<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

const { getSession } = useAuth();
const faculties = ref([]), faculty = ref(null), rounds = ref([]), round = ref(null), people = ref([]);
const facultySuggestions = ref([]);
function searchFaculty({ query }) {
    const term = String(query || '').trim().toLowerCase();
    facultySuggestions.value = faculties.value.filter(item => `${item.name} ${item.id}`.toLowerCase().includes(term));
}
const superadmin = ref(false), loading = ref(true), loadingRounds = ref(false), loadingPeople = ref(false), downloading = ref(false);
const search = ref(''), error = ref('');
const busy = computed(() => loading.value || loadingRounds.value || loadingPeople.value);
const readyCount = computed(() => people.value.filter(p => p.ready).length);
const visiblePeople = computed(() => people.value
    .filter(p => `${p.name} ${p.staffid}`.toLowerCase().includes(search.value.trim().toLowerCase()))
    .sort((a, b) => Number(!!b.ready) - Number(!!a.ready)
        || String(a.name || '').localeCompare(String(b.name || ''), 'th')
        || String(a.staffid).localeCompare(String(b.staffid), 'en', { numeric: true })));
let roundRequest = 0, peopleRequest = 0;
const api = 'http://127.0.0.1:8000/api/hr/p04';
async function post(path, body = {}, binary = false) {
    const session = await getSession();
    if (!session?.providerInfo?.access_token) throw new Error('กรุณาเข้าสู่ระบบใหม่');
    return axios.post(`${api}/${path}`, body, { headers: { Authorization: `Bearer ${session.providerInfo.access_token}`, Accept: binary ? '*/*' : 'application/json' }, ...(binary ? { responseType: 'blob' } : {}) });
}
const message = e => e.response?.data?.message || e.message || 'ไม่สามารถโหลดข้อมูลได้ กรุณาลองใหม่';
async function init() {
    loading.value = true; error.value = '';
    try {
        const { data } = await post('context');
        superadmin.value = data.superadmin;
        faculties.value = (data.faculties || []).map(p => ({
            id: String(p.fac_id ?? p.facultyID ?? p.FACULTYID ?? p.faculty_id ?? p.id ?? ''),
            name: String(p.facuties ?? p.fac_name ?? p.FACULTYNAME ?? p.facultyName ?? p.faculty_name ?? p.name ?? '').trim()
        })).filter(p => p.id && p.name && (superadmin.value || p.id === String(data.fac_id)));
        if (!superadmin.value && !data.fac_id) throw new Error('ไม่พบหน่วยงานที่ได้รับสิทธิ์ กรุณาติดต่อผู้ดูแลระบบ');
        if (!superadmin.value && !faculties.value.length) faculties.value = [{ id: String(data.fac_id), name: `หน่วยงาน ${data.fac_id}` }];
        faculty.value = faculties.value.find(p => p.id === String(data.fac_id)) || null;
    } catch (e) { error.value = message(e); }
    finally { loading.value = false; }
}
watch(() => faculty.value?.id, async id => {
    const request = ++roundRequest; ++peopleRequest;
    round.value = null; rounds.value = []; people.value = []; loadingPeople.value = false; error.value = ''; search.value = '';
    loadingRounds.value = !!id;
    if (!id) return;
    try {
        const { data } = await post('rounds', { fac_id: id });
        if (request === roundRequest) rounds.value = data.map(p => ({ ...p, label: `ปี ${p.d_date} · ${p.d_evaluationround || `รอบที่ ${p.evalua}`}` }));
    } catch (e) { if (request === roundRequest) error.value = message(e); }
    finally { if (request === roundRequest) loadingRounds.value = false; }
});
async function loadPeople() {
    const request = ++peopleRequest;
    people.value = []; error.value = ''; loadingPeople.value = !!round.value;
    if (!round.value || !faculty.value) return;
    try {
        const { data } = await post('list', { fac_id: faculty.value.id, round_id: round.value.id });
        if (request === peopleRequest) people.value = data;
    } catch (e) { if (request === peopleRequest) error.value = message(e); }
    finally { if (request === peopleRequest) loadingPeople.value = false; }
}
watch(round, loadPeople);
onMounted(init);
async function download(person, format) {
    if (downloading.value || busy.value || !person.ready || !round.value) return;
    const preview = format === 'pdf' ? window.open('', '_blank') : null;
    if (format === 'pdf' && !preview) {
        await Swal.fire('เปิดหน้าต่างไม่ได้', 'กรุณาอนุญาต Pop-up สำหรับเว็บไซต์นี้ แล้วลองเปิด PDF อีกครั้ง', 'info');
        return;
    }
    if (preview) { preview.opener = null; preview.document.title = 'กำลังเตรียม PDF ป.04'; preview.document.body.textContent = 'กำลังสร้างเอกสาร กรุณารอสักครู่…'; }
    downloading.value = true;
    Swal.fire({ title: `กำลังสร้าง ${format === 'word' ? 'Word' : 'PDF'} ป.04`, allowOutsideClick: false, allowEscapeKey: false, didOpen: () => Swal.showLoading() });
    try {
        const { data } = await post('download', { fac_id: faculty.value.id, round_id: round.value.id, target_staffid: person.staffid, document_format: format }, true);
        if (format === 'pdf') {
            const url = URL.createObjectURL(new Blob([data], { type: 'application/pdf' }));
            if (preview.closed) { URL.revokeObjectURL(url); Swal.close(); return; }
            preview.document.title = `ป.04 - ${person.name}`;
            preview.document.body.textContent = '';
            preview.document.body.style.margin = '0';
            const frame = preview.document.createElement('iframe');
            frame.title = 'ตัวอย่าง PDF ป.04'; frame.src = url;
            frame.style.cssText = 'width:100%;height:100vh;border:0;display:block';
            preview.document.body.appendChild(frame);
            const timer = window.setInterval(() => {
                if (preview.closed) { window.clearInterval(timer); URL.revokeObjectURL(url); }
            }, 1000);
            Swal.close();
            return;
        }
        const url = URL.createObjectURL(data), link = document.createElement('a');
        link.href = url; link.download = `ป04_${person.staffid}_${round.value.d_date}_${round.value.evalua}.${format === 'word' ? 'doc' : 'pdf'}`;
        document.body.appendChild(link); link.click(); link.remove(); setTimeout(() => URL.revokeObjectURL(url), 10000);
        Swal.close();
    } catch (e) {
        if (preview && !preview.closed) preview.close();
        let detail = message(e);
        if (e.response?.data instanceof Blob) { try { detail = JSON.parse(await e.response.data.text()).message || detail; } catch (_) {} }
        await Swal.fire('ส่งออกไม่สำเร็จ', detail, 'error');
    } finally { downloading.value = false; }
}
</script>

<template>
    <div class="p04-page">
        <header class="page-hero"><div class="hero-icon"><i class="pi pi-file" /></div><div><span class="eyebrow">เจ้าหน้าที่บุคคล / ศูนย์เอกสาร</span><h2>Export แบบ ป.04</h2><p>แบบสรุปผลการประเมินรายบุคคล · ดูตัวอย่าง PDF หรือดาวน์โหลด Word</p></div><span class="access-pill"><i :class="superadmin ? 'pi pi-globe' : 'pi pi-lock'" /> {{ superadmin ? 'ทุกหน่วยงาน' : 'เฉพาะหน่วยงานของคุณ' }}</span></header>
        <div class="summary-grid" aria-label="สรุปสถานะเอกสาร">
            <div class="summary-item"><span class="summary-icon"><i class="pi pi-users" /></span><div><span>บุคลากรทั้งหมด</span><strong>{{ busy ? '—' : people.length }} <small>คน</small></strong></div></div>
            <div class="summary-item"><span class="summary-icon success"><i class="pi pi-check-circle" /></span><div><span>พร้อมส่งออก</span><strong>{{ busy ? '—' : readyCount }} <small>คน</small></strong></div></div>
            <div class="summary-item"><span class="summary-icon waiting"><i class="pi pi-clock" /></span><div><span>รอผลคะแนน</span><strong>{{ busy ? '—' : people.length - readyCount }} <small>คน</small></strong></div></div>
        </div>
        <section class="card">
            <div class="panel-heading"><i class="pi pi-filter" /><strong>เลือกรอบและหน่วยงาน</strong><span>เลือกข้อมูลที่ต้องการส่งออก</span></div>
            <div class="grid">
                <div class="col-12 md:col-6"><label for="p04-faculty" class="block font-semibold mb-2">คณะ / หน่วยงาน</label><AutoComplete v-model="faculty" inputId="p04-faculty" :suggestions="facultySuggestions" optionLabel="name" dropdown forceSelection class="w-full" inputClass="w-full" placeholder="พิมพ์ชื่อหรือเลือกคณะ / หน่วยงาน" :disabled="!superadmin || loading || downloading" @complete="searchFaculty" /><small v-if="!superadmin" class="block text-500 mt-2">แสดงเฉพาะหน่วยงานที่คุณได้รับสิทธิ์</small></div>
                <div class="col-12 md:col-6"><label for="p04-round" class="block font-semibold mb-2">รอบประเมิน</label><Dropdown v-model="round" inputId="p04-round" :options="rounds" optionLabel="label" class="w-full" placeholder="เลือกรอบประเมิน" :loading="loadingRounds" :disabled="!faculty || loading || loadingRounds || downloading" emptyMessage="ไม่พบรอบประเมิน" /></div>
            </div>
            <div v-if="error" class="surface-100 border-round p-3 text-red-600 mt-3" role="alert">{{ error }} <Button label="ลองใหม่" text @click="round ? loadPeople() : init()" /></div>
        </section>
        <section class="card" :aria-busy="busy">
            <div class="list-toolbar"><div><h4>รายชื่อบุคลากร <span class="count-pill">{{ busy ? '…' : visiblePeople.length }}</span></h4><p>{{ round?.label || 'เลือกรอบประเมินเพื่อแสดงรายชื่อ' }}</p></div><div class="search-tools"><span class="p-input-icon-left"><i class="pi pi-search" /><InputText v-model="search" placeholder="ค้นหาชื่อ / รหัสบุคลากร" aria-label="ค้นหาบุคลากร" /></span><Button icon="pi pi-refresh" outlined rounded aria-label="โหลดรายชื่อใหม่" :disabled="!round || busy || downloading" @click="loadPeople" /></div></div>
            <div v-if="busy" class="text-center p-6" role="status"><i class="pi pi-spin pi-spinner text-3xl text-primary" /><p>กำลังโหลดข้อมูล กรุณารอสักครู่…</p></div>
            <DataTable v-else :value="visiblePeople" dataKey="staffid" paginator :rows="100" :rowsPerPageOptions="[20,50,100]" :alwaysShowPaginator="false" responsiveLayout="scroll">
                <template #empty><div class="text-center p-5 text-500">{{ round ? 'ไม่พบรายชื่อบุคลากร' : 'กรุณาเลือกคณะ / หน่วยงาน และรอบประเมิน' }}</div></template>
                <Column field="name" header="บุคลากร"><template #body="{ data }"><div class="person-cell"><span class="person-avatar"><i class="pi pi-user" /></span><div class="person-label"><strong>{{ data.name || '-' }}</strong><small>(รหัส {{ data.staffid }})</small></div></div></template></Column>
                <Column header="สถานะ"><template #body="{ data }"><Tag :severity="data.ready ? 'success' : 'warning'" :value="data.ready ? 'พร้อมส่งออก' : 'รอผลคะแนน'" /><small v-if="!data.ready && data.readiness_reason" class="readiness-reason">{{ data.readiness_reason }}</small></template></Column>
                <Column header="แบบ ป.04"><template #body="{ data }"><ExportFormatPicker v-if="data.ready && !downloading" @word="download(data, 'word')" @pdf="download(data, 'pdf')" /><Button v-else :class="{ 'waiting-score-button': !data.ready }" :label="data.ready ? 'กำลังส่งออก' : 'รอผลคะแนน'" :icon="data.ready ? 'pi pi-spin pi-spinner' : 'pi pi-clock'" disabled outlined /></template></Column>
            </DataTable>
            <p class="text-500 text-sm mt-3 mb-0">พร้อมส่งออกเมื่อมีคะแนนสรุปผลสัมฤทธิ์และพฤติกรรมใน ป.04 ครบ โดยไม่บังคับรหัสผู้ประเมินของแต่ละงาน</p>
        </section>
    </div>
</template>

<style scoped>
.readiness-reason { display: block; max-width: 23rem; margin-top: .4rem; color: var(--text-color-secondary); line-height: 1.5; white-space: normal; }
.p04-page { max-width: 1440px; margin: auto; }
.page-hero { display: flex; align-items: center; gap: 1.25rem; margin-bottom: 1.75rem; }
.hero-icon { flex-shrink: 0; width: 4rem; height: 4rem; display: grid; place-items: center; border-radius: 1.2rem; background: #eaf2ff; color: #2563eb; font-size: 1.7rem; }
.eyebrow { color: var(--text-color-secondary); font-size: .8rem; }
.page-hero h2 { margin: .4rem 0; font-size: 1.9rem; font-weight: 700; }
.page-hero p { margin: 0; color: var(--text-color-secondary); line-height: 1.7; }
.access-pill { margin-left: auto; white-space: nowrap; border: 1px solid var(--surface-border); border-radius: 2rem; padding: .65rem 1rem; color: var(--text-color-secondary); font-size: .85rem; }
.access-pill i { margin-right: .4rem; }
.summary-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
.summary-item { display: flex; align-items: center; gap: 1rem; padding: 1.4rem; background: var(--surface-card); border: 1px solid var(--surface-border); border-radius: 1rem; }
.summary-item div > span { color: var(--text-color-secondary); font-size: .9rem; }
.summary-item strong { display: block; font-size: 1.9rem; margin-top: .3rem; }
.summary-item small { font-size: .85rem; font-weight: 400; color: var(--text-color-secondary); }
.summary-icon { display: grid; place-items: center; width: 3rem; height: 3rem; border-radius: .9rem; background: #eff6ff; color: #2563eb; font-size: 1.3rem; }
.summary-icon.success { background: #ecfdf5; color: #047857; }
.summary-icon.waiting { background: #fffbeb; color: #b45309; }
.card { border: 1px solid var(--surface-border); border-radius: 1rem; padding: 1.5rem; box-shadow: 0 3px 18px rgb(0 0 0 / 3%); }
.panel-heading { display: flex; align-items: center; gap: .6rem; margin-bottom: 1.5rem; }
.panel-heading i { color: var(--primary-color); }
.panel-heading span { margin-left: auto; font-size: .85rem; color: var(--text-color-secondary); }
.list-toolbar { display: flex; justify-content: space-between; align-items: center; gap: 1rem; margin-bottom: 1.5rem; }
.list-toolbar h4 { margin: 0 0 .5rem; font-weight: 700; }
.list-toolbar p { margin: 0; color: var(--text-color-secondary); font-size: .85rem; }
.count-pill { padding: .2rem .65rem; margin-left: .5rem; border-radius: 1rem; background: var(--surface-100); font-size: .85rem; }
.search-tools { display: flex; gap: .6rem; flex-shrink: 0; }
.person-cell { display: flex; align-items: center; gap: .8rem; }
.person-avatar { display: grid; place-items: center; flex-shrink: 0; width: 2.6rem; height: 2.6rem; border-radius: 50%; background: var(--surface-100); color: var(--text-color-secondary); }
.person-cell strong { font-weight: 600; }
.person-label { display: flex; align-items: baseline; gap: .5rem; white-space: nowrap; }
.person-cell small { color: var(--text-color-secondary); }
:deep(.p-datatable-thead > tr > th) { background: var(--surface-50); padding: 1rem; color: var(--text-color-secondary); }
:deep(.p-datatable-thead .p-column-header-content) { justify-content: flex-start; text-align: left; }
:deep(.p-datatable-thead > tr > th:first-child .p-column-header-content) { padding-left: 3.4rem; }
:deep(.p-datatable-tbody > tr > td) { padding: .75rem 1rem; }
:deep(.p-button-label), :deep(.p-tag) { white-space: nowrap; }
:deep(.waiting-score-button.p-button:disabled) { background: #f8ecee; border-color: #b77b83; color: #793541; opacity: 1; cursor: not-allowed; }
@media (max-width: 767px) {
    .page-hero { flex-wrap: wrap; }
    .access-pill { margin-left: 0; }
    .summary-grid { grid-template-columns: 1fr; }
    .summary-item { padding: 1rem; }
    .list-toolbar { flex-direction: column; align-items: stretch; }
    .search-tools > span, .search-tools input { width: 100%; }
    .panel-heading { flex-wrap: wrap; }
    .panel-heading span { margin-left: 0; }
    :deep(.p-datatable-table) { min-width: 38rem; }
}
</style>
