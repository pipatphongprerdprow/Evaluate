<template>
  <div class="page-wrap">  
    <div class="hero">
      <div class="hero-left">
        <div class="hero-title">
          <i class="pi pi-chart-bar mr-2"></i> รายงานภาระงาน/โครงการ
        </div>
        <div class="hero-sub">สรุปภาพรวมโครงการทุกคณะ ทุกหน่วยงาน</div>
      </div>
      <div class="kpi-row">
        <div class="kpi-card">
          <div class="kpi-label">โครงการทั้งหมด</div>
          <div class="kpi-value">{{ dashTotals.total }}</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-label">อยู่ระหว่างดำเนินการ</div>
          <div class="kpi-value text-amber-600">{{ dashTotals.inProgress }}</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-label">เสร็จสิ้น</div>
          <div class="kpi-value text-green-600">{{ dashTotals.completed }}</div>
        </div>
        <div class="kpi-card">
          <div class="kpi-label">ความคืบหน้าเฉลี่ย</div>
          <div class="kpi-value">{{ averageProgress }}%</div>
        </div>
      </div>
    </div>   
    <div class="filterbar card">
      <div class="grid align-items-end">
        <div class="col-12 md:col-3">
          <label class="block text-600 mb-1">ปีงบประมาณ</label>
          <Dropdown v-model="selectedFYBE" :options="fyOptions" optionLabel="label" optionValue="value" class="w-full" />
        </div>
        <div class="col-12 md:col-3">
          <label class="block text-600 mb-1">ไตรมาส</label>
          <Dropdown v-model="selectedQuarter" :options="quarterOptions" optionLabel="label" optionValue="value" class="w-full" placeholder="เลือกไตรมาส"/>
        </div>
        <div class="col-12 md:col-3">
          <label class="block text-600 mb-1">ประเภทแผน</label>
          <Dropdown v-model="selectedPlanType" :options="planOptions" optionLabel="label" optionValue="value" class="w-full" placeholder="ทั้งหมด"/>
        </div>
        <!-- <div class="col-12 md:col-3">
          <label class="block text-600 mb-1">คณะ/หน่วยงาน/กอง</label>
          <Dropdown v-model="selectedDepartment" :options="departmentOptions" optionLabel="label" optionValue="value" class="w-full" placeholder="ทั้งหมด"/>
        </div> -->
        <div class="col-12 md:col-3">
          <label class="block text-600 mb-1">คณะ/หน่วยงาน/กอง</label>
          <Dropdown v-model="selectedDepartment" :options="departmentOptions" optionLabel="label" optionValue="value" class="w-full" placeholder="ทั้งหมด" :disabled="!isAdmin"/>
        </div>

        <div class="col-12 md:col-6 mt-3">
          <span class="p-input-icon-left w-full">
            <i class="pi pi-search" />
            <InputText v-model="tableSearch" class="w-full" placeholder="ค้นหาชื่อแผนงาน/โครงการ…" />
          </span>
        </div>
        <div class="col-12 md:col-6 mt-3 flex gap-2 justify-content-end">
          <Button :loading="searching" icon="pi pi-refresh" label="ค้นหาใหม่" class="p-button-primary" @click="handleSearch" />
          <Button icon="pi pi-times" class="p-button-secondary" label="ล้างตัวกรอง" @click="resetFilters" />
          <Button icon="pi pi-download" class="p-button-help" label="ส่งออก CSV" @click="exportCSV" />
        </div>

        <div class="col-12 flex align-items-center gap-2" v-if="searching">
          <ProgressSpinner style="width:24px;height:24px" strokeWidth="6" />
          <small class="text-600">กำลังโหลดข้อมูล…</small>
        </div>
      </div>
    </div> 
    <div class="card p-3 mb-3"> 
      <div class="grid p-fluid"> 
        <!-- ประเภทแผน -->
        <div class="col-12 lg:col-4">
          <Card class="h-full dash-card">
            <template #title>
              <div class="card-head"><i class="pi pi-sitemap mr-2"></i>ประเภทแผนงาน</div>
            </template>
            <template #content>
              <div class="relative">
                <div v-if="searching" class="overlay-loading" aria-live="polite">
                  <div class="flex align-items-center gap-2">
                    <ProgressSpinner style="width:28px;height:28px" strokeWidth="6" />
                    <small class="text-700">กำลังโหลดข้อมูล...</small>
                  </div>
                </div>
                <Chart type="pie" :data="planTypeChartData" :options="pieLegendBottom" />
              </div>
              <div class="text-600 text-sm mt-2">รวม: <b>{{ dashTotals.total }}</b> โครงการ</div>
            </template>
          </Card>
        </div> 
        <!-- สถานะโครงการ -->
        <div class="col-12 lg:col-4">
          <Card class="h-full dash-card">
            <template #title>
              <div class="card-head"><i class="pi pi-check-circle mr-2"></i>สถานะโครงการ</div>
            </template>
            <template #content>
              <div class="relative">
                <div v-if="searching" class="overlay-loading" aria-live="polite">
                  <div class="flex align-items-center gap-2">
                    <ProgressSpinner style="width:28px;height:28px" strokeWidth="6" />
                    <small class="text-700">กำลังโหลดข้อมูล...</small>
                  </div>
                </div>
                <div class="relative">
                  <Chart type="doughnut" :data="statusChartData" :options="doughnutNoLegend" />
                  <div class="dash-center">
                    <div class="text-2xl font-bold">{{ dashTotals.total }}</div>
                    <div class="text-500 text-sm">ทั้งหมด</div>
                  </div>
                </div>
                <div class="grid mt-3 text-center">
                  <div class="col-4">
                    <div class="dot dot-gray mb-1"></div>
                    <div class="text-500 text-sm">รอดำเนินการ</div>
                    <div class="font-bold">{{ dashTotals.pending }}</div>
                  </div>
                  <div class="col-4">
                    <div class="dot dot-amber mb-1"></div>
                    <div class="text-500 text-sm">ระหว่างดำเนินการ</div>
                    <div class="font-bold">{{ dashTotals.inProgress }}</div>
                  </div>
                  <div class="col-4">
                    <div class="dot dot-green mb-1"></div>
                    <div class="text-500 text-sm">เสร็จสิ้น</div>
                    <div class="font-bold">{{ dashTotals.completed }}</div>
                  </div>
                </div>
              </div>
            </template>
          </Card>
        </div>

        <!-- ความคืบหน้าโครงการ -->
        <!-- <div class="col-12 lg:col-4">
          <Card class="h-full dash-card">
            <template #title>
              <div class="card-head between">
                <div><i class="pi pi-chart-line mr-2"></i>ความคืบหน้าโครงการ</div>
                <span class="text-primary font-bold">เฉลี่ย {{ averageProgress }}%</span>
              </div>
            </template>
            <template #content>
              <div class="relative">
                <div v-if="searching" class="overlay-loading"><ProgressSpinner style="width:28px;height:28px" strokeWidth="6" /></div>
                <Chart type="bar" :data="progressChartData" :options="progressChartOptions" />
              </div>
              <div v-if="progressOverflowNote" class="text-500 text-xs mt-2">
                * แสดงเฉพาะ {{ progressMaxBars }} โครงการแรก (เรียงตามชื่อ) เพื่อความอ่านง่าย
              </div>
            </template>
          </Card>
        </div> -->
        <div class="col-12 lg:col-4">
          <Card class="h-full dash-card">
            <template #title>
              <div class="card-head between">
                <div><i class="pi pi-clock mr-2"></i>เวลารวมตามประเภทแผน (นาที)</div>
                <span class="text-primary font-bold">
                  รวมทั้งหมด {{ totalMinutesAllTypes.toLocaleString() }} นาที
                </span>
              </div>
            </template>
            <template #content>
              <div class="relative">
                <div v-if="searching" class="overlay-loading">
                  <ProgressSpinner style="width:28px;height:28px" strokeWidth="6" />
                </div> 
                <!-- กราฟแท่งแสดงเวลารวม (นาที) ต่อประเภทแผน -->
                <Chart type="bar" :data="planTypeMinutesChartData" :options="planTypeMinutesChartOptions" /> 
                <!-- รายการสรุปด้านล่าง (เรียงจากมาก -> น้อย) -->
                <div class="mt-3">
                  <div v-for="row in planTypeMinutesList" :key="row.type" class="flex justify-content-between align-items-center py-1 border-bottom-1 surface-border">
                    <div class="text-700">
                      <i class="pi pi-sitemap mr-2"></i>{{ row.type }}
                    </div>
                    <div class="font-bold">{{ row.minutes.toLocaleString() }} นาที</div>
                  </div>
                </div>
              </div>
            </template>
          </Card>
        </div> 
      </div>
    </div> 
    <div class="card p-3"> 
      <div v-if="searching" class="p-6 text-600 text-center flex align-items-center justify-content-center">
        <ProgressSpinner style="width:36px;height:36px" strokeWidth="6" />
        <span class="ml-2">กำลังโหลดข้อมูล…</span>
      </div> 
      <template v-else>
        <DataTable  ref="dt" :value="filteredProjects" :paginator="true" :rows="10" :rowsPerPageOptions="[10,20,50]" dataKey="__key" responsiveLayout="scroll" stripedRows class="elevated-table">
          <Column header="ไตรมาส" style="width: 10rem; text-align:center">
            <template #body="slotProps">
              <Tag :value="getQuarter(slotProps.data.startDate)" severity="info" />
            </template>
          </Column>

          <Column header="ปี" style="width: 6rem; text-align:center">
            <template #body="slotProps">
              <span class="font-semibold">{{ getYearBE(slotProps.data.startDate) }}</span>
            </template>
          </Column>

          <Column header="ประเภทแผน" style="width: 9rem; text-align:center">
            <template #body="slotProps">
              <Tag :value="getPlanType(slotProps.data)" :severity="getPlanTypeSeverity(getPlanType(slotProps.data))" class="font-semibold"/>
            </template>
          </Column> 

          <!-- ===== WOW: ชื่อโครงการ + Owners Avatar + Accent ===== -->
          <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width: 22rem">
            <template #body="slotProps">
              <div class="cell-card" :class="`type-${getPlanType(slotProps.data)}`">
                <div class="cell-main">
                  <div class="title-row">
                    <i class="pi pi-briefcase text-primary-600 text-lg"></i>
                    <span class="title line-clamp-1">{{ slotProps.data.planLabel || '(ไม่ระบุ)' }}</span>
                  </div>
                  <div class="sub-row">
                    <i class="pi pi-calendar mr-1 text-xs"></i>
                    {{ formatDate(slotProps.data.startDate) }} - {{ formatDate(slotProps.data.endDate) }}
                  </div>
                </div>
                <div class="cell-owners" v-if="(slotProps.data.owner||[]).length">
                  <AvatarGroup>
                    <Avatar v-for="(o, i) in (slotProps.data.owner||[]).slice(0,4)" :key="i" :label="initials(o.name)" shape="circle" class="owner-avatar" :class="colorSeed(o.name)"/>
                    <Avatar v-if="(slotProps.data.owner||[]).length > 4" :label="`+${(slotProps.data.owner||[]).length-4}`" shape="circle" class="owner-avatar more"/>
                  </AvatarGroup>
                </div>
              </div>
            </template>
          </Column> 
          <Column header="เวลารวม (นาที)" style="width: 10rem; text-align:center">
            <template #body="slotProps">
              <span class="font-semibold">{{ getPlanTotalMinutes(slotProps.data).toLocaleString() }}</span>
            </template>
          </Column> 
          <Column header="ความคืบหน้า" style="width: 10.5rem; text-align:center">
            <template #body="slotProps">
              <div  class="radial-wrap" :style="radialStyle(getPlanProgress(slotProps.data))" :class="{ 'rc-success': getPlanStatusLabel(slotProps.data)==='เสร็จสิ้น', 'rc-warn': getPlanStatusLabel(slotProps.data)==='อยู่ระหว่างดำเนินการ' }">
                <div class="radial-core">
                  <div class="radial-num">{{ getPlanProgress(slotProps.data) }}%</div>
                </div>
              </div>
            </template>
          </Column> 
          <Column header="สถานะ" style="width: 10rem; text-align:center">
            <template #body="slotProps">
              <span class="status-pill" :class="getPlanStatusSeverity(slotProps.data)">
                <i v-if="getPlanStatusLabel(slotProps.data)==='เสร็จสิ้น'" class="pi pi-check-circle mr-1"></i>
                <i v-else-if="getPlanStatusLabel(slotProps.data)==='อยู่ระหว่างดำเนินการ'" class="pi pi-spinner mr-1 pi-spin"></i>
                <i v-else class="pi pi-clock mr-1"></i>
                {{ getPlanStatusLabel(slotProps.data) }}
              </span>
            </template>
          </Column> 
          <Column header="รายละเอียด" style="width: 8rem; text-align:center">
            <template #body="slotProps">
              <Button label="รายละเอียด" icon="pi pi-search" class="p-button-sm" :disabled="searching" @click="openPlanDrawer(null, slotProps.data)"/>
            </template>
          </Column>
        </DataTable> 
        <div v-if="filteredProjects.length === 0" class="text-center text-500 py-5">
          ไม่พบโครงการตามเงื่อนไขที่เลือก
        </div>
      </template>
    </div>

    <!-- ===== Drawer รายละเอียดแผน ===== -->
    <Sidebar v-model:visible="planSidebarVisible" position="right" :modal="true" :dismissable="true" style="width: 920px; max-width: 100vw;">
      <template #header>
        <div class="flex items-center gap-3">
          <i class="pi pi-briefcase text-primary text-xl"></i>
          <div class="flex flex-column">
            <span class="text-lg font-bold line-clamp-1">{{ selectedPlan?.planLabel || '-' }}</span>
            <small class="text-600"><i class="pi pi-user mr-1"></i>{{ (selectedPlan?.owner ?? []).map(o=>o.name).join(', ') || '-' }}</small>
          </div>
        </div>
      </template>

      <div v-if="selectedPlan" class="detail-wrap">
        <div class="summary">
          <div class="summary-item"><i class="pi pi-calendar text-600 mr-2"></i>{{ formatDate(selectedPlan.startDate) }} - {{ formatDate(selectedPlan.endDate) }}</div>
          <div class="summary-item"><i class="pi pi-chart-line text-600 mr-2"></i>ความคืบหน้า: <b>{{ getPlanProgress(selectedPlan) }}%</b></div>
          <div class="summary-item"><i class="pi pi-clock text-600 mr-2"></i>เวลารวม: <b>{{ getPlanTotalMinutes(selectedPlan).toLocaleString() }}</b> นาที</div>
          <div class="summary-item"><i class="pi pi-sitemap text-600 mr-2"></i>{{ getQuarter(selectedPlan.startDate) }}</div>
          <div class="summary-item"><i class="pi pi-calendar-times text-600 mr-2"></i>ปีงบฯ: <b>{{ getYearBE(selectedPlan.startDate) }}</b></div>
        </div> 
        <div class="legend">
          <span class="dot dot-gray"></span> รอดำเนินการ
          <span class="dot dot-amber ml-3"></span> อยู่ระหว่างดำเนินการ
          <span class="dot dot-green ml-3"></span> เสร็จสิ้น
        </div> 
        <div class="timeline">
          <div v-for="(st, idx) in (selectedPlan.steps || [])" :key="st.id ?? idx" class="step-card">
            <div class="step-marker" :class="statusClass(getStepStatus(st))"></div>
            <div class="step-body">
              <div class="step-head">
                <div class="step-title"><i class="pi pi-list mr-2 text-primary"></i>{{ st.name || ('ขั้นตอนที่ ' + (idx + 1)) }}</div>
                <div class="step-right">
                  <i class="pi pi-users mr-2 text-600"></i>
                  <span class="step-owners">{{ getStepOwnerNames(st) }}</span>                      
                  <Tag class="ml-2" :value="getStepStatus(st)" :severity="getStepSeverity(st)" />
                </div>
              </div>
              <div class="step-meta">
                <span><i class="pi pi-calendar mr-1"></i>{{ formatDate(st.startDate) }} - {{ formatDate(st.endDate) }}</span>
                <span class="ml-3"><i class="pi pi-percentage mr-1"></i>{{ getStepProgress(st) }}%</span>
                <span class="ml-3"><i class="pi pi-clock mr-1"></i>{{ getStepTotalMinutes(st).toLocaleString() }} นาที</span>
              </div>
              <div class="task-list" v-if="(st.tasks||[]).length">
                <div v-for="(t,i) in st.tasks" :key="i" class="task-item">
                  <div class="task-header">
                    <span class="task-bullet" :class="statusClass(t.status)"></span>
                    <span class="task-title">{{ t.description || '(ยังไม่ระบุ)' }}</span>
                    <Tag class="ml-auto" :value="normalizeStatus(t.status)" :severity="getTaskStatusSeverityByValue(t.status)" />
                  </div>
                  <div class="task-meta">
                    <span class="chip" :class="typeClass(classifyTaskType(t))">{{ classifyTaskType(t) }}</span>
                    <span class="ml-3"><i class="pi pi-calendar mr-1"></i>วันที่ลง: {{ t.createdDate ? formatDate(t.createdDate) : '-' }}</span>
                    <span class="ml-3"><i class="pi pi-clock mr-1"></i>{{ getTaskMinutes(t).toLocaleString() }} นาที</span>
                  </div>
                </div>
              </div>
              <div v-else class="empty-task">ยังไม่มีภาระงานสำหรับขั้นตอนนี้</div>
            </div>
          </div>
        </div>
      </div>
    </Sidebar>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import { useAuth } from '#imports'
import ProgressSpinner from 'primevue/progressspinner'
import Card from 'primevue/card'
import Sidebar from 'primevue/sidebar'
import Chart from 'primevue/chart'
import Avatar from 'primevue/avatar'
import AvatarGroup from 'primevue/avatargroup'

const { getSession } = await useAuth() 

const API = 'http://127.0.0.1:8000/api'

/* ===== state หลัก ===== */
const staffIdMain = ref('')
const facIdMain = ref('')
const groupIdMain = ref('')
const selectedEvaluationRound = ref(null)
const evaluationRounds = ref([])
const products = ref([]) 
const hasSearched = ref(true)
const searching = ref(false)
let reqSeq = 0
let debounceTimer = null
 
const planTypeMinutesMap = computed(() => {
  const map = new Map()
  ;(filteredProjects.value || []).forEach(p => {
    const t = getPlanType(p) || 'ไม่ระบุ'
    const minutes = getPlanTotalMinutes(p) || 0
    map.set(t, (map.get(t) || 0) + minutes)
  })
  return map
})
 
const planTypeMinutesList = computed(() => {
  return Array.from(planTypeMinutesMap.value.entries())
    .map(([type, minutes]) => ({ type, minutes }))
    .sort((a,b) => b.minutes - a.minutes)
})

/* รวมทั้งหมดทุกประเภท (ไว้โชว์ที่หัวการ์ด) */
const totalMinutesAllTypes = computed(() => {
  let sum = 0
  for (const v of planTypeMinutesMap.value.values()) sum += v
  return sum
})

/* Chart Data */
const planTypeMinutesChartData = computed(() => {
  const labels = planTypeMinutesList.value.map(x => x.type)
  const data = planTypeMinutesList.value.map(x => x.minutes)
  return {
    labels,
    datasets: [
      {
        label: 'เวลารวม (นาที)',
        data,
        backgroundColor: '#3B82F6'
      }
    ]
  }
})

/* Chart Options */
const planTypeMinutesChartOptions = {
  plugins: {
    legend: { display: false },
    tooltip: {
      callbacks: {
        label: (ctx) => {
          const val = Number(ctx.raw || 0) 
          const hrs = (val / 60).toFixed(1)
          return ` ${val.toLocaleString()} นาที (~${hrs} ชม.)`
        }
      }
    }
  },
  scales: {
    y: {
      beginAtZero: true,
      ticks: {
        callback: (v) => Number(v).toLocaleString()
      }
    }
  }
}
 
/* ===== ตัวกรอง ===== */
const selectedPlanType = ref('ALL')
const planOptions = [
  { label: 'ทั้งหมด', value: 'ALL' },
  { label: 'แผนปฏิบัติการ', value: 'แผนปฏิบัติการ' },
  { label: 'โครงการ', value: 'โครงการ' },
  { label: 'นโยบาย', value: 'นโยบาย' },
  { label: 'มติประชุม', value: 'มติประชุม' },
  { label: 'ไม่ระบุ', value: 'ไม่ระบุ' },
]

const selectedDepartment = ref('ALL')
// const departmentOptions = computed(() => {
//   const set = new Map()
//   ;(products.value || []).forEach(p => {
//     const id = String(p.departmentid || p.fac_id || '')
//     const name = p.departmentname || p.fac_name || 'ไม่ระบุหน่วยงาน'
//     if (!set.has(id)) set.set(id, name)
//   })
//   return [{ label: 'ทั้งหมด', value: 'ALL' }, ...Array.from(set, ([value, label]) => ({ value, label }))]
// })

const departmentOptions = computed(() => {
  const set = new Map()
  ;(products.value || []).forEach(p => {
    const id = String(p.departmentid || p.fac_id || '')
    const name = p.departmentname || p.fac_name || 'ไม่ระบุหน่วยงาน'
    if (!set.has(id)) set.set(id, name)
  })

  const arr = [{ label: 'ทั้งหมด', value: 'ALL' }, ...Array.from(set, ([value, label]) => ({ value, label }))]

  if (isAdmin.value) return arr
  // non-admin: แสดงเฉพาะคณะของตน (ถ้าไม่มี id จะ fallback เป็นทั้งหมด 1 รายการไม่รวม ALL)
  const myId = String(facIdMain.value || '')
  const onlyMine = arr.filter(o => String(o.value) === myId)
  return onlyMine.length ? onlyMine : arr.filter(o => o.value !== 'ALL')
})

/* ปีงบ + ไตรมาส */
const today = new Date()
const thisFY = (m => (m >= 10 ? today.getFullYear() + 1 : today.getFullYear()))(today.getMonth() + 1)
const selectedFYAD = ref(thisFY)
const selectedFYBE = ref(thisFY + 543)
const fyOptions = computed(()=>{
  const base = thisFY + 543
  return Array.from({length:6}).map((_,i)=>({ label: String(base - i), value: base - i }))
})
const selectedQuarter = ref('ALL')
const quarterOptions = [
  { label: 'ทั้งหมด', value:'ALL' },
  { label: 'ไตรมาส 1', value:'Q1' },
  { label: 'ไตรมาส 2', value:'Q2' },
  { label: 'ไตรมาส 3', value:'Q3' },
  { label: 'ไตรมาส 4', value:'Q4' },
]
const isPeriodValid = computed(() => !!selectedFYBE.value && !!selectedQuarter.value)

/* ===== โครงการทั้งหมด ===== */
const projects = ref([])

/* ===== ค้นหาในตาราง ===== */
const tableSearch = ref('')
const dt = ref(null)

/* ===== Utils เวลา/ช่วง ===== */
function toDate(d){ if(!d) return null; const t = d instanceof Date ? d : new Date(d); return isNaN(t)?null:t }
function fyQuarterToRange(fyAD,q){
  if(q==='ALL') return { start:new Date(fyAD-1,9,1), end:new Date(fyAD,8,30,23,59,59,999) }
  if(q==='Q1') return { start:new Date(fyAD-1,9,1), end:new Date(fyAD-1,11,31,23,59,59,999) }
  if(q==='Q2') return { start:new Date(fyAD,0,1), end:new Date(fyAD,2,31,23,59,59,999) }
  if(q==='Q3') return { start:new Date(fyAD,3,1), end:new Date(fyAD,5,30,23,59,59,999) }
  if(q==='Q4') return { start:new Date(fyAD,6,1), end:new Date(fyAD,8,30,23,59,59,999) }
  return {start:null,end:null}
}
const periodRange = computed(()=> fyQuarterToRange(selectedFYAD.value, selectedQuarter.value))

/* ===== map/normalize ===== */
function ownersFromAny(p){
  const v = p?.owner ?? p?.owners ?? p?.owner_ids ?? p?.responsible ?? null
  if(!v) return []
  if(Array.isArray(v)) return v.map(o => (o && typeof o==='object') ? { id:o.id||o.staffid||null, name: o.name||o.namefully||o.staffname||'' } : { id:null, name:String(o) })
  if(typeof v==='string') return v.split(',').map(s=>({id:null,name:s.trim()}))
  if(typeof v==='object') return [{ id: v.id||v.staffid||null, name: v.name||v.namefully||v.staffname||'' }]
  return []
}
function normalizeStatus(v){
  if(v==null) return 'รอดำเนินการ'
  const s = String(v).toLowerCase()
  if(['complete','completed','เสร็จสิ้น','เสร็จ'].includes(s)) return 'เสร็จสิ้น'
  if(['progress','inprogress','processing','อยู่ระหว่างดำเนินการ'].includes(s)) return 'อยู่ระหว่างดำเนินการ'
  return 'รอดำเนินการ'
}
function mapApiToState(arr){
  return (arr||[]).map(p=>({
    ...p,
    id: p.id ?? p.plan_id ?? p.planId,
    startDate: p.startDate ? new Date(p.startDate) : (p.start_date ? new Date(p.start_date) : null),
    endDate: p.endDate ? new Date(p.endDate) : (p.end_date ? new Date(p.end_date) : null),
    planLabel: p.planLabel ?? p.plan_label,
    planType:  p.planType  ?? p.plan_type ?? 'ไม่ระบุ',
    owner: ownersFromAny(p),
    steps: Array.isArray(p.steps) ? p.steps.map(s=>({
      ...s,
      id: s.id,
      name: s.name ?? s.plan_name,
      status: normalizeStatus(s.status_planstep ?? s.status ?? s.status_plan ?? null),
      startDate: s.startDate?new Date(s.startDate):(s.start_date?new Date(s.start_date):null),
      endDate: s.endDate?new Date(s.endDate):(s.end_date?new Date(s.end_date):null),
      tasks: Array.isArray(s.tasks) ? s.tasks.map(t=>({
        ...t,
        id: t.id,
        description: t.description,
        status: normalizeStatus(t.status),
        startTime: t.startTime?new Date(t.startTime):(t.start_time?new Date(t.start_time):null),
        endTime: t.endTime?new Date(t.endTime):(t.end_time?new Date(t.end_time):null),
        createdDate: t.createdDate?new Date(t.createdDate):(t.created_date?new Date(t.created_date):null)
      })) : []
    })) : []
  }))
}

function isInRangeDate(d, start, end){ const x = toDate(d); return !!(x && start && end && x>=start && x<=end) }
function planOverlapsRange(plan, start, end){
  const s = toDate(plan?.startDate), e = toDate(plan?.endDate)||s
  if(!s&&!e) return false
  return !(e<start || s>end)
}
function filterPlansByRange(plans, start, end){
  return (plans||[])
    .map(p=>{
      const steps = (p.steps||[]).map(st=>{
        const tasks = (st.tasks||[]).filter(t=>{
          const d = t.createdDate || t.startTime || t.endTime || t.dueDate
          return d ? isInRangeDate(d,start,end) : false
        })
        return { ...st, tasks }
      })
      return { ...p, steps }
    })
    .filter(p=>{
      const hasTask = (p.steps||[]).some(st=>(st.tasks||[]).length>0)
      return hasTask || planOverlapsRange(p,start,end)
    })
}

/* ===== โหลดข้อมูล ===== */
async function fetchEvaluationRounds(){
  try{
    const res = await axios.post(`${API}/showDateSetleader`, { staff_id: staffIdMain.value, fac_id: facIdMain.value, group_id: groupIdMain.value })
    evaluationRounds.value = res.data
  }catch{ Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'ไม่สามารถโหลดรอบการประเมินได้' }) }
}
async function fetchAllStaff(){
  try{
    const res = await axios.get(`${API}/showDataEvalu`, {
      params: {
        staff_id: staffIdMain.value,
        fac_id: selectedEvaluationRound.value?.fac_id,
        group_id: groupIdMain.value,
        evalua: selectedEvaluationRound.value?.evalua,
        p_year: selectedEvaluationRound.value?.d_date
      }
    })
    products.value = res.data || []
  }catch{ Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'โหลดรายชื่อบุคลากรไม่สำเร็จ' }) }
}

/* ====== รายคณะ + รวม/ลบซ้ำ owners/steps/tasks ====== */
async function buildProjectBoard() {
  projects.value = [];
  const { start, end } = periodRange.value;

  let facIds = []
  const myFac = String(facIdMain.value || '')

  if (!isAdmin.value) {
    facIds = myFac ? [myFac] : []
  } else if (selectedDepartment.value !== 'ALL') {
    facIds = [String(selectedDepartment.value)]
  } else {
    const set = new Set()
    ;(products.value || []).forEach(p => {
      const id = String(p.departmentid || p.fac_id || '')
      if (id) set.add(id)
    })
    facIds = Array.from(set)
  }

  const buckets = []
  const jobs = facIds.map(async (facId) => {
    try {
      const { data } = await axios.post(`${API}/showplannew`, {
        fac_id: facId,
        date_start: start?.toISOString?.(),
        date_end: end?.toISOString?.(),
      })

      let plans = mapApiToState(data?.data || [])
      plans = filterPlansByRange(plans, start, end)

      const deptName =
        (departmentOptions.value.find(d => String(d.value) === String(facId))?.label) ||
        'ไม่ระบุหน่วยงาน'

      plans.forEach(p => {
        p.__deptId = String(facId)
        p.__deptName = deptName
      })

      buckets.push(plans)
    } catch (e) { /* ignore */ }
  })

  await Promise.all(jobs)

  // รวมและลบซ้ำตาม id จริง
  const byPlan = new Map()

  const mergeUniquePlan = (a, b) => {
    const ownerMap = new Map()
    ;[...(a.owner||[]), ...(b.owner||[])].forEach(o => ownerMap.set(`${o.id}-${o.name}`, o))

    const stepMap = new Map()
    const putStep = (s) => {
      const skey = s.id ?? `${s.name}|${s.startDate?.toISOString?.()}|${s.endDate?.toISOString?.()}`
      const existed = stepMap.get(skey)
      if (!existed) {
        const tMap = new Map()
        ;(s.tasks||[]).forEach(t=>{
          const tkey = t.id ?? `${t.description}|${t.startTime?.toISOString?.()}|${t.endTime?.toISOString?.()}|${t.createdDate?.toISOString?.()}`
          if (!tMap.has(tkey)) tMap.set(tkey, t)
        })
        stepMap.set(skey, { ...s, tasks: Array.from(tMap.values()) })
      } else {
        const tMap = new Map()
        ;[...(existed.tasks||[]), ...(s.tasks||[])].forEach(t=>{
          const tkey = t.id ?? `${t.description}|${t.startTime?.toISOString?.()}|${t.endTime?.toISOString?.()}|${t.createdDate?.toISOString?.()}`
          if (!tMap.has(tkey)) tMap.set(tkey, t)
        })
        stepMap.set(skey, { ...existed, tasks: Array.from(tMap.values()) })
      }
    }
    ;(a.steps||[]).forEach(putStep)
    ;(b.steps||[]).forEach(putStep)

    return {
      ...a,
      owner: Array.from(ownerMap.values()),
      steps: Array.from(stepMap.values()),
    }
  }

  buckets.flat().forEach((p, idx) => {
    const key = String(p.id ?? p.planLabel ?? `tmp-${idx}`)
    if (!byPlan.has(key)) byPlan.set(key, { ...p, __key: key })
    else byPlan.set(key, mergeUniquePlan(byPlan.get(key), p))
  })

  projects.value = Array.from(byPlan.values())
}

/* ===== คำนวณ/เรียง ===== */
function getPlanProgress(plan){
  if(!plan?.steps?.length) return 0
  const total = plan.steps.length
  let score = 0
  plan.steps.forEach(st => { score += st.status==='เสร็จสิ้น' ? 1 : st.status==='อยู่ระหว่างดำเนินการ' ? 0.5 : 0 })
  return Math.round((score/total)*100)
}
function getPlanStatusLabel(plan){
  if(!plan?.steps?.length) return 'รอดำเนินการ'
  const total = plan.steps.length
  const done = plan.steps.filter(st=> st.status==='เสร็จสิ้น').length
  if(done===total) return 'เสร็จสิ้น'
  const progress = plan.steps.some(st=> st.status==='อยู่ระหว่างดำเนินการ')
  return (progress || done>0) ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ'
}
function getPlanStatusSeverity(plan){
  const s = getPlanStatusLabel(plan)
  return s==='เสร็จสิ้น' ? 'success' : s==='อยู่ระหว่างดำเนินการ' ? 'warning' : 'info'
}
function getPlanType(p){ return (p?.planType ?? p?.plan_type ?? 'ไม่ระบุ') || 'ไม่ระบุ' }
function getPlanTypeSeverity(t){ return t==='แผนปฏิบัติการ' ? 'success' : t==='โครงการ' ? 'danger' : t==='นโยบาย' ? 'warning' : t==='มติประชุม' ? 'info' : 'secondary' }

function getStepTotalMinutes(step){ return (step?.tasks||[]).reduce((s,t)=> s + getTaskMinutes(t), 0) }
function getPlanTotalMinutes(plan){ return (plan?.steps||[]).reduce((s,st)=> s + getStepTotalMinutes(st), 0) }
function parseDateLoose(v){ if(!v) return null; const d = v instanceof Date ? v : new Date(v); return isNaN(d)?null:d }
function getTaskMinutes(t){ const a=parseDateLoose(t.startTime), b=parseDateLoose(t.endTime); if(!a||!b) return 0; return Math.max(0, Math.round((b-a)/60000)) }

/* เรียง: ปีงบฯ (ใหม่→เก่า) > ไตรมาส 4→1 > ชื่อแผน */
const quarterRank = { 'ไตรมาส 4 : ก.ค. - ก.ย.':1, 'ไตรมาส 3 : เม.ย. - มิ.ย.':2, 'ไตรมาส 2 : ม.ค. - มี.ค.':3, 'ไตรมาส 1 : ต.ค. - ธ.ค.':4 }
function defaultProjectSort(a,b){
  const yA = Number(getYearBE(a.startDate)||0), yB = Number(getYearBE(b.startDate)||0)
  if(yA !== yB) return yB - yA
  const qA = quarterRank[getQuarter(a.startDate)]||99
  const qB = quarterRank[getQuarter(b.startDate)]||99
  if(qA !== qB) return qA - qB
  return (a.planLabel||'').localeCompare(b.planLabel||'', 'th')
}

/* filter รวมตาราง + ค้นหา */
const filteredProjects = computed(()=>{
  let arr = [...projects.value]
  if(selectedPlanType.value !== 'ALL'){
    arr = arr.filter(p => getPlanType(p) === selectedPlanType.value)
  }
  if(selectedDepartment.value !== 'ALL'){
    arr = arr.filter(p => String(p.__deptId||'') === String(selectedDepartment.value))
  }
  if (tableSearch.value?.trim()) {
    const q = tableSearch.value.trim().toLowerCase()
    arr = arr.filter(p => (p.planLabel||'').toLowerCase().includes(q))
  }
  return arr.sort(defaultProjectSort)
})

/* ===== DASHBOARD DATA ===== */
const pieColors  = ['#42A5F5', '#66BB6A', '#FFA726', '#AB47BC', '#26C6DA', '#EF5350', '#8D6E63']
const pieHover   = ['#64B5F6', '#81C784', '#FFB74D', '#BA68C8', '#4DD0E1', '#E57373', '#A1887F']
const doughnutColors = ['#9CA3AF', '#F59E0B', '#22C55E']
const doughnutHover  = ['#6B7280', '#D97706', '#16A34A']

const progressMaxBars = 15
const pieLegendBottom = { plugins:{ legend:{ position:'bottom' } } }
const doughnutNoLegend = { cutout: '60%', plugins:{ legend:{ display:false } } }

const dashProjects = computed(() => filteredProjects.value)

const dashTotals = computed(() => {
  const arr = dashProjects.value
  let pending=0, inProgress=0, completed=0
  arr.forEach(p=>{
    const s = getPlanStatusLabel(p)
    if (s==='เสร็จสิ้น') completed++
    else if (s==='อยู่ระหว่างดำเนินการ') inProgress++
    else pending++
  })
  return { total: arr.length, pending, inProgress, completed }
})

const planTypeChartData = computed(() => {
  const map = new Map()
  dashProjects.value.forEach(p => {
    const t = getPlanType(p)
    map.set(t, (map.get(t) || 0) + 1)
  })
  const labels = Array.from(map.keys())
  const data = Array.from(map.values())
  return { labels, datasets:[{ data, backgroundColor: pieColors, hoverBackgroundColor: pieHover }] }
})

const statusChartData = computed(() => {
  const t = dashTotals.value
  return {
    labels: ['รอดำเนินการ','อยู่ระหว่างดำเนินการ','เสร็จสิ้น'],
    datasets: [{ data: [t.pending, t.inProgress, t.completed], backgroundColor: doughnutColors, hoverBackgroundColor: doughnutHover }]
  }
})

const averageProgress = computed(() => {
  const arr = dashProjects.value
  if (!arr.length) return 0
  const sum = arr.reduce((s, p) => s + (getPlanProgress(p) || 0), 0)
  return Math.round(sum / arr.length)
})

const progressChartData = computed(() => {
  const arr = [...dashProjects.value]
    .sort((a,b)=>(a.planLabel||'').localeCompare(b.planLabel||'', 'th'))
    .slice(0, progressMaxBars)
  const labels = arr.map(p => (p.planLabel || '(ไม่ระบุ)'))
  const data = arr.map(p => getPlanProgress(p))
  return { labels, datasets: [{ label:'ความคืบหน้า (%)', data, backgroundColor:'#3B82F6' }] }
})
const progressChartOptions = {
  plugins: { legend: { display: false }, tooltip: { callbacks: { label: (ti)=> `${ti.raw}%` } } },
  scales: { y: { beginAtZero: true, max: 100, ticks: { stepSize: 20 } } }
}
const progressOverflowNote = computed(()=> dashProjects.value.length > progressMaxBars)

/* ===== Utils แสดงผล ===== */
function formatDate(dateLike){ const d = dateLike instanceof Date ? dateLike : new Date(dateLike); if(!d||isNaN(d)) return ''; return d.toLocaleDateString('th-TH',{year:'numeric',month:'2-digit',day:'2-digit'}) }
function getQuarter(dateInput){ const d = toDate(dateInput); if(!d) return '-'; const m=d.getMonth()+1; if(m>=10&&m<=12) return 'ไตรมาส 1 : ต.ค. - ธ.ค.'; if(m>=1&&m<=3)  return 'ไตรมาส 2 : ม.ค. - มี.ค.'; if(m>=4&&m<=6)  return 'ไตรมาส 3 : เม.ย. - มิ.ย.'; if(m>=7&&m<=9)  return 'ไตรมาส 4 : ก.ค. - ก.ย.'; return '-' }
function getYearBE(dateInput){ const d = toDate(dateInput); if(!d) return '-'; return String(d.getFullYear()+543) }
function statusClass(s){ const st=String(s||'').trim(); if(st.includes('เสร็จ')) return 'is-done'; if(st.includes('ระหว่าง')) return 'is-progress'; return 'is-pending' }
function typeClass(s){ if(s==='งานหลัก') return 'chip-main'; if(s==='งานตำแหน่งอื่น') return 'chip-otherpos'; return 'chip-other' }
function getStepStatus(step){ return normalizeStatus(step?.status) }
function getStepSeverity(step){ const st=getStepStatus(step); return st==='เสร็จสิ้น'?'success':st==='อยู่ระหว่างดำเนินการ'?'warning':'info' }
function getStepOwnerNames(st){ return (st?.owner||[]).map(o=>o.name).join(', ') || (selectedPlan.value?.owner||[]).map(o=>o.name).join(', ') || '-' }
function getTaskStatusSeverityByValue(v){ const s=normalizeStatus(v); return s==='เสร็จสิ้น'?'success':s==='อยู่ระหว่างดำเนินการ'?'warning':'info' }
function classifyTaskType(t){ const raw=(t?.taskType ?? t?.workload_type ?? t?.mainTask ?? '').toString().trim(); if(raw==='งานหลัก') return 'งานหลัก'; if(raw==='งานตำแหน่งอื่น') return 'งานตำแหน่งอื่น'; if(raw==='งานอื่นๆ') return 'งานอื่นๆ'; return 'งานอื่นๆ' }

function getStepProgress(step){
  if (!step) return 0
  if (typeof step.progress === 'number' && !isNaN(step.progress)) {
    return Math.round(step.progress)
  }
  const st = normalizeStatus(step.status)
  if (st === 'เสร็จสิ้น') return 100
  if (st === 'อยู่ระหว่างดำเนินการ') return 50

  const tasks = Array.isArray(step.tasks) ? step.tasks : []
  if (!tasks.length) return 0

  let score = 0
  tasks.forEach(t => {
    const ts = normalizeStatus(t.status)
    score += ts === 'เสร็จสิ้น' ? 1 : ts === 'อยู่ระหว่างดำเนินการ' ? 0.5 : 0
  })
  return Math.round((score / tasks.length) * 100)
} 
function initials(name='') {
  const parts = String(name).trim().split(/\s+/).slice(0,2)
  return parts.map(p=>p[0]?.toUpperCase?.() || '').join('')
}
function colorSeed(name='') {
  const palette = ['av1','av2','av3','av4','av5','av6']
  let sum = 0; for (let i=0;i<name.length;i++) sum = (sum + name.charCodeAt(i)) % palette.length
  return palette[sum]
}
function radialStyle(percent=0){
  const p = Math.max(0, Math.min(100, Number(percent)||0))
  return {
    background: `conic-gradient(var(--radial-color) ${p*3.6}deg, #eef2f7 ${p*3.6}deg)`,
  }
}

/* ===== Drawer ===== */
const selectedPlan = ref(null)
const planSidebarVisible = ref(false)
function openPlanDrawer(_, plan){ selectedPlan.value = plan; planSidebarVisible.value = true }

/* ===== Actions ===== exportCSV  */
// function exportCSV(){ dt.value?.exportCSV() }
// function resetFilters(){
//   selectedFYBE.value = thisFY + 543
//   selectedQuarter.value = 'ALL'
//   selectedPlanType.value = 'ALL'
//   selectedDepartment.value = 'ALL'
//   tableSearch.value = ''
//   handleSearch()
// }

/* ===== Actions: Export CSV (สรุปโครงการ + รายละเอียดงานย่อย) ===== */
function csvEscape(v){
  if (v == null) return ''
  const s = String(v).replace(/\r?\n/g, ' ')
  return /[",\n;]/.test(s) ? `"${s.replace(/"/g,'""')}"` : s
}
function downloadCSV(filename, rows){
  const bom = '\uFEFF'
  const csv = bom + rows.map(r=>r.map(csvEscape).join(',')).join('\n')
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url; a.download = filename
  document.body.appendChild(a); a.click(); document.body.removeChild(a)
  URL.revokeObjectURL(url)
}
function joinNames(arr){
  return (arr||[]).map(o=>o.name).filter(Boolean).join(', ')
}
function ownersForPlan(p){
  const fromPlan = joinNames(p.owner||[])
  if (fromPlan) return fromPlan
  const set = new Map()
  ;(p.steps||[]).forEach(st=>{
    (st.tasks||[]).forEach(t=>{
      (t.responsible||[]).forEach(x=>{
        const key = `${x.id}-${x.name||''}`
        if(!set.has(key)) set.set(key, x.name||`ผู้รับผิดชอบ #${x.id}`)
      })
    })
  })
  return Array.from(set.values()).join(', ')
}

/* ---------- สรุปรายโครงการ ---------- */
const exportProjectRows = computed(()=>{
  const hdr = [
    'ปีงบประมาณ','ไตรมาส','คณะ/หน่วยงาน','ประเภทแผน','ชื่อแผน/โครงการ',
    'ช่วงเวลา','ผู้รับผิดชอบ','เวลารวม(นาที)','ความคืบหน้า(%)',
    'สถานะโครงการ','จำนวนขั้นตอน','จำนวนงานย่อย'
  ]
  const rows = [hdr]
  filteredProjects.value.forEach(p=>{
    const stepCount = (p.steps||[]).length
    const taskCount = (p.steps||[]).reduce((s,st)=> s + (st.tasks?.length||0), 0)
    rows.push([
      getYearBE(p.startDate),
      getQuarter(p.startDate),
      p.__deptName || '-',
      getPlanType(p),
      p.planLabel || '(ไม่ระบุ)',
      `${formatDate(p.startDate)} - ${formatDate(p.endDate)}`,
      ownersForPlan(p) || '-',
      getPlanTotalMinutes(p),
      getPlanProgress(p),
      getPlanStatusLabel(p),
      stepCount,
      taskCount,
    ])
  })
  return rows
})

/* ---------- รายละเอียดงานย่อย ---------- */
const exportTaskRows = computed(()=>{
  const hdr = [
    'ปีงบประมาณ','ไตรมาส','คณะ/หน่วยงาน','ชื่อแผน/โครงการ','ขั้นตอน',
    'คำอธิบายงาน','วันที่ลง','เวลา(นาที)','ประเภทงาน','สถานะงาน','ผู้รับผิดชอบงาน'
  ]
  const rows = [hdr]
  filteredProjects.value.forEach(p=>{
    (p.steps||[]).forEach(st=>{
      (st.tasks||[]).forEach(t=>{
        const minutes = getTaskMinutes(t)
        const resp = (t.responsible||[]).map(r=>r.name||`ผู้รับผิดชอบ #${r.id}`).join(', ')
        rows.push([
          getYearBE(p.startDate),
          getQuarter(p.startDate),
          p.__deptName || '-',
          p.planLabel || '(ไม่ระบุ)',
          st.name || '-',
          t.description || '(ยังไม่ระบุ)',
          t.createdDate ? formatDate(t.createdDate) : '-',
          minutes,
          classifyTaskType(t),
          normalizeStatus(t.status),
          resp || '-'
        ])
      })
    })
  })
  return rows
})

/* ---------- ปุ่มส่งออกหลัก ---------- */
async function exportCSV() {
  const { value: action } = await Swal.fire({
    title: 'ส่งออกข้อมูล',
    text: 'เลือกประเภทที่ต้องการส่งออก',
    icon: 'question',
    showCancelButton: true,
    showDenyButton: true,
    confirmButtonText: '📊 สรุปรายโครงการ',
    denyButtonText: '📝 รายละเอียดงานย่อย',
    cancelButtonText: 'ยกเลิก'
  }); 
  if (action) {
    // ถ้ากดปุ่ม Confirm (สรุปรายโครงการ)
    downloadCSV('สรุปรายโครงการ.csv', exportProjectRows.value);
    Swal.fire('สำเร็จ', 'ส่งออก "สรุปรายโครงการ" แล้ว', 'success');
  } else if (action === false) {
    // ถ้ากดปุ่ม Deny (รายละเอียดงานย่อย)
    downloadCSV('รายละเอียดงานย่อย.csv', exportTaskRows.value);
    Swal.fire('สำเร็จ', 'ส่งออก "รายละเอียดงานย่อย" แล้ว', 'success');
  }
} 
function resetFilters(){
  selectedFYBE.value = thisFY + 543
  selectedQuarter.value = 'ALL'
  selectedPlanType.value = 'ALL'
  selectedDepartment.value = isAdmin.value ? 'ALL' : String(facIdMain.value || '')
  tableSearch.value = ''
  handleSearch()
}

 
/* ===== Search flow + debounce ===== */
async function handleSearch(){
  if(!isPeriodValid.value){ Swal.fire('แจ้งเตือน','กรุณาเลือกปีงบประมาณและไตรมาสก่อน','warning'); return }
  searching.value = true
  const my = ++reqSeq
  try{
    await reloadAll()
    if(my===reqSeq) hasSearched.value = true
  }finally{
    if(my===reqSeq) searching.value = false
  }
}
function handleSearchDebounced(delay=250){
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(()=>{ handleSearch() }, delay)
}
async function reloadAll(){
  if(!selectedEvaluationRound.value){
    // Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน', 'error'); return
    return;
  }
  await fetchAllStaff()
  await buildProjectBoard()
}

/* ===== watches ===== */
watch(selectedFYBE, (be) => {
  selectedFYAD.value = (parseInt(be, 10) || (thisFY + 543)) - 543
  if (selectedQuarter.value) handleSearchDebounced()
})
watch(selectedQuarter, () => { if (selectedFYBE.value) handleSearchDebounced() })
watch([selectedPlanType, selectedDepartment], () => { handleSearchDebounced() })
 

/* ===== เริ่มต้น ===== */
// onMounted(async ()=>{
//   const session = await getSession()
//   if(session?.user?.name){
//     const { STAFFID, SCOPES } = session.user.name
//     const { staffdepartment, groupid } = SCOPES || {}
//     staffIdMain.value = String(STAFFID || '')
//     facIdMain.value = String(staffdepartment || '')
//     groupIdMain.value = String(groupid || '')
//     await fetchEvaluationRounds()
//     if(evaluationRounds.value.length>0){
//       selectedEvaluationRound.value = evaluationRounds.value[0]
//       await handleSearch()
//     }
//   }
// }) 
const isAdmin = ref(false)

onMounted(async ()=>{
  const session = await getSession()
  if(session?.user?.name){
    const { STAFFID, SCOPES } = session.user.name
    const { staffdepartment, groupid } = SCOPES || {}
    staffIdMain.value = String(STAFFID || '')
    facIdMain.value = String(staffdepartment || '')
    groupIdMain.value = String(groupid || '')
 
    const roles = []
        .concat(SCOPES?.roles || [])
        .concat(SCOPES?.role ? [SCOPES.role] : [])
        .map(r=>String(r).toLowerCase())
      isAdmin.value = SCOPES?.is_admin === true || roles.includes('admin') || roles.includes('superadmin')

      // ถ้าไม่ใช่แอดมิน → ล็อคคณะทันที
      if(!isAdmin.value && facIdMain.value){
        selectedDepartment.value = String(facIdMain.value)
    }

    await fetchEvaluationRounds()
    if(evaluationRounds.value.length>0){
      selectedEvaluationRound.value = evaluationRounds.value[0]
      await handleSearch()
    }
  }
})

</script>

<style> 
  .page-wrap{ display:flex; flex-direction:column; gap:1rem; }
  
  .hero{
    background: linear-gradient(135deg, #eef2ff 0%, #ecfeff 100%);
    border: 1px solid #e5e7eb;
    border-radius: 16px;
    padding: 18px 20px;
    display:flex; align-items:center; justify-content:space-between; gap:16px;
  }
  .hero-title{
    font-size: 1.25rem; font-weight: 800; color:#0f172a;
    display:flex; align-items:center;
  }
  .hero-sub{ color:#475569; font-size:.9rem; }
  
  .kpi-row{ display:grid; grid-template-columns: repeat(4,minmax(0,1fr)); gap:10px; width: 52%; }
  .kpi-card{
    background: linear-gradient(180deg, rgba(255,255,255,.9), rgba(255,255,255,.75));
    backdrop-filter: blur(6px);
    border:1px solid rgba(226,232,240,.9); border-radius:14px; padding:10px 12px;
    box-shadow:0 8px 24px rgba(15,23,42,.08), inset 0 1px 0 rgba(255,255,255,.8);
    transition: transform .18s ease, box-shadow .18s ease;
  }
  .kpi-card:hover{ transform: translateY(-2px); box-shadow: 0 14px 32px rgba(15,23,42,.12); }
  .kpi-label{ color:#64748b; font-size:.8rem; }
  .kpi-value{ font-weight:800; font-size:1.3rem; color:#0f172a; }
  
  .filterbar{
    position: sticky; top: 8px; z-index: 20;
    padding: 14px 16px !important; border-radius: 14px;
    border:1px solid #eef2f7;
    box-shadow:0 6px 24px rgba(2,6,23,.06);
  }
  
  .dash-center{
    position:absolute; inset:0;
    display:flex; flex-direction:column; align-items:center; justify-content:center;
    pointer-events:none;
  }
  .dot{ width:10px; height:10px; border-radius:9999px; margin:0 auto; }
  .dot-gray{ background:#9CA3AF; }
  .dot-amber{ background:#F59E0B; }
  .dot-green{ background:#22C55E; }
  .card-head{ font-weight:700; color:#0f172a; display:flex; align-items:center; }
  .card-head.between{ display:flex; align-items:center; justify-content:space-between; }
  .dash-card{ border-radius:14px; border:1px solid #eef2f7; }
  
  .overlay-loading{
    position:absolute; inset:0;
    background: rgba(255,255,255,.7);
    display:flex; align-items:center; justify-content:center;
    z-index: 5;
    border-radius: .75rem;
    text-align: center;
    padding: 12px;
  }
  
  .elevated-table{ box-shadow: 0 8px 18px rgba(2,6,23,.05); border-radius: 12px; }
  .p-datatable .p-datatable-tbody > tr{
    transition: background .15s ease, box-shadow .15s ease, transform .15s ease;
  }
  .p-datatable .p-datatable-tbody > tr:hover{
    background: #fbfdff;
    box-shadow: 0 8px 18px rgba(2,6,23,.06);
    transform: translateZ(0);
  }

  .cell-card{
    display:flex; align-items:center; justify-content:space-between; gap:12px;
    border: 1px solid #eef2f7; background:#fff; border-radius:12px; padding:10px 12px;
    position:relative; overflow:hidden;
    box-shadow: 0 6px 16px rgba(2,6,23,.04);
  }
  .cell-card:before{
    content:""; position:absolute; left:0; top:0; bottom:0; width:4px; border-radius:12px 0 0 12px;
    background: var(--type-accent, #c7d2fe);
  }
  .cell-card .title-row{ display:flex; align-items:center; gap:8px; font-weight:700; color:#0f172a; }
  .cell-card .title{ max-width: 34ch; }
  .cell-card .sub-row{ color:#64748b; font-size:.8rem; margin-top:2px; display:flex; align-items:center; }
  .cell-owners{ display:flex; align-items:center; }
  
  .type-แผนปฏิบัติการ { --type-accent:#34d399; }
  .type-โครงการ       { --type-accent:#60a5fa; }
  .type-นโยบาย         { --type-accent:#fbbf24; }
  .type-มติประชุม      { --type-accent:#a78bfa; }
  .type-ไม่ระบุ         { --type-accent:#cbd5e1; }
  
  .owner-avatar{ width:28px!important; height:28px!important; font-size:.75rem!important; border:2px solid #fff; box-shadow:0 2px 6px rgba(2,6,23,.12); }
  .owner-avatar.more{ background:#f1f5f9!important; color:#334155!important; }
  .av1{ background:#1d4ed8!important; }
  .av2{ background:#059669!important; }
  .av3{ background:#b45309!important; }
  .av4{ background:#7c3aed!important; }
  .av5{ background:#0ea5e9!important; }
  .av6{ background:#f43f5e!important; }
  
  .radial-wrap{
    --radial-color: #3B82F6;
    width:64px; height:64px; border-radius:9999px; display:inline-flex; align-items:center; justify-content:center;
    background: conic-gradient(var(--radial-color) 0deg, #eef2f7 0deg);
    box-shadow: 0 6px 14px rgba(2,6,23,.08);
    position: relative;
    animation: pop .18s ease-out;
  }
  .radial-wrap::after{
    content:""; position:absolute; inset:6px; border-radius:9999px; background:#fff;
  }
  .radial-core{ position:relative; z-index:1; width:100%; height:100%; display:flex; align-items:center; justify-content:center; }
  .radial-num{ font-weight:800; font-size:.9rem; color:#0f172a; }
  .radial-wrap.rc-success{ --radial-color:#16a34a; }
  .radial-wrap.rc-warn{ --radial-color:#f59e0b; }
  @keyframes pop{ from{ transform:scale(.92); opacity:.6 } to{ transform:scale(1); opacity:1 } }
  
  .status-pill{
    display:inline-flex; align-items:center; gap:6px; padding:6px 10px; border-radius:9999px;
    font-weight:700; font-size:.8rem; letter-spacing:.2px; background:#eef2f7; color:#334155;
  }
  .status-pill.success{ background:#ecfdf5; color:#065f46; }
  .status-pill.warning{ background:#fff7ed; color:#9a3412; }
  .status-pill.info{ background:#eff6ff; color:#1e40af; } 
  .detail-wrap { padding: 8px 6px 24px; }
  .summary { display:flex; flex-wrap:wrap; gap:12px; background:#f8fafc; border:1px solid #eef2f7; border-radius:12px; padding:10px 12px; margin-bottom:10px; }
  .summary-item { display:flex; align-items:center; color:#475569; }
  .legend { color:#64748b; margin:6px 2px 14px; display:flex; align-items:center; gap:16px; }
  .timeline { position:relative; margin-left:18px; }
  .timeline:before { content:""; position:absolute; left:-9px; top:0; bottom:0; width:2px; background:#e5e7eb; }
  .step-card { position:relative; margin-bottom:14px; }
  .step-marker { position:absolute; left:-14px; top:10px; width:12px; height:12px; border-radius:9999px; border:2px solid #fff; box-shadow:0 0 0 2px rgba(0,0,0,.06); }
  .step-marker.is-pending { background:#9ca3af; }
  .step-marker.is-progress { background:#f59e0b; }
  .step-marker.is-done { background:#22c55e; }
  .step-body { background:#fff; border:1px solid #eef2f7; border-radius:12px; padding:12px; box-shadow:0 4px 10px rgba(0,0,0,.04); }
  .step-head { display:flex; align-items:center; justify-content:space-between; }
  .step-title { font-weight:700; color:#0f172a; display:flex; align-items:center; }
  .step-meta { color:#475569; margin-top:4px; font-size:.9rem; display:flex; flex-wrap:wrap; gap:6px 0; }
  .task-list { margin-top:10px; margin-left:32px; display:flex; flex-direction:column; gap:8px; }
  .task-item { border-left:2px solid #e5e7eb; padding-left:12px; border-radius:6px; background:#fafafa; }
  .task-header { display:flex; align-items:center; }
  .task-title { color:#444; font-weight:500; }
  .task-bullet { width:10px; height:10px; border-radius:9999px; display:inline-block; margin-right:6px; }
  .task-bullet.is-pending { background:#2465d6; }
  .task-bullet.is-progress { background:#f59e0b; }
  .task-bullet.is-done { background:#22c55e; }
  .task-meta { margin-top:4px; color:#4b5563; font-size:.9rem; display:flex; flex-wrap:wrap; gap:6px 0; }
  .chip { padding:2px 8px; border-radius:9999px; font-size:.75rem; font-weight:600; margin-right:8px; border:1px solid transparent; background:#f1f5f9; }
  .chip-main { background:#ecfeff; border-color:#67e8f9; }
  .chip-otherpos { background:#fef9c3; border-color:#fde047; }
  .chip-other { background:#e0e7ff; border-color:#818cf8; }
  .empty-task { color:#94a3b8; font-style:italic; margin-top:8px; } 
  .p-paginator { border-top: 1px solid #f1f5f9; margin-top: .75rem; padding-top: .5rem; }
</style>
