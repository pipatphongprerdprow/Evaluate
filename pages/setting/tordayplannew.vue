<template>
    <div class="p-4 bg-gray-100 min-h-screen font-sans">
        <ConfirmDialog></ConfirmDialog>
        <Toast />

        <div class="flex flex-col sm:flex-row justify-between items-center mb-8 gap-4">
            <div class="flex flex-col items-start">
                <h4 class="text-4xl font-extrabold text-primary-800 flex items-center mb-1">
                    <i class="pi pi-chart-line mr-3 text-primary-500"></i>
                    บันทึกแผนงาน/โครงการ/ภาระงาน
                </h4> 
            </div> 
        </div>
        
        <div class="card p-6 shadow-2xl rounded-xl surface-card">
            
            <div class="flex justify-between items-center mb-6">
                <div class="flex items-center">
                    <i class="pi pi-sitemap mr-3 text-primary-500 text-2xl"></i>
                    <h4 class="text-2xl font-bold text-700 m-0">โครงสร้างแผนงานและภาระงาน</h4>
                </div> 
            </div>
             <div class="flex justify-end mb-4">
                <Button icon="pi pi-plus" label="สร้างแผนงาน/โครงการใหม่" class="p-button p-button-info px-4 py-2 rounded-lg font-semibold shadow hover:shadow-lg transition duration-200" @click="openPlanDialog" />
            </div>
            <DataTable 
                :value="allPlans" 
                v-model:expandedRows="expandedPlans" 
                dataKey="id" 
                responsiveLayout="scroll"
                stripedRows
                :class="{'p-datatable-gridlines': allPlans.length > 0}">
                <Column expander style="width: 3rem" />
                <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width: 12rem" class="font-bold text-primary-800">
                    <template #body="slotProps">
                        <span class="p-column-title">ชื่อแผนงาน</span>
                        <div class="flex flex-col items-start">
                            <div class="flex items-center">
                                <i class="pi pi-briefcase mr-2 text-primary-600 text-lg"></i>
                                {{ slotProps.data.planLabel }}
                            </div>
                            <small class="text-gray-500 mt-1">
                                <i class="pi pi-calendar mr-1 text-xs"></i>
                                {{ formatDate(slotProps.data.startDate) }} - {{ formatDate(slotProps.data.endDate) }}
                            </small>
                        </div>
                    </template>
                </Column>
                <Column header="ผู้รับผิดชอบหลัก" style="min-width: 10rem">
                    <template #body="slotProps">
                        <span class="p-column-title">ผู้รับผิดชอบหลัก</span>
                        <span v-if="slotProps.data.owner && slotProps.data.owner.length">
                             {{ slotProps.data.owner.map(o => o.name).join(', ') }}
                        </span>
                        <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                    </template>
                </Column>
                <Column header="ความคืบหน้า" style="min-width: 12rem">
                    <template #body="slotProps">
                        <span class="p-column-title">ความคืบหน้า</span>
                        <div class="flex items-center">
                            <span class="mr-2 text-sm text-primary-600 font-bold">{{ getPlanProgress(slotProps.data) }}%</span>
                            <ProgressBar :value="getPlanProgress(slotProps.data)" class="flex-1" />
                        </div>
                    </template>
                </Column>
                <Column header="สถานะ" style="min-width: 8rem">
                    <template #body="slotProps">
                        <span class="p-column-title">สถานะ</span>
                        <Tag :value="getPlanStatusLabel(slotProps.data)" :severity="getPlanStatusSeverity(slotProps.data)" class="font-bold" />
                    </template>
                </Column>
                <Column header="จัดการ" style="width: 8rem" class="text-center">
                    <template #body="slotProps">
                        <span class="p-column-title">จัดการ</span>
                        <div class="flex gap-1 justify-center">
                            <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="editPlan(slotProps.data)" v-tooltip.top="'แก้ไข'" />
                            <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmDeletePlan(slotProps.data.id)" v-tooltip.top="'ลบ'" />
                        </div>
                    </template>
                </Column>

                <template #expansion="slotProps">
                    <div class="p-4 bg-gray-50 border-round-xl ml-4">
                        <div class="text-xl font-bold text-700 flex items-center mb-3">
                            <i class="pi pi-list mr-2 text-primary-500"></i>
                            ขั้นตอนการทำงาน
                        </div>
                        <DataTable 
                            :value="slotProps.data.steps" 
                            v-model:expandedRows="expandedSteps" 
                            dataKey="name" 
                            responsiveLayout="scroll"
                        >
                            <Column expander style="width: 3rem" />
                            <Column field="name" header="ชื่อขั้นตอน" style="min-width: 12rem" class="font-semibold text-700">
                                <template #body="stepProps">
                                    <span class="p-column-title">ชื่อขั้นตอน</span>
                                    {{ stepProps.data.name }}
                                </template>
                            </Column>
                             <Column header="ผู้รับผิดชอบ" style="min-width: 12rem">
                                <template #body>
                                     <span class="p-column-title">ผู้รับผิดชอบ</span>
                                     <span v-if="slotProps.data.owner && slotProps.data.owner.length">
                                         {{ slotProps.data.owner.map(o => o.name).join(', ') }}
                                     </span>
                                     <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                                 </template>
                             </Column>
                            <Column header="ความคืบหน้า" style="min-width: 12rem">
                                <template #body="stepProps">
                                    <span class="p-column-title">ความคืบหน้า</span>
                                    <div class="flex items-center">
                                        <span class="mr-2 text-sm text-primary-600 font-bold">{{ getStepProgress(stepProps.data) }}%</span>
                                        <ProgressBar :value="getStepProgress(stepProps.data)" class="flex-1" />
                                    </div>
                                </template>
                            </Column>
                            <Column header="สถานะ" style="min-width: 8rem">
                                <template #body="stepProps">
                                    <span class="p-column-title">สถานะ</span>
                                    <Tag :value="getStepStatus(stepProps.data)" :severity="getStepSeverity(stepProps.data)" class="font-bold" />
                                </template>
                            </Column>

                            <template #expansion="stepProps">
                                <div class="p-4 bg-gray-100 border-round-xl ml-4">
                                    <div class="text-lg font-bold text-700 flex items-center mb-3">
                                        <i class="pi pi-calendar-check mr-2 text-primary-500"></i>
                                        ภาระงานประจำวัน
                                    </div>
                                    <DataTable :value="stepProps.data.tasks" responsiveLayout="scroll">
                                        <Column field="description" header="ภาระงาน" style="min-width: 15rem" />
                                        <Column header="ผู้รับผิดชอบ" style="width: 12rem">
                                            <template #body>
                                                <span v-if="slotProps.data.owner && slotProps.data.owner.length">
                                                    {{ slotProps.data.owner.map(o => o.name).join(', ') }}
                                                </span>
                                                <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                                            </template>
                                        </Column>
                                        <Column header="กำหนดเสร็จ" style="width: 10rem">
                                            <template #body="taskProps">
                                                <Tag :value="formatDate(taskProps.data.dueDate)" :severity="getTaskDueDateSeverity(taskProps.data.dueDate)" />
                                            </template>
                                        </Column>
                                        <Column header="เวลาที่ใช้ไป" style="width: 10rem">
                                            <template #body="taskProps">
                                                <span>{{ getTaskTimeSpent(taskProps.data) }}</span>
                                            </template>
                                        </Column>
                                        <Column header="สถานะ" style="width: 10rem">
                                            <template #body="taskProps">
                                                <Dropdown
                                                    v-model="taskProps.data.status"
                                                    :options="taskStatuses"
                                                    class="w-full"
                                                    :class="getTaskStatusSeverityByValue(taskProps.data.status) + '-tag-dropdown'"
                                                />
                                            </template>
                                        </Column>
                                        <Column header="จัดการ" style="width: 8rem" class="text-center">
                                             <template #body="taskProps">
                                                 <div class="flex gap-1 justify-center">
                                                     <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditTaskDialogInTable(stepProps.data, taskProps.data, taskProps.index)" v-tooltip.top="'แก้ไขภาระงาน'" />
                                                     <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmRemoveTaskInTable(stepProps.data, taskProps.index)" v-tooltip.top="'ลบภาระงาน'" />
                                                 </div>
                                             </template>
                                         </Column>
                                    </DataTable>
                                </div>
                            </template>
                        </DataTable>
                    </div>
                </template>
            </DataTable>
            
            <div v-if="allPlans.length === 0" class="flex flex-col items-center justify-center p-12 bg-white rounded-lg shadow-inner-lg mt-4">
                <i class="pi pi-inbox text-8xl text-gray-400 mb-6"></i>
                <p class="text-gray-500 text-xl font-medium mb-4">ยังไม่มีแผนงานที่ถูกสร้าง</p>
                <p class="text-gray-400 text-md max-w-sm text-center">เริ่มต้นการทำงานของคุณด้วยการสร้างแผนงานใหม่ เพื่อจัดระเบียบและติดตามความคืบหน้า</p> 
            </div>
        </div>

        <Dialog v-model:visible="showPlanDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '80vw' }" modal position="top">
            <template #header>
                <div class="flex items-center w-full">
                    <i class="pi pi-calendar-plus mr-3 text-primary-500 text-3xl"></i>
                    <h5 class="m-0 text-2xl font-bold text-primary-700">{{ isEditMode ? 'แก้ไขแผนงาน/โครงการ' : 'สร้างแผนงาน/โครงการใหม่' }}</h5>
                    <span class="text-xl text-gray-400 font-normal ml-auto">({{ activeTabIndex + 1 }}/3)</span>
                </div>
            </template>
            
            <div v-if="activeTabIndex === 0">
                <h3 class="text-xl font-bold text-700 flex items-center mb-4">
                    <i class="pi pi-file mr-2 text-primary-500"></i>
                    ข้อมูลแผนงาน / โครงการ
                </h3>
                <div class="p-fluid grid form-layout">
                    <div class="field col-12">
                        <label class="font-semibold text-lg">ชื่อแผนปฏิบัติงาน <span class="text-red-500">*</span></label>
                        <InputText v-model="currentPlan.planLabel" placeholder="ระบุชื่อแผนปฏิบัติงาน" required />
                    </div>
                    <div class="field col-12">
                        <label class="font-semibold text-lg">ผู้รับผิดชอบหลัก <span class="text-red-500">*</span></label>
                        <MultiSelect v-model="currentPlan.owner" :options="owners" optionLabel="name" placeholder="เลือกผู้รับผิดชอบหลัก" display="chip" required />
                    </div>
                    <div class="field col-12 md:col-6">
                        <label class="font-semibold text-lg">วันที่เริ่มต้น <span class="text-red-500">*</span></label>
                        <Calendar v-model="currentPlan.startDate" dateFormat="dd/mm/yy" showIcon required />
                    </div>
                    <div class="field col-12 md:col-6">
                        <label class="font-semibold text-lg">วันที่สิ้นสุด <span class="text-red-500">*</span></label>
                        <Calendar v-model="currentPlan.endDate" dateFormat="dd/mm/yy" showIcon required />
                    </div>
                </div>
            </div>

            <div v-if="activeTabIndex === 1">
                <h3 class="text-xl font-bold text-700 flex items-center mb-4">
                    <i class="pi pi-list mr-2 text-primary-500"></i>
                    2. กำหนดขั้นตอนการทำงาน
                </h3>
                <div class="flex flex-col sm:flex-row items-stretch gap-2 mb-4">
                      <InputText v-model="newStepName" placeholder="เพิ่มชื่อขั้นตอนใหม่..." class="w-full sm:w-72" />
                    <Button icon="pi pi-plus" label="เพิ่ม" @click="addStep" :disabled="!newStepName" />
                </div>
                <div class="p-4 bg-gray-100 rounded-lg max-h-80 overflow-y-auto custom-scroll">
                    <ul v-if="currentPlan.steps.length" class="list-none p-0 m-0">
                        <li v-for="(step, index) in currentPlan.steps" :key="index" class="p-3 mb-2 bg-white shadow-sm rounded-md">
                            <div class="flex items-center justify-between gap-2 mb-2">
                                <span class="text-lg font-medium text-primary-700 flex-grow">
                                    {{ index + 1 }}. {{ step.name }}
                                </span>
                                <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-rounded" @click="openEditStepDialog(step, index)" v-tooltip.top="'แก้ไข'" />
                                <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-rounded" @click="confirmRemoveStep(index)" v-tooltip.top="'ลบ'" />
                            </div>
                        </li>
                    </ul>
                    <div v-else class="text-center text-gray-500 p-4 border-dashed border-2 border-gray-300 rounded-lg">
                        <p>ยังไม่มีการเพิ่มขั้นตอน</p>
                    </div>
                </div>
            </div>
            
            <div v-if="activeTabIndex === 2">
                <h3 class="text-xl font-bold text-700 flex items-center mb-4">
                    <i class="pi pi-calendar-check mr-2 text-primary-500"></i>
                    3. บันทึกภาระงานประจำวัน
                </h3>
                <div class="p-fluid grid form-layout">
                    <div class="field col-12">
                        <label class="font-semibold">เลือกขั้นตอน <span class="text-red-500">*</span></label>
                        <Dropdown v-model="newTask.step" :options="currentPlan.steps" optionLabel="name" placeholder="เลือกขั้นตอน" />
                    </div>
                    <div class="field col-12">
                        <label class="font-semibold">ภาระงานประจำวัน <span class="text-red-500">*</span></label>
                        <Textarea v-model="newTask.description" rows="3" placeholder="ระบุภาระงาน..." autoResize />
                    </div>
                    <div class="field col-12 md:col-6">
                        <label class="font-semibold">เวลาเริ่มต้น</label>
                        <Calendar v-model="newTask.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น" />
                    </div>
                    <div class="field col-12 md:col-6">
                        <label class="font-semibold">เวลาสิ้นสุด</label>
                        <Calendar v-model="newTask.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด" />
                    </div>
                    <div class="field col-12">
                        <label class="font-semibold">วันที่กำหนดเสร็จ <span class="text-red-500">*</span></label>
                        <Calendar v-model="newTask.dueDate" dateFormat="dd/mm/yy" showIcon />
                    </div>
                </div>
                <div class="flex justify-end gap-2 mt-4">
                    <Button label="เพิ่มภาระงาน" icon="pi pi-plus" class="p-button-info p-button-sm" @click="addTaskToStep" :disabled="!isTaskFormValid" />
                </div>
                <Divider class="my-6" />
                <h4 class="text-lg font-bold text-700 flex items-center mb-2">
                    <i class="pi pi-table mr-2 text-primary-500"></i>
                    ภาระงานที่เพิ่มแล้ว
                </h4>
                <div class="max-h-60 overflow-y-auto custom-scroll">
                    <div v-for="(step, index) in currentPlan.steps" :key="index" class="mb-3 p-3 bg-gray-100 rounded-lg">
                        <div class="font-bold text-lg text-primary-800 mb-2">{{ index + 1 }}. {{ step.name }}</div>
                        <ul class="list-none p-0 m-0">
                            <li v-for="(task, taskIndex) in step.tasks" :key="taskIndex" class="flex items-center p-2 mb-1 bg-white shadow-sm rounded-md">
                                <span class="text-sm flex-grow">
                                    <span class="font-medium">{{ task.description }}</span>
                                    <span class="text-gray-500 block sm:inline"> 
                                        (ผู้รับผิดชอบ: 
                                        <span v-if="currentPlan.owner && currentPlan.owner.length">
                                             {{ currentPlan.owner.map(o => o.name).join(', ') }}
                                         </span>
                                        <span v-else>ยังไม่กำหนด</span>
                                        , กำหนดเสร็จ: {{ formatDate(task.dueDate) }})
                                    </span>
                                </span>
                                <div class="flex gap-1 ml-2">
                                    <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditTaskDialog(step, task, taskIndex)" v-tooltip.top="'แก้ไข'" />
                                    <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmRemoveTask(step, taskIndex)" v-tooltip.top="'ลบภาระงาน'" />
                                </div>
                            </li>
                        </ul>
                        <div v-if="step.tasks.length === 0" class="text-center text-gray-400 text-sm py-2">
                            ไม่มีภาระงานในขั้นตอนนี้
                        </div>
                    </div>
                </div>
            </div>

            <template #footer>
                <div class="flex justify-between w-full pt-4">
                    <Button v-if="activeTabIndex > 0" label="ย้อนกลับ" icon="pi pi-angle-left" class="p-button-secondary p-button-text" @click="goToPrevStep" />
                    <Button v-else label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-text" @click="showPlanDialog = false" />
                    
                    <div class="flex-grow"></div>
                    
                    <Button v-if="activeTabIndex < 2" label="ถัดไป" icon="pi pi-angle-right" iconPos="right" class="p-button-warning" @click="goToNextStep" />
                    <Button v-else label="บันทึก" icon="pi pi-save" class="p-button-success" @click="savePlan" :disabled="!isFinalStepValid" />
                </div>
            </template>
        </Dialog>
        
        <Dialog v-model:visible="showEditStepDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '40vw' }" modal>
            <template #header>
                <div class="flex items-center w-full">
                    <i class="pi pi-pencil mr-2 text-primary-500 text-2xl"></i>
                    <h5 class="m-0 text-xl font-bold text-primary-700">แก้ไขขั้นตอน</h5>
                </div>
            </template>
            <div class="p-fluid">
                <div class="field">
                    <label class="font-semibold">ชื่อขั้นตอน</label>
                    <InputText v-model="currentEditingStep.name" />
                </div>
            </div>
            <template #footer>
                <div class="flex justify-end gap-2 pt-4">
                    <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditStepDialog = false" />
                    <Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedStep" />
                </div>
            </template>
        </Dialog>

        <Dialog v-model:visible="showEditTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '40vw' }" modal>
            <template #header>
                <div class="flex items-center w-full">
                    <i class="pi pi-pencil mr-2 text-primary-500 text-2xl"></i>
                    <h5 class="m-0 text-xl font-bold text-primary-700">แก้ไขภาระงาน</h5>
                </div>
            </template>
            <div class="p-fluid">
                <div class="field">
                    <label class="font-semibold">ภาระงาน</label>
                    <Textarea v-model="currentEditingTask.description" rows="3" autoResize />
                </div>
                <div class="field mt-4">
                    <label class="font-semibold">วันที่กำหนดเสร็จ</label>
                    <Calendar v-model="currentEditingTask.dueDate" dateFormat="dd/mm/yy" showIcon />
                </div>
                <div class="field mt-4">
                    <label class="font-semibold">เวลาเริ่มต้น</label>
                    <Calendar v-model="currentEditingTask.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น" />
                </div>
                <div class="field mt-4">
                    <label class="font-semibold">เวลาสิ้นสุด</label>
                    <Calendar v-model="currentEditingTask.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด" />
                </div>
            </div>
            <template #footer>
                <div class="flex justify-end gap-2 pt-4">
                    <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditTaskDialog = false" />
                    <Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedTask" />
                </div>
            </template>
        </Dialog>
    </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue';
import Swal from 'sweetalert2';
import { useConfirm } from 'primevue/useconfirm';
import { useToast } from 'primevue/usetoast';

// Component Imports
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Tag from 'primevue/tag';
import ProgressBar from 'primevue/progressbar';
import InputText from 'primevue/inputtext';
import Dropdown from 'primevue/dropdown';
import MultiSelect from 'primevue/multiselect';
import Calendar from 'primevue/calendar';
import Divider from 'primevue/divider';
import Textarea from 'primevue/textarea';
import ConfirmDialog from 'primevue/confirmdialog';
import Toast from 'primevue/toast';
import Tooltip from 'primevue/tooltip';

// Directives
const vTooltip = Tooltip;

// Data and State Management
const allPlans = ref([]);
const owners = ref([
    { name: 'สมชาย รักดี', code: 'smc' },
    { name: 'สมหญิง มีสุข', code: 'smy' },
    { name: 'สุทธิชัย มั่นคง', code: 'scm' },
    { name: 'จันทรา เพ็ญ', code: 'jtp' },
]);
const taskStatuses = ref(['รอดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น']);

const confirm = useConfirm();
const toast = useToast();
const showPlanDialog = ref(false);
const isEditMode = ref(false);
const currentPlan = reactive({ id: null, planLabel: '', owner: [], startDate: null, endDate: null, steps: [] });
const newStepName = ref('');
const newTask = reactive({ step: null, description: '', dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });
const expandedPlans = ref([]);
const expandedSteps = ref([]);
const activeTabIndex = ref(0);

// Edit State for Steps and Tasks
const showEditStepDialog = ref(false);
const currentEditingStep = reactive({ name: '', index: null });
const showEditTaskDialog = ref(false);
const currentEditingTask = reactive({ description: '', dueDate: null, startTime: null, endTime: null, status: '', stepIndex: null, taskIndex: null });

// Functions for Data and UI Management
const openPlanDialog = () => {
    isEditMode.value = false;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    Object.assign(currentPlan, { id: Date.now(), planLabel: '', owner: [], startDate: null, endDate: null, steps: [] });
    newStepName.value = '';
    Object.assign(newTask, { step: null, description: '', dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });
};
const editPlan = (plan) => {
    isEditMode.value = true;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    Object.assign(currentPlan, { ...plan });
    currentPlan.steps = JSON.parse(JSON.stringify(plan.steps));
    Object.assign(newTask, { step: null, description: '', dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });
};
const addStep = () => {
    if (newStepName.value) {
        currentPlan.steps.push({ name: newStepName.value, responsible: currentPlan.owner, tasks: [] });
        newStepName.value = '';
    }
};
const confirmRemoveStep = (index) => {
    confirm.require({
        message: `คุณแน่ใจหรือไม่ว่าต้องการลบขั้นตอน "${currentPlan.steps[index].name}"?`,
        header: 'ยืนยันการลบขั้นตอน',
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            currentPlan.steps.splice(index, 1);
            toast.add({ severity: 'success', summary: 'ลบสำเร็จ', detail: 'ลบขั้นตอนเรียบร้อยแล้ว', life: 3000 });
        },
    });
};
const openEditStepDialog = (step, index) => {
    Object.assign(currentEditingStep, { name: step.name, index });
    showEditStepDialog.value = true;
};
const saveEditedStep = () => {
    const { index, name } = currentEditingStep;
    currentPlan.steps[index].name = name;
    showEditStepDialog.value = false;
    toast.add({ severity: 'success', summary: 'แก้ไขสำเร็จ', detail: 'แก้ไขขั้นตอนเรียบร้อยแล้ว', life: 3000 });
};

const addTaskToStep = () => {
    if (isTaskFormValid.value) {
        const step = currentPlan.steps.find(s => s.name === newTask.step.name);
        if (step) {
            step.tasks.push({ 
                description: newTask.description,
                responsible: currentPlan.owner, // Assign owner as responsible
                dueDate: newTask.dueDate,
                startTime: newTask.startTime,
                endTime: newTask.endTime,
                status: 'รอดำเนินการ'
            });
            toast.add({ severity: 'success', summary: 'เพิ่มภาระงานสำเร็จ', detail: 'เพิ่มภาระงานเรียบร้อยแล้ว', life: 3000 });
        }
        Object.assign(newTask, { step: null, description: '', dueDate: null, startTime: null, endTime: null });
    }
};
const confirmRemoveTaskInTable = (step, taskIndex) => {
    confirm.require({
        message: `คุณแน่ใจหรือไม่ว่าต้องการลบภาระงานนี้?`,
        header: 'ยืนยันการลบภาระงาน',
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            const stepIndex = currentPlan.steps.indexOf(step);
            currentPlan.steps[stepIndex].tasks.splice(taskIndex, 1);
            toast.add({ severity: 'success', summary: 'ลบสำเร็จ', detail: 'ลบภาระงานเรียบร้อยแล้ว', life: 3000 });
        },
    });
};
const openEditTaskDialogInTable = (step, task, taskIndex) => {
    const stepIndex = currentPlan.steps.indexOf(step);
    Object.assign(currentEditingTask, { ...task, stepIndex, taskIndex });
    showEditTaskDialog.value = true;
};
const saveEditedTask = () => {
    const { stepIndex, taskIndex, description, dueDate, startTime, endTime } = currentEditingTask;
    Object.assign(currentPlan.steps[stepIndex].tasks[taskIndex], { description, dueDate, startTime, endTime });
    showEditTaskDialog.value = false;
    toast.add({ severity: 'success', summary: 'แก้ไขสำเร็จ', detail: 'แก้ไขภาระงานเรียบร้อยแล้ว', life: 3000 });
};
const openEditTaskDialog = (step, task, taskIndex) => {
    const stepIndex = currentPlan.steps.indexOf(step);
    Object.assign(currentEditingTask, { ...task, stepIndex, taskIndex });
    showEditTaskDialog.value = true;
};
const confirmRemoveTask = (step, taskIndex) => {
    confirm.require({
        message: `คุณแน่ใจหรือไม่ว่าต้องการลบภาระงานนี้?`,
        header: 'ยืนยันการลบภาระงาน',
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            const stepIndex = currentPlan.steps.indexOf(step);
            currentPlan.steps[stepIndex].tasks.splice(taskIndex, 1);
            toast.add({ severity: 'success', summary: 'ลบสำเร็จ', detail: 'ลบภาระงานเรียบร้อยแล้ว', life: 3000 });
        },
    });
};

const goToNextStep = () => {
    if (activeTabIndex.value === 0) {
        if (!isFirstStepValid.value) {
            Swal.fire('ข้อผิดพลาด', 'กรุณาระบุข้อมูลในส่วนข้อมูลแผนงานให้ครบถ้วน', 'warning');
            return;
        }
    }
    if (activeTabIndex.value === 1) {
        if (!isSecondStepValid.value) {
             Swal.fire('ข้อผิดพลาด', 'กรุณาเพิ่มขั้นตอนการทำงานอย่างน้อยหนึ่งขั้นตอน', 'warning');
            return;
        }
    }
    activeTabIndex.value++;
};
const goToPrevStep = () => {
    if (activeTabIndex.value > 0) {
        activeTabIndex.value--;
    }
};
const savePlan = () => {
    if (!isFinalStepValid.value) {
        Swal.fire('ข้อผิดพลาด', 'กรุณาเพิ่มภาระงานในทุกขั้นตอนก่อนบันทึก', 'warning');
        return;
    }
    
    if (isEditMode.value) {
        const index = allPlans.value.findIndex(p => p.id === currentPlan.id);
        if (index !== -1) {
            allPlans.value[index] = { ...currentPlan };
        }
        Swal.fire('แก้ไขสำเร็จ', 'อัปเดตแผนงานเรียบร้อยแล้ว', 'success');
    } else {
        allPlans.value.push({ ...currentPlan });
        Swal.fire('สำเร็จ!', 'บันทึกแผนงานเรียบร้อยแล้ว', 'success');
    }
    showPlanDialog.value = false;
};
const confirmDeletePlan = (id) => {
    confirm.require({
        message: 'คุณแน่ใจหรือไม่ว่าต้องการลบแผนงานนี้?',
        header: 'ยืนยันการลบ',
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            allPlans.value = allPlans.value.filter(p => p.id !== id);
            toast.add({ severity: 'success', summary: 'ลบสำเร็จ', detail: 'ลบแผนงานเรียบร้อยแล้ว', life: 3000 });
        },
    });
};

const isFirstStepValid = computed(() => {
    return !!currentPlan.planLabel && currentPlan.owner.length > 0 && !!currentPlan.startDate && !!currentPlan.endDate;
});
const isSecondStepValid = computed(() => {
    return currentPlan.steps.length > 0;
});
const isFinalStepValid = computed(() => {
    return currentPlan.steps.every(step => step.tasks.length > 0);
});
const isTaskFormValid = computed(() => {
    return !!newTask.step && !!newTask.description && !!newTask.dueDate;
});

// Utility Functions for Status and Progress
const getPlanStatusLabel = (plan) => {
    const now = new Date();
    if (plan.steps.every(step => step.tasks.every(task => task.status === 'เสร็จสิ้น'))) {
        return 'เสร็จสิ้น';
    }
    if (now > new Date(plan.endDate)) {
        return 'เกินกำหนด';
    }
    if (plan.steps.some(step => step.tasks.some(task => task.status === 'อยู่ระหว่างดำเนินการ'))) {
        return 'กำลังดำเนินการ';
    }
    if (plan.steps.some(step => step.tasks.length > 0)) {
        return 'เริ่มแล้ว';
    }
    return 'รอดำเนินการ';
};
const getPlanStatusSeverity = (plan) => {
    const label = getPlanStatusLabel(plan);
    switch (label) {
        case 'เสร็จสิ้น': return 'success';
        case 'เกินกำหนด': return 'danger';
        case 'กำลังดำเนินการ': return 'info';
        case 'เริ่มแล้ว': return 'warning';
        default: return 'secondary';
    }
};
const getPlanProgress = (plan) => {
    const totalTasks = plan.steps.reduce((sum, step) => sum + step.tasks.length, 0);
    if (totalTasks === 0) return 0;
    const completedTasks = plan.steps.reduce((sum, step) => sum + step.tasks.filter(task => task.status === 'เสร็จสิ้น').length, 0);
    return Math.round((completedTasks / totalTasks) * 100);
};
const getStepStatus = (step) => {
    if (step.tasks.every(task => task.status === 'เสร็จสิ้น')) {
        return 'เสร็จสิ้น';
    } else if (step.tasks.some(task => task.status === 'อยู่ระหว่างดำเนินการ')) {
        return 'กำลังดำเนินการ';
    } else if (step.tasks.length > 0) {
        return 'รอดำเนินการ';
    }
    return 'ยังไม่เริ่ม';
};
const getStepSeverity = (step) => {
    const status = getStepStatus(step);
    switch (status) {
        case 'เสร็จสิ้น': return 'success';
        case 'กำลังดำเนินการ': return 'info';
        case 'รอดำเนินการ': return 'warning';
        default: return 'secondary';
    }
};
const getStepProgress = (step) => {
    const totalTasks = step.tasks.length;
    if (totalTasks === 0) return 0;
    const completedTasks = step.tasks.filter(task => task.status === 'เสร็จสิ้น').length;
    return Math.round((completedTasks / totalTasks) * 100);
};
const getTaskDueDateSeverity = (date) => {
    const now = new Date();
    if (now > new Date(date)) return 'danger';
    return 'info';
};
const getTaskStatusSeverityByValue = (status) => {
    switch(status) {
        case 'รอดำเนินการ': return 'warning';
        case 'อยู่ระหว่างดำเนินการ': return 'info';
        case 'เสร็จสิ้น': return 'success';
        default: return 'secondary';
    }
};
const getTaskTimeSpent = (task) => {
    if (!task.startTime || !task.endTime) return 'N/A';
    const start = new Date(task.startTime);
    const end = new Date(task.endTime);
    const diffInMilliseconds = end - start;
    if (diffInMilliseconds <= 0) return '0 ชั่วโมง 0 นาที';

    const hours = Math.floor(diffInMilliseconds / (1000 * 60 * 60));
    const minutes = Math.floor((diffInMilliseconds % (1000 * 60 * 60)) / (1000 * 60));
    return `${hours} ชั่วโมง ${minutes} นาที`;
};
const formatDate = (date) => {
    if (!date) return '';
    const d = new Date(date);
    return d.toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: 'numeric' });
};
</script>

<style scoped>
.font-sans {
    font-family: var(--font-family);
}
.shadow-inner-lg {
    box-shadow: inset 0 2px 4px 0 rgba(0, 0, 0, 0.06);
}
/* Style for PrimeVue Data Table */
::v-deep(.p-datatable-thead th) {
    background-color: var(--surface-100);
    color: var(--text-color-secondary);
    font-weight: bold;
}
::v-deep(.p-datatable-tbody > tr > td) {
    vertical-align: top;
}
::v-deep(.p-datatable-gridlines .p-datatable-thead tr) {
    border-bottom: 2px solid var(--surface-200);
}
/* Custom scrollbar for dialogs */
.custom-scroll::-webkit-scrollbar {
    width: 8px;
}
.custom-scroll::-webkit-scrollbar-track {
    background: #f1f1f1;
    border-radius: 4px;
}
.custom-scroll::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 4px;
}
.custom-scroll::-webkit-scrollbar-thumb:hover {
    background: #555;
}

/* Custom style for status dropdown */
.p-dropdown.p-component {
    width: 100%;
}
.warning-tag-dropdown {
    background-color: var(--yellow-100);
    color: var(--yellow-800);
    border: 1px solid var(--yellow-400);
}
.info-tag-dropdown {
    background-color: var(--blue-100);
    color: var(--blue-800);
    border: 1px solid var(--blue-400);
}
.success-tag-dropdown {
    background-color: var(--green-100);
    color: var(--green-800);
    border: 1px solid var(--green-400);
}
.secondary-tag-dropdown {
    background-color: var(--surface-200);
    color: var(--text-color-secondary);
    border: 1px solid var(--surface-300);
}
</style>