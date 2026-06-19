  <template>
    <!-- DASHBOARD WRAPPER -->
      <div class="tracking-dashboard"> 
          <section class="dash-hero">
              <div>
                  <div class="eyebrow">MSU PERFORMANCE APPRAISAL</div>
                  <h2>Dashboard ตรวจติดตามแบบประเมิน</h2>
                  <p>
                      ภาพรวมสถานะการประเมิน คะแนนเฉลี่ย การกระจายระดับผลประเมิน
                      และรายชื่อผู้รับการประเมิน
                  </p>
              </div>

              <div class="hero-actions">
                  <Dropdown
                      v-model="tracking_date"
                      :options="tracking_dates || []"
                      :optionLabel="(item) => `${item.facuties} ${item.d_evaluationround} ${item.d_date}`"
                      placeholder="กรุณาเลือกรอบการประเมิน"
                      class="round-select"
                  />

                  <Button
                      label="ค้นหา"
                      icon="pi pi-search"
                      :disabled="loading || !tracking_date"
                      @click="xxr"
                  />

                  <Button
                      label="Export PDF"
                      icon="pi pi-file-pdf"
                      severity="danger"
                      outlined
                      :disabled="loading || totalStaff === 0"
                      @click="printDatatrackingpdf"
                  />
              </div>
          </section>

          <!-- LOADING -->
          <div v-if="loading" class="loading-wrap">
              <ProgressSpinner style="width:60px;height:60px" strokeWidth="6" />
              <div class="mt-2">กำลังโหลดข้อมูล…</div>
          </div>

          <!-- KPI DASHBOARD -->
          <section class="kpi-grid">
              <div class="kpi-card primary">
                  <div class="kpi-icon">
                      <i class="pi pi-users"></i>
                  </div>
                  <div>
                      <span>บุคลากรทั้งหมด</span>
                      <strong>{{ totalStaff }}</strong>
                      <small>คนในรอบประเมินที่เลือก</small>
                  </div>
              </div>

              <div class="kpi-card success">
                  <div class="kpi-icon">
                      <i class="pi pi-check-circle"></i>
                  </div>
                  <div>
                      <span>ประเมินแล้ว</span>
                      <strong>{{ completedStaff }}</strong>
                      <small>{{ completedPercent }}% ของทั้งหมด</small>
                  </div>
              </div>

              <div class="kpi-card warning">
                  <div class="kpi-icon">
                      <i class="pi pi-clock"></i>
                  </div>
                  <div>
                      <span>รอข้อมูลประเมิน</span>
                      <strong>{{ pendingStaff }}</strong>
                      <small>ควรติดตามข้อมูลเพิ่มเติม</small>
                  </div>
              </div>

              <div class="kpi-card info">
                  <div class="kpi-icon">
                      <i class="pi pi-chart-line"></i>
                  </div>
                  <div>
                      <span>คะแนนเฉลี่ยรวม</span>
                      <strong>{{ avgTotalScore }}</strong>
                      <small>จากผู้ที่มีข้อมูลประเมิน</small>
                  </div>
              </div>
          </section>

          <!-- SCORE SUMMARY -->
          <section class="dashboard-grid">
              <div class="panel">
                  <div class="panel-head">
                      <div>
                          <h3>ความคืบหน้าการประเมิน</h3>
                          <p>แสดงสัดส่วนผู้ที่มีข้อมูลประเมินแล้ว</p>
                      </div>
                      <Tag :value="`${completedPercent}%`" severity="success" />
                  </div>

                  <ProgressBar :value="completedPercent" />

                  <div class="progress-meta">
                      <span>ประเมินแล้ว {{ completedStaff }} คน</span>
                      <span>รอข้อมูล {{ pendingStaff }} คน</span>
                  </div>
              </div>

              <div class="panel">
                  <div class="panel-head">
                      <div>
                          <h3>คะแนนเฉลี่ยรายองค์ประกอบ</h3>
                          <p>ผลสัมฤทธิ์ / พฤติกรรม / คะแนนรวม</p>
                      </div>
                  </div>

                  <div class="score-summary-grid">
                      <div class="score-box">
                          <span>ผลสัมฤทธิ์ของงาน</span>
                          <strong>{{ avgAchievementScore }}</strong>
                      </div>

                      <div class="score-box">
                          <span>พฤติกรรมฯ</span>
                          <strong>{{ avgBehaviorScore }}</strong>
                      </div>

                      <div class="score-box highlight">
                          <span>คะแนนรวม</span>
                          <strong>{{ avgTotalScore }}</strong>
                      </div>
                  </div>
              </div>
          </section>

          <!-- LEVEL SUMMARY -->
          <!-- <section class="level-grid">
              <div class="level-card excellent">
                  <span>ดีเด่น</span>
                  <strong>{{ outstandingCount }}</strong>
                  <small>90 - 100 คะแนน</small>
              </div>

              <div class="level-card very-good">
                  <span>ดีมาก</span>
                  <strong>{{ veryGoodCount }}</strong>
                  <small>80 - 89 คะแนน</small>
              </div>

              <div class="level-card good">
                  <span>ดี</span>
                  <strong>{{ goodCount }}</strong>
                  <small>70 - 79 คะแนน</small>
              </div>

              <div class="level-card fair">
                  <span>พอใช้</span>
                  <strong>{{ fairCount }}</strong>
                  <small>60 - 69 คะแนน</small>
              </div>

              <div class="level-card improve">
                  <span>ต้องปรับปรุง</span>
                  <strong>{{ improveCount }}</strong>
                  <small>ต่ำกว่า 60 คะแนน</small>
              </div>
          </section> -->

          <!-- LEVEL SUMMARY -->
          <section class="level-grid">
              <div
                  class="level-card excellent clickable-level"
                  @click="openLevelDialog('outstanding')"
              >
                  <span>ดีเด่น</span>
                  <strong>{{ outstandingCount }}</strong>
                  <small>90 - 100 คะแนน</small>
                  <em>คลิกดูรายชื่อ</em>
              </div>

              <div
                  class="level-card very-good clickable-level"
                  @click="openLevelDialog('veryGood')"
              >
                  <span>ดีมาก</span>
                  <strong>{{ veryGoodCount }}</strong>
                  <small>80 - 89 คะแนน</small>
                  <em>คลิกดูรายชื่อ</em>
              </div>

              <div
                  class="level-card good clickable-level"
                  @click="openLevelDialog('good')"
              >
                  <span>ดี</span>
                  <strong>{{ goodCount }}</strong>
                  <small>70 - 79 คะแนน</small>
                  <em>คลิกดูรายชื่อ</em>
              </div>

              <div
                  class="level-card fair clickable-level"
                  @click="openLevelDialog('fair')"
              >
                  <span>พอใช้</span>
                  <strong>{{ fairCount }}</strong>
                  <small>60 - 69 คะแนน</small>
                  <em>คลิกดูรายชื่อ</em>
              </div>

              <div
                  class="level-card improve clickable-level"
                  @click="openLevelDialog('improve')"
              >
                  <span>ต้องปรับปรุง</span>
                  <strong>{{ improveCount }}</strong>
                  <small>ต่ำกว่า 60 คะแนน</small>
                  <em>คลิกดูรายชื่อ</em>
              </div>
          </section>

          <!-- LEVEL DETAIL DIALOG -->
        <Dialog v-model:visible="levelDialogVisible" :modal="true" :style="{ width: '760px', maxWidth: '95vw' }" :breakpoints="{ '960px': '90vw', '640px': '96vw' }" >
            <template #header>
                <div>
                    <h3 class="dialog-title">{{ selectedLevelTitle }}</h3>
                    <p class="dialog-subtitle">
                        จำนวน {{ selectedLevelRows.length }} คน
                        <span v-if="dashboardRows.length === 0">
                            — ยังไม่มีข้อมูลในรอบประเมิน กรุณาเลือกรอบและกดค้นหา
                        </span>
                    </p>
                </div>
            </template>

            <DataTable
                :value="selectedLevelRows"
                :paginator="true"
                :rows="8"
                responsiveLayout="scroll"
                stripedRows
                dataKey="staffid"
                class="level-detail-table"
            >
                <Column header="ผู้รับการประเมิน" style="min-width: 260px">
                    <template #body="slotProps">
                        <div class="person-cell">
                            <div class="avatar">
                                {{ getInitial(slotProps.data) }}
                            </div>

                            <div>
                                <strong>
                                    {{ slotProps.data.prefixfullname }}
                                    {{ slotProps.data.namefully }}
                                </strong>
                                <small>{{ slotProps.data.posnameth || '-' }}</small>
                            </div>
                        </div>
                    </template>
                </Column>

                <Column header="ผลสัมฤทธิ์" style="width: 120px">
                    <template #body="slotProps">
                        <b>{{ slotProps.data.tb_tor?.achievement_score || '-' }}</b>
                    </template>
                </Column>

                <Column header="พฤติกรรมฯ" style="width: 120px">
                    <template #body="slotProps">
                        <b>{{ slotProps.data.tb_tor?.behavior || '-' }}</b>
                    </template>
                </Column>

                <Column header="คะแนนรวม" style="width: 130px">
                    <template #body="slotProps">
                        <div
                            class="score-pill"
                            :class="scoreClass(slotProps.data.tb_tor?.sum_score)"
                        >
                            {{ Number(slotProps.data.tb_tor?.sum_score || 0).toFixed(2) }}
                        </div>
                    </template>
                </Column>

                <Column header="ระดับ" style="width: 120px">
                    <template #body="slotProps">
                        <b>{{ scoreLevel(slotProps.data.tb_tor?.sum_score) }}</b>
                    </template>
                </Column>
            </DataTable>

            <div v-if="selectedLevelRows.length === 0" class="empty-level">
                ไม่มีรายชื่อในระดับนี้
            </div>

            <template #footer>
                <Button
                    label="ปิด"
                    icon="pi pi-times"
                    severity="secondary"
                    @click="levelDialogVisible = false"
                />
            </template>
        </Dialog>

          <!-- ALERT -->
          <section class="alert-strip" v-if="pendingStaff > 0 || lowScoreRows.length > 0">
              <div v-if="pendingStaff > 0" class="alert-card amber">
                  <i class="pi pi-exclamation-triangle"></i>
                  <div>
                      <strong>มีผู้รอข้อมูลการประเมิน {{ pendingStaff }} คน</strong>
                      <span>ควรติดตามข้อมูลการประเมินให้ครบถ้วนก่อนปิดรอบ</span>
                  </div>
              </div>

              <div v-if="lowScoreRows.length > 0" class="alert-card red">
                  <i class="pi pi-arrow-down"></i>
                  <div>
                      <strong>พบคะแนนต่ำกว่า 70 จำนวน {{ lowScoreRows.length }} คน</strong>
                      <span>ควรตรวจสอบแผนพัฒนารายบุคคลและข้อเสนอแนะของผู้ประเมิน</span>
                  </div>
              </div>
          </section>

          <!-- MODERN TABLE -->
          <section class="panel table-panel">
              <div class="panel-head table-head">
                  <div>
                      <h3>รายชื่อผู้รับการประเมิน</h3>
                      <p>แสดงข้อมูลจากตารางเดิม พร้อมสถานะและระดับผลประเมิน</p>
                  </div>

                  <span class="table-summary">{{ dashboardRows.length }} รายการ</span>
              </div>

              <DataTable
                  :value="dashboardRows"
                  :paginator="true"
                  :rows="10"
                  responsiveLayout="scroll"
                  stripedRows
                  dataKey="staffid"
                  class="modern-table"
              >
                  <Column header="ผู้รับการประเมิน" style="min-width: 260px">
                      <template #body="slotProps">
                          <div class="person-cell">
                              <div class="avatar">
                                  {{ getInitial(slotProps.data) }}
                              </div>

                              <div>
                                  <strong>
                                      {{ slotProps.data.prefixfullname }}
                                      {{ slotProps.data.namefully }}
                                  </strong>
                                  <small>{{ slotProps.data.posnameth || '-' }}</small>
                              </div>
                          </div>
                      </template>
                  </Column>

                  <Column header="สถานะ" style="width: 140px">
                      <template #body="slotProps">
                          <Tag
                              :value="slotProps.data.tb_tor ? 'ประเมินแล้ว' : 'รอข้อมูล'"
                              :severity="slotProps.data.tb_tor ? 'success' : 'warning'"
                          />
                      </template>
                  </Column>

                  <Column header="สัดส่วน" style="width: 120px">
                      <template #body="slotProps">
                          <b>{{ slotProps.data.tb_tor?.persen || '-' }}</b>
                      </template>
                  </Column>

                  <Column header="ผลสัมฤทธิ์" style="width: 130px">
                      <template #body="slotProps">
                          <b>{{ slotProps.data.tb_tor?.achievement_score || '-' }}</b>
                      </template>
                  </Column>

                  <Column header="ผลรวมสัดส่วน" style="width: 140px">
                      <template #body="slotProps">
                          <b class="weight-score">{{ calcAchievement(slotProps.data) || '-' }}</b>
                      </template>
                  </Column>

                  <Column header="พฤติกรรมฯ" style="width: 130px">
                      <template #body="slotProps">
                          <b>{{ slotProps.data.tb_tor?.behavior || '-' }}</b>
                      </template>
                  </Column>

                  <Column header="ผลรวมสัดส่วน" style="width: 140px">
                      <template #body="slotProps">
                          <b class="weight-score">{{ calcBehavior(slotProps.data) || '-' }}</b>
                      </template>
                  </Column>

                  <Column header="คะแนนรวม" style="width: 140px">
                      <template #body="slotProps">
                          <div
                              v-if="slotProps.data.tb_tor"
                              class="score-pill"
                              :class="scoreClass(slotProps.data.tb_tor.sum_score)"
                          >
                              {{ Number(slotProps.data.tb_tor.sum_score).toFixed(2) }}
                          </div>

                          <span v-else>-</span>
                      </template>
                  </Column>

                  <Column header="ระดับ" style="width: 130px">
                      <template #body="slotProps">
                          <span v-if="slotProps.data.tb_tor">
                              {{ scoreLevel(slotProps.data.tb_tor.sum_score) }}
                          </span>
                          <span v-else>-</span>
                      </template>
                  </Column>

                  <!-- <Column header="ประเมิน" style="width: 130px">
                      <template #body="slotProps">
                          <Button
                              v-if="slotProps.data.tb_tor"
                              label="ประเมิน"
                              icon="pi pi-list"
                              size="small"
                              :loading="loadingEvaluIndex === slotProps.index"
                              :disabled="loadingEvalu"
                              @click="openDataEvalu(slotProps.data, slotProps.index)"
                          />

                          <span v-else class="pending-text">รอข้อมูล</span>
                      </template>
                  </Column> -->
              </DataTable>
          </section>
      </div>
  </template>

  <script setup>
  const { getSession } = await useAuth();
  const user = await getSession();
  </script>

  <script>
  import axios from 'axios';
  import Swal from 'sweetalert2';

  export default {
    data() {
      return {
      tracking_date: null,
      tracking_dates: [],
      products: [],

      loading: false,
      loadingEvalu: false,
      loadingEvaluIndex: null,

      levelDialogVisible: false,
      selectedLevelKey: null,
      selectedLevelTitle: '',

      dataList: [],
      filteredData: [],

      staffid_Main: '',
      facid_Main: '',
      groupid_Main: '',

      postypename: '',
      postypenameid: '',
      stftypename: '', 

      };
    },

    computed: {
      /* =========================
        ROWS / STAFF SUMMARY
      ========================= */

      evaluatedRows() {
        const rows = Array.isArray(this.products) ? this.products : [];

        return [...rows]
          .filter((item) => item)
          .sort((a, b) => Number(!!b.tb_tor) - Number(!!a.tb_tor));
      },

      dashboardRows() {
        return this.evaluatedRows;
      },

      totalStaff() {
        return this.evaluatedRows.length;
      },

      completedStaff() {
        return this.evaluatedRows.filter((item) => item?.tb_tor).length;
      },

      pendingStaff() {
        return Math.max(this.totalStaff - this.completedStaff, 0);
      },

      completedPercent() {
        if (!this.totalStaff) return 0;
        return Number(((this.completedStaff / this.totalStaff) * 100).toFixed(1));
      },

      evaluatedOnly() {
        return this.evaluatedRows.filter((item) => item?.tb_tor);
      },

      avgScore() {
        if (!this.evaluatedOnly.length) return '0.00';

        const total = this.evaluatedOnly.reduce((sum, item) => {
          return sum + (Number(item?.tb_tor?.sum_score) || 0);
        }, 0);

        return (total / this.evaluatedOnly.length).toFixed(2);
      },

      avgTotalScore() {
        return this.avgScore;
      },

      avgAchievement() {
        if (!this.evaluatedOnly.length) return 0;

        const total = this.evaluatedOnly.reduce((sum, item) => {
          return sum + (Number(item?.tb_tor?.achievement_score) || 0);
        }, 0);

        return Number((total / this.evaluatedOnly.length).toFixed(2));
      },

      avgAchievementScore() {
        return Number(this.avgAchievement).toFixed(2);
      },

      avgBehavior() {
        if (!this.evaluatedOnly.length) return 0;

        const total = this.evaluatedOnly.reduce((sum, item) => {
          return sum + (Number(item?.tb_tor?.behavior) || 0);
        }, 0);

        return Number((total / this.evaluatedOnly.length).toFixed(2));
      },

      avgBehaviorScore() {
        return Number(this.avgBehavior).toFixed(2);
      },

      lowScoreStaff() {
        return this.evaluatedOnly.filter((item) => {
          return Number(item?.tb_tor?.sum_score) < 70;
        });
      },

      lowScoreRows() {
        return this.lowScoreStaff;
      },

      scoreDistribution() {
        const dist = {
          outstanding: 0,
          veryGood: 0,
          good: 0,
          fair: 0,
          improve: 0
        };

        this.evaluatedOnly.forEach((item) => {
          const score = Number(item?.tb_tor?.sum_score) || 0;

          if (score >= 90) dist.outstanding++;
          else if (score >= 80) dist.veryGood++;
          else if (score >= 70) dist.good++;
          else if (score >= 60) dist.fair++;
          else dist.improve++;
        });

        return dist;
      },

      outstandingCount() {
        return this.scoreDistribution.outstanding;
      },

      veryGoodCount() {
        return this.scoreDistribution.veryGood;
      },

      goodCount() {
        return this.scoreDistribution.good;
      },

      fairCount() {
        return this.scoreDistribution.fair;
      },

      improveCount() {
        return this.scoreDistribution.improve;
      },
      selectedLevelRows() {
          const levelKey = this.selectedLevelKey;

          if (!levelKey) return [];

          const rows = Array.isArray(this.dashboardRows)
              ? this.dashboardRows
              : [];

          return rows.filter((item) => {
              if (!item || !item.tb_tor) return false;

              const rawScore = item.tb_tor.sum_score;
              const score = parseFloat(String(rawScore ?? '').replace(',', '').trim());

              if (Number.isNaN(score)) return false;

              if (levelKey === 'outstanding') {
              return score >= 90;
              }

              if (levelKey === 'veryGood') {
              return score >= 80 && score < 90;
              }

              if (levelKey === 'good') {
              return score >= 70 && score < 80;
              }

              if (levelKey === 'fair') {
              return score >= 60 && score < 70;
              }

              if (levelKey === 'improve') {
              return score < 60;
              }

              return false;
          });
      },





    },

    async mounted() {
      try {
        const { getSession } = await useAuth();
        const user = await getSession();

        const { STAFFID, SCOPES } = user.user.name;
        const { staffdepartment, groupid } = SCOPES;

        this.setSession(
          STAFFID,
          staffdepartment,
          groupid,
          user.user.name.POSTYPENAME,
          user.user.name.POSITIONNAMEID
        );

        await this.showDataSet();

      } catch (error) {
        console.error('mounted error:', error);
        Swal.fire({
          icon: 'error',
          title: 'โหลดข้อมูลผู้ใช้ไม่สำเร็จ',
          text: 'กรุณาตรวจสอบ session หรือ useAuth()'
        });
      }
    },

    methods: {
      setSession(staffid_Main, facid_Main, groupid_Main, postypename, postypenameid) {
        this.staffid_Main = staffid_Main;
        this.facid_Main = facid_Main;
        this.groupid_Main = groupid_Main;
        this.postypename = postypename;
        this.postypenameid = postypenameid;
      },

      async withLoading(task) {
        this.loading = true;

        try {
          return await task();
        } finally {
          this.loading = false;
        }
      },

      async showDataSet() {
        try {
          const res = await axios.post('http://127.0.0.1:8000/api/showDateSetleader', {
            staff_id: this.staffid_Main,
            fac_id: this.facid_Main,
            group_id: this.groupid_Main
          });

          console.log('showDateSetleader:', res.data);

          this.tracking_dates = Array.isArray(res.data) ? res.data : [];

        } catch (error) {
          console.error('showDataSet error:', error);

          this.tracking_dates = [];

          Swal.fire({
            icon: 'error',
            title: 'โหลดรอบประเมินไม่สำเร็จ',
            text: 'กรุณาตรวจสอบ API showDateSetleader'
          });
        }
      },

      async xxr() {
        if (!this.tracking_date || this.tracking_date?.evalua === undefined) {
          Swal.fire({
            title: 'แจ้งเตือนจากระบบ!',
            text: 'กรุณาเลือกรอบประเมินก่อน',
            icon: 'error'
          });
          return;
        }

        await this.withLoading(async () => {
          await this.showDataEvalu();
        });
      },

      async showDataEvalu() {
        try {
          const res = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {
            params: {
              staff_id: this.staffid_Main,
              fac_id: this.tracking_date.fac_id,
              group_id: this.groupid_Main,
              evalua: this.tracking_date.evalua,
              p_year: this.tracking_date.d_date
            }
          });

          console.log('showDataEvalu:', res.data);

          this.products = Array.isArray(res.data) ? res.data : [];

        } catch (error) {
          console.error('showDataEvalu error:', error);

          this.products = [];

          Swal.fire({
            icon: 'error',
            title: 'โหลดข้อมูลประเมินไม่สำเร็จ',
            text: 'กรุณาตรวจสอบ API showDataEvalu'
          });
        }
      },

      parsePersen(persen) {
        const [wAch, wBeh] = String(persen || '0:0')
          .split(':')
          .map((v) => parseFloat(v) || 0);

        return { wAch, wBeh };
      },

      calcAchievement(item) {
        if (!item?.tb_tor?.persen) return '';

        const { wAch } = this.parsePersen(item.tb_tor.persen);
        const ach = parseFloat(item.tb_tor.achievement_score) || 0;

        return (wAch * ach).toFixed(2);
      },

      calcBehavior(item) {
        if (!item?.tb_tor?.persen) return '';

        const { wBeh } = this.parsePersen(item.tb_tor.persen);
        const beh = parseFloat(item.tb_tor.behavior) || 0;

        return (wBeh * beh).toFixed(2);
      },

      scoreLevel(score) {
        const s = Number(score) || 0;

        if (s >= 90) return 'ดีเด่น';
        if (s >= 80) return 'ดีมาก';
        if (s >= 70) return 'ดี';
        if (s >= 60) return 'พอใช้';

        return 'ต้องปรับปรุง';
      },

      scoreClass(score) {
        const s = Number(score) || 0;

        if (s >= 90) return 'excellent';
        if (s >= 80) return 'very-good';
        if (s >= 70) return 'good';
        if (s >= 60) return 'fair';

        return 'improve';
      },

      getInitial(item) {
        const name = item?.namefully || item?.staffname || '';
        return name.trim().slice(0, 1) || 'P';
      },

      openLevelDialog(levelKey) {
          const titleMap = {
              outstanding: 'รายชื่อผู้ได้รับผลประเมินระดับดีเด่น',
              veryGood: 'รายชื่อผู้ได้รับผลประเมินระดับดีมาก',
              good: 'รายชื่อผู้ได้รับผลประเมินระดับดี',
              fair: 'รายชื่อผู้ได้รับผลประเมินระดับพอใช้',
              improve: 'รายชื่อผู้ได้รับผลประเมินระดับต้องปรับปรุง'
          };

          this.selectedLevelKey = levelKey;
          this.selectedLevelTitle = titleMap[levelKey] || 'รายชื่อผู้รับการประเมิน';
          this.levelDialogVisible = true;

          this.$nextTick(() => {
              console.log('เปิดดูระดับ:', levelKey);
              console.log('products:', this.products);
              console.log('dashboardRows:', this.dashboardRows);
              console.log('selectedLevelRows:', this.selectedLevelRows);
          });
      },


      async printDatatrackingpdf() {
        if (!this.tracking_date) {
          Swal.fire({
            icon: 'warning',
            title: 'กรุณาเลือกรอบประเมินก่อน'
          });
          return;
        }

        try {
          const { getSession } = await useAuth();
          const user = await getSession();

          const form = {
            staff_id: this.staffid_Main,
            group_id: this.groupid_Main,
            fac_id: this.tracking_date.fac_id,
            year_id: this.tracking_date.d_date,
            evalua: this.tracking_date.evalua,
            PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
            STAFFNAME: user.user.name.STAFFNAME,
            STAFFSURNAME: user.user.name.STAFFSURNAME,
            POSITIONNAME: user.user.name.POSITIONNAME,
            GROUPTYPENAME: user.user.name.GROUPTYPENAME,
            POSTYPENAME: user.user.name.POSTYPENAME,
            SCOPES: user.user.name.SCOPES.staffdepartmentname,
            postypename: `ระดับ${this.postypename}`,
            postypenameid: this.postypenameid,
            stftypename: this.stftypename
          };

          const response = await axios.post(
            'http://127.0.0.1:8000/api/exportPdf_Tracking',
            form,
            { responseType: 'blob' }
          );

          const url = window.URL.createObjectURL(response.data);
          window.open(url, '_blank');

        } catch (error) {
          console.error('printDatatrackingpdf error:', error);

          Swal.fire({
            icon: 'error',
            title: 'Export PDF ไม่สำเร็จ'
          });
        }
      },


      openDataEvalu(item, index) {
        console.log('openDataEvalu:', item, index);

        Swal.fire({
          icon: 'info',
          title: 'ยังไม่ได้เชื่อม Dialog เดิม',
          text: 'ถ้าต้องการใช้แบบประเมิน ป.01 - ป.04 ต้องนำ methods เดิมของ openDataEvalu กลับมาใส่'
        });
      }
    }
  };
  </script>

  <style scoped>
  .tracking-dashboard {
    padding: 1.25rem;
    background: linear-gradient(180deg, #f4f7fb 0%, #ffffff 46%);
    min-height: 100vh;
  }

  /* HEADER */
  .dash-hero {
    display: flex;
    justify-content: space-between;
    gap: 1.5rem;
    align-items: center;
    padding: 1.55rem 1.65rem;
    border-radius: 24px;
    background:
      radial-gradient(circle at top right, rgba(20, 184, 166, 0.28), transparent 34%),
      linear-gradient(135deg, #0f1f4b 0%, #1e3a8a 48%, #0f766e 100%);
    color: #ffffff;
    box-shadow:
      0 18px 40px rgba(15, 31, 75, 0.22),
      0 6px 16px rgba(15, 118, 110, 0.14);
    border: 1px solid rgba(255, 255, 255, 0.12);
  }

  .eyebrow {
    font-size: 0.72rem;
    letter-spacing: 0.18em;
    opacity: 0.9;
    font-weight: 800;
    color: rgba(255, 255, 255, 0.88);
  }

  .dash-hero h2 {
    margin: 0.35rem 0;
    font-size: 2rem;
    font-weight: 750;
    color: #ffffff;
    line-height: 1.2;
    text-align: left;
  }

  .dash-hero p {
    margin: 0;
    opacity: 0.88;
    color: rgba(255, 255, 255, 0.86);
    line-height: 1.55;
  }

  .hero-actions {
    display: flex;
    gap: 0.75rem;
    align-items: center;
    flex-wrap: wrap;
    justify-content: flex-end;
  }

  .round-select {
    min-width: 360px;
  }

  /* PrimeVue Dropdown */
  :deep(.round-select.p-dropdown),
  :deep(.round-select .p-dropdown) {
    min-height: 46px;
    border-radius: 12px;
    border: 1px solid rgba(226, 232, 240, 0.95);
    background: rgba(255, 255, 255, 0.96);
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.12);
  }

  :deep(.round-select .p-dropdown-label) {
    color: #334155;
    font-weight: 500;
  }

  :deep(.round-select .p-dropdown-trigger) {
    color: #64748b;
  }

  /* PrimeVue Buttons in Header */
  :deep(.hero-actions .p-button) {
    min-height: 46px;
    border-radius: 12px;
    font-weight: 700;
    padding: 0 1rem;
    transition: all 0.22s ease;
  }

  /* ปุ่มค้นหา */
  :deep(.hero-actions .p-button:not(.p-button-outlined)) {
    background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%);
    border: none;
    color: #ffffff;
    box-shadow: 0 10px 22px rgba(20, 184, 166, 0.26);
  }

  :deep(.hero-actions .p-button:not(.p-button-outlined):hover) {
    background: linear-gradient(135deg, #0f766e 0%, #115e59 100%);
    transform: translateY(-1px);
  }

  /* ปุ่ม Export PDF */
  :deep(.hero-actions .p-button.p-button-outlined) {
    background: rgba(255, 255, 255, 0.09);
    color: #ffffff;
    border: 1px solid rgba(255, 255, 255, 0.42);
    backdrop-filter: blur(6px);
    box-shadow: none;
  }

  :deep(.hero-actions .p-button.p-button-outlined:hover) {
    background: rgba(255, 255, 255, 0.18);
    color: #ffffff;
    border-color: rgba(255, 255, 255, 0.65);
    transform: translateY(-1px);
  }

  /* KPI */
  .kpi-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(180px, 1fr));
    gap: 1rem;
    margin: 1.25rem 0;
  }

  .kpi-card {
    display: flex;
    gap: 1rem;
    padding: 1.2rem;
    border-radius: 20px;
    background: #ffffff;
    box-shadow: 0 10px 28px rgba(20, 35, 75, 0.08);
    border: 1px solid #edf1f7;
  }

  .kpi-icon {
    width: 48px;
    height: 48px;
    border-radius: 16px;
    display: grid;
    place-items: center;
    font-size: 1.3rem;
    flex-shrink: 0;
  }

  .kpi-card span {
    display: block;
    color: #64748b;
    font-weight: 600;
  }

  .kpi-card strong {
    display: block;
    font-size: 2rem;
    color: #0f172a;
    line-height: 1.1;
  }

  .kpi-card small {
    color: #94a3b8;
  }

  .kpi-card.primary .kpi-icon {
    background: #e0f2fe;
    color: #0369a1;
  }

  .kpi-card.success .kpi-icon {
    background: #dcfce7;
    color: #15803d;
  }

  .kpi-card.warning .kpi-icon {
    background: #fff7ed;
    color: #c2410c;
  }

  .kpi-card.info .kpi-icon {
    background: #ecfeff;
    color: #0891b2;
  }

  /* GRID */
  .dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .panel {
    background: #ffffff;
    border: 1px solid #edf1f7;
    border-radius: 22px;
    padding: 1.25rem;
    box-shadow: 0 10px 28px rgba(20, 35, 75, 0.07);
  }

  .panel-head {
    display: flex;
    justify-content: space-between;
    gap: 1rem;
    align-items: flex-start;
    margin-bottom: 1rem;
  }

  .panel-head h3 {
    margin: 0;
    text-align: left;
    color: #0f172a;
  }

  .panel-head p {
    margin: 0.25rem 0 0;
    color: #64748b;
  }

  .wide {
    grid-column: span 2;
  }

  .chart-box {
    height: 280px;
  }

  .progress-meta {
    display: flex;
    justify-content: space-between;
    margin-top: 0.8rem;
    color: #64748b;
    font-weight: 600;
  }

  /* SCORE SUMMARY */
  .score-summary-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.85rem;
  }

  .score-box {
    border-radius: 18px;
    background: #f8fafc;
    padding: 1rem;
    border: 1px solid #e2e8f0;
  }

  .score-box span {
    display: block;
    color: #64748b;
    font-weight: 600;
    margin-bottom: 0.4rem;
  }

  .score-box strong {
    font-size: 1.8rem;
    color: #0f172a;
  }

  .score-box.highlight {
    background: linear-gradient(135deg, #eff6ff, #ecfeff);
    border-color: #bfdbfe;
  }

  /* LEVEL SUMMARY */
  .level-grid {
    display: grid;
    grid-template-columns: repeat(5, minmax(140px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .level-card {
    border-radius: 18px;
    padding: 1rem;
    background: #ffffff;
    border: 1px solid #edf1f7;
    box-shadow: 0 8px 22px rgba(20, 35, 75, 0.06);
  }

  .level-card span {
    display: block;
    font-weight: 700;
  }

  .level-card strong {
    display: block;
    font-size: 2rem;
    margin: 0.25rem 0;
  }

  .level-card small {
    color: #64748b;
  }

  .level-card.excellent {
    border-left: 5px solid #16a34a;
  }

  .level-card.very-good {
    border-left: 5px solid #0284c7;
  }

  .level-card.good {
    border-left: 5px solid #4f46e5;
  }

  .level-card.fair {
    border-left: 5px solid #f59e0b;
  }

  .level-card.improve {
    border-left: 5px solid #dc2626;
  }

  /* ALERT */
  .alert-strip {
    display: grid;
    grid-template-columns: repeat(2, minmax(260px, 1fr));
    gap: 1rem;
    margin-bottom: 1rem;
  }

  .alert-card {
    display: flex;
    gap: 0.9rem;
    align-items: flex-start;
    padding: 1rem;
    border-radius: 18px;
  }

  .alert-card i {
    font-size: 1.4rem;
    margin-top: 0.2rem;
  }

  .alert-card strong,
  .alert-card span {
    display: block;
  }

  .alert-card span {
    opacity: 0.82;
    margin-top: 0.2rem;
  }

  .alert-card.amber {
    background: #fffbeb;
    color: #92400e;
    border: 1px solid #fde68a;
  }

  .alert-card.red {
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
  }

  /* TABLE */
  .table-panel {
    margin-top: 1rem;
  }

  .table-head {
    align-items: center;
  }

  .table-summary {
    color: #64748b;
    font-weight: 700;
  }

  .person-cell {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    text-align: left;
  }

  .avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    display: grid;
    place-items: center;
    background: #e0f2fe;
    color: #0369a1;
    font-weight: 800;
    flex-shrink: 0;
  }

  .person-cell strong {
    display: block;
    color: #0f172a;
  }

  .person-cell small {
    display: block;
    color: #64748b;
    margin-top: 0.15rem;
  }

  .score-pill {
    display: inline-flex;
    min-width: 72px;
    justify-content: center;
    padding: 0.35rem 0.7rem;
    border-radius: 999px;
    font-weight: 800;
  }

  .score-pill.excellent {
    background: #dcfce7;
    color: #166534;
  }

  .score-pill.very-good {
    background: #e0f2fe;
    color: #075985;
  }

  .score-pill.good {
    background: #eef2ff;
    color: #3730a3;
  }

  .score-pill.fair {
    background: #fef3c7;
    color: #92400e;
  }

  .score-pill.improve {
    background: #fee2e2;
    color: #991b1b;
  }

  .weight-score {
    color: #92400e;
  }

  .pending-text {
    color: #92400e;
    font-weight: 700;
  }

  .loading-panel,
  .loading-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 0.75rem;
    padding: 2rem;
    color: #64748b;
  }

  /* RESPONSIVE */
  @media (max-width: 1100px) {
    .dash-hero {
      flex-direction: column;
      align-items: stretch;
    }

    .hero-actions {
      justify-content: flex-start;
    }

    .kpi-grid {
      grid-template-columns: repeat(2, 1fr);
    }

    .dashboard-grid,
    .alert-strip {
      grid-template-columns: 1fr;
    }

    .level-grid {
      grid-template-columns: repeat(2, 1fr);
    }

    .wide {
      grid-column: auto;
    }

    .round-select {
      min-width: 100%;
    }
  }

  @media (max-width: 640px) {
    .kpi-grid,
    .level-grid,
    .score-summary-grid {
      grid-template-columns: 1fr;
    }

    .dash-hero h2 {
      font-size: 1.55rem;
    }
  }
  </style>