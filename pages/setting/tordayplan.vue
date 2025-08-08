<template>
    <div class="p-4 bg-gray-50 min-h-screen">
        <ConfirmDialog></ConfirmDialog>

        <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
            <h1 class="text-3xl font-extrabold text-primary-800 flex items-center">
                <i class="pi pi-briefcase mr-3 text-primary-600"></i>
                บันทึกแผนปฎิบัติงานและภาระงานประจำวัน
            </h1>
        </div>
        <div class="grid">
            <div class="col-12">
                <div class="card p-6 shadow-md rounded-xl surface-card">
                    <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-5 gap-4">
                        <div class="flex flex-col sm:flex-row gap-2">
                            <Button icon="pi pi-plus" label="เพิ่มแผนปฎิบัติงาน" class="p-button-warning p-button-sm font-semibold" @click="openPlanDialog" />
                            <Button icon="pi pi-plus" label="เพิ่มภาระงาน" class="p-button-info p-button-sm font-semibold" @click="openTaskDialog" :disabled="!selectedPlanId" />
                        </div>
                        <div class="flex-1 flex flex-col sm:flex-row sm:items-center gap-3 justify-end">
                            <label for="plan-dropdown" class="font-bold text-lg text-700 mb-1 sm:mb-0 whitespace-nowrap">เลือกแผนปฏิบัติงาน:</label>
                            <Dropdown v-model="selectedPlanId" :options="plans" optionLabel="actionplan_label" optionValue="action_id" placeholder="เลือกแผนปฏิบัติงาน" />

                            <div class="flex gap-2" v-if="selectedPlanId">
                                <Button  icon="pi pi-pencil"  @click="openEditPlanDialog(selectedPlanId)" class="p-button-text p-button-rounded p-button-sm" v-tooltip.top="'แก้ไขแผน'" />
                                <Button  icon="pi pi-trash" v-if="filteredDailyTasks.length === 0" @click="confirmDeletePlan(selectedPlanId)" class="p-button-text p-button-danger p-button-rounded p-button-sm" v-tooltip.top="'ลบแผนนี้และภาระงานที่เกี่ยวข้อง'"  />
                            </div> 
                        </div> 
                    </div>
                    <Divider class="my-5" />
                    <h4 class="text-2xl font-bold text-700 mb-4 flex items-center">
                        <i class="pi pi-list mr-2 text-primary-500"></i>
                        ภาระงานประจำวัน
                        <span v-if="selectedPlanId" class="ml-2 text-primary-600 font-normal text-xl">
                            ( <span class="font-semibold text-primary-700">{{ getPlanLabelById(selectedPlanId) }}</span> <span v-if="getPlanDateRange(selectedPlanId)"> วันที่ {{ getPlanDateRange(selectedPlanId) }}</span
                            >)
                        </span>
                        <span v-else class="ml-2 text-500 font-normal text-lg">(โปรดเลือกแผนเพื่อแสดงภาระงาน)</span>
                    </h4>

                    <DataTable :value="filteredDailyTasks || []" :rows="10" :paginator="true" dataKey="id" class="p-datatable-gridlines p-datatable-sm">
                        <Column field="recordDate" header="วันที่" class="text-center" style="width: 10%">
                            <template #body="slotProps">
                                <span class="font-medium text-color-secondary">{{ formatDate(slotProps.data.recordDate) }}</span>
                            </template>
                        </Column>
                        <Column field="evaluationRound" header="รอบประเมิน" class="text-center" style="width: 7%">
                            <template #body="slotProps">
                                <Tag :value="slotProps.data.evaluation_round" class="p-tag-rounded p-tag-info font-medium"></Tag>
                            </template>
                        </Column>
                       <Column field="description" header="ภาระงาน" class="text-left" style="width: 25%">
                            <template #body="slotProps">
                                <div>
                                    <span class="text-700 font-medium">{{ slotProps.data.description }}</span>
                                    <div class="font-bold underline mt-1">
                                        ข้อเสนอแนะจากผู้บริหาร
                                    </div>
                                    <!-- แสดงข้อเสนอแนะจากผู้บริหาร ถ้ามี -->
                                    <div v-if="slotProps.data.manager_comment" 
                                        :style="{ color: 'red' }">
                                        {{ slotProps.data.manager_comment }}
                                    </div>
                                    <!-- ถ้าไม่มีข้อเสนอแนะแสดงข้อความ "ไม่มีข้อเสนอแนะ" ด้วยสีเขียว -->
                                    <div v-else 
                                        :style="{ color: 'green' }">
                                        ไม่มีข้อเสนอแนะ
                                    </div>
                                </div>
                            </template>
                        </Column>
                        <Column field="fileName" header="ไฟล์เอกสาร" class="text-center" style="width: 15%">
                            <template #body="slotProps">
                                <span v-if="slotProps.data.file_name">
                                    <a :href="getFileUrl(slotProps.data.file_path)" target="_blank" class="p-button p-component p-button-link text-sm flex items-center justify-center">
                                        <i class="pi pi-file-arrow-down mr-1"></i> {{ slotProps.data.file_name }}
                                    </a>
                                </span>
                                <span v-else class="text-500 text-sm">ไม่มีไฟล์</span>
                            </template>
                        </Column>
                        <Column field="documentLink" header="ลิงก์เอกสาร" class="text-center" style="width: 10%">
                            <template #body="slotProps">
                                <a v-if="slotProps.data.document_link" :href="slotProps.data.document_link" target="_blank" class="p-button p-component p-button-link text-sm flex items-center justify-center">
                                    <i class="pi pi-external-link mr-1"></i> เปิดลิงก์
                                </a>
                                <span v-else class="text-500 text-sm">ไม่มีลิงก์</span>
                            </template>
                        </Column>
                        <Column field="status" header="สถานะ" class="text-center" style="width: 15%">
                            <template #body="slotProps">
                                <Tag :value="getStatusLabel(slotProps.data.status)" :severity="getStatusSeverity(slotProps.data.status)" class="p-tag-rounded p-tag-sm font-bold" />
                            </template>
                        </Column>
                        <Column field="actions" header="จัดการ" headerStyle="text-align: center;" bodyStyle="text-align: center;" style="width: 13%">
                            <template #body="slotProps">
                                <Button icon="pi pi-pencil" class="p-button-success p-button-rounded p-button-sm" @click="editRow(slotProps.data)" v-tooltip.top="'แก้ไข'"></Button>&nbsp;
                                <Button  icon="pi pi-info-circle" class="p-button-text p-button-warning p-button-rounded p-button-sm"  @click="viewTaskDetails(slotProps.data)" v-tooltip.top="'ดูรายละเอียด'"></Button>&nbsp;
                                <Button icon="pi pi-trash"  class="p-button-danger p-button-rounded p-button-sm" @click="confirmDeleteTask(slotProps.data.id)" v-tooltip.top="'ลบ'"> </Button> 
                                <!-- <Button icon="pi pi-ellipsis-v" class="p-button-text p-button-secondary p-button-rounded p-button-sm" @click="toggleOptionsMenu($event, slotProps.data)" aria-haspopup="true" aria-controls="overlay_menu" /> -->
                                <!-- <Button icon="pi pi-ellipsis-v" class="p-button-text p-button-secondary p-button-rounded p-button-sm" @click="toggleOptionsMenu($event, slotProps.data)" aria-haspopup="true" aria-controls="overlay_menu"></Button> -->
                            </template>
                        </Column>
                    </DataTable>
                    <Menu ref="optionsMenu" :model="taskMenuItems" popup /> 
                </div>
            </div>
        </div>
        <Dialog  v-model:visible="showPlanDialog"  :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" modal  position="top"  class="p-dialog-lg" >
            <template #header>
                <div class="flex flex-col sm:flex-row justify-between items-center w-full gap-4">
                    <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                        <i :class="newPlan.id ? 'pi pi-pencil' : 'pi pi-calendar-plus'" class="mr-2 text-primary-500"></i>
                        {{ newPlan.id ? 'แก้ไขข้อมูลแผนปฏิบัติงาน' : 'บันทึกแผนปฏิบัติงาน' }}
                    </h5>
                    <div class="text-right text-sm text-gray-600">
                        <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                        <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                    </div>
                </div>
            </template>

            <form @submit.prevent="savePlan" class="p-fluid grid form-layout">
                <!-- รอบประเมิน -->
                <div class="field col-12 md:col-4">
                    <label class="font-semibold">รอบประเมิน <span class="text-red-500">*</span></label>
                    <Dropdown v-model="newPlan.evaluationRound" :options="evaluationRounds" optionLabel="label" optionValue="value" placeholder="เลือกรอบประเมิน" class="w-full" />
                </div>

                <!-- วันที่เริ่มต้น -->
                <div class="field col-12 md:col-4">
                    <label class="font-semibold">วันที่เริ่มต้นแผน <span class="text-red-500">*</span></label>
                    <Calendar v-model="newPlan.startDate" dateFormat="dd/mm/yy" showIcon class="w-full" />
                </div>

                <!-- วันที่สิ้นสุด -->
                <div class="field col-12 md:col-4">
                    <label class="font-semibold">วันที่สิ้นสุดแผน <span class="text-red-500">*</span></label>
                    <Calendar v-model="newPlan.endDate" dateFormat="dd/mm/yy" showIcon class="w-full" />
                </div>

                <!-- ชื่อแผน -->
                <div class="field col-12">
                    <label class="font-semibold">ชื่อแผนปฏิบัติงาน <span class="text-red-500">*</span></label>
                    <InputText v-model="newPlan.planLabel" placeholder="ระบุชื่อแผนปฏิบัติงานหลัก" class="w-full" />
                </div> 
            </form> 
            <template #footer>
                <Button :label="newPlan.id ? 'บันทึกการแก้ไข' : 'บันทึกแผน'" icon="pi pi-save" class="p-button-success" @click="savePlan" />
                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger" @click="closePlanDialog" />
            </template>
        </Dialog> 
        
        <Dialog v-model:visible="showTaskDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top" class="p-dialog-lg">
            <template #header>
                <div class="flex justify-between items-center w-full">
                    <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                        <i :class="[newTask.id ? 'pi pi-pencil' : 'pi pi-calendar-check', 'mr-2', 'text-primary-500']"></i>
                        {{ newTask.id ? 'แก้ไขภาระงานประจำวัน' : 'บันทึกภาระงานประจำวัน' }}
                    </h5>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <div class="text-right text-sm text-gray-600">
                        <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }} <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                    </div>
                </div>
            </template>
            <form @submit.prevent="saveDailyTask" class="p-fluid grid form-layout">
                <div class="field col-12 md:col-4">
                    <label for="selected_plan_for_task" class="font-semibold text-color-secondary">แผนปฏิบัติงาน<span class="text-red-500">*</span></label>
                    <Dropdown id="selected_plan_for_task" v-model="newTask.planId" :options="planOptions" optionLabel="label" optionValue="value" placeholder="เลือกแผนปฎิบัติงาน" class="w-full" required />
                </div>
                <div class="field col-12 md:col-4">
                    <label for="evaluation_round_task" class="font-semibold text-color-secondary">รอบประเมิน <span class="text-red-500">*</span></label>
                    <Dropdown id="evaluation_round_task" v-model="newTask.evaluationRound" :options="evaluationRounds" optionLabel="label" optionValue="value" placeholder="เลือกรอบประเมิน" class="w-full" required />
                </div>
                <div class="field col-12 md:col-4">
                    <label for="task_date" class="font-semibold text-color-secondary"> วันที่ลงบันทึก <span class="text-red-500">*</span> </label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar id="task_date" v-model="newTask.recordDate" dateFormat="dd/mm/yy" placeholder="วัน/เดือน/ปี" showIcon class="w-full" required showTime hourFormat="24" />
                    </InputGroup>
                </div>

                <div class="field col-12 md:col-4">
                    <label for="end_date_task" class="font-semibold text-color-secondary">วันที่กำหนดเสร็จ <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar id="end_date_task" v-model="newTask.dueDate" dateFormat="dd/mm/yy" placeholder="วัน/เดือน/ปี" showIcon class="w-full" required  showTime hourFormat="24"/>
                    </InputGroup>
                </div>
                <div class="field col-12 md:col-4">
                    <label for="acomp_date_task" class="font-semibold text-color-secondary">วันที่เสร็จจริง</label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar id="acomp_date_task" v-model="newTask.completionDate" dateFormat="dd/mm/yy" placeholder="วัน/เดือน/ปี" showIcon class="w-full"  showTime hourFormat="24"/>
                    </InputGroup>
                </div>
                <div class="field col-12 md:col-4">
                    <label for="status_task" class="font-semibold text-color-secondary">สถานะ <span class="text-red-500">*</span></label>
                    <Dropdown
                        id="status_task"
                        v-model="newTask.status"
                        :options="[
                            { label: 'รอดำเนินการ', value: 'pending' },
                            { label: 'อยู่ระหว่างดำเนินการ', value: 'in_progress' },
                            { label: 'เสร็จสิ้น', value: 'completed' },
                            { label: 'ยกเลิก', value: 'cancelled' }
                        ]"
                        optionLabel="label"
                        optionValue="value"
                        placeholder="เลือกสถานะ"
                        class="w-full"
                        required
                    />
                </div>

                <div class="field col-12 md:col-6">
                    <label for="file_upload_task" class="font-semibold text-color-secondary">ไฟล์เอกสาร <span class="text-red-500 text-xs">(ถ้ามี)</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-paperclip"></i></InputGroupAddon>
                        <input id="file_upload_task" type="file" @change="onFileChange" class="w-full border-1 surface-border border-round p-2" ref="fileInputRef" />
                    </InputGroup>
                    <small v-if="newTask.fileName && !newTask.selectedFile" class="text-600 ml-2 mt-1">ไฟล์เดิม: {{ newTask.fileName }}</small>
                </div>

                <div class="field col-12 md:col-6">
                    <label for="document_link_task" class="font-semibold text-color-secondary">ลิงก์เอกสาร <span class="text-red-500 text-xs">(ถ้ามี)</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-link"></i></InputGroupAddon>
                        <InputText id="document_link_task" v-model="newTask.documentLink" type="text" placeholder="วางลิงก์เอกสาร เช่น https://..." autocomplete="off" />
                    </InputGroup>
                </div>
                <div class="field col-12">
                    <label for="daily_task_description" class="font-semibold text-color-secondary">ภาระงานประจำวัน <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-pencil"></i></InputGroupAddon>
                        <Textarea id="daily_task_description" v-model="newTask.description" rows="3" placeholder="ระบุภาระงานประจำวัน..." autoResize class="w-full" required />
                    </InputGroup>
                </div>
            </form>
            <template #footer>
                <Button :label="newTask.id ? 'บันทึกการแก้ไข' : 'บันทึก'" icon="pi pi-check" class="p-button-success p-button-sm mr-2 font-semibold" @click="saveDailyTask" />
                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-sm font-semibold" @click="closeTaskDialog" />
            </template>
        </Dialog>

        <Dialog v-model:visible="showTaskDetailDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top" class="p-dialog-md">
            <template #header>
                <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center"><i class="pi pi-info-circle mr-2 text-primary-500"></i> รายละเอียดภาระงาน</h5>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <div class="text-right text-sm text-gray-600">
                    <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }} <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                </div>
            </template>
            <div class="p-fluid grid form-detail-layout" v-if="selectedTaskDetail">
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">แผนปฏิบัติงาน:</strong> {{ getPlanLabelById(selectedTaskDetail.plan_id) }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">รอบประเมิน:</strong> <Tag :value="selectedTaskDetail.evaluation_round" class="p-tag-info font-medium"></Tag></p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">วันที่ลงบันทึก:</strong> {{ selectedTaskDetail.record_date_display }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">วันที่กำหนดเสร็จ:</strong> {{ selectedTaskDetail.due_date_display }}</p>
                </div> 
                <div class="col-12 md:col-4">
                    <p class="detail-item"> <strong class="label-text">วันที่เสร็จจริง:</strong> {{ selectedTaskDetail.completion_date_display || 'ยังไม่ระบุ' }} </p>
                </div>

                <div class="col-12 md:col-4">
                    <p class="detail-item">
                        <strong class="label-text">ใช้เวลาทั้งหมด:</strong>&nbsp;
                        <span v-if="selectedTaskDetail.total_time_display">
                            {{ selectedTaskDetail.total_time_display }}
                        </span>
                        <span v-else class="text-500">ยังไม่เสร็จสิ้น/ไม่ระบุเวลา</span>
                    </p>
                </div>
                <div class="col-12">
                    <p class="detail-item"><strong class="label-text">ภาระงาน:</strong> {{ selectedTaskDetail.description }}</p>
                    
                </div>

                <div class="col-12 md:col-6">
                    <p class="detail-item">
                        <strong class="label-text">ไฟล์เอกสาร:</strong>
                        <span v-if="selectedTaskDetail.file_name">
                            <a :href="getFileUrl(selectedTaskDetail.file_path)" target="_blank" class="p-button p-component p-button-link p-button-sm flex items-center">
                                <i class="pi pi-file-arrow-down mr-1"></i> {{ selectedTaskDetail.file_name }}
                            </a>
                        </span>
                        <span v-else class="text-500">ไม่มีไฟล์</span>
                    </p>
                </div>
                <div class="col-12 md:col-6">
                    <p class="detail-item">
                        <strong class="label-text">ลิงก์เอกสาร:</strong>
                        <a v-if="selectedTaskDetail.document_link" :href="selectedTaskDetail.document_link" target="_blank" class="p-button p-component p-button-link p-button-sm flex items-center">
                            <i class="pi pi-external-link mr-1"></i> เปิดลิงก์
                        </a>
                        <span v-else class="text-500">ไม่มีลิงก์</span>
                    </p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">ผู้บันทึก:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item">
                        <strong class="label-text">สถานะ:</strong> &nbsp;
                        <Tag :value="getStatusLabel(selectedTaskDetail.status)" :severity="getStatusSeverity(selectedTaskDetail.status)" class="p-tag-rounded p-tag-sm font-bold" />
                    </p>
                </div>
            </div>
            <template #footer>
                <Button label="ปิด" icon="pi pi-times" class="p-button-warning p-button-sm font-semibold" @click="showTaskDetailDialog = false" />
            </template>
        </Dialog>
    </div>
</template>

<script setup>
    import { ref, reactive, computed, onMounted, watch, nextTick } from 'vue';
    import { useAuth } from '#imports';
    import axios from 'axios';
    import Swal from 'sweetalert2';
    import { useConfirm } from 'primevue/useconfirm';
    import { useToast } from 'primevue/usetoast';
    import Tag from 'primevue/tag';
    import Divider from 'primevue/divider';
    import Dialog from 'primevue/dialog';
    import InputText from 'primevue/inputtext';
    import Calendar from 'primevue/calendar';
    import Button from 'primevue/button';
    import DataTable from 'primevue/datatable';
    import Column from 'primevue/column';
    import Dropdown from 'primevue/dropdown';
    import InputGroup from 'primevue/inputgroup';
    import InputGroupAddon from 'primevue/inputgroupaddon';
    import Textarea from 'primevue/textarea';
    import Menu from 'primevue/menu';
    import ConfirmDialog from 'primevue/confirmdialog';
    import InputNumber from 'primevue/inputnumber';
    import RadioButton from 'primevue/radiobutton'; 

    const { getSession } = useAuth();
    const user = ref(null);
    const confirm = useConfirm();
    const toast = useToast();
    const showPlanDialog = ref(false);
    const showTaskDialog = ref(false);
    const showTaskDetailDialog = ref(false);
    const plans = ref([]);
    const dailyTasks = ref([]); 
    const selectedPlanId = ref(null);
    const editPlanDialog = ref(false);
    const editPlanForm = ref({
    id: null,
    plan_name: '',
    description: '',
    start_date: '',
    end_date: ''
});

 
    const taskMenuItems = ref([]);
    const optionsMenu = ref(null);  
    const editRow = (task) => {
        editTask(task);
    };


    const newPlan = reactive({
        id: null,
        evaluationRound: null,
        startDate: null,
        endDate: null,
        planLabel: '',
        planItems: []
    });
    const newPlanItem = reactive({
        id: null,
        order: null,
        name: ''
    });
    const editingPlanItemId = ref(null);
    const newTask = ref({
        id: null,
        planId: null,
        evaluationRound: null,
        recordDate: null,
        dueDate: null,
        completionDate: null,
        description: '',
        status: 'pending',
        documentLink: '',
        fileName: '',
        selectedFile: null
    });
    const selectedTaskDetail = ref(null); 
    const deletePlanOption = ref('delete_all');
    const fileInputRef = ref(null);
    let planItemCounter = 0;
    const evaluationRounds = ref([
        { label: 'รอบที่ 1', value: 1 },
        { label: 'รอบที่ 2', value: 2 }
    ]);
    const planOptions = computed(() => {
        return Array.isArray(plans.value)
            ? plans.value.map((plan) => ({
                label: getPlanLabelById(plan.action_id) || '',
                value: plan.action_id,
                startDate: plan.action_startdate,
                endDate: plan.action_enddate
            }))
            : [];
    });

    const filteredDailyTasks = computed(() => {
        if (!selectedPlanId.value) {
            return [];
        }
        return dailyTasks.value.filter((task) => Number(task.planId) === Number(selectedPlanId.value));  
    });
    

    onMounted(async () => {
        user.value = await getSession();
        if (user.value?.user) {
            console.log('✅ User session loaded.');
            await fetchPlans();
            await fetchDailyTasks();
        } else {
            console.log('⚠️ User session not found.');
        }
    });

    watch(selectedPlanId, (newVal) => {
        if (newVal) {
            newTask.value.planId = newVal;
        }
    });

    const fetchPlans = async () => {
        try {
            const staffId = user.value?.user?.name?.STAFFID?.toString() || '';
            const facId = user.value?.user?.name?.SCOPES?.staffdepartment?.toString() || '';

            if (!staffId || !facId) {
                console.error('Staff ID or Faculty ID is missing. Cannot fetch plans.');
                return;
            }
            const response = await axios.post('http://127.0.0.1:8000/api/getDataplans', {
                staffid: staffId,
                facid: facId
            });

            if (response.data && response.data.plans) {
                plans.value = response.data.plans.map((plan) => ({
                    ...plan,
                    action_startdate: plan.action_startdate ? new Date(plan.action_startdate) : null,
                    action_enddate: plan.action_enddate ? new Date(plan.action_enddate) : null
                }));
            } else {
                console.error('Invalid data structure for plans:', response.data);
                plans.value = [];
            }
            if (!selectedPlanId.value && plans.value.length > 0) {
                selectedPlanId.value = plans.value[0].action_id;
            }
        } catch (error) {
            console.error('Error fetching plans:', error);
            Swal.fire('ข้อผิดพลาด!', 'ไม่สามารถโหลดแผนปฏิบัติงานได้', 'error');
        }
    };

    const fetchDailyTasks = async () => {
        try {
            const response = await axios.get('http://127.0.0.1:8000/api/dailytasks');
            dailyTasks.value = response.data.map((task) => {
                const completionDate = task.completion_date && task.completion_date !== '0000-00-00 00:00:00' ? new Date(task.completion_date) : null;
                return {
                    ...task,
                    planId: task.plan_id,
                    evaluationRound: task.evaluation_round,
                    recordDate: task.record_date ? new Date(task.record_date) : null,
                    dueDate: task.due_date ? new Date(task.due_date) : null,
                    completionDate: completionDate,
                    totalTimeDisplay: calculateTimeDifference(task.due_date, completionDate),
                    status: task.status,
                    fileName: task.file_name || null,
                    filePath: task.file_path || null,
                    documentLink: task.document_link || null
                };
            });
        } catch (error) {
            console.error('Error fetching daily tasks:', error);
            Swal.fire('ข้อผิดพลาด!', 'ไม่สามารถโหลดภาระงานประจำวันได้', 'error');
        }
    };

    const openPlanDialog = (planId = null) => {
        // รีเซ็ตฟอร์มก่อนเปิด
        Object.assign(newPlan, {
            id: null,
            evaluationRound: null,
            startDate: null,
            endDate: null,
            planItems: []
        });
        Object.assign(newPlanItem, {
            id: null,
            order: null,
            name: ''
        });
        editingPlanItemId.value = null;
        planItemCounter = 0;

        if (planId) {
            const planToEdit = plans.value.find((p) => p.action_id === planId);
            if (planToEdit) {
                Object.assign(newPlan, {
                    id: planToEdit.action_id,
                    evaluationRound: planToEdit.actionevaluation_round,
                    startDate: planToEdit.action_startdate,
                    endDate: planToEdit.action_enddate,
                    planItems: JSON.parse(planToEdit.actionplan_label || '[]')
                });
            }
        }
        showPlanDialog.value = true;
    };

    const closePlanDialog = () => {
        showPlanDialog.value = false;
    };

    const openTaskDialog = async (taskData = null) => {
        // รีเซ็ตค่าเริ่มต้น
        Object.assign(newTask.value, {
            id: null,
            planId: selectedPlanId.value, // ใส่ตามระบบคุณ
            evaluationRound: null,
            recordDate: new Date(), // ✅ วันที่ปัจจุบัน
            dueDate: null,
            completionDate: new Date(),
            description: '',
            status: 'pending',
            documentLink: '',
            fileName: '',
            selectedFile: null
        });

        // กรณีเป็น edit
        if (taskData) {
            Object.assign(newTask.value, {
                id: taskData.id,
                planId: taskData.planId,
                evaluationRound: taskData.evaluationRound,
                recordDate: taskData.recordDate ? new Date(taskData.recordDate) : new Date(),
                dueDate: taskData.dueDate ? new Date(taskData.dueDate) : null,
                completionDate: taskData.completionDate ? new Date(taskData.completionDate) : null,
                description: taskData.description,
                documentLink: taskData.document_link,
                fileName: taskData.file_name,
                selectedFile: null,
                status: taskData.status
            });
        }

        await nextTick(); // ✅ ให้ Vue เตรียม DOM ก่อนเปิด Dialog
        showTaskDialog.value = true;
    };

    // const closeTaskDialog = () => {
    //     showTaskDialog.value = false;
    //     // ล้างค่าฟอร์มเมื่อปิด
    //     resetNewTask();
    // };

    const resetNewTask = () => {
        newTask.value = {
            id: null,
            planId: selectedPlanId.value,
            evaluationRound: null,
            recordDate: new Date(),
            dueDate: null,
            completionDate: null,
            description: '',
            status: 'pending',
            documentLink: '',
            fileName: '',
            selectedFile: null
        };
    };

    // const viewTaskDetails = (task) => {
    //     selectedTaskDetail.value = task;
    //     showTaskDetailDialog.value = true;
    // };

  const formatDateTime = (date) => {
        if (!date || date === '0000-00-00 00:00:00') return '-';
        const [y, m, d, h, i, s] = date.split(/[- :]/); 
        const localDate = new Date(y, m - 1, d, h, i, s); // ✅ month - 1 เพราะ month ใน JS เริ่มที่ 0
        return localDate.toLocaleString('th-TH', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
    };

    const calculateDuration = (start, end) => {
        if (!start || !end || end === '0000-00-00 00:00:00') return null;
        const startDate = new Date(start);
        const endDate = new Date(end);
        const diffMs = endDate.getTime() - startDate.getTime();

        const days = Math.floor(diffMs / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60));

        return `${days} วัน ${hours} ชั่วโมง ${minutes} นาที`;
    };

    const viewTaskDetails = (task) => {
        selectedTaskDetail.value = {
            ...task,
            record_date_display: formatDateTime(task.record_date),
            due_date_display: formatDateTime(task.due_date),
            completion_date_display: formatDateTime(task.completion_date),
            total_time_display: calculateDuration(task.record_date, task.completion_date)
        };
        showTaskDetailDialog.value = true;
    };






    const editTask = (task) => {
        openTaskDialog(task);
    };

    const confirmDeleteTask = (taskId) => {
        Swal.fire({
            title: 'คุณแน่ใจหรือไม่?',
            text: 'คุณต้องการลบภาระงานนี้ใช่หรือไม่?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33', // สีแดง
            cancelButtonColor: '#3085d6', // สีน้ำเงิน
            confirmButtonText: 'ลบ',
            cancelButtonText: 'ยกเลิก'
        }).then(async (result) => {
            if (result.isConfirmed) {
                try {
                    await axios.post(`http://127.0.0.1:8000/api/delDailyTask`, { id: taskId });
                    Swal.fire('สำเร็จ!', 'ลบภาระงานสำเร็จแล้ว', 'success');
                    fetchDailyTasks();
                } catch (error) {
                    console.error('Error deleting daily task:', error);
                    Swal.fire('ผิดพลาด!', 'ไม่สามารถลบภาระงานได้', 'error');
                }
            }
        });
    }; 
// หลังปิด Dialog หรือเมนู ให้รีเซ็ตค่ากลับเป็น array เปล่า
    const closeTaskDialog = () => {
        showTaskDialog.value = false;
        taskMenuItems.value = []; // ล้างทุกครั้ง
        resetNewTask();
    };
    const addPlanItemToList = () => {
        if (!newPlanItem.name.trim() || !newPlanItem.order) {
            Swal.fire('ข้อมูลไม่ครบถ้วน', 'กรุณาระบุลำดับและชื่อแผนย่อย', 'warning');
            return;
        }
        if (editingPlanItemId.value) {
            const index = newPlan.planItems.findIndex((item) => item.id === editingPlanItemId.value);
            if (index !== -1) {
                newPlan.planItems[index] = { ...newPlanItem };
            }
            editingPlanItemId.value = null;
        } else {
            planItemCounter++;
            newPlan.planItems.push({ ...newPlanItem, id: planItemCounter });
        }
        newPlan.planItems.sort((a, b) => a.order - b.order);
        Object.assign(newPlanItem, { id: null, order: null, name: '' });
    };

    const editPlanItem = (item) => {
        Object.assign(newPlanItem, { ...item });
        editingPlanItemId.value = item.id;
        newPlan.planItems = newPlan.planItems.filter((i) => i.id !== item.id);
    };

    const deletePlanItem = (id) => {
        newPlan.planItems = newPlan.planItems.filter((item) => item.id !== id);
        toast.add({ severity: 'success', summary: 'สำเร็จ', detail: 'ลบแผนย่อยเรียบร้อยแล้ว', life: 1500 });
    };

    const onFileChange = (event) => {
        const file = event.target.files[0];
        if (file) {
            newTask.value.selectedFile = file;
            newTask.value.fileName = file.name;
        } else {
            newTask.value.selectedFile = null;
            if (!newTask.value.id) {
                newTask.value.fileName = '';
            }
        }
    };

    //เปิด Dialog แก้ไขแผน
    const openEditPlanDialog = async (planId) => {
        try {
            const staffId = user.value?.user?.name?.STAFFID?.toString() || '';
            const facId = user.value?.user?.name?.SCOPES?.staffdepartment?.toString() || '';

            if (!staffId || !facId) {
                Swal.fire('ไม่พบข้อมูลผู้ใช้', 'กรุณาเข้าสู่ระบบใหม่อีกครั้ง', 'error');
                return;
            }

            // เรียก API ที่คุณมี
            const { data } = await axios.post('http://127.0.0.1:8000/api/getDataplans', {
                staffid: staffId,
                facid: facId
            });

            const plan = data.plans.find(p => p.action_id === planId);
            if (!plan) {
                Swal.fire('ไม่พบข้อมูลแผน', 'กรุณาลองใหม่อีกครั้ง', 'error');
                return;
            }

            // ใส่ค่าลงใน newPlan
            newPlan.id = plan.action_id;
             newPlan.evaluationRound = Number(plan.actionevaluation_round);
            newPlan.startDate = new Date(plan.action_startdate);
            newPlan.endDate = new Date(plan.action_enddate);
            newPlan.planLabel = plan.actionplan_label; 
            newPlan.planItems = [];  
            // เปิด Dialog
            showPlanDialog.value = true;

        } catch (error) {
            console.error("Error loading plan:", error);
            Swal.fire('ผิดพลาด', 'ไม่สามารถโหลดข้อมูลแผนได้', 'error');
        }
    };


    const confirmDeletePlan = async (planId) => {
        const result = await Swal.fire({
            title: 'ยืนยันการลบ',
            text: 'คุณแน่ใจหรือไม่ว่าต้องการลบแผนปฏิบัติงานนี้และภาระงานทั้งหมดที่เกี่ยวข้อง?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'ลบ',
            cancelButtonText: 'ยกเลิก'
        });

        if (result.isConfirmed) {
            try {
                await axios.delete(`http://127.0.0.1:8000/api/deleteDataplan/${planId}`);
                await fetchPlans();
                await fetchDailyTasks();
                selectedPlanId.value = null;

                Swal.fire({
                    icon: 'success',
                    title: 'สำเร็จ!',
                    text: 'ลบแผนและภาระงานเรียบร้อยแล้ว',
                    timer: 2000,
                    showConfirmButton: false
                });
            } catch (error) {
                console.error('Error deleting plan:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ผิดพลาด',
                    text: 'ไม่สามารถลบแผนได้'
                });
            }
        }
    };

    const savePlan = async () => {
    // ✅ จุดที่ 1: ตรวจสอบว่ามีรายการแผนย่อย (planItems) หรือไม่
    //    ถ้า Array ของ planItems ว่างเปล่า หรือไม่มีเลย จะแสดงข้อความนี้
    // if (!newPlan.planItems || newPlan.planItems.length === 0) {
    //     Swal.fire('ข้อมูลไม่ครบถ้วน', 'กรุณาเพิ่มรายการแผนปฏิบัติงานอย่างน้อย 1 รายการ', 'warning');
    //     return; // หยุดการทำงานของฟังก์ชันทันที
    // }

    // ✅ จุดที่ 2: ตรวจสอบความถูกต้องของข้อมูลพื้นฐาน
    if (!newPlan.evaluationRound || !newPlan.startDate || !newPlan.endDate) {
        Swal.fire('ข้อมูลไม่ครบถ้วน', 'กรุณากรอกข้อมูลให้ครบถ้วน', 'warning');
        return;
    }
    if (newPlan.startDate > newPlan.endDate) {
        Swal.fire('วันที่ไม่ถูกต้อง', 'วันที่เริ่มต้นต้องไม่เกินวันที่สิ้นสุด', 'warning');
        return;
    }
    if (!user.value?.user?.name?.STAFFID || !user.value?.user?.name?.SCOPES?.staffdepartment) {
        Swal.fire('ไม่พบข้อมูลผู้ใช้', 'กรุณาเข้าสู่ระบบใหม่อีกครั้ง', 'error');
        return;
    }

    const formData = new FormData();

    // ✅ 3. ส่ง action_id ถ้าเป็นโหมดแก้ไข
    if (newPlan.id) {
        formData.append('action_id', newPlan.id);
    }

    // ✅ 4. แก้ไขชื่อ key ให้ตรงกับ Backend
    formData.append('evaluation_round', newPlan.evaluationRound);
    formData.append('action_startdate', newPlan.startDate.toISOString().split('T')[0]);
    formData.append('action_enddate', newPlan.endDate.toISOString().split('T')[0]);
    formData.append('actionplan_label', newPlan.planLabel);

    // ✅ 5. วนลูปเพิ่ม planItems (โค้ดส่วนนี้ถูกต้องแล้ว)
    // newPlan.planItems.forEach((item, index) => {
    //     if (item.id) {
    //         formData.append(`planItems[${index}][id]`, item.id);
    //     }
    //     formData.append(`planItems[${index}][order]`, item.order);
    //     formData.append(`planItems[${index}][name]`, item.name);
    // });

    formData.append('staffid', user.value.user.name.STAFFID.toString());
    formData.append('facid', user.value.user.name.SCOPES.staffdepartment.toString());

    try {
        await axios.post('http://127.0.0.1:8000/api/saveDataplan', formData);

        Swal.fire('สำเร็จ!', 'บันทึกข้อมูลเรียบร้อยแล้ว', 'success');
        closePlanDialog();
        fetchPlans();
    } catch (error) {
        console.error('Error saving plan:', error);
        const errorMessage = error.response?.data?.message || 'ไม่สามารถบันทึกข้อมูลได้';
        Swal.fire('ข้อผิดพลาด', errorMessage, 'error');
    }
};




    const saveDailyTask = async () => {
        if (!newTask.value.planId || !newTask.value.evaluationRound || !newTask.value.dueDate || !newTask.value.description) {
            Swal.fire('ข้อมูลไม่ครบถ้วน', 'กรุณากรอกข้อมูลภาระงานประจำวันให้ครบถ้วน', 'warning');
            return;
        }

        if (newTask.value.dueDate < newTask.value.recordDate) {
            Swal.fire('วันที่ไม่ถูกต้อง', 'วันที่กำหนดเสร็จต้องไม่ก่อนวันที่ลงบันทึก', 'warning');
            return;
        }

        const payload = {
            id: newTask.value.id || null, // สำหรับ update
            plan_id: newTask.value.planId,
            evaluation_round: newTask.value.evaluationRound,
            staff_id: user.value.user.name.STAFFID.toString(),
            fac_id: user.value.user.name.SCOPES.staffdepartment.toString(), 
            task_date: toLocalDatetimeString(newTask.value.recordDate),
            record_date: toLocalDatetimeString(newTask.value.recordDate),
            due_date: toLocalDatetimeString(newTask.value.dueDate),
            completion_date: toLocalDatetimeString(newTask.value.completionDate), 
            description: newTask.value.description,
            status: newTask.value.status, 
            document_link: newTask.value.documentLink || null
        };

        const formData = new FormData();
        Object.keys(payload).forEach((key) => {
            if (payload[key] !== null && payload[key] !== undefined) {
                formData.append(key, payload[key]);
            }
        });

        if (newTask.value.selectedFile) {
            formData.append('file', newTask.value.selectedFile);
        }

        try {
            await axios.post(
                'http://127.0.0.1:8000/api/saveDailyTask', // ใช้ endpoint เดียว
                formData,
                { headers: { 'Content-Type': 'multipart/form-data' } }
            );

            Swal.fire('สำเร็จ!', 'บันทึกภาระงานประจำวันเรียบร้อยแล้ว', 'success');
            closeTaskDialog();
            fetchDailyTasks();
        } catch (error) {
            console.error('Error saving daily task:', error);
            Swal.fire('ข้อผิดพลาด!', 'ไม่สามารถบันทึกภาระงานประจำวันได้', 'error');
        }
    };

    const toLocalDatetimeString = (date) => {
    if (!date) return null;
    const offsetDate = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
    return offsetDate.toISOString().slice(0, 19); // "YYYY-MM-DDTHH:mm:ss"
    };

    const formatDate = (date) => {
        if (!date || isNaN(date)) {
            return '';
        }
        return new Intl.DateTimeFormat('th-TH', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        }).format(date);
    };

    const getPlanLabelById = (planId) => {
        const plan = plans.value.find((p) => p.action_id === planId);
        if (plan && plan.actionplan_label) {
            try {
                const planItems = JSON.parse(plan.actionplan_label);
                if (Array.isArray(planItems)) {
                    return planItems.map((item) => `${item.order}. ${item.name}`).join(' | ');
                }
            } catch {
                return plan.actionplan_label || '';
            }
        }
        return 'ไม่พบแผน';
    };

    const getPlanDateRange = (planId) => {
        const plan = plans.value.find((p) => p.action_id === planId);
        if (plan && plan.action_startdate && plan.action_enddate) {
            const start = formatDate(plan.action_startdate);
            const end = formatDate(plan.action_enddate);
            return `${start} - ${end}`;
        }
        return '';
    };

    const getFileUrl = (filePath) => {
        if (filePath) {
            return `http://127.0.0.1:8000/${filePath}`;
        }
        return '#';
    };

    const getStatusLabel = (status) => {
        switch (status) {
            case 'pending':
                return 'รอดำเนินการ';
            case 'in_progress':
                return 'อยู่ระหว่างดำเนินการ';
            case 'completed':
                return 'เสร็จสิ้น';
            case 'late':
                return 'ล่าช้า';
            case 'cancelled':
                return 'ยกเลิก';
            default:
                return 'ไม่ระบุ';
        }
    };

    const getStatusSeverity = (status) => {
        switch (status) {
            case 'pending':
                return 'warning';
            case 'in_progress':
                return 'info';
            case 'completed':
                return 'success';
            case 'late':
                return 'danger';
            case 'cancelled':
                return 'secondary';
            default:
                return null;
        }
    };

    const calculateTimeDifference = (dueDate, completionDate) => {
        if (!dueDate || !completionDate) {
            return null;
        }

        const due = new Date(dueDate);
        const completion = new Date(completionDate);

        if (isNaN(due) || isNaN(completion)) {
            return null;
        }

        const diffMilliseconds = completion.getTime() - due.getTime();
        const diffDays = Math.ceil(diffMilliseconds / (1000 * 60 * 60 * 24));

        if (diffDays > 0) {
            return `ช้ากว่ากำหนด ${diffDays} วัน`;
        } else if (diffDays < 0) {
            return `เร็วกว่ากำหนด ${Math.abs(diffDays)} วัน`;
        } else {
            return 'ตรงตามกำหนด';
        }
    };
</script>


<style scoped>
body {
    font-family: 'Inter', sans-serif;
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
.min-h-screen {
    background-color: var(--surface-a);
}
.card {
    background-color: var(--surface-card);
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.05), 0 4px 6px rgba(0, 0, 0, 0.05);
    border: 1px solid var(--surface-border);
}
h1 {
    font-size: 2.5rem;
    color: var(--primary-color-text);
    line-height: 1.2;
}
h2 {
    font-size: 1.8rem;
    color: var(--text-color);
    margin-bottom: 1.5rem;
    padding-bottom: 0.5rem;
    border-bottom: none;
}
h5 {
    font-size: 1.6rem;
    color: var(--primary-color-text);
}
.p-button {
    font-weight: 600;
    border-radius: 8px;
    transition: all 0.2s ease-in-out;
}
.p-button.p-button-sm {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
}
.p-button.p-button-sm .p-button-icon {
    font-size: 0.9rem;
}

.p-button-outlined {
    background-color: transparent;
    border-width: 2px;
}

.p-button-warning {
    background-color: var(--orange-500);
    border-color: var(--orange-500);
    color: var(--primary-color-text);
}
.p-button-warning:hover {
    background-color: var(--orange-600);
    border-color: var(--orange-600);
}

.p-button-info {
    background-color: var(--blue-500);
    border-color: var(--blue-500);
    color: var(--primary-color-text);
}
.p-button-info:hover {
    background-color: var(--blue-600);
    border-color: var(--blue-600);
}
.p-button-primary {
    background-color: var(--primary-color);
    border-color: var(--primary-color);
    color: var(--primary-color-text);
}
.p-button-primary:hover {
    background-color: var(--primary-500);
    border-color: var(--primary-500);
}
.p-button-text.p-button-info {
    color: var(--blue-500);
}
.p-button-text.p-button-info:hover {
    background-color: var(--blue-50);
}
.p-button-text.p-button-danger {
    color: var(--red-500);
}
.p-button-text.p-button-danger:hover {
    background-color: var(--red-50);
}
.p-button-text.p-button-success {
    color: var(--green-500);
}
.p-button-text.p-button-success:hover {
    background-color: var(--green-50);
}
.p-button-text.p-button-secondary {
    color: var(--text-color-secondary);
}
.p-button-text.p-button-secondary:hover {
    background-color: var(--surface-hover);
}

.p-button-text.p-button-sm {
    padding: 0.3rem 0.6rem;
    font-size: 0.8rem;
}

.form-layout .field {
    margin-bottom: 1.5rem;
}
.form-layout label {
    display: block;
    margin-bottom: 0.6rem;
    font-size: 0.9rem;
    color: var(--text-color-secondary);
    font-weight: 600;
}
.p-inputgroup > .p-inputtext,
.p-inputgroup > .p-calendar,
.p-inputgroup > .p-dropdown,
.p-inputgroup > .p-textarea,
.p-inputtext.p-inputtext-sm {
    border-radius: var(--border-radius);
    padding: 0.75rem 0.875rem;
}
.p-inputtext.p-inputtext-sm {
    padding: 0.6rem 0.75rem;
    font-size: 0.9rem;
}
input[type='file'] {
    cursor: pointer;
    background-color: var(--surface-input);
    color: var(--text-color);
    border: 1px solid var(--surface-border);
    border-radius: var(--border-radius);
    padding: 0.75rem 0.875rem;
    transition: all 0.2s;
    font-size: 1rem;
    box-shadow: var(--form-element-shadow);
}
input[type='file']:hover {
    border-color: var(--primary-color);
}
input[type='file']::file-selector-button {
    background-color: var(--primary-color);
    color: var(--primary-color-text);
    border: none;
    padding: 0.5rem 1rem;
    margin-right: 1rem;
    border-radius: var(--border-radius);
    cursor: pointer;
    transition: all 0.2s;
}
input[type='file']::file-selector-button:hover {
    background-color: var(--primary-color-hover);
}

.p-datatable-gridlines .p-datatable-tbody > tr > td {
    border: 1px solid var(--surface-border);
    padding: 0.7rem 1rem;
    font-size: 0.9rem;
}
.p-datatable-gridlines .p-datatable-thead > tr > th {
    background-color: var(--surface-hover);
    color: var(--text-color);
    font-weight: 700;
    padding: 0.7rem 1rem;
    border: 1px solid var(--surface-border);
}
.p-datatable-gridlines {
    border: 1px solid var(--surface-border);
    border-radius: var(--border-radius);
    overflow: hidden;
}
.p-datatable .p-paginator {
    background-color: var(--surface-a);
    border-top: 1px solid var(--surface-border);
}
.p-tag {
    font-size: 0.8rem;
    padding: 0.3em 0.6em;
}
.p-tag-sm {
    font-size: 0.75rem;
    padding: 0.25em 0.5em;
}
.form-detail-layout .detail-item {
    margin-bottom: 0.8rem;
    line-height: 1.5;
    font-size: 1rem;
    color: var(--text-color);
}
.form-detail-layout .label-text {
    font-weight: 700;
    color: var(--text-color-secondary);
    display: inline-block;
    width: 120px;
    flex-shrink: 0;
}
.form-detail-layout p {
    display: flex;
    align-items: baseline;
}
.form-detail-layout p span {
    flex-grow: 1;
}
.p-button-link {
    padding: 0;
    font-weight: 500;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
}
.p-button-link:hover {
    text-decoration: underline;
}
.p-divider.p-divider-horizontal:before {
    border-top: 1px solid var(--surface-d);
}
@media screen and (max-width: 768px) {
    .p-4 {
        padding: 1rem;
    }
    .p-6 {
        padding: 1.5rem;
    }
    h1 {
        font-size: 1.8rem;
    }
    h2 {
        font-size: 1.5rem;
    }
    h5 {
        font-size: 1.3rem;
    }
    .p-button {
        padding: 0.6rem 0.9rem;
        font-size: 0.9rem;
    }
    .p-datatable-gridlines .p-datatable-tbody > tr > td,
    .p-datatable-gridlines .p-datatable-thead > tr > th {
        padding: 0.6rem 0.8rem;
        font-size: 0.85rem;
    }
    .p-dialog-lg,
    .p-dialog-md {
        width: 90vw !important;
    }
    .form-detail-layout .label-text {
        width: 100%;
        margin-bottom: 0.2rem;
        display: block;
    }
    .form-detail-layout p {
        flex-direction: column;
        align-items: flex-start;
    }
}
</style>