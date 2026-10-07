<template>
    <div class="grid">
        <div class="col-12">
            <div v-if="!canView" class="card">
                <Message severity="error" :closable="false">ไม่มีสิทธิ์เข้าถึงหน้าประวัติการใช้งาน</Message>
            </div>

            <div v-else class="card">
                <!-- หัวข้อ -->
                <div class="flex flex-wrap align-items-start justify-content-between gap-3 mb-4">
                    <div>
                        <h4 class="m-0"><i class="pi pi-history mr-2 text-primary"></i>ประวัติการใช้งาน</h4>
                        <p class="text-600 mt-2 mb-0">ตรวจสอบว่าผู้ใช้งานแต่ละคนเข้าระบบ บันทึก แก้ไข ลบ หรือพิมพ์รายงานอะไร เมื่อไหร่</p>
                    </div>
                    <div class="flex gap-2">
                        <Button label="ล้างตัวกรอง" icon="pi pi-filter-slash" severity="secondary" text @click="resetFilters" />
                        <Button label="รีเฟรช" icon="pi pi-refresh" severity="secondary" outlined :loading="loading" @click="loadLogs" />
                    </div>
                </div>

                <!-- สรุปจำนวนตามการกระทำ (กดเพื่อกรอง) -->
                <div class="summary-grid mb-4">
                    <button type="button" class="summary-card" :class="{ active: !filters.action }" @click="filterAction(null)">
                        <span class="summary-icon bg-primary-50 text-primary"><i class="pi pi-list"></i></span>
                        <span>
                            <span class="summary-count">{{ summaryTotal.toLocaleString() }}</span>
                            <span class="summary-label">ทั้งหมด</span>
                        </span>
                    </button>
                    <button
                        v-for="option in actionOptions"
                        :key="option.value"
                        type="button"
                        class="summary-card"
                        :class="{ active: filters.action === option.value }"
                        @click="filterAction(option.value)"
                    >
                        <span class="summary-icon" :class="`tone-${actionMeta(option.value).tone}`"><i :class="actionMeta(option.value).icon"></i></span>
                        <span>
                            <span class="summary-count">{{ (summary[option.value] ?? 0).toLocaleString() }}</span>
                            <span class="summary-label">{{ option.label }}</span>
                        </span>
                    </button>
                </div>

                <!-- ตัวกรอง -->
                <div class="formgrid grid">
                    <div class="field col-12 md:col-3">
                        <label for="audit_q">ค้นหา</label>
                        <AutoComplete
                            v-model="filters.q"
                            inputId="audit_q"
                            :suggestions="staffSuggestions"
                            :optionLabel="staffLabel"
                            :minLength="3"
                            :delay="300"
                            placeholder="พิมพ์ชื่อ-สกุล 3 ตัวอักษรขึ้นไป"
                            emptySearchMessage="ไม่พบรายชื่อผู้ใช้งาน"
                            class="w-full"
                            inputClass="w-full"
                            @complete="searchStaff"
                            @item-select="search"
                            @clear="search"
                            @keyup.enter="search"
                        >
                            <template #option="{ option }">
                                <div class="flex align-items-center gap-2">
                                    <Avatar :label="initial(option.staff_name)" shape="circle" size="small" class="avatar" />
                                    <div>
                                        <div>
                                            <span class="font-semibold">{{ option.staff_name || 'ไม่ทราบชื่อ' }}</span>
                                            <span class="text-600 ml-2">{{ option.staff_id }}</span>
                                        </div>
                                        <small class="text-600">{{ option.fac_name || '-' }} · {{ option.total }} รายการ</small>
                                    </div>
                                </div>
                            </template>
                        </AutoComplete>
                        <small class="text-500">หรือพิมพ์รหัสบุคลากร / หน่วยงาน / รายการ แล้วกด Enter</small>
                    </div>
                    <div class="field col-12 md:col-2">
                        <label for="audit_action">การกระทำ</label>
                        <Dropdown id="audit_action" v-model="filters.action" :options="actionOptions" optionLabel="label" optionValue="value" placeholder="ทั้งหมด" showClear class="w-full" @change="search" />
                    </div>
                    <div class="field col-6 md:col-2">
                        <label for="audit_year">ปีงบประมาณ</label>
                        <Dropdown id="audit_year" v-model="filters.eval_year" :options="yearOptions" optionLabel="label" optionValue="value" placeholder="ทุกปี" showClear class="w-full" @change="search" />
                    </div>
                    <div class="field col-6 md:col-2">
                        <label for="audit_round">รอบประเมิน</label>
                        <Dropdown id="audit_round" v-model="filters.eval_round" :options="roundOptions" optionLabel="label" optionValue="value" placeholder="ทุกรอบ" showClear class="w-full" @change="search" />
                    </div>
                    <div class="field col-12 md:col-3">
                        <label for="audit_date">ช่วงวันที่</label>
                        <Calendar id="audit_date" v-model="filters.dates" selectionMode="range" dateFormat="dd/mm/yy" placeholder="เลือกช่วงวันที่" showIcon showButtonBar :manualInput="false" class="w-full" @hide="search" @clear-click="search" />
                    </div>
                </div>

                <!-- ตาราง -->
                <DataTable
                    v-model:expandedRows="expandedRows"
                    :value="logs"
                    :loading="loading"
                    lazy
                    paginator
                    :rows="perPage"
                    :rowsPerPageOptions="[20, 50, 100]"
                    :totalRecords="total"
                    :first="(page - 1) * perPage"
                    dataKey="id"
                    responsiveLayout="scroll"
                    stripedRows
                    rowHover
                    class="audit-table"
                    currentPageReportTemplate="แสดง {first}–{last} จาก {totalRecords} รายการ"
                    paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink RowsPerPageDropdown CurrentPageReport"
                    @page="onPage"
                    @row-click="toggleRow"
                >
                    <template #empty>
                        <div class="text-center text-600 py-5"><i class="pi pi-inbox text-3xl block mb-2"></i>ไม่พบประวัติการใช้งาน</div>
                    </template>

                    <Column expander style="width: 3rem" />

                    <Column header="วันเวลา" style="min-width: 9rem">
                        <template #body="{ data }">
                            <div class="font-medium">{{ formatDate(data.created_at) }}</div>
                            <small class="text-600">{{ formatTime(data.created_at) }} น.</small>
                        </template>
                    </Column>

                    <Column header="ผู้ใช้งาน" style="min-width: 16rem">
                        <template #body="{ data }">
                            <div class="flex align-items-center gap-2">
                                <Avatar :label="initial(data.staff_name)" shape="circle" class="avatar" />
                                <div>
                                    <span class="font-semibold">{{ data.staff_name || 'ไม่ทราบชื่อผู้ใช้งาน' }}</span>
                                    <span class="text-600 ml-2">{{ data.staff_id || '-' }}</span>
                                </div>
                            </div>
                        </template>
                    </Column>

                    <Column header="การกระทำ" style="min-width: 10rem">
                        <template #body="{ data }">
                            <span class="action-pill" :class="`tone-${actionMeta(data.action).tone}`">
                                <i :class="actionMeta(data.action).icon"></i>{{ actionMeta(data.action).label }}
                            </span>
                        </template>
                    </Column>

                    <Column header="ปีงบประมาณ / รอบ" style="min-width: 10rem">
                        <template #body="{ data }">
                            <div v-if="data.eval_year || data.eval_round" v-tooltip.top="data.round_label || ''">
                                <div class="font-medium">{{ data.eval_year ? `ปีงบประมาณ ${data.eval_year}` : '-' }}</div>
                                <span v-if="data.eval_round" class="round-chip">รอบที่ {{ data.eval_round }}</span>
                            </div>
                            <span v-else class="text-500">-</span>
                        </template>
                    </Column>

                    <Column header="รายการ" style="min-width: 16rem">
                        <template #body="{ data }">
                            <div class="font-medium">{{ data.label || data.route }}</div>
                            <div v-if="summarize(data)" class="flex flex-wrap gap-2 mt-1">
                                <span class="meta-chip"><i class="pi pi-database"></i>{{ summarize(data) }}</span>
                            </div>
                        </template>
                    </Column>

                    <Column header="ผลลัพธ์" style="min-width: 8rem">
                        <template #body="{ data }">
                            <span v-if="isFailed(data)" class="text-red-500 font-medium"><i class="pi pi-times-circle mr-1"></i>ไม่สำเร็จ</span>
                            <span v-else class="text-green-600 font-medium"><i class="pi pi-check-circle mr-1"></i>สำเร็จ</span>
                        </template>
                    </Column>

                    <Column header="คณะ/หน่วยงาน" style="min-width: 12rem">
                        <template #body="{ data }">
                            <span v-if="data.fac_name" class="faculty-cell"><i class="pi pi-building"></i>{{ data.fac_name }}</span>
                            <span v-else class="text-500">-</span>
                        </template>
                    </Column>

                    <!-- รายละเอียดเมื่อกดขยาย -->
                    <template #expansion="{ data }">
                        <div class="detail-wrap">
                            <p class="detail-sentence">
                                <b>{{ data.staff_name || 'ไม่ทราบชื่อผู้ใช้งาน' }}</b>
                                <span v-if="data.staff_id" class="text-600"> ({{ data.staff_id }})</span>
                                <span v-if="data.fac_name" class="text-600"> {{ data.fac_name }}</span>
                                {{ actionSentence(data) }}
                                <b>“{{ data.label || data.route }}”</b>
                                <template v-if="data.eval_year || data.eval_round">
                                    ของ<b>{{ data.eval_year ? ` ปีงบประมาณ ${data.eval_year}` : '' }}{{ data.eval_round ? ` รอบที่ ${data.eval_round}` : '' }}</b>
                                </template>
                                เมื่อ {{ formatDate(data.created_at) }} เวลา {{ formatTime(data.created_at) }} น.
                            </p>
                            <div v-if="data.round_label" class="round-banner mb-3">
                                <i class="pi pi-calendar mr-2"></i>ปีงบประมาณ {{ data.eval_year }} · {{ data.round_label }}
                            </div>

                            <Message v-if="isFailed(data)" severity="error" :closable="false" class="mt-0">
                                ทำรายการไม่สำเร็จ (รหัส {{ data.status_code }}) ข้อมูลในรายการนี้ไม่ได้ถูกบันทึกลงระบบ
                            </Message>

                            <div v-if="!data.changes?.items?.length" class="empty-note">
                                <i class="pi pi-info-circle mr-2"></i>
                                {{ data.action === 'login' ? 'เข้าสู่ระบบ ไม่มีการเปลี่ยนแปลงข้อมูล' : data.action === 'export' ? 'พิมพ์/ส่งออกรายงาน ไม่มีการเปลี่ยนแปลงข้อมูล' : 'ไม่มีการเปลี่ยนแปลงข้อมูลในฐานข้อมูล' }}
                            </div>

                            <!-- ข้อมูลที่เปลี่ยนแปลง -->
                            <div v-for="(item, idx) in data.changes?.items ?? []" :key="idx" class="change-card" :class="`border-${opMeta(item.op).tone}`">
                                <div class="change-head">
                                    <span class="action-pill" :class="`tone-${opMeta(item.op).tone}`"><i :class="opMeta(item.op).icon"></i>{{ opMeta(item.op).label }}</span>
                                    <span class="font-semibold">{{ item.table_label || item.table || 'ข้อมูล' }}</span>
                                    <span v-if="item.where" class="text-600 text-sm">({{ humanizeWhere(item.where) }})</span>
                                    <span v-if="item.insert_id && item.op === 'insert'" class="text-600 text-sm">(รหัสที่สร้าง {{ item.insert_id }})</span>
                                    <Tag v-if="item.rolled_back" value="ถูกยกเลิก ไม่ได้บันทึกจริง" severity="danger" icon="pi pi-undo" />
                                </div>

                                <!-- แก้ไข: ค่าเดิม → ค่าใหม่ -->
                                <template v-if="item.op === 'update'">
                                    <div v-if="!item.rows?.length && !item.sql" class="text-600 text-sm">กดบันทึกด้วยค่าเดิม ไม่มีข้อมูลเปลี่ยน</div>
                                    <table v-for="(row, r) in item.rows ?? []" :key="r" class="kv-table">
                                        <thead>
                                            <tr><th>ข้อมูล</th><th>ค่าเดิม</th><th class="arrow-col"></th><th>ค่าใหม่</th></tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="f in row.fields" :key="f.field">
                                                <td class="field-cell">
                                                    {{ fieldLabel(f.field) }}
                                                    <small v-if="fieldLabels[f.field]">{{ f.field }}</small>
                                                </td>
                                                <td class="old-value">{{ displayValue(f.from) }}</td>
                                                <td class="arrow-col"><i class="pi pi-arrow-right"></i></td>
                                                <td class="new-value">{{ displayValue(f.to) }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </template>

                                <!-- เพิ่ม / ลบ: ค่าของแถว -->
                                <template v-else>
                                    <table v-for="(row, r) in item.rows ?? []" :key="r" class="kv-table">
                                        <tbody>
                                            <tr v-for="(value, field) in row" :key="field">
                                                <td class="field-cell">
                                                    {{ fieldLabel(field) }}
                                                    <small v-if="fieldLabels[field]">{{ field }}</small>
                                                </td>
                                                <td :class="item.op === 'delete' ? 'old-value' : 'new-value'">{{ displayValue(value) }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </template>

                                <pre v-if="item.sql" class="raw-block">{{ item.sql }}</pre>
                            </div>

                            <div v-if="data.changes?.truncated" class="text-orange-500 text-sm mb-3">* รายการเปลี่ยนแปลงมากเกินไป แสดงเพียงบางส่วน</div>

                            <!-- ข้อมูลที่ส่งมา -->
                            <details v-if="payloadRows(data.payload).length" class="detail-section">
                                <summary><i class="pi pi-send mr-2"></i>ข้อมูลที่ผู้ใช้ส่งมา ({{ payloadRows(data.payload).length }} รายการ)</summary>
                                <table class="kv-table mt-2">
                                    <tbody>
                                        <tr v-for="p in payloadRows(data.payload)" :key="p.key">
                                            <td class="field-cell">
                                                {{ p.label }}
                                                <small v-if="p.label !== p.key">{{ p.key }}</small>
                                            </td>
                                            <td>{{ displayValue(p.value) }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </details>

                            <details class="detail-section">
                                <summary><i class="pi pi-cog mr-2"></i>ข้อมูลทางเทคนิค</summary>
                                <div class="tech-grid mt-2">
                                    <span>คำสั่ง</span><span>{{ data.method }} /{{ data.route }}</span>
                                    <span>สถานะ</span><span>{{ data.status_code }}</span>
                                    <span>เวลาประมวลผล</span><span>{{ data.duration_ms != null ? `${data.duration_ms} ms` : '-' }}</span>
                                    <span>IP</span><span>{{ data.ip_address || '-' }}</span>
                                    <span>อุปกรณ์</span><span>{{ device(data.user_agent) }}</span>
                                    <span>เบราว์เซอร์</span><span class="break-all">{{ data.user_agent || '-' }}</span>
                                </div>
                            </details>
                        </div>
                    </template>
                </DataTable>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

const { data: sessionData } = useAuthState();
const canView = computed(() => isAuditViewer(sessionData.value?.user?.name?.STAFFID));

const ACTIONS = {
    login: { label: 'เข้าสู่ระบบ', tone: 'blue', icon: 'pi pi-sign-in', verb: 'เข้าสู่ระบบ' },
    create: { label: 'บันทึกข้อมูล', tone: 'green', icon: 'pi pi-plus-circle', verb: 'บันทึกข้อมูล' },
    update: { label: 'แก้ไขข้อมูล', tone: 'orange', icon: 'pi pi-pencil', verb: 'แก้ไขข้อมูล' },
    delete: { label: 'ลบข้อมูล', tone: 'red', icon: 'pi pi-trash', verb: 'ลบข้อมูล' },
    export: { label: 'พิมพ์/ส่งออก', tone: 'purple', icon: 'pi pi-print', verb: 'พิมพ์/ส่งออก' },
    no_change: { label: 'กดบันทึก (ไม่มีข้อมูลเปลี่ยน)', tone: 'gray', icon: 'pi pi-minus-circle', verb: 'กดบันทึกแต่ไม่มีข้อมูลเปลี่ยน ในรายการ' },
    error: { label: 'ทำรายการไม่สำเร็จ', tone: 'red', icon: 'pi pi-exclamation-triangle', verb: 'ทำรายการไม่สำเร็จ ในรายการ' }
};
const OPS = {
    insert: { label: 'เพิ่ม', tone: 'green', icon: 'pi pi-plus' },
    update: { label: 'แก้ไข', tone: 'orange', icon: 'pi pi-pencil' },
    delete: { label: 'ลบ', tone: 'red', icon: 'pi pi-trash' }
};

const actionOptions = Object.entries(ACTIONS).map(([value, meta]) => ({ value, label: meta.label }));
const actionMeta = (action) => ACTIONS[action] ?? { label: action, tone: 'gray', icon: 'pi pi-circle', verb: action };
const opMeta = (op) => OPS[op] ?? { label: op, tone: 'gray', icon: 'pi pi-circle' };

const logs = ref([]);
const total = ref(0);
const page = ref(1);
const perPage = ref(20);
const loading = ref(false);
const expandedRows = ref([]);
const summary = ref({});
const fieldLabels = ref({});
const filters = reactive({ q: '', action: null, eval_year: null, eval_round: null, dates: null });
const yearOptions = ref([]);
const staffSuggestions = ref([]);

// ค่าในช่องค้นหา: เลือกจากรายชื่อ = object, พิมพ์เอง = ข้อความ
const selectedStaff = () => (filters.q && typeof filters.q === 'object' ? filters.q : null);
const staffLabel = (item) => `${item.staff_name ?? ''} ${item.staff_id ?? ''}`.trim();

const searchStaff = async (event) => {
    try {
        const res = await axios.get('http://127.0.0.1:8000/api/auditlogs/staff', { params: { q: event.query } });
        staffSuggestions.value = res.data ?? [];
    } catch (error) {
        console.error('Error:', error);
        staffSuggestions.value = [];
    }
};
const roundOptions = ref([]);

const summaryTotal = computed(() => Object.values(summary.value).reduce((sum, n) => sum + Number(n || 0), 0));

const toYmd = (date) => {
    if (!date) return undefined;
    const d = new Date(date);
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};

const loadLogs = async () => {
    loading.value = true;
    try {
        const [from, to] = filters.dates ?? [];
        const res = await axios.get('http://127.0.0.1:8000/api/auditlogs', {
            params: {
                staff_id: selectedStaff()?.staff_id,
                q: selectedStaff() ? undefined : String(filters.q ?? '').trim() || undefined,
                action: filters.action || undefined,
                eval_year: filters.eval_year || undefined,
                eval_round: filters.eval_round || undefined,
                date_from: toYmd(from),
                date_to: toYmd(to ?? from),
                page: page.value,
                per_page: perPage.value
            }
        });
        logs.value = res.data.data ?? [];
        total.value = res.data.total ?? 0;
        summary.value = res.data.summary ?? {};
        fieldLabels.value = res.data.field_labels ?? {};
        yearOptions.value = (res.data.years ?? []).map((y) => ({ value: String(y), label: `ปีงบประมาณ ${y}` }));
        roundOptions.value = (res.data.rounds ?? []).map((r) => ({ value: String(r), label: `รอบที่ ${r}` }));
        expandedRows.value = [];
    } catch (error) {
        console.error('Error:', error);
        Swal.fire('เกิดข้อผิดพลาด', error.response?.data?.message ?? 'ไม่สามารถโหลดประวัติการใช้งานได้', 'error');
    } finally {
        loading.value = false;
    }
};

const search = () => {
    page.value = 1;
    loadLogs();
};

const filterAction = (action) => {
    filters.action = action;
    search();
};

const resetFilters = () => {
    filters.q = '';
    filters.action = null;
    filters.eval_year = null;
    filters.eval_round = null;
    filters.dates = null;
    search();
};

const onPage = (event) => {
    page.value = event.page + 1;
    perPage.value = event.rows;
    loadLogs();
};

// คลิกที่แถวเพื่อขยาย/ย่อรายละเอียด
const toggleRow = (event) => {
    const id = event.data.id;
    const opened = expandedRows.value.some((row) => row.id === id);
    expandedRows.value = opened ? expandedRows.value.filter((row) => row.id !== id) : [...expandedRows.value, event.data];
};

const parseDate = (value) => new Date(String(value).replace(' ', 'T'));
const formatDate = (value) => (value ? parseDate(value).toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' }) : '-');
const formatTime = (value) => (value ? parseDate(value).toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit', second: '2-digit' }) : '-');

const initial = (name) => {
    const clean = String(name ?? '').replace(/^(นาย|นางสาว|นาง|ดร\.|ผศ\.|รศ\.|ศ\.|อ\.)+/, '').trim();
    return clean ? clean.charAt(0) : '?';
};

const isFailed = (log) => log.action === 'error' || Number(log.status_code) >= 400;

const fieldLabel = (field) => fieldLabels.value[field] ?? field;

const displayValue = (value) => {
    if (value === null || value === undefined || value === '') return '(ว่าง)';
    if (typeof value === 'object') return JSON.stringify(value);
    return value;
};

const actionSentence = (log) => actionMeta(log.action).verb;

// `p_id` = '12' AND ... -> รหัสภาระงาน = 12 และ ...
const humanizeWhere = (where) =>
    String(where)
        .replace(/`(\w+)`/g, (_, field) => fieldLabel(field))
        .replace(/'([^']*)'/g, '$1')
        .replace(/\band\b/gi, 'และ')
        .replace(/\bor\b/gi, 'หรือ')
        .replace(/\bis null\b/gi, 'ว่าง');

const summarize = (log) => {
    const items = log.changes?.items ?? [];
    if (!items.length) return '';
    const parts = items.map((item) => {
        const rows = item.op === 'update' ? (item.rows ?? []).reduce((n, row) => n + (row.fields?.length ?? 0), 0) : (item.rows ?? []).length || item.affected || 1;
        const unit = item.op === 'update' ? 'ช่อง' : 'รายการ';
        return `${opMeta(item.op).label}${item.table_label ? item.table_label : ''} ${rows} ${unit}`;
    });
    return parts.slice(0, 2).join(', ') + (parts.length > 2 ? ` และอีก ${parts.length - 2}` : '');
};

// แปลงข้อมูลที่ส่งมาให้เป็นรายการ ฟิลด์ -> ค่า (แตก object ซ้อนเป็น a.b)
const payloadRows = (payload) => {
    const rows = [];
    const walk = (value, path) => {
        if (value && typeof value === 'object' && !Array.isArray(value)) {
            Object.entries(value).forEach(([key, child]) => walk(child, path ? `${path}.${key}` : key));
        } else if (Array.isArray(value) && value.some((v) => v && typeof v === 'object')) {
            value.forEach((child, i) => walk(child, `${path}[${i + 1}]`));
        } else {
            const leaf = path.split('.').pop().replace(/\[\d+\]$/, '');
            const label = fieldLabels.value[leaf];
            rows.push({ key: path, label: label ? path.replace(leaf, label) : path, value: Array.isArray(value) ? value.join(', ') : value });
        }
    };
    walk(payload ?? {}, '');
    return rows;
};

const device = (ua) => {
    const s = String(ua ?? '');
    if (!s) return '-';
    const browser = /Edg\//.test(s) ? 'Edge' : /OPR\//.test(s) ? 'Opera' : /Chrome\//.test(s) ? 'Chrome' : /Firefox\//.test(s) ? 'Firefox' : /Safari\//.test(s) ? 'Safari' : 'เบราว์เซอร์อื่น';
    const os = /Android/.test(s) ? 'Android' : /iPhone|iPad/.test(s) ? 'iOS' : /Windows/.test(s) ? 'Windows' : /Mac OS X/.test(s) ? 'macOS' : /Linux/.test(s) ? 'Linux' : '';
    return os ? `${browser} · ${os}` : browser;
};

onMounted(() => {
    if (canView.value) loadLogs();
});
</script>

<style scoped>
/* สรุปจำนวน */
.summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(165px, 1fr));
    gap: 0.75rem;
}
.summary-card {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.75rem 0.9rem;
    border: 1px solid var(--surface-border);
    border-radius: 10px;
    background: var(--surface-card);
    cursor: pointer;
    text-align: left;
    font-family: inherit;
    color: inherit;
    transition: border-color 0.15s, box-shadow 0.15s;
}
.summary-card:hover {
    border-color: var(--primary-color);
}
.summary-card.active {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 2px color-mix(in srgb, var(--primary-color) 25%, transparent);
}
.summary-icon {
    width: 2.25rem;
    height: 2.25rem;
    border-radius: 8px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}
.summary-count {
    display: block;
    font-size: 1.25rem;
    font-weight: 700;
    line-height: 1.2;
}
.summary-label {
    display: block;
    font-size: 0.8rem;
    color: var(--text-color-secondary);
}

/* สีตามประเภท */
.tone-blue { background: #e3f2fd; color: #1565c0; }
.tone-green { background: #e8f5e9; color: #2e7d32; }
.tone-orange { background: #fff3e0; color: #e65100; }
.tone-red { background: #fdecea; color: #c62828; }
.tone-purple { background: #f3e5f5; color: #6a1b9a; }
.tone-gray { background: #eceff1; color: #546e7a; }

.action-pill {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.25rem 0.65rem;
    border-radius: 999px;
    font-size: 0.8rem;
    font-weight: 600;
    white-space: nowrap;
}
.meta-chip {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    font-size: 0.78rem;
    color: var(--text-color-secondary);
    background: var(--surface-100);
    border-radius: 6px;
    padding: 0.15rem 0.5rem;
}
.round-chip {
    display: inline-block;
    margin-top: 0.2rem;
    padding: 0.1rem 0.55rem;
    border-radius: 999px;
    font-size: 0.78rem;
    font-weight: 600;
    background: #e0f2f1;
    color: #00695c;
}
.round-banner {
    display: inline-block;
    background: #e0f2f1;
    color: #00695c;
    border-radius: 8px;
    padding: 0.5rem 0.9rem;
    font-size: 0.9rem;
}
.faculty-cell {
    display: inline-flex;
    align-items: flex-start;
    gap: 0.4rem;
    line-height: 1.4;
}
.faculty-cell i {
    color: var(--text-color-secondary);
    margin-top: 0.2rem;
}
.avatar {
    background: var(--primary-100, #d1fae5);
    color: var(--primary-700, #047857);
    font-weight: 600;
    flex-shrink: 0;
}
.audit-table :deep(.p-datatable-tbody > tr) {
    cursor: pointer;
}

/* รายละเอียด */
.detail-wrap {
    padding: 0.5rem 1rem 1rem 3.5rem;
}
.detail-sentence {
    font-size: 1rem;
    margin: 0 0 1rem;
    line-height: 1.7;
}
.empty-note {
    background: var(--surface-50);
    border: 1px dashed var(--surface-border);
    border-radius: 8px;
    padding: 0.75rem 1rem;
    color: var(--text-color-secondary);
    margin-bottom: 1rem;
}
.change-card {
    border: 1px solid var(--surface-border);
    border-left-width: 4px;
    border-radius: 8px;
    padding: 0.85rem 1rem;
    margin-bottom: 1rem;
    background: var(--surface-card);
}
.border-green { border-left-color: #43a047; }
.border-orange { border-left-color: #fb8c00; }
.border-red { border-left-color: #e53935; }
.border-gray { border-left-color: #90a4ae; }
.change-head {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.6rem;
    margin-bottom: 0.75rem;
}
.kv-table {
    width: 100%;
    max-width: 960px;
    border-collapse: collapse;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
}
.kv-table th,
.kv-table td {
    border: 1px solid var(--surface-border);
    padding: 0.45rem 0.7rem;
    text-align: left;
    vertical-align: top;
    word-break: break-word;
}
.kv-table th {
    background: var(--surface-100);
    font-weight: 600;
}
.field-cell {
    width: 230px;
    font-weight: 500;
}
.field-cell small {
    display: block;
    font-weight: 400;
    color: var(--text-color-secondary);
    font-size: 0.75rem;
}
.arrow-col {
    width: 2.5rem;
    text-align: center !important;
    color: var(--text-color-secondary);
}
.old-value {
    background: #fdecea;
    color: #b71c1c;
}
.new-value {
    background: #e8f5e9;
    color: #1b5e20;
}
.detail-section {
    margin-top: 0.75rem;
}
.detail-section summary {
    cursor: pointer;
    color: var(--text-color-secondary);
    font-weight: 500;
    padding: 0.35rem 0;
}
.tech-grid {
    display: grid;
    grid-template-columns: 130px 1fr;
    gap: 0.3rem 1rem;
    font-size: 0.85rem;
}
.tech-grid span:nth-child(odd) {
    color: var(--text-color-secondary);
}
.raw-block {
    background: var(--surface-100);
    padding: 0.75rem;
    border-radius: 6px;
    white-space: pre-wrap;
    word-break: break-word;
    font-size: 0.8rem;
    max-height: 320px;
    overflow: auto;
}
@media (max-width: 768px) {
    .detail-wrap {
        padding: 0.5rem 0.25rem 1rem;
    }
    .field-cell {
        width: 40%;
    }
}
</style>
