<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

definePageMeta({ middleware: ['superadmin'] });
const { getSession } = useAuth();
const session = await getSession();
const api = 'http://127.0.0.1:8000/api';
const faculties = ref([]);
const suggestions = ref([]);
const faculty = ref(null);
const rounds = ref([]);
const round = ref(null);
const rows = ref([]);
const loading = ref(false);
const loadingRounds = ref(false);
const loadingFaculties = ref(false);
const saving = ref(false);
const editing = ref(null);
const details = ref(null);
const search = ref('');
const filteredRows = computed(() => rows.value.filter((row) => `${row.p_staffname || ''} ${row.p_staffid || ''}`.toLowerCase().includes(search.value.trim().toLowerCase())));
watch([faculty, round], () => { details.value = null; search.value = ''; });
const ratio = ref(null);
const assessor = ref(null);
const assessorPosition = ref('');
const staffSuggestions = ref([]);
const staffError = ref('');
let staffRequest = 0;
const period = computed(() => round.value?.periods?.[ratio.value] || '');
const assessorName = computed(() => typeof assessor.value === 'object' ? assessor.value?.displayName?.trim() || '' : '');
const canSave = computed(() => !!ratio.value && !!assessorName.value && !!assessorPosition.value.trim());

async function searchStaff({ query }) {
    const request = ++staffRequest;
    staffError.value = '';
    staffSuggestions.value = [];
    if (!query || query.trim().length < 2) return;
    try {
        const { data } = await axios.get(`${api}/searchDataStaff`, { params: { staffid: query.trim() } });
        if (request !== staffRequest) return;
        staffSuggestions.value = (data || []).map((item) => ({ ...item, displayName: `${item.prefixfullname || item.PREFIXFULLNAME || ''}${item.namefully || ''}`.trim() }));
    } catch (error) { if (request === staffRequest) staffError.value = 'ค้นหาผู้ประเมินไม่สำเร็จ กรุณาลองใหม่'; }
}
const ratios = ['50:50', '70:30'];
let facultyRequest = 0;
let rowRequest = 0;

const post = (path, data) => axios.post(`${api}/superadmin/tor-ratios/${path}`, data, {
    headers: { Authorization: `Bearer ${session?.providerInfo?.access_token || ''}`, Accept: 'application/json' }
});
const errorMessage = (error) => error.response?.data?.message || 'ไม่สามารถเชื่อมต่อระบบได้ กรุณาลองใหม่';
const showError = (error) => Swal.fire('ไม่สำเร็จ', errorMessage(error), 'error');
const searchFaculty = ({ query }) => {
    suggestions.value = faculties.value.filter((item) => `${item.name} ${item.id}`.toLowerCase().includes(query.toLowerCase()));
};

onMounted(async () => {
    loadingFaculties.value = true;
    try {
        const response = await axios.get(`${api}/searchDataFaculty`, {
            params: { access_token: session?.providerInfo?.access_token, staff_id: session?.user?.name?.STAFFID }
        });
        const data = Array.isArray(response.data) ? response.data : response.data?.data || [];
        faculties.value = data.map((item) => ({
            id: String(item.fac_id ?? item.facultyID ?? item.FACULTYID ?? item.faculty_id ?? item.id ?? ''),
            name: String(item.facuties ?? item.fac_name ?? item.FACULTYNAME ?? item.facultyName ?? item.faculty_name ?? item.name ?? '').trim()
        })).filter((item) => item.id && item.name);
        faculty.value = faculties.value.find((item) => item.id === String(session?.user?.name?.SCOPES?.staffdepartment)) || null;
    } catch (error) { showError(error); }
    finally { loadingFaculties.value = false; }
});

watch(() => faculty.value?.id, async (facId) => {
    const request = ++facultyRequest;
    ++rowRequest;
    round.value = null;
    rounds.value = [];
    rows.value = [];
    editing.value = null;
    loading.value = false;
    loadingRounds.value = !!facId;
    if (!facId) return;
    try {
        const { data } = await post('rounds', { fac_id: facId });
        if (request !== facultyRequest) return;
        rounds.value = data.map((item) => ({ ...item, label: `ปี ${item.d_date} · ${item.d_evaluationround || `รอบที่ ${item.evalua}`}` }));
    } catch (error) { if (request === facultyRequest) showError(error); }
    finally { if (request === facultyRequest) loadingRounds.value = false; }
});

async function loadRows() {
    const request = ++rowRequest;
    rows.value = [];
    if (!faculty.value?.id || !round.value?.id) { loading.value = false; return; }
    loading.value = true;
    try {
        const { data } = await post('list', { fac_id: faculty.value.id, round_id: round.value.id });
        if (request === rowRequest) rows.value = data;
    } catch (error) { if (request === rowRequest) showError(error); }
    finally { if (request === rowRequest) loading.value = false; }
}
watch(round, () => { editing.value = null; loadRows(); });

function edit(row) {
    details.value = null;
    ++staffRequest;
    staffSuggestions.value = [];
    staffError.value = '';
    assessor.value = row.assessor ? { displayName: row.assessor } : null;
    assessorPosition.value = row.assessor_position || '';
    editing.value = { ...row, fac_id: faculty.value.id, round_id: round.value.id };
    ratio.value = ratios.includes(row.persen) ? row.persen : null;
}

async function save() {
    if (saving.value || !editing.value || !ratios.includes(ratio.value) || !canSave.value) return;
    saving.value = true;
    try {
        const result = await Swal.fire({ title: 'ยืนยันการแก้ไขข้อมูล?', text: `${editing.value.p_staffname || editing.value.p_staffid}: สัดส่วน ${ratio.value} · ${period.value} · ผู้ประเมิน ${assessorName.value} (${assessorPosition.value.trim()})`, icon: 'question', showCancelButton: true, confirmButtonText: 'บันทึก', cancelButtonText: 'ยกเลิก' });
        if (!result.isConfirmed) return;
        await post('update', {
            fac_id: editing.value.fac_id, round_id: editing.value.round_id, p01_id: editing.value.p01_id,
            original_persen: editing.value.persen, persen: ratio.value,
            original_assessor: editing.value.assessor, original_assessor_position: editing.value.assessor_position,
            original_record_evalua: editing.value.record_evalua,
            assessor: assessorName.value, assessor_position: assessorPosition.value.trim()
        });
        editing.value = null;
        await loadRows();
        await Swal.fire('สำเร็จ', 'บันทึกสัดส่วน ช่วงประเมิน และข้อมูลผู้ประเมินเรียบร้อยแล้ว', 'success');
    } catch (error) {
        await showError(error);
        if (error.response?.status === 409) { editing.value = null; await loadRows(); }
    } finally { saving.value = false; }
}
</script>

<template>
    <div class="ratio-page">
        <header class="page-heading">
            <div class="heading-icon"><i class="pi pi-sliders-h"></i></div>
            <div><span class="eyebrow">SUPERADMIN / ข้อตกลงการปฏิบัติงาน</span><h2>จัดการสัดส่วน</h2><p>ตรวจสอบและปรับปรุงสัดส่วน พร้อมข้อมูลผู้ประเมินของแต่ละหน่วยงาน</p></div>
        </header>
        <section class="filter-panel">
        <div class="section-heading"><i class="pi pi-filter"></i><strong>เลือกข้อมูลที่ต้องการจัดการ</strong><span>เลือกหน่วยงาน แล้วเลือกรอบประเมิน</span></div>
        <div class="grid mt-3">
            <div class="col-12 md:col-6">
                <label for="ratio-faculty" class="block font-bold mb-2">คณะ / หน่วยงาน</label>
                <AutoComplete v-model="faculty" inputId="ratio-faculty" :suggestions="suggestions" optionLabel="name" dropdown forceSelection class="w-full" inputClass="w-full" placeholder="เลือกคณะ / หน่วยงาน" :disabled="loadingFaculties || saving" @complete="searchFaculty" />
            </div>
            <div class="col-12 md:col-6">
                <label for="ratio-round" class="block font-bold mb-2">รอบประเมิน</label>
                <Dropdown v-model="round" inputId="ratio-round" :options="rounds" optionLabel="label" class="w-full" placeholder="เลือกรอบประเมิน" :loading="loadingRounds" :disabled="!faculty?.id || loadingRounds || saving" emptyMessage="ไม่พบรอบประเมินของหน่วยงานนี้" />
            </div>
        </div>
        </section>
        <section class="list-panel">
        <div class="list-toolbar">
            <div><div class="list-title">รายชื่อบุคลากร <span class="count-pill">{{ rows.length }}</span></div><p class="list-caption">{{ round?.label || 'รายการ TOR จะแสดงเมื่อเลือกรอบประเมิน' }}</p></div>
            <div class="toolbar-actions">
                <span class="p-input-icon-left"><i class="pi pi-search"></i><InputText v-model="search" aria-label="ค้นหาชื่อหรือรหัสบุคลากร" placeholder="ค้นหาชื่อหรือรหัสบุคลากร" :disabled="!round" /></span>
                <Button icon="pi pi-refresh" outlined rounded aria-label="โหลดข้อมูลใหม่" title="โหลดข้อมูลใหม่" :disabled="!round || loading || saving" @click="loadRows" />
            </div>
        </div>
        <DataTable :value="filteredRows" dataKey="p01_id" :loading="loading" paginator :rows="20" :rowsPerPageOptions="[20, 50, 100]" :alwaysShowPaginator="false" responsiveLayout="scroll" class="people-table">
            <template #empty><div class="empty-state"><i class="pi pi-folder-open"></i><strong>{{ search ? 'ไม่พบรายชื่อที่ค้นหา' : 'ยังไม่มีรายการแสดง' }}</strong><span>{{ search ? 'ลองค้นหาด้วยชื่อหรือรหัสบุคลากรอื่น' : round ? 'ไม่พบรายการ TOR ที่บันทึกไว้ในคณะและรอบประเมินนี้' : 'กรุณาเลือกคณะ / หน่วยงาน และรอบประเมินด้านบน' }}</span></div></template>
            <Column field="p_staffname" header="บุคลากร" sortable><template #body="{ data }"><div class="person-cell"><span class="person-icon"><i class="pi pi-user"></i></span><div class="person-label"><strong>{{ data.p_staffname || '-' }}</strong><small>(รหัส {{ data.p_staffid }})</small></div></div></template></Column>
            <Column field="persen" header="สัดส่วน" style="width: 18%"><template #body="{ data }"><span class="ratio-badge" :class="{ 'ratio-balanced': data.persen === '50:50' }">{{ data.persen || '-' }}</span></template></Column>
            <Column header="การจัดการ" style="width: 18rem; min-width: 18rem"><template #body="{ data }"><div class="row-actions"><Button label="รายละเอียด" icon="pi pi-eye" outlined class="details-button" :disabled="saving" @click="details = { ...data }" /><Button icon="pi pi-pencil" outlined rounded aria-label="แก้ไขสัดส่วนและผู้ประเมิน" title="แก้ไขข้อมูล" :disabled="saving" @click="edit(data)" /></div></template></Column>
        </DataTable>
        </section>
        <Dialog :visible="!!details" header="รายละเอียดข้อตกลง" modal :draggable="false" :style="{ width: '64rem', maxWidth: '95vw' }" @update:visible="(value) => { if (!value) details = null; }">
            <div class="surface-100 border-round p-3 mb-4"><strong class="text-xl">{{ details?.p_staffname || '-' }}</strong><div class="text-600 mt-2">รหัสบุคลากร {{ details?.p_staffid }}</div></div>
            <dl class="detail-grid">
                <div><dt>คณะ / หน่วยงาน</dt><dd>{{ faculty?.name || '-' }}</dd></div>
                <div><dt>สัดส่วน</dt><dd><span class="ratio-badge">{{ details?.persen || '-' }}</span></dd></div>
                <div class="detail-wide"><dt>รอบประเมิน</dt><dd>{{ round?.label || '-' }}</dd></div>
                <div class="detail-wide"><dt>รายละเอียดข้อตกลง ระหว่างวันที่</dt><dd>{{ details?.record_evalua || '-' }}</dd></div>
                <div><dt>ชื่อผู้ประเมิน</dt><dd>{{ details?.assessor || '-' }}</dd></div>
                <div><dt>ตำแหน่งผู้ประเมิน</dt><dd>{{ details?.assessor_position || '-' }}</dd></div>
            </dl>
            <template #footer><Button label="ปิด" text @click="details = null" /></template>
        </Dialog>
        <Dialog :visible="!!editing" header="แก้ไขสัดส่วนและผู้ประเมิน" modal :closable="!saving" :draggable="false" :style="{ width: '64rem', maxWidth: '95vw' }" @update:visible="(value) => { if (!value && !saving) editing = null; }">
            <div class="surface-100 border-round p-3 mb-4"><strong class="text-xl">{{ editing?.p_staffname || editing?.p_staffid }}</strong><p class="text-600 mb-0">{{ round?.label }}</p></div>
            <label for="new-ratio" class="block mb-2">สัดส่วนผลสัมฤทธิ์ของงาน : พฤติกรรมการปฏิบัติราชการ</label>
            <Dropdown v-model="ratio" inputId="new-ratio" :options="ratios" placeholder="เลือกสัดส่วน" class="w-full" :disabled="saving" />
            <div class="surface-100 border-round p-3 my-3"><strong>รายละเอียดข้อตกลง ระหว่าง วันที่ :</strong> {{ period || '-' }}</div>
            <label for="ratio-assessor" class="block mb-2">ชื่อผู้ประเมิน</label>
            <AutoComplete v-model="assessor" inputId="ratio-assessor" :suggestions="staffSuggestions" optionLabel="displayName" forceSelection dropdown class="w-full" inputClass="w-full" placeholder="พิมพ์ชื่ออย่างน้อย 2 ตัวอักษร" :disabled="saving" @complete="searchStaff" />
            <small v-if="staffError" class="text-red-500">{{ staffError }}</small>
            <label for="ratio-assessor-position" class="block mt-3 mb-2">ตำแหน่งผู้ประเมิน</label>
            <InputText v-model="assessorPosition" id="ratio-assessor-position" class="w-full" maxlength="100" :disabled="saving" />
            <template #footer>
                <Button label="ยกเลิก" text :disabled="saving" @click="editing = null" />
                <Button label="บันทึก" icon="pi pi-save" :loading="saving" :disabled="!canSave" @click="save" />
            </template>
        </Dialog>
    </div>
</template>

<style scoped>
.ratio-page { --panel-border: var(--surface-border, #e2e8f0); }
.page-heading { display: flex; align-items: center; gap: 1.2rem; margin-bottom: 1.8rem; }
.heading-icon { width: 3.8rem; height: 3.8rem; display: grid; place-items: center; border-radius: 1rem; background: var(--primary-50, #ecfdf5); color: var(--primary-color); flex-shrink: 0; }
.heading-icon i { font-size: 1.5rem; }
.eyebrow { color: var(--text-color-secondary); font-size: .75rem; letter-spacing: .06em; }
.page-heading h2 { font-size: 1.8rem; font-weight: 700; margin: .4rem 0; }
.page-heading p, .list-caption { color: var(--text-color-secondary); margin: 0; line-height: 1.6; }
.filter-panel, .list-panel { background: var(--surface-card); border: 1px solid var(--panel-border); border-radius: 1rem; box-shadow: 0 3px 16px rgb(0 0 0 / 3%); }
.filter-panel { padding: 1.5rem; margin-bottom: 1.5rem; }
.section-heading { display: flex; align-items: center; gap: .7rem; flex-wrap: wrap; }
.section-heading i { color: var(--primary-color); }
.section-heading span { color: var(--text-color-secondary); font-size: .85rem; margin-left: auto; }
.list-panel { overflow: hidden; }
.list-toolbar { display: flex; align-items: center; justify-content: space-between; gap: 1.5rem; padding: 1.5rem; }
.list-title { display: flex; align-items: center; gap: .7rem; font-size: 1.15rem; font-weight: 700; margin-bottom: .4rem; }
.count-pill { font-size: .8rem; padding: .2rem .65rem; border-radius: 2rem; background: var(--surface-100); color: var(--text-color-secondary); }
.list-caption { font-size: .85rem; }
.toolbar-actions, .row-actions { display: flex; align-items: center; gap: .6rem; }
.toolbar-actions { flex-shrink: 0; }
.person-cell { display: flex; align-items: center; gap: .8rem; }
.person-icon { width: 2.6rem; height: 2.6rem; border-radius: 50%; display: grid; place-items: center; background: var(--surface-100); color: var(--text-color-secondary); flex-shrink: 0; }
.person-cell strong { font-weight: 600; line-height: 1.6; }
.person-label { display: flex; align-items: baseline; gap: .6rem; white-space: nowrap; }
.person-cell small { color: var(--text-color-secondary); }
.row-actions { flex-wrap: nowrap; }
.row-actions :deep(.p-button) { flex-shrink: 0; white-space: nowrap; }
.details-button :deep(.p-button-label) { white-space: nowrap; }
.ratio-badge { display: inline-block; padding: .4rem .85rem; border-radius: .5rem; background: #eff6ff; color: #1d4ed8; font-weight: 700; white-space: nowrap; }
.ratio-balanced { background: #ecfdf5; color: #047857; }
.people-table :deep(.p-datatable-thead > tr > th) { background: var(--surface-50); color: var(--text-color-secondary); padding: 1rem 1.5rem; font-weight: 600; }
.people-table :deep(.p-datatable-tbody > tr > td) { padding: 1.15rem 1.5rem; border-color: var(--panel-border); }
.people-table :deep(.p-datatable-tbody > tr:hover) { background: var(--surface-50); }
.empty-state { display: flex; flex-direction: column; align-items: center; gap: .85rem; padding: 3rem 1rem; text-align: center; color: var(--text-color-secondary); }
.empty-state i { font-size: 2.2rem; color: var(--primary-color); }
.detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.4rem; margin: 0; }
.detail-grid dt { color: var(--text-color-secondary); font-size: .85rem; margin-bottom: .5rem; }
.detail-grid dd { margin: 0; line-height: 1.7; overflow-wrap: anywhere; }
.detail-wide { grid-column: 1 / -1; }
@media (max-width: 767px) {
    .page-heading { align-items: flex-start; }
    .page-heading h2 { font-size: 1.5rem; }
    .section-heading span { width: 100%; margin: 0; }
    .list-toolbar { align-items: stretch; flex-direction: column; }
    .toolbar-actions > span, .toolbar-actions input { width: 100%; }
    .people-table :deep(table) { min-width: 38rem; }
    .detail-grid { grid-template-columns: 1fr; }
}
</style>
