<template>
  <div class="grid">
    <div class="col-12 lg:col-12 xl:col-12">
      <div class="card mb-0">
        <div class="formgroup-inline mb-1">
          <div class="col md:col-5">
            <h3 class="mb-4 card-header">
              <i class="pi pi-file" style="font-size: x-large;"></i>
              ตรวจสอบภาระงานประจำวัน
            </h3>
          </div>
          <div class="col md:col-5">
            <Dropdown
              v-model="selectedEvaluationRound"
              :options="evaluationRounds"
              :optionLabel="(item) => `${item.facuties} ${item.d_evaluationround} ${item.d_date}`"
              placeholder="กรุณาเลือกรอบการประเมิน"
              style="max-width: 500px; width: 100%"
            />
          </div>
          <div class="col md:col-1">
            <Button class="mb-2 mr-2" icon="pi pi-search" @click="fetchStaffAndDailyTasks" />
          </div>
        </div>

        <table class="table">
          <thead>
            <tr style="height: 40px;background-color: blanchedalmond;">
              <th style="width: 40%;">ผู้รับการประเมิน</th>
              <th>ตำแหน่ง</th>
              <th>ดูภาระงาน</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in products" :key="index">
              <td style="padding-left: 5px;text-align: left;">
                <b style="color: blue;">{{ item.prefixfullname }} {{ item.namefully }}</b>
              </td>
              <td class="text-center" style="color: blue;">
                <b>{{ item.posnameth || '' }}</b>
              </td>
              <td style="text-align: center;">
                <Button
                  label="รายละเอียด"
                  severity="info"
                  icon="pi pi-list"
                  style="width: 130px;"
                  @click="openDailyTaskDetail(item)"
                />
              </td>
            </tr>
          </tbody>
        </table>

        <!-- Dialog: รายบุคคล -->
        <div class="col md:col-5 text-right">
          <Dialog
            header="รายละเอียดภาระงานประจำวัน"
            maximizable
            v-model:visible="dailyTaskDialogVisible"
            :breakpoints="{ '960px': '75vw' }"
            :style="{ width: '100vw', height: '100vh' }"
            :modal="true"
            position="top"
          >
            <template #header>
              <h3>รายงานภาระงานประจำวัน</h3>
              <p v-if="currentStaffDetail">
                <strong>ชื่อผู้ปฏิบัติงาน:</strong>
                {{ currentStaffDetail?.prefixfullname || '-' }}
                {{ currentStaffDetail?.staffname || currentStaffDetail?.namefully || '-' }}
                {{ currentStaffDetail?.staffsurname || '' }}
              </p>
            </template>

            <!-- ตารางรายบุคคล: แผน → ขั้นตอน → ภาระงาน -->
            <DataTable
              :value="personPlans"
              v-model:expandedRows="expandedPlansPerson"
              dataKey="id"
              responsiveLayout="scroll"
              stripedRows
            >
              <Column expander style="width: 3rem" />

              <Column
                field="planLabel"
                header="ชื่อแผนงาน/โครงการ"
                style="min-width: 12rem"
                class="font-bold text-primary-800"
              >
                <template #body="slotProps">
                  <div class="flex flex-col items-start">
                    <div class="flex items-center">
                      <i class="pi pi-briefcase mr-2 text-primary-600 text-lg"></i>
                      {{ slotProps.data.planLabel }}
                    </div>
                    <small class="text-gray-500 mt-1">
                      <i class="pi pi-calendar mr-1 text-xs"></i>
                      {{ formatDate(slotProps.data.startDate) }} - {{ formatDate(slotProps.data.endDate) }}
                    </small>
                  </div>
                </template>
              </Column>

              <Column header="ผู้รับผิดชอบ">
                <template #body="slotProps">
                  <span v-if="slotProps.data.owner?.length">
                    {{ slotProps.data.owner.map(o => o.name).join(', ') }}
                  </span>
                  <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                </template>
              </Column>

              <Column header="เวลารวม (นาที)" style="min-width: 10rem; text-align:center;">
                <template #body="slotProps">
                  <span class="font-semibold">{{ getPlanTotalMinutes(slotProps.data).toLocaleString() }}</span>
                </template>
              </Column>

              <Column header="ความคืบหน้า" style="min-width: 12rem">
                <template #body="slotProps">
                  <span class="mr-2 text-sm text-primary-600 font-bold">
                    {{ getPlanProgress(slotProps.data) }}%
                  </span>
                  <ProgressBar :value="getPlanProgress(slotProps.data)" class="flex-1" />
                </template>
              </Column>

              <Column header="สถานะ" style="min-width: 8rem">
                <template #body="slotProps">
                  <Tag
                    :value="getPlanStatusLabel(slotProps.data)"
                    :severity="getPlanStatusSeverity(slotProps.data)"
                    class="font-bold"
                  />
                </template>
              </Column>

              <!-- Expansion: ขั้นตอน -->
              <template #expansion="slotProps">
                <div class="p-4 bg-gray-50 border-round-xl ml-4">
                  <div class="text-xl font-bold text-700 flex items-center mb-3">
                    <i class="pi pi-list mr-2 text-primary-500"></i>
                    ขั้นตอน/กิจกรรมการทำงาน
                  </div>

                  <DataTable
                    :value="slotProps.data.steps"
                    v-model:expandedRows="expandedStepsPerson"
                    dataKey="id"
                    responsiveLayout="scroll"
                  >
                    <Column expander style="width: 3rem" />

                    <Column field="name" header="ชื่อขั้นตอน/กิจกรรม" style="min-width: 12rem" class="font-semibold text-700">
                      <template #body="stepProps">
                        <div class="flex items-center">
                          <i class="pi pi-circle-fill mr-2 text-xs text-blue-500"></i>
                          {{ stepProps.data.name }}
                        </div>
                      </template>
                    </Column>

                    <Column header="วันเริ่มต้น" style="min-width: 8rem">
                      <template #body="stepProps">{{ formatDate(stepProps.data.startDate) }}</template>
                    </Column>

                    <Column header="วันสิ้นสุด" style="min-width: 8rem">
                      <template #body="stepProps">{{ formatDate(stepProps.data.endDate) }}</template>
                    </Column>

                    <!-- <Column header="ผู้รับผิดชอบ">
                      <template #body="stepProps">
                        <span v-if="stepProps.data.owner?.length">
                          {{ stepProps.data.owner.map(o => o.name).join(', ') }}
                        </span>
                        <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                      </template>
                    </Column> -->


                    <Column header="ความคืบหน้า" style="min-width: 12rem">
                      <template #body="stepProps">
                        <div class="flex items-center">
                          <span class="mr-2 text-sm text-primary-600 font-bold">{{ getStepProgress(stepProps.data) }}%</span>
                          <ProgressBar :value="getStepProgress(stepProps.data)" class="flex-1" />
                        </div>
                      </template>
                    </Column>

                    <Column header="สถานะ" style="min-width: 8rem">
                      <template #body="stepProps">
                        <Tag :value="getStepStatus(stepProps.data)" :severity="getStepSeverity(stepProps.data)" class="font-bold" />
                      </template>
                    </Column>

                    <!-- Expansion: ภาระงาน -->
                    <template #expansion="stepProps">
                      <div class="p-4 bg-gray-100 border-round-xl ml-4">
                        <div class="text-lg font-bold text-700 flex items-center mb-3">
                          <i class="pi pi-calendar-check mr-2 text-primary-500"></i>
                          ภาระงานประจำวัน
                        </div>

                        <DataTable
                          :value="stepProps.data.tasks"
                          responsiveLayout="scroll"
                          stripedRows
                          :class="{ 'p-datatable-gridlines': true }"
                        >
                          <Column header="ภาระงานหลัก" style="width: 12rem">
                            <template #body="taskProps">
                              <Tag
                                v-if="taskProps.data.mainTask"
                                :value="getMainTaskLabel(taskProps.data.mainTask)"
                                severity="info"
                              />
                              <span v-else class="text-gray-400">ยังไม่เลือก</span>
                            </template>
                          </Column>

                          <Column field="description" header="ภาระงานประจำวัน" style="flex: 1" /> 
                          <Column header="วันที่ลงบันทึก" style="width: 9rem" class="text-center">
                            <template #body="taskProps">{{ formatDate(taskProps.data.createdDate) }}</template>
                          </Column>

                          <Column header="กำหนดเสร็จ" style="width: 9rem" class="text-center">
                            <template #body="taskProps">
                              <Tag :value="formatDate(taskProps.data.dueDate)" :severity="getTaskDueDateSeverity(taskProps.data.dueDate)" />
                            </template>
                          </Column>

                          <Column header="เวลาที่ใช้ไป" style="width: 9rem" class="text-center">
                            <template #body="taskProps">{{ getTaskTimeSpent(taskProps.data) }}</template>
                          </Column>

                          <Column header="สถานะ" style="width: 11rem" class="text-center">
                            <template #body="taskProps">
                              <Dropdown
                                :modelValue="taskProps.data.status"
                                :options="taskStatuses"
                                class="w-full"
                                disabled
                                :class="getTaskStatusSeverityByValue(taskProps.data.status) + '-tag-dropdown'"
                              />
                            </template>
                          </Column>
                        </DataTable>

                        <div v-if="stepProps.data.tasks?.length === 0" class="text-center text-gray-500 text-sm py-4">
                          ยังไม่มีภาระงานสำหรับขั้นตอนนี้
                        </div>
                      </div>
                    </template>
                  </DataTable>
                </div>
              </template>
            </DataTable>

            <div v-if="personPlans.length === 0" class="flex flex-col items-center justify-center p-8">
              <i class="pi pi-inbox text-5xl text-gray-400 mb-3"></i>
              <p class="text-gray-500">ไม่พบแผน/ภาระงานของบุคคลนี้</p>
            </div>

            <template #footer>
              <Button label="ปิด" severity="secondary" @click="dailyTaskDialogVisible = false" />
            </template>
          </Dialog>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'
import { useAuth } from '#imports'

const { getSession } = await useAuth()

/* ---------- CONFIG ---------- */
const API = 'http://127.0.0.1:8000/api'

/* รายชื่อเจ้าของงาน (ใช้ map owner ให้ตรงกับหน้าแรก) */
const owners = ref([
  { id: 1, name: 'นาย พิพัฒน์พงษ์ เพริดพราว' },
    { id: 2, name: 'นาย อนุรักษ์ สุระขันตี' },
    { id: 3, name: 'นาย อัครรินทร์ บุปผา' },
    { id: 4, name: 'นาย สุชาติ กัญญาประสิทธิ์' },
    { id: 5, name: 'นาย ธนดล สิงขรอาสน์' }, 
    { id: 6, name: 'นาย ณัฐวุฒิ สุทธิพันธ์' },
    { id: 7, name: 'นาง นันทรัตน์ จำปาแดง' },
    { id: 8, name: 'นาย ไกรษร อุทัยแสง' },
    { id: 9, name: 'นาง พิมพ์พร พรรณศรี' },
    { id: 10, name: 'นาย กัมปนาท อาชา' },
    { id: 11, name: 'นาง วาสนา อุทัยแสง' },
    { id: 12, name: 'นางสาว แจ่มจันทร์ จันทร์ศรี' },
    { id: 13, name: 'นาง อิศราภรณ์ ศรีเวียงธนาธิป' },
    { id: 14, name: 'นาย คมรัตน์ หลูปรีชาเศรษฐ' },
    { id: 15, name: 'นางสาว สิริมา ศรีสุภาพ' },
    { id: 16, name: 'นางสาว รัตติยา สัจจภิรมย์' },
    { id: 17, name: 'นางสาว กัญญมน แก้วมงคล' },
    { id: 18, name: 'นาง อัจฉราวดี กำมุขโช' },
    { id: 19, name: 'นาง วรินธร จีระฉัตร' },
    { id: 20, name: 'นางสาว ญาณทัสน์ อันทะราศรี' },
    { id: 21, name: 'นาย นัฐพงษ์ ศรีเตชะ' },
    { id: 22, name: 'นางสาว สมสมัย บุญทศ' },
    { id: 23, name: 'นาง สารดา พันธุ์เสนา' }, 
])

const staffIdMain = ref('')
const facIdMain = ref('')
const groupIdMain = ref('')

const selectedEvaluationRound = ref(null)
const evaluationRounds = ref([])
const products = ref([])

const dailyTaskDialogVisible = ref(false)
const currentStaffDetail = ref(null)

const personPlans = ref([])
const expandedPlansPerson = ref([])
const expandedStepsPerson = ref([])

const taskStatuses = ['รอดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น']

onMounted(async () => {
  const session = await getSession()
  if (session?.user?.name) {
    const { STAFFID, SCOPES } = session.user.name
    const { staffdepartment, groupid } = SCOPES || {}
    staffIdMain.value = String(STAFFID || '')
    facIdMain.value = String(staffdepartment || '')
    groupIdMain.value = String(groupid || '')
    await fetchEvaluationRounds()
  }
})

/* ---------- utils / format ---------- */
function formatDate(dateLike) {
  const d = dateLike instanceof Date ? dateLike : new Date(dateLike)
  if (!d || isNaN(d)) return ''
  return d.toLocaleDateString('th-TH', { year: 'numeric', month: '2-digit', day: '2-digit' })
}
function pad(n){return String(n).padStart(2,'0')}

function parseDateLoose(v) {
  if (!v) return null
  if (v instanceof Date) return isNaN(v) ? null : v
  if (typeof v === 'number') return new Date(v)

  const s = String(v).trim()

  // ISO-like
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) return new Date(s.replace(' ', 'T'))

  // DD/MM/YYYY (รองรับ พ.ศ.)
  let m = s.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/)
  if (m) {
    let [, dd, mm, yyyy] = m
    let y = parseInt(yyyy, 10); if (y > 2400) y -= 543
    return new Date(y, parseInt(mm,10)-1, parseInt(dd,10))
  }

  // YYYY/MM/DD (รองรับ พ.ศ.)
  m = s.match(/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})$/)
  if (m) {
    let [, yyyy, mm, dd] = m
    let y = parseInt(yyyy, 10); if (y > 2400) y -= 543
    return new Date(y, parseInt(mm,10)-1, parseInt(dd,10))
  }

  // time-only HH:mm[:ss] → วันนี้
  const t = s.match(/^(\d{1,2}):(\d{2})(?::(\d{2}))?$/)
  if (t) {
    const now = new Date()
    return new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      parseInt(t[1],10),
      parseInt(t[2],10),
      t[3] ? parseInt(t[3],10) : 0
    )
  }

  const d = new Date(s)
  return isNaN(d) ? null : d
}

function displayNameOf(o) {
  if (!o) return ''
  if (typeof o === 'string') return o
  if (typeof o === 'number') return `รหัส ${o}`
  const parts = []
  const prefix = o.prefixfullname || o.prefix || ''
  const first  = o.name || o.staffname || o.firstname || o.first_name || o.namefully || ''
  const last   = o.staffsurname || o.lastname || o.last_name || ''
  const full   = o.fullname || o.full_name || o.namefully
  if (full) return full
  if (prefix) parts.push(prefix)
  if (first)  parts.push(first)
  if (last)   parts.push(last)
  return parts.join(' ').trim()
}

function normalizePeople(v) {
  if (!v) return []
  if (Array.isArray(v)) {
    return v.map(x => {
      if (typeof x === 'string' || typeof x === 'number') return { id: x, name: displayNameOf(x) }
      return {
        id: x.id ?? x.staffid ?? x.STAFFID ?? x.user_id ?? null,
        name: displayNameOf(x) || (x.POSNAMETH ?? '')
      }
    })
  }
  if (typeof v === 'string') {
    return v.split(',').map(s => ({ id: s.trim(), name: s.trim() }))
  }
  return []
}

function normalizeStatus(v) {
  if (v === undefined || v === null) return 'รอดำเนินการ'
  if (typeof v === 'number') {
    if (v === 2 || v === 3) return 'เสร็จสิ้น'
    if (v === 1 || v === 2) return 'อยู่ระหว่างดำเนินการ'
    return 'รอดำเนินการ'
  }
  const s = String(v).trim().toLowerCase()
  if (['done','finished','complete','completed','เสร็จ','เสร็จสิ้น'].includes(s)) return 'เสร็จสิ้น'
  if (['progress','inprogress','processing','อยู่ระหว่างดำเนินการ'].includes(s)) return 'อยู่ระหว่างดำเนินการ'
  return 'รอดำเนินการ'
}

/* ---------- progress / tag helpers ---------- */
function getPlanProgress(plan) {
  if (!plan?.steps?.length) return 0
  const total = plan.steps.reduce((s, st) => s + (st.tasks?.length || 0), 0)
  if (!total) return 0
  const done = plan.steps.reduce((s, st) => s + (st.tasks?.filter(t => normalizeStatus(t.status) === 'เสร็จสิ้น').length || 0), 0)
  return Math.round((done / total) * 100)
}
function getStepProgress(step) {
  if (!step?.tasks?.length) return 0
  const total = step.tasks.length
  const done = step.tasks.filter(t => normalizeStatus(t.status) === 'เสร็จสิ้น').length
  return Math.round((done / total) * 100)
}
function getPlanStatusLabel(plan) {
  const p = getPlanProgress(plan)
  return p === 100 ? 'เสร็จสิ้น' : p > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ'
}
function getPlanStatusSeverity(plan) {
  const p = getPlanProgress(plan)
  return p === 100 ? 'success' : p > 0 ? 'warning' : 'info'
}
function getStepStatus(step) {
  const p = getStepProgress(step)
  return p === 100 ? 'เสร็จสิ้น' : p > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ'
}
function getStepSeverity(step) {
  const p = getStepProgress(step)
  return p === 100 ? 'success' : p > 0 ? 'warning' : 'info'
}
function getTaskDueDateSeverity(dueDate) {
  if (!dueDate) return 'info'
  const now = new Date()
  const due = dueDate instanceof Date ? dueDate : new Date(dueDate)
  due.setHours(23,59,59,999)
  return due < now ? 'danger' : 'success'
}
function getTaskTimeSpent(task) {
  const mins = getTaskMinutes(task);
  if (mins === 0) {
    // ถ้าอยากให้โชว์ “ยังไม่ระบุ” กรณีไม่มีเวลา start/end ให้ใช้แบบนี้:
    const hasStart = !!parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start);
    const hasEnd   = !!parseDateLoose(task?.endTime   ?? task?.time_end   ?? task?.end_time   ?? task?.work_end);
    return (hasStart && hasEnd) ? '0 นาที' : 'ยังไม่ระบุ';
  }
  return `${mins} นาที`;
}

function getTaskMinutes(task) {
  // รองรับคีย์หลายแบบที่อาจมาจาก API
  const start = parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start);
  const end   = parseDateLoose(task?.endTime   ?? task?.time_end   ?? task?.end_time   ?? task?.work_end);

  // ถ้ายังไม่ครบ ให้ถือว่า 0 นาที (ไม่ทิ้ง error)
  if (!start || !end) return 0;

  // กันเวลา end < start
  const diffMs = Math.max(0, end - start);
  return Math.round(diffMs / 60000); // นาทีล้วน
}

// รวม “นาทีทั้งหมด” ของขั้นตอนหนึ่ง ๆ
function getStepTotalMinutes(step) {
  if (!step?.tasks?.length) return 0;
  return step.tasks.reduce((sum, t) => sum + getTaskMinutes(t), 0);
}

// รวม “นาทีทั้งหมด” ของทั้งแผน (รวมทุกขั้นตอน)
function getPlanTotalMinutes(plan) {
  if (!plan?.steps?.length) return 0;
  return plan.steps.reduce((sum, st) => sum + getStepTotalMinutes(st), 0);
}


function getTaskStatusSeverityByValue(status) {
  const s = normalizeStatus(status)
  return s === 'เสร็จสิ้น' ? 'success' : s === 'อยู่ระหว่างดำเนินการ' ? 'warning' : 'info'
}
function getMainTaskLabel(mainTask) {
  return mainTask || 'ยังไม่เลือก'
}

/* ---------- mapping ให้ตรงกับหน้าแรก ---------- */
const findOwner = (o) =>
  owners.value.find(x => Number(x.id) === Number(o?.id ?? o)) || null;

// แปลง owner ให้เป็น [{id,name}] รับได้ทั้ง id, object, string, "1,2", "ชื่อ ก,ชื่อ ข"
function toOwnerArray(v) {
  if (!v) return [];
  if (Array.isArray(v)) {
    return v.map(item => {
      if (item && typeof item === 'object' && ('id' in item || 'staffid' in item)) {
        const id = item.id ?? item.staffid;
        return findOwner({ id }) ?? { id, name: String(item.name ?? item.fullname ?? id) };
      }
      if (typeof item === 'number' || /^\d+$/.test(String(item))) {
        const id = Number(item);
        return findOwner({ id }) ?? { id, name: String(id) };
      }
      return { id: null, name: String(item) };
    });
  }
  if (typeof v === 'string') {
    return v.split(',').map(s => {
      const t = s.trim();
      if (/^\d+$/.test(t)) {
        const id = Number(t);
        return findOwner({ id }) ?? { id, name: t };
      }
      return { id: null, name: t };
    });
  }
  if (typeof v === 'object') {
    const id = v.id ?? v.staffid ?? null;
    return [findOwner({ id }) ?? { id, name: String(v.name ?? v.fullname ?? id ?? '') }];
  }
  return [];
}

// รองรับหลายชื่อฟิลด์ที่ API อาจส่งมา
function ownersFromAny(p) {
  return toOwnerArray(
    p?.owner ?? p?.owners ?? p?.ownerIds ?? p?.owner_ids ?? p?.responsible ?? null
  );
}

// === mapping หลัก ===
function mapApiToState(arr) {
  return (arr || []).map(p => {
    const planOwners = ownersFromAny(p);

    return {
      ...p,
      startDate: p.startDate ? new Date(p.startDate) : null,
      endDate:   p.endDate   ? new Date(p.endDate)   : null,

      owner: planOwners,
      ownerNames: planOwners.map(o => o.name).join(', '),

      steps: (p.steps || []).map(s => {
        const stepOwners = ownersFromAny(s);

        return {
          ...s,
          owner: stepOwners,
          ownerNames: stepOwners.map(o => o.name).join(', '),
          startDate: s.startDate ? new Date(s.startDate) : null,
          endDate:   s.endDate   ? new Date(s.endDate)   : null,

          tasks: (s.tasks || []).map(t => {
            const responsible = ownersFromAny(t);
            return {
              ...t,
              responsible,
              mainTask: t.mainTask ?? t.Main_tasks ?? null,
              dueDate:     t.dueDate     ? new Date(t.dueDate)     : null,
              startTime:   t.startTime   ? new Date(t.startTime)   : null,
              endTime:     t.endTime     ? new Date(t.endTime)     : null,
              createdDate: t.createdDate ? new Date(t.createdDate) : null,
            };
          }),
        };
      }),
    };
  });
}


/* ---------- API ---------- */
async function fetchEvaluationRounds() {
  try {
    const res = await axios.post(`${API}/showDateSetleader`, {
      staff_id: staffIdMain.value,
      fac_id: facIdMain.value,
      group_id: groupIdMain.value
    })
    evaluationRounds.value = res.data
  } catch {
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดรอบการประเมินได้' })
  }
}

async function fetchStaffAndDailyTasks() {
  if (!selectedEvaluationRound.value) {
    Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมิน', 'error')
    return
  }
  try {
    const res = await axios.get(`${API}/showDataEvalu`, {
      params: {
        staff_id: staffIdMain.value,
        fac_id: selectedEvaluationRound.value.fac_id,
        group_id: groupIdMain.value,
        evalua: selectedEvaluationRound.value.evalua,
        p_year: selectedEvaluationRound.value.d_date
      }
    })
    products.value = (res.data || []).filter(
      item => item.stftypename !== 'ลูกจ้างชั่วคราว' && item.stftypename !== 'พนักงานราชการ'
    )
  } catch {
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลผู้รับการประเมินได้' })
  }
}

async function openDailyTaskDetail(staffData) {
  if (!selectedEvaluationRound.value) {
    Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน', 'error')
    return
  }
  currentStaffDetail.value = staffData
  dailyTaskDialogVisible.value = true
  personPlans.value = []

  try {
    // ใช้ endpoint เดียวกับหน้าแรก เพื่อให้โครงสร้าง/ค่าตรงกัน
    const { data } = await axios.post(`${API}/showplannew`, {
      staff_id: staffData.staffid,
      fac_id:   selectedEvaluationRound.value.fac_id
    })
    personPlans.value = mapApiToState(data?.data || [])

    // (option) ถ้าไม่มีข้อมูล ลอง fallback ไปของเดิม
    if (!personPlans.value.length) {
      const alt = await axios.post(`${API}/getDataplans`, {
        staffid: staffData.staffid,
        facid: selectedEvaluationRound.value.fac_id
      })
      personPlans.value = mapApiToState(alt.data?.plans || [])
    }
  } catch (e) {
    console.error(e)
    personPlans.value = []
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลภาระงานประจำวันได้' })
  }
}
// ิ bew
/* ---------- expose ---------- */
defineExpose({
  formatDate,
  getMainTaskLabel,
  getPlanProgress,
  getStepProgress,
  getPlanStatusLabel,
  getPlanStatusSeverity,
  getStepStatus,
  getStepSeverity,
  getTaskDueDateSeverity,
  getTaskTimeSpent,
  getTaskStatusSeverityByValue,
  fetchEvaluationRounds,
  fetchStaffAndDailyTasks,
  openDailyTaskDetail
})




</script>




<style>
.card-header {
  text-align: left;
  margin: 0;
  padding: 0;
}
.table th {
  background-color: #edf2bb;
  font-weight: bold;
}
table {
  border-collapse: collapse;
  width: 100%;
}
th, td {
  border: 1px solid rgb(206, 203, 203);
  text-align: center;
}
.p-datatable .p-column-header-content {
  justify-content: center;
}
</style>

