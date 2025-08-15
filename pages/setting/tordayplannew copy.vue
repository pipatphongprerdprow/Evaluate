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
            <DataTable :value="allPlans" v-model:expandedRows="expandedPlans" dataKey="id" responsiveLayout="scroll" stripedRows :class="{'p-datatable-gridlines': allPlans.length > 0}">
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
                        <DataTable :value="slotProps.data.steps" v-model:expandedRows="expandedSteps" dataKey="id" responsiveLayout="scroll">
                            <Column expander style="width: 3rem" />
                            <Column field="name" header="ชื่อขั้นตอน" style="min-width: 12rem" class="font-semibold text-700">
                                <template #body="stepProps">
                                    <span class="p-column-title">ชื่อขั้นตอน</span>
                                    <div class="flex items-center">
                                         <i class="pi pi-circle-fill mr-2 text-xs text-blue-500"></i>
                                         {{ stepProps.data.name }}
                                    </div>
                                </template>
                            </Column>
                            <Column header="วันเริ่มต้น" style="min-width: 8rem">
                                <template #body="stepProps">
                                    <span class="p-column-title">วันเริ่มต้น</span>
                                    {{ formatDate(stepProps.data.startDate) }}
                                </template>
                            </Column>
                             <Column header="วันสิ้นสุด" style="min-width: 8rem">
                                <template #body="stepProps">
                                    <span class="p-column-title">วันสิ้นสุด</span>
                                    {{ formatDate(stepProps.data.endDate) }}
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
                            <Column header="จัดการ" style="width: 12rem" class="text-center">
                                <template #body="stepProps">
                                    <div class="flex gap-2 justify-center">
                                        <Button icon="pi pi-plus" label="เพิ่ม" class="p-button-warning p-button-sm px-3 py-1" @click="openAddTaskDialog(stepProps.data, slotProps.data.owner)" v-tooltip.top="'เพิ่มภาระงานประจำวัน'" />
                                        <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditStepDialogInTable(slotProps.data.id, stepProps.data)" v-tooltip.top="'แก้ไขขั้นตอน'" />
                                        <Button  icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmRemoveStepById(slotProps.data.id, stepProps.data.id)" v-tooltip.top="'ลบขั้นตอน'" />
                                    </div>
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
                                            <template #body="taskProps">
                                                <span v-if="taskProps.data.responsible && taskProps.data.responsible.length">
                                                    {{ taskProps.data.responsible.map(o => o.name).join(', ') }}
                                                </span>
                                                <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                                            </template>
                                        </Column>
                                         <Column header="วันที่ลงบันทึก" style="width: 10rem">
                                            <template #body="taskProps">
                                                <span>{{ formatDate(taskProps.data.createdDate) }}</span>
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
                                     <div v-if="stepProps.data.tasks && stepProps.data.tasks.length === 0" class="text-center text-gray-500 text-sm py-4">
                                         ยังไม่มีภาระงานสำหรับขั้นตอนนี้
                                     </div>
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
                    <span class="text-xl text-gray-400 font-normal ml-auto">({{ activeTabIndex + 1 }}/2)</span>
                </div>
            </template>

            <div v-if="activeTabIndex === 0">
                <h3 class="text-xl font-bold text-700 flex items-center mb-4">
                    <i class="pi pi-file mr-2 text-primary-500"></i>
                    1. ข้อมูลแผนงาน / โครงการ
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
                    <InputText v-model="newStepName" placeholder="เพิ่มชื่อขั้นตอนใหม่..." class="w-full" />
                    <Calendar v-model="newStepDates" selectionMode="range" :manualInput="false" placeholder="เลือกวันเริ่มต้น-สิ้นสุด" class="w-full sm:w-80" />
                    <Button icon="pi pi-plus" label="เพิ่ม" @click="addStep" :disabled="!isNewStepValid" class="sm:w-32" />
                </div>
                <div class="p-4 bg-gray-100 rounded-lg max-h-80 overflow-y-auto custom-scroll">
                    <ul v-if="currentPlan.steps.length" class="list-none p-0 m-0">
                        <li v-for="(step, index) in currentPlan.steps" :key="step.id" class="p-3 mb-2 bg-white shadow-sm rounded-md">
                            <div class="flex items-center justify-between gap-2 mb-2">
                                <div class="flex flex-col flex-grow">
                                    <span class="text-lg font-medium text-primary-700">
                                        {{ index + 1 }}. {{ step.name }}
                                    </span>
                                    <small class="text-gray-500 mt-1">
                                        <i class="pi pi-calendar mr-1 text-xs"></i>
                                        {{ formatDate(step.startDate) }} - {{ formatDate(step.endDate) }}
                                    </small>
                                </div>
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

            <template #footer>
                <div class="flex justify-between w-full pt-4">
                    <Button v-if="activeTabIndex > 0" label="ย้อนกลับ" icon="pi pi-angle-left" class="p-button-secondary p-button-text" @click="goToPrevStep" />
                    <Button v-else label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-text" @click="showPlanDialog = false" />

                    <div class="flex-grow"></div>

                    <Button v-if="activeTabIndex < 1" label="ถัดไป" icon="pi pi-angle-right" iconPos="right" class="p-button-warning" @click="goToNextStep" />
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
                <div class="field mt-4">
                    <label class="font-semibold text-lg">ช่วงเวลาของขั้นตอน</label>
                    <Calendar v-model="currentEditingStep.dates" selectionMode="range" :manualInput="false" placeholder="เลือกวันเริ่มต้น-สิ้นสุด" />
                </div>
            </div>
            <template #footer>
                <div class="flex justify-end gap-2 pt-4">
                    <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditStepDialog = false" />
                    <Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedStep" />
                </div>
            </template>
        </Dialog>

        <Dialog v-model:visible="showEditTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '60vw' }" modal>
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
                    <label class="font-semibold">ผู้รับผิดชอบ</label>
                    <MultiSelect v-model="currentEditingTask.responsible" :options="owners" optionLabel="name" placeholder="เลือกผู้รับผิดชอบ" display="chip" />
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

        <Dialog v-model:visible="showAddTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '50vw' }" modal>
            <template #header>
                <div class="flex items-center w-full">
                    <i class="pi pi-plus-circle mr-2 text-primary-500 text-2xl"></i>
                    <h5 class="m-0 text-xl font-bold text-primary-700">เพิ่มภาระงานสำหรับขั้นตอน "{{ currentStepToAddTasks.name }}"</h5>
                </div>
            </template>
            <div class="p-fluid grid form-layout">
                <div class="field col-12">
                    <label class="font-semibold">ภาระงานประจำวัน <span class="text-red-500">*</span></label>
                    <Textarea v-model="newTaskInStep.description" rows="3" placeholder="ระบุภาระงาน..." autoResize />
                </div>
                <div class="field col-12">
                    <label class="font-semibold">ผู้รับผิดชอบ <span class="text-red-500">*</span></label>
                    <MultiSelect v-model="newTaskInStep.responsible" :options="owners" optionLabel="name" placeholder="เลือกผู้รับผิดชอบ" display="chip" required />
                </div>
                <div class="field col-12 md:col-6">
                    <label class="font-semibold">เวลาเริ่มต้น</label>
                    <Calendar v-model="newTaskInStep.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น" />
                </div>
                <div class="field col-12 md:col-6">
                    <label class="font-semibold">เวลาสิ้นสุด</label>
                    <Calendar v-model="newTaskInStep.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด" />
                </div>
                <div class="field col-12">
                    <label class="font-semibold">วันที่กำหนดเสร็จ <span class="text-red-500">*</span></label>
                    <Calendar v-model="newTaskInStep.dueDate" dateFormat="dd/mm/yy" showIcon />
                </div>
            </div>
            <template #footer>
                <div class="flex justify-end gap-2 pt-4">
                    <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showAddTaskDialog = false" />
                    <Button label="บันทึก" icon="pi pi-plus" class="p-button-success" @click="addTaskToStepFromMain" :disabled="!isNewTaskInStepValid" />
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
const newStepDates = ref([]);
const expandedPlans = ref([]);
const expandedSteps = ref([]);
const activeTabIndex = ref(0);

// Edit State for Steps and Tasks
const showEditStepDialog = ref(false);
const currentEditingStep = reactive({ id: null, name: '', dates: [], index: null });
const showEditTaskDialog = ref(false);
const currentEditingTask = reactive({ description: '', responsible: [], dueDate: null, startTime: null, endTime: null, status: '', stepId: null, taskId: null, taskIndex: null, createdDate: null });
// State for adding task from main table
const showAddTaskDialog = ref(false);
const currentStepToAddTasks = reactive({ id: null, name: '' });
const newTaskInStep = reactive({ description: '', responsible: [], dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });

// Computed properties for form validation
const isFirstStepValid = computed(() => {
    return currentPlan.planLabel && currentPlan.owner.length > 0 && currentPlan.startDate && currentPlan.endDate;
});

const isSecondStepValid = computed(() => {
    return currentPlan.steps.length > 0;
});

const isFinalStepValid = computed(() => {
    return isFirstStepValid.value && isSecondStepValid.value;
});

const isNewStepValid = computed(() => {
    return newStepName.value && newStepDates.value && newStepDates.value.length === 2 && newStepDates.value[0] && newStepDates.value[1];
});

const isNewTaskInStepValid = computed(() => {
    return newTaskInStep.description && newTaskInStep.responsible.length > 0 && newTaskInStep.dueDate;
});

// Helper Functions
const formatDate = (date) => {
    if (!date) return '';
    const d = new Date(date);
    const day = d.getDate().toString().padStart(2, '0');
    const month = (d.getMonth() + 1).toString().padStart(2, '0');
    const year = d.getFullYear();
    return `${day}/${month}/${year}`;
};

const getPlanProgress = (plan) => {
    if (!plan.steps || plan.steps.length === 0) return 0;
    const totalTasks = plan.steps.reduce((sum, step) => sum + (step.tasks?.length || 0), 0);
    if (totalTasks === 0) return 0;
    const completedTasks = plan.steps.reduce((sum, step) => sum + (step.tasks?.filter(t => t.status === 'เสร็จสิ้น').length || 0), 0);
    return Math.round((completedTasks / totalTasks) * 100);
};

const getStepProgress = (step) => {
     if (!step.tasks || step.tasks.length === 0) return 0;
    const totalTasks = step.tasks.length;
    const completedTasks = step.tasks.filter(t => t.status === 'เสร็จสิ้น').length;
    return Math.round((completedTasks / totalTasks) * 100);
};

const getPlanStatusLabel = (plan) => {
    const progress = getPlanProgress(plan);
    if (progress === 100) return 'เสร็จสิ้น';
    if (progress > 0) return 'อยู่ระหว่างดำเนินการ';
    return 'รอดำเนินการ';
};

const getPlanStatusSeverity = (plan) => {
    const progress = getPlanProgress(plan);
    if (progress === 100) return 'success';
    if (progress > 0) return 'warning';
    return 'info';
};

const getStepStatus = (step) => {
     const progress = getStepProgress(step);
    if (progress === 100) return 'เสร็จสิ้น';
    if (progress > 0) return 'อยู่ระหว่างดำเนินการ';
    return 'รอดำเนินการ';
};

const getStepSeverity = (step) => {
    const progress = getStepProgress(step);
    if (progress === 100) return 'success';
    if (progress > 0) return 'warning';
    return 'info';
};

const getTaskDueDateSeverity = (dueDate) => {
    if (!dueDate) return 'info';
    const now = new Date();
    const due = new Date(dueDate);
    due.setHours(23, 59, 59, 999); // Set to end of the day for comparison
    if (due < now) return 'danger';
    return 'success';
};

const getTaskTimeSpent = (task) => {
    if (!task.startTime || !task.endTime) return 'ยังไม่ระบุ';
    const start = new Date(task.startTime);
    const end = new Date(task.endTime);
    const diffInMinutes = Math.abs(end - start) / (1000 * 60);
    const hours = Math.floor(diffInMinutes / 60);
    const minutes = Math.round(diffInMinutes % 60);
    return `${hours} ชม. ${minutes} นาที`;
};

const getTaskStatusSeverityByValue = (status) => {
    if (status === 'เสร็จสิ้น') return 'success';
    if (status === 'อยู่ระหว่างดำเนินการ') return 'warning';
    return 'info';
};

// Functions for Data and UI Management
const openPlanDialog = () => {
    isEditMode.value = false;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    Object.assign(currentPlan, { id: Date.now(), planLabel: '', owner: [], startDate: null, endDate: null, steps: [] });
    newStepName.value = '';
    newStepDates.value = [];
};

const editPlan = (plan) => {
    isEditMode.value = true;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    // ใช้ JSON.parse(JSON.stringify()) เพื่อ Deep Copy ข้อมูล
    const clonedPlan = JSON.parse(JSON.stringify(plan));
    // แปลงวันที่กลับเป็น Date object
    clonedPlan.startDate = clonedPlan.startDate ? new Date(clonedPlan.startDate) : null;
    clonedPlan.endDate = clonedPlan.endDate ? new Date(clonedPlan.endDate) : null;
    clonedPlan.steps.forEach(step => {
        step.startDate = step.startDate ? new Date(step.startDate) : null;
        step.endDate = step.endDate ? new Date(step.endDate) : null;
        if (step.tasks) {
            step.tasks.forEach(task => {
                task.dueDate = task.dueDate ? new Date(task.dueDate) : null;
                task.startTime = task.startTime ? new Date(task.startTime) : null;
                task.endTime = task.endTime ? new Date(task.endTime) : null;
                 task.createdDate = task.createdDate ? new Date(task.createdDate) : null;
            });
        }
    });

    Object.assign(currentPlan, clonedPlan);
};

const confirmDeletePlan = (planId) => {
    Swal.fire({
        title: 'ยืนยันการลบ',
        text: 'คุณต้องการลบแผนงานนี้ใช่หรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33', // สีแดงสำหรับปุ่มยืนยันลบ
        cancelButtonColor: '#3085d6', // สีน้ำเงินสำหรับปุ่มยกเลิก
        confirmButtonText: 'ลบ',
        cancelButtonText: 'ยกเลิก'
    }).then((result) => {
        if (result.isConfirmed) {
            // ลบแผนงานออกจากรายการ
            allPlans.value = allPlans.value.filter(plan => plan.id !== planId);

            // แจ้งเตือนสำเร็จ
            Swal.fire({
                icon: 'success',
                title: 'สำเร็จ',
                text: 'ลบแผนงานเรียบร้อยแล้ว',
                timer: 2000,
                showConfirmButton: false
            });
        }
    });
}; 

const goToNextStep = () => {
    if (isFirstStepValid.value) {
        activeTabIndex.value = 1;
    } else {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณากรอกข้อมูลแผนงานให้ครบถ้วน',
            confirmButtonText: 'ตกลง'
        });
    }
};

const goToPrevStep = () => {
    activeTabIndex.value = 0;
};

const savePlan = () => {
    if (!isFinalStepValid.value) {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณาตรวจสอบข้อมูลแผนงานและขั้นตอน',
            confirmButtonText: 'ตกลง'
        });
        return;
    }

    if (isEditMode.value) {
        const index = allPlans.value.findIndex(p => p.id === currentPlan.id);
        if (index !== -1) {
            allPlans.value[index] = { ...currentPlan };
        }
        Swal.fire({
            icon: 'success',
            title: 'สำเร็จ',
            text: 'แก้ไขแผนงานเรียบร้อยแล้ว',
            timer: 2000,
            showConfirmButton: false
        });
    } else {
        allPlans.value.push({ ...currentPlan, id: Date.now() });
        Swal.fire({
            icon: 'success',
            title: 'สำเร็จ',
            text: 'สร้างแผนงานใหม่เรียบร้อยแล้ว',
            timer: 2000,
            showConfirmButton: false
        });
    }

    showPlanDialog.value = false;
};

const addStep = () => {
    if (isNewStepValid.value) {
        currentPlan.steps.push({
            id: Date.now(),
            name: newStepName.value,
            startDate: newStepDates.value[0],
            endDate: newStepDates.value[1],
            tasks: []
        });
        newStepName.value = '';
        newStepDates.value = [];
        Swal.fire({
            icon: 'success',
            title: 'สำเร็จ',
            text: 'เพิ่มขั้นตอนเรียบร้อยแล้ว',
            timer: 2000,
            showConfirmButton: false
        });
    } else {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณาใส่ชื่อขั้นตอนและช่วงเวลาให้ครบถ้วน',
            confirmButtonText: 'ตกลง'
        });
    }
};

const confirmRemoveStep = (index) => {
    Swal.fire({
        title: 'ยืนยันการลบ',
        text: 'คุณต้องการลบขั้นตอนการทำงานนี้ใช่หรือไม่?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'ลบ',
        cancelButtonText: 'ยกเลิก'
    }).then((result) => {
        if (result.isConfirmed) {
            currentPlan.steps.splice(index, 1);
            Swal.fire({
                icon: 'success',
                title: 'สำเร็จ',
                text: 'ลบขั้นตอนเรียบร้อยแล้ว',
                timer: 2000,
                showConfirmButton: false
            });
        }
    });
};


const openEditStepDialog = (step, index) => {
    showEditStepDialog.value = true;
    currentEditingStep.id = step.id;
    currentEditingStep.name = step.name;
    currentEditingStep.dates = [step.startDate, step.endDate];
    currentEditingStep.index = index;
};

const openEditStepDialogInTable = (planId, stepData) => {
    const plan = allPlans.value.find(p => p.id === planId);
    if (!plan) return;

    const stepIndex = plan.steps.findIndex(s => s.id === stepData.id);
    if (stepIndex === -1) return;

    const stepToEdit = plan.steps[stepIndex];
    Object.assign(currentEditingStep, {
        id: stepToEdit.id,
        name: stepToEdit.name,
        dates: [new Date(stepToEdit.startDate), new Date(stepToEdit.endDate)],
        index: stepIndex
    });
    showEditStepDialog.value = true;
};

const saveEditedStep = () => {
    if (!currentEditingStep.name || !currentEditingStep.dates || currentEditingStep.dates.length !== 2) {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณากรอกข้อมูลขั้นตอนให้ครบถ้วน',
            confirmButtonText: 'ตกลง'
        });
        return;
    }
    const index = currentEditingStep.index;
    currentPlan.steps[index].name = currentEditingStep.name;
    currentPlan.steps[index].startDate = currentEditingStep.dates[0];
    currentPlan.steps[index].endDate = currentEditingStep.dates[1];
    showEditStepDialog.value = false;
    Swal.fire({
        icon: 'success',
        title: 'สำเร็จ',
        text: 'แก้ไขขั้นตอนเรียบร้อยแล้ว',
        timer: 2000,
        showConfirmButton: false
    });
};

// Functions for Task Management
const openAddTaskDialog = (stepData, owners) => {
    showAddTaskDialog.value = true;
    Object.assign(currentStepToAddTasks, { id: stepData.id, name: stepData.name });
    Object.assign(newTaskInStep, { description: '', responsible: owners, dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });
};

const addTaskToStepFromMain = () => {
    if (!isNewTaskInStepValid.value) {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณากรอกข้อมูลภาระงานให้ครบถ้วน',
            confirmButtonText: 'ตกลง'
        });
        return;
    }

    const plan = allPlans.value.find(p => p.steps.some(s => s.id === currentStepToAddTasks.id));
    if (plan) {
        const step = plan.steps.find(s => s.id === currentStepToAddTasks.id);
        if (step) {
            if (!step.tasks) {
                step.tasks = [];
            }
            step.tasks.push({
                id: Date.now(),
                description: newTaskInStep.description,
                responsible: newTaskInStep.responsible,
                dueDate: newTaskInStep.dueDate,
                startTime: newTaskInStep.startTime,
                endTime: newTaskInStep.endTime,
                status: newTaskInStep.status,
                createdDate: new Date(),
            });

            showAddTaskDialog.value = false;

            Swal.fire({
                icon: 'success',
                title: 'สำเร็จ',
                text: 'เพิ่มภาระงานเรียบร้อยแล้ว',
                timer: 2000,
                showConfirmButton: false
            });
        }
    }
};
 
const openEditTaskDialogInTable = (step, task, taskIndex) => {
    showEditTaskDialog.value = true;
    currentEditingTask.stepId = step.id;
    currentEditingTask.taskId = task.id;
    currentEditingTask.taskIndex = taskIndex;
    currentEditingTask.description = task.description;
    currentEditingTask.responsible = task.responsible;
    currentEditingTask.dueDate = task.dueDate ? new Date(task.dueDate) : null;
    currentEditingTask.startTime = task.startTime ? new Date(task.startTime) : null;
    currentEditingTask.endTime = task.endTime ? new Date(task.endTime) : null;
    currentEditingTask.status = task.status;
    currentEditingTask.createdDate = task.createdDate ? new Date(task.createdDate) : null;
};

const saveEditedTask = () => {
    if (!currentEditingTask.description || !currentEditingTask.responsible.length || !currentEditingTask.dueDate) {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณากรอกข้อมูลภาระงานให้ครบถ้วน',
            confirmButtonText: 'ตกลง'
        });
        return;
    }

    const planIndex = allPlans.value.findIndex(p => p.steps.some(s => s.id === currentEditingTask.stepId));
    if (planIndex === -1) return;

    const stepIndex = allPlans.value[planIndex].steps.findIndex(s => s.id === currentEditingTask.stepId);
    if (stepIndex === -1) return;

    allPlans.value[planIndex].steps[stepIndex].tasks[currentEditingTask.taskIndex] = {
        id: currentEditingTask.taskId,
        description: currentEditingTask.description,
        responsible: currentEditingTask.responsible,
        dueDate: currentEditingTask.dueDate,
        startTime: currentEditingTask.startTime,
        endTime: currentEditingTask.endTime,
        status: currentEditingTask.status,
        createdDate: currentEditingTask.createdDate,
    };

    showEditTaskDialog.value = false;

    Swal.fire({
        icon: 'success',
        title: 'สำเร็จ',
        text: 'แก้ไขภาระงานเรียบร้อยแล้ว',
        timer: 2000,
        showConfirmButton: false
    });
}; 
const confirmRemoveTaskInTable = (step, taskIndex) => {
    confirm.require({
        message: 'คุณต้องการลบภาระงานนี้ใช่หรือไม่?',
        header: 'ยืนยันการลบ',
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            const plan = allPlans.value.find(p => p.steps.some(s => s.id === step.id));
            if (plan) {
                const stepToUpdate = plan.steps.find(s => s.id === step.id);
                if (stepToUpdate && stepToUpdate.tasks) {
                    stepToUpdate.tasks.splice(taskIndex, 1);
                    Swal.fire({
                        icon: 'success',
                        title: 'สำเร็จ',
                        text: 'ลบภาระงานเรียบร้อยแล้ว',
                        timer: 2000,
                        showConfirmButton: false
                    });
                }
            }
        },
        reject: () => { }
    });
};
const confirmRemoveStepById = (planId, stepId) => {
    Swal.fire({
        title: 'ยืนยันการลบ',
        text: 'คุณต้องการลบขั้นตอนนี้ใช่หรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'ลบ',
        cancelButtonText: 'ยกเลิก',
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
    }).then((result) => {
        if (result.isConfirmed) {
            const plan = allPlans.value.find(p => p.id === planId);
            if (plan) {
                plan.steps = plan.steps.filter(step => step.id !== stepId);
                
                Swal.fire({
                    title: 'สำเร็จ',
                    text: 'ลบขั้นตอนเรียบร้อยแล้ว',
                    icon: 'success',
                    timer: 2000,
                    showConfirmButton: false
                });
            }
        }
    });
};
 
</script>

<style scoped>
.custom-scroll::-webkit-scrollbar {
  width: 6px;
}

.custom-scroll::-webkit-scrollbar-thumb {
  background-color: #d1d5db; 
  border-radius: 3px;
}
</style>