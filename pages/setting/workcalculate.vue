<template>
  <div class="grid">
    <div class="col-12">
      <div class="card mb-0">
        <div class="formgroup-inline mb-1 items-center">
          <div class="col md:col-5">
            <h3 class="mb-4 card-header">
              <i class="pi pi-calculator" style="font-size: x-large;"></i>
              ตรวจสอบ ค่าภาระงาน
            </h3>
          </div>
        </div>

        <!-- ตัวกรองคณะ -->
        <div class="formgroup-inline mb-3 items-center" v-if="!loading">
          <div class="col md:col-6">
            <Dropdown
              v-model="selectedFaculty"
              :options="facultyOptions"
              optionLabel="label"
              optionValue="value"
              placeholder="เลือกคณะ (ทั้งหมด)"
              :filter="true"
              showClear
              style="max-width: 420px; width: 100%;"
            />
          </div>
          <div class="col md:col-6 text-right" v-if="viewRows.length">
            แสดง {{ viewRows.length.toLocaleString() }} รายการ
          </div>
        </div>

        <!-- กำลังโหลด -->
        <div v-if="loading" class="loading-wrap">
          <ProgressSpinner style="width:60px;height:60px" strokeWidth="6" />
          <div class="mt-2">กำลังโหลดข้อมูล…</div>
        </div>

        <!-- ตาราง -->
        <table v-else class="table workload-table">
          <colgroup>
            <col style="width: 6%" />
            <col style="width: 30%" />
            <col style="width: 18%" />
            <col style="width: 14%" />
            <col style="width: 14%" />
            <col style="width: 8%" />
            <col style="width: 10%" />
          </colgroup>

          <thead>
            <tr class="thead-1">
              <th rowspan="2">ที่</th>
              <th rowspan="2">ชื่อ–สกุล</th>
              <th rowspan="2">ตำแหน่ง</th>
              <th colspan="3">ส่วนงาน</th>
              <th rowspan="2">ค่างานปัจจุบัน</th>
            </tr>
            <tr class="thead-2">
              <th>งานหลัก</th>
              <th>งานตำแหน่งอื่น</th>
              <th>อื่นๆ</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="(Item, index) in viewRows" :key="Item.staffid ?? Item.staff_id ?? index">
              <td class="text-center">{{ index + 1 }}</td>
              <td class="left">
                <b class="blue">{{ [Item.prefixfullname, Item.namefully].filter(Boolean).join(' ') }}</b>
              </td>
              <td class="text-center"><b class="blue">{{ Item.posnameth || '—' }}</b></td>

              <!-- ส่วนงาน -->
              <td class="text-center">{{ formatDays(Item.work_main) }}</td>
              <td class="text-center">{{ formatDays(Item.work_other_position) }}</td>
              <td class="text-center">{{ formatDays(Item.work_misc) }}</td>

              <!-- ค่างานปัจจุบัน = ผลรวมของ 3 ช่องข้างต้น -->
              <td class="text-center">{{ formatDays(Item.current_value) }}</td>
            </tr>

            <tr v-if="!viewRows.length">
              <td colspan="7" class="text-center">— ไม่พบข้อมูล —</td>
            </tr>
          </tbody>

          <tfoot v-if="viewRows.length">
            <tr>
              <td colspan="3" class="left"><b>รวม</b></td>
              <td class="text-center"><b>{{ formatDays(totals.main) }}</b></td>
              <td class="text-center"><b>{{ formatDays(totals.other) }}</b></td>
              <td class="text-center"><b>{{ formatDays(totals.misc) }}</b></td>
              <td class="text-center"><b>{{ formatDays(totals.total) }}</b></td>
            </tr>
          </tfoot>
        </table>

      </div>
    </div>
  </div>
</template>

<script setup>
import axios from 'axios'
import { ref, onMounted, computed } from 'vue'
import ProgressSpinner from 'primevue/progressspinner'
import Dropdown from 'primevue/dropdown'

// ถ้ามี composable useAuth อยู่แล้ว ให้ import ให้ถูก path ของโปรเจกต์
// import { useAuth } from '@/composables/useAuth'

const API = axios.create({
  baseURL: 'http://127.0.0.1:8000/api',
  timeout: 20000,
})

const products = ref([])
const tracking_date = ref(null)
const tracking_dates = ref([])
const loading = ref(false)

const staffid_Main = ref('')
const facid_Main   = ref('')
const groupid_Main = ref('')

// กรองคณะ
const selectedFaculty = ref(null)
const facultyOptions = computed(() => {
  const map = new Map()
  for (const p of products.value) {
    const id = p.facultyid ?? p.fac_id
    const name = p.facultyname ?? p.facuties ?? p.fac_name
    if (id != null && name) map.set(String(id), String(name))
  }
  const opts = Array.from(map, ([value, label]) => ({ label, value }))
  return [{ label: 'ทั้งหมด', value: null }, ...opts]
})
const filteredProducts = computed(() => {
  if (!selectedFaculty.value) return products.value
  return products.value.filter(p => String(p.facultyid ?? p.fac_id) === String(selectedFaculty.value))
})

// viewRows ใช้ current_value ที่ “คำนวณใหม่แล้ว”
const viewRows = computed(() => filteredProducts.value)

const totals = computed(() => {
  const acc = { main: 0, other: 0, misc: 0, total: 0 }
  for (const r of viewRows.value) {
    const m = Number(r.work_main || 0)
    const o = Number(r.work_other_position || 0)
    const s = Number(r.work_misc || 0)
    acc.main  += m
    acc.other += o
    acc.misc  += s
    acc.total += (Number(r.current_value || (m + o + s)) || 0)
  }
  return acc
})

// ---- Session ----
const { getSession } = await useAuth()
const user = await getSession()
const STAFFID = user?.user?.name?.STAFFID ?? user?.user?.STAFFID ?? ''
const SCOPES  = user?.user?.name?.SCOPES  ?? user?.user?.SCOPES  ?? {}
const staffdepartment = SCOPES?.staffdepartment ?? ''
const groupid         = SCOPES?.groupid ?? ''

function setSession(staffid, facid, groupidX) {
  staffid_Main.value = staffid ?? ''
  facid_Main.value   = facid ?? ''
  groupid_Main.value = groupidX ?? ''
}

function toFix(val) {
  const n = Number(val)
  if (!isFinite(n) || isNaN(n)) return '—'
  // ถ้าติดลบจากข้อมูลไม่ครบ ให้แสดง 0.00
  return (n < 0 ? 0 : n).toFixed(2)
}
function formatDays(val) {
  return toFix(val)
}

// ---- Loaders ----
async function showDataSetAndAutoLoad() {
  loading.value = true
  try {
    const res = await API.post('/showDateSetleader', {
      staff_id: staffid_Main.value,
      fac_id:   facid_Main.value,
      group_id: groupid_Main.value
    })
    const arr = Array.isArray(res.data) ? res.data : []
    // กันวันที่ซ้ำ + sort desc โดย fallback เป็น 0
    const seen = new Set()
    tracking_dates.value = arr.filter(x => {
      const key = [x?.fac_id, x?.evalua, x?.d_date].join('|')
      if (seen.has(key)) return false
      seen.add(key)
      return true
    }).sort((a, b) => {
      const da = Date.parse(a?.d_date ?? '') || 0
      const db = Date.parse(b?.d_date ?? '') || 0
      return db - da
    })

    if (tracking_dates.value.length) {
      tracking_date.value = tracking_dates.value[0]
      await showDataEvalu()
      await fetchWorkloadSummary()
    } else {
      // ไม่มีวันที่ให้โหลด ตั้งค่าว่าง
      products.value = []
    }
  } catch (e) {
    console.error('showDataSetAndAutoLoad error', e)
    products.value = []
  } finally {
    loading.value = false
  }
}

async function showDataEvalu() {
  if (!tracking_date.value) return
  try {
    const res = await API.get('/showDataEvalu', {
      params: {
        staff_id: staffid_Main.value,
        fac_id:   tracking_date.value?.fac_id ?? null,
        group_id: groupid_Main.value,
        evalua:   tracking_date.value?.evalua ?? null,
        p_year:   tracking_date.value?.d_date ?? null
      }
    })
    products.value = (Array.isArray(res.data) ? res.data : []).map(r => ({
      ...r,
      original_current_value: r.current_value,
      work_main: 0,
      work_other_position: 0,
      work_misc: 0,
      current_value: 0,
    }))
  } catch (e) {
    console.error('showDataEvalu error', e)
    products.value = []
  }
}

async function fetchWorkloadSummary() {
  if (!tracking_date.value) return
  try {
    const resp = await API.post('/showplannew', {
      fac_id:   tracking_date.value?.fac_id ?? null,
      staff_id: null,
      keyword:  null,
    })
    const workloadSummary = resp?.data?.workloadSummary || {}
    const sumByStaff = new Map()

    for (const planId of Object.keys(workloadSummary)) {
      const bucket = workloadSummary[planId] || {}
      for (const rawStaffId of Object.keys(bucket)) {
        const byType = bucket[rawStaffId]?.byType || {}
        const cur = sumByStaff.get(String(rawStaffId)) || { main: 0, other_position: 0, misc: 0 }
        sumByStaff.set(String(rawStaffId), {
          main:           cur.main + Number(byType?.main?.days || 0),
          other_position: cur.other_position + Number(byType?.other_position?.days || 0),
          misc:           cur.misc + Number(byType?.misc?.days || 0),
        })
      }
    }

    products.value = products.value.map(row => {
      const key = String(row?.staffid ?? row?.staff_id ?? '')
      const found = sumByStaff.get(key)
      if (!found) return row

      const main  = Number(found.main || 0)
      const other = Number(found.other_position || 0)
      const misc  = Number(found.misc || 0)
      const total = main + other + misc

      return {
        ...row,
        work_main:           main,
        work_other_position: other,
        work_misc:           misc,
        current_value:       total,
      }
    })
  } catch (e) {
    console.error('fetchWorkloadSummary error', e)
    // ถ้าดึง summary ไม่ได้ ให้คงค่าเดิมไว้
  }
}

const emit = defineEmits(['open'])
function openDataEvalu(item) {
  emit('open', item)
}

onMounted(async () => {
  setSession(STAFFID, staffdepartment, groupid)
  await showDataSetAndAutoLoad()
})
</script>

<style scoped>
.card-header { text-align: left; margin: 0; padding: 0; }

/* ตาราง */
.table { width: 100%; border-collapse: collapse; background: #fff; }
.table th, .table td { border: 1px solid #ddd; padding: 8px; text-align: center; font-size: 14px; }

.workload-table thead th { background: #d9f3da; color: #1B5E20; font-weight: 700; }
.thead-1 th, .thead-2 th { background: #d9f3da; }

.left { text-align: left; }
.blue { color: #1a73e8; }

.loading-wrap {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  padding: 32px; color: #555;
}
@media (max-width: 992px) {
  .table th, .table td { font-size: 13px; padding: 6px; }
}
</style>
