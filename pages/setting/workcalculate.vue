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
            <col style="width: 10%" /> <!-- ค่างานปัจจุบัน (ผลรวมใหม่) -->
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
            <tr v-for="(Item, index) in viewRows" :key="Item.staffid ?? index">
              <td class="text-center">{{ index + 1 }}</td>
              <td class="left"><b class="blue">{{ Item.prefixfullname }} {{ Item.namefully }}</b></td>
              <td class="text-center"><b class="blue">{{ Item.posnameth || '—' }}</b></td>

              <!-- ส่วนงาน -->
              <td class="text-center">{{ toFix(Item.work_main) }}</td>
              <td class="text-center">{{ toFix(Item.work_other_position) }}</td>
              <td class="text-center">{{ toFix(Item.work_misc) }}</td>

              <!-- ค่างานปัจจุบัน = ผลรวมของ 3 ช่องข้างต้น -->
              <td class="text-center">{{ toFix(Item.current_value) }}</td>
            </tr>

            <tr v-if="!viewRows.length">
              <td colspan="7" class="text-center">— ไม่พบข้อมูล —</td>
            </tr>
          </tbody>
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
    const name = p.facultyname ?? p.facuties
    if (id != null && name) map.set(id, name)
  }
  return [{ label: 'ทั้งหมด', value: null }, ...Array.from(map, ([value, label]) => ({ label, value }))]
})
const filteredProducts = computed(() => {
  if (!selectedFaculty.value) return products.value
  return products.value.filter(p => (p.facultyid ?? p.fac_id) === selectedFaculty.value)
})
 
const viewRows = computed(() => filteredProducts.value)

const { getSession } = await useAuth()
const user = await getSession()
const { STAFFID, SCOPES } = user.user.name
const { staffdepartment, groupid } = SCOPES

function setSession(staffid, facid, groupidX) {
  staffid_Main.value = staffid
  facid_Main.value   = facid
  groupid_Main.value = groupidX
}

function toFix(val) {
  const n = Number(val)
  return isNaN(n) ? '—' : n.toFixed(2)
}

async function showDataSetAndAutoLoad() {
  try {
    loading.value = true
    const res = await axios.post('http://127.0.0.1:8000/api/showDateSetleader', {
      staff_id: staffid_Main.value,
      fac_id:   facid_Main.value,
      group_id: groupid_Main.value
    })
    tracking_dates.value = Array.isArray(res.data) ? res.data : []

    if (tracking_dates.value.length) {
      const sorted = [...tracking_dates.value].sort((a, b) => {
        const da = Date.parse(a?.d_date ?? '')
        const db = Date.parse(b?.d_date ?? '')
        if (isNaN(da) || isNaN(db)) return 0
        return db - da
      })
      tracking_date.value = sorted[0] || tracking_dates.value[0]

      await showDataEvalu()
      await fetchWorkloadSummary()    
    }
  } finally {
    loading.value = false
  }
}

async function showDataEvalu() {
  if (!tracking_date.value) return
  const res = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {
    params: {
      staff_id: staffid_Main.value,
      fac_id:   tracking_date.value?.fac_id,
      group_id: groupid_Main.value,
      evalua:   tracking_date.value?.evalua,
      p_year:   tracking_date.value?.d_date
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
}

async function fetchWorkloadSummary() {
  const resp = await axios.post('http://127.0.0.1:8000/api/showplannew', {
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
