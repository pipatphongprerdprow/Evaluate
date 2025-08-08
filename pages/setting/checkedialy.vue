<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-5">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-file" style="font-size: x-large;"></i> ตรวจสอบภาระงานประจำวัน
                        </h3>
                    </div>
                    <div class="col md:col-5">
                        <Dropdown v-model="selectedEvaluationRound" :options="evaluationRounds" :optionLabel="(item) => `${item.facuties} ${item.d_evaluationround} ${item.d_date}`" placeholder="กรุณาเลือกรอบการประเมิน" style="max-width: 500px; width: 100%" />
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
                            <td style="padding-left: 5px;text-align: left;">
                                <b style="color: blue;">{{ item.prefixfullname }} {{ item.namefully }}</b>
                            </td>
                            <td class="text-center" style="color: blue;">
                                <b>{{ item.posnameth || '' }}</b>
                            </td>
                            <td style="text-align: center;">
                                <Button label="รายละเอียด" severity="info" icon="pi pi-list" style="width: 130px;" @click="openDailyTaskDetail(item)" />
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Dialog -->
                <div class="col md:col-5 text-right">
                    <Dialog header="รายละเอียดภาระงานประจำวัน" maximizable v-model:visible="dailyTaskDialogVisible" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw', height: '100vh' }" :modal="true" position="top"> 
                        <template #header>
                            <h3>รายงานภาระงานประจำวัน</h3>
                            <p v-if="currentStaffDetail"> <strong>ชื่อผู้ปฎิบัติงาน:</strong> {{ currentStaffDetail?.prefixfullname || '-' }} {{ currentStaffDetail?.staffname || '-' }} {{ currentStaffDetail?.staffsurname || '-' }} </p>
                        </template> 
                        <!-- แสดงชื่อแผนและภาระงานใต้แผน -->
                        <div v-for="plan in dailyTasksOfStaff" :key="plan.action_id" class="mb-4">
                            <h4 style="color: darkblue;">
                                 {{ plan.actionplan_label }}
                                <small>({{ formatDate(plan.action_startdate) }} - {{ formatDate(plan.action_enddate) }})</small>
                            </h4> 
                            <DataTable :value="plan.daily_tasks" :rows="5" :paginator="true" responsiveLayout="scroll">
                                <!-- <Column field="evaluation_round" header="รอบประเมิน" style="width: 8%; text-align: center;" /> -->
                                <Column field="task_date" header="วันที่ปฏิบัติงาน" style="width: 12%; text-align: center;">
                                    <template #body="{ data }">{{ formatDate(data.task_date) }}</template>
                                </Column>
                                <Column field="description" header="รายละเอียดงาน" style="width: 20%;" />

                                <!-- ไฟล์เอกสาร -->
                                <Column header="ไฟล์เอกสาร" style="width: 15%; text-align: center;">
                                    <template #body="{ data }">
                                        <a v-if="data.file_path" 
                                           :href="getFileUrl(data.file_path)" 
                                           target="_blank" 
                                           style="color: blue; text-decoration: underline;">
                                           📎 {{ data.file_name || 'ดาวน์โหลด' }}
                                        </a>
                                        <span v-else>-</span>
                                    </template>
                                </Column>

                                <!-- ลิงก์เอกสาร -->
                                <Column header="ลิงก์เอกสาร" style="width: 15%; text-align: center;">
                                    <template #body="{ data }">
                                        <a v-if="data.document_link" 
                                           :href="data.document_link" 
                                           target="_blank" 
                                           style="color: green; text-decoration: underline;">
                                           🔗 เปิดลิงก์
                                        </a>
                                        <span v-else>-</span>
                                    </template>
                                </Column>

                                <!-- ความคิดเห็นผู้บริหาร -->
                               <Column header="ความคิดเห็นผู้บริหาร" style="width: 25%;">
                                    <template #body="{ data }">
                                        <div style="display: flex; flex-direction: column; align-items: center; gap: 0.5rem;">
                                            <Textarea v-model="data.manager_comment" autoResize rows="2" cols="25" style="width: 90%;" placeholder="เพิ่มความคิดเห็น..." />
                                            <Button label="บันทึก" size="small" icon="pi pi-save" @click="saveManagerComment(data)" />
                                                <div v-if="data.manager_comment_date"
                                                    style="font-size: 0.8em; color: gray; text-align: center;">
                                                    (อัปเดตล่าสุด: {{ formatDate(data.manager_comment_date) }})
                                                </div>
                                        </div>
                                    </template>
                                </Column> 
                                <Column field="status" header="สถานะ" style="width: 10%; text-align: center;">
                                    <template #body="{ data }">
                                        <Tag :value="getStatusLabel(data.status)" :severity="getStatusSeverity(data.status)" />
                                    </template>
                                </Column>
                            </DataTable>
                        </div>

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

export default {
    data() {
        return {
            staffIdMain: '',
            facIdMain: '',
            groupIdMain: '',
            selectedEvaluationRound: null,
            evaluationRounds: null,
            products: [],
            dailyTaskDialogVisible: false,
            currentStaffDetail: null,
            dailyTasksOfStaff: []
        };
    },
    async mounted() {
        const session = await useAuth().getSession();
        if (session?.user?.name) {
            const { STAFFID, SCOPES } = session.user.name;
            const { staffdepartment, groupid } = SCOPES;
            this.staffIdMain = String(STAFFID);
            this.facIdMain = String(staffdepartment);
            this.groupIdMain = String(groupid);
            this.fetchEvaluationRounds();
        }
    },
    methods: {
        formatDate(dateString) {
            if (!dateString) return '';
            const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
            return new Date(dateString).toLocaleDateString('th-TH', options);
        },
        getFileUrl(filename) {
            return filename ? `http://127.0.0.1:8000/storage/${filename}` : '';
        },
        async fetchEvaluationRounds() {
            try {
                const res = await axios.post('http://127.0.0.1:8000/api/showDateSetleader', {
                    staff_id: this.staffIdMain,
                    fac_id: this.facIdMain,
                    group_id: this.groupIdMain
                });
                this.evaluationRounds = res.data;
            } catch {
                Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดรอบการประเมินได้' });
            }
        },
        async fetchStaffAndDailyTasks() {
            if (!this.selectedEvaluationRound) {
                Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมิน', 'error');
                return;
            }
            try {
                const res = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {
                    params: {
                        staff_id: this.staffIdMain,
                        fac_id: this.selectedEvaluationRound.fac_id,
                        group_id: this.groupIdMain,
                        evalua: this.selectedEvaluationRound.evalua,
                        p_year: this.selectedEvaluationRound.d_date
                    }
                });
                this.products = res.data.filter(item =>
                    item.stftypename !== "ลูกจ้างชั่วคราว" &&
                    item.stftypename !== "พนักงานราชการ"
                );
            } catch {
                Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลผู้รับการประเมินได้' });
            }
        },
        async openDailyTaskDetail(staffData) {
            if (!this.selectedEvaluationRound) {
                Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน', 'error');
                return;
            }
            this.currentStaffDetail = staffData;
            this.dailyTaskDialogVisible = true;
            try {
                const plansRes = await axios.post('http://127.0.0.1:8000/api/getDataplans', {
                    staffid: staffData.staffid,
                    facid: this.selectedEvaluationRound.fac_id
                });
                this.dailyTasksOfStaff = plansRes.data.plans;
            } catch {
                Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถโหลดข้อมูลภาระงานประจำวันได้' });
            }
        },
        async saveManagerComment(task) {
            try {
                await axios.post(`http://127.0.0.1:8000/api/updateManagerComment/${task.id}`, {
                    manager_comment: task.manager_comment
                });
                Swal.fire({
                    icon: 'success',
                    title: 'บันทึกความคิดเห็นเรียบร้อย',
                    timer: 1500,
                    showConfirmButton: false
                });
            } catch {
                Swal.fire({ icon: 'error', title: 'ข้อผิดพลาด', text: 'ไม่สามารถบันทึกความคิดเห็นได้' });
            }
        },
        getStatusLabel(status) {
            switch (status) {
                case 'completed': return 'เสร็จสิ้น';
                case 'pending': return 'รอดำเนินการ';
                case 'in_progress': return 'อยู่ระหว่างดำเนินการ';
                case 'cancelled': return 'เกินเวลากำหนด';
                default: return '-';
            }
        },
        getStatusSeverity(status) {
            switch (status) {
                case 'completed': return 'success';
                case 'pending': return 'warning';
                case 'in_progress': return 'info';
                case 'cancelled': return 'danger';
                default: return 'secondary';
            }
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
