  <template>
    <div class="contact-admin-page">
      <!-- Hero Section -->
      <section class="hero-section">
        <!-- <div class="hero-badge">
          <i class="pi pi-shield"></i>
          MSU Support Center
        </div> -->
        <h1 class="page-title">ช่องทางการติดต่อผู้ดูแลระบบ</h1>
        <p class="page-subtitle">
          ติดต่อเจ้าหน้าที่ผู้ดูแลด้านกระบวนการและการพัฒนาระบบ เพื่อขอคำแนะนำ แก้ไขปัญหา หรือรับบริการสนับสนุน
        </p>
      </section>

      <!-- Admin Cards -->
      <div class="contact-cards">
        <div v-for="(admin, idx) in admins" :key="idx" class="contact-card">
          <div class="avatar-wrapper">
            <img :src="admin.avatar" alt="avatar" class="avatar" />
          </div>
          <div class="role-chip">{{ admin.role }}</div>
          <h3 class="admin-name">{{ admin.name }}</h3>
          <p class="admin-position">{{ admin.position }}</p>

          <div class="info-list">
            <div v-if="admin.phone" class="info-item">
              <i class="pi pi-phone"></i>
              <span>โทรศัพท์: <strong>{{ admin.phone }}</strong></span>
            </div>
            <div v-if="admin.email" class="info-item">
              <i class="pi pi-envelope"></i>
              <span>อีเมล: <strong>{{ admin.email }}</strong></span>
            </div>
          </div>

          <!-- <div class="card-actions">
            <a v-if="admin.phone" :href="`tel:${admin.phone}`" class="action-btn primary">
              <i class="pi pi-phone"></i> โทรติดต่อ
            </a>
            <a v-if="admin.email" :href="`mailto:${admin.email}`" class="action-btn secondary">
              <i class="pi pi-envelope"></i> ส่งอีเมล
            </a>
          </div> -->
          
        </div>
      </div>

      <!-- Help Section -->
      <section class="help-section">
        <h2 class="help-title"><i class="pi pi-info-circle"></i> ช่องทางติดต่อเพิ่มเติม</h2>
        <div class="help-grid">
          <a href="https://anydesk.com/th/downloads" target="_blank" class="help-card">
            <img :src="anydeskLogo" class="help-icon" alt="AnyDesk" />
            <span>ดาวน์โหลดโปรแกรม</span>
            <strong>AnyDesk</strong>
          </a>
          <div class="help-card">
            <i class="pi pi-phone help-icon"></i>
            <span>โทรศัพท์ฝ่ายสนับสนุน</span>
            <strong>1395</strong>
          </div>
          <div class="help-card">
            <i class="pi pi-envelope help-icon"></i>
            <span>อีเมลฝ่ายสนับสนุน</span>
            <strong>Thanapong.r@msu.ac.th</strong>
          </div>
        </div>
      </section>
    </div>
  </template>

  <script setup>
  import { reactive } from 'vue'
  import pipatphong from '~/assets/layout/images/pipatphong.jpg'
  import Thanapong from '~/assets/layout/images/may.jpg'
  import anydeskLogo from '~/assets/layout/images/anydesk.jpg'

  const admins = reactive([
    {
      role: 'กระบวนการ',
      name: 'นายธนพงศ์ รักษาพล',
      position: 'บุคลากรปฏิบัติการ',
      phone: '1395',
      email: 'Thanapong.r@msu.ac.th',
      avatar: Thanapong
    },
    {
      role: 'พัฒนาระบบ',
      name: 'นายพิพัฒน์พงษ์ เพริดพราว',
      position: 'นักวิชาการคอมพิวเตอร์',
      phone: '1702',
      email: 'pipatphong.p@msu.ac.th',
      avatar: pipatphong
    }
  ])
  </script>

  <style scoped> 
    .contact-admin-page {
      font-family: 'Noto Sans Thai', sans-serif;
      min-height: 100vh;
      padding: 40px 20px;
      background: linear-gradient(135deg, #eef5ff, #fff9e8);
    } 
    .hero-section {
      text-align: center;
      margin-bottom: 50px;
    }
    .hero-badge {
      display: inline-flex;
      align-items: center;
      padding: 6px 16px;
      background: #fff3c4;
      border-radius: 50px;
      font-weight: 700;
      margin-bottom: 16px;
    }
    .page-title {
      font-size: 2.5rem;
      font-weight: 900;
      color: #16345c;
    }
    .page-subtitle {
      color: #5f6f86;
      font-size: 1rem;
      max-width: 720px;
      margin: 8px auto 0;
    } 
    .contact-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
      gap: 28px;
      max-width: 1100px;
      margin: 0 auto 60px;
    }
    .contact-card {
      background: rgba(255, 255, 255, 0.85);
      backdrop-filter: blur(18px);
      border-radius: 24px;
      padding: 28px 20px;
      text-align: center;
      box-shadow: 0 20px 50px rgba(0,0,0,0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .contact-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 30px 70px rgba(0,0,0,0.15);
    }
    .avatar-wrapper {
      width: 140px;
      height: 140px;
      margin: 0 auto 12px;
      border-radius: 50%;
      padding: 4px;
      background: linear-gradient(135deg,#fbc02d,#1565c0);
    }
    .avatar {
      width: 100%;
      height: 100%;
      border-radius: 50%;
      object-fit: cover;
    }
    .role-chip {
      background: #edf6ff;
      color: #17406d;
      display: inline-block;
      padding: 4px 14px;
      border-radius: 50px;
      font-weight: 700;
      margin-bottom: 10px;
    }
    .admin-name {
      font-size: 1.3rem;
      font-weight: 900;
      margin: 6px 0;
    }
    .admin-position {
      font-size: 1rem;
      color: #64748b;
      margin-bottom: 12px;
    }
    .info-list {
      display: flex;
      flex-direction: column;
      gap: 8px;
      margin-bottom: 14px;
    }
    .info-item {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 6px 12px;
      border-radius: 12px;
      background: #f8fafc;
      font-size: 0.95rem;
    }
    .card-actions {
      display: flex;
      justify-content: center;
      gap: 10px;
      flex-wrap: wrap;
    }
    .action-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 14px;
      border-radius: 14px;
      font-weight: 700;
      text-decoration: none;
      transition: all 0.25s ease;
    }
    .action-btn.primary {
      background: linear-gradient(135deg,#1565c0,#0d47a1);
      color: #fff;
    }
    .action-btn.secondary {
      background: linear-gradient(135deg,#fff3c4,#ffe082);
      color: #7a5200;
      border: 1px solid #ffd54f;
    } 
    .help-section {
      max-width: 1100px;
      margin: 0 auto;
    }
    .help-title {
      font-size: 1.5rem;
      font-weight: 900;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 8px;
      color: #16345c;
    }
    .help-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit,minmax(220px,1fr));
      gap: 20px;
    }
    .help-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      background: #1565c0;
      color: #fff;
      padding: 16px;
      border-radius: 20px;
      transition: all 0.25s ease;
      text-align: center;
    }
    .help-card:hover {
      transform: translateY(-5px);
      background: #0d47a1;
    }
    .help-icon {
      font-size: 2rem;
      margin-bottom: 8px;
      width: 40px;
      height: 40px;
    } 
    @media(max-width:768px){
      .contact-cards { grid-template-columns: 1fr; }
      .help-grid { grid-template-columns: 1fr; }
    }
  </style>