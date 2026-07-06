<template>
  <main class="support-page">
    <!-- Header -->
    <section class="support-hero">
      <div class="hero-orb orb-one"></div>
      <div class="hero-orb orb-two"></div>
      <div class="hero-grid"></div>

      <div class="hero-content">
        <div class="hero-label">
          <i class="pi pi-sparkles"></i>
          ศูนย์สนับสนุนการใช้งานระบบ
        </div>

        <h1>ช่องทางการติดต่อผู้ดูแลระบบ</h1>

        <p>
          ติดต่อเจ้าหน้าที่ผู้รับผิดชอบด้านกระบวนการและการพัฒนาระบบ
          เพื่อรับคำแนะนำ แก้ไขปัญหา และสนับสนุนการใช้งานระบบอย่างมีประสิทธิภาพ
        </p>

        <div class="hero-meta">
          <div class="meta-item">
            <i class="pi pi-check-circle"></i>
            <span>ให้คำปรึกษาการใช้งานระบบ</span>
          </div>
          <div class="meta-item">
            <i class="pi pi-wrench"></i>
            <span>แก้ไขปัญหาเชิงเทคนิค</span>
          </div>
        </div>
      </div>

      <div class="hero-panel">
        <div class="panel-icon">
          <i class="pi pi-comments"></i>
        </div>

        <div class="panel-text">
          <span>พร้อมให้บริการ</span>
          <strong>ในวันและเวลาราชการ</strong> 
        </div>
      </div>
    </section>

    <!-- Main Contact -->
    <section class="admin-section">
      <div class="section-title">
        <span></span>
        <div>
          <p>System Administrator</p>
          <h2>ผู้ดูแลระบบ</h2>
        </div>
      </div>

      <div class="admin-list">
        <article
          v-for="(admin, idx) in admins"
          :key="idx"
          class="admin-card"
        >
          <div class="card-shine"></div>

          <div class="admin-left">
            <div class="avatar-box">
              <img :src="admin.avatar" :alt="admin.name" />
              <div class="status-dot"></div>
            </div>

            <div class="admin-detail">
              <div class="role-badge">
                <i class="pi pi-user"></i>
                {{ admin.role }}
              </div>

              <h3>{{ admin.name }}</h3>
              <p>{{ admin.position }}</p>
            </div>
          </div>

          <div class="admin-contact">
            <a
              v-if="admin.phone"
              :href="`tel:${admin.phone}`"
              class="contact-link phone"
            >
              <i class="pi pi-phone"></i>
              <div>
                <span>เบอร์โทรศัพท์ภายใน</span>
                <strong>{{ admin.phone }}</strong>
              </div>
            </a>

            <a
              v-if="admin.email"
              :href="`mailto:${admin.email}`"
              class="contact-link email"
            >
              <i class="pi pi-envelope"></i>
              <div>
                <span>อีเมล</span>
                <strong>{{ admin.email }}</strong>
              </div>
            </a>
          </div>
        </article>
      </div>
    </section>

    <!-- Help Desk -->
    <section class="help-section">
      <div class="section-title">
        <span></span>
        <div>
          <p>Additional Support</p>
          <h2>ช่องทางติดต่อเพิ่มเติม</h2>
        </div>
      </div>

      <div class="help-grid">
        <a
          href="https://anydesk.com/th/downloads"
          target="_blank"
          rel="noopener noreferrer"
          class="help-card"
        >
          <div class="help-icon image-icon">
            <img :src="anydeskLogo" alt="AnyDesk" />
          </div>

          <div>
            <span>ดาวน์โหลดโปรแกรม</span>
            <strong>AnyDesk</strong>
          </div>

          <i class="pi pi-arrow-up-right arrow"></i>
        </a>

        <a href="tel:1395" class="help-card">
          <div class="help-icon">
            <i class="pi pi-phone"></i>
          </div>

          <div>
            <span>โทรศัพท์ฝ่ายสนับสนุน</span>
            <strong>1395</strong>
          </div>

          <i class="pi pi-arrow-up-right arrow"></i>
        </a>

        <a href="mailto:Thanapong.r@msu.ac.th" class="help-card">
          <div class="help-icon">
            <i class="pi pi-envelope"></i>
          </div>

          <div>
            <span>อีเมลฝ่ายสนับสนุน</span>
            <strong>Thanapong.r@msu.ac.th</strong>
          </div>

          <i class="pi pi-arrow-up-right arrow"></i>
        </a>
      </div>
    </section>
  </main>
</template>

<script setup>
import { reactive } from 'vue'
import pipatphong from '~/assets/layout/images/pipatphong.jpg'
import Thanapong from '~/assets/layout/images/may.jpg'
import anydeskLogo from '~/assets/layout/images/anydesk.jpg'

const admins = reactive([
  {
    role: 'ผู้ดูแลด้านกระบวนการ',
    name: 'นายธนพงศ์ รักษาพล',
    position: 'บุคลากรปฏิบัติการ',
    phone: '1395',
    email: 'Thanapong.r@msu.ac.th',
    avatar: Thanapong
  },
  {
    role: 'ผู้ดูแลด้านพัฒนาระบบ',
    name: 'นายพิพัฒน์พงษ์ เพริดพราว',
    position: 'นักวิชาการคอมพิวเตอร์',
    phone: '1702',
    email: 'pipatphong.p@msu.ac.th',
    avatar: pipatphong
  }
])
</script>

<style scoped>
.support-page {
  --primary: #0d47a1;
  --primary-2: #1565c0;
  --primary-3: #1e88e5;
  --gold: #ffd54f;
  --gold-2: #fff3bf;
  --text: #172033;
  --muted: #64748b;
  --card: rgba(255, 255, 255, 0.88);
  --border: rgba(15, 45, 90, 0.1);
  --shadow: 0 22px 54px rgba(15, 45, 90, 0.11);

  min-height: 100vh;
  padding: 38px 20px 58px;
  font-family: 'Noto Sans Thai', 'Sarabun', sans-serif;
  color: var(--text);
  background:
    radial-gradient(circle at top left, rgba(255, 213, 79, 0.22), transparent 34%),
    radial-gradient(circle at top right, rgba(30, 136, 229, 0.16), transparent 36%),
    linear-gradient(180deg, #f8fbff 0%, #f4f7fb 52%, #eef4fb 100%);
}

/* Hero */
.support-hero {
  position: relative;
  isolation: isolate;
  max-width: 1180px;
  margin: 0 auto 36px;
  padding: 38px;
  border-radius: 34px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 340px;
  gap: 30px;
  align-items: center;
  overflow: hidden;
  background:
    linear-gradient(135deg, rgba(13, 71, 161, 0.98) 0%, rgba(21, 101, 192, 0.96) 54%, rgba(30, 136, 229, 0.94) 100%);
  box-shadow:
    0 30px 72px rgba(13, 71, 161, 0.26),
    inset 0 1px 0 rgba(255, 255, 255, 0.24);
}

.hero-grid {
  position: absolute;
  inset: 0;
  z-index: -1;
  opacity: 0.18;
  background-image:
    linear-gradient(rgba(255,255,255,0.28) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,0.28) 1px, transparent 1px);
  background-size: 34px 34px;
  mask-image: linear-gradient(90deg, transparent, #000 18%, #000 82%, transparent);
}

.hero-orb {
  position: absolute;
  z-index: -1;
  border-radius: 50%;
  filter: blur(1px);
}

.orb-one {
  width: 360px;
  height: 360px;
  right: -125px;
  top: -155px;
  background: rgba(255, 213, 79, 0.38);
}

.orb-two {
  width: 250px;
  height: 250px;
  left: -110px;
  bottom: -130px;
  background: rgba(255, 255, 255, 0.14);
}

.hero-content,
.hero-panel {
  position: relative;
  z-index: 1;
}

.hero-label {
  width: fit-content;
  display: inline-flex;
  align-items: center;
  gap: 9px;
  padding: 9px 17px;
  margin-bottom: 17px;
  border-radius: 999px;
  color: #102f55;
  background: linear-gradient(135deg, #fff8d7, var(--gold));
  border: 1px solid rgba(255, 255, 255, 0.38);
  box-shadow: 0 12px 28px rgba(255, 213, 79, 0.22);
  font-weight: 950;
  font-size: 0.96rem;
}

.hero-content h1 {
  margin: 0;
  color: #ffffff;
  font-size: clamp(2.1rem, 4vw, 3.15rem);
  font-weight: 1000;
  letter-spacing: -0.03em;
  line-height: 1.22;
  text-shadow: 0 14px 34px rgba(0, 0, 0, 0.16);
}

.hero-content p {
  max-width: 760px;
  margin: 15px 0 0;
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.06rem;
  line-height: 1.9;
}

.hero-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 22px;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 9px 13px;
  border-radius: 999px;
  color: #ffffff;
  background: rgba(255, 255, 255, 0.13);
  border: 1px solid rgba(255, 255, 255, 0.18);
  backdrop-filter: blur(12px);
  font-size: 0.92rem;
  font-weight: 800;
}

.meta-item i {
  color: var(--gold);
}

.hero-panel {
  min-height: 172px;
  padding: 25px;
  border-radius: 28px;
  display: flex;
  align-items: center;
  gap: 18px;
  background:
    linear-gradient(145deg, rgba(255,255,255,0.2), rgba(255,255,255,0.08));
  border: 1px solid rgba(255, 255, 255, 0.28);
  box-shadow:
    inset 0 1px 0 rgba(255,255,255,0.35),
    0 18px 46px rgba(0,0,0,0.12);
  backdrop-filter: blur(18px);
}

.panel-icon {
  width: 68px;
  height: 68px;
  border-radius: 24px;
  display: grid;
  place-items: center;
  background: #ffffff;
  color: var(--primary-2);
  font-size: 1.9rem;
  flex: 0 0 auto;
  box-shadow: 0 16px 34px rgba(0, 0, 0, 0.16);
}

.panel-text span {
  display: block;
  color: rgba(255, 255, 255, 0.78);
  font-size: 0.95rem;
  font-weight: 700;
}

.panel-text strong {
  display: block;
  margin-top: 3px;
  color: #ffffff;
  font-size: 1.28rem;
  font-weight: 1000;
  line-height: 1.4;
}

.panel-text small {
  display: block;
  margin-top: 8px;
  color: rgba(255, 255, 255, 0.72);
  font-size: 0.86rem;
  line-height: 1.65;
}

/* Section */
.admin-section,
.help-section {
  max-width: 1180px;
  margin: 0 auto 32px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 13px;
  margin-bottom: 19px;
}

.section-title > span {
  width: 8px;
  height: 42px;
  border-radius: 999px;
  background: linear-gradient(180deg, var(--primary-2), var(--gold));
  box-shadow: 0 10px 22px rgba(21, 101, 192, 0.18);
}

.section-title p {
  margin: 0 0 2px;
  color: var(--primary-2);
  font-size: 0.78rem;
  font-weight: 950;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.section-title h2 {
  margin: 0;
  color: #102f55;
  font-size: 1.48rem;
  font-weight: 1000;
  letter-spacing: -0.015em;
}

/* Admin Card */
.admin-list {
  display: grid;
  gap: 19px;
}

.admin-card {
  position: relative;
  overflow: hidden;
  display: grid;
  grid-template-columns: minmax(0, 1fr) 1.12fr;
  gap: 24px;
  align-items: center;
  padding: 25px;
  border-radius: 30px;
  background: var(--card);
  border: 1px solid var(--border);
  box-shadow: var(--shadow);
  backdrop-filter: blur(16px);
  transition:
    transform 0.25s ease,
    box-shadow 0.25s ease,
    border-color 0.25s ease;
}

.admin-card::before {
  content: '';
  position: absolute;
  inset: 0;
  background:
    radial-gradient(circle at 0% 0%, rgba(255, 213, 79, 0.16), transparent 34%),
    radial-gradient(circle at 100% 100%, rgba(21, 101, 192, 0.1), transparent 32%);
  opacity: 0;
  transition: opacity 0.25s ease;
}

.card-shine {
  position: absolute;
  width: 180px;
  height: 180px;
  right: -80px;
  top: -90px;
  border-radius: 50%;
  background: rgba(255, 213, 79, 0.18);
  pointer-events: none;
}

.admin-card:hover {
  transform: translateY(-6px);
  border-color: rgba(21, 101, 192, 0.18);
  box-shadow: 0 32px 70px rgba(15, 45, 90, 0.15);
}

.admin-card:hover::before {
  opacity: 1;
}

.admin-left,
.admin-contact {
  position: relative;
  z-index: 1;
}

.admin-left {
  display: flex;
  align-items: center;
  gap: 21px;
}

.avatar-box {
  position: relative;
  width: 120px;
  height: 120px;
  padding: 5px;
  border-radius: 30px;
  background:
    linear-gradient(135deg, var(--primary-2), var(--primary-3) 52%, var(--gold));
  box-shadow: 0 18px 38px rgba(21, 101, 192, 0.18);
  flex: 0 0 auto;
}

.avatar-box img {
  width: 100%;
  height: 100%;
  display: block;
  border-radius: 25px;
  object-fit: cover;
  background: #ffffff;
}

.status-dot {
  position: absolute;
  right: 8px;
  bottom: 8px;
  width: 18px;
  height: 18px;
  border-radius: 50%;
  background: #22c55e;
  border: 4px solid #ffffff;
  box-shadow: 0 0 0 5px rgba(34, 197, 94, 0.16);
}

.role-badge {
  width: fit-content;
  display: inline-flex;
  align-items: center;
  gap: 7px;
  padding: 6px 14px;
  margin-bottom: 9px;
  border-radius: 999px;
  color: var(--primary);
  background: linear-gradient(135deg, #eaf3ff, #f7fbff);
  border: 1px solid rgba(21, 101, 192, 0.1);
  font-size: 0.9rem;
  font-weight: 950;
}

.admin-detail h3 {
  margin: 0;
  color: var(--text);
  font-size: 1.38rem;
  font-weight: 1000;
  letter-spacing: -0.018em;
}

.admin-detail p {
  margin: 5px 0 0;
  color: var(--muted);
  font-size: 1rem;
  font-weight: 650;
}

.admin-contact {
  display: grid;
  grid-template-columns: repeat(2, minmax(180px, 1fr));
  gap: 13px;
}

.contact-link {
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  gap: 13px;
  padding: 16px;
  border-radius: 21px;
  text-decoration: none;
  background: rgba(248, 250, 252, 0.88);
  border: 1px solid rgba(15, 45, 90, 0.08);
  transition:
    transform 0.25s ease,
    background 0.25s ease,
    border-color 0.25s ease,
    box-shadow 0.25s ease;
}

.contact-link::after {
  content: '';
  position: absolute;
  inset: auto -30px -45px auto;
  width: 92px;
  height: 92px;
  border-radius: 50%;
  background: rgba(21, 101, 192, 0.08);
  transition: transform 0.25s ease;
}

.contact-link:hover {
  background: #ffffff;
  border-color: rgba(21, 101, 192, 0.18);
  transform: translateY(-4px);
  box-shadow: 0 18px 34px rgba(15, 45, 90, 0.09);
}

.contact-link:hover::after {
  transform: scale(1.22);
}

.contact-link > i {
  width: 44px;
  height: 44px;
  display: grid;
  place-items: center;
  border-radius: 17px;
  color: #ffffff;
  font-size: 1.16rem;
  flex: 0 0 auto;
  box-shadow: 0 12px 24px rgba(21, 101, 192, 0.18);
}

.contact-link.phone > i {
  background: linear-gradient(135deg, var(--primary-2), var(--primary));
}

.contact-link.email > i {
  background: linear-gradient(135deg, #f59e0b, var(--gold));
  color: #102f55;
}

.contact-link span {
  display: block;
  color: var(--muted);
  font-size: 0.88rem;
  font-weight: 650;
}

.contact-link strong {
  display: block;
  color: #102f55;
  font-size: 0.98rem;
  font-weight: 950;
  word-break: break-word;
}

/* Help */
.help-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(220px, 1fr));
  gap: 19px;
}

.help-card {
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 21px;
  min-height: 122px;
  border-radius: 28px;
  text-decoration: none;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--border);
  box-shadow: var(--shadow);
  backdrop-filter: blur(16px);
  transition:
    transform 0.25s ease,
    box-shadow 0.25s ease,
    border-color 0.25s ease;
}

.help-card::before {
  content: '';
  position: absolute;
  width: 130px;
  height: 130px;
  right: -65px;
  bottom: -72px;
  border-radius: 50%;
  background: rgba(21, 101, 192, 0.08);
  transition: transform 0.25s ease;
}

.help-card:hover {
  transform: translateY(-6px);
  border-color: rgba(21, 101, 192, 0.18);
  box-shadow: 0 32px 70px rgba(15, 45, 90, 0.15);
}

.help-card:hover::before {
  transform: scale(1.3);
}

.help-icon {
  position: relative;
  z-index: 1;
  width: 60px;
  height: 60px;
  border-radius: 22px;
  display: grid;
  place-items: center;
  background: linear-gradient(135deg, var(--primary-2), var(--primary));
  color: #ffffff;
  font-size: 1.58rem;
  flex: 0 0 auto;
  box-shadow: 0 15px 32px rgba(21, 101, 192, 0.18);
}

.image-icon {
  background: #f1f5f9;
}

.image-icon img {
  width: 39px;
  height: 39px;
  object-fit: contain;
}

.help-card div:not(.help-icon) {
  position: relative;
  z-index: 1;
}

.help-card span {
  display: block;
  color: var(--muted);
  font-size: 0.92rem;
  font-weight: 650;
}

.help-card strong {
  display: block;
  margin-top: 3px;
  color: #102f55;
  font-size: 1.03rem;
  font-weight: 1000;
  word-break: break-word;
}

.arrow {
  position: relative;
  z-index: 1;
  margin-left: auto;
  width: 34px;
  height: 34px;
  border-radius: 13px;
  display: grid;
  place-items: center;
  color: var(--primary-2);
  background: #eef6ff;
  font-size: 0.95rem;
  transition: transform 0.25s ease, background 0.25s ease;
}

.help-card:hover .arrow {
  transform: translate(3px, -3px);
  background: var(--gold-2);
}

/* Focus accessibility */
a:focus-visible {
  outline: 4px solid rgba(255, 213, 79, 0.55);
  outline-offset: 4px;
}

/* Responsive */
@media (max-width: 960px) {
  .support-hero {
    grid-template-columns: 1fr;
  }

  .hero-panel {
    min-height: auto;
  }

  .admin-card {
    grid-template-columns: 1fr;
  }

  .admin-contact {
    grid-template-columns: 1fr;
  }

  .help-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 560px) {
  .support-page {
    padding: 24px 14px 42px;
  }

  .support-hero {
    padding: 27px 20px;
    border-radius: 26px;
  }

  .hero-content h1 {
    font-size: 2rem;
  }

  .hero-content p {
    font-size: 0.98rem;
  }

  .hero-meta {
    flex-direction: column;
  }

  .hero-panel {
    align-items: flex-start;
    flex-direction: column;
  }

  .admin-card {
    padding: 20px;
    border-radius: 24px;
  }

  .admin-left {
    align-items: flex-start;
    gap: 15px;
  }

  .avatar-box {
    width: 90px;
    height: 90px;
    border-radius: 24px;
  }

  .avatar-box img {
    border-radius: 19px;
  }

  .admin-detail h3 {
    font-size: 1.16rem;
  }

  .help-card {
    align-items: flex-start;
  }
}
</style>