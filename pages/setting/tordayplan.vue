<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-file" style="font-size: x-large;"></i> บันทึกแผนปฏิบัติงานและภาระงานประจำวัน
                        </h3>
                    </div>
                    <br>
                    <div class="col md:col-16 text-right">
                        <Button icon="pi pi-book" severity="warning" class="mb-2 mr-2" label="เพิ่มแผนปฎิบัติงาน" @click="openAddWorkPlanDialog" />
                        
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มภาระงานประจำวัน" @click="openAddTaskDialog" :disabled="workPlans.length === 0" />

                        <Dropdown
                            v-model="selectedWorkPlanId"
                            :options="workPlans"
                            optionLabel="planName"
                            optionValue="planId"
                            placeholder="เลือกแผนปฎิบัติงานเพื่อดูภาระงาน"
                            class="w-full md:w-auto mr-2 mb-2"
                            :disabled="workPlans.length === 0"
                            @change="onWorkPlanSelected"
                        />
                        
                        <Dialog v-model:visible="displayAddWorkPlanDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '50vw' }" :modal="true" position="top">
                            <template #header>
                                <h5 class="m-0"><b>{{ currentWorkPlan.planId ? 'แก้ไขแผนปฎิบัติงาน' : 'บันทึกแผนปฎิบัติงาน' }}</b></h5>
                            </template>
                            <form>
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12">
                                        <label for="work_plan_name">ชื่อแผนปฎิบัติงาน <span style="color:red">*</span></label>
                                        <InputText v-model="currentWorkPlan.planName" type="text" placeholder="ระบุชื่อแผนปฎิบัติงาน" required />
                                        <small class="p-error" v-if="!currentWorkPlan.planName && submittedPlan">กรุณากรอกชื่อแผนปฎิบัติงาน</small>
                                    </div>
                                    <div class="field col-12 md:col-6">
                                        <label for="work_plan_start_date">วันที่เริ่มต้นแผน <span style="color:red">*</span></label>
                                        <Calendar v-model="currentWorkPlan.startDate" dateFormat="dd/mm/yy" showIcon class="w-full" required />
                                        <small class="p-error" v-if="!currentWorkPlan.startDate && submittedPlan">กรุณาระบุวันที่เริ่มต้น</small>
                                    </div>
                                    <div class="field col-12 md:col-6">
                                        <label for="work_plan_end_date">วันที่สิ้นสุดแผน <span style="color:red">*</span></label>
                                        <Calendar v-model="currentWorkPlan.endDate" dateFormat="dd/mm/yy" showIcon class="w-full" required />
                                        <small class="p-error" v-if="!currentWorkPlan.endDate && submittedPlan">กรุณาระบุวันที่สิ้นสุด</small>
                                    </div>
                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึกแผน" icon="pi pi-check" class="mb-2 mr-2" @click="saveWorkPlan" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="displayAddWorkPlanDialog = false" />
                            </template>
                        </Dialog>

                        <Dialog v-model:visible="displayAddTaskDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top">
                            <template #header>
                                <div class="flex justify-between items-start w-full">
                                    <div class="flex-1">
                                        <h5 class="m-0"><b>{{ currentTask.id ? 'แก้ไขภาระงานประจำวัน' : 'บันทึกภาระงานประจำวัน' }}</b></h5>
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
                                    <div class="field col-12 md:col-6">
                                        <label for="parent_work_plan">แผนปฎิบัติงาน <span style="color:red">*</span></label>
                                        <Dropdown
                                            v-model="currentTask.workPlanId"
                                            :options="workPlans"
                                            optionLabel="planName"
                                            optionValue="planId"
                                            placeholder="เลือกแผนปฎิบัติงาน"
                                            class="w-full"
                                            :required="true"
                                            :disabled="workPlans.length === 0"
                                        />
                                        <small class="p-error" v-if="!currentTask.workPlanId && submittedTask">กรุณาเลือกแผนปฎิบัติงาน</small>
                                    </div>
                                    <div class="field col-12 md:col-6">
                                        <label for="evaluation_round">รอบประเมิน <span style="color:red">*</span></label>
                                        <Dropdown
                                            v-model="currentTask.evaluadaily"
                                            :options="evaluadailys"
                                            optionLabel="label"
                                            optionValue="value"
                                            placeholder="เลือกรอบประเมิน"
                                            class="w-full"
                                            :required="true"
                                        />
                                        <small class="p-error" v-if="!currentTask.evaluadaily && submittedTask">กรุณาเลือกรอบประเมิน</small>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="task_date">วันที่ลงบันทึก</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <InputText :value="formatDate(currentTask.taskDate)" disabled class="w-full" />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="end_date">วันที่กำหนดเสร็จ <span style="color:red">*</span></label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="currentTask.EndDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี เวลา"
                                                showIcon
                                                showTime
                                                hourFormat="24"
                                                class="w-full"
                                                :required="true"
                                            />
                                        </InputGroup>
                                        <small class="p-error" v-if="!currentTask.EndDate && submittedTask">กรุณาระบุวันที่กำหนดเสร็จ</small>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="acomp_date">วันที่เสร็จจริง</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="currentTask.AcompDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี เวลา"
                                                showIcon
                                                showTime
                                                hourFormat="24"
                                                class="w-full"
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
                                                v-model="currentTask.documentLink"
                                                type="text"
                                                placeholder="วางลิงก์เอกสาร เช่น https://..."
                                                autocomplete="off"
                                            />
                                        </InputGroup>
                                    </div>

                                    <div class="field col-12 md:col-12">
                                        <label for="daily_task">ภาระงานประจำวัน <span style="color:red">*</span></label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-pencil"></i>
                                            </InputGroupAddon>
                                            <Textarea
                                                v-model="currentTask.dailyTask"
                                                rows="3"
                                                placeholder="ระบุภาระงานประจำวัน..."
                                                autoResize
                                                class="w-full"
                                                :required="true"
                                            />
                                        </InputGroup>
                                        <small class="p-error" v-if="!currentTask.dailyTask && submittedTask">กรุณาระบุภาระงานประจำวัน</small>
                                    </div>
                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDailyTask" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetTaskDialog" />
                            </template>
                        </Dialog>

                        <Dialog v-model:visible="displayTaskDetailDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <template #header>
                                <h5 class="m-0"><b>รายละเอียดภาระงาน</b></h5>
                            </template>
                            <div class="p-fluid grid" v-if="selectedTaskDetail">
                                <div class="col-12 md:col-6">
                                    <p><strong>แผนปฎิบัติงาน:</strong> {{ selectedTaskDetail.work_plan_name }}</p>
                                </div>
                                <div class="col-12 md:col-6">
                                    <p><strong>รอบประเมิน:</strong> {{ selectedTaskDetail.daily_evalua }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่ลงบันทึก:</strong> {{ formatDate(selectedTaskDetail.daily_date) }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่กำหนดเสร็จ:</strong> {{ formatDate(selectedTaskDetail.end_date) }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่เสร็จจริง:</strong> {{ selectedTaskDetail.accomplet_date && selectedTaskDetail.accomplet_date !== '0000-00-00 00:00:00' ? formatDate(selectedTaskDetail.accomplet_date) : 'ยังไม่ระบุ' }}</p>
                                </div>

                                <div class="col-12">
                                    <p><strong>ภาระงาน:</strong> {{ selectedTaskDetail.name_dialywork }}</p>
                                </div>

                                <div class="col-12 md:col-6">
                                    <p><strong>ไฟล์เอกสาร:</strong>
                                        <span v-if="selectedTaskDetail.daily_filename">
                                            <a :href="getFileUrl(selectedTaskDetail.dialy_file)" target="_blank" class="p-button p-component p-button-link">
                                                <i class="pi pi-download"></i> {{ selectedTaskDetail.daily_filename }}
                                            </a>
                                        </span>
                                        <span v-else>ไม่มีไฟล์</span>
                                    </p>
                                </div>
                                <div class="col-12 md:col-6">
                                    <p><strong>ลิงก์เอกสาร:</strong>
                                        <a v-if="selectedTaskDetail.daily_link" :href="selectedTaskDetail.daily_link" target="_blank" class="p-button p-component p-button-link">
                                            <i class="pi pi-external-link"></i> เปิดลิงก์
                                        </a>
                                        <span v-else>ไม่มีลิงก์</span>
                                    </p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>ใช้เวลาทั้งหมด:</strong>&nbsp;
                                        <span v-if="selectedTaskDetail.total_time_display">
                                        {{ selectedTaskDetail.total_time_display }}
                                        </span>
                                        <span v-else>ยังไม่เสร็จสิ้น/ไม่ระบุเวลา</span>
                                    </p>
                                </div>

                                <div class="col-12 md:col-4">
                                    <p><strong>ผู้บันทึก:</strong> {{ selectedTaskDetail.name_daily }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>สังกัด:</strong> {{ selectedTaskDetail.name_facdialy }}</p>
                                </div>

                                <div class="col-12 md:col-4">
                                    <p><strong>สถานะ:</strong> &nbsp;
                                        <Button
                                            v-if="selectedTaskDetail.status === 'in_progress'"
                                            label="กำลังดำเนินการ"
                                            severity="warning"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else-if="selectedTaskDetail.status === 'completed'"
                                            label="เสร็จสิ้น"
                                            severity="success"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else-if="selectedTaskDetail.status === 'overdue'"
                                            label="เลยกำหนด"
                                            severity="danger"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else
                                            label="ไม่ระบุ"
                                            severity="contrast" class="p-button-sm"
                                            outlined
                                        />
                                    </p>
                                </div>
                            </div>
                            <template #footer>
                                <Button label="ปิด" icon="pi pi-times" @click="displayTaskDetailDialog = false" style="background-color: red; color: white; border: none;"/>
                            </template>
                        </Dialog>
                    </div>
                </div>

                <div class="card mb-4" v-if="selectedWorkPlanObject">
                    <div class="flex justify-content-between align-items-center mb-3">
                        <div>
                            <h4 class="m-0">
                                <i class="pi pi-book mr-2"></i> 
                                **แผนปฏิบัติงาน: {{ selectedWorkPlanObject.planName }}**
                                <br>
                                <small>วันที่: {{ formatDateOnly(selectedWorkPlanObject.startDate) }} - {{ formatDateOnly(selectedWorkPlanObject.endDate) }}</small>
                            </h4>
                        </div>
                        <div>
                            <Button icon="pi pi-pencil" class="p-button-rounded p-button-success p-button-text mr-2" @click="editWorkPlan(selectedWorkPlanObject)" />
                            <Button icon="pi pi-trash" class="p-button-rounded p-button-danger p-button-text" @click="deleteWorkPlan(selectedWorkPlanObject)" />
                        </div>
                    </div>
                </div>
                <div v-else class="card">
                    <p class="text-center text-500">โปรดเลือกแผนปฏิบัติงานจาก Dropdown ด้านบน</p>
                </div>
                
                <div class="card" v-if="selectedWorkPlanObject">
                    <h4 class="mb-3">ภาระงานประจำวัน
                        <span v-if="selectedWorkPlanObject">
                            สำหรับแผน: **{{ selectedWorkPlanObject.planName }}**
                        </span>
                    </h4>
                    <DataTable :value="filteredDailyTasks" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id" :emptyMessage="getEmptyMessage()">
                        <Column field="daily_date" header="วันที่" style="width: 10%; text-align: center;">
                            <template #body="slotProps">
                                <b>{{ formatDate(slotProps.data.daily_date) }}</b>
                            </template>
                        </Column>
                        <Column field="daily_evalua" header="รอบประเมิน" style="width: 10%; text-align: center;">
                            <template #body="slotProps">
                                <b>{{ slotProps.data.daily_evalua }}</b>
                            </template>
                        </Column>
                        <Column field="name_dialywork" header="ภาระงาน" style="width: 25%; text-align: left;">
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
                        <Column field="daily_link" header="ลิงก์เอกสาร" style="width: 10%; text-align: center;">
                            <template #body="slotProps">
                                <a v-if="slotProps.data.daily_link" :href="slotProps.data.daily_link" target="_blank" class="p-button p-component p-button-link">
                                    <i class="pi pi-external-link"></i> เปิดลิงก์
                                </a>
                                <span v-else>ไม่มีลิงก์</span>
                            </template>
                        </Column>
                        <Column field="status" header="สถานะ" style="width: 15%; text-align: center;">
                            <template #body="slotProps">
                                <Button
                                    v-if="slotProps.data.status === 'in_progress'"
                                    label="กำลังดำเนินการ"
                                    severity="warning"
                                    class="p-button-sm"
                                />
                                <Button
                                    v-else-if="slotProps.data.status === 'completed'"
                                    label="เสร็จสิ้น"
                                    severity="success"
                                    class="p-button-sm"
                                />
                                <Button
                                    v-else-if="slotProps.data.status === 'overdue'"
                                    label="เลยกำหนด"
                                    severity="danger"
                                    class="p-button-sm"
                                />
                                <Button
                                    v-else
                                    label="ไม่ระบุ"
                                    severity="contrast" class="p-button-sm"
                                    outlined
                                />
                            </template>
                        </Column>
                        <Column field="actions" header="จัดการ" headerStyle="text-align: center;" bodyStyle="text-align: center;" style="width: 10%;">
                            <template #body="slotProps">
                                <Button
                                    icon="pi pi-ellipsis-h"
                                    class="p-button-text p-button-secondary"
                                    @click="toggleOptionsMenu($event, slotProps.data)"
                                    aria-haspopup="true"
                                    aria-controls="overlay_menu"
                                />
                            </template>
                        </Column>
                    </DataTable>
                    <Menu ref="optionsMenu" :model="items" :popup="true" />
                </div>
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
            staffid_Main: '12345', // Mock user ID
            facid_Main: '67890', // Mock faculty ID
            groupid_Main: '01',
            userStaffId: '12345',
            userFacId: '67890',
            userStaffNameDaily: 'สมชาย รักชาติ', // Mock user name
            userStaffDepartmentName: 'ฝ่ายบุคคล', // Mock department name

            allDailyTasks: [], // เก็บภาระงานทั้งหมด
            filteredDailyTasks: [], // ภาระงานที่ถูกกรองตามแผนที่เลือก
            workPlans: [], // รายการแผนปฏิบัติงาน
            selectedWorkPlanId: null, // ID ของแผนปฏิบัติงานที่ถูกเลือกจาก Dropdown หลัก
            selectedWorkPlanObject: null, // Object ของแผนปฏิบัติงานที่ถูกเลือก (สำหรับแสดงชื่อและข้อมูลแผน)
            
            displayAddWorkPlanDialog: false,
            displayAddTaskDialog: false,
            displayTaskDetailDialog: false,

            currentWorkPlan: { // ข้อมูลสำหรับฟอร์มเพิ่ม/แก้ไขแผน
                planId: null,
                planName: '',
                startDate: null,
                endDate: null,
            },
            currentTask: { // ข้อมูลสำหรับฟอร์มเพิ่ม/แก้ไขภาระงาน
                id: null,
                workPlanId: null, // สำหรับเลือกแผนใน Dialog
                dailyTask: '',
                taskDate: null, // จะถูกกำหนดเป็นวันที่ปัจจุบัน
                EndDate: null,
                AcompDate: null,
                documentLink: '',
                selectedFile: null,
                base64FileContent: null,
                dailyFilename: '',
                evaluadaily: null,
            },
            evaluadailys: [
                { label: 'รอบประเมินที่ 1', value: 1 },
                { label: 'รอบประเมินที่ 2', value: 2 },
            ],
            selectedTaskDetail: null, // ใช้สำหรับ DialogDetail
            selectedRowData: null, // ใช้สำหรับเก็บข้อมูลแถวที่คลิก Menu เพื่อส่งให้ command

            submittedPlan: false, // ใช้เพื่อแสดง error validation สำหรับแผน
            submittedTask: false, // ใช้เพื่อแสดง error validation สำหรับภาระงาน

            items: [
                {
                    label: 'ดูรายละเอียด',
                    icon: 'pi pi-info-circle',
                    class: 'detail-menu-item',
                    command: () => {
                        this.openTaskDetailDialog(this.selectedRowData);
                    }
                },
                {
                    label: 'แก้ไข',
                    icon: 'pi pi-pencil',
                    class: 'edit-menu-item',
                    command: () => {
                        this.editDailyTask(this.selectedRowData);
                    }
                },
                {
                    label: 'ลบ',
                    icon: 'pi pi-trash',
                    class: 'delete-menu-item',
                    command: () => {
                        this.deleteDailyTask(this.selectedRowData);
                    }
                }
            ]
        };
    },
    async mounted() {
        // Mock user session if real auth is not available during prototype
        // const session = await useAuth().getSession();
        // if (session && session.user && session.user.name) {
        //     const { STAFFID, SCOPES, STAFFNAME, PREFIXFULLNAME, STAFFSURNAME } = session.user.name;
        //     const { staffdepartment, groupid, staffdepartmentname } = SCOPES;
        //     this.staffid_Main = String(STAFFID);
        //     this.facid_Main = String(staffdepartment);
        //     this.groupid_Main = String(groupid);
        //     this.userStaffId = String(STAFFID);
        //     this.userFacId = String(staffdepartment);
        //     this.userStaffNameDaily = `${PREFIXFULLNAME || ''} ${STAFFNAME || ''} ${STAFFSURNAME || ''}`.trim();
        //     this.userStaffDepartmentName = String(staffdepartmentname);
        // } else {
        //     console.warn("User session data not found, using mock data.");
        // }

        await this.loadInitialData();
    },
    methods: {
        async loadInitialData() {
            // Load mock data for plans
            this.workPlans = [
                { planId: 101, planName: 'แผนพัฒนาบุคลากรไตรมาส 3/2568', startDate: new Date('2025-07-01'), endDate: new Date('2025-09-30') },
                { planId: 102, planName: 'แผนการปรับปรุงระบบ IT สิ้นปี 2568', startDate: new Date('2025-10-01'), endDate: new Date('2025-12-31') },
                { planId: 103, planName: 'แผนงานบริการวิชาการภาคฤดูร้อน', startDate: new Date('2026-03-15'), endDate: new Date('2026-05-30') },
                { planId: 104, planName: 'แผนการตลาดสินค้าใหม่ Q4', startDate: new Date('2025-10-15'), endDate: new Date('2025-12-30') },
                { planId: 105, planName: 'แผนฝึกอบรมพนักงานใหม่', startDate: new Date('2025-08-01'), endDate: new Date('2025-08-31') },
                { planId: 106, planName: 'แผนปรับปรุงประสิทธิภาพการผลิต', startDate: new Date('2025-09-01'), endDate: new Date('2026-02-28') },
                { planId: 107, planName: 'แผนวิจัยและพัฒนาผลิตภัณฑ์', startDate: new Date('2025-11-01'), endDate: new Date('2026-04-30') },
                { planId: 108, planName: 'แผนการเงินและบัญชีประจำปี', startDate: new Date('2025-01-01'), endDate: new Date('2025-12-31') },
                { planId: 109, planName: 'แผนกิจกรรม CSR ประจำปี', startDate: new Date('2025-06-01'), endDate: new Date('2025-11-30') },
                { planId: 110, planName: 'แผนการพัฒนาแพลตฟอร์มออนไลน์', startDate: new Date('2026-01-10'), endDate: new Date('2026-09-30') },
            ];

            // Load mock data for tasks
            const rawTasks = [
                { id: 1, work_plan_id: 101, daily_evalua: 1, daily_date: '2025-07-18 10:00:00', end_date: '2025-07-19 17:00:00', accomplet_date: '0000-00-00 00:00:00', name_dialywork: 'ประชุมวางแผนโครงการ A', daily_filename: null, dialy_file: null, daily_link: null, name_daily: 'สมชาย รักงาน', name_facdialy: 'ฝ่ายบุคคล' },
                { id: 2, work_plan_id: 101, daily_evalua: 1, daily_date: '2025-07-18 11:00:00', end_date: '2025-07-18 16:00:00', accomplet_date: '2025-07-18 15:30:00', name_dialywork: 'จัดทำเอกสารงบประมาณโครงการ A', daily_filename: 'งบประมาณA.pdf', dialy_file: 'งบประมาณA.pdf', daily_link: 'https://docs.google.com/docA', name_daily: 'สมหญิง ขยันดี', name_facdialy: 'ฝ่ายบุคคล' },
                { id: 3, work_plan_id: 102, daily_evalua: 2, daily_date: '2025-10-01 09:00:00', end_date: '2025-10-05 17:00:00', accomplet_date: '0000-00-00 00:00:00', name_dialywork: 'ศึกษาความเป็นไปได้ระบบบัญชีใหม่', daily_filename: null, dialy_file: null, daily_link: null, name_daily: 'มานะ ทุ่มเท', name_facdialy: 'ฝ่ายการเงิน' },
                { id: 4, work_plan_id: 101, daily_evalua: 1, daily_date: '2025-07-17 09:00:00', end_date: '2025-07-17 18:00:00', accomplet_date: '2025-07-17 19:00:00', name_dialywork: 'เตรียมข้อมูลนำเสนอผู้บริหาร', daily_filename: null, dialy_file: null, daily_link: null, name_daily: 'สมชาย รักงาน', name_facdialy: 'ฝ่ายบุคคล' },
                { id: 5, work_plan_id: 103, daily_evalua: 1, daily_date: '2026-03-16 09:00:00', end_date: '2026-03-20 17:00:00', accomplet_date: '0000-00-00 00:00:00', name_dialywork: 'เตรียมการจัดอบรมเชิงปฏิบัติการ', daily_filename: null, dialy_file: null, daily_link: null, name_daily: 'สุดาพร ตั้งใจ', name_facdialy: 'ฝ่ายวิชาการ' },
                { id: 6, work_plan_id: 104, daily_evalua: 1, daily_date: '2025-10-16 09:00:00', end_date: '2025-10-20 17:00:00', accomplet_date: '0000-00-00 00:00:00', name_dialywork: 'วิเคราะห์ตลาดและคู่แข่งผลิตภัณฑ์ใหม่', daily_filename: null, dialy_file: null, daily_link: null, name_daily: 'กาญจนา ฉลาดคิด', name_facdialy: 'ฝ่ายการตลาด' },
                { id: 7, work_plan_id: 105, daily_evalua: 1, daily_date: '2025-08-01 09:00:00', end_date: '2025-08-05 12:00:00', accomplet_date: '2025-08-04 11:30:00', name_dialywork: 'จัดทำคู่มือฝึกอบรมพนักงาน', daily_filename: 'คู่มือฝึกอบรม.docx', dialy_file: 'คู่มือฝึกอบรม.docx', daily_link: 'https://docs.google.com/training', name_daily: 'ปรีชา อบรมดี', name_facdialy: 'ฝ่ายบุคคล' },
            ];

            this.allDailyTasks = this.allDailyTasks.concat(rawTasks.map(this.processTaskData));

            // Set initial selected plan if available
            if (this.workPlans.length > 0) {
                this.selectedWorkPlanId = this.workPlans[0].planId;
                this.selectedWorkPlanObject = this.workPlans[0];
            }
            this.filterDailyTasksByWorkPlan(); // Initial filter
        },
        processTaskData(item) {
            const endDate = item.end_date ? new Date(item.end_date) : null;
            const accompDate = item.accomplet_date && item.accomplet_date !== '0000-00-00 00:00:00'
                            ? new Date(item.accomplet_date) : null;
            const today = new Date(); // Current date and time

            let status = 'unknown';
            if (accompDate && accompDate.getFullYear() > 1900) { // Check for valid date
                status = 'completed';
            } else {
                if (endDate && today > endDate) {
                    status = 'overdue';
                } else {
                    status = 'in_progress';
                }
            }

            const totalTime = this.calculateTotalTime(item.daily_date, item.accomplet_date);
            
            // Ensure work_plan_name is up-to-date
            const workPlan = this.workPlans.find(plan => plan.planId === item.work_plan_id);
            const workPlanName = workPlan ? workPlan.planName : 'ไม่ระบุแผน';

            return {
                ...item,
                status: status,
                total_days: totalTime.days,
                total_hours: totalTime.hours,
                total_minutes: totalTime.minutes,
                total_time_display: totalTime.display,
                work_plan_name: workPlanName
            };
        },
        formatDate(dateString) {
            if (!dateString || dateString === '0000-00-00 00:00:00' || dateString === '0000-00-00') return '';
            const date = new Date(dateString);
            if (isNaN(date.getTime())) return String(dateString);
            const options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false, timeZone: 'Asia/Bangkok' };
            return date.toLocaleDateString('th-TH', options);
        },
        formatDateOnly(dateObject) {
            if (!dateObject) return '';
            const date = new Date(dateObject);
            if (isNaN(date.getTime())) return '';
            return date.toLocaleDateString('th-TH', { year: 'numeric', month: '2-digit', day: '2-digit' });
        },
        getFileUrl(filename) {
            if (!filename) return '#';
            return `javascript:void(0);`; // Disable actual download for prototype
        },
        calculateTotalTime(startDateStr, endDateStr) {
            if (!startDateStr || !endDateStr || endDateStr === '0000-00-00 00:00:00' || endDateStr === '0000-00-00') {
                return { days: null, hours: null, minutes: null, display: 'ยังไม่เสร็จสิ้น/ไม่ระบุเวลา' };
            }
            const startDate = new Date(startDateStr);
            const endDate = new Date(endDateStr);
            const diffMs = Math.abs(endDate - startDate);
            const totalMinutes = Math.floor(diffMs / (1000 * 60));
            const days = Math.floor(totalMinutes / (24 * 60));
            const remainingMinutesAfterDays = totalMinutes % (24 * 60);
            const hours = Math.floor(remainingMinutesAfterDays / 60);
            const minutes = remainingMinutesAfterDays % 60;

            let displayString = '';
            if (days > 0) displayString += `${days} วัน `;
            if (hours > 0) displayString += `${hours} ชั่วโมง `;
            if (minutes > 0) displayString += `${minutes} นาที`;
            if (displayString.trim() === '') displayString = (diffMs > 0) ? "น้อยกว่า 1 นาที" : "เสร็จสิ้นภายในช่วงเวลาเดียวกัน";
            return { days: days, hours: hours, minutes: minutes, display: displayString.trim() };
        },

        // --- Methods for Work Plans ---
        openAddWorkPlanDialog() {
            this.displayAddWorkPlanDialog = true;
            this.currentWorkPlan = { planId: null, planName: '', startDate: null, endDate: null };
            this.submittedPlan = false;
        },
        editWorkPlan(plan) {
            this.currentWorkPlan = { ...plan };
            this.displayAddWorkPlanDialog = true;
            this.submittedPlan = false;
        },
        async saveWorkPlan() {
            this.submittedPlan = true;
            if (!this.currentWorkPlan.planName || !this.currentWorkPlan.startDate || !this.currentWorkPlan.endDate) {
                Swal.fire({ icon: 'warning', title: 'ข้อมูลไม่ครบถ้วน', text: 'กรุณากรอกข้อมูลที่จำเป็นสำหรับแผนปฏิบัติงาน' });
                return;
            }

            // Simulate API call and data update
            if (this.currentWorkPlan.planId) {
                // Update existing plan
                const index = this.workPlans.findIndex(p => p.planId === this.currentWorkPlan.planId);
                if (index !== -1) {
                    this.workPlans[index] = { ...this.currentWorkPlan };
                    // Update plan name in related tasks if it changed
                    this.allDailyTasks = this.allDailyTasks.map(task => 
                        task.work_plan_id === this.currentWorkPlan.planId 
                            ? { ...task, work_plan_name: this.currentWorkPlan.planName }
                            : task
                    );
                }
            } else {
                // Add new plan
                const newPlanId = this.workPlans.length > 0 ? Math.max(...this.workPlans.map(p => p.planId)) + 1 : 101; // Simple unique ID for prototype
                const newPlan = { ...this.currentWorkPlan, planId: newPlanId };
                this.workPlans.push(newPlan);
            }
            
            Swal.fire({ icon: 'success', title: 'สำเร็จ', text: 'บันทึกแผนปฏิบัติงานเรียบร้อยแล้ว' });
            this.displayAddWorkPlanDialog = false;
            // Select the newly added/edited plan or maintain current selection
            if (!this.selectedWorkPlanId || this.currentWorkPlan.planId === this.selectedWorkPlanId) {
                 this.selectedWorkPlanId = this.currentWorkPlan.planId || this.workPlans[this.workPlans.length - 1].planId;
                 this.selectedWorkPlanObject = this.workPlans.find(p => p.planId === this.selectedWorkPlanId);
            }
            this.filterDailyTasksByWorkPlan(); // Refresh filtered tasks
        },
        deleteWorkPlan(plan) {
            Swal.fire({
                title: 'คุณแน่ใจหรือไม่?', text: `คุณต้องการลบแผน "${plan.planName}" ใช่หรือไม่? ภาระงานที่เกี่ยวข้องจะถูกลบด้วย!`,
                icon: 'warning', showCancelButton: true, confirmButtonText: 'ใช่, ลบเลย!', cancelButtonText: 'ยกเลิก'
            }).then((result) => {
                if (result.isConfirmed) {
                    this.workPlans = this.workPlans.filter(p => p.planId !== plan.planId);
                    this.allDailyTasks = this.allDailyTasks.filter(task => task.work_plan_id !== plan.planId);

                    Swal.fire('ลบแล้ว!', 'แผนปฏิบัติงานถูกลบเรียบร้อยแล้ว', 'success');
                    // Reset selected plan if the deleted one was selected
                    if (this.selectedWorkPlanId === plan.planId) {
                        this.selectedWorkPlanId = this.workPlans.length > 0 ? this.workPlans[0].planId : null;
                        this.selectedWorkPlanObject = this.workPlans.length > 0 ? this.workPlans[0] : null;
                    }
                    this.filterDailyTasksByWorkPlan();
                }
            });
        },
        onWorkPlanSelected() {
            // Dropdown change handler - updates selectedWorkPlanObject and filters
            this.selectedWorkPlanObject = this.workPlans.find(p => p.planId === this.selectedWorkPlanId);
            this.filterDailyTasksByWorkPlan();
        },

        // --- Methods for Daily Tasks ---
        filterDailyTasksByWorkPlan() {
            if (this.selectedWorkPlanId) {
                this.filteredDailyTasks = this.allDailyTasks.filter(task => task.work_plan_id === this.selectedWorkPlanId);
            } else {
                this.filteredDailyTasks = [];
            }
        },
        getEmptyMessage() {
            if (!this.selectedWorkPlanId) {
                return "โปรดเลือกแผนปฏิบัติงานจาก Dropdown ด้านบน";
            }
            return "ไม่มีภาระงานสำหรับแผนนี้";
        },
        openAddTaskDialog() {
            this.displayAddTaskDialog = true;
            this.resetTaskForm();
            this.currentTask.taskDate = new Date(); // Set current date/time

            // Pre-select plan in the dialog if a plan is already selected in the main UI
            if (this.selectedWorkPlanId) {
                this.currentTask.workPlanId = this.selectedWorkPlanId;
            } else if (this.workPlans.length > 0) {
                // If no plan selected in main UI, but plans exist, pre-select the first one
                this.currentTask.workPlanId = this.workPlans[0].planId;
            }
            this.submittedTask = false;
        },
        openTaskDetailDialog(data) {
            this.selectedTaskDetail = data;
            this.displayTaskDetailDialog = true;
        },
        resetTaskDialog() {
            this.displayAddTaskDialog = false;
            this.resetTaskForm();
        },
        resetTaskForm() {
            this.currentTask = {
                id: null, workPlanId: null, dailyTask: '', taskDate: null, EndDate: null,
                AcompDate: null, documentLink: '', selectedFile: null, base64FileContent: null, dailyFilename: '', evaluadaily: null,
            };
            if (this.$refs.fileInputRef) {
                this.$refs.fileInputRef.value = ''; // Clear file input
            }
            this.submittedTask = false;
        },
        onFileChange(event) {
            const file = event.target.files[0];
            this.currentTask.selectedFile = file;

            if (file) {
                this.currentTask.dailyFilename = file.name;
                const reader = new FileReader();
                reader.onload = (e) => {
                    this.currentTask.base64FileContent = e.target.result;
                };
                reader.onerror = (error) => {
                    console.error("FileReader error:", error);
                    this.currentTask.base64FileContent = null;
                };
                reader.readAsDataURL(file);
            } else {
                this.currentTask.base64FileContent = null;
                this.currentTask.dailyFilename = '';
            }
        },
        async saveDailyTask() {
            this.submittedTask = true;
            if (!this.currentTask.dailyTask || !this.currentTask.EndDate || !this.currentTask.evaluadaily || !this.currentTask.workPlanId) {
                Swal.fire({ icon: 'warning', title: 'ข้อมูลไม่ครบถ้วน', text: 'กรุณากรอกข้อมูลที่จำเป็นสำหรับภาระงาน (ที่มีเครื่องหมาย * สีแดง)' });
                return;
            }

            const realTimeDateForSave = new Date();
            const formattedDate = realTimeDateForSave.toISOString().slice(0, 19).replace('T', ' ');
            const formattedEndDate = this.currentTask.EndDate ? this.currentTask.EndDate.toISOString().slice(0, 19).replace('T', ' ') : null;
            const formattedAcompDate = this.currentTask.AcompDate ? this.currentTask.AcompDate.toISOString().slice(0, 19).replace('T', ' ') : null;

            const payload = {
                id: this.currentTask.id,
                work_plan_id: this.currentTask.workPlanId,
                name_dialywork: this.currentTask.dailyTask,
                daily_evalua: this.currentTask.evaluadaily,
                daily_date: formattedDate,
                end_date: formattedEndDate,
                accomplet_date: formattedAcompDate,
                daily_link: this.currentTask.documentLink,
                dialy_file_base64: this.currentTask.base64FileContent, // For sending to API
                daily_filename: this.currentTask.dailyFilename,
                name_daily: this.userStaffNameDaily,
                name_facdialy: this.userStaffDepartmentName,
                staff_id: this.userStaffId,
                fac_id: this.userFacId,
                group_id: this.groupid_Main,
            };

            // Simulate API call and data update
            if (this.currentTask.id) {
                // Update existing task
                const index = this.allDailyTasks.findIndex(t => t.id === payload.id);
                if (index !== -1) {
                    // Update only changed fields, and re-process for status/time display
                    this.allDailyTasks[index] = this.processTaskData({ ...this.allDailyTasks[index], ...payload });
                }
            } else {
                // Add new task
                const newTaskId = this.allDailyTasks.length > 0 ? Math.max(...this.allDailyTasks.map(t => t.id)) + 1 : 1;
                const newTaskData = { ...payload, id: newTaskId };
                this.allDailyTasks.push(this.processTaskData(newTaskData));
            }
            
            Swal.fire({ icon: 'success', title: 'บันทึกสำเร็จ!', text: 'ภาระงานประจำวันถูกบันทึกเรียบร้อยแล้ว', timer: 2000, showConfirmButton: false });
            this.resetTaskDialog();
            this.filterDailyTasksByWorkPlan(); // Refresh filtered tasks
        },
        editDailyTask(data) {
            this.currentTask = {
                id: data.id,
                workPlanId: data.work_plan_id,
                dailyTask: data.name_dialywork,
                evaluadaily: data.daily_evalua,
                taskDate: new Date(data.daily_date),
                EndDate: new Date(data.end_date),
                AcompDate: data.accomplet_date && data.accomplet_date !== '0000-00-00 00:00:00' ? new Date(data.accomplet_date) : null,
                documentLink: data.daily_link,
                selectedFile: null,
                base64FileContent: null,
                dailyFilename: data.daily_filename,
            };
            this.submittedTask = false;
            this.displayAddTaskDialog = true;
        },
        deleteDailyTask(data) {
            Swal.fire({
                title: 'คุณแน่ใจหรือไม่?', text: "คุณต้องการลบภาระงานนี้ใช่หรือไม่!",
                icon: 'warning', showCancelButton: true, confirmButtonText: 'ใช่, ลบเลย!', cancelButtonText: 'ยกเลิก'
            }).then((result) => {
                if (result.isConfirmed) {
                    this.allDailyTasks = this.allDailyTasks.filter(task => task.id !== data.id);
                    Swal.fire('ลบแล้ว!', 'ภาระงานถูกลบเรียบร้อยแล้ว', 'success');
                    this.filterDailyTasksByWorkPlan();
                }
            });
        },
        toggleOptionsMenu(event, data) {
            this.selectedRowData = data;
            this.$refs.optionsMenu.toggle(event);
        },
    }
};
</script>

<style scoped>
.p-error {
    color: red;
    font-size: 0.8rem;
    margin-top: 0.2rem;
}
</style>