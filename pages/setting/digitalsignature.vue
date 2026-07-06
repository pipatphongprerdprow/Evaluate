<template>
    <div class="digital-signature-page">
        <!-- Header -->
        <div class="page-title">
            <div class="title-icon">
                <span style="font-size:20px;">👤</span>
                <span style="font-size:20px;">✏️</span>
            </div> 
            <div>
                <h2>ตั้งค่าลายเซ็นดิจิทัล</h2>
                <p>ลายเซ็นรูปภาพจะถูกนำไปแสดงในเอกสาร และใบรับรองดิจิทัล (PKI) ใช้ยืนยันตัวตนของผู้ลงนาม</p>
            </div>
        </div>

        <div class="grid">
            <!-- Left Profile Card -->
            <div class="col-12 lg:col-4 xl:col-4">
                <div class="card profile-card">
                    <h3 class="card-title">ข้อมูลบุคลากร</h3>

                    <div class="profile-body">
                        <div class="avatar-box">
                            <img
                                v-if="profilePhoto && !profilePhotoError"
                                :src="profilePhoto"
                                @error="profilePhotoError = true"
                                alt="profile"
                            />
                            <div v-else class="avatar-initial">
                                {{ initials }}
                            </div>
                        </div>

                        <h4>{{ fullName || '-' }}</h4>
                        <p>{{ positionName || '-' }}</p>
                        <p>{{ departmentName || '-' }}</p>
                        <p>{{ email || '-' }}</p>
                        <span>รหัสบุคลากร: {{ staffId || '-' }}</span>

                        <div class="status-stack">
                            <div class="status-pill" :class="{ active: hasSignature }">
                                <i class="pi pi-check-circle"></i>
                                {{ hasSignature ? 'มีลายเซ็นรูปภาพ' : 'ยังไม่มีลายเซ็นรูปภาพ' }}
                            </div>

                            <div class="status-pill" :class="{ active: certificate.usable }">
                                <i class="pi pi-shield"></i>
                                {{ certificate.usable ? 'ใบรับรองดิจิทัลใช้งานได้' : 'ยังไม่มีใบรับรองดิจิทัล' }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Management Card -->
            <div class="col-12 lg:col-8 xl:col-8">
                <div class="card manage-card">
                    <h3 class="card-title">จัดการลายเซ็น</h3>

                    <TabView :activeIndex="activeIndex" @tabChange="activeIndex = $event.index">
                        <!-- Tab 1: Signature Image -->
                        <TabPanel>
                            <template #header>
                                <i class="pi pi-image mr-2"></i>
                                <span>ลายเซ็นรูปภาพ</span>
                            </template>

                            <div class="info-box blue">
                                <i class="pi pi-info-circle"></i>
                                <div>
                                    <b>วิธีกำหนดลายเซ็นรูปภาพ</b>
                                    <p>
                                        อัปโหลดรูปลายเซ็น PNG/JPG พื้นหลังขาว ไม่เกิน 2MB
                                        หรือวาดด้วยเมาส์/นิ้วมือ แนะนำพื้นหลังโปร่งใส (PNG)
                                        เพื่อให้แสดงในเอกสารอย่างสวยงาม
                                    </p>
                                </div>
                            </div>

                            <div class="action-row">
                                <input
                                    ref="signatureInput"
                                    type="file"
                                    accept="image/png,image/jpeg,image/jpg"
                                    hidden
                                    @change="handleSignatureFile"
                                />

                                <Button
                                    label="อัปโหลดรูป"
                                    icon="pi pi-upload"
                                    severity="info"
                                    outlined
                                    @click="$refs.signatureInput.click()"
                                />
                            </div>

                            <div class="draw-panel">
                                <div class="draw-title">
                                    <i class="pi pi-pencil"></i>
                                    <span>หรือวาดลายเซ็นด้วยตนเอง</span>
                                </div>

                                <canvas
                                    ref="signatureCanvas"
                                    class="signature-canvas"
                                    @mousedown="startDraw"
                                    @mousemove="draw"
                                    @mouseup="endDraw"
                                    @mouseleave="endDraw"
                                    @touchstart="startDraw"
                                    @touchmove="draw"
                                    @touchend="endDraw"
                                ></canvas>

                                <div class="draw-actions">
                                    <Button
                                        label="ล้าง"
                                        icon="pi pi-refresh"
                                        severity="secondary"
                                        outlined
                                        :disabled="!hasDrawing"
                                        @click="clearCanvas"
                                    />

                                    <Button
                                        label="ใช้ลายเซ็นที่วาด"
                                        icon="pi pi-check-circle"
                                        severity="info"
                                        :disabled="!hasDrawing"
                                        @click="useDrawnSignature"
                                    />
                                </div>
                            </div>

                            <div class="current-section">
                                <label>ลายเซ็นปัจจุบัน</label>

                                <div class="current-signature">
                                    <img
                                        v-if="signaturePreview"
                                        :src="signaturePreview"
                                        alt="signature"
                                    />
                                    <div v-else class="empty-signature">
                                        ยังไม่มีลายเซ็น
                                    </div>
                                </div>

                                <p v-if="signatureUpdatedAt" class="updated-text">
                                    อัปเดตล่าสุด: {{ signatureUpdatedAt }}
                                </p>

                                <div class="bottom-actions">
                                    <Button
                                        label="ลบลายเซ็น"
                                        icon="pi pi-trash"
                                        severity="danger"
                                        outlined
                                        :disabled="!hasSignature"
                                        @click="deleteSignature"
                                    />

                                    <Button
                                        label="บันทึกลายเซ็น"
                                        icon="pi pi-save"
                                        severity="info"
                                        :loading="savingSignature"
                                        :disabled="!signaturePreview"
                                        @click="saveSignature"
                                    />
                                </div>
                            </div>
                        </TabPanel>

                        <!-- Tab 2: PKI Certificate -->
                        <TabPanel>
                            <template #header>
                                <i class="pi pi-shield mr-2"></i>
                                <span>ใบรับรองดิจิทัล (PKI)</span>
                            </template>

                            <div class="info-box blue">
                                <i class="pi pi-info-circle"></i>
                                <div>
                                    <b>ใบรับรองดิจิทัล (X.509 / PKI)</b>
                                    <p>
                                        อัปโหลดไฟล์ใบรับรอง .cer/.crt/.pem
                                        เพื่อยืนยันตัวตนผู้ลงนาม ระบบจะอ่านข้อมูล Subject
                                        และวันหมดอายุให้อัตโนมัติ
                                    </p>
                                </div>
                            </div>

                            <div class="action-row">
                                <input
                                    ref="certificateInput"
                                    type="file"
                                    accept=".cer,.crt,.pem"
                                    hidden
                                    @change="handleCertificateFile"
                                />

                                <Button
                                    label="อัปโหลดใบรับรอง"
                                    icon="pi pi-upload"
                                    severity="info"
                                    outlined
                                    @click="$refs.certificateInput.click()"
                                />

                                <Button
                                    label="สร้างใบรับรองของระบบเอง"
                                    icon="pi pi-shield"
                                    severity="info"
                                    @click="createSystemCertificate"
                                />
                            </div>

                            <div v-if="certificate.usable" class="certificate-card">
                                <div class="certificate-header">
                                    <div>
                                        <i class="pi pi-check-circle"></i>
                                        <b>ใบรับรองใช้งานได้</b>
                                    </div>
                                    <span>{{ certificate.fileName }}</span>
                                </div>

                                <div class="certificate-row">
                                    <span>ผู้ถือใบรับรอง (CN)</span>
                                    <b>{{ certificate.cn }}</b>
                                </div>
                                <div class="certificate-row">
                                    <span>ออกโดย (Issuer)</span>
                                    <b>{{ certificate.issuer }}</b>
                                </div>
                                <div class="certificate-row">
                                    <span>มีผลตั้งแต่</span>
                                    <b>{{ certificate.validFrom }}</b>
                                </div>
                                <div class="certificate-row">
                                    <span>หมดอายุ</span>
                                    <b>{{ certificate.validTo }}</b>
                                </div>
                                <div class="certificate-row">
                                    <span>Serial Number</span>
                                    <b>{{ certificate.serial }}</b>
                                </div>
                                <div class="certificate-row">
                                    <span>ลายนิ้วมือ (SHA-256)</span>
                                    <b class="fingerprint">{{ certificate.fingerprint }}</b>
                                </div>

                                <div class="certificate-actions">
                                    <Button
                                        label="ลบใบรับรอง"
                                        icon="pi pi-trash"
                                        severity="danger"
                                        outlined
                                        @click="deleteCertificate"
                                    />
                                </div>
                            </div>

                            <div v-else class="certificate-empty">
                                <i class="pi pi-shield"></i>
                                <p>ยังไม่มีใบรับรองดิจิทัล</p>
                            </div>

                            <div class="info-box yellow">
                                <i class="pi pi-exclamation-triangle"></i>
                                <div>
                                    ระบบจัดเก็บเฉพาะใบรับรองส่วนสาธารณะ (public certificate)
                                    เพื่อยืนยันตัวตนและแสดงในเอกสารเท่านั้น
                                    การลงนามแบบเข้ารหัส (PAdES) ที่ใช้กุญแจส่วนตัว
                                    เป็นขั้นตอนแยกที่ต้องตั้งค่าระบบจัดเก็บกุญแจแบบปลอดภัยเพิ่มเติม
                                </div>
                            </div>
                        </TabPanel>
                    </TabView>
                </div>
            </div>

            <!-- Document Preview -->
            <div class="col-12">
                <div class="card preview-card">
                    <h3 class="card-title">ตัวอย่างการแสดงลายเซ็นในเอกสาร</h3>

                    <div class="document-preview">
                        <div class="document-paper">
                            <h4>รายงานการเดินทางไปราชการ (แบบ 8708)</h4>
                            <hr />

                            <p>ผู้รายงาน: {{ fullName || '-' }}</p>
                            <p>ตำแหน่ง: {{ positionName || '-' }}</p>

                            <div class="signature-on-doc">
                                <img
                                    v-if="signaturePreview"
                                    :src="signaturePreview"
                                    alt="signature preview"
                                />
                                <div v-else class="doc-empty-signature">
                                    พื้นที่แสดงลายเซ็น
                                </div>

                                <p>( {{ fullName || '........................................' }} )</p>
                                <p>{{ positionName || 'ตำแหน่ง ........................................' }}</p>
                                <p class="green-text" v-if="certificate.usable">
                                    ลงนามดิจิทัลโดย {{ fullName }}
                                </p>
                                <p class="muted-text" v-else>
                                    ยังไม่ได้เชื่อมใบรับรองดิจิทัล
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <Button
            icon="pi pi-arrow-up"
            class="scroll-top"
            rounded
            severity="info"
            @click="scrollTop"
        />
    </div>
</template>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';

const API_BASE = 'http://127.0.0.1:8000/api';

export default {
    data() {
        return {
            userSession: null,
            activeIndex: 0,

            profilePhotoError: false,

            signaturePreview: null,
            signatureFile: null,
            signatureUpdatedAt: null,
            savingSignature: false,

            isDrawing: false,
            hasDrawing: false,
            lastPoint: null,

            certificate: {
                usable: false,
                fileName: '',
                cn: '-',
                issuer: '-',
                validFrom: '-',
                validTo: '-',
                serial: '-',
                fingerprint: '-'
            }
        };
    },

    computed: {
        profile() {
            return this.userSession?.user?.name || {};
        },

        fullName() {
            return `${this.profile.PREFIXFULLNAME || ''}${this.profile.STAFFNAME || ''} ${this.profile.STAFFSURNAME || ''}`.trim();
        },

        positionName() {
            return this.profile.POSITIONNAME || '';
        },

        departmentName() {
            return this.profile.SCOPES?.staffdepartmentname || '';
        },

        email() {
            return this.profile.EMAIL || this.profile.email || '';
        },

        staffId() {
            return this.profile.STAFFID || '';
        },

        profilePhoto() {
            return this.profile.picture || this.profile.photo || this.profile.avatar || '';
        },

        initials() {
            if (!this.fullName) return 'MSU';
            return this.fullName.replace(/\s+/g, '').slice(0, 2);
        },

        hasSignature() {
            return !!this.signaturePreview;
        }
    },

    async mounted() {
        const { getSession } = await useAuth();
        this.userSession = await getSession();

        this.$nextTick(() => {
            this.prepareCanvas();
        });

        window.addEventListener('resize', this.prepareCanvas);
        await this.loadDigitalSignatureData();
    },

    beforeUnmount() {
        window.removeEventListener('resize', this.prepareCanvas);
    },

    methods: {
        async loadDigitalSignatureData() {
            try {
                const res = await axios.post(`${API_BASE}/digital-signature/profile`, {
                    staff_id: this.staffId
                });

                const data = res.data || {};

                this.signaturePreview = data.signature_url || null;
                this.signatureUpdatedAt = data.signature_updated_at || null;

                if (data.certificate) {
                    this.certificate = {
                        usable: !!data.certificate.usable,
                        fileName: data.certificate.file_name || '',
                        cn: data.certificate.cn || '-',
                        issuer: data.certificate.issuer || '-',
                        validFrom: data.certificate.valid_from || '-',
                        validTo: data.certificate.valid_to || '-',
                        serial: data.certificate.serial || '-',
                        fingerprint: data.certificate.fingerprint || '-'
                    };
                }
            } catch (error) {
                console.warn('ยังไม่พบ API สำหรับโหลดข้อมูลลายเซ็น หรือโหลดข้อมูลไม่สำเร็จ');
            }
        },

        handleSignatureFile(event) {
            const file = event.target.files?.[0];
            if (!file) return;

            const allowed = ['image/png', 'image/jpeg', 'image/jpg'];
            const maxSize = 2 * 1024 * 1024;

            if (!allowed.includes(file.type)) {
                Swal.fire('แจ้งเตือน', 'รองรับเฉพาะไฟล์ PNG หรือ JPG เท่านั้น', 'warning');
                event.target.value = '';
                return;
            }

            if (file.size > maxSize) {
                Swal.fire('แจ้งเตือน', 'ขนาดไฟล์ต้องไม่เกิน 2MB', 'warning');
                event.target.value = '';
                return;
            }

            this.signatureFile = file;
            this.signaturePreview = URL.createObjectURL(file);
            this.signatureUpdatedAt = 'รอบันทึกข้อมูล';
        },

        prepareCanvas() {
            const canvas = this.$refs.signatureCanvas;
            if (!canvas) return;

            const ratio = window.devicePixelRatio || 1;
            const width = canvas.clientWidth || 700;
            const height = 220;

            canvas.width = width * ratio;
            canvas.height = height * ratio;
            canvas.style.height = `${height}px`;

            const ctx = canvas.getContext('2d');
            ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
            ctx.clearRect(0, 0, width, height);
            ctx.lineWidth = 1.8;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            ctx.strokeStyle = '#4f5fc7';
        },

        getCanvasPoint(event) {
            const canvas = this.$refs.signatureCanvas;
            const rect = canvas.getBoundingClientRect();
            const pointer = event.touches?.[0] || event.changedTouches?.[0] || event;

            return {
                x: pointer.clientX - rect.left,
                y: pointer.clientY - rect.top
            };
        },

        startDraw(event) {
            event.preventDefault();
            this.isDrawing = true;
            this.hasDrawing = true;
            this.lastPoint = this.getCanvasPoint(event);
        },

        draw(event) {
            if (!this.isDrawing) return;

            event.preventDefault();

            const canvas = this.$refs.signatureCanvas;
            const ctx = canvas.getContext('2d');
            const point = this.getCanvasPoint(event);

            ctx.beginPath();
            ctx.moveTo(this.lastPoint.x, this.lastPoint.y);
            ctx.lineTo(point.x, point.y);
            ctx.stroke();

            this.lastPoint = point;
        },

        endDraw() {
            this.isDrawing = false;
        },

        clearCanvas() {
            this.prepareCanvas();
            this.hasDrawing = false;
            this.lastPoint = null;
        },

        useDrawnSignature() {
            const canvas = this.$refs.signatureCanvas;
            if (!canvas || !this.hasDrawing) return;

            this.signatureFile = null;
            this.signaturePreview = canvas.toDataURL('image/png');
            this.signatureUpdatedAt = 'รอบันทึกข้อมูล';
        },

        async saveSignature() {
            if (!this.signaturePreview) {
                Swal.fire('แจ้งเตือน', 'กรุณาอัปโหลดหรือวาดลายเซ็นก่อนบันทึก', 'warning');
                return;
            }

            this.savingSignature = true;

            try {
                const formData = new FormData();
                formData.append('staff_id', this.staffId);

                if (this.signatureFile) {
                    formData.append('signature_file', this.signatureFile);
                } else {
                    formData.append('signature_base64', this.signaturePreview);
                }

                const res = await axios.post(`${API_BASE}/digital-signature/save`, formData);

                this.signaturePreview = res.data?.signature_url || this.signaturePreview;
                this.signatureUpdatedAt = res.data?.updated_at || new Date().toLocaleString('th-TH');

                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกลายเซ็นสำเร็จ',
                    showConfirmButton: false,
                    timer: 1500
                });
            } catch (error) {
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถบันทึกลายเซ็นได้ กรุณาตรวจสอบ API', 'error');
            } finally {
                this.savingSignature = false;
            }
        },

        async deleteSignature() {
            const confirm = await Swal.fire({
                title: 'ยืนยันการลบลายเซ็น?',
                text: 'เมื่อลบแล้วลายเซ็นจะไม่แสดงในเอกสาร',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'ลบลายเซ็น',
                cancelButtonText: 'ยกเลิก'
            });

            if (!confirm.isConfirmed) return;

            try {
                await axios.post(`${API_BASE}/digital-signature/delete`, {
                    staff_id: this.staffId
                });

                this.signaturePreview = null;
                this.signatureFile = null;
                this.signatureUpdatedAt = null;
                this.clearCanvas();

                Swal.fire({
                    icon: 'success',
                    title: 'ลบลายเซ็นสำเร็จ',
                    showConfirmButton: false,
                    timer: 1200
                });
            } catch (error) {
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถลบลายเซ็นได้', 'error');
            }
        },

        async handleCertificateFile(event) {
            const file = event.target.files?.[0];
            if (!file) return;

            const formData = new FormData();
            formData.append('staff_id', this.staffId);
            formData.append('certificate_file', file);

            try {
                const res = await axios.post(`${API_BASE}/digital-certificate/upload`, formData);
                this.setCertificateData(res.data?.certificate || res.data);

                Swal.fire({
                    icon: 'success',
                    title: 'อัปโหลดใบรับรองสำเร็จ',
                    showConfirmButton: false,
                    timer: 1500
                });
            } catch (error) {
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถอัปโหลดใบรับรองได้', 'error');
            }
        },

        async createSystemCertificate() {
            const confirm = await Swal.fire({
                title: 'สร้างใบรับรองของระบบเอง?',
                text: 'ระบบจะสร้างใบรับรองสำหรับใช้แสดงตัวตนในเอกสาร',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'สร้างใบรับรอง',
                cancelButtonText: 'ยกเลิก'
            });

            if (!confirm.isConfirmed) return;

            try {
                const res = await axios.post(`${API_BASE}/digital-certificate/create`, {
                    staff_id: this.staffId,
                    common_name: this.fullName,
                    email: this.email
                });

                this.setCertificateData(res.data?.certificate || res.data);

                Swal.fire({
                    icon: 'success',
                    title: 'สร้างใบรับรองสำเร็จ',
                    showConfirmButton: false,
                    timer: 1500
                });
            } catch (error) {
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถสร้างใบรับรองได้ กรุณาตรวจสอบ API', 'error');
            }
        },

        setCertificateData(data = {}) {
            this.certificate = {
                usable: true,
                fileName: data.file_name || data.fileName || `${this.fullName}.cer`,
                cn: data.cn || this.fullName || '-',
                issuer: data.issuer || 'MSU Digital Certificate Authority',
                validFrom: data.valid_from || data.validFrom || '-',
                validTo: data.valid_to || data.validTo || '-',
                serial: data.serial || '-',
                fingerprint: data.fingerprint || '-'
            };
        },

        async deleteCertificate() {
            const confirm = await Swal.fire({
                title: 'ยืนยันการลบใบรับรอง?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'ลบใบรับรอง',
                cancelButtonText: 'ยกเลิก'
            });

            if (!confirm.isConfirmed) return;

            try {
                await axios.post(`${API_BASE}/digital-certificate/delete`, {
                    staff_id: this.staffId
                });

                this.certificate = {
                    usable: false,
                    fileName: '',
                    cn: '-',
                    issuer: '-',
                    validFrom: '-',
                    validTo: '-',
                    serial: '-',
                    fingerprint: '-'
                };

                Swal.fire({
                    icon: 'success',
                    title: 'ลบใบรับรองสำเร็จ',
                    showConfirmButton: false,
                    timer: 1200
                });
            } catch (error) {
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถลบใบรับรองได้', 'error');
            }
        },

        scrollTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }
    }
};
</script>

<style scoped>
.digital-signature-page {
    min-height: 100vh;
    padding: 18px 10px 40px;
    background: #f6f7fc;
    color: #3f3a4d;
}

.page-title {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 18px;
}

.title-icon {
    width: 36px;
    height: 36px;
    border-radius: 12px;
    background: #e7f3ff;
    color: #1e88e5;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
}

.page-title h2 {
    margin: 0 0 4px;
    font-size: 24px;
    font-weight: 800;
}

.page-title p {
    margin: 0;
    color: #706b7d;
    font-size: 14px;
}

.card {
    border: 0;
    border-radius: 8px;
    background: #ffffff;
    box-shadow: 0 5px 16px rgba(32, 39, 55, 0.12);
}

.card-title {
    margin: -8px -8px 18px;
    padding: 18px 20px;
    border-bottom: 1px solid #e8e8ef;
    font-size: 17px;
    text-align: left;
}

.profile-card {
    min-height: 375px;
}

.profile-body {
    text-align: center;
    padding: 2px 12px 14px;
}

.avatar-box {
    width: 96px;
    height: 96px;
    margin: 0 auto 16px;
    border-radius: 50%;
    overflow: hidden;
    background: linear-gradient(135deg, #1e88e5, #60b8ff);
    display: flex;
    align-items: center;
    justify-content: center;
}

.avatar-box img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.avatar-initial {
    color: #ffffff;
    font-size: 26px;
    font-weight: 800;
}

.profile-body h4 {
    margin: 0 0 6px;
    font-size: 16px;
    font-weight: 800;
}

.profile-body p {
    margin: 4px 0;
    color: #6f6a78;
}

.profile-body span {
    display: inline-block;
    margin-top: 4px;
    color: #9a96a3;
}

.status-stack {
    margin-top: 16px;
}

.status-pill {
    width: 100%;
    margin-top: 8px;
    padding: 9px 12px;
    border-radius: 999px;
    background: #e5e7eb;
    color: #6b7280;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
}

.status-pill.active {
    background: #49d100;
    color: #ffffff;
}

.manage-card {
    min-height: 470px;
}

.info-box {
    display: flex;
    gap: 14px;
    border-radius: 7px;
    padding: 16px;
    margin: 14px 0 12px;
    line-height: 1.65;
}

.info-box i {
    width: 30px;
    height: 30px;
    min-width: 30px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ffffff;
}

.info-box p {
    margin: 2px 0 0;
}

.info-box.blue {
    background: #d9f0ff;
    color: #5e6876;
}

.info-box.blue i {
    background: #2aa8f5;
}

.info-box.yellow {
    background: #fff0cc;
    color: #8a6a18;
}

.info-box.yellow i {
    background: #f9ae18;
}

.action-row {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin: 10px 0;
}

.draw-panel {
    border: 1px solid #dfdfe6;
    border-radius: 7px;
    padding: 10px;
    margin-top: 8px;
}

.draw-title {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #6f6a78;
    font-weight: 700;
    margin-bottom: 8px;
}

.signature-canvas {
    width: 100%;
    border: 1px solid #e0e1e8;
    border-radius: 10px;
    background: #ffffff;
    cursor: crosshair;
    touch-action: none;
}

.draw-actions {
    display: flex;
    gap: 8px;
    margin-top: 8px;
}

.current-section {
    margin-top: 18px;
}

.current-section label {
    display: block;
    margin-bottom: 8px;
    font-weight: 800;
    color: #6f6a78;
}

.current-signature {
    height: 145px;
    border: 1px solid #e0e1e8;
    border-radius: 7px;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
}

.current-signature img {
    max-width: 260px;
    max-height: 90px;
    object-fit: contain;
}

.empty-signature {
    color: #b3b0bb;
}

.updated-text {
    margin: 8px 0;
    color: #7c7885;
}

.bottom-actions {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    margin-top: 10px;
}

.certificate-card {
    border: 1px solid #e0e1e8;
    border-radius: 7px;
    margin-top: 12px;
    overflow: hidden;
}

.certificate-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 12px 14px;
    border-bottom: 1px solid #e0e1e8;
}

.certificate-header div {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #38b000;
    font-size: 17px;
}

.certificate-header span {
    border: 1px solid #e0e1e8;
    border-radius: 999px;
    padding: 4px 12px;
    color: #706b7d;
    background: #ffffff;
}

.certificate-row {
    display: grid;
    grid-template-columns: 220px 1fr;
    gap: 12px;
    padding: 8px 14px;
    border-bottom: 1px dashed #e2e2ea;
}

.certificate-row span {
    color: #7b7684;
}

.certificate-row b {
    color: #8b8794;
    text-align: right;
}

.fingerprint {
    word-break: break-all;
}

.certificate-actions {
    padding: 10px 14px;
    text-align: right;
}

.certificate-empty {
    height: 160px;
    border: 1px dashed #d5d7df;
    border-radius: 8px;
    margin-top: 12px;
    color: #a6a2ad;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.certificate-empty i {
    font-size: 34px;
    margin-bottom: 8px;
}

.preview-card {
    margin-top: 10px;
}

.document-preview {
    display: flex;
    justify-content: center;
    padding: 20px 0 10px;
}

.document-paper {
    width: min(600px, 100%);
    min-height: 275px;
    border: 1px solid #e0e1e8;
    border-radius: 8px;
    background: #ffffff;
    padding: 20px;
}

.document-paper h4 {
    text-align: center;
    margin: 0 0 12px;
}

.document-paper p {
    color: #706b7d;
}

.signature-on-doc {
    margin-top: 42px;
    text-align: center;
}

.signature-on-doc img {
    max-width: 150px;
    max-height: 55px;
    object-fit: contain;
}

.doc-empty-signature {
    color: #b7b3bf;
    margin-bottom: 10px;
}

.green-text {
    color: #38b000 !important;
    font-weight: 700;
}

.muted-text {
    color: #9a96a3 !important;
}

.scroll-top {
    position: fixed;
    right: 28px;
    bottom: 24px;
}

@media (max-width: 768px) {
    .certificate-row {
        grid-template-columns: 1fr;
    }

    .certificate-row b {
        text-align: left;
    }

    .bottom-actions {
        flex-direction: column;
    }
}
</style>