<template>
    <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataDaily"></Button>
    </div>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header"><i class="pi pi-file" style="font-size: x-large;"></i> บันทึกภาระงานประจำวัน </h3>
                    </div>
                    <br>
                    <div class="col md:col-16 text-right">
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มถาระงาน" @click="OpenDialogAdd" />
                        <Dialog v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top">
                            <template #header>
                                <div class="flex justify-between items-start w-full">
                                    <div class="flex-1">
                                        <h5 class="m-0"><b>บันทึกภาระงานประจำวัน</b></h5>
                                    </div>
                                    <div class="text-center">
                                        <p class="m-0">
                                            <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                                            <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                                        </p>
                                    </div>
                                </div>
                            </template>
                            <form>
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-2">
                                        <label for="evaluation_round">รอบประเมิน</label>
                                        <Dropdown
                                            v-model="evaluadaily"
                                            :options="evaluadailys"
                                            optionLabel="label"
                                            optionValue="value"
                                            placeholder="เลือกรอบประเมิน"
                                            class="w-full"
                                            required
                                        />
                                    </div>
                                    <div class="field col-12 md:col-2">
                                        <label for="task_date">วันที่ลงบันทึก</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="taskDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี"
                                                showIcon
                                                class="w-full"
                                                required
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="file_upload">ชื่อไฟล์</label> &nbsp;&nbsp;
                                        <span style="color: red;">
                                            <b>(ถ้ามี)</b>
                                        </span>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-paperclip"></i>
                                            </InputGroupAddon>
                                            <input
                                                type="file"
                                                @change="onFileChange"
                                                class="w-full border-1 surface-border border-round p-2"
                                                ref="fileInputRef"
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="document_link">ลิงก์เอกสาร</label>
                                        <span style="color: red;"> &nbsp;&nbsp; <b>(ถ้ามี)</b></span>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-link"></i>
                                            </InputGroupAddon>
                                            <InputText
                                                v-model="documentLink"
                                                type="text"
                                                placeholder="วางลิงก์เอกสาร เช่น https://..."
                                                autocomplete="off"
                                            />
                                        </InputGroup>
                                    </div>

                                    <div class="field col-12 md:col-12">
                                        <label for="daily_task">ภาระงานประจำวัน</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-pencil"></i>
                                            </InputGroupAddon>
                                            <Textarea
                                                v-model="dailyTask"
                                                rows="3"
                                                placeholder="ระบุภาระงานประจำวัน..."
                                                autoResize
                                                class="w-full"
                                                required
                                            />
                                        </InputGroup>
                                    </div>
                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDailyTask" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialogdialy" />
                            </template>
                        </Dialog>
                    </div>
                </div>
                <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                    <Column field="daily_date" header="วันที่" style="width: 15%; text-align: center;">
                        <template #body="slotProps">
                            <b>{{ formatDate(slotProps.data.daily_date) }}</b>
                        </template>
                    </Column>
                     <Column field="daily_evalua" header="รอบประเมิน" style="width: 15%; text-align: center;">
                        <template #body="slotProps">
                            <b>{{ slotProps.data.daily_evalua }}</b>
                        </template>
                    </Column>
                    <Column field="name_dialywork" header="ภาระงาน" style="width: 30%; text-align: left;">
                        <template #body="slotProps">
                            <b>{{ slotProps.data.name_dialywork }}</b>
                        </template>
                    </Column>
                    <Column field="daily_filename" header="ไฟล์เอกสาร" style="width: 20%; text-align: center;">
                        <template #body="slotProps">
                            <span v-if="slotProps.data.daily_filename">
                                <a :href="getFileUrl(slotProps.data.dialy_file)" target="_blank" class="p-button p-component p-button-link">
                                    <i class="pi pi-download"></i> {{ slotProps.data.daily_filename }}
                                </a>
                            </span>
                            <span v-else>ไม่มีไฟล์</span>
                        </template>
                    </Column>
                    <Column field="daily_link" header="ลิงก์เอกสาร" style="width: 20%; text-align: center;">
                        <template #body="slotProps">
                            <a v-if="slotProps.data.daily_link" :href="slotProps.data.daily_link" target="_blank" class="p-button p-component p-button-link">
                                <i class="pi pi-external-link"></i> เปิดลิงก์
                            </a>
                            <span v-else>ไม่มีลิงก์</span>
                        </template>
                    </Column>
                    <Column field="options" header="ตัวเลือก" headerStyle="text-align: center;" bodyStyle="text-align: center;">
                        <template #body="slotProps">
                            <div style="display: flex; justify-content: center; align-items: center; gap: 5px;">
                                <Button icon="pi pi-pencil" severity="success" class="p-button-sm" @click="editData(slotProps.data)" />
                                <Button icon="pi pi-trash" severity="danger" class="p-button-sm" @click="delData(slotProps.data)" />
                            </div>
                        </template>
                    </Column>
                </DataTable>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useAuth } from '#imports';
const { signIn, getSession, signOut } = await useAuth();
const user = await getSession();
</script>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';
import { ref } from 'vue';

export default {
    data() {
        return {
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '01',
            products_date: [],
            DialogAdd: false,
            DialogDetail: false,
            currentRecordId: null,
            taskDate: null,
            documentLink: '',
            dailyTask: '',
            selectedFile: null,
            base64FileContent: null,
            dailyFilename: '',
            userStaffId: null,
            userFacId: null,
            userStaffNameDaily: null,
            userStaffDepartmentName: null,
            evaluadaily: null,
            evaluadailys: [
                { label: 'รอบประเมินที่ 1', value: 1 },
                { label: 'รอบประเมินที่ 2', value: 2 },
            ],

        };
    },
    async mounted() {
        const session = await useAuth().getSession();
        if (session && session.user && session.user.name) {
            const { STAFFID, SCOPES, STAFFNAME, PREFIXFULLNAME, STAFFSURNAME } = session.user.name;
            const { staffdepartment, groupid, staffdepartmentname } = SCOPES;

            this.staffid_Main = String(STAFFID);
            this.facid_Main = String(staffdepartment);
            this.groupid_Main = String(groupid);

            this.userStaffId = String(STAFFID);
            this.userFacId = String(staffdepartment);
            this.userStaffNameDaily = `${PREFIXFULLNAME || ''} ${STAFFNAME || ''} ${STAFFSURNAME || ''}`.trim();
            this.userStaffDepartmentName = String(staffdepartmentname);

            await this.showDataSetUserdialy();
        } else {
            console.warn("User session data not found on mounted.");
        }
    },
    methods: {
        formatDate(dateString) {
            if (!dateString) return '';
            // New Date(dateString) ก็จะสร้าง Date object ใน Local Time ถ้า dateString เป็น 'YYYY-MM-DD'
            const date = new Date(dateString);
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            return date.toLocaleDateString('th-TH', options);
        },
        getFileUrl(filename) {
            if (!filename) return '';
            return `http://127.0.0.1:8000/storage/uploads/daily_files/${filename}`;
        },

        async showDataSetUserdialy() {
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/showDateSetUserdaily', {
                    facid_Main: this.facid_Main,
                    groupid_Main: this.groupid_Main,
                    staffid_Main: this.staffid_Main
                });
                this.products_date = response.data;
            } catch (error) {
                console.error('Error fetching data:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาด',
                    text: 'ไม่สามารถโหลดข้อมูลภาระงานได้',
                });
            }
        },
        OpenDialogAdd() {
            this.DialogAdd = true;
            this.clearForm();
        },
        resetDialogdialy() {
            this.DialogAdd = false;
            this.DialogDetail = false;
            this.clearForm();
        },
        onFileChange(event) {
            const file = event.target.files[0];
            this.selectedFile = file;

            if (file) {
                this.dailyFilename = file.name;

                const reader = new FileReader();
                reader.onload = (e) => {
                    this.base64FileContent = e.target.result;
                };
                reader.onerror = (error) => {
                    console.error("FileReader error:", error);
                    this.base64FileContent = null;
                };
                reader.readAsDataURL(file);
            } else {
                this.base64FileContent = null;
                this.dailyFilename = '';
            }
        },

        async saveDailyTask() {
            if (!this.taskDate || !this.dailyTask) {
                Swal.fire({
                    icon: 'warning',
                    title: 'ข้อมูลไม่ครบถ้วน',
                    text: 'กรุณากรอกวันที่และภาระงานประจำวันให้ครบถ้วน',
                });
                return;
            }
            if (this.evaluadaily === null) {
                Swal.fire({
                    icon: 'warning',
                    title: 'ข้อมูลไม่ครบถ้วน',
                    text: 'กรุณาเลือกรอบประเมิน',
                });
                return;
            } 
            const year = this.taskDate.getFullYear();
            const month = (this.taskDate.getMonth() + 1).toString().padStart(2, '0'); // เดือนใน JavaScript เริ่มจาก 0 (ม.ค. = 0) จึงต้อง +1
            const day = this.taskDate.getDate().toString().padStart(2, '0');
            const formattedDate = `${year}-${month}-${day}`; // สร้างสตริงในรูปแบบ YYYY-MM-DD

            const payload = {
                name_dialywork: this.dailyTask,
                daily_date: formattedDate, // ใช้ formattedDate ที่สร้างขึ้นจาก Local Time
                daily_link: this.documentLink,
                dialy_file: this.base64FileContent,
                daily_filename: this.dailyFilename,
                daily_evalua: this.evaluadaily,
                staffid: this.staffid_Main,
                facid: this.facid_Main,
                name_daily: this.userStaffNameDaily,
                name_facdialy: this.userStaffDepartmentName,
            };

            if (this.currentRecordId) {
                payload.id = this.currentRecordId;
            }
            console.log("Payload being sent:", payload);

            try {
                const res = await axios.post('http://127.0.0.1:8000/api/saveWorkdaily', payload);

                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกเรียบร้อยแล้ว !",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.DialogAdd = false;
                this.showDataSetUserdialy();
                this.clearForm();
            } catch (error) {
                console.error('Error saving daily task:', error.response || error);
                let errorMessage = "เกิดข้อผิดพลาดในการบันทึก!";
                if (error.response && error.response.data) {
                    if (error.response.data.error) {
                        errorMessage = "เกิดข้อผิดพลาด: " + error.response.data.error;
                    } else if (error.response.data.message) {
                        errorMessage = "ข้อผิดพลาด: " + error.response.data.message;
                        if (error.response.data.errors) {
                            let validationErrors = '';
                            for (const field in error.response.data.errors) {
                                validationErrors += `\n- ${error.response.data.errors[field].join(', ')}`;
                            }
                            errorMessage += validationErrors;
                        }
                    }
                } else if (error.request) {
                    errorMessage = "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ ตรวจสอบ Network";
                } else {
                    errorMessage = "ข้อผิดพลาดที่ไม่รู้จัก: " + error.message;
                }

                Swal.fire({
                    position: "top-center",
                    icon: "error",
                    title: errorMessage,
                    showConfirmButton: true,
                });
            }
        },

        editData(data) {
            this.DialogAdd = true;
            this.currentRecordId = data.id; 
            this.taskDate = data.daily_date ? new Date(data.daily_date) : null;
            this.documentLink = data.daily_link;
            this.evaluadaily = data.daily_evalua ? parseInt(data.daily_evalua, 10) : null;
            this.dailyTask = data.name_dialywork;
            this.dailyFilename = data.daily_filename || '';
            this.base64FileContent = null; // ไม่ต้องโหลดไฟล์เก่ามาแสดงใน base64 เพราะเราจะอัปโหลดใหม่ถ้าผู้ใช้เลือกไฟล์
        },
        delData(data) {
            Swal.fire({
                title: "คุณต้องการลบรายการนี้ใช่หรือไม่ ?",
                text: "เมื่อคลิกปุ่ม ใช่, ลบเลย! ข้อมูลจะถูกลบทันที!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "ใช่, ลบเลย!",
                cancelButtonText: "ยกเลิก"
            }).then(async (result) => {
                if (result.isConfirmed) {
                    try {
                        await axios.post('http://127.0.0.1:8000/api/deleteWorkdaily', {
                            id: data.id
                        });
                        this.showDataSetUserdialy();
                        Swal.fire({
                            title: "ลบข้อมูลเสร็จสิ้น!",
                            text: "ข้อมูลของคุณถูกลบแล้ว",
                            icon: "success"
                        });
                    } catch (error) {
                        console.error('Error deleting data:', error);
                        Swal.fire({
                            icon: 'error',
                            title: 'ข้อผิดพลาด',
                            text: 'ไม่สามารถลบข้อมูลได้: ' + (error.response?.data?.error || error.message),
                        });
                    }
                }
            });
        },

        clearForm() {
            this.currentRecordId = null;
            this.taskDate = null;
            this.documentLink = '';
            this.dailyTask = '';
            this.evaluadaily = null;
            this.selectedFile = null;
            this.base64FileContent = null;
            this.dailyFilename = '';
            if (this.$refs.fileInputRef) {
                this.$refs.fileInputRef.value = '';
            }
        },
        async printDataDaily() {
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession();
            const form = {
                PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                STAFFNAME :user.user.name.STAFFNAME,
                STAFFSURNAME:user.user.name.STAFFSURNAME,
                POSITIONNAME:user.user.name.POSITIONNAME,
                GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                POSTYPENAME:user.user.name.POSTYPENAME,
                SCOPES:user.user.name.SCOPES.staffdepartmentname,
                staffid: this.staffid_Main,
                facid: this.facid_Main,
                name_daily: this. userStaffNameDaily,
                daily_date: this.taskDate ? this.taskDate.toISOString().split('T')[0] : null,  
            }
            const queryParams = new URLSearchParams(form).toString();
            const url = `http://127.0.0.1:8000/report_Daily?${queryParams}`;
            window.open(url, '_blank');
        },  
    }
};
</script>

<style>
/* CSS เดิมของคุณ */
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
#country-list{
    list-style:none;
    margin-top:-3px;
    padding:0;
    width:25%;
    position: absolute;
    z-index:9999 !important;
}
#country-list li{padding: 10px; background: #f0f0f0; border-bottom: #bbb9b9 1px solid;}
#country-list li:hover{background:#ece3d2;cursor: pointer;}
</style>