<template>
  <div class="personal-dashboard">
    <section class="hero-shell">
      <div class="hero-bg-glow glow-one"></div>
      <div class="hero-bg-glow glow-two"></div>

      <div class="hero-content">
        <div class="hero-copy">
          <div class="eyebrow">
            <i class="pi pi-chart-line"></i>
            MSU PERFORMANCE APPRAISAL
          </div>

          <h3>ผลการประเมินของฉัน</h3>
          <p>Dashboard แสดงสถานะ คะแนน และรายละเอียดผลการประเมิน</p>

          <div class="profile-strip">
            <div class="profile-avatar">
              <img
                v-if="profileImageSrc && !profileImageLoadError"
                :src="profileImageSrc"
                :alt="profileFullName"
                @error="profileImageLoadError = true"
              />
              <span v-else>{{ profileInitial }}</span>
            </div>

            <div class="profile-info">
              <strong>{{ profileFullName }}</strong>
              <span>{{ profilePosition }}</span>
            </div>

            <div class="profile-meta">
              <span>
                <i class="pi pi-id-card"></i>
                รหัสพนักงาน: {{ staffid_Main || '-' }}
              </span>
              <span>
                <i class="pi pi-building"></i>
                {{ profileDepartment }}
              </span>
            </div>
          </div>
        </div>

        <div class="control-panel">
          <label>เลือกรอบการประเมิน</label>

          <!-- <Dropdown
            v-model="tracking_date"
            :options="tracking_dates"
            :optionLabel="roundOptionLabel"
            placeholder="กรุณาเลือกรอบการประเมิน"
            class="round-select"
            :disabled="loading"
            @change="onRoundChanged"
          /> -->

          <Dropdown
            v-model="tracking_date"
            :options="allEvaluationRounds"
            autoFilterFocus
            :optionLabel="(item) => item.d_evaluationround + ' ' + item.d_date"
            placeholder="กรุณาเลือกรอบการประเมิน"
            class="round-select"
            appendTo="body"
            :disabled="loading"
            @change="onRoundChanged"
          />

          <div class="round-status">
            <i class="pi pi-calendar"></i>
            <span>{{ selectedRoundText }}</span>
          </div>
        </div>
      </div>
    </section>

    <section v-if="loading" class="loading-card">
      <ProgressSpinner style="width:62px;height:62px" strokeWidth="6" />
      <strong>กำลังโหลดข้อมูลผลการประเมิน…</strong>
      <span>ระบบกำลังดึงข้อมูลเฉพาะของผู้ใช้งานที่เข้าสู่ระบบ</span>
    </section>

    <section v-else-if="!tracking_date" class="empty-state">
      <div class="empty-icon">
        <i class="pi pi-calendar-plus"></i>
      </div>
      <h2>กรุณาเลือกรอบการประเมิน</h2>
      <p>เมื่อเลือกรอบการประเมินแล้ว ระบบจะแสดงข้อมูลให้อัตโนมัติ โดยไม่ต้องกดปุ่มค้นหา</p>
    </section>

     <template v-else>
      <section v-if="!isSelectedScoreAnnounced" class="score-wait-card">
        <div class="score-wait-icon">
          <i class="pi pi-clock"></i>
        </div>

        <h2>รอประกาศผลคะแนน</h2>
        <p>{{ scoreAnnounceText }}</p>
        <span>
          เมื่อถึงวันประกาศผลคะแนน ระบบจะแสดงคะแนนรวม กราฟย้อนหลัง และคะแนนรายองค์ประกอบโดยอัตโนมัติ
        </span>
      </section>

      <section v-else class="summary-layout">
        <div class="score-hero-card">
          <div class="score-card-head">
            <div>
              <span>คะแนนรวม</span>
              <h2>{{ displayTotalScore }}</h2>
            </div>

            <Tag :value="statusText" :severity="statusSeverity" rounded />
          </div>

          <div class="score-ring-wrap">
            <div class="score-ring" :style="scoreRingStyle">
              <div class="score-ring-inner">
                <strong>{{ displayTotalScore }}</strong>
                <span>/ 100</span>
              </div>
            </div>
          </div>

          <div class="score-level-box" :class="currentLevelClass">
            <span>ระดับผลประเมิน</span>
            <strong>{{ currentLevelText }}</strong>
          </div>
        </div>

        <div class="status-card history-card">
          <div class="card-title-row">
            <div>
              <h3>คะแนนรอบประเมินย้อนหลัง</h3>
              <p>เปรียบเทียบคะแนนรวมในแต่ละรอบ / ปีงบประมาณ</p>
            </div>

            <div class="soft-icon history-icon">
              <i class="pi pi-chart-bar"></i>
            </div>
          </div>

          <div class="history-summary">
            <div>
              <span>ผลสัมฤทธิ์ของงาน</span>
              <strong>{{ avgAchievementScore }}</strong>
            </div>
            <div>
              <span>พฤติกรรมฯ</span>
              <strong>{{ avgBehaviorScore }}</strong>
            </div>
            <div>
              <span>คะแนนรวม</span>
              <strong>{{ avgTotalScore }}</strong>
            </div>
          </div>

          <div v-if="loadingHistory" class="history-loading">
            <ProgressSpinner style="width:34px;height:34px" strokeWidth="6" />
            <span>กำลังโหลดคะแนนย้อนหลัง…</span>
          </div>

          <div v-else-if="!scoreHistoryRows.length" class="history-empty">
            <i class="pi pi-info-circle"></i>
            <span>ยังไม่มีข้อมูลคะแนนย้อนหลัง</span>
          </div>

          <div v-else class="history-chart grouped-history-chart">
            <div class="history-grid-line line-100">100</div>
            <div class="history-grid-line line-75">75</div>
            <div class="history-grid-line line-50">50</div>

            <div
              v-for="group in groupedScoreHistoryRows"
              :key="group.year"
              class="history-year-group"
            >
              <div class="history-bars-pair">
                <div
                  class="history-bar-item round-one"
                  :class="{ active: group.round1?.key === selectedRoundKey }"
                  :title="getHistoryTitle(group.round1, group.year, 1)"
                >
                  <div class="history-score">
                    {{ historyScoreText(group.round1) }}
                  </div>
                  <div class="history-bar-track">
                    <div
                      class="history-bar-fill"
                      :style="{ height: historyBarHeight(group.round1?.score) }"
                    ></div>
                  </div>
                </div>

                <div
                  class="history-bar-item round-two"
                  :class="{ active: group.round2?.key === selectedRoundKey }"
                  :title="getHistoryTitle(group.round2, group.year, 2)"
                >
                  <div class="history-score">
                    {{ historyScoreText(group.round2) }}
                  </div>
                  <div class="history-bar-track">
                    <div
                      class="history-bar-fill"
                      :style="{ height: historyBarHeight(group.round2?.score) }"
                    ></div>
                  </div>
                </div>
              </div>

              <div class="history-year-label">ปี {{ group.year }}</div>
            </div>

            <div class="history-legend">
              <span><i class="legend-one"></i> รอบ 1</span>
              <span><i class="legend-two"></i> รอบ 2</span>
            </div>
          </div>
        </div>

        <div class="component-card">
          <div class="card-title-row">
            <div>
              <h3>คะแนนรายองค์ประกอบ</h3>
              <p>ผลสัมฤทธิ์ของงาน และพฤติกรรมการปฏิบัติงาน</p>
            </div>

            <div class="soft-icon alt">
              <i class="pi pi-sliders-h"></i>
            </div>
          </div>

          <div class="component-list">
            <div class="component-item">
              <div>
                <span>ผลสัมฤทธิ์ของงาน</span>
                <strong>{{ avgAchievementScore }}</strong>
              </div>
              <div class="mini-bar">
                <i :style="{ width: achievementPercentWidth }"></i>
              </div>
            </div>

            <div class="component-item">
              <div>
                <span>พฤติกรรมฯ</span>
                <strong>{{ avgBehaviorScore }}</strong>
              </div>
              <div class="mini-bar">
                <i :style="{ width: behaviorPercentWidth }"></i>
              </div>
            </div>

            <div class="component-item highlight">
              <div>
                <span>คะแนนรวม</span>
                <strong>{{ avgTotalScore }}</strong>
              </div>
              <div class="mini-bar">
                <i :style="{ width: totalPercentWidth }"></i>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section
        v-if="isSelectedScoreAnnounced && (pendingStaff > 0 || lowScoreRows.length > 0 || dashboardRows.length === 0)"
        class="insight-section"
      >
        <div v-if="dashboardRows.length === 0" class="insight-card neutral">
          <i class="pi pi-info-circle"></i>
          <div>
            <strong>ไม่พบข้อมูลของผู้ใช้งานในรอบประเมินนี้</strong>
            <span>ระบบไม่พบข้อมูลที่ตรงกับ Staff ID: {{ staffid_Main }}</span>
          </div>
        </div>

        <div v-else-if="pendingStaff > 0" class="insight-card warning">
          <i class="pi pi-clock"></i>
          <div>
            <strong>ยังไม่มีข้อมูลการประเมิน</strong>
            <span>ควรตรวจสอบข้อมูลการประเมินในรอบที่เลือก หรือประสานผู้รับผิดชอบระบบ</span>
          </div>
        </div>

        <div v-if="lowScoreRows.length > 0" class="insight-card danger">
          <i class="pi pi-exclamation-triangle"></i>
          <div>
            <strong>พบคะแนนต่ำกว่า 70</strong>
            <span>ควรตรวจสอบแผนพัฒนารายบุคคลและข้อเสนอแนะของผู้ประเมิน</span>
          </div>
        </div>
      </section>

      <section class="detail-card recommendation-card">
        <div class="section-head table-head">
          <div>
            <h2>ข้อเสนอแนะจากผู้ประเมิน</h2>
            <!-- <p>แสดงเฉพาะหัวข้อที่มีข้อเสนอแนะในรอบประเมินที่เลือก</p> -->
          </div>

          <span class="table-count recommendation-count">
            {{ recommendationRows.length }} ข้อเสนอแนะ
          </span>
        </div>

        <div v-if="loadingRecommendations" class="recommendation-loading">
          <ProgressSpinner style="width:42px;height:42px" strokeWidth="6" />
          <span>กำลังโหลดข้อเสนอแนะจากผู้ประเมิน…</span>
        </div>

        <div v-else-if="!recommendationRows.length" class="recommendation-empty">
          <div class="recommendation-empty-icon">
            <i class="pi pi-check-circle"></i>
          </div>

          <div>
            <strong>ยังไม่มีข้อเสนอแนะในรอบนี้</strong>
            <span>
              ระบบไม่พบข้อเสนอแนะรายหัวข้อจากผู้ประเมินในรอบ
              {{ selectedRoundText }}
            </span>
          </div>
        </div>

        <div v-else class="recommendation-table-wrap">
          <table class="recommendation-table">
            <thead>
              <tr>
                <th class="col-no">ลำดับ</th>
                <th class="col-work">กิจกรรม / โครงการ / งาน</th>
                <th class="col-recommend">ข้อเสนอแนะ</th>
              </tr>
            </thead>

            <tbody>
              <tr
                v-for="(item, index) in recommendationRows"
                :key="item.id || index"
              >
                <td class="col-no">{{ index + 1 }}</td>

                <td class="col-work">
                  <div class="work-title">
                    <strong class="main-work-title">
                      {{ item.groupNo }} {{ item.groupName }}
                    </strong>

                    <!-- <span class="round-line">
                      <i class="pi pi-calendar"></i>
                      {{ item.roundLabel }}
                    </span> -->

                    <div v-if="item.activityText" class="activity-subject-line">
                      <strong>{{ item.activityNo }}</strong>
                      <span>{{ item.activityText }}</span>
                    </div>
                  </div>
                </td>

                <td class="col-recommend">
                  <div class="recommend-red-text">
                    <div class="recommend-red-label">
                      <i class="pi pi-comments"></i>
                      ข้อเสนอแนะจากผู้ประเมิน :
                    </div>
                    <p>{{ item.recommendation }}</p>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>
  </div>
</template>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';

const API = 'http://127.0.0.1:8000/api';
const PROFILE_IMAGE_URL = 'https://pd.msu.ac.th/staff/picture/';

export default {
  data() {
    return {
      tracking_date: null,
      tracking_dates: [],
      products: [],
      scoreHistory: [],
      recommendationRows: [],

      loading: false,
      loadingHistory: false,
      loadingRecommendations: false,

      staffid_Main: '',
      facid_Main: '',
      groupid_Main: '',
      postypename: '',
      postypenameid: '',
      currentUserProfile: {},
      profileImageLoadError: false,

      animatedScoreValue: 0,
      animatedAchievementValue: 0,
      animatedBehaviorValue: 0,
      animateCharts: false,
      counterFrame: null,
    };
  },

  computed: {
    evaluatedRows() {
      return (Array.isArray(this.products) ? this.products : [])
        .filter(Boolean)
        .map(this.normalizeRow)
        .filter(this.isLoginStaffRow)
        .sort((a, b) => Number(!!b.tb_tor) - Number(!!a.tb_tor));
    },

    dashboardRows() {
      return this.evaluatedRows;
    },

    personalRow() {
      return this.dashboardRows[0] || null;
    },

    hasEvaluation() {
      return !!this.personalRow?.tb_tor;
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

    evaluatedOnly() {
      return this.evaluatedRows.filter((item) => item?.tb_tor);
    },

    avgAchievement() {
      return this.averageByField('achievement_score');
    },

    avgBehavior() {
      return this.averageByField('behavior');
    },

    scoreValue() {
      return this.hasEvaluation ? this.parseScore(this.personalRow?.tb_tor?.sum_score) : 0;
    },

    avgAchievementScore() {
      return Number(this.animatedAchievementValue || 0).toFixed(2);
    },

    avgBehaviorScore() {
      return Number(this.animatedBehaviorValue || 0).toFixed(2);
    },

    avgTotalScore() {
      return Number(this.animatedScoreValue || 0).toFixed(2);
    },

    displayTotalScore() {
      return this.hasEvaluation ? Number(this.animatedScoreValue || 0).toFixed(2) : '0.00';
    },

    scoreRingStyle() {
      const score = Math.max(0, Math.min(Number(this.animatedScoreValue) || 0, 100));
      return { '--score-deg': `${score * 3.6}deg` };
    },

    achievementPercentWidth() {
      return this.percentWidthFromScore(this.animatedAchievementValue, 1);
    },

    behaviorPercentWidth() {
      return this.percentWidthFromScore(this.animatedBehaviorValue, 1);
    },

    totalPercentWidth() {
      return this.percentWidthFromScore(this.animatedScoreValue, 100);
    },

    currentLevelText() {
      return this.hasEvaluation ? this.scoreLevel(this.scoreValue) : 'รอข้อมูล';
    },

    currentLevelClass() {
      return this.hasEvaluation ? this.scoreClass(this.scoreValue) : 'pending';
    },

    statusText() {
      return this.hasEvaluation ? 'ประเมินแล้ว' : 'รอข้อมูล';
    },

    statusSeverity() {
      return this.hasEvaluation ? 'success' : 'warning';
    },

    lowScoreRows() {
      return this.evaluatedOnly.filter((item) => this.parseScore(item?.tb_tor?.sum_score) < 70);
    },

    profileFullName() {
      const row = this.personalRow || {};
      const prefix = row.prefixfullname || this.currentUserProfile.PREFIXFULLNAME || '';
      const name =
        row.namefully ||
        `${this.currentUserProfile.STAFFNAME || ''} ${this.currentUserProfile.STAFFSURNAME || ''}`.trim();

      return `${prefix || ''}${prefix && name ? ' ' : ''}${name || 'ผู้ใช้งานระบบ'}`.trim();
    },

    profileInitial() {
      const name = this.personalRow?.namefully || this.currentUserProfile.STAFFNAME || this.profileFullName || 'P';
      return String(name).trim().slice(0, 1) || 'P';
    },

    profilePosition() {
      return (
        this.personalRow?.posnameth ||
        this.currentUserProfile.POSITIONNAME ||
        this.currentUserProfile.POSTYPENAME ||
        'ตำแหน่งไม่ระบุ'
      );
    },

    profileDepartment() {
      return (
        this.currentUserProfile?.SCOPES?.staffdepartmentname ||
        this.currentUserProfile?.SCOPES?.staffdepartment ||
        this.facid_Main ||
        'หน่วยงานไม่ระบุ'
      );
    },

    profileImageSrc() {
      const staffid = this.normalizeStaffId(this.staffid_Main || this.currentUserProfile.STAFFID);
      return staffid ? `${PROFILE_IMAGE_URL}${staffid}.jpg` : '';
    },

    selectedRoundText() {
      return this.tracking_date ? this.roundOptionLabel(this.tracking_date) : 'ยังไม่ได้เลือกรอบการประเมิน';
    },

    selectedRoundKey() {
      return this.getRoundKey(this.tracking_date);
    },

    scoreHistoryRows() {
      return Array.isArray(this.scoreHistory) ? this.scoreHistory.filter(Boolean) : [];
    },

    groupedScoreHistoryRows() {
      const map = new Map();

      this.scoreHistoryRows.forEach((item) => {
        const year = String(item.year || this.historyYear(item.round) || '-');
        const roundNo = String(item.roundNo || this.historyRoundNo(item.round));

        if (!map.has(year)) {
          map.set(year, { year, round1: null, round2: null });
        }

        map.get(year)[roundNo === '2' ? 'round2' : 'round1'] = item;
      });

      return Array.from(map.values()).sort((a, b) => Number(a.year) - Number(b.year));
    },

    allEvaluationRounds() {
      if (!Array.isArray(this.tracking_dates) || this.tracking_dates.length === 0) {
        return [];
      }

      return [...this.tracking_dates].sort((a, b) => {
        const yearA = Number(String(a.d_date || '').match(/25\d{2}/)?.[0] || 0);
        const yearB = Number(String(b.d_date || '').match(/25\d{2}/)?.[0] || 0);

        const roundA = Number(a.evalua || 0);
        const roundB = Number(b.evalua || 0);

        if (yearB !== yearA) return yearB - yearA;
        return roundB - roundA;
      });
    },
    isSelectedScoreAnnounced() {
      return this.isScoreAnnounced(this.tracking_date);
    },

    scoreAnnounceText() {
      const dateText = this.formatThaiDate(this.tracking_date?.d_scoringday);

      return dateText
        ? `ระบบจะประกาศผลคะแนนในวันที่ ${dateText}`
        : 'ยังไม่กำหนดวันประกาศผลคะแนน';
    },




  },

  async mounted() {
    try {
      const { getSession } = await useAuth();
      const user = await getSession();
      const sessionName = user?.user?.name || {};
      const scopes = sessionName.SCOPES || {};

      this.currentUserProfile = sessionName;
      this.staffid_Main = sessionName.STAFFID || '';
      this.facid_Main = scopes.staffdepartment || '';
      this.groupid_Main = scopes.groupid || '';
      this.postypename = sessionName.POSTYPENAME || '';
      this.postypenameid = sessionName.POSITIONNAMEID || '';

      await this.showDataSet();
    } catch (error) {
      console.error('mounted error:', error);
      Swal.fire({
        icon: 'error',
        title: 'โหลดข้อมูลผู้ใช้ไม่สำเร็จ',
        text: 'กรุณาตรวจสอบ session หรือ useAuth()',
      });
    }
  },

  beforeUnmount() {
    if (this.counterFrame) {
      cancelAnimationFrame(this.counterFrame);
    }
  },

  methods: {
    roundOptionLabel(item) {
      if (!item) return '';
      return `${item.facuties || ''} ${item.d_evaluationround || ''} ${item.d_date || ''}`.trim();
    },

    getRoundKey(item) {
      if (!item) return '';
      return [item.fac_id, item.evalua, item.d_date, item.d_evaluationround].join('|');
    },

    // async onRoundChanged() {
    //   if (!this.tracking_date || this.tracking_date?.evalua === undefined) {
    //     this.resetDashboard();
    //     return;
    //   }

    //   await this.withLoading(async () => {
    //     await Promise.all([
    //       this.showDataEvalu(),
    //       this.fetchEvaluationRecommendations(),
    //     ]);
    //   });

    //   this.runDashboardAnimation();
    // },

    async onRoundChanged() {
      if (!this.tracking_date || this.tracking_date?.evalua === undefined) {
        this.resetDashboard();
        return;
      }

      await this.withLoading(async () => {
        await Promise.all([
          this.showDataEvalu(),
          this.fetchEvaluationRecommendations(),
        ]);
      });

      if (this.isSelectedScoreAnnounced) {
        this.runDashboardAnimation();
      } else {
        this.animatedScoreValue = 0;
        this.animatedAchievementValue = 0;
        this.animatedBehaviorValue = 0;
        this.animateCharts = false;
      }
    },

    resetDashboard() {
      this.products = [];
      this.recommendationRows = [];
      this.animateCharts = false;
      this.animatedScoreValue = 0;
      this.animatedAchievementValue = 0;
      this.animatedBehaviorValue = 0;
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
        const res = await axios.post(`${API}/showDateSet`, {
          staff_id: this.staffid_Main,
          fac_id: this.facid_Main,
          group_id: this.groupid_Main,
        });

        this.tracking_dates = Array.isArray(res.data) ? res.data : [];

        console.log('รอบประเมินทั้งหมด:', this.tracking_dates.length);
        console.table(this.tracking_dates);

        await this.fetchScoreHistory(10);
      } catch (error) {
        console.error('showDataSet error:', error);
        this.tracking_dates = [];
        Swal.fire({
          icon: 'error',
          title: 'โหลดรอบประเมินไม่สำเร็จ',
          text: 'กรุณาตรวจสอบ API showDateSet',
        });
      }
    },
 
    async showDataEvalu() {
      try {
        const res = await axios.get(`${API}/showDataEvalu`, {
          params: {
            staff_id: this.staffid_Main,
            fac_id: this.tracking_date?.fac_id ?? this.facid_Main,
            group_id: this.groupid_Main,
            evalua: this.tracking_date?.evalua,
            p_year: this.tracking_date?.d_date,
          },
        });

        this.products = this.filterOnlyLoginStaff(Array.isArray(res.data) ? res.data : []);
      } catch (error) {
        console.error('showDataEvalu error:', error);
        this.products = [];
        Swal.fire({
          icon: 'error',
          title: 'โหลดข้อมูลประเมินไม่สำเร็จ',
          text: 'กรุณาตรวจสอบ API showDataEvalu',
        });
      }
    },

    async fetchScoreHistory(limit = 10) {
      const rounds = this.getHistoryRounds(limit);

      if (!rounds.length || !this.staffid_Main) {
        this.scoreHistory = [];
        return;
      }

      this.loadingHistory = true;

      try {
        this.scoreHistory = await Promise.all(rounds.map(this.fetchScoreHistoryItem));
      } catch (error) {
        console.error('fetchScoreHistory error:', error);
        this.scoreHistory = [];
      } finally {
        this.loadingHistory = false;
      }
    },

    // async fetchScoreHistoryItem(round) {
    //   try {
    //     const res = await axios.get(`${API}/showDataEvalu`, {
    //       params: {
    //         staff_id: this.staffid_Main,
    //         fac_id: round?.fac_id,
    //         group_id: this.groupid_Main,
    //         evalua: round?.evalua,
    //         p_year: round?.d_date,
    //       },
    //     });

    //     const row = this.filterOnlyLoginStaff(Array.isArray(res.data) ? res.data : [])[0] || null;
    //     const score = row?.tb_tor ? this.parseScore(row.tb_tor.sum_score) : null;

    //     return this.makeScoreHistoryItem(round, score, score !== null ? this.scoreLevel(score) : 'ไม่มีข้อมูล');
    //   } catch (error) {
    //     console.error('fetchScoreHistory item error:', error);
    //     return this.makeScoreHistoryItem(round, null, 'โหลดข้อมูลไม่สำเร็จ');
    //   }
    // },

    async fetchScoreHistoryItem(round) {
      try {
        const announced = this.isScoreAnnounced(round);

        if (!announced) {
          return this.makeScoreHistoryItem(round, null, 'รอประกาศผลคะแนน', false);
        }

        const res = await axios.get(`${API}/showDataEvalu`, {
          params: {
            staff_id: this.staffid_Main,
            fac_id: round?.fac_id ?? this.facid_Main,
            group_id: this.groupid_Main,
            evalua: round?.evalua,
            p_year: round?.d_date,
          },
        });

        const row = this.filterOnlyLoginStaff(Array.isArray(res.data) ? res.data : [])[0] || null;
        const score = row?.tb_tor ? this.parseScore(row.tb_tor.sum_score) : null;

        return this.makeScoreHistoryItem(
          round,
          score,
          score !== null ? this.scoreLevel(score) : 'ไม่มีข้อมูล',
          true
        );
      } catch (error) {
        console.error('fetchScoreHistory item error:', error);
        return this.makeScoreHistoryItem(round, null, 'โหลดข้อมูลไม่สำเร็จ', true);
      }
    },

    // makeScoreHistoryItem(round, score, level) {
    //   return {
    //     key: this.getRoundKey(round),
    //     round,
    //     year: this.historyYear(round),
    //     roundNo: this.historyRoundNo(round),
    //     fullLabel: this.historyFullLabel(round),
    //     score,
    //     hasData: score !== null && !Number.isNaN(score),
    //     level,
    //   };
    // },

    makeScoreHistoryItem(round, score, level, isAnnounced = true) {
      return {
        key: this.getRoundKey(round),
        round,
        year: this.historyYear(round),
        roundNo: this.historyRoundNo(round),
        fullLabel: this.historyFullLabel(round),
        score,
        isAnnounced,
        hasData: isAnnounced && score !== null && !Number.isNaN(score),
        level: isAnnounced ? level : 'รอประกาศผลคะแนน',
      };
    },

    async fetchEvaluationRecommendations() {
      if (!this.tracking_date || !this.staffid_Main) {
        this.recommendationRows = [];
        return;
      }

      this.loadingRecommendations = true;

      try {
        const res = await axios.post(`${API}/showDataP03New`, {
          staff_id: this.staffid_Main,
          fac_id: this.tracking_date?.fac_id ?? this.facid_Main,
          year_id: this.tracking_date?.d_date,
          evalua: this.tracking_date?.evalua,
        });

        this.recommendationRows = this.mapRecommendationRows(Array.isArray(res.data) ? res.data : []);
      } catch (error) {
        console.error('fetchEvaluationRecommendations error:', error);
        this.recommendationRows = [];
      } finally {
        this.loadingRecommendations = false;
      }
    },

    mapRecommendationRows(groups) {
      const rows = [];

      groups.forEach((group, groupIndex) => {
        const subItems = Array.isArray(group?.subP01sX) ? group.subP01sX : [];

        subItems.forEach((item, itemIndex) => {
          const recommendation = this.cleanRecommendationText(item?.p01_detail);
          if (!recommendation) return;

          // rows.push({
          //   id: [
          //     group?.h_no ?? groupIndex,
          //     item?.p01_id ?? itemIndex,
          //     this.tracking_date?.d_date,
          //     this.tracking_date?.evalua,
          //   ].join('-'),
          //   groupNo: group?.h_no || '',
          //   groupName: group?.nameH || 'ไม่ระบุหมวดงาน',
          //   recommendation,
          //   roundLabel: this.selectedRoundText,
          // });

          rows.push({
            id: [
              group?.h_no ?? groupIndex,
              item?.p01_id ?? itemIndex,
              this.tracking_date?.d_date,
              this.tracking_date?.evalua,
            ].join('-'),

            groupNo: group?.h_no || '',
            groupName: group?.nameH || 'ไม่ระบุหมวดงาน',

            activityNo: item?.p01_no || '',
            activityText: this.getMainActivityText(item?.p01_subject),

            recommendation,
            roundLabel: this.selectedRoundText,
          }); 
        });
      });

      return rows;
    },

    cleanRecommendationText(value) {
      const text = String(value ?? '')
        .replace(/<br\s*\/?>/gi, '\n')
        .replace(/<\/?[^>]+(>|$)/g, '')
        .trim();

      return text && !['-', 'null', 'undefined'].includes(text.toLowerCase()) ? text : '';
    },

    normalizeRow(item) {
      return {
        ...item,
        tb_tor: Array.isArray(item?.tb_tor) ? item.tb_tor[0] || null : item?.tb_tor || null,
      };
    },

    normalizeStaffId(value) {
      return String(value ?? '').replace(/\s+/g, '').trim();
    },

    getRowStaffId(item) {
      const row = this.normalizeRow(item);

      return this.normalizeStaffId(
        row?.staffid ||
        row?.STAFFID ||
        row?.staff_id ||
        row?.staffId ||
        row?.STAFF_ID ||
        row?.tb_tor?.staffid ||
        row?.tb_tor?.STAFFID ||
        row?.tb_tor?.staff_id ||
        row?.tb_tor?.staffId ||
        row?.tb_tor?.STAFF_ID ||
        ''
      );
    },

    isLoginStaffRow(item) {
      const loginStaffId = this.normalizeStaffId(this.staffid_Main);
      const rowStaffId = this.getRowStaffId(item);
      return !!loginStaffId && !!rowStaffId && rowStaffId === loginStaffId;
    },

    filterOnlyLoginStaff(rows) {
      return Array.isArray(rows)
        ? rows.map(this.normalizeRow).filter(this.isLoginStaffRow)
        : [];
    },

    parseScore(value) {
      const score = parseFloat(String(value ?? '0').replace(',', '').trim());
      return Number.isNaN(score) ? 0 : score;
    },

    averageByField(field) {
      if (!this.evaluatedOnly.length) return 0;

      const total = this.evaluatedOnly.reduce((sum, item) => {
        return sum + this.parseScore(item?.tb_tor?.[field]);
      }, 0);

      return Number((total / this.evaluatedOnly.length).toFixed(2));
    },

    percentWidthFromScore(value, fullScore = 100) {
      const percent = (this.parseScore(value) / (Number(fullScore) || 100)) * 100;
      return `${Math.max(0, Math.min(percent, 100))}%`;
    },

    scoreLevel(score) {
      const value = this.parseScore(score);
      if (value >= 90) return 'ดีเด่น';
      if (value >= 80) return 'ดีมาก';
      if (value >= 70) return 'ดี';
      if (value >= 60) return 'พอใช้';
      return 'ต้องปรับปรุง';
    },

    scoreClass(score) {
      const value = this.parseScore(score);
      if (value >= 90) return 'excellent';
      if (value >= 80) return 'very-good';
      if (value >= 70) return 'good';
      if (value >= 60) return 'fair';
      return 'improve';
    },

    getHistoryRounds(limit = 10) {
      return (Array.isArray(this.tracking_dates) ? [...this.tracking_dates] : [])
        .slice(0, limit)
        .reverse();
    },

    historyFullLabel(round) {
      return `${round?.facuties || ''} ${round?.d_evaluationround || ''} ${round?.d_date || ''}`.trim();
    },

    historyYear(round) {
      const match = String(round?.d_date || '').trim().match(/\d{4}/);
      return match ? match[0] : String(round?.d_date || '-').trim();
    },

    historyRoundNo(round) {
      const text = String(round?.d_evaluationround || round?.evalua || '').trim();
      const match = text.match(/(?:รอบ|ครั้ง)(?:ที่)?\s*([12])/);

      if (match?.[1]) return match[1];

      return String(round?.evalua || '').trim() === '2' ? '2' : '1';
    },

    getHistoryTitle(item, year, roundNo) {
      return item?.fullLabel || `ปี ${year} รอบ ${roundNo}`;
    },

    historyBarHeight(score) {
      if (!this.animateCharts) return '0%';
      return `${Math.max(0, Math.min(this.parseScore(score), 100))}%`;
    },

    runDashboardAnimation() {
      this.animateCharts = false;
      this.animatedScoreValue = 0;
      this.animatedAchievementValue = 0;
      this.animatedBehaviorValue = 0;

      this.$nextTick(() => {
        requestAnimationFrame(() => {
          this.animateCharts = true;
          this.countUpDashboardValues({
            score: this.scoreValue,
            achievement: this.avgAchievement,
            behavior: this.avgBehavior,
            duration: 1300,
          });
        });
      });
    },

    countUpDashboardValues({ score = 0, achievement = 0, behavior = 0, duration = 1200 }) {
      if (this.counterFrame) {
        cancelAnimationFrame(this.counterFrame);
      }

      const startTime = performance.now();

      const animate = (now) => {
        const progress = Math.min((now - startTime) / duration, 1);
        const eased = this.easeOutCubic(progress);

        this.animatedScoreValue = score * eased;
        this.animatedAchievementValue = achievement * eased;
        this.animatedBehaviorValue = behavior * eased;

        if (progress < 1) {
          this.counterFrame = requestAnimationFrame(animate);
        } else {
          this.animatedScoreValue = score;
          this.animatedAchievementValue = achievement;
          this.animatedBehaviorValue = behavior;
          this.counterFrame = null;
        }
      };

      this.counterFrame = requestAnimationFrame(animate);
    },

    easeOutCubic(value) {
      return 1 - Math.pow(1 - value, 3);
    },

    getMainActivityText(text) {
      const lines = String(text || '')
        .split(/\r?\n/)
        .map((line) => line.trim())
        .filter(Boolean);

      return lines[0] || '';
    },

    parseDbDate(value) {
      if (!value) return null;

      if (value instanceof Date) {
        const date = new Date(value);
        date.setHours(0, 0, 0, 0);
        return date;
      }

      const text = String(value).trim();
      if (!text) return null;

      // รองรับทั้ง 2026-06-23 และ 2026-06-23 00:00:00
      const datePart = text.includes('T')
        ? text.split('T')[0]
        : text.split(' ')[0];

      const date = new Date(`${datePart}T00:00:00`);
      if (Number.isNaN(date.getTime())) return null;

      date.setHours(0, 0, 0, 0);
      return date;
    },

    isScoreAnnounced(item) {
      const scoringDate = this.parseDbDate(item?.d_scoringday);

      // ถ้าไม่มีวันประกาศคะแนน ให้ถือว่ายังไม่ประกาศ
      if (!scoringDate) return false;

      const today = new Date();
      today.setHours(0, 0, 0, 0);

      return today >= scoringDate;
    },

    formatThaiDate(value) {
      const date = this.parseDbDate(value);
      if (!date) return '';

      return date.toLocaleDateString('th-TH', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
      });
    },

    historyScoreText(item) {
      if (!item) return '-';
      if (!item.isAnnounced) return 'รอประกาศ';
      return item.hasData ? Number(item.score).toFixed(2) : '-';
    },
 
  },
};
</script>

<style scoped>
.personal-dashboard {
  min-height: 100vh;
  padding: 1.5rem;
  color: #0f172a;
  background:
    radial-gradient(circle at top left, rgba(14, 165, 233, 0.18), transparent 28%),
    radial-gradient(circle at top right, rgba(20, 184, 166, 0.16), transparent 30%),
    linear-gradient(180deg, #eef5ff 0%, #f8fafc 42%, #ffffff 100%);
}

.hero-shell {
  position: relative;
  overflow: hidden;
  padding: 1.4rem;
  border: 1px solid #c7d2fe;
  border-radius: 28px;
  background: linear-gradient(135deg, #eef4ff 0%, #eafcf7 58%, #ffffff 100%);
  box-shadow: 0 14px 34px rgba(30, 64, 175, 0.08), 0 4px 14px rgba(15, 118, 110, 0.05);
}

.hero-bg-glow {
  position: absolute;
  border-radius: 999px;
  filter: blur(8px);
  opacity: 0.16;
  pointer-events: none;
}

.glow-one {
  width: 260px;
  height: 260px;
  right: -70px;
  top: -80px;
  background: rgba(45, 212, 191, 0.28);
}

.glow-two {
  width: 220px;
  height: 220px;
  left: 36%;
  bottom: -120px;
  background: rgba(96, 165, 250, 0.22);
}

.hero-content {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 380px;
  gap: 1.4rem;
}

.hero-copy {
  padding: 0.35rem 0.25rem;
  color: #172554;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.48rem 0.9rem;
  border-radius: 999px;
  color: #ffffff;
  font-size: 0.78rem;
  font-weight: 900;
  background: linear-gradient(135deg, #60a5fa, #3b82f6);
  box-shadow: 0 8px 18px rgba(59, 130, 246, 0.16);
}

.hero-copy h3 {
  margin: 1rem 0 0.45rem;
  color: #1e1b4b;
  font-size: clamp(1.65rem, 3vw, 2.2rem);
  font-weight: 900;
  line-height: 1.18;
}

.hero-copy p,
.card-title-row p,
.section-head p {
  margin: 0.25rem 0 0;
  color: #64748b;
  line-height: 1.6;
}

.profile-strip {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.2rem;
  padding: 1rem;
  border: 1px solid #e6b087;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.66);
  box-shadow: 0 10px 24px rgba(30, 64, 175, 0.06);
}

.profile-avatar {
  width: 58px !important;
  height: 58px !important;
  flex: 0 0 58px;
  display: grid;
  place-items: center;
  overflow: hidden;
  border: 2px solid #ffffff;
  border-radius: 20px;
  background: #ffffff;
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.1);
}

.profile-avatar img {
  width: 100% !important;
  height: 100% !important;
  display: block;
  object-fit: cover;
  object-position: center top;
  border-radius: 18px;
}

.profile-avatar span {
  width: 100%;
  height: 100%;
  display: grid;
  place-items: center;
  color: #78350f;
  font-weight: 900;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
}

.profile-info {
  min-width: 220px;
}

.profile-info strong {
  display: block;
  color: #1e293b;
  font-size: 1.08rem;
}

.profile-info span {
  display: block;
  margin-top: 0.2rem;
  color: #64748b;
}

.profile-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.55rem;
  margin-left: auto;
  justify-content: flex-end;
}

.profile-meta span {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.48rem 0.7rem;
  border: 1px solid #bfdbfe;
  border-radius: 999px;
  color: #334155;
  font-size: 0.82rem;
  font-weight: 800;
  background: #ffffff;
}

.control-panel {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  padding: 1.05rem;
  border: 1px solid #dbeafe;
  border-radius: 24px;
  background: rgba(226, 243, 179, 0.78);
  box-shadow: 0 12px 26px rgba(30, 64, 175, 0.08);
}

.control-panel label {
  color: #334155;
  font-size: 0.9rem;
  font-weight: 900;
}

.round-select {
  width: 100%;
}

:deep(.round-select.p-dropdown),
:deep(.round-select .p-dropdown) {
  min-height: 50px;
  border: 1px solid #dbeafe;
  border-radius: 16px;
  background: #f8fafc;
  box-shadow: none;
}

:deep(.round-select .p-dropdown-label) {
  color: #0f172a;
  font-weight: 700;
}

:deep(.round-select .p-dropdown-trigger) {
  color: #2563eb;
}

.round-status {
  display: flex;
  align-items: flex-start;
  gap: 0.55rem;
  min-height: 46px;
  padding: 0.75rem;
  border: 1px solid #dbeafe;
  border-radius: 16px;
  color: #475569;
  font-size: 0.9rem;
  line-height: 1.45;
  background: #f8fafc;
}

.loading-card,
.empty-state {
  min-height: 320px;
  margin-top: 1.25rem;
  padding: 2rem;
  display: grid;
  place-items: center;
  text-align: center;
  border: 1px solid #e2e8f0;
  border-radius: 28px;
  color: #64748b;
  background: rgba(255, 255, 255, 0.86);
  box-shadow: 0 18px 40px rgba(15, 23, 42, 0.07);
}

.loading-card strong {
  margin-top: 0.8rem;
  color: #0f172a;
  font-size: 1.15rem;
}

.empty-icon {
  width: 78px;
  height: 78px;
  display: grid;
  place-items: center;
  margin-bottom: 1rem;
  border-radius: 26px;
  color: #2563eb;
  font-size: 2rem;
  background: linear-gradient(135deg, #dbeafe, #ccfbf1);
}

.summary-layout {
  display: grid;
  grid-template-columns: 380px minmax(0, 1fr) minmax(0, 1fr);
  gap: 1rem;
  margin-top: 1.25rem;
}

.score-hero-card,
.status-card,
.component-card,
.detail-card {
  padding: 1.2rem;
  border: 1px solid #e2e8f0;
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.92);
  box-shadow: 0 18px 42px rgba(15, 23, 42, 0.08), inset 0 1px 0 rgba(255, 255, 255, 0.75);
  animation: cardLiftIn 0.55s ease both;
}

.score-card-head,
.card-title-row,
.section-head {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: flex-start;
}

.score-card-head span,
.history-summary span,
.component-item span {
  color: #64748b;
  font-weight: 800;
}

.score-card-head h2 {
  margin: 0.1rem 0 0;
  color: #0f172a;
  font-size: 2.35rem;
  line-height: 1;
}

.score-ring-wrap {
  display: grid;
  place-items: center;
  padding: 1.35rem 0;
}

@property --score-deg {
  syntax: '<angle>';
  inherits: false;
  initial-value: 0deg;
}

.score-ring {
  width: 210px;
  height: 210px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background: conic-gradient(#32cd63 var(--score-deg), #e2e8f0 0deg);
  transition: --score-deg 1.25s cubic-bezier(0.22, 1, 0.36, 1);
  animation: scorePop 0.85s ease both;
}

.score-ring-inner {
  width: 150px;
  height: 150px;
  display: grid;
  place-items: center;
  align-content: center;
  border-radius: 50%;
  background: #ffffff;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.1);
}

.score-ring-inner strong {
  color: #0f172a;
  font-size: 2.15rem;
  line-height: 1;
}

.score-ring-inner span {
  margin-top: 0.2rem;
  color: #94a3b8;
  font-weight: 800;
}

.score-level-box {
  padding: 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 22px;
  background: #f8fafc;
}

.score-level-box span {
  display: block;
  color: #64748b;
  font-weight: 800;
}

.score-level-box strong {
  display: block;
  margin-top: 0.15rem;
  font-size: 1.35rem;
}

.score-level-box.excellent { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
.score-level-box.very-good { background: #e0f2fe; border-color: #bae6fd; color: #075985; }
.score-level-box.good { background: #eef2ff; border-color: #c7d2fe; color: #3730a3; }
.score-level-box.fair { background: #fef3c7; border-color: #fde68a; color: #92400e; }
.score-level-box.improve { background: #fee2e2; border-color: #fecaca; color: #991b1b; }
.score-level-box.pending { color: #64748b; }

.card-title-row h3,
.section-head h2 {
  margin: 0;
  color: #0f172a;
  font-size: 1.15rem;
}

.soft-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 18px;
  color: #2563eb;
  font-size: 1.25rem;
  background: #dbeafe;
}

.soft-icon.alt,
.history-icon {
  color: #0f766e;
  background: #ccfbf1;
}

.history-summary {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.7rem;
  margin: 1rem 0 1.15rem;
}

.history-summary div,
.component-item {
  padding: 0.85rem;
  border: 1px solid #e2e8f0;
  border-radius: 16px;
  background: #f8fafc;
}

.history-summary strong,
.component-item strong {
  display: block;
  margin-top: 0.2rem;
  color: #0f172a;
  font-size: 1.25rem;
  line-height: 1;
}

.history-loading,
.history-empty {
  min-height: 170px;
  display: grid;
  place-items: center;
  gap: 0.65rem;
  border: 1px dashed #cbd5e1;
  border-radius: 20px;
  color: #64748b;
  font-weight: 800;
  background: #f8fafc;
}

.grouped-history-chart {
  position: relative;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(88px, 1fr));
  align-items: end;
  gap: 0.95rem;
  height: 250px;
  padding: 1.45rem 1rem 2.65rem;
  overflow: hidden;
  border: 1px solid #e2e8f0;
  border-radius: 20px;
  background: #ffffff;
}

.history-grid-line {
  position: absolute;
  left: 0.9rem;
  right: 0.9rem;
  height: 1px;
  z-index: 0;
  border-top: 1px dashed #dbeafe;
  color: #94a3b8;
  font-size: 0.68rem;
  font-weight: 800;
  pointer-events: none;
}

.line-100 { top: 1rem; }
.line-75 { top: 25%; }
.line-50 { top: 50%; }

.history-year-group {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-rows: 1fr 26px;
  align-items: end;
  justify-items: center;
  height: 100%;
  animation: barGroupIn 0.45s ease both;
}

.history-bars-pair {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  gap: 0.38rem;
  height: 100%;
}

.history-bar-item {
  display: grid;
  grid-template-rows: 24px 1fr;
  align-items: end;
  justify-items: center;
  height: 100%;
}

.history-score,
.history-year-label {
  color: #475569;
  font-size: 0.72rem;
  font-weight: 900;
}

.history-bar-track {
  width: 28px;
  height: 142px;
  display: flex;
  align-items: flex-end;
  overflow: hidden;
  border-radius: 7px 7px 3px 3px;
  background: #e2e8f0;
  box-shadow: inset 0 1px 3px rgba(15, 23, 42, 0.08);
}

.history-bar-fill {
  width: 100%;
  min-height: 4px;
  border-radius: 7px 7px 3px 3px;
  transition: height 1.25s cubic-bezier(0.22, 1, 0.36, 1);
}

.round-one .history-bar-fill { background: linear-gradient(180deg, #60a5fa 0%, #2563eb 100%); }
.round-two .history-bar-fill { background: linear-gradient(180deg, #f87171 0%, #dc2626 100%); }
.history-bar-item.active .history-bar-track { outline: 2px solid rgba(245, 158, 11, 0.35); background: #fef3c7; }
.history-bar-item.active .history-score { color: #b45309; }

.history-legend {
  position: absolute;
  right: 1rem;
  bottom: 0.65rem;
  z-index: 2;
  display: flex;
  gap: 0.9rem;
  padding: 0.35rem 0.55rem;
  border: 1px solid #e2e8f0;
  border-radius: 999px;
  color: #475569;
  font-size: 0.72rem;
  font-weight: 900;
  background: rgba(255, 255, 255, 0.86);
}

.history-legend span {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
}

.history-legend i {
  width: 10px;
  height: 10px;
  display: inline-block;
  border-radius: 2px;
}

.legend-one { background: #2563eb; }
.legend-two { background: #dc2626; }

.component-list {
  display: grid;
  gap: 0.85rem;
  margin-top: 1.1rem;
}

.component-item > div:first-child {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 1rem;
  margin-bottom: 0.7rem;
}

.component-item.highlight {
  background: linear-gradient(135deg, #eff6ff, #ecfeff);
  border-color: #bfdbfe;
}

.mini-bar {
  height: 10px;
  overflow: hidden;
  border-radius: 999px;
  background: #e2e8f0;
}

.mini-bar i {
  display: block;
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(90deg, #2563eb, #14b8a6);
  transition: width 1.15s cubic-bezier(0.22, 1, 0.36, 1);
}

.insight-section {
  display: grid;
  grid-template-columns: repeat(2, minmax(260px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.insight-card {
  display: flex;
  gap: 0.9rem;
  align-items: flex-start;
  padding: 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 24px;
  background: #ffffff;
}

.insight-card i {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 16px;
  font-size: 1.2rem;
}

.insight-card strong,
.insight-card span {
  display: block;
}

.insight-card span {
  margin-top: 0.25rem;
  color: #64748b;
}

.insight-card.neutral i { color: #2563eb; background: #dbeafe; }
.insight-card.warning { background: #fffbeb; border-color: #fde68a; }
.insight-card.warning i { color: #92400e; background: #fef3c7; }
.insight-card.danger { background: #fef2f2; border-color: #fecaca; }
.insight-card.danger i { color: #991b1b; background: #fee2e2; }

.detail-card {
  margin-top: 1rem;
}

.table-count {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 92px;
  padding: 0.55rem 0.8rem;
  border: 1px solid #bfdbfe;
  border-radius: 999px;
  color: #1d4ed8;
  font-weight: 900;
  background: #eff6ff;
}

.recommendation-card {
  background: radial-gradient(circle at top right, rgba(59, 130, 246, 0.1), transparent 32%), linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
}

.recommendation-loading,
.recommendation-empty {
  display: flex;
  align-items: center;
  gap: 1rem;
  min-height: 130px;
  padding: 1.1rem;
  border: 1px dashed #cbd5e1;
  border-radius: 22px;
  color: #64748b;
  font-weight: 800;
  background: #ffffff;
}

.recommendation-empty-icon {
  width: 56px;
  height: 56px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 20px;
  color: #16a34a;
  font-size: 1.5rem;
  background: #dcfce7;
}

.recommendation-empty strong,
.recommendation-empty span {
  display: block;
}

.recommendation-empty span {
  margin-top: 0.25rem;
  color: #64748b;
  font-weight: 600;
}

.recommendation-table-wrap {
  width: 100%;
  overflow-x: auto;
  border: 1px solid #dbeafe;
  border-radius: 22px;
  background: #ffffff;
  box-shadow: 0 12px 28px rgba(15, 23, 42, 0.06);
}

.recommendation-table {
  width: 100%;
  min-width: 760px;
  table-layout: fixed;
  border-collapse: separate;
  border-spacing: 0;
}

.recommendation-table th {
  padding: 0.9rem 1rem;
  border-bottom: 1px solid #bfdbfe;
  border-right: 1px solid #dbeafe;
  color: #0f172a;
  font-size: 0.9rem;
  font-weight: 900;
  text-align: left;
  background: linear-gradient(180deg, #f8fafc 0%, #eff6ff 100%);
}

.recommendation-table td {
  padding: 1rem;
  border-bottom: 1px solid #e2e8f0;
  border-right: 1px solid #e2e8f0;
  color: #334155;
  line-height: 1.6;
  vertical-align: top;
}

.recommendation-table th:last-child,
.recommendation-table td:last-child {
  border-right: none;
}

.recommendation-table tr:last-child td {
  border-bottom: none;
}

.recommendation-table tbody tr:hover {
  background: #fffafa;
}

.recommendation-table .col-no {
  width: 70px;
  text-align: center;
  font-weight: 800;
}

.recommendation-table .col-work {
  width: 45%;
  text-align: left;
}

.recommendation-table .col-recommend {
  width: 55%;
  text-align: left;
}

.work-title strong {
  display: inline;
  color: #0f172a;
  font-weight: 900;
}

.work-title span {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  margin-left: 0.35rem;
  color: #334155;
  font-size: 0.86rem;
} 
.recommend-red-text {
  color: #dc2626;
}

.recommend-red-label {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  margin-bottom: 0.25rem;
  color: #0f172a !important;
  font-size: 0.86rem;
  font-weight: 900;
}

.recommend-red-label i {
  color: #0f172a !important;
}

.recommend-red-text p {
  margin: 0;
  color: #dc2626 !important;
  font-weight: 900;
  line-height: 1.7;
  white-space: pre-line;
} 
@keyframes scorePop {
  0% { transform: scale(0.92); }
  65% { transform: scale(1.035); }
  100% { transform: scale(1); }
}

@keyframes cardLiftIn {
  0% { opacity: 0; transform: translateY(14px); }
  100% { opacity: 1; transform: translateY(0); }
}

@keyframes barGroupIn {
  0% { opacity: 0; transform: translateY(12px) scale(0.96); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}


  .score-wait-card {
  min-height: 300px;
  margin-top: 1.25rem;
  padding: 2rem;
  display: grid;
  place-items: center;
  text-align: center;
  border: 1px dashed #bfdbfe;
  border-radius: 28px;
  color: #64748b;
  background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
  box-shadow: 0 18px 40px rgba(15, 23, 42, 0.07);
}

/* กล่องรอประกาศผลคะแนน */
.score-wait-card {
  min-height: 300px;
  margin-top: 1.25rem;
  padding: 2rem;
  display: grid;
  place-items: center;
  text-align: center;
  border: 1px dashed #ef4444;
  border-radius: 28px;
  background: linear-gradient(180deg, #fff5f5 0%, #fee2e2 100%);
  box-shadow: 0 18px 40px rgba(220, 38, 38, 0.12);
}

/* ไอคอนนาฬิกา */
.score-wait-icon {
  width: 78px;
  height: 78px;
  display: grid;
  place-items: center;
  margin-bottom: 1rem;
  border-radius: 26px;
  color: #dc2626;
  font-size: 2rem;
  background: #fecaca;
}

/* หัวข้อ: รอประกาศผลคะแนน */
.score-wait-card h2 {
  margin: 0;
  color: #dc2626 !important;
  font-size: 1.6rem;
  font-weight: 900;
}

/* บรรทัดวันที่ประกาศ */
.score-wait-card p {
  margin: 0.65rem 0 0.25rem;
  color: #b91c1c !important;
  font-size: 1.05rem;
  font-weight: 900;
}

/* ข้อความอธิบาย */
.score-wait-card span {
  color: #991b1b !important;
  font-weight: 700;
  line-height: 1.6;
}
 
@media (max-width: 1180px) {
  .hero-content,
  .summary-layout {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 900px) {
  .personal-dashboard {
    padding: 1rem;
  }

  .profile-strip {
    align-items: flex-start;
    flex-direction: column;
  }

  .profile-meta {
    margin-left: 0;
    justify-content: flex-start;
  }

  .history-summary,
  .insight-section {
    grid-template-columns: 1fr;
  }

  .grouped-history-chart {
    grid-template-columns: repeat(auto-fit, minmax(86px, 1fr));
    height: 260px;
  }

  .recommendation-table {
    min-width: 760px;
  }
}

@media (max-width: 620px) {
  .hero-shell {
    padding: 1rem;
    border-radius: 24px;
  }

  .hero-copy h3 {
    font-size: 1.5rem;
  }

  .section-head,
  .component-item > div:first-child {
    flex-direction: column;
    gap: 0.25rem;
  }

  .work-title .main-work-title {
    display: block;
    color: #0f172a;
    font-weight: 900;
    line-height: 1.5;
  }

  .work-title .round-line {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    margin-top: 0.25rem;
    margin-left: 0;
    color: #64748b;
    font-size: 0.86rem;
    font-weight: 700;
  }

  .activity-subject-line {
    margin-top: 0.5rem;
    padding: 0.55rem 0.65rem;
    border-left: 4px solid #2563eb;
    border-radius: 10px;
    background: #eff6ff;
    color: #0f172a;
    line-height: 1.55;
  }

  .activity-subject-line strong {
    display: inline;
    margin-right: 0.35rem;
    color: #1d4ed8;
    font-weight: 900;
  }

  .activity-subject-line span {
    display: inline;
    margin-left: 0;
    color: #0f172a;
    font-weight: 800;
  }
 
  
}


</style>