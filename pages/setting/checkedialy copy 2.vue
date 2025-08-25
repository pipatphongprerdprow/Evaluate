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
        </div>

        <!-- ===== Leaderboard / ชาเล้นภาระงาน ===== -->
        <div class="card p-3 mb-3">
          <div class="flex align-items-center justify-content-between mb-3">
            <div class="flex align-items-center gap-2">
              <i class="pi pi-trophy text-yellow-500 text-2xl"></i>
              <h3 class="m-0">ชาเล้นภาระงาน (Leaderboard)</h3>
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
            <div
              v-for="p in leaderboardSorted"
              :key="p.staffid"
              class="col-12 md:col-6 lg:col-4"
            >
              <div class="lb-card">
                <div class="flex align-items-center gap-3">
                  <img :src="getAvatar(p)" class="lb-avatar" alt="avatar" />
                  <div class="flex-1">
                    <div class="lb-name">{{ p.displayName }}</div>
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

        <table class="table">
          <thead>
            <tr style="height: 40px;background-color: #FFFBEA;">
              <th style="width: 40%;">ผู้รับการประเมิน</th>
              <th>ตำแหน่ง</th>
              <th>ดูภาระงาน</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in products" :key="index">
              <td class="staff-name-cell">
                <b style="color: blue;">{{ item.prefixfullname }} {{ item.namefully }}</b>
              </td>
              <td class="text-center staff-position-cell">
                <b>{{ item.posnameth || '' }}</b>
              </td>
              <td class="button-cell">
                <Button
                  label="รายละเอียด"
                  severity="info"
                  icon="pi pi-list"
                  class="detail-button"
                  @click="openDailyTaskDetail(item)"
                />
              </td>
            </tr>
          </tbody>
        </table>

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
                            <span class="text-2xl font-bold">{{ totalTasks }}</span>
                            <span class="text-sm text-500">ภาระงานทั้งหมด</span>
                          </div>
                        </div>
                        <div class="grid w-full mt-3 text-center">
                          <div class="col-4">
                            <div class="status-legend-item pending"></div>
                            <span class="block text-500 font-medium mt-1">ยังไม่เริ่ม</span>
                            <div class="text-xl font-bold">{{ taskStatusCounts.pending }}</div>
                          </div>
                          <div class="col-4">
                            <div class="status-legend-item in-progress"></div>
                            <span class="block text-500 font-medium mt-1">ระหว่างทำ</span>
                            <div class="text-xl font-bold">{{ taskStatusCounts.inProgress }}</div>
                          </div>
                          <div class="col-4">
                            <div class="status-legend-item completed"></div>
                            <span class="block text-500 font-medium mt-1">เสร็จสิ้น</span>
                            <div class="text-xl font-bold">{{ taskStatusCounts.completed }}</div>
                          </div>
                        </div>
                      </div>
                    </template>
                  </Card>
                </div>
              </div>
            </div>

            <Divider />

            <DataTable :value="personPlansSortedByNumber" v-model:expandedRows="expandedPlansPerson" dataKey="id" responsiveLayout="scroll" stripedRows>
              <Column expander style="width: 3rem" />
              <Column header="ประเภทแผน" style="width: 9rem; min-width: 8rem; text-align:center;">
                <template #body="slotProps">
                  <span class="p-column-title">ประเภทแผน</span>
                  <Tag
                    :value="getPlanType(slotProps.data)"
                    :severity="getPlanTypeSeverity(getPlanType(slotProps.data))"
                    class="font-semibold"
                  />
                </template>
              </Column>
              <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width: 12rem" class="font-bold text-primary-800">
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
                              <Tag
                                :value="taskProps.data.taskType || 'ไม่ระบุ'"
                                :severity="
                                  taskProps.data.taskType === 'งานหลัก' ? 'success'
                                  : taskProps.data.taskType === 'งานตำแหน่งอื่น' ? 'warning'
                                  : taskProps.data.taskType === 'งานอื่นๆ' ? 'info'
                                  : 'secondary'
                                "
                              />
                            </template>
                          </Column>
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

const { getSession } = await useAuth();

/* ---------- CONFIG ---------- */
const API = 'http://127.0.0.1:8000/api';

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
]);

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

/* ===== Leaderboard state & helpers ===== */
const leaderboard = ref([]);
const sortKey = ref('total');
const sortOptions = [
  { label: 'รวมมาก → น้อย', value: 'total' },
  { label: 'งานหลักมาก → น้อย', value: 'main' },
  { label: 'ตำแหน่งอื่นมาก → น้อย', value: 'otherPos' },
  { label: 'งานอื่นๆมาก → น้อย', value: 'other' },
  { label: 'ชื่อ (ก-ฮ)', value: 'name' },
];

const displayNameOfStaff = (s) =>
  `${s?.prefixfullname || ''} ${s?.namefully || s?.staffname || ''}`.trim();

function getAvatar(s) {
  if (s?.photoUrl) return s.photoUrl;                // ใช้รูปจาก API ถ้ามี
  // เปลี่ยนเป็น path รูปจริงของระบบคุณได้ เช่น `/uploads/staff/${s.staffid}.jpg`
  return 'https://ui-avatars.com/api/?name=' + encodeURIComponent(s.displayName || 'User');
}

function accumulateFromPlans(plans) {
  let main = 0, otherPos = 0, other = 0, total = 0, totalTasks = 0, completed = 0;
  (plans || []).forEach(pl => {
    (pl.steps || []).forEach(st => {
      (st.tasks || []).forEach(t => {
        totalTasks += 1;
        if ((String(t.status||'')).includes('เสร็จ')) completed += 1;
        const tt = t.taskType || '';
        if (tt === 'งานหลัก') main += 1;
        else if (tt === 'งานตำแหน่งอื่น') otherPos += 1;
        else other += 1;
      });
    });
  });
  total = main + otherPos + other;
  return { main, otherPos, other, total, progressPercent: totalTasks ? Math.round((completed/totalTasks)*100) : 0 };
}

async function buildLeaderboard() {
  if (!selectedEvaluationRound.value || !products.value.length) {
    leaderboard.value = [];
    return;
  }
  const fac = selectedEvaluationRound.value.fac_id;
  const jobs = products.value.map(async (s) => {
    try {
      const { data } = await axios.post(`${API}/showplannew`, {
        staff_id: s.staffid,
        fac_id: fac
      });
      const plans = mapApiToState(data?.data || []);
      const acc = accumulateFromPlans(plans);
      return {
        staffid: s.staffid,
        displayName: displayNameOfStaff(s),
        posnameth: s.posnameth || '',
        photoUrl: s.photoUrl || null,
        ...acc,
      };
    } catch {
      return {
        staffid: s.staffid,
        displayName: displayNameOfStaff(s),
        posnameth: s.posnameth || '',
        photoUrl: s.photoUrl || null,
        main: 0, otherPos: 0, other: 0, total: 0, progressPercent: 0,
      };
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
/* ===== /Leaderboard ===== */

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
function pad(n) { return String(n).padStart(2, '0'); }

function parseDateLoose(v) {
  if (!v) return null;
  if (v instanceof Date) return isNaN(v) ? null : v;
  if (typeof v === 'number') return new Date(v);
  const s = String(v).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) return new Date(s.replace(' ', 'T'));
  let m = s.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$/);
  if (m) {
    let [, dd, mm, yyyy] = m;
    let y = parseInt(yyyy, 10); if (y > 2400) y -= 543;
    return new Date(y, parseInt(mm, 10) - 1, parseInt(dd, 10));
  }
  m = s.match(/^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})$/);
  if (m) {
    let [, yyyy, mm, dd] = m;
    let y = parseInt(yyyy, 10); if (y > 2400) y -= 543;
    return new Date(y, parseInt(mm, 10) - 1, parseInt(dd, 10));
  }
  const t = s.match(/^(\d{1,2}):(\d{2})(?::(\d{2}))?$/);
  if (t) {
    const now = new Date();
    return new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      parseInt(t[1], 10),
      parseInt(t[2], 10),
      t[3] ? parseInt(t[3], 10) : 0
    );
  }
  const d = new Date(s);
  return isNaN(d) ? null : d;
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

function normalizePeople(v) {
  if (!v) return [];
  if (Array.isArray(v)) {
    return v.map(x => {
      if (typeof x === 'string' || typeof x === 'number') return { id: x, name: displayNameOf(x) };
      return {
        id: x.id ?? x.staffid ?? x.STAFFID ?? x.user_id ?? null,
        name: displayNameOf(x) || (x.POSNAMETH ?? '')
      };
    });
  }
  if (typeof v === 'string') {
    return v.split(',').map(s => ({ id: s.trim(), name: s.trim() }));
  }
  return [];
}

function normalizeStatus(v) {
  if (v === undefined || v === null) return 'รอดำเนินการ';
  if (typeof v === 'number') {
    if (v === 2 || v === 3) return 'เสร็จสิ้น';
    if (v === 1 || v === 2) return 'อยู่ระหว่างดำเนินการ';
    return 'รอดำเนินการ';
  }
  const s = String(v).trim().toLowerCase();
  if (['done', 'finished', 'complete', 'completed', 'เสร็จ', 'เสร็จสิ้น'].includes(s)) return 'เสร็จสิ้น';
  if (['progress', 'inprogress', 'processing', 'อยู่ระหว่างดำเนินการ'].includes(s)) return 'อยู่ระหว่างดำเนินการ';
  return 'รอดำเนินการ';
}

function getPlanProgress(plan) {
  if (!plan?.steps?.length) return 0;
  const total = plan.steps.reduce((s, st) => s + (st.tasks?.length || 0), 0);
  if (!total) return 0;
  const done = plan.steps.reduce((s, st) => s + (st.tasks?.filter(t => normalizeStatus(t.status) === 'เสร็จสิ้น').length || 0), 0);
  return Math.round((done / total) * 100);
}
function getStepProgress(step) {
  if (!step?.tasks?.length) return 0;
  const total = step.tasks.length;
  const done = step.tasks.filter(t => normalizeStatus(t.status) === 'เสร็จสิ้น').length;
  return Math.round((done / total) * 100);
}
function getPlanStatusLabel(plan) {
  const p = getPlanProgress(plan);
  return p === 100 ? 'เสร็จสิ้น' : p > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ';
}
function getPlanStatusSeverity(plan) {
  const p = getPlanProgress(plan);
  return p === 100 ? 'success' : p > 0 ? 'warning' : 'info';
}
function getStepStatus(step) {
  const p = getStepProgress(step);
  return p === 100 ? 'เสร็จสิ้น' : p > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ';
}
function getStepSeverity(step) {
  const p = getStepProgress(step);
  return p === 100 ? 'success' : p > 0 ? 'warning' : 'info';
}
function getTaskDueDateSeverity(dueDate) {
  if (!dueDate) return 'info';
  const now = new Date();
  const due = dueDate instanceof Date ? dueDate : new Date(dueDate);
  due.setHours(23, 59, 59, 999);
  return due < now ? 'danger' : 'success';
}
function getTaskTimeSpent(task) {
  const mins = getTaskMinutes(task);
  if (mins === 0) {
    const hasStart = !!parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start);
    const hasEnd = !!parseDateLoose(task?.endTime ?? task?.time_end ?? task?.end_time ?? task?.work_end);
    return (hasStart && hasEnd) ? '0 นาที' : 'ยังไม่ระบุ';
  }
  return `${mins} นาที`;
}

function getTaskMinutes(task) {
  const start = parseDateLoose(task?.startTime ?? task?.time_start ?? task?.start_time ?? task?.work_start);
  const end = parseDateLoose(task?.endTime ?? task?.time_end ?? task?.end_time ?? task?.work_end);
  if (!start || !end) return 0;
  const diffMs = Math.max(0, end - start);
  return Math.round(diffMs / 60000);
}

function getStepTotalMinutes(step) {
  if (!step?.tasks?.length) return 0;
  return step.tasks.reduce((sum, t) => sum + getTaskMinutes(t), 0);
}

function getPlanTotalMinutes(plan) {
  if (!plan?.steps?.length) return 0;
  return plan.steps.reduce((sum, st) => sum + getStepTotalMinutes(st), 0);
}

function getTaskStatusSeverityByValue(status) {
  const s = normalizeStatus(status);
  return s === 'เสร็จสิ้น' ? 'success' : s === 'อยู่ระหว่างดำเนินการ' ? 'warning' : 'info';
}
function getMainTaskLabel(mainTask) {
  return mainTask || 'ยังไม่เลือก';
}

const findOwner = (o) =>
  owners.value.find(x => Number(x.id) === Number(o?.id ?? o)) || null;

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

function ownersFromAny(p) {
  return toOwnerArray(
    p?.owner ?? p?.owners ?? p?.ownerIds ?? p?.owner_ids ?? p?.responsible ?? null
  );
}

function mapApiToState(arr) {
  return (arr || []).map(p => {
    const planOwners = ownersFromAny(p);
    return {
      ...p,
      startDate: p.startDate ? new Date(p.startDate) : null,
      endDate: p.endDate ? new Date(p.endDate) : null,
      owner: planOwners,
      ownerNames: planOwners.map(o => o.name).join(', '),
      steps: (p.steps || []).map(s => {
        const stepOwners = ownersFromAny(s);
        return {
          ...s,
          owner: stepOwners,
          ownerNames: stepOwners.map(o => o.name).join(', '),
          startDate: s.startDate ? new Date(s.startDate) : null,
          endDate: s.endDate ? new Date(s.endDate) : null,
          tasks: (s.tasks || []).map(t => {
            const responsible = ownersFromAny(t);
            return {
              ...t,
              responsible,
              taskType: t.taskType ?? t.workload_type ?? null,
              mainTask: t.mainTask ?? t.Main_tasks ?? null,
              dueDate: t.dueDate ? new Date(t.dueDate) : null,
              startTime: t.startTime ? new Date(t.startTime) : null,
              endTime: t.endTime ? new Date(t.endTime) : null,
              createdDate: t.createdDate ? new Date(t.createdDate) : null,
            };
          }),
        };
      }),
    };
  });
}

/* ---------- Computed Properties for Dashboards ---------- */
const allTasks = computed(() => {
  const tasks = [];
  if (personPlans.value) {
    personPlans.value.forEach(plan => {
      plan.steps.forEach(step => {
        tasks.push(...step.tasks);
      });
    });
  }
  return tasks;
});

const totalTasks = computed(() => allTasks.value.length);

const taskTypeData = computed(() => {
  const main = allTasks.value.filter(t => t.taskType === 'งานหลัก').length
  const otherPos = allTasks.value.filter(t => t.taskType === 'งานตำแหน่งอื่น').length
  const other = allTasks.value.filter(t => t.taskType === 'งานอื่นๆ').length
  return {
    labels: ['งานหลัก', 'งานตำแหน่งอื่น', 'งานอื่นๆ'],
    datasets: [
      {
        data: [main, otherPos, other],
        backgroundColor: ['#42A5F5', '#66BB6A', '#FFA726'],
        hoverBackgroundColor: ['#64B5F6', '#81C784', '#FFB74D']
      }
    ]
  }
});
// ใช้ option เดียวกันสำหรับ Pie ขนาดเล็ก
const taskTypeOptions = {
  plugins: {
    legend: { position: 'bottom' },
    tooltip: {
      callbacks: {
        label: (tooltipItem) => {
          const total = tooltipItem.dataset.data.reduce((sum, val) => sum + val, 0);
          const value = tooltipItem.raw;
          const percentage = total > 0 ? ((value / total) * 100).toFixed(2) + '%' : '0.00%';
          return `${tooltipItem.label}: ${value} (${percentage})`;
        }
      }
    }
  }
};
const taskTypeOptionsSmall = taskTypeOptions;
 
const BAR_COLORS  = ['#FACC15', '#34D399', '#60A5FA'];
const BAR_HOVERS  = ['#EAB308', '#10B981', '#3B82F6'];
const BAR_BORDERS = ['#D4AF0A', '#0EA5A2', '#2563EB'];

const timeSpentData = computed(() => {
  const typeOf = (t) => t.taskType ?? t.mainTask ?? '';

  const mainMinutes = allTasks.value
    .filter(t => typeOf(t) === 'งานหลัก')
    .reduce((sum, t) => sum + getTaskMinutes(t), 0);

  const otherPosMinutes = allTasks.value
    .filter(t => typeOf(t) === 'งานตำแหน่งอื่น')
    .reduce((sum, t) => sum + getTaskMinutes(t), 0);

  const otherMinutes = allTasks.value
    .filter(t => typeOf(t) === 'งานอื่นๆ')
    .reduce((sum, t) => sum + getTaskMinutes(t), 0);

  return {
    labels: ['งานหลัก', 'งานตำแหน่งอื่น', 'งานอื่นๆ'],
    datasets: [
      {
        label: 'เวลารวม (นาที)',
        data: [mainMinutes, otherPosMinutes, otherMinutes],
        backgroundColor: BAR_COLORS,
        hoverBackgroundColor: BAR_HOVERS,
        borderColor: BAR_BORDERS,
        borderWidth: 1
      }
    ]
  };
});
 
const timeSpentOptions = {
  plugins: {
    legend: { display: false }
  },
  scales: {
    y: {
      beginAtZero: true
    }
  }
};

const taskStatusCounts = computed(() => {
  let pending = 0;
  let inProgress = 0;
  let completed = 0;
  allTasks.value.forEach(t => {
    const status = normalizeStatus(t.status);
    if (status === 'รอดำเนินการ') {
      pending++;
    } else if (status === 'อยู่ระหว่างดำเนินการ') {
      inProgress++;
    } else {
      completed++;
    }
  });
  return { pending, inProgress, completed };
});
const taskStatusData = computed(() => {
  const counts = taskStatusCounts.value;
  return {
    labels: ['ยังไม่ดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น'],
    datasets: [
      {
        data: [counts.pending, counts.inProgress, counts.completed],
        backgroundColor: ['#6c757d', '#ffc107', '#28a745'],
        hoverBackgroundColor: ['#5a6268', '#e0a800', '#218838']
      }
    ]
  };
});
const taskStatusOptions = {
  cutout: '60%',
  plugins: {
    legend: { display: false },
    tooltip: {
      callbacks: {
        label: (tooltipItem) => {
          const total = tooltipItem.dataset.data.reduce((sum, val) => sum + val, 0);
          const value = tooltipItem.raw;
          const percentage = total > 0 ? ((value / total) * 100).toFixed(2) + '%' : '0.00%';
          return `${tooltipItem.label}: ${value} (${percentage})`;
        }
      }
    }
  }
};

/* ---------- API ---------- */
async function fetchEvaluationRounds() {
  try {
    const res = await axios.post(`${API}/showDateSetleader`, {
      staff_id: staffIdMain.value,
      fac_id: facIdMain.value,
      group_id: groupIdMain.value
    });
    evaluationRounds.value = res.data;
  } catch {
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดรอบการประเมินได้' });
  }
}

async function fetchStaffAndDailyTasks() {
  if (!selectedEvaluationRound.value) {
    Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมิน', 'error');
    return;
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
    });
    products.value = (res.data || []).filter(
      item => item.stftypename !== 'ลูกจ้างชั่วคราว' && item.stftypename !== 'พนักงานราชการ'
    );
    // ✅ สร้าง leaderboard หลังได้รายชื่อผู้รับการประเมิน
    await buildLeaderboard();
  } catch {
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลผู้รับการประเมินได้' });
  }
}

async function openDailyTaskDetail(staffData) {
  if (!selectedEvaluationRound.value) {
    Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน', 'error');
    return;
  }
  currentStaffDetail.value = staffData;
  dailyTaskDialogVisible.value = true;
  personPlans.value = [];
  try {
    const { data } = await axios.post(`${API}/showplannew`, {
      staff_id: staffData.staffid,
      fac_id: selectedEvaluationRound.value.fac_id
    });
    personPlans.value = mapApiToState(data?.data || []);
    if (!personPlans.value.length) {
      const alt = await axios.post(`${API}/getDataplans`, {
        staffid: staffData.staffid,
        facid: selectedEvaluationRound.value.fac_id
      });
      personPlans.value = mapApiToState(alt.data?.plans || []);
    }
  } catch (e) {
    console.error(e);
    personPlans.value = [];
    Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลภาระงานประจำวันได้' });
  }
}

const personPlansSortedByNumber = computed(() => {
  return [...personPlans.value].sort((a, b) => {
    const numA = parseInt((a.planLabel || '').replace(/[^0-9]/g, ''), 10) || 0
    const numB = parseInt((b.planLabel || '').replace(/[^0-9]/g, ''), 10) || 0
    return numA - numB
  })
})

function getPlanType(p) {
  return (p?.planType ?? p?.plan_type ?? 'ไม่ระบุ') || 'ไม่ระบุ';
}

function getPlanTypeSeverity(t) {
  switch (t) {
    case 'แผนปฏิบัติการ': return 'success';
    case 'โครงการ':        return 'danger';
    case 'นโยบาย':         return 'warning';
    case 'มติประชุม':      return 'info';
    case 'ไม่ระบุ':        return 'secondary';
    default:                return 'secondary';
  }
}

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
});  
</script>

<style>
/* CSS Variables for theme colors */
:root {
  --surface-bg: #f9fafb; /* Light gray */
  --card-bg: #ffffff;    /* White */
}

/* Apply background to the dialog content */
.p-dialog .p-dialog-content {
  background-color: var(--surface-bg);
}

.card-header {
  text-align: left;
  margin: 0;
  padding: 0;
}

.table {
  border-collapse: separate;
  border-spacing: 0 5px;
  width: 100%;
}

.table th {
  background-color: #efefaf;  /* เหลืองอ่อน */
  font-weight: bold;
  padding: 10px;
  border: 1px solid #e0e0e0;
}

.table td {
  border: 1px solid #e0e0e0;
  text-align: center;
  padding: 10px;
}

.table tbody tr {
  transition: background-color 0.3s ease;
}

.table tbody tr:hover {
  background-color: #f5f5f5;
}

.striped-row {
  background-color: #f9f9f9;
}

.p-datatable .p-column-header-content {
  justify-content: center;
}

/* Specific styling for table cells */
.staff-name-cell {
  text-align: left;
  padding-left: 20px;
}
.staff-position-cell {
  text-align: center;
}
.button-cell {
  text-align: center;
}
.detail-button {
  width: 130px;
}

.chart-container {
  position: relative;
  width: 15rem;
  height: 15rem;
}

.chart-label {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: flex;
  flex-direction: column;
  align-items: center;
  line-height: 1.2;
}

.status-legend-item {
  width: 1rem;
  height: 1rem;
  border-radius: 50%;
  margin: auto;
  margin-bottom: 0.25rem;
}

.status-legend-item.pending {
  background-color: #6c757d;
}

.status-legend-item.in-progress {
  background-color: #ffc107;
}

.status-legend-item.completed {
  background-color: #28a745;
}

/* Card Styling */
.p-card {
  background-color: var(--card-bg);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.08);
  border-radius: 12px;
  border: none;
}
.p-card .p-card-content {
  height: calc(100% - 3.5rem);
}

/* ===== Leaderboard styles ===== */
.lb-card {
  background: #fff;
  border-radius: 14px;
  padding: 14px;
  box-shadow: 0 4px 14px rgba(0,0,0,.06);
  border: 1px solid #f0f0f0;
}
.lb-avatar {
  width: 44px;
  height: 44px;
  border-radius: 9999px;
  object-fit: cover;
  border: 2px solid #e5e7eb;
}
.lb-name { font-weight: 700; }
.lb-pos { font-size: .9rem; }
.lb-num { font-size: 1.25rem; font-weight: 800; }
.lb-num.success { color: #16a34a; }   /* งานหลัก */
.lb-num.warning { color: #d97706; }   /* ตำแหน่งอื่น */
.lb-num.info    { color: #2563eb; }   /* งานอื่นๆ */
</style>
