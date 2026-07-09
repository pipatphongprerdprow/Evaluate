<template>
    <div class="digital-signature-page">
        <!-- Header -->
        <div class="page-title">
            <div class="title-icon">
                <span style="font-size:32px;">👤</span>
                <span style="font-size:32px;">✏️</span>
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
                        <div class="profile-avatar">
                            <img
                                v-if="profileImageSrc && !profileImageLoadError"
                                :src="profileImageSrc"
                                :alt="profileFullName"
                                @error="profileImageLoadError = true"
                            />
                            <span v-else>{{ profileInitial }}</span>
                        </div>

                        <h4>{{ profileFullName || '-' }}</h4>
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
                                    :disabled="isSignatureLocked"
                                    @click="openSignatureFilePicker"
                                />
                            </div>

                            <div class="draw-panel" :class="{ locked: isSignatureLocked }">
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
                                        :disabled="isSignatureLocked || !hasDrawing"
                                        @click="clearCanvas"
                                    />

                                    <Button
                                        label="ใช้ลายเซ็นที่วาด"
                                        icon="pi pi-check-circle"
                                        severity="info"
                                        :disabled="isSignatureLocked || !hasDrawing"
                                        @click="useDrawnSignature"
                                    />
                                </div>
                                <div v-if="isSignatureLocked" class="signature-locked-message">
                                    มีลายเซ็นปัจจุบันแล้ว หากต้องการเปลี่ยน กรุณากดปุ่ม “เปลี่ยนลายเซ็น”
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
                                    อัปเดตล่าสุด: {{ formatThaiDateTimeBE(signatureUpdatedAt) }}
                                </p>

                                <div class="bottom-actions">
                                    <Button
                                        label="ลบลายเซ็น"
                                        icon="pi pi-trash"
                                        severity="danger"
                                        outlined
                                        :disabled="!hasSavedSignature || savingSignature"
                                        @click="deleteSignature"
                                    />

                                    <Button
                                        v-if="hasSavedSignature && !signatureEditMode"
                                        label="เปลี่ยนลายเซ็น"
                                        icon="pi pi-pencil"
                                        severity="warning"
                                        @click="startChangeSignature"
                                    />

                                    <template v-else>
                                        <Button
                                            v-if="hasSavedSignature"
                                            label="ยกเลิก"
                                            icon="pi pi-times"
                                            severity="secondary"
                                            outlined
                                            :disabled="savingSignature"
                                            @click="cancelChangeSignature"
                                        />

                                        <Button
                                            :label="hasSavedSignature ? 'บันทึกการเปลี่ยนลายเซ็น' : 'บันทึกลายเซ็น'"
                                            icon="pi pi-save"
                                            severity="info"
                                            :loading="savingSignature"
                                            :disabled="!canSaveSignature"
                                            @click="saveSignature"
                                        />
                                    </template>
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
                                    :label="hasSavedCertificate ? 'เปลี่ยนใบรับรอง' : 'อัปโหลดใบรับรอง'"
                                    icon="pi pi-upload"
                                    severity="info"
                                    outlined
                                    @click="$refs.certificateInput.click()"
                                />

                                <Button
                                    :label="hasSavedCertificate ? 'สร้างใบรับรองใหม่' : 'สร้างใบรับรองของระบบเอง'"
                                    icon="pi pi-shield"
                                    severity="info"
                                    @click="openCertificateDialog"
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
                            <h4>รายงานแบบประเมิน ป.04</h4>
                            <hr />

                            <p>ผู้รายงาน: {{ profileFullName || '-' }}</p>
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

                                <p>( {{ profileFullName || '........................................' }} )</p>
                                <p>{{ positionName || 'ตำแหน่ง ........................................' }}</p>
                                <p class="green-text" v-if="certificate.usable">
                                    ลงนามดิจิทัลโดย {{ profileFullName }}
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

        <!-- Create Certificate Dialog -->
        <Dialog
            v-model:visible="createCertDialog"
            modal
            class="cert-create-dialog"
            header="สร้างใบรับรองดิจิทัลของระบบ (Self-signed X.509)"
            :style="{ width: '600px' }"
            :breakpoints="{ '960px': '90vw', '640px': '96vw' }"
        >
            <div class="cert-dialog-body">
                <div class="cert-info-box">
                    <i class="pi pi-info-circle"></i>
                    <div>
                        ระบบจะสร้างคู่กุญแจ RSA 2048 บิต และใบรับรอง self-signed อายุ 1 ปี —
                        เก็บใบรับรองส่วนสาธารณะไว้ในระบบ และดาวน์โหลดกุญแจส่วนตัว
                        (private key) ที่ท่านเก็บเอง ระบบไม่จัดเก็บกุญแจส่วนตัว
                    </div>
                </div>

                <div class="p-fluid formgrid grid cert-form">
                    <div class="field col-12">
                        <label>ชื่อผู้ถือใบรับรอง (CN) <span>*</span></label>
                        <InputText v-model="certForm.cn" />
                    </div>

                    <div class="field col-12 md:col-6">
                        <label>อีเมล (emailAddress)</label>
                        <InputText v-model="certForm.email" />
                    </div>

                    <div class="field col-12 md:col-6">
                        <label>หน่วยงาน (OU)</label>
                        <InputText v-model="certForm.ou" />
                    </div>

                    <div class="field col-12">
                        <label>องค์กร (O)</label>
                        <InputText v-model="certForm.o" />
                    </div>

                    <div class="field col-12 md:col-4">
                        <label>ประเทศ (C)</label>
                        <InputText v-model="certForm.c" maxlength="2" />
                    </div>

                    <div class="field col-12 md:col-4">
                        <label>จังหวัด (ST)</label>
                        <InputText v-model="certForm.st" />
                    </div>

                    <div class="field col-12 md:col-4">
                        <label>อำเภอ (L)</label>
                        <InputText v-model="certForm.l" />
                    </div>
                </div>
            </div>

            <template #footer>
                <Button
                    label="ยกเลิก"
                    severity="secondary"
                    text
                    @click="createCertDialog = false"
                />

                <Button
                    label="สร้างและบันทึกใบรับรอง"
                    icon="pi pi-shield"
                    severity="info"
                    :loading="creatingCertificate"
                    @click="createSystemCertificate"
                />
            </template>
        </Dialog>

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
import Button from 'primevue/button';
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel';
import Dialog from 'primevue/dialog';
import InputText from 'primevue/inputtext';

const API_BASE = 'http://127.0.0.1:8000/api';
const PROFILE_IMAGE_URL = 'https://pd.msu.ac.th/staff/picture/'; 

// const PROFILE_IMAGE_URL = 'http://127.0.0.1:8000/storage/profile/';


export default {
    components: {
        Button,
        TabView,
        TabPanel,
        Dialog,
        InputText
    },

    data() {
        return {
            userSession: null,
            currentUserProfile: {},
            personalRow: null,
            staffid_Main: '',

            activeIndex: 0,

            profileImageLoadError: false,

            signaturePreview: null,
            signatureFile: null,
            signatureUpdatedAt: null,
            savingSignature: false,
            hasSavedSignature: false,
            signatureChanged: false,
            createCertDialog: false,
            creatingCertificate: false,
            hasSavedCertificate: false,

            signatureEditMode: false,
            oldSignaturePreview: null,
            oldSignatureUpdatedAt: null,
 
            isDrawing: false,
            hasDrawing: false,
            lastPoint: null,

            createCertDialog: false,
            creatingCertificate: false,

            certForm: {
                cn: '',
                email: '',
                ou: '',
                o: 'มหาวิทยาลัยมหาสารคาม',
                c: 'TH',
                st: 'มหาสารคาม',
                l: 'กันทรวิชัย'
            },

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
        staffId() {
            return this.normalizeStaffId(this.staffid_Main || this.currentUserProfile.STAFFID);
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

        profileImageSrc() {
            const staffid = this.normalizeStaffId(this.staffid_Main || this.currentUserProfile.STAFFID);
            return staffid ? `${PROFILE_IMAGE_URL}${staffid}.jpg` : '';
        },

        positionName() {
            return (
                this.personalRow?.posnameth ||
                this.currentUserProfile.POSITIONNAME ||
                this.currentUserProfile.POSTYPENAME ||
                ''
            );
        },

        departmentName() {
            return (
                this.personalRow?.departmentname ||
                this.personalRow?.staffdepartmentname ||
                this.currentUserProfile.SCOPES?.staffdepartmentname ||
                ''
            );
        },

        email() {
            return (
                this.personalRow?.email ||
                this.currentUserProfile.EMAIL ||
                this.currentUserProfile.email ||
                ''
            );
        },

        hasSignature() {
            return !!this.signaturePreview;
        },
        isSignatureLocked() {
            return this.hasSavedSignature && !this.signatureEditMode;
        },

        canSaveSignature() {
            return !!this.signaturePreview && this.signatureChanged && !this.savingSignature;
        }

    },

     

    async mounted() {
        const { getSession } = await useAuth();
        this.userSession = await getSession();

        const sessionName = this.userSession?.user?.name || {};

        this.currentUserProfile = sessionName;
        this.staffid_Main = sessionName.STAFFID || '';
        this.profileImageLoadError = false;

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
        normalizeStaffId(value) {
            return String(value ?? '').replace(/\s+/g, '').trim();
        },

       async loadDigitalSignatureData() {
            try {
                const res = await axios.post(`${API_BASE}/digital-signature/profile`, {
                    staff_id: this.staffId
                });

                const data = res.data || {};
                const signatureUrl = data.signature_url || data.signatureUrl || null;
                const signatureRow = data.signature || data.digital_signature || null;

                this.personalRow = data.personal || data.personalRow || this.personalRow;

                this.signaturePreview = signatureUrl;
                this.signatureUpdatedAt = data.signature_updated_at || data.signatureUpdatedAt || signatureRow?.updated_at || null;
                this.hasSavedSignature = !!(signatureUrl || signatureRow?.signature_image);
                this.signatureChanged = false;
                this.signatureFile = null;
                this.signatureEditMode = !this.hasSavedSignature;
                this.oldSignaturePreview = this.signaturePreview;
                this.oldSignatureUpdatedAt = this.signatureUpdatedAt;

                if (data.certificate) {
                    this.setCertificateData(data.certificate);
                    this.hasSavedCertificate = !!data.certificate.usable;
                } else {
                    this.hasSavedCertificate = false;
                    this.certificate = this.getEmptyCertificate();
                }
            } catch (error) {
                console.warn('ยังไม่พบ API สำหรับโหลดข้อมูลลายเซ็น หรือโหลดข้อมูลไม่สำเร็จ', error);
                this.hasSavedSignature = false;
                this.hasSavedCertificate = false;
            }
        },

        handleSignatureFile(event) {
            if (this.isSignatureLocked) {
                event.target.value = '';

                Swal.fire({
                    icon: 'info',
                    title: 'ยังไม่สามารถแก้ไขได้',
                    text: 'กรุณากดปุ่ม “เปลี่ยนลายเซ็น” ก่อนอัปโหลดรูปใหม่',
                });

                return;
            }

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
            this.signatureChanged = true;
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
            if (this.isSignatureLocked) {
                return;
            }

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
            const canvas = this.$refs.signatureCanvas;
            if (!canvas) return;

            this.prepareCanvas();
            this.hasDrawing = false;
            this.lastPoint = null;
        },

        useDrawnSignature() {
            if (this.isSignatureLocked) {
                Swal.fire({
                    icon: 'info',
                    title: 'ยังไม่สามารถแก้ไขได้',
                    text: 'กรุณากดปุ่ม “เปลี่ยนลายเซ็น” ก่อนวาดลายเซ็นใหม่',
                });

                return;
            }

            const canvas = this.$refs.signatureCanvas;
            if (!canvas || !this.hasDrawing) return;

            this.signatureFile = null;
            this.signaturePreview = canvas.toDataURL('image/png');
            this.signatureUpdatedAt = 'รอบันทึกข้อมูล';
            this.signatureChanged = true;
        },

        async saveSignature() {
            if (this.isSignatureLocked) {
                Swal.fire({
                    icon: 'info',
                    title: 'ยังไม่สามารถบันทึกได้',
                    text: 'กรุณากดปุ่ม “เปลี่ยนลายเซ็น” ก่อนแก้ไขลายเซ็น',
                });

                return;
            }

            if (!this.signaturePreview) {
                Swal.fire('แจ้งเตือน', 'กรุณาอัปโหลดหรือวาดลายเซ็นก่อนบันทึก', 'warning');
                return;
            }

            if (!this.signatureChanged) {
                Swal.fire('แจ้งเตือน', 'ยังไม่มีการเปลี่ยนแปลงลายเซ็น', 'warning');
                return;
            }

            this.savingSignature = true;

            try {
                const formData = new FormData();

                formData.append('staff_id', this.staffId);
                formData.append('signer_name', this.profileFullName || '');
                formData.append('signer_position', this.positionName || '');
                formData.append('department_name', this.departmentName || '');
                formData.append('email', this.email || '');

                if (this.signatureFile) {
                    formData.append('signature_file', this.signatureFile);
                } else {
                    formData.append('signature_base64', this.signaturePreview);
                }

                const endpoint = this.hasSavedSignature
                    ? `${API_BASE}/digital-signature/update`
                    : `${API_BASE}/digital-signature/save`;

                const res = await axios.post(endpoint, formData);

                const data = res.data || {};

                this.signaturePreview = data.signature_url || data.signatureUrl || this.signaturePreview;
                this.signatureUpdatedAt = data.updated_at || data.updatedAt || new Date();

                this.hasSavedSignature = true;
                this.signatureChanged = false;
                this.signatureFile = null;

                this.signatureEditMode = false;
                this.oldSignaturePreview = this.signaturePreview;
                this.oldSignatureUpdatedAt = this.signatureUpdatedAt;

                this.clearCanvas();

                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกลายเซ็นสำเร็จ',
                    showConfirmButton: false,
                    timer: 1500,
                });

            } catch (error) {
                console.error('saveSignature error:', error);

                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text:
                        error.response?.data?.error ||
                        error.response?.data?.message ||
                        'ไม่สามารถบันทึกลายเซ็นได้ กรุณาตรวจสอบ API',
                });

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
                cancelButtonText: 'ยกเลิก',
            });

            if (!confirm.isConfirmed) return;

            try {
                await axios.post(`${API_BASE}/digital-signature/delete`, {
                    staff_id: this.staffId,
                });

                this.signaturePreview = null;
                this.signatureFile = null;
                this.signatureUpdatedAt = null;

                this.hasSavedSignature = false;
                this.signatureChanged = false;
                this.signatureEditMode = true;

                this.oldSignaturePreview = null;
                this.oldSignatureUpdatedAt = null;

                this.clearCanvas();

                Swal.fire({
                    icon: 'success',
                    title: 'ลบลายเซ็นสำเร็จ',
                    showConfirmButton: false,
                    timer: 1200,
                });

            } catch (error) {
                console.error('deleteSignature error:', error);

                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text:
                        error.response?.data?.error ||
                        error.response?.data?.message ||
                        'ไม่สามารถลบลายเซ็นได้',
                });
            }
        },

        async handleCertificateFile(event) {
            const file = event.target.files?.[0];
            if (!file) return;

            const fileName = file.name.toLowerCase();
            const validExt = fileName.endsWith('.cer') || fileName.endsWith('.crt') || fileName.endsWith('.pem');

            if (!validExt) {
                Swal.fire('แจ้งเตือน', 'รองรับเฉพาะไฟล์ .cer, .crt หรือ .pem เท่านั้น', 'warning');
                event.target.value = '';
                return;
            }

            const formData = new FormData();
            formData.append('staff_id', this.staffId);
            formData.append('certificate_file', file);

            try {
                // const res = await axios.post(`${API_BASE}/digital-certificate/upload`, formData);
                const endpoint = this.hasSavedCertificate
                    ? `${API_BASE}/digital-certificate/update`
                    : `${API_BASE}/digital-certificate/upload`;

                const res = await axios.post(endpoint, formData);
                this.setCertificateData(res.data?.certificate || res.data);
                this.hasSavedCertificate = true;


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

        openCertificateDialog() {
            this.certForm = {
                cn: this.profileFullName || '',
                email: this.email || '',
                ou: this.departmentName || '',
                o: 'มหาวิทยาลัยมหาสารคาม',
                c: 'TH',
                st: 'มหาสารคาม',
                l: 'กันทรวิชัย'
            };

            this.createCertDialog = true;
        },

        async createSystemCertificate() {
            if (!this.certForm.cn || !this.certForm.cn.trim()) {
                Swal.fire({
                    icon: 'warning',
                    title: 'กรุณากรอกข้อมูล',
                    text: 'กรุณากรอกชื่อผู้ถือใบรับรอง (CN)'
                });
                return;
            }

            this.creatingCertificate = true;

            try {
                const res = await axios.post(`${API_BASE}/digital-certificate/create`, {
                    staff_id: this.staffId,
                    common_name: this.certForm.cn,
                    email: this.certForm.email,
                    organizational_unit: this.certForm.ou,
                    organization: this.certForm.o,
                    country: this.certForm.c,
                    state: this.certForm.st,
                    locality: this.certForm.l
                });

                this.setCertificateData(res.data?.certificate || res.data);
                this.hasSavedCertificate = true;
                this.createCertDialog = false;

                Swal.fire({
                    icon: 'success',
                    title: 'สร้างใบรับรองสำเร็จ',
                    text: 'ระบบได้สร้างและบันทึกใบรับรองดิจิทัลเรียบร้อยแล้ว',
                    showConfirmButton: false,
                    timer: 1500
                });

                if (res.data?.private_key_download_url) {
                    window.open(res.data.private_key_download_url, '_blank');
                }

                if (res.data?.private_key_pem) {
                    this.downloadTextFile(
                        res.data.private_key_pem,
                        res.data.private_key_file_name || `private_key_${this.staffId}.pem`
                    );
                }
            } catch (error) {
                console.error('createSystemCertificate error:', error.response?.data || error);

                const message =
                    error.response?.data?.error ||
                    error.response?.data?.message ||
                    'ไม่สามารถสร้างใบรับรองได้ กรุณาตรวจสอบ API';

                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text: message
                });
            } finally {
                this.creatingCertificate = false;
            }
        },

        setCertificateData(data = {}) {
            const rawCn =
                data.cn ||
                data.common_name ||
                data.commonName ||
                this.profileFullName ||
                '-';

            const rawIssuer =
                data.issuer ||
                data.issuer_name ||
                rawCn ||
                '-';

            const rawFingerprint =
                data.fingerprint ||
                data.fingerprint_sha256 ||
                data.sha256 ||
                '-';

            this.certificate = {
                usable: data.usable !== undefined ? !!data.usable : true,

                fileName: rawCn && rawCn !== '-'
                    ? `${rawCn}.cer`
                    : (data.file_name || data.fileName || data.certificate_file?.split('/').pop() || ''),

                cn: this.extractCertificateCN(rawCn),

                issuer: this.extractCertificateCN(rawIssuer),

                validFrom: this.formatThaiDateTimeBE(data.valid_from || data.validFrom),

                validTo: this.formatThaiDateTimeBE(data.valid_to || data.validTo),

                serial: data.serial || data.serial_number || data.serialNumber || '-',

                fingerprint: this.formatFingerprint(rawFingerprint)
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
        },
        downloadTextFile(content, fileName) {
            const blob = new Blob([content], { type: 'text/plain;charset=utf-8' });
            const url = window.URL.createObjectURL(blob);
            const link = document.createElement('a');

            link.href = url;
            link.download = fileName;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            setTimeout(() => window.URL.revokeObjectURL(url), 1000);
        },
        getEmptyCertificate() {
            return {
                usable: false,
                fileName: '',
                cn: '-',
                issuer: '-',
                validFrom: '-',
                validTo: '-',
                serial: '-',
                fingerprint: '-'
            };
        },

        extractCertificateCN(value) {
            if (!value) return '-';

            const text = String(value).trim(); 
            const match = text.match(/CN\s*=\s*([^,\/]+)/i);

            if (match && match[1]) {
                return match[1].trim();
            }

            return text;
        },

        formatThaiDateTime(value) {
            if (!value) return '-';

            const text = String(value).trim(); 
            const match = text.match(/^(\d{4})-(\d{2})-(\d{2})[ T](\d{2}):(\d{2}):(\d{2})/);

            if (!match) return text;

            const yearBE = Number(match[1]) + 543;
            const month = Number(match[2]);
            const day = Number(match[3]);

            return `${day}/${month}/${yearBE} ${match[4]}:${match[5]}:${match[6]}`;
        },

        formatFingerprint(value) {
            if (!value || value === '-') return '-';

            const cleaned = String(value)
                .replace(/[^a-fA-F0-9]/g, '')
                .toUpperCase();

            if (!cleaned) return '-';

            return cleaned.match(/.{1,2}/g).join(':');
        },

        formatThaiDateTimeBE(value) {
            if (!value) return '-'; 
            if (value === 'รอบันทึกข้อมูล') {
                return value;
            }
            const months = [
                'มกราคม',
                'กุมภาพันธ์',
                'มีนาคม',
                'เมษายน',
                'พฤษภาคม',
                'มิถุนายน',
                'กรกฎาคม',
                'สิงหาคม',
                'กันยายน',
                'ตุลาคม',
                'พฤศจิกายน',
                'ธันวาคม'
            ];

            const text = String(value).trim(); 
            const match = text.match(/^(\d{4})-(\d{2})-(\d{2})(?:[ T](\d{2}):(\d{2})(?::(\d{2}))?)?/);

            if (match) {
                const yearBE = Number(match[1]) + 543;
                const monthName = months[Number(match[2]) - 1];
                const day = Number(match[3]);

                const hour = match[4] || '00';
                const minute = match[5] || '00';
                const second = match[6] || '00';

                return `${day} ${monthName} ${yearBE} เวลา ${hour}:${minute}:${second} น.`;
            } 
            const date = new Date(value);

            if (!isNaN(date.getTime())) {
                const day = date.getDate();
                const monthName = months[date.getMonth()];
                const yearBE = date.getFullYear() + 543;

                const hour = String(date.getHours()).padStart(2, '0');
                const minute = String(date.getMinutes()).padStart(2, '0');
                const second = String(date.getSeconds()).padStart(2, '0');

                return `${day} ${monthName} ${yearBE} เวลา ${hour}:${minute}:${second} น.`;
            }

            return text;
        },

        openSignatureFilePicker() {
            if (this.isSignatureLocked) {
                Swal.fire({
                    icon: 'info',
                    title: 'ยังไม่สามารถแก้ไขได้',
                    text: 'หากต้องการเปลี่ยนลายเซ็น กรุณากดปุ่ม “เปลี่ยนลายเซ็น” ก่อน',
                });
                return;
            }

            this.$refs.signatureInput.click();
        },

        startChangeSignature() {
            this.oldSignaturePreview = this.signaturePreview;
            this.oldSignatureUpdatedAt = this.signatureUpdatedAt;

            this.signatureEditMode = true;
            this.signatureChanged = false;
            this.signatureFile = null;

            this.clearCanvas();

            Swal.fire({
                icon: 'success',
                title: 'เปิดโหมดเปลี่ยนลายเซ็นแล้ว',
                text: 'สามารถอัปโหลดรูปใหม่ หรือวาดลายเซ็นใหม่ได้',
                timer: 1400,
                showConfirmButton: false,
            });
        },

        cancelChangeSignature() {
            this.signaturePreview = this.oldSignaturePreview;
            this.signatureUpdatedAt = this.oldSignatureUpdatedAt;

            this.signatureEditMode = false;
            this.signatureChanged = false;
            this.signatureFile = null;

            this.clearCanvas();
        },








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
    width: 40px;
    height: 40px;
    border-radius: 14px;
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

.profile-avatar {
    width: 96px;
    height: 96px;
    margin: 0 auto 16px;
    border-radius: 50%;
    overflow: hidden;
    background: linear-gradient(135deg, #1e88e5, #60b8ff);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 8px 18px rgba(30, 136, 229, 0.25);
}

.profile-avatar img {
    width: 100%;
    height: 100%;
    display: block;
    object-fit: cover;
    object-position: center top;
}

.profile-avatar span {
    color: #ffffff;
    font-size: 30px;
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
    word-break: normal;
    overflow-wrap: anywhere;
    font-family: monospace;
    font-size: 12px;
    line-height: 1.5;
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

/* Dialog */
:deep(.cert-create-dialog .p-dialog-header) {
    padding: 22px 22px 18px;
    border-bottom: 1px solid #e5e7eb;
}

:deep(.cert-create-dialog .p-dialog-title) {
    font-size: 18px;
    font-weight: 800;
    color: #333247;
}

:deep(.cert-create-dialog .p-dialog-content) {
    padding: 20px 20px 8px;
}

:deep(.cert-create-dialog .p-dialog-footer) {
    padding: 14px 20px 18px;
    border-top: 1px solid #eef0f4;
}

.cert-dialog-body {
    color: #4b4b5f;
}

.cert-info-box {
    display: flex;
    gap: 14px;
    align-items: flex-start;
    padding: 16px;
    margin-bottom: 10px;
    border-radius: 7px;
    background: #d9f0ff;
    color: #7a8492;
    line-height: 1.6;
}

.cert-info-box i {
    width: 32px;
    height: 32px;
    min-width: 32px;
    border-radius: 8px;
    background: #25a8f5;
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
}

.cert-form .field {
    position: relative;
    margin-bottom: 10px;
}

.cert-form label {
    position: absolute;
    top: -9px;
    left: 14px;
    z-index: 1;
    padding: 0 5px;
    background: #ffffff;
    color: #7b7688;
    font-size: 13px;
    font-weight: 500;
}

.cert-form label span {
    color: #e53935;
}

.cert-form :deep(.p-inputtext) {
    width: 100%;
    min-height: 56px;
    border-radius: 7px;
    border: 1px solid #d1d5db;
    color: #36344a;
    font-size: 15px;
    padding: 14px 13px 8px;
}

.cert-form :deep(.p-inputtext:focus) {
    border-color: #2196f3;
    box-shadow: 0 0 0 1px rgba(33, 150, 243, 0.18);
}

.draw-panel.locked {
    background: #f8fafc;
    border-style: dashed;
}

.draw-panel.locked .signature-canvas {
    cursor: not-allowed;
    background: #f3f4f6;
    opacity: 0.7;
}

.signature-locked-message {
    margin-bottom: 8px;
    padding: 8px 10px;
    border-radius: 6px;
    background: #fff7ed;
    color: #c2410c;
    font-size: 13px;
    font-weight: 600;
}

.bottom-actions {
    align-items: center;
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