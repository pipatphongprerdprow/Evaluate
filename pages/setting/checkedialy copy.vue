<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-5">
                        <h3 class="mb-4 card-header"><i class="pi pi-file" style="font-size: x-large;"></i> ตรวจสอบภาระงานประจำวัน</h3>
                    </div>
                    <div class="col md:col-5">
                        <label for="tracking_date"></label>
                        <Dropdown v-model="selectedEvaluationRound" :options="evaluationRounds" :optionLabel="(item) => `${item.facuties} ${item.d_evaluationround} ${item.d_date}`" placeholder="กรุณาเลือกรอบการประเมิน" style="max-width: 500px; width: 100%"></Dropdown>
                    </div>
                    <div class="col md:col-1">
                        <Button class="mb-2 mr-2" icon="pi pi-search" @click="fetchStaffAndDailyTasks" />
                    </div>
                </div>
                <table class="table">
                    <thead>
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th style="width: 40%;">ผู้รับการประเมิน</th>
                            <th>ตำแหน่ง</th>
                            <th>ดูภาระงาน</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 30%;text-align: left;">
                                <b style="color: blue;">{{ item.prefixfullname }} {{ item.namefully }} </b>
                            </td>
                            <td class="text-center" style="color: blue;"><b>{{ item.posnameth ? item.posnameth: '' }} </b></td>
                            <td style="text-align: center;width: 10%;">
                                <Button
                                    label="รายละเอียด"
                                    severity="info"
                                    class="mb-2 mr-2"
                                    icon="pi pi-list"
                                    @click="openDailyTaskDetail(item)"
                                    style="width: 130px;"
                                />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="col md:col-5 text-right">
                    <Dialog header="รายละเอียดภาระงานประจำวัน" maximizable v-model:visible="dailyTaskDialogVisible" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw', height: '100vh' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3 style="text-align: left;">รายงานภาระงานประจำวัน</h3>
                            <p v-if="currentStaffDetail">
                                <strong>ชื่อผู้รับการประเมิน:</strong> {{ currentStaffDetail?.prefixfullname || '-' }} {{ currentStaffDetail?.staffname || '-' }} {{ currentStaffDetail?.staffsurname || '-' }}
                            </p>
                            <!-- <p v-if="currentStaffDetail">
                                <strong>สังกัด:</strong> {{ currentStaffDetail?.staffdepartmentname || '-' }}
                            </p> -->
                        </template>
                        <TabView :activeIndex="0"> <TabPanel header="รายงานภาระงานประจำวัน">
                                <DataTable :value="dailyTasksOfStaff" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                                    <Column field="daily_date" header="วันที่" style="width: 15%; text-align: center;">
                                        <template #body="slotProps">
                                            <b>{{ formatDate(slotProps.data.daily_date) }}</b>
                                        </template>
                                    </Column>
                                    <Column field="daily_evalua" header="รอบประเมิน" style="width: 10%; text-align: center;">
                                        <template #body="slotProps">
                                            <b>{{ slotProps.data.daily_evalua }}</b>
                                        </template>
                                    </Column> 
                                    <Column field="name_dialywork" header="ภาระงาน" style="width: 35%; text-align: left;">
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
                                </DataTable>
                            </TabPanel>
                        </TabView>
                        <template #footer>
                            <Button label="ปิด" severity="secondary" @click="dailyTaskDialogVisible = false" />
                        </template>
                    </Dialog>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { useAuth } from '#imports';
const { getSession } = await useAuth();
const user = await getSession();
</script>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel';

export default {
    data() {
        return {
            // ข้อมูลหลักของผู้ใช้ที่เข้าสู่ระบบ
            staffIdMain: '',
            facIdMain: '',
            groupIdMain: '',

            // ข้อมูลสำหรับ Dropdown เลือกรอบการประเมิน
            selectedEvaluationRound: null, // เก็บ object รอบการประเมินที่เลือก
            evaluationRounds: null,      // ตัวเลือกทั้งหมดสำหรับรอบการประเมิน

            // รายชื่อเจ้าหน้าที่
            products: [],

            // การควบคุม Dialog และข้อมูลภาระงานประจำวัน
            dailyTaskDialogVisible: false, // ควบคุมการแสดง/ซ่อน Dialog
            currentStaffDetail: null,     // เก็บข้อมูลรายละเอียดเจ้าหน้าที่ที่กำลังดู
            dailyTasksOfStaff: [],        // เก็บรายการภาระงานประจำวันของเจ้าหน้าที่ที่เลือก
        };
    },
    components: {
        TabView,
        TabPanel
    },

    async mounted() {
        // ดึงข้อมูล session ของผู้ใช้เมื่อคอมโพเนนต์โหลด
        const session = await useAuth().getSession();
        if (session && session.user && session.user.name) {
            const { STAFFID, SCOPES } = session.user.name;
            const { staffdepartment, groupid } = SCOPES;

            // กำหนดค่า ID หลักของผู้ใช้เป็น String เพื่อความสอดคล้อง
            this.staffIdMain = String(STAFFID);
            this.facIdMain = String(staffdepartment);
            this.groupIdMain = String(groupid);

            // ดึงข้อมูลรอบการประเมินเมื่อคอมโพเนนต์โหลดเสร็จ
            this.fetchEvaluationRounds();
        } else {
            console.warn("ไม่พบข้อมูลผู้ใช้ใน session เมื่อคอมโพเนนต์โหลด");
        }
    },
    methods: {
        // ฟังก์ชันช่วยในการจัดรูปแบบวันที่สำหรับแสดงผล
        formatDate(dateString) {
            if (!dateString) return '';
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            const date = new Date(dateString);
            return date.toLocaleDateString('th-TH', options);
        },

        // ฟังก์ชันช่วยในการสร้าง URL สำหรับไฟล์เอกสาร
        getFileUrl(filename) {
            if (!filename) return '';
            // ตรวจสอบให้แน่ใจว่าพาธนี้ตรงกับที่คุณตั้งค่าการเก็บไฟล์ใน Laravel storage
            return `http://127.0.0.1:8000/storage/uploads/daily_files/${filename}`;
        },

        // ดึงรอบการประเมินที่มีจาก Backend
        async fetchEvaluationRounds() {
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/showDateSetleader', {
                    staff_id: this.staffIdMain,
                    fac_id: this.facIdMain,
                    group_id: this.groupIdMain
                });
                this.evaluationRounds = response.data;
            } catch (error) {
                console.error('เกิดข้อผิดพลาดในการดึงรอบการประเมิน:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาด',
                    text: 'ไม่สามารถโหลดรอบการประเมินได้',
                });
            }
        },

        // ดึงรายชื่อเจ้าหน้าที่ตามรอบการประเมินที่เลือก
        async fetchStaffAndDailyTasks() {
            if (!this.selectedEvaluationRound) {
                Swal.fire({
                    title: 'แจ้งเตือนจากระบบ!',
                    text: 'กรุณาเลือก รอบการประเมิน ก่อน!',
                    icon: 'error'
                });
                return;
            }

            try {
                const response = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {
                    params: {
                        staff_id: this.staffIdMain,
                        fac_id: this.selectedEvaluationRound.fac_id, // ใช้ faculty_id จากรอบที่เลือก
                        group_id: this.groupIdMain,
                        evalua: this.selectedEvaluationRound.evalua,
                        p_year: this.selectedEvaluationRound.d_date
                    }
                });
                // กรองประเภทเจ้าหน้าที่ที่ไม่ต้องการออกทันทีหลังจากดึงข้อมูล
                this.products = response.data.filter(item =>
                    item.stftypename !== "ลูกจ้างชั่วคราว" &&
                    item.stftypename !== "พนักงานราชการ"
                );
            } catch (error) {
                console.error('เกิดข้อผิดพลาดในการดึงข้อมูลผู้รับการประเมิน:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาด',
                    text: 'ไม่สามารถโหลดข้อมูลผู้รับการประเมินได้',
                });
            }
        },

        // เปิด Dialog และดึงภาระงานประจำวันสำหรับเจ้าหน้าที่ที่เลือก
        async openDailyTaskDetail(staffData) {
            if (!this.selectedEvaluationRound) {
                Swal.fire('แจ้งเตือนจากระบบ', 'กรุณาเลือกรอบการประเมินก่อน', 'error');
                return;
            }

            this.currentStaffDetail = staffData; // กำหนดข้อมูลเจ้าหน้าที่ที่กำลังดู
            this.dailyTaskDialogVisible = true; // แสดง Dialog

            try {
                // ดึงภาระงานประจำวันสำหรับเจ้าหน้าที่ที่เลือกโดยใช้ endpoint ที่มีอยู่
                // (หมายเหตุ: endpoint 'showDateSetUser' อาจต้องมีการปรับแก้ที่ Backend
                // หากต้องการให้กรองตามรอบการประเมินหรือปีด้วย นอกเหนือจาก staffid และ facid)
                const response = await axios.post('http://127.0.0.1:8000/api/showDateSetUserdaily', {
                    staffid_Main: staffData.staffid,
                    facid_Main: this.selectedEvaluationRound.fac_id // ใช้ faculty จากรอบการประเมินที่เลือก
                });
                this.dailyTasksOfStaff = response.data;
            } catch (error) {
                console.error('เกิดข้อผิดพลาดในการดึงภาระงานประจำวันของเจ้าหน้าที่:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาด',
                    text: 'ไม่สามารถโหลดข้อมูลภาระงานประจำวันได้',
                });
            }
        },

        // เมธอดนี้อาจไม่จำเป็นต้องมี logic อะไรพิเศษ เพราะมีแท็บเดียว
        onTabChange(event) {
            // ไม่มี logic เฉพาะที่นี่ เพราะข้อมูลภาระงานประจำวันจะถูกโหลดเมื่อ Dialog เปิด
        }
    }
};
</script>

<style>
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
</style>