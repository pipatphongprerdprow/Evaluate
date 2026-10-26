<script setup>
import { ref, computed, onMounted, onBeforeUnmount, watch } from 'vue';
import axios from 'axios';
definePageMeta({ middleware: ['superadmin'] });
const { getSession } = useAuth();
const periods = ref([]), faculties = ref([]), rows = ref([]), year = ref(null), round = ref(null);
const busy = ref(false), initializing = ref(true), error = ref('');
const details = ref(null), personSearch = ref('');
const memberGroups = computed(() => [
    { key: 'done', label: 'กรอกแล้ว', members: details.value?.members || [] },
    { key: 'pending', label: details.value?.form === 'p04' ? 'ยังไม่มีคะแนนสรุปพร้อมส่งออก' : 'ยังไม่กรอก', members: details.value?.pending || [] }
].map(group => ({ ...group, filtered: group.members.filter(p => `${p.name} ${p.staffid} ${p.faculty || ''}`.toLowerCase().includes(personSearch.value.trim().toLowerCase())) })));
function openMembers(row, col) {
    const sources = row ? [row] : rows.value.filter(r => !['loading', 'error'].includes(r.status));
    const members = [], pending = [];
    sources.forEach(r => {
        const completed = r.members?.[col.key] || [];
        const ids = new Set(completed.map(p => String(p.staffid)));
        const decorate = p => row ? p : { ...p, faculty: r.name };
        members.push(...completed.map(decorate));
        pending.push(...(r.roster || []).filter(p => !ids.has(String(p.staffid))).map(decorate));
    });
    details.value = { title: `รายชื่อบุคลากร ${col.label}`, form: col.key, allFaculties: !row, faculty: row?.name || 'ทุกหน่วยงาน (รายการที่โหลดสำเร็จ)', year: year.value, round: round.value, members, pending };
    personSearch.value = '';
}
let generation = 0, controller;
const columns = [{ key: 'people', label: 'บุคลากรทั้งหมด', icon: 'pi-users' }, { key: 'p01', label: 'แบบ ป.01', icon: 'pi-file' }, { key: 'p02', label: 'แบบ ป.02', icon: 'pi-file' }, { key: 'p03', label: 'แบบ ป.03', icon: 'pi-file-edit' }, { key: 'p04', label: 'แบบ ป.04', icon: 'pi-check-square' }];
const years = computed(() => [...new Set(periods.value.map(p => Number(p.d_date)))].sort((a,b) => b-a));
const rounds = computed(() => [...new Set(periods.value.filter(p => Number(p.d_date) === year.value).map(p => Number(p.evalua)))].filter(n => [1,2].includes(n)).sort().map(value => ({ label: `รอบที่ ${value}`, value })));
const totals = computed(() => Object.fromEntries(columns.map(c => [c.key, rows.value.reduce((sum,r) => sum + (r.status !== 'loading' && r.status !== 'error' ? Number(r[c.key] || 0) : 0), 0)])));
const loaded = computed(() => rows.value.filter(r => !['loading','error'].includes(r.status)).length);
const canExport = computed(() => !initializing.value && !busy.value && rows.value.length > 0 && loaded.value === rows.value.length);
const labels = { loading: 'กำลังโหลด', error: 'โหลดข้อมูลไม่สำเร็จ', empty: 'ไม่มีบุคลากร', none: 'ยังไม่บันทึกทุกแบบ', partial: 'บันทึกบางส่วน', complete: 'บันทึกครบทุกคนทุกแบบ' };
async function api(path, data = {}, signal) {
    const session = await getSession();
    return axios.post(`http://127.0.0.1:8000/api/superadmin/form-progress/${path}`, data, { signal, headers: { Authorization: `Bearer ${session?.providerInfo?.access_token || ''}`, Accept: 'application/json' } });
}
async function init() {
    initializing.value = true; error.value = '';
    try {
        const { data } = await api('context');
        periods.value = data.periods || [];
        const mapped = (data.faculties || []).map(p => ({ id: String(p.fac_id ?? p.facultyID ?? p.FACULTYID ?? p.faculty_id ?? p.id ?? ''), name: String(p.facuties ?? p.fac_name ?? p.FACULTYNAME ?? p.facultyName ?? p.faculty_name ?? p.name ?? '').trim() })).filter(p => p.id && p.name);
        faculties.value = [...new Map(mapped.map(p => [p.id, p])).values()];
        year.value = years.value[0] ?? null;
    } catch (e) { error.value = 'โหลดข้อมูลตั้งต้นไม่สำเร็จ กรุณาลองใหม่หรือติดต่อผู้ดูแลระบบ'; }
    finally { initializing.value = false; }
}
watch(year, () => { round.value = rounds.value[0]?.value ?? null; });
watch([year, round], () => { if (year.value && round.value) load(); });
async function load() {
    details.value = null;
    if (!year.value || !round.value) return;
    const current = ++generation;
    controller?.abort(); controller = new AbortController();
    const signal = controller.signal, selectedYear = year.value, selectedRound = round.value;
    rows.value = faculties.value.map(f => ({ ...f, status: 'loading' })); busy.value = true;
    let next = 0;
    async function worker() {
        while (next < faculties.value.length && current === generation) {
            const index = next++, faculty = faculties.value[index];
            try {
                const { data } = await api('summary', { fac_id: faculty.id, year: selectedYear, round: selectedRound }, signal);
                if (current === generation) rows.value[index] = { ...faculty, ...data };
            } catch (e) {
                if (current === generation && !signal.aborted) rows.value[index] = { ...faculty, status: 'error', message: 'โหลดข้อมูลหน่วยงานไม่สำเร็จ กรุณาลองใหม่' };
            }
        }
    }
    await Promise.all([worker(), worker(), worker()]);
    if (current === generation) busy.value = false;
}
onMounted(init);
onBeforeUnmount(() => { generation++; controller?.abort(); });
const display = (row, key) => ['loading','error'].includes(row.status) ? '—' : row[key];
function exportExcel() {
    if (!canExport.value) return;
    const escape = value => String(value).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[c]));
    const cell = (value, numeric = false, style = 'base') => `<Cell ss:StyleID="${style}"><Data ss:Type="${numeric ? 'Number' : 'String'}">${escape(value)}</Data></Cell>`;
    const content = [
        `<Row>${cell(`การติดตามการกรอกข้อมูล ปี ${year.value} รอบที่ ${round.value}`)}</Row>`,
        `<Row>${cell('บุคลากรเป็นข้อมูลปัจจุบันจาก ERP; ป.01–ป.03 นับผู้ที่เริ่มบันทึก; ป.04 นับผู้มีคะแนนครบ')}</Row>`,
        `<Row>${['คณะ / หน่วยงาน', ...columns.map(c=>c.label), 'สถานะ'].map(v=>cell(v,false,'head')).join('')}</Row>`,
        `<Row>${cell('รวมทั้งหมด',false,'head')}${columns.map(c=>cell(totals.value[c.key],true,'head')).join('')}${cell('',false,'head')}</Row>`,
        ...rows.value.map(r => `<Row>${cell(r.name,false,r.status)}${columns.map(c=>cell(r[c.key],true,r.status)).join('')}${cell(labels[r.status],false,r.status)}</Row>`)
    ].join('');
    const style = (id, color) => `<Style ss:ID="${id}" ss:Parent="base"><Interior ss:Color="${color}" ss:Pattern="Solid"/></Style>`;
    const xml = `<?xml version="1.0" encoding="UTF-8"?><?mso-application progid="Excel.Sheet"?><Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"><Styles><Style ss:ID="base"><Font ss:FontName="TH Sarabun New" ss:Size="16"/><Alignment ss:Vertical="Center" ss:WrapText="1"/><Borders><Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#DDDDDD"/></Borders></Style>${style('head','#E5E7EB')}${style('none','#FCE7EF')}${style('partial','#FFF3DB')}${style('complete','#E6F5EA')}${style('empty','#F3F4F6')}</Styles><Worksheet ss:Name="ติดตามการกรอกข้อมูล"><Table><Column ss:Width="300"/>${columns.map(()=>'<Column ss:Width="100"/>').join('')}<Column ss:Width="200"/>${content}</Table></Worksheet></Workbook>`;
    const url = URL.createObjectURL(new Blob([xml], { type: 'application/xml;charset=utf-8' })), link = document.createElement('a');
    link.href = url; link.download = `ติดตามการกรอกข้อมูล_${year.value}_${round.value}.xml`; document.body.appendChild(link); link.click(); link.remove(); setTimeout(()=>URL.revokeObjectURL(url),1000);
}
</script>

<template>
    <div class="progress-page">
        <header class="toolbar"><div><h2>📊 การติดตามการกรอกข้อมูล</h2><p>สรุปจำนวนบุคลากรที่บันทึกแบบประเมิน แยกตามคณะ / หน่วยงาน</p></div><div class="controls"><div><label for="progress-year">ปีงบประมาณ</label><Dropdown v-model="year" inputId="progress-year" :options="years" :disabled="initializing" placeholder="เลือกปี" /></div><div><label for="progress-round">รอบประเมิน</label><Dropdown v-model="round" inputId="progress-round" :options="rounds" optionLabel="label" optionValue="value" :disabled="initializing" placeholder="เลือกรอบ" /></div><Button icon="pi pi-refresh" outlined aria-label="โหลดใหม่" :disabled="busy || initializing || !round" @click="load" /></div></header>
        <div v-if="error" role="alert" class="mb-3 text-red-600">{{ error }} <Button label="ลองใหม่" text @click="init" /></div>
        <div class="legend"><span class="partial">บันทึกบางส่วน</span><span class="none">ยังไม่บันทึกทุกแบบ</span><span class="complete">บันทึกครบทุกคนทุกแบบ</span><span class="empty">ไม่มีบุคลากร / ข้อมูลไม่พร้อม</span></div>
        <p v-if="busy || initializing" role="status" class="text-500"><i class="pi pi-spin pi-spinner" /> กำลังโหลด {{ loaded }} / {{ rows.length }} หน่วยงาน</p>
        <p v-else-if="loaded !== rows.length" role="alert" class="text-red-600">บางหน่วยงานโหลดไม่สำเร็จ ยอดรวมยังไม่ครบ กรุณากดโหลดใหม่ก่อน Export</p>
        <div class="table-wrap"><table><thead><tr><th>คณะ / หน่วยงาน</th><th v-for="col in columns" :key="col.key"><i :class="`pi ${col.icon}`" /><span>{{ col.label }}</span></th></tr></thead><tbody>
            <tr class="totals"><th>{{ busy || loaded !== rows.length ? 'รวมเฉพาะข้อมูลที่โหลดสำเร็จ' : 'รวมทั้งหมด' }}</th><td v-for="col in columns" :key="col.key"><button v-if="col.key.startsWith('p0') && loaded > 0" type="button" class="count-link" :aria-label="`ดูรายชื่อ ${col.label} ทุกหน่วยงาน`" @click="openMembers(null,col)">{{ totals[col.key] }}</button><span v-else>{{ totals[col.key] }}</span></td></tr>
            <tr v-for="row in rows" :key="row.id" :class="row.status"><th><i :class="row.status === 'complete' ? 'pi pi-check-circle' : row.status === 'loading' ? 'pi pi-spin pi-spinner' : 'pi pi-info-circle'" :title="labels[row.status]" /><span>{{ row.name }}</span><span class="sr-only">{{ labels[row.status] }}</span></th><td v-for="col in columns" :key="col.key"><button v-if="col.key.startsWith('p0') && row.members && row.roster" type="button" class="count-link" :aria-label="`ดูรายชื่อ ${col.label} ${row.name}`" @click="openMembers(row,col)">{{ row[col.key] }}</button><span v-else>{{ display(row,col.key) }}</span></td></tr>
            <tr v-if="!busy && !initializing && !rows.length"><td :colspan="columns.length + 1" class="empty-message">ไม่พบข้อมูลคณะ / หน่วยงานหรือรอบประเมิน</td></tr>
        </tbody></table></div> 
        <Dialog :visible="!!details" :header="details?.title" modal maximizable :draggable="false" :style="{ width: '92vw', maxWidth: '100rem' }" :breakpoints="{ '640px': '96vw' }" @update:visible="value => { if (!value) details = null; }">
            <p class="text-600">{{ details?.faculty }} · ปี {{ details?.year }} · รอบที่ {{ details?.round }}</p>
            <div class="flex justify-content-between align-items-center gap-3 flex-wrap mb-3"><strong>บุคลากรทั้งหมด {{ (details?.members.length || 0) + (details?.pending.length || 0) }} คน</strong><InputText v-model="personSearch" placeholder="ค้นหาชื่อ / รหัสบุคลากร" aria-label="ค้นหารายชื่อบุคลากร" /></div>
            <div class="member-summary"><div v-for="group in memberGroups" :key="group.key" :class="group.key">{{ group.label }} <strong>{{ group.members.length }} คน</strong></div></div>
            <p v-if="details?.form === 'p04'" class="text-600">ป.04 นับผู้ที่มีคะแนนสรุปพร้อมส่งออก กลุ่มที่เหลืออาจมีคะแนนบางส่วนแล้ว</p>
            <section v-for="group in memberGroups" :key="group.key" class="member-section" :class="group.key">
                <h3>{{ group.label }} — {{ group.members.length }} คน</h3>
                <DataTable :value="group.filtered" paginator :rows="20" :rowsPerPageOptions="[20,50,100]" :alwaysShowPaginator="false" responsiveLayout="scroll">
                    <template #empty>{{ personSearch ? 'ไม่พบรายชื่อที่ค้นหา' : 'ไม่มีบุคลากรในกลุ่มนี้' }}</template>
                    <Column field="staffid" header="รหัสบุคลากร" />
                    <Column field="name" header="ชื่อ – สกุล" sortable><template #body="{ data }"><span :class="group.key === 'pending' ? 'text-red-700' : 'text-green-700'">{{ data.name }}</span></template></Column>
                    <Column field="position" header="ตำแหน่ง" sortable><template #body="{ data }">{{ data.position || '-' }}</template></Column>
                    <Column field="position_level" header="ระดับตำแหน่ง" sortable><template #body="{ data }">{{ data.position_level || '-' }}</template></Column>
                    <Column v-if="details?.allFaculties" field="faculty" header="คณะ / หน่วยงาน" />
                </DataTable>
            </section>
            <template #footer><Button label="ปิด" @click="details = null" /></template>
        </Dialog>
    </div>
</template>

<style scoped>
.member-summary { display:flex; gap:1rem; flex-wrap:wrap; margin:1rem 0; }
.member-summary > div { flex:1; min-width:12rem; padding:1rem; border-radius:.75rem; }
.member-summary strong { display:block; font-size:1.5rem; margin-top:.4rem; }
.member-summary .done { background:#e6f5ea; color:#166534; }.member-summary .pending { background:#fff1f2; color:#b91c1c; }
.member-section { margin-top:1.5rem; }.member-section h3 { font-size:1.1rem; }.member-section.pending h3 { color:#b91c1c; }.member-section.done h3 { color:#166534; }
.count-link { border:0; background:transparent; color:#4f46a5; cursor:pointer; font:inherit; font-weight:700; text-decoration:underline; text-underline-offset:3px; padding:.4rem .7rem; border-radius:.4rem; }
.count-link:hover { background:#ffffff99; }.count-link:focus-visible { outline:2px solid #4f46a5; outline-offset:2px; }
.toolbar,.controls { display:flex; align-items:center; gap:1rem; flex-wrap:wrap; }
.toolbar { justify-content:space-between; margin-bottom:1.25rem; }
h2 { margin:0 0 .5rem; font-size:1.6rem; } .toolbar p,.notes { color:var(--text-color-secondary); }
.controls label { display:block; font-size:.8rem; margin-bottom:.35rem; color:var(--text-color-secondary); }
.controls :deep(.p-dropdown) { min-width:10rem; }.excel-button { background:#5abd00; border-color:#5abd00; }
.legend { display:flex; gap:1rem; flex-wrap:wrap; margin-bottom:1rem; font-size:.85rem; color:#596273; }
.legend span { padding:.35rem .65rem; border-radius:.35rem; }
.table-wrap { overflow:auto; border-radius:1rem; border:1px solid #e3e5eb; box-shadow:0 3px 12px #00000008; }
table { width:100%; border-collapse:collapse; min-width:920px; color:#465064; }
thead { background:#e5e5e7; } th,td { padding:1rem; border-bottom:1px solid #dcdde3; }
thead th:first-child { width:36%; text-align:left; } thead i { display:block; font-size:1.25rem; margin-bottom:.45rem; } thead span { font-size:.85rem; }
tbody th { text-align:left; font-weight:400; } tbody th i { margin-right:.6rem; } tbody td { text-align:center; font-variant-numeric:tabular-nums; }
.totals { background:#f5f3fa; color:#805ad5; font-weight:700; }.totals th { font-weight:700; }
.none { background:#fce7ef; }.partial { background:#fff3db; }.complete { background:#e6f5ea; }.empty,.error,.loading { background:#f3f4f6; }
tbody .none i { color:#df566e; } tbody .complete i { color:#219653; } tbody .partial i { color:#b87916; }
small { display:block; color:#b42318; margin-top:.4rem; }.notes { font-size:.85rem; line-height:1.6; margin-top:1.2rem; }.notes p { margin:.3rem 0; }
.sr-only { position:absolute; width:1px; height:1px; overflow:hidden; clip:rect(0,0,0,0); }.empty-message { text-align:center; padding:3rem; }
</style>
