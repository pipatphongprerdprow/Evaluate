<template>
  <div class="personal-dashboard">
    <!-- TOP HERO -->
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

          <p>
            Dashboard แสดงสถานะ คะแนน และรายละเอียดผลการประเมิน
          </p>

          <div class="profile-strip"> 

            <div class="profile-avatar">
              <img
                v-if="profileImageSrc && !profileImageLoadError"
                :src="profileImageSrc"
                :alt="profileFullName"
                @error="profileImageLoadError = true"
              /> 
              <span v-else>
                {{ profileInitial }}
              </span>
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

          <Dropdown
            v-model="tracking_date"
            :options="tracking_dates || []"
            :optionLabel="roundOptionLabel"
            placeholder="กรุณาเลือกรอบการประเมิน"
            class="round-select"
            :disabled="loading"
            @change="onRoundChanged"
          />

          <div class="round-status">
            <i class="pi pi-calendar"></i>
            <span>{{ selectedRoundText }}</span>
          </div>

          <!-- <Button
            label="Export PDF"
            icon="pi pi-file-pdf"
            severity="danger"
            outlined
            class="export-btn"
            :disabled="loading || !tracking_date || totalStaff === 0"
            @click="printDatatrackingpdf"
          /> -->
        </div>
      </div>
    </section>

    <!-- LOADING -->
    <section v-if="loading" class="loading-card">
      <ProgressSpinner style="width:62px;height:62px" strokeWidth="6" />
      <strong>กำลังโหลดข้อมูลผลการประเมิน…</strong>
      <span>ระบบกำลังดึงข้อมูลเฉพาะของผู้ใช้งานที่เข้าสู่ระบบ</span>
    </section>

    <!-- EMPTY BEFORE SELECT ROUND -->
    <section v-else-if="!tracking_date" class="empty-state">
      <div class="empty-icon">
        <i class="pi pi-calendar-plus"></i>
      </div>
      <h2>กรุณาเลือกรอบการประเมิน</h2>
      <p>
        เมื่อเลือกรอบการประเมินแล้ว ระบบจะแสดงข้อมูลให้อัตโนมัติ โดยไม่ต้องกดปุ่มค้นหา
      </p>
    </section>

    <!-- MAIN DASHBOARD -->
    <template v-else>
      <!-- SUMMARY AREA -->
      <section class="summary-layout">
        <!-- MAIN SCORE CARD -->
        <div class="score-hero-card">
          <div class="score-card-head">
            <div>
              <span>คะแนนรวม</span>
              <h2>{{ displayTotalScore }}</h2>
            </div>

            <Tag
              :value="statusText"
              :severity="statusSeverity"
              rounded
            />
          </div>

          <div class="score-ring-wrap">
            <div
              class="score-ring"
              :style="scoreRingStyle"
            >
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

        <!-- STATUS CARD -->
        <div class="status-card">
          <div class="card-title-row">
            <div>
              <h3>สถานะการประเมิน</h3>
              <p>ข้อมูลเฉพาะเจ้าของบัญชี</p>
            </div>

            <div class="soft-icon">
              <i class="pi pi-user-check"></i>
            </div>
          </div>

          <div class="status-big">
            <strong>{{ completedPercent }}%</strong>
            <span>{{ hasEvaluation ? 'มีข้อมูลการประเมินแล้ว' : 'ยังไม่มีข้อมูลการประเมิน' }}</span>
          </div>

          <ProgressBar :value="completedPercent" />

          <div class="status-grid">
            <div>
              <span>รายการทั้งหมด</span>
              <strong>{{ totalStaff }}</strong>
            </div>
            <div>
              <span>ประเมินแล้ว</span>
              <strong>{{ completedStaff }}</strong>
            </div>
            <div>
              <span>รอข้อมูล</span>
              <strong>{{ pendingStaff }}</strong>
            </div>
          </div>
        </div>

        <!-- SCORE COMPONENTS -->
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

      <!-- LEVEL CARDS -->
      <section class="level-section">
        <div class="section-head">
          <div>
            <h2>ระดับผลการประเมิน</h2>
            <p>คลิกที่ระดับเพื่อดูรายละเอียดข้อมูลในระดับนั้น</p>
          </div>
        </div>

        <div class="level-grid">
          <div
            class="level-card excellent clickable-level"
            @click="openLevelDialog('outstanding')"
          >
            <span>ดีเด่น</span>
            <strong>{{ outstandingCount }}</strong>
            <small>90 - 100 คะแนน</small>
          </div>

          <div
            class="level-card very-good clickable-level"
            @click="openLevelDialog('veryGood')"
          >
            <span>ดีมาก</span>
            <strong>{{ veryGoodCount }}</strong>
            <small>80 - 89 คะแนน</small>
          </div>

          <div
            class="level-card good clickable-level"
            @click="openLevelDialog('good')"
          >
            <span>ดี</span>
            <strong>{{ goodCount }}</strong>
            <small>70 - 79 คะแนน</small>
          </div>

          <div
            class="level-card fair clickable-level"
            @click="openLevelDialog('fair')"
          >
            <span>พอใช้</span>
            <strong>{{ fairCount }}</strong>
            <small>60 - 69 คะแนน</small>
          </div>

          <div
            class="level-card improve clickable-level"
            @click="openLevelDialog('improve')"
          >
            <span>ต้องปรับปรุง</span>
            <strong>{{ improveCount }}</strong>
            <small>ต่ำกว่า 60 คะแนน</small>
          </div>
        </div>
      </section>

      <!-- ALERT -->
      <section
        v-if="pendingStaff > 0 || lowScoreRows.length > 0 || dashboardRows.length === 0"
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

      <!-- DETAIL TABLE -->
      <section class="detail-card">
        <div class="section-head table-head">
          <div>
            <h2>รายละเอียดผลการประเมิน</h2>
            <p>แสดงเฉพาะข้อมูลของเจ้าของบัญชีที่เข้าสู่ระบบเท่านั้น</p>
          </div>

          <span class="table-count">
            {{ dashboardRows.length }} รายการ
          </span>
        </div>

        <DataTable
          :value="dashboardRows"
          :paginator="dashboardRows.length > 10"
          :rows="10"
          responsiveLayout="scroll"
          stripedRows
          dataKey="staffid"
          class="modern-table"
        >
          <Column header="ผู้รับการประเมิน" style="min-width: 280px">
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

          <Column header="สถานะ" style="width: 150px">
            <template #body="slotProps">
              <Tag
                :value="slotProps.data.tb_tor ? 'ประเมินแล้ว' : 'รอข้อมูล'"
                :severity="slotProps.data.tb_tor ? 'success' : 'warning'"
                rounded
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
                {{ Number(slotProps.data.tb_tor.sum_score || 0).toFixed(2) }}
              </div>

              <span v-else>-</span>
            </template>
          </Column>

          <Column header="ระดับ" style="width: 140px">
            <template #body="slotProps">
              <span v-if="slotProps.data.tb_tor" class="level-text">
                {{ scoreLevel(slotProps.data.tb_tor.sum_score) }}
              </span>
              <span v-else>-</span>
            </template>
          </Column>
        </DataTable>
      </section>
    </template>

    <!-- LEVEL DETAIL DIALOG -->
    <Dialog
      v-model:visible="levelDialogVisible"
      :modal="true"
      :style="{ width: '820px', maxWidth: '95vw' }"
      :breakpoints="{ '960px': '90vw', '640px': '96vw' }"
    >
      <template #header>
        <div>
          <h3 class="dialog-title">{{ selectedLevelTitle }}</h3>
          <p class="dialog-subtitle">
            จำนวน {{ selectedLevelRows.length }} รายการ
            <span v-if="dashboardRows.length === 0">
              — ยังไม่มีข้อมูลในรอบประเมินที่เลือก
            </span>
          </p>
        </div>
      </template>

      <DataTable
        :value="selectedLevelRows"
        :paginator="selectedLevelRows.length > 8"
        :rows="8"
        responsiveLayout="scroll"
        stripedRows
        dataKey="staffid"
        class="level-detail-table"
      >
        <Column header="ผู้รับการประเมิน" style="min-width: 280px">
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
        ไม่มีข้อมูลในระดับนี้
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
  </div>
</template>

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

      currentUserProfile: {},
      profileImageLoadError: false,
    };
  },

  computed: {
    evaluatedRows() {
      const rows = Array.isArray(this.products) ? this.products : [];

      return [...rows]
        .filter((item) => item)
        .map((item) => this.normalizeRow(item))
        .filter((item) => this.isLoginStaffRow(item))
        .sort((a, b) => Number(!!b.tb_tor) - Number(!!a.tb_tor));
    },

    dashboardRows() {
      return this.evaluatedRows;
    },

    personalRow() {
      return this.dashboardRows?.[0] || null;
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
        return sum + (this.parseScore(item?.tb_tor?.sum_score) || 0);
      }, 0);

      return (total / this.evaluatedOnly.length).toFixed(2);
    },

    avgTotalScore() {
      return this.avgScore;
    },

    avgAchievement() {
      if (!this.evaluatedOnly.length) return 0;

      const total = this.evaluatedOnly.reduce((sum, item) => {
        return sum + (this.parseScore(item?.tb_tor?.achievement_score) || 0);
      }, 0);

      return Number((total / this.evaluatedOnly.length).toFixed(2));
    },

    avgAchievementScore() {
      return Number(this.avgAchievement).toFixed(2);
    },

    avgBehavior() {
      if (!this.evaluatedOnly.length) return 0;

      const total = this.evaluatedOnly.reduce((sum, item) => {
        return sum + (this.parseScore(item?.tb_tor?.behavior) || 0);
      }, 0);

      return Number((total / this.evaluatedOnly.length).toFixed(2));
    },

    avgBehaviorScore() {
      return Number(this.avgBehavior).toFixed(2);
    },

    scoreValue() {
      if (!this.hasEvaluation) return 0;
      return this.parseScore(this.personalRow?.tb_tor?.sum_score);
    },

    displayTotalScore() {
      if (!this.hasEvaluation) return '0.00';
      return Number(this.scoreValue || 0).toFixed(2);
    },

    scoreRingStyle() {
      const safeScore = Math.max(0, Math.min(Number(this.scoreValue) || 0, 100));
      return {
        '--score-deg': `${safeScore * 3.6}deg`,
      };
    },

    // achievementPercentWidth() {
    //   return `${Math.max(0, Math.min(Number(this.avgAchievement) || 0, 100))}%`;
    // },

    // behaviorPercentWidth() {
    //   return `${Math.max(0, Math.min(Number(this.avgBehavior) || 0, 100))}%`;
    // },

    // totalPercentWidth() {
    //   return `${Math.max(0, Math.min(Number(this.scoreValue) || 0, 100))}%`;
    // },
    achievementPercentWidth() {
      return this.percentWidthFromScore(this.avgAchievement, 1);
    },

    behaviorPercentWidth() {
      return this.percentWidthFromScore(this.avgBehavior, 1);
    },

    totalPercentWidth() {
      return this.percentWidthFromScore(this.scoreValue, 100);
    },
 
    currentLevelText() {
      if (!this.hasEvaluation) return 'รอข้อมูล';
      return this.scoreLevel(this.scoreValue);
    },

    currentLevelClass() {
      if (!this.hasEvaluation) return 'pending';
      return this.scoreClass(this.scoreValue);
    },

    statusText() {
      return this.hasEvaluation ? 'ประเมินแล้ว' : 'รอข้อมูล';
    },

    statusSeverity() {
      return this.hasEvaluation ? 'success' : 'warning';
    },

    lowScoreStaff() {
      return this.evaluatedOnly.filter((item) => {
        return this.parseScore(item?.tb_tor?.sum_score) < 70;
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
        improve: 0,
      };

      this.evaluatedOnly.forEach((item) => {
        const score = this.parseScore(item?.tb_tor?.sum_score);

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

        const score = this.parseScore(item.tb_tor.sum_score);

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

    profileFullName() {
      const row = this.personalRow || {};
      const prefix = row.prefixfullname || this.currentUserProfile.PREFIXFULLNAME || '';
      const name =
        row.namefully ||
        `${this.currentUserProfile.STAFFNAME || ''} ${this.currentUserProfile.STAFFSURNAME || ''}`.trim();

      return `${prefix || ''}${prefix && name ? ' ' : ''}${name || 'ผู้ใช้งานระบบ'}`.trim();
    },

    profileInitial() {
      const name =
        this.personalRow?.namefully ||
        this.currentUserProfile.STAFFNAME ||
        this.profileFullName ||
        'P';

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

    selectedRoundText() {
      if (!this.tracking_date) return 'ยังไม่ได้เลือกรอบการประเมิน';
      return this.roundOptionLabel(this.tracking_date);
    },

    profileImageSrc() {
      const staffid = this.normalizeStaffId(
        this.staffid_Main ||
        this.currentUserProfile.STAFFID ||
        this.personalRow?.staffid ||
        this.personalRow?.STAFFID ||
        this.personalRow?.staff_id ||
        ''
      );

      if (!staffid) return '';

      return `https://pd.msu.ac.th/staff/picture/${staffid}.jpg`;
    },


  },

  async mounted() {
    try {
      const { getSession } = await useAuth();
      const user = await getSession();

      const sessionName = user?.user?.name || {};
      const { STAFFID, SCOPES } = sessionName;
      const { staffdepartment, groupid } = SCOPES || {};

      this.currentUserProfile = sessionName;

      this.setSession(
        STAFFID,
        staffdepartment,
        groupid,
        sessionName.POSTYPENAME,
        sessionName.POSITIONNAMEID
      );

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

  methods: {
    setSession(staffid_Main, facid_Main, groupid_Main, postypename, postypenameid) {
      this.staffid_Main = staffid_Main;
      this.facid_Main = facid_Main;
      this.groupid_Main = groupid_Main;
      this.postypename = postypename;
      this.postypenameid = postypenameid;
    },

    roundOptionLabel(item) {
      if (!item) return '';
      return `${item.facuties || ''} ${item.d_evaluationround || ''} ${item.d_date || ''}`.trim();
    },

    getRoundKey(item) {
      if (!item) return '';
      return [
        item.fac_id,
        item.evalua,
        item.d_date,
        item.d_evaluationround,
      ].join('|');
    },

    async onRoundChanged() {
      if (!this.tracking_date || this.tracking_date?.evalua === undefined) {
        this.products = [];
        return;
      }

      await this.withLoading(async () => {
        await this.showDataEvalu();
      });
    },

    normalizeStaffId(value) {
      return String(value ?? '')
        .replace(/\s+/g, '')
        .trim();
    },

    parseScore(value) {
      const score = parseFloat(String(value ?? '0').replace(',', '').trim());
      return Number.isNaN(score) ? 0 : score;
    },

    normalizeRow(item) {
      const tor = Array.isArray(item?.tb_tor)
        ? item.tb_tor[0] || null
        : item?.tb_tor || null;

      return {
        ...item,
        tb_tor: tor,
      };
    },

    getRowStaffId(item) {
      const normalizedItem = this.normalizeRow(item);

      return this.normalizeStaffId(
        normalizedItem?.staffid ||
        normalizedItem?.STAFFID ||
        normalizedItem?.staff_id ||
        normalizedItem?.staffId ||
        normalizedItem?.STAFF_ID ||
        normalizedItem?.tb_tor?.staffid ||
        normalizedItem?.tb_tor?.STAFFID ||
        normalizedItem?.tb_tor?.staff_id ||
        normalizedItem?.tb_tor?.staffId ||
        normalizedItem?.tb_tor?.STAFF_ID ||
        ''
      );
    },

    isLoginStaffRow(item) {
      const loginStaffId = this.normalizeStaffId(this.staffid_Main);
      const rowStaffId = this.getRowStaffId(item);

      if (!loginStaffId || !rowStaffId) return false;

      return rowStaffId === loginStaffId;
    },

    filterOnlyLoginStaff(rows) {
      if (!Array.isArray(rows)) return [];

      return rows
        .map((item) => this.normalizeRow(item))
        .filter((item) => this.isLoginStaffRow(item));
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
          group_id: this.groupid_Main,
        });

        console.log('showDateSetleader:', res.data);

        this.tracking_dates = Array.isArray(res.data) ? res.data : [];

      } catch (error) {
        console.error('showDataSet error:', error);

        this.tracking_dates = [];

        Swal.fire({
          icon: 'error',
          title: 'โหลดรอบประเมินไม่สำเร็จ',
          text: 'กรุณาตรวจสอบ API showDateSetleader',
        });
      }
    },

    async showDataEvalu() {
      try {
        const res = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {
          params: {
            staff_id: this.staffid_Main,
            fac_id: this.tracking_date?.fac_id,
            group_id: this.groupid_Main,
            evalua: this.tracking_date?.evalua,
            p_year: this.tracking_date?.d_date,
          },
        });

        console.log('showDataEvalu raw:', res.data);

        const rows = Array.isArray(res.data) ? res.data : [];

        /*
          กรองข้อมูลเฉพาะผู้ที่ login เข้าระบบ
          เช่น staffid_Main = 5009942 จะเห็นเฉพาะ staffid 5009942
        */
        this.products = this.filterOnlyLoginStaff(rows);

        console.log('showDataEvalu filtered by login staff:', this.products);

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

    parsePersen(persen) {
      const [wAch, wBeh] = String(persen || '0:0')
        .split(':')
        .map((v) => parseFloat(v) || 0);

      return { wAch, wBeh };
    },

    calcAchievement(item) {
      if (!item?.tb_tor?.persen) return '';

      const { wAch } = this.parsePersen(item.tb_tor.persen);
      const ach = this.parseScore(item.tb_tor.achievement_score);

      return (wAch * ach).toFixed(2);
    },

    calcBehavior(item) {
      if (!item?.tb_tor?.persen) return '';

      const { wBeh } = this.parsePersen(item.tb_tor.persen);
      const beh = this.parseScore(item.tb_tor.behavior);

      return (wBeh * beh).toFixed(2);
    },

    scoreLevel(score) {
      const s = this.parseScore(score);

      if (s >= 90) return 'ดีเด่น';
      if (s >= 80) return 'ดีมาก';
      if (s >= 70) return 'ดี';
      if (s >= 60) return 'พอใช้';

      return 'ต้องปรับปรุง';
    },

    scoreClass(score) {
      const s = this.parseScore(score);

      if (s >= 90) return 'excellent';
      if (s >= 80) return 'very-good';
      if (s >= 70) return 'good';
      if (s >= 60) return 'fair';

      return 'improve';
    },

    getInitial(item) {
      const name = item?.namefully || item?.staffname || item?.STAFFNAME || '';
      return name.trim().slice(0, 1) || 'P';
    },

    openLevelDialog(levelKey) {
      const titleMap = {
        outstanding: 'รายละเอียดผลประเมินระดับดีเด่น',
        veryGood: 'รายละเอียดผลประเมินระดับดีมาก',
        good: 'รายละเอียดผลประเมินระดับดี',
        fair: 'รายละเอียดผลประเมินระดับพอใช้',
        improve: 'รายละเอียดผลประเมินระดับต้องปรับปรุง',
      };

      this.selectedLevelKey = levelKey;
      this.selectedLevelTitle = titleMap[levelKey] || 'รายละเอียดผลการประเมิน';
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
          title: 'กรุณาเลือกรอบประเมินก่อน',
        });
        return;
      }

      try {
        const { getSession } = await useAuth();
        const user = await getSession();
        const sessionName = user?.user?.name || {};

        const form = {
          staff_id: this.staffid_Main,
          group_id: this.groupid_Main,
          fac_id: this.tracking_date.fac_id,
          year_id: this.tracking_date.d_date,
          evalua: this.tracking_date.evalua,
          PREFIXFULLNAME: sessionName.PREFIXFULLNAME,
          STAFFNAME: sessionName.STAFFNAME,
          STAFFSURNAME: sessionName.STAFFSURNAME,
          POSITIONNAME: sessionName.POSITIONNAME,
          GROUPTYPENAME: sessionName.GROUPTYPENAME,
          POSTYPENAME: sessionName.POSTYPENAME,
          SCOPES: sessionName?.SCOPES?.staffdepartmentname,
          postypename: `ระดับ${this.postypename}`,
          postypenameid: this.postypenameid,
          stftypename: this.stftypename,
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
          title: 'Export PDF ไม่สำเร็จ',
        });
      }
    },

    percentWidthFromScore(value, fullScore = 100) {
      const score = this.parseScore(value);
      const max = Number(fullScore) || 100;

      const percent = (score / max) * 100;

      return `${Math.max(0, Math.min(percent, 100))}%`;
    }, 
  },
};
</script>

<style scoped>
.personal-dashboard {
  position: relative;
  min-height: 100vh;
  padding: 1.5rem;
  background:
    radial-gradient(circle at top left, rgba(14, 165, 233, 0.18), transparent 28%),
    radial-gradient(circle at top right, rgba(20, 184, 166, 0.16), transparent 30%),
    linear-gradient(180deg, #eef5ff 0%, #f8fafc 42%, #ffffff 100%);
  color: #0f172a;
}

/* HERO */
.hero-shell {
  position: relative;
  overflow: hidden;
  border-radius: 32px;
  padding: 1.5rem;
  background:
    linear-gradient(135deg, rgba(15, 23, 42, 0.98) 0%, rgba(30, 64, 175, 0.94) 48%, rgba(13, 148, 136, 0.9) 100%);
  box-shadow:
    0 24px 55px rgba(15, 23, 42, 0.22),
    0 8px 24px rgba(13, 148, 136, 0.12);
}

.hero-bg-glow {
  position: absolute;
  border-radius: 999px;
  filter: blur(6px);
  opacity: 0.45;
  pointer-events: none;
}

.glow-one {
  width: 260px;
  height: 260px;
  right: -70px;
  top: -80px;
  background: rgba(34, 211, 238, 0.42);
}

.glow-two {
  width: 220px;
  height: 220px;
  left: 36%;
  bottom: -120px;
  background: rgba(250, 204, 21, 0.22);
}

.hero-content {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 380px;
  gap: 1.4rem;
  align-items: stretch;
}

.hero-copy {
  color: #ffffff;
  padding: 0.35rem 0.25rem;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.42rem 0.75rem;
  border-radius: 999px;
  font-size: 0.72rem;
  letter-spacing: 0.14em;
  font-weight: 900;
  color: rgba(255, 255, 255, 0.92);
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(10px);
}

.hero-copy h3 {
  margin: 1rem 0 0.5rem;
  font-size: clamp(2rem, 4vw, 3.15rem);
  line-height: 1.05;
  font-weight: 900;
  color: #ffffff;
  text-align: left;
}

.hero-copy p {
  margin: 0;
  max-width: 760px;
  color: rgba(255, 255, 255, 0.82);
  line-height: 1.7;
  font-size: 1rem;
}

.profile-strip {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.35rem;
  padding: 1rem;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(12px);
} 
.profile-avatar {
  width: 58px !important;
  height: 58px !important;
  min-width: 58px !important;
  max-width: 58px !important;
  min-height: 58px !important;
  max-height: 58px !important;
  display: grid;
  place-items: center;
  border-radius: 20px;
  overflow: hidden;
  flex: 0 0 58px;
  background: #ffffff;
  border: 2px solid #ffffff;
  box-shadow: 0 8px 18px rgba(15, 23, 42, 0.10);
}

.profile-avatar img {
  width: 100% !important;
  height: 100% !important;
  max-width: 100% !important;
  max-height: 100% !important;
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
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  color: #78350f;
  font-size: 1.3rem;
  font-weight: 900;
}

.profile-info {
  min-width: 220px;
}

.profile-info strong {
  display: block;
  color: #ffffff;
  font-size: 1.08rem;
}

.profile-info span {
  display: block;
  margin-top: 0.2rem;
  color: rgba(255, 255, 255, 0.72);
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
  border-radius: 999px;
  color: rgba(255, 255, 255, 0.86);
  background: rgba(15, 23, 42, 0.28);
  border: 1px solid rgba(255, 255, 255, 0.13);
  font-size: 0.82rem;
  font-weight: 700;
}

/* CONTROL PANEL */

/* HERO - โทนสีจืดแบบตัวอย่าง */
.hero-shell {
  position: relative;
  overflow: hidden;
  border-radius: 28px;
  padding: 1.4rem;
  background:
    linear-gradient(135deg, #eef4ff 0%, #eafcf7 58%, #ffffff 100%);
  box-shadow:
    0 14px 34px rgba(30, 64, 175, 0.08),
    0 4px 14px rgba(15, 118, 110, 0.05);
  border: 1px solid #c7d2fe;
}

/* ถ้าไม่อยากให้มีแสงฟุ้งเข้ม ให้ลด opacity */
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

.hero-copy {
  color: #172554;
  padding: 0.35rem 0.25rem;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.48rem 0.9rem;
  border-radius: 999px;
  font-size: 0.78rem;
  letter-spacing: 0;
  font-weight: 900;
  color: #ffffff;
  background: linear-gradient(135deg, #60a5fa, #3b82f6);
  border: 1px solid rgba(59, 130, 246, 0.18);
  backdrop-filter: none;
  box-shadow: 0 8px 18px rgba(59, 130, 246, 0.16);
}

.hero-copy h3 {
  margin: 1rem 0 0.45rem;
  font-size: clamp(1.65rem, 3vw, 2.2rem);
  line-height: 1.18;
  font-weight: 900;
  color: #1e1b4b;
  text-align: left;
}

.hero-copy p {
  margin: 0;
  max-width: 780px;
  color: #475569;
  line-height: 1.65;
  font-size: 0.98rem;
}

/* กล่องข้อมูลผู้ใช้ ให้เป็นสีอ่อน */
.profile-strip {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-top: 1.2rem;
  padding: 1rem;
  border-radius: 22px;
  background: rgba(255, 255, 255, 0.66);
  border: 1px solid #dbeafe;
  backdrop-filter: blur(10px);
  box-shadow: 0 10px 24px rgba(30, 64, 175, 0.06);
}

.profile-avatar {
  width: 58px;
  height: 58px;
  display: grid;
  place-items: center;
  border-radius: 20px;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  color: #78350f;
  font-size: 1.6rem;
  font-weight: 900;
  box-shadow: none;
  flex-shrink: 0;
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

.profile-meta span {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.48rem 0.7rem;
  border-radius: 999px;
  color: #334155;
  background: #efbcbc;
  border: 1px solid #8cb5ec;
  font-size: 0.82rem;
  font-weight: 800;
}

/* CONTROL PANEL - กล่องเลือกรอบด้านขวา */
.control-panel {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  padding: 1.05rem;
  border-radius: 24px;
  background: rgba(226, 243, 179, 0.78);
  box-shadow: 0 12px 26px rgba(30, 64, 175, 0.08);
  border: 1px solid #dbeafe;
  align-self: stretch;
}

.control-panel label {
  color: #334155;
  font-weight: 900;
  font-size: 0.9rem;
}

.round-status {
  display: flex;
  align-items: flex-start;
  gap: 0.55rem;
  min-height: 46px;
  padding: 0.75rem;
  border-radius: 16px;
  background: #f8fafc;
  border: 1px solid #dbeafe;
  color: #475569;
  font-size: 0.9rem;
  line-height: 1.45;
}

.round-status i {
  margin-top: 0.15rem;
  color: #3b82f6;
}
.export-btn {
  width: 100%;
  justify-content: center;
  min-height: 46px;
  border-radius: 16px;
  font-weight: 900;
}

/* LOADING / EMPTY */
.loading-card,
.empty-state {
  margin-top: 1.25rem;
  display: grid;
  place-items: center;
  text-align: center;
  min-height: 320px;
  padding: 2rem;
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.86);
  border: 1px solid #e2e8f0;
  box-shadow: 0 18px 40px rgba(15, 23, 42, 0.07);
}

.loading-card strong {
  margin-top: 0.8rem;
  font-size: 1.15rem;
  color: #0f172a;
}

.loading-card span,
.empty-state p {
  color: #64748b;
}

.empty-icon {
  width: 78px;
  height: 78px;
  display: grid;
  place-items: center;
  border-radius: 26px;
  background: linear-gradient(135deg, #dbeafe, #ccfbf1);
  color: #2563eb;
  font-size: 2rem;
  margin-bottom: 1rem;
}

.empty-state h2 {
  margin: 0;
  color: #0f172a;
}

/* SUMMARY */
.summary-layout {
  display: grid;
  grid-template-columns: 380px minmax(0, 1fr) minmax(0, 1fr);
  gap: 1rem;
  margin-top: 1.25rem;
}

.score-hero-card,
.status-card,
.component-card,
.detail-card,
.level-section {
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid #e2e8f0;
  border-radius: 28px;
  box-shadow:
    0 18px 42px rgba(15, 23, 42, 0.08),
    inset 0 1px 0 rgba(255, 255, 255, 0.75);
}

.score-hero-card {
  padding: 1.25rem;
  background:
    radial-gradient(circle at top right, rgba(34, 211, 238, 0.18), transparent 34%),
    linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
}

.score-card-head {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: flex-start;
}

.score-card-head span {
  color: #64748b;
  font-weight: 800;
}

.score-card-head h2 {
  margin: 0.1rem 0 0;
  font-size: 2.35rem;
  color: #0f172a;
  line-height: 1;
}

.score-ring-wrap {
  display: grid;
  place-items: center;
  padding: 1.35rem 0;
}

.score-ring {
  width: 210px;
  height: 210px;
  display: grid;
  place-items: center;
  border-radius: 50%;
  background:
    conic-gradient(#0ea5e9 var(--score-deg), #e2e8f0 0deg);
  box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.04);
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
  font-size: 2.15rem;
  line-height: 1;
  color: #0f172a;
}

.score-ring-inner span {
  margin-top: 0.2rem;
  color: #94a3b8;
  font-weight: 800;
}

.score-level-box {
  padding: 1rem;
  border-radius: 22px;
  border: 1px solid #e2e8f0;
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

.score-level-box.excellent {
  background: #dcfce7;
  border-color: #bbf7d0;
  color: #166534;
}

.score-level-box.very-good {
  background: #e0f2fe;
  border-color: #bae6fd;
  color: #075985;
}

.score-level-box.good {
  background: #eef2ff;
  border-color: #c7d2fe;
  color: #3730a3;
}

.score-level-box.fair {
  background: #fef3c7;
  border-color: #fde68a;
  color: #92400e;
}

.score-level-box.improve {
  background: #fee2e2;
  border-color: #fecaca;
  color: #991b1b;
}

.score-level-box.pending {
  background: #f8fafc;
  border-color: #e2e8f0;
  color: #64748b;
}

.status-card,
.component-card {
  padding: 1.2rem;
}

.card-title-row {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: flex-start;
}

.card-title-row h3 {
  margin: 0;
  color: #0f172a;
  font-size: 1.15rem;
}

.card-title-row p {
  margin: 0.25rem 0 0;
  color: #64748b;
}

.soft-icon {
  width: 48px;
  height: 48px;
  display: grid;
  place-items: center;
  border-radius: 18px;
  background: #dbeafe;
  color: #2563eb;
  font-size: 1.25rem;
  flex-shrink: 0;
}

.soft-icon.alt {
  background: #ccfbf1;
  color: #0f766e;
}

.status-big {
  margin: 1.25rem 0 1rem;
}

.status-big strong {
  display: block;
  font-size: 3rem;
  line-height: 1;
  color: #0f172a;
}

.status-big span {
  display: block;
  margin-top: 0.35rem;
  color: #64748b;
  font-weight: 700;
}

.status-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.75rem;
  margin-top: 1rem;
}

.status-grid div {
  padding: 0.85rem;
  border-radius: 18px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
}

.status-grid span {
  display: block;
  color: #64748b;
  font-size: 0.82rem;
  font-weight: 800;
}

.status-grid strong {
  display: block;
  margin-top: 0.2rem;
  color: #0f172a;
  font-size: 1.35rem;
}

.component-list {
  display: grid;
  gap: 0.85rem;
  margin-top: 1.1rem;
}

.component-item {
  padding: 0.95rem;
  border-radius: 20px;
  background: #f8fafc;
  border: 1px solid #e2e8f0;
}

.component-item.highlight {
  background: linear-gradient(135deg, #eff6ff, #ecfeff);
  border-color: #bfdbfe;
}

.component-item > div:first-child {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 1rem;
  margin-bottom: 0.7rem;
}

.component-item span {
  color: #64748b;
  font-weight: 800;
}

.component-item strong {
  color: #0f172a;
  font-size: 1.25rem;
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
}

/* LEVEL */
.level-section,
.detail-card {
  margin-top: 1rem;
  padding: 1.2rem;
}

.section-head {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: flex-start;
  margin-bottom: 1rem;
}

.section-head h2 {
  margin: 0;
  color: #0f172a;
  font-size: 1.22rem;
}

.section-head p {
  margin: 0.25rem 0 0;
  color: #64748b;
}

.level-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(140px, 1fr));
  gap: 0.85rem;
}

.level-card {
  position: relative;
  overflow: hidden;
  padding: 1rem;
  min-height: 126px;
  border-radius: 24px;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  box-shadow: 0 10px 24px rgba(15, 23, 42, 0.05);
}

.level-card::after {
  content: "";
  position: absolute;
  right: -26px;
  top: -28px;
  width: 86px;
  height: 86px;
  border-radius: 50%;
  opacity: 0.14;
}

.level-card span,
.level-card small,
.level-card strong {
  position: relative;
  z-index: 1;
  display: block;
}

.level-card span {
  font-weight: 900;
}

.level-card strong {
  margin: 0.28rem 0;
  font-size: 2.05rem;
  line-height: 1;
}

.level-card small {
  color: #64748b;
  font-weight: 700;
}

.clickable-level {
  cursor: pointer;
  transition: all 0.22s ease;
}

.clickable-level:hover {
  transform: translateY(-4px);
  box-shadow: 0 18px 32px rgba(15, 23, 42, 0.1);
}

.level-card.excellent {
  border-left: 6px solid #16a34a;
}

.level-card.excellent::after {
  background: #16a34a;
}

.level-card.very-good {
  border-left: 6px solid #0284c7;
}

.level-card.very-good::after {
  background: #0284c7;
}

.level-card.good {
  border-left: 6px solid #4f46e5;
}

.level-card.good::after {
  background: #4f46e5;
}

.level-card.fair {
  border-left: 6px solid #f59e0b;
}

.level-card.fair::after {
  background: #f59e0b;
}

.level-card.improve {
  border-left: 6px solid #dc2626;
}

.level-card.improve::after {
  background: #dc2626;
}

/* INSIGHT */
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
  border-radius: 24px;
  border: 1px solid #e2e8f0;
  background: #ffffff;
}

.insight-card i {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  border-radius: 16px;
  font-size: 1.2rem;
  flex-shrink: 0;
}

.insight-card strong {
  display: block;
  color: #0f172a;
}

.insight-card span {
  display: block;
  margin-top: 0.25rem;
  color: #64748b;
}

.insight-card.neutral i {
  color: #2563eb;
  background: #dbeafe;
}

.insight-card.warning {
  background: #fffbeb;
  border-color: #fde68a;
}

.insight-card.warning i {
  color: #92400e;
  background: #fef3c7;
}

.insight-card.danger {
  background: #fef2f2;
  border-color: #fecaca;
}

.insight-card.danger i {
  color: #991b1b;
  background: #fee2e2;
}

/* TABLE */
.table-head {
  align-items: center;
}

.table-count {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 92px;
  padding: 0.55rem 0.8rem;
  border-radius: 999px;
  background: #eff6ff;
  color: #2563eb;
  font-weight: 900;
  border: 1px solid #dbeafe;
}

.person-cell {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  text-align: left;
}

.avatar {
  width: 42px;
  height: 42px;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  border-radius: 16px;
  background: linear-gradient(135deg, #dbeafe, #ccfbf1);
  color: #075985;
  font-weight: 900;
}

.person-cell strong {
  display: block;
  color: #0f172a;
}

.person-cell small {
  display: block;
  margin-top: 0.15rem;
  color: #64748b;
}

.score-pill {
  display: inline-flex;
  min-width: 78px;
  justify-content: center;
  padding: 0.38rem 0.75rem;
  border-radius: 999px;
  font-weight: 900;
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

.level-text {
  font-weight: 900;
  color: #0f172a;
}

.dialog-title {
  margin: 0;
  color: #0f172a;
}

.dialog-subtitle {
  margin: 0.25rem 0 0;
  color: #64748b;
}

.empty-level {
  padding: 1rem;
  text-align: center;
  color: #64748b;
  font-weight: 800;
}

/* PrimeVue table refinement */
:deep(.modern-table .p-datatable-header),
:deep(.level-detail-table .p-datatable-header) {
  border: none;
}

:deep(.modern-table .p-datatable-thead > tr > th),
:deep(.level-detail-table .p-datatable-thead > tr > th) {
  background: #f8fafc;
  color: #334155;
  font-weight: 900;
  border-color: #e2e8f0;
}

:deep(.modern-table .p-datatable-tbody > tr > td),
:deep(.level-detail-table .p-datatable-tbody > tr > td) {
  border-color: #edf2f7;
}

/* RESPONSIVE */
@media (max-width: 1180px) {
  .hero-content {
    grid-template-columns: 1fr;
  }

  .control-panel {
    max-width: none;
  }

  .summary-layout {
    grid-template-columns: 1fr;
  }

  .score-hero-card {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto minmax(220px, 0.75fr);
    gap: 1rem;
    align-items: center;
  }

  .score-ring-wrap {
    padding: 0;
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

  .level-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .insight-section {
    grid-template-columns: 1fr;
  }

  .score-hero-card {
    display: block;
  }

  .score-ring-wrap {
    padding: 1.2rem 0;
  }
}

@media (max-width: 620px) {
  .hero-shell {
    padding: 1rem;
    border-radius: 24px;
  }

  .hero-copy h1 {
    font-size: 1.5rem;
  }

  .status-grid,
  .level-grid {
    grid-template-columns: 1fr;
  }

  .component-item > div:first-child {
    align-items: flex-start;
    flex-direction: column;
    gap: 0.25rem;
  }

  .section-head {
    flex-direction: column;
  }
}
</style>