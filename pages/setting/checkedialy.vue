<template>
  <div class="grid">
    <div class="col-12 lg:col-12 xl:col-12">
      <div class="card mb-0">
        <div class="formgroup-inline mb-3">
          <div class="col md:col-5">
            <h3 class="mb-4 card-header">
              <i class="pi pi-file" style="font-size: x-large;"></i>
              ตรวจสอบภาระงานประจำวัน
            </h3>
          </div>
        </div>

        <!-- ===== Leaderboard ===== -->
        <div class="card p-3 mb-3">
          <div class="flex align-items-center justify-content-between mb-3">
            <div class="flex align-items-center gap-2">
              <i class="pi pi-trophy text-yellow-500 text-2xl"></i>
            </div>
            <Dropdown
              v-model="sortKey"
              :options="sortOptions"
              optionLabel="label"
              optionValue="value"
              class="w-14rem"
              placeholder="เรียงลำดับตาม"
            />
          </div>

          <div class="grid">
            <div v-for="p in leaderboardSorted" :key="p.staffid" class="col-12 md:col-6 lg:col-4">
              <div class="lb-card">
                <div class="flex align-items-center gap-3">
                  <img :src="getAvatarByStaffId(p.staffid)" class="lb-avatar" alt="avatar" @error="(e)=>onImgError(e, p.displayName)" />
                  <div class="flex-1">
                    <button class="lb-name-btn" @click="openDailyTaskDetail(findProductByStaffId(p.staffid))" :title="'ดูรายละเอียดของ ' + p.displayName">
                      <span class="lb-name">{{ p.displayName }}</span>
                      <i class="pi pi-list ml-2 text-primary-600"></i>
                    </button>
                    <div class="lb-pos text-500">{{ p.posnameth || '-' }}</div>
                  </div>
                  <Tag :value="p.total.toLocaleString()" severity="info" />
                </div>

                <div class="mt-3 grid text-center">
                  <div class="col-4">
                    <div class="text-500 text-sm">งานหลัก</div>
                    <div class="lb-num success">{{ p.main }}</div>
                  </div>
                  <div class="col-4">
                    <div class="text-500 text-sm">ตำแหน่งอื่น</div>
                    <div class="lb-num warning">{{ p.otherPos }}</div>
                  </div>
                  <div class="col-4">
                    <div class="text-500 text-sm">อื่นๆ</div>
                    <div class="lb-num info">{{ p.other }}</div>
                  </div>
                </div>

                <ProgressBar :value="p.progressPercent" class="mt-2" />
              </div>
            </div>
          </div>
        </div>
        <!-- ===== /Leaderboard ===== -->

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

            <div class="p-4 dashboard-section">
              <div class="grid p-fluid">
                <div class="col-12 lg:col-4">
                  <Card class="h-full">
                    <template #title>
                      <div class="flex align-items-center">
                        <i class="pi pi-chart-pie mr-2 text-primary"></i>
                        ภาพรวมภาระงาน
                      </div>
                    </template>
                    <template #content>
                      <div class="h-full flex flex-column justify-content-center">
                        <Chart type="pie" :data="taskTypeData" :options="taskTypeOptionsSmall" />
                      </div>
                    </template>
                  </Card>
                </div>

                <div class="col-12 lg:col-4">
                  <Card class="h-full">
                    <template #title>
                      <div class="flex align-items-center">
                        <i class="pi pi-clock mr-2 text-primary"></i>
                        เวลารวม (นาที)
                      </div>
                    </template>
                    <template #content>
                      <div class="h-full flex flex-column justify-content-center">
                        <Chart type="bar" :data="timeSpentData" :options="timeSpentOptions" class="w-full" />
                      </div>
                    </template>
                  </Card>
                </div>

                <div class="col-12 lg:col-4">
                  <Card class="h-full">
                    <template #title>
                      <div class="flex align-items-center">
                        <i class="pi pi-check-circle mr-2 text-primary"></i>
                        สถานะภาระงาน
                      </div>
                    </template>
                    <template #content>
                      <div class="h-full flex flex-column align-items-center justify-content-center">
                        <div class="chart-container">
                          <Chart type="doughnut" :data="taskStatusData" :options="taskStatusOptions" />
                          <div class="chart-label">
                            <span class="text-2xl font-bold">{{ totalPlans }}</span>
                            <span class="text-sm text-500">แผนทั้งหมด</span>
                          </div>
                        </div>
                        <div class="grid w-full mt-3 text-center">
                          <div class="col-4">
                            <div class="status-legend-item pending"></div>
                            <span class="block text-500 font-medium mt-1">รอดำเนินการ</span>
                            <div class="text-xl font-bold">{{ planStatusCounts.pending }}</div>
                          </div>
                          <div class="col-4">
                            <div class="status-legend-item in-progress"></div>
                            <span class="block text-500 font-medium mt-1">อยู่ระหว่างดำเนินการ</span>
                            <div class="text-xl font-bold">{{ planStatusCounts.inProgress }}</div>
                          </div>
                          <div class="col-4">
                            <div class="status-legend-item completed"></div>
                            <span class="block text-500 font-medium mt-1">เสร็จสิ้น</span>
                            <div class="text-xl font-bold">{{ planStatusCounts.completed }}</div>
                          </div>
                        </div>
                      </div>
                    </template>
                  </Card>
                </div>
              </div>
            </div>

            <Divider />

            <!-- ตารางแผนของบุคคล -->
            <DataTable :value="personPlansSortedByNumber" v-model:expandedRows="expandedPlansPerson" dataKey="planLabel" responsiveLayout="scroll" stripedRows>
              <Column header="ประเภทแผน" style="width: 9rem; min-width: 8rem; text-align:center;">
                <template #body="slotProps">
                  <Tag :value="getPlanType(slotProps.data)" :severity="getPlanTypeSeverity(getPlanType(slotProps.data))" class="font-semibold" />
                </template>
              </Column>
              <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width: 12rem">
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
              <Column header="ความคืบหน้า">
                <template #body="slotProps">
                  <span class="mr-2 text-sm text-primary-600 font-bold">{{ getPlanProgress(slotProps.data) }}%</span>
                  <ProgressBar :value="getPlanProgress(slotProps.data)" class="flex-1" />
                </template>
              </Column>
              <Column header="สถานะ">
                <template #body="slotProps">
                  <Tag :value="getPlanStatusLabel(slotProps.data)"
                      :severity="getPlanStatusSeverity(slotProps.data)"
                      class="font-bold" />
                </template>
              </Column>
              <Column header="รายละเอียด" style="width:8rem; text-align:center;">
                <template #body="slotProps">
                  <Button label="รายละเอียด" icon="pi pi-search" class="p-button-sm px-3 py-1 rounded-full bg-sky-500 text-white hover:bg-sky-600 transition" @click="(e) => openPlanDrawer(e, slotProps.data)" />
                </template>
              </Column>

              <template #expansion="slotProps">
                <div class="p-4 bg-gray-50 border-round-xl ml-4">
                  <div class="text-xl font-bold text-700 flex items-center mb-3">
                    <i class="pi pi-list mr-2 text-primary-500"></i>
                    ขั้นตอน/กิจกรรมการทำงาน
                  </div>
                  <DataTable :value="slotProps.data.steps" v-model:expandedRows="expandedStepsPerson" dataKey="id" responsiveLayout="scroll">
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
                    <template #expansion="stepProps">
                      <div class="p-4 bg-gray-100 border-round-xl ml-4">
                        <div class="text-lg font-bold text-700 flex items-center mb-3">
                          <i class="pi pi-calendar-check mr-2 text-primary-500"></i>
                          ภาระงานประจำวัน
                        </div>
                        <DataTable :value="stepProps.data.tasks" responsiveLayout="scroll" stripedRows :class="{ 'p-datatable-gridlines': true }">
                          <Column header="ประเภทภาระงาน" style="width: 10rem">
                            <template #body="taskProps">
                              <Tag :value="taskProps.data.taskType || 'ไม่ระบุ'" :severity="taskProps.data.taskType === 'งานหลัก' ? 'success' : taskProps.data.taskType === 'งานตำแหน่งอื่น' ? 'warning' : taskProps.data.taskType === 'งานอื่นๆ' ? 'info' : 'secondary'" />
                            </template>
                          </Column>
                          <Column header="ภาระงานหลัก" style="width: 12rem">
                            <template #body="taskProps">
                              <Tag v-if="taskProps.data.mainTask" :value="getMainTaskLabel(taskProps.data.mainTask)" severity="info" />
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
                              <Dropdown :modelValue="taskProps.data.status" :options="taskStatuses" class="w-full" disabled :class="getTaskStatusSeverityByValue(taskProps.data.status) + '-tag-dropdown'" />
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

            <!-- Drawer รายละเอียดแผน -->
            <Sidebar v-model:visible="planSidebarVisible" position="right" :modal="true" :dismissable="true" style="width: 920px; max-width: 100vw;">
              <template #header>
                <div class="flex items-center gap-3">
                  <i class="pi pi-briefcase text-primary text-xl"></i>
                  <div class="flex flex-column">
                    <span class="text-lg font-bold line-clamp-1">{{ selectedPlan?.planLabel || '-' }}</span>
                    <small class="text-600">
                      <i class="pi pi-user mr-1"></i>{{ (selectedPlan?.owner ?? []).map(o=>o.name).join(', ') || '-' }}
                    </small>
                  </div>
                </div>
              </template>
              <div v-if="selectedPlan" class="detail-wrap">
                <div class="summary">
                  <div class="summary-item"><i class="pi pi-calendar text-600 mr-2"></i>{{ formatDate(selectedPlan.startDate) }} - {{ formatDate(selectedPlan.endDate) }}</div>
                  <div class="summary-item"><i class="pi pi-chart-line text-600 mr-2"></i>ความคืบหน้า: <b>{{ getPlanProgress(selectedPlan) }}%</b></div>
                  <div class="summary-item"><i class="pi pi-clock text-600 mr-2"></i>เวลารวม: <b>{{ getPlanTotalMinutes(selectedPlan).toLocaleString() }}</b> นาที</div>
                </div>

                <div class="legend">
                  <span class="dot bg-gray-400"></span> รอดำเนินการ
                  <span class="dot bg-yellow-500 ml-3"></span> อยู่ระหว่างดำเนินการ
                  <span class="dot bg-green-500 ml-3"></span> เสร็จสิ้น
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

            <div v-if="personPlans.length === 0" class="flex flex-col items-center justify-center p-8">
              <i class="pi pi-inbox text-5xl text-gray-400 mb-3"></i>
              <p class="text-gray-500">ไม่พบแผน/ภาระงานของบุคคลนี้</p>
            </div>

            <template #footer>
              <Button label="ปิด" severity="danger" @click="dailyTaskDialogVisible = false" />
            </template>
          </Dialog>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import { useAuth } from '#imports';
import Chart from 'primevue/chart';
import Card from 'primevue/card';
import Divider from 'primevue/divider';
import Sidebar from 'primevue/sidebar';

const { getSession } = await useAuth();

/* ---------- CONFIG ---------- */
const API = 'http://127.0.0.1:8000/api';
const profileImageUrl = 'https://pd.msu.ac.th/staff/picture/';

const staffIdMain = ref('');
const facIdMain = ref('');
const groupIdMain = ref('');

const selectedEvaluationRound = ref(null);
const evaluationRounds = ref([]);
const products = ref([]);

const dailyTaskDialogVisible = ref(false);
const currentStaffDetail = ref(null);

const personPlans = ref([]);
const expandedPlansPerson = ref([]);
const expandedStepsPerson = ref([]);

const taskStatuses = ['รอดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น'];

/* ===== Drawer state ===== */
const selectedPlan = ref(null);
const planSidebarVisible = ref(false);

function openPlanDrawer(_, plan) {
  selectedPlan.value = plan;
  planSidebarVisible.value = true;
}

/* ===== Leaderboard ===== */
const leaderboard = ref([]);
const sortKey = ref('total');
const sortOptions = [
  { label: 'รวมมาก → น้อย', value: 'total' },
  { label: 'งานหลักมาก → น้อย', value: 'main' },
  { label: 'ตำแหน่งอื่นมาก → น้อย', value: 'otherPos' },
  { label: 'งานอื่นๆมาก → น้อย', value: 'other' },
  { label: 'ชื่อ (ก-ฮ)', value: 'name' },
];

const displayNameOfStaff = (s) => `${s?.prefixfullname || ''} ${s?.namefully || s?.staffname || ''}`.trim();

function findProductByStaffId(staffid) { return products.value.find(x => String(x.staffid) === String(staffid)) || null; }
function getAvatarByStaffId(staffid) { return `${profileImageUrl}${staffid}.jpg`; }
function onImgError(e, name = 'User') { e.target.src = 'https://ui-avatars.com/api/?background=EEE&color=444&name=' + encodeURIComponent(name); }

function accumulateFromPlans(plans) {
  // นับจำนวนงานหลัก/ตำแหน่งอื่น/อื่นๆ ยังใช้ tasks เหมือนเดิม
  const tasks = [];
  (plans || []).forEach(pl =>
    (pl.steps || []).forEach(st =>
      (st.tasks || []).forEach(t => tasks.push(t))
    )
  );
  const { main, otherPos, other } = tallyByType(tasks, PIE_MODE);
  const total = main + otherPos + other;

  // >>> คิด progress ตาม "step"
  let stepTotal = 0, score = 0;
  (plans || []).forEach(pl =>
    (pl.steps || []).forEach(st => {
      stepTotal++;
      const s = normalizeStatus(st.status);
      score += s === 'เสร็จสิ้น' ? 1 : s === 'อยู่ระหว่างดำเนินการ' ? 0.5 : 0;
    })
  );
  const progressPercent = stepTotal ? Math.round((score / stepTotal) * 100) : 0;

  return { main, otherPos, other, total, progressPercent };
}

const PIE_MODE = 'count';
function classifyTaskType(t) {
  const raw = (t?.taskType ?? t?.workload_type ?? t?.mainTask ?? '').toString().trim();
  if (raw === 'งานหลัก') return 'งานหลัก';
  if (raw === 'งานตำแหน่งอื่น') return 'งานตำแหน่งอื่น';
  if (raw === 'งานอื่นๆ') return 'งานอื่นๆ';
  return 'งานอื่นๆ';
}
function tallyByType(tasks, mode = 'count') {
  const acc = { main: 0, otherPos: 0, other: 0 };
  (tasks || []).forEach(t => { const k = classifyTaskType(t); const plus = mode === 'minutes' ? getTaskMinutes(t) : 1; if (k === 'งานหลัก') acc.main += plus; else if (k === 'งานตำแหน่งอื่น') acc.otherPos += plus; else acc.other += plus; });
  return acc;
}

async function buildLeaderboard() {
  if (!selectedEvaluationRound.value || !products.value.length) { leaderboard.value = []; return; }
  const fac = selectedEvaluationRound.value.fac_id;
  const jobs = products.value.map(async (s) => {
    try {
      const { data } = await axios.post(`${API}/showplannew`, { staff_id: s.staffid, fac_id: fac });
      const plans = mapApiToState(data?.data || []);
      const acc = accumulateFromPlans(plans);
      return { staffid: s.staffid, displayName: displayNameOfStaff(s), posnameth: s.posnameth || '', ...acc };
    } catch {
      return { staffid: s.staffid, displayName: displayNameOfStaff(s), posnameth: s.posnameth || '', main: 0, otherPos: 0, other: 0, total: 0, progressPercent: 0 };
    }
  });
  leaderboard.value = await Promise.all(jobs);
}

const leaderboardSorted = computed(() => {
  const arr = [...leaderboard.value];
  switch (sortKey.value) {
    case 'name': return arr.sort((a,b) => a.displayName.localeCompare(b.displayName, 'th'));
    case 'main': return arr.sort((a,b) => b.main - a.main);
    case 'otherPos': return arr.sort((a,b) => b.otherPos - a.otherPos);
    case 'other': return arr.sort((a,b) => b.other - a.other);
    case 'total':
    default: return arr.sort((a,b) => b.total - a.total);
  }
});

onMounted(async () => {
  const session = await getSession();
  if (session?.user?.name) {
    const { STAFFID, SCOPES } = session.user.name;
    const { staffdepartment, groupid } = SCOPES || {};
    staffIdMain.value = String(STAFFID || '');
    facIdMain.value = String(staffdepartment || '');
    groupIdMain.value = String(groupid || '');
    await fetchEvaluationRounds();
    if (evaluationRounds.value.length > 0) {
      selectedEvaluationRound.value = evaluationRounds.value[0];
      await fetchStaffAndDailyTasks();
    }
  }
});

/* ---------- utils / format ---------- */
function formatDate(dateLike) {
  const d = dateLike instanceof Date ? dateLike : new Date(dateLike);
  if (!d || isNaN(d)) return '';
  return d.toLocaleDateString('th-TH', { year: 'numeric', month: '2-digit', day: '2-digit' });
}

function parseDateLoose(v) {
  if (!v) return null;
  if (v instanceof Date) return isNaN(v) ? null : v;
  if (typeof v === 'number') return new Date(v);
  const s = String(v).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) return new Date(s.replace(' ', 'T'));
  let m = s.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
  if (m) { let [, dd, mm, yyyy] = m; let y = parseInt(yyyy, 10); if (y > 2400) y -= 543; return new Date(y, parseInt(mm, 10) - 1, parseInt(dd, 10)); }
  m = s.match(/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})$/);
  if (m) { let [, yyyy, mm, dd] = m; let y = parseInt(yyyy, 10); if (y > 2400) y -= 543; return new Date(y, parseInt(mm, 10) - 1, parseInt(dd, 10)); }
  const t = s.match(/^(\d{1,2}):(\d{2})(?::(\d{2}))?$/);
  if (t) { const now = new Date(); return new Date(now.getFullYear(), now.getMonth(), now.getDate(), parseInt(t[1], 10), parseInt(t[2], 10), t[3] ? parseInt(t[3], 10) : 0); }
  const d = new Date(s); return isNaN(d) ? null : d;
}

function displayNameOf(o) {
  if (!o) return '';
  if (typeof o === 'string') return o;
  if (typeof o === 'number') return `รหัส ${o}`;
  const parts = [];
  const prefix = o.prefixfullname || o.prefix || '';
  const first = o.name || o.staffname || o.firstname || o.first_name || o.namefully || '';
  const last = o.staffsurname || o.lastname || o.last_name || '';
  const full = o.fullname || o.full_name || o.namefully;
  if (full) return full;
  if (prefix) parts.push(prefix);
  if (first) parts.push(first);
  if (last) parts.push(last);
  return parts.join(' ').trim();
}

function normalizeStatus(v) {
  if (v === undefined || v === null) return 'รอดำเนินการ';
  if (typeof v === 'number') { if (v === 2 || v === 3) return 'เสร็จสิ้น'; if (v === 1 || v === 2) return 'อยู่ระหว่างดำเนินการ'; return 'รอดำเนินการ'; }
  const s = String(v).trim().toLowerCase();
  if (['done', 'finished', 'complete', 'completed', 'เสร็จ', 'เสร็จสิ้น'].includes(s)) return 'เสร็จสิ้น';
  if (['progress', 'inprogress', 'processing', 'อยู่ระหว่างดำเนินการ'].includes(s)) return 'อยู่ระหว่างดำเนินการ';
  return 'รอดำเนินการ';
}

function getPlanProgress(plan) {
    if (!plan?.steps?.length) return 0;
    const total = plan.steps.length;
    let score = 0;
    for (const st of plan.steps) {
      score += st.status === 'เสร็จสิ้น' ? 1
            : st.status === 'อยู่ระหว่างดำเนินการ' ? 0.5
            : 0;
    }
    return Math.round((score / total) * 100);
}

function getPlanStatusLabel(plan){
  if(!plan?.steps?.length) return 'รอดำเนินการ';
  const total = plan.steps.length;
  const done = plan.steps.filter(st=> (st.status ?? st.status_planstep) === 'เสร็จสิ้น').length;
  if (done === total) return 'เสร็จสิ้น';
  const inProgress = plan.steps.some(st => (st.status ?? st.status_planstep) === 'อยู่ระหว่างดำเนินการ');
  return (inProgress || done > 0) ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ';
}
function getPlanStatusSeverity(plan){
  const s = getPlanStatusLabel(plan);
  return s==='เสร็จสิ้น' ? 'success'
       : s==='อยู่ระหว่างดำเนินการ' ? 'warning'
       : 'info';
}




function getStepProgress(step) { if (!step) return 0; if (step.status === 'เสร็จสิ้น') return 100; if (step.status === 'อยู่ระหว่างดำเนินการ') return 50; return 0; }
function getStepStatus(step) {
  return normalizeStatus(step?.status ?? step?.status_planstep ?? step?.rawStatus ?? null);
}
function getStepSeverity(step) {
  const st = getStepStatus(step);
  return st === 'เสร็จสิ้น' ? 'success'
       : st === 'อยู่ระหว่างดำเนินการ' ? 'warning'
       : 'info';
}

function getTaskDueDateSeverity(dueDate) { if (!dueDate) return 'info'; const now = new Date(); const due = dueDate instanceof Date ? dueDate : new Date(dueDate); due.setHours(23,59,59,999); return due < now ? 'danger' : 'success'; }
function getTaskMinutes(task) { const start = parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start); const end = parseDateLoose(task?.endTime ?? task?.time_end ?? task?.end_time ?? task?.work_end); if (!start || !end) return 0; const diffMs = Math.max(0, end - start); return Math.round(diffMs / 60000); }
function getTaskTimeSpent(task) { const mins = getTaskMinutes(task); if (mins === 0) { const hasStart = !!parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start); const hasEnd = !!parseDateLoose(task?.endTime ?? task?.time_end ?? task?.end_time ?? task?.work_end); return (hasStart && hasEnd) ? '0 นาที' : 'ยังไม่ระบุ'; } return `${mins} นาที`; }
function getStepTotalMinutes(step) { if (!step?.tasks?.length) return 0; return step.tasks.reduce((sum, t) => sum + getTaskMinutes(t), 0); }
function getPlanTotalMinutes(plan) { if (!plan?.steps?.length) return 0; return plan.steps.reduce((sum, st) => sum + getStepTotalMinutes(st), 0); }
function getTaskStatusSeverityByValue(status) { const s = normalizeStatus(status); return s === 'เสร็จสิ้น' ? 'success' : s === 'อยู่ระหว่างดำเนินการ' ? 'warning' : 'info'; }
function getMainTaskLabel(mainTask) { return mainTask || 'ยังไม่เลือก'; }

function findOwner(o) {
  if (!o) return null;
  const id = o.id ?? o.staffid ?? o.STAFFID ?? o.user_id ?? (typeof o === 'number' ? o : null);
  return { id, name: displayNameOf(o) || (typeof o === 'string' ? o : (id != null ? String(id) : '')) };
}
function toOwnerArray(v) {
  if (!v) return [];
  if (Array.isArray(v)) return v.map(item => (item && typeof item === 'object') ? findOwner(item) : (typeof item === 'number' ? { id: item, name: String(item) } : { id: null, name: String(item ?? '') }));
  if (typeof v === 'string') return v.split(',').map(s => { const t = s.trim(); return { id: /^\d+$/.test(t) ? Number(t) : null, name: t }; });
  if (typeof v === 'object') return [findOwner(v)];
  return [];
}
function ownersFromAny(p) { return toOwnerArray(p?.owner ?? p?.owners ?? p?.ownerIds ?? p?.owner_ids ?? p?.responsible ?? null); }
function mapApiToState(arr) {
  return (arr || []).map(p => ({
    ...p,
    startDate: p.startDate ? new Date(p.startDate) : null,
    endDate: p.endDate ? new Date(p.endDate) : null,
    owner: ownersFromAny(p),
    ownerNames: ownersFromAny(p).map(o => o.name).join(', '),
    steps: (p.steps || []).map(s => ({
      ...s,
      status: normalizeStatus(s.status_planstep ?? s.status ?? s.status_plan ?? null),
      rawStatus: s.status_planstep ?? s.status ?? s.status_plan ?? null,
      owner: ownersFromAny(s),
      ownerNames: ownersFromAny(s).map(o => o.name).join(', '),
      startDate: s.startDate ? new Date(s.startDate) : null,
      endDate: s.endDate ? new Date(s.endDate) : null,
      tasks: (s.tasks || []).map(t => ({
        ...t,
        responsible: ownersFromAny(t),
        taskType: t.taskType ?? t.workload_type ?? null,
        mainTask: t.mainTask ?? t.Main_tasks ?? null,
        dueDate: t.dueDate ? new Date(t.dueDate) : null,
        startTime: t.startTime ? new Date(t.startTime) : null,
        endTime: t.endTime ? new Date(t.endTime) : null,
        createdDate: t.createdDate ? new Date(t.createdDate) : null,
      })),
    })),
  }));
}

/* ---------- Dashboards ---------- */
const allTasks = computed(() => {
  const tasks = [];
  (personPlans.value || []).forEach(plan => (plan.steps || []).forEach(step => tasks.push(...(step.tasks || []))));
  return tasks;
});
 
const totalTasks = computed(() => allTasks.value.length);

const taskTypeData = computed(() => {
  const { main, otherPos, other } = tallyByType(allTasks.value, PIE_MODE);
  return {
    labels: ['งานหลัก', 'งานตำแหน่งอื่น', 'งานอื่นๆ'],
    datasets: [{
      data: [main, otherPos, other],
      backgroundColor: TYPE_COLORS,
      hoverBackgroundColor: TYPE_HOVERS
    }]
  };
});
const taskTypeOptions = { plugins: { legend: { position: 'bottom' }, tooltip: { callbacks: { label: (ti) => { const total = ti.dataset.data.reduce((s, v) => s + v, 0); const value = ti.raw; const pct = total > 0 ? ((value / total) * 100).toFixed(2) + '%' : '0.00%'; return `${ti.label}: ${value} (${pct})`; } } } } };
const taskTypeOptionsSmall = taskTypeOptions;


const planStatusCounts = computed(() => {
  let pending = 0, inProgress = 0, completed = 0;
  (personPlans.value || []).forEach(p => {
    const s = getPlanStatusLabel(p);
    if (s === 'เสร็จสิ้น') completed++;
    else if (s === 'อยู่ระหว่างดำเนินการ') inProgress++;
    else pending++;
  });
  return { pending, inProgress, completed };
});

const totalPlans = computed(() => personPlans.value.length);

  

const BAR_COLORS  = ['#FACC15', '#34D399', '#60A5FA'];
const BAR_HOVERS  = ['#EAB308', '#10B981', '#3B82F6'];
const BAR_BORDERS = ['#D4AF0A', '#0EA5A2', '#2563EB'];
const TYPE_COLORS = ['#42A5F5', '#66BB6A', '#FFA726'];       // ฟ้า, เขียว, ส้ม
const TYPE_HOVERS = ['#64B5F6', '#81C784', '#FFB74D']; 

const timeSpentData = computed(() => {
  const typeOf = (t) => t.taskType ?? t.mainTask ?? '';
  const mainMinutes = allTasks.value.filter(t => typeOf(t) === 'งานหลัก').reduce((s, t) => s + getTaskMinutes(t), 0);
  const otherPosMinutes = allTasks.value.filter(t => typeOf(t) === 'งานตำแหน่งอื่น').reduce((s, t) => s + getTaskMinutes(t), 0);
  const otherMinutes = allTasks.value.filter(t => typeOf(t) === 'งานอื่นๆ').reduce((s, t) => s + getTaskMinutes(t), 0);
  return {
    labels: ['งานหลัก', 'งานตำแหน่งอื่น', 'งานอื่นๆ'],
    datasets: [{
      label: 'เวลารวม (นาที)',
      data: [mainMinutes, otherPosMinutes, otherMinutes],
      backgroundColor: TYPE_COLORS,
      hoverBackgroundColor: TYPE_HOVERS
    }]
  };
});
const timeSpentOptions = { plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } };

const taskStatusCounts = computed(() => {
  let pending = 0, inProgress = 0, completed = 0;
  allTasks.value.forEach(t => { const s = normalizeStatus(t.status); if (s === 'รอดำเนินการ') pending++; else if (s === 'อยู่ระหว่างดำเนินการ') inProgress++; else completed++; });
  return { pending, inProgress, completed };
});
const taskStatusData = computed(() => {
  const c = planStatusCounts.value;
  return {
    labels: ['รอดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น'],
    datasets: [{
      data: [c.pending, c.inProgress, c.completed],
      backgroundColor: ['#9ca3af', '#f59e0b', '#22c55e'],
      hoverBackgroundColor: ['#6b7280', '#d97706', '#16a34a']
    }]
  };
});
const taskStatusOptions = {
  cutout: '60%',
  plugins: { legend: { display: false } }
};

/* ---------- API ---------- */
async function fetchEvaluationRounds() {
  try {
    const res = await axios.post(`${API}/showDateSetleader`, { staff_id: staffIdMain.value, fac_id: facIdMain.value, group_id: groupIdMain.value });
    evaluationRounds.value = res.data;
  } catch { Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดรอบการประเมินได้' }); }
}
function statusClass(s) { const st = String(s || '').trim(); if (st.includes('เสร็จ')) return 'is-done'; if (st.includes('ระหว่าง')) return 'is-progress'; return 'is-pending'; }
function typeClass(s) { if (s === 'งานหลัก') return 'chip-main'; if (s === 'งานตำแหน่งอื่น') return 'chip-otherpos'; return 'chip-other'; }

async function fetchStaffAndDailyTasks() {
  if (!selectedEvaluationRound.value) { Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมิน', 'error'); return; }
  try {
    const res = await axios.get(`${API}/showDataEvalu`, { params: { staff_id: staffIdMain.value, fac_id: selectedEvaluationRound.value.fac_id, group_id: groupIdMain.value, evalua: selectedEvaluationRound.value.evalua, p_year: selectedEvaluationRound.value.d_date } });
    products.value = (res.data || []).filter(item => item.stftypename !== 'ลูกจ้างชั่วคราว' && item.stftypename !== 'พนักงานราชการ');
    await buildLeaderboard();
  } catch { Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลผู้รับการประเมินได้' }); }
}

async function openDailyTaskDetail(staffData) {
  if (!selectedEvaluationRound.value) { Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน', 'error'); return; }
  if (!staffData) { Swal.fire('แจ้งเตือน', 'ไม่พบข้อมูลพนักงาน', 'error'); return; }
  currentStaffDetail.value = staffData; dailyTaskDialogVisible.value = true; personPlans.value = [];
  try {
    const { data } = await axios.post(`${API}/showplannew`, { staff_id: staffData.staffid, fac_id: selectedEvaluationRound.value.fac_id });
    personPlans.value = mapApiToState(data?.data || []);
    if (!personPlans.value.length) {
      const alt = await axios.post(`${API}/getDataplans`, { staffid: staffData.staffid, facid: selectedEvaluationRound.value.fac_id });
      personPlans.value = mapApiToState(alt.data?.plans || []);
    }
  } catch {
    personPlans.value = []; Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลภาระงานประจำวันได้' });
  }
}

const personPlansSortedByNumber = computed(() => [...personPlans.value].sort((a, b) => { const numA = parseInt((a.planLabel || '').replace(/[^0-9]/g, ''), 10) || 0; const numB = parseInt((b.planLabel || '').replace(/[^0-9]/g, ''), 10) || 0; return numA - numB; }));
function getPlanType(p) { return (p?.planType ?? p?.plan_type ?? 'ไม่ระบุ') || 'ไม่ระบุ'; }
function getPlanTypeSeverity(t) { switch (t) { case 'แผนปฏิบัติการ': return 'success'; case 'โครงการ': return 'danger'; case 'นโยบาย': return 'warning'; case 'มติประชุม': return 'info'; case 'ไม่ระบุ': return 'secondary'; default: return 'secondary'; } }
function getStepOwnerNames(st) { const arr = ownersFromAny(st); if (arr.length) return arr.map(o => o.name).join(', '); const planOwners = ownersFromAny(selectedPlan.value || {}); if (planOwners.length) return planOwners.map(o => o.name).join(', '); return selectedPlan.value?.ownerNames || '-'; }

/* ---------- expose (ปลอดภัยที่จะคงไว้) ---------- */
defineExpose({
  formatDate,
  getMainTaskLabel,
  getPlanProgress,
  getStepProgress,
  getStepStatus,
  getStepSeverity,
  getTaskDueDateSeverity,
  getTaskTimeSpent,
  getTaskStatusSeverityByValue,
  fetchEvaluationRounds,
  fetchStaffAndDailyTasks,
  openDailyTaskDetail
});
</script>

<style>
:root { --surface-bg: #f9fafb; --card-bg: #ffffff; }
.p-dialog .p-dialog-content { background-color: var(--surface-bg); }
.card-header { text-align: left; margin: 0; padding: 0; }

/* ===== Leaderboard styles ===== */
.lb-card { background: #fff; border-radius: 14px; padding: 14px; box-shadow: 0 4px 14px rgba(0,0,0,.06); border: 1px solid #f0f0f0; }
.lb-avatar { width: 44px; height: 44px; border-radius: 9999px; object-fit: cover; border: 2px solid #e5e7eb; transition: transform 0.3s ease; }
.lb-avatar:hover { transform: scale(3); z-index: 10; position: relative; }
.lb-name-btn { background: transparent; border: 0; padding: 0; cursor: pointer; display: inline-flex; align-items: center; }
.lb-name-btn:hover .lb-name { text-decoration: underline; }
.lb-name { font-weight: 700; }
.lb-pos { font-size: .9rem; }
.lb-num { font-size: 1.25rem; font-weight: 800; }
.lb-num.success { color: #16a34a; }
.lb-num.warning { color: #d97706; }
.lb-num.info { color: #2563eb; }

/* Card (PrimeVue) */
.p-card { background-color: var(--card-bg); box-shadow: 0 4px 6px rgba(0,0,0,0.08); border-radius: 12px; border: none; }
.p-card .p-card-content { height: calc(100% - 3.5rem); }

/* ===== Timeline ===== */
.detail-wrap { padding: 8px 6px 24px; }
.summary { display:flex; flex-wrap:wrap; gap:12px; background:#f8fafc; border:1px solid #eef2f7; border-radius:12px; padding:10px 12px; margin-bottom:10px; }
.summary-item { display:flex; align-items:center; color:#475569; }
.legend { color:#64748b; margin:6px 2px 14px; display:flex; align-items:center; }
.legend .dot { width:10px; height:10px; border-radius:9999px; display:inline-block; margin-right:6px; }
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
.line-clamp-1 { display:-webkit-box; -webkit-line-clamp:1; -webkit-box-orient:vertical; overflow:hidden; }
.step-right { display:flex; align-items:center; gap:.25rem; }
.step-owners { max-width:360px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
@media (max-width:640px){ .step-owners { max-width:180px; } }
.chart-container { position: relative; width: 100%; max-width: 280px; margin: 0 auto; }
.chart-label {
  position: absolute; inset: 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  pointer-events: none;
}

/* จุดกลมสถานะใน legend */
.status-legend-item { width: 10px; height: 10px; border-radius: 9999px; margin: 0 auto 6px; }
.status-legend-item.pending { background: #9ca3af; }       /* เทา */
.status-legend-item.in-progress { background: #f59e0b; }   /* เหลือง */
.status-legend-item.completed { background: #22c55e; }     /* เขียว */
 
</style>
