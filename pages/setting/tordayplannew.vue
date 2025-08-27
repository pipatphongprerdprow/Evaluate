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

            <DataTable :value="allPlansSorted" v-model:expandedRows="expandedPlans" dataKey="id" responsiveLayout="scroll" stripedRows > <!-- :class="{'p-datatable-gridlines': allPlans.length > 0}" -->
                <Column expander style="width: 3rem" /> 


                <Column header="ประเภทแผน" style="width: 9rem; min-width: 8rem; text-align:center">
                    <template #body="slotProps">
                        <span class="p-column-title">ประเภทแผน</span>
                        <Tag
                        :value="slotProps.data.planType || 'ไม่ระบุ'"
                        :severity="getPlanTypeSeverity(slotProps.data.planType)"
                        class="font-semibold"
                        />
                    </template>
                </Column>
                <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width: 12rem" >
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
                        {{ slotProps.data.owner.map(o => getOwnerDisplay(o)).join(', ') }}
                        </span>
                        <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                    </template>
                </Column>
                <!-- คืบหน้าแผน -->
                <Column header="ความคืบหน้า" style="min-width: 12rem">
                    <template #body="slotProps">
                        <span class="p-column-title">ความคืบหน้า</span>
                        <div class="flex items-center">
                            <span class="mr-2 text-sm text-primary-600 font-bold">{{ getPlanProgress(slotProps.data) }}%</span>
                            <ProgressBar :value="getPlanProgress(slotProps.data)" class="flex-1" />
                        </div>
                    </template>
                </Column>
                <!-- สิ้นสุดคืบหน้าแผน -->

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

                <template #expansion="planSlot">
                    <div class="p-4 bg-gray-50 border-round-xl ml-4">
                        <div class="text-xl font-bold text-700 flex items-center mb-3">
                            <i class="pi pi-list mr-2 text-primary-500"></i>
                            ขั้นตอน/กิจกรรมการทำงาน
                        </div>
                        <DataTable :value="planSlot.data.steps" v-model:expandedRows="expandedSteps" dataKey="id" responsiveLayout="scroll">
                            <Column expander style="width: 3rem" />
                            <Column field="name" header="ชื่อขั้นตอน/กิจกรรม" style="min-width: 12rem" class="font-semibold text-700">
                                <template #body="stepProps">
                                    <span class="p-column-title">ชื่อขั้นตอน/กิจกรรม</span>
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
                                <template #body="stepProps">
                                    <span v-if="Array.isArray(planSlot.data.owner) && planSlot.data.owner.length">
                                    {{ planSlot.data.owner.map(o => getOwnerDisplay(o)).join(', ') }}
                                    </span>
                                    <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                                </template>
                            </Column>

                            <!-- ความคืบหน้าขั้นตอน --> 
                            <Column header="ความคืบหน้า" style="min-width: 12rem">
                                <template #body="stepProps">
                                    <span class="p-column-title">ความคืบหน้า</span>
                                    <div class="flex items-center">
                                        <span class="mr-2 text-sm text-primary-600 font-bold">{{ getStepProgress(stepProps.data) }}%</span>
                                        <ProgressBar :value="getStepProgress(stepProps.data)" class="flex-1" />
                                    </div>
                                </template>
                            </Column>
                            <!-- สิ้นสุดความคืบหน้าขั้นตอน -->

                            <!-- สถานะขั้นตอน -->
                            <Column header="สถานะ" style="min-width: 9rem" class="text-center">
                                <template #body="stepProps">
                                    <span class="p-column-title">สถานะ</span>
                                    <Dropdown
                                    :modelValue="getStepStatus(stepProps.data)"     
                                    :options="taskStatuses"                        
                                    class="w-full"
                                    :disabled="stepProps.data.__saving === true"
                                    :class="getTaskStatusSeverityByValue(getStepStatus(stepProps.data)) + '-tag-dropdown'"
                                    @update:modelValue="(val) => updateStepStatus(planSlot.data, stepProps.data, val)"
                                    />
                                </template>
                            </Column>
                            <!-- สิ้นสุดสถานะขั้นตอน -->

                            <Column header="จัดการ" style="width: 12rem" class="text-center">
                                <template #body="stepProps">
                                    <div class="flex gap-2 justify-center">
                                    <!-- owner ต้องใช้จาก planSlot -->
                                        <Button 
                                            icon="pi pi-plus" 
                                            label="เพิ่ม" 
                                            class="p-button-warning p-button-sm px-3 py-1" 
                                            @click="openAddTaskDialog(stepProps.data, planSlot.data.owner)" 
                                            v-tooltip.top="'เพิ่มภาระงานประจำวัน'" 
                                        /> 

                                        <Button 
                                            icon="pi pi-pencil" 
                                            class="p-button-text p-button-warning p-button-sm p-button-rounded" 
                                            @click="openEditStepDialogInTable(planSlot.data.id, stepProps.data)" 
                                            v-tooltip.top="'แก้ไขขั้นตอน'" 
                                        />

                                        <Button  
                                            icon="pi pi-trash" 
                                            class="p-button-text p-button-danger p-button-sm p-button-rounded" 
                                            @click="confirmRemoveStepById(planSlot.data.id, stepProps.data.id)" 
                                            v-tooltip.top="'ลบขั้นตอน'" 
                                        />
                                    </div>
                                </template>
                            </Column>
                            <template #expansion="stepProps">
                                <div class="p-4 bg-gray-100 border-round-xl ml-4">
                                    <div class="text-lg font-bold text-700 flex items-center mb-3">
                                        <i class="pi pi-calendar-check mr-2 text-primary-500"></i>
                                        ภาระงานประจำวัน
                                    </div>

                                    <DataTable :value="stepProps.data.tasks" responsiveLayout="scroll" stripedRows :class="{'p-datatable-gridlines': true}"> 
                                        <!-- ประเภทภาระงาน -->
                                        <Column header="ประเภทภาระงาน" style="width: 8rem">
                                            <template #body="taskProps">
                                                <Tag :value="taskProps.data.taskType || 'ไม่ระบุ'"
                                                    :severity="taskProps.data.taskType === 'งานหลัก' ? 'success'
                                                                : taskProps.data.taskType === 'งานตำแหน่งอื่น' ? 'warning'
                                                                : taskProps.data.taskType === 'งานอื่นๆ' ? 'info' : 'secondary'" />
                                            </template>
                                        </Column>  

                                        <!-- ภาระงาน -->
                                        <Column header="ภาระงาน" style="width: 10rem">
                                            <template #body="taskProps">
                                                <Tag v-if="taskProps.data.mainTask" 
                                                    :value="getMainTaskLabel(taskProps.data.mainTask)" 
                                                    severity="info" />
                                                <span v-else class="text-gray-400">ยังไม่เลือก</span>
                                            </template>
                                        </Column>

                                        <!-- ภาระงานประจำวัน (หลัก → กินพื้นที่เยอะสุด) -->
                                        <Column field="description" header="ภาระงานประจำวัน" style="flex: 1; min-width: 18rem" /> 

                                        <!-- วันที่ลงบันทึก -->
                                        <Column header="วันที่ลงบันทึก" style="width: 7.5rem" class="text-center">
                                            <template #body="taskProps">
                                                <span>{{ formatDate(taskProps.data.createdDate) }}</span>
                                            </template>
                                        </Column> 

                                        <!-- เวลาที่ใช้ไป -->
                                        <Column header="เวลาที่ใช้ไป" style="width: 7rem" class="text-center">
                                            <template #body="taskProps">
                                                <span>{{ getTaskTimeSpent(taskProps.data) }}</span>
                                            </template>
                                        </Column>

                                        <!-- สถานะภาระงานประจำวัน -->
                                      
                                        <!-- สิ้นสุดสถานะภาระงานประจำวัน -->


                                        <!-- จัดการ -->
                                        <Column header="จัดการ" style="width: 6rem" class="text-center">
                                            <template #body="taskProps">
                                                <div class="flex gap-2 justify-center">
                                                    <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditTaskDialogInTable(stepProps.data, taskProps.data, taskProps.index)" v-tooltip.top="'แก้ไขภาระงาน'" />
                                                    <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded"  @click="confirmRemoveTaskInTable(stepProps.data, taskProps.index)" v-tooltip.top="'ลบภาระงาน'" />
                                                </div>
                                            </template>
                                        </Column>
                                    </DataTable> 
                                    <div v-if="stepProps.data.tasks?.length === 0" 
                                        class="text-center text-gray-500 text-sm py-4">
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

        <!-- Dialog: สร้าง/แก้ไขแผน -->
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
                      <div class="field col-12 md:col-12">
                        <label class="font-semibold text-lg">ประเภทแผน <span class="text-red-500">*</span></label>
                        <Dropdown 
                            v-model="currentPlan.planType"
                            :options="planTypes"
                            optionLabel="label"
                            optionValue="value"
                            placeholder="เลือกประเภทแผน"
                            class="w-full"
                            required
                        />
                    </div>
                    <div class="field col-12">
                        <label class="font-semibold text-lg">ชื่อแผนปฏิบัติงาน <span class="text-red-500">*</span></label>
                        <InputText v-model="currentPlan.planLabel" placeholder="ระบุชื่อแผนปฏิบัติงาน" required />
                    </div>
                    <div class="field col-12">
                        <label class="font-semibold text-lg">ผู้รับผิดชอบหลัก <span class="text-red-500">*</span></label>
                        <AutoComplete
                            v-model="currentPlan.owner"
                            :multiple="true"
                            :suggestions="ownerSuggestions"
                            optionLabel="name"
                            placeholder="พิมพ์ชื่อหรือรหัสพนักงานเพื่อค้นหา…"
                            forceSelection
                            dropdown
                            @complete="searchOwners"
                            />
                        <small class="text-gray-500">พิมพ์อย่างน้อย 3 ตัวอักษร เช่น รหัสพนักงาน หรือชื่อ-สกุล</small>
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
                    2. กำหนดขั้นตอน/กิจกรรมการทำงาน
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

        <!-- Dialog: แก้ไขขั้นตอน -->
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

        <!-- Dialog: แก้ไขภาระงาน -->
        <Dialog v-model:visible="showEditTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '70vw' }" modal>
            <template #header>
                <div class="flex items-center w-full">
                    <i class="pi pi-pencil mr-2 text-primary-500 text-2xl"></i>
                    <h5 class="m-0 text-xl font-bold text-primary-700">แก้ไขภาระงาน</h5>
                </div>
            </template> 

            <div class="p-fluid formgrid grid">
                <!-- ประเภทภาระงาน -->
                <div class="field col-6">
                    <label class="font-semibold">ประเภทภาระงาน</label>
                    <Dropdown
                    v-model="currentEditingTask.taskType"
                    :options="taskTypes"
                    optionLabel="label"
                    optionValue="value"
                    placeholder="เลือกประเภทภาระงาน"
                    class="w-full"
                    @change="onEditTaskTypeChange"
                    />
                </div>

                <!-- ภาระงานหลัก -->
                <div class="field col-6">
                    <label class="font-semibold">ภาระงานหลัก</label>
                    <Dropdown
                    v-model="currentEditingTask.mainTask"
                    :options="mainTasks"
                    optionLabel="label"
                    optionValue="value"
                    placeholder="เลือกภาระงานหลัก"
                    class="w-full"
                    />
                </div>
            </div>

            <div class="p-fluid formgrid grid">
                <!-- ภาระงาน -->
                <div class="field col-12 md:col-6 lg:col-6">
                    <label class="font-semibold">ภาระงานประจำวัน</label>
                    <InputText
                    v-model="currentEditingTask.description"
                    placeholder="ระบุภาระงาน..."
                    class="w-full"
                    />
                </div>

                <!-- เวลาเริ่มต้น -->
                <div class="field col-12 md:col-3 lg:col-3">
                    <label class="font-semibold">เวลาเริ่มต้น</label>
                    <Calendar
                    v-model="currentEditingTask.startTime"
                    :showTime="true"
                    hourFormat="24"
                    placeholder="เวลาเริ่มต้น"
                    class="w-full"
                    />
                </div>

                <!-- เวลาสิ้นสุด -->
                <div class="field col-12 md:col-3 lg:col-3">
                    <label class="font-semibold">เวลาสิ้นสุด</label>
                    <Calendar
                    v-model="currentEditingTask.endTime"
                    :showTime="true"
                    hourFormat="24"
                    placeholder="เวลาสิ้นสุด"
                    class="w-full"
                    />
                </div>  
            </div>
            <template #footer>
                <div class="flex justify-end gap-2 pt-4">
                    <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditTaskDialog = false" />
                    <Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedTask" />
                </div>
            </template>
        </Dialog>

        <!-- Dialog: เพิ่มภาระงาน -->
        <Dialog v-model:visible="showAddTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '70vw' }" modal>
            <template #header>
                <div class="flex items-center w-full">
                <i class="pi pi-plus-circle mr-2 text-primary-500 text-2xl"></i>
                <h5 class="m-0 text-xl font-bold text-primary-700">
                    เพิ่มภาระงานสำหรับขั้นตอน "{{ currentStepToAddTasks.name }}"
                </h5>
                </div>
            </template>

            <div class="p-fluid grid form-layout"> 
                <!-- ประเภทภาระงาน -->
                <div class="field col-12">
                <label class="font-semibold">ประเภทภาระงาน</label>
                <Dropdown
                    v-model="newTaskInStep.taskType"
                    :options="taskTypes"
                    optionLabel="label"
                    optionValue="value"
                    placeholder="เลือกประเภทภาระงาน"
                    class="w-full"
                    @change="onTaskTypeChange"
                />
                </div>

                <!-- ภาระงานหลัก (แสดงเมื่อไม่ใช่ 'งานอื่นๆ') -->
                <div class="field col-12" v-if="newTaskInStep.taskType !== 'งานอื่นๆ'">
                <label class="font-semibold">ภาระงานหลัก</label>
                <div class="grid">
                    <div class="col-12">
                        <Dropdown
                            v-if="!useCustomMainTask"
                            v-model="newTaskInStep.mainTask"
                            :options="mainTasks"
                            optionLabel="label"
                            optionValue="value"
                            placeholder="เลือกภาระงานหลัก"
                            class="w-full"
                            @change="onMainTaskChange"
                        />
                        <InputText
                            v-else
                            v-model="newTaskInStep.mainTask"
                            placeholder="ภาระงานอื่นๆ"
                            class="w-full"
                            readonly
                        />
                        </div> 
                    </div>
                </div>

                <!-- ภาระงานประจำวัน (แสดงเมื่อไม่ใช่ 'งานอื่นๆ') -->

                <div class="field col-12">
                    <label class="font-semibold">ภาระงานประจำวัน</label>

                    <!-- งานหลัก: Dropdown -->
                    <Dropdown
                        v-if="newTaskInStep.taskType === 'งานหลัก'"
                        v-model="newTaskInStep.description"
                        :options="subTasks"
                        optionLabel="name"
                        optionValue="name"
                        placeholder="เลือกภาระงานประจำวัน"
                        class="w-full"
                        :disabled="!newTaskInStep.mainTask"
                    />

                    <!-- งานตำแหน่งอื่น / งานอื่นๆ: กรอกเอง -->
                    <InputText
                        v-else
                        v-model="newTaskInStep.description"
                        placeholder="กรอกภาระงานประจำวัน"
                        class="w-full"
                    />
                </div>

                <!-- หมายเหตุ (แสดงเฉพาะเมือ 'งานอื่นๆ') -->
                <div class="field col-12" v-if="newTaskInStep.taskType === 'งานอื่นๆ'">
                <label class="font-semibold">หมายเหตุ</label>
                <Textarea
                    v-model="newTaskInStep.note"
                    autoResize
                    rows="3"
                    placeholder="กรอกรายละเอียดภาระงาน/หมายเหตุ"
                    class="w-full"
                />
                </div>

                <!-- เวลาเริ่มต้น -->
                <div class="field col-6 md:col-6">
                <label class="font-semibold">เวลาเริ่มต้น</label>
                <Calendar v-model="newTaskInStep.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น" />
                </div>

                <!-- เวลาสิ้นสุด -->
                <div class="field col-6 md:col-6">
                <label class="font-semibold">เวลาสิ้นสุด</label>
                <Calendar v-model="newTaskInStep.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด" />
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
    import { ref, reactive, computed, onMounted } from 'vue';
    import Swal from 'sweetalert2';
    import { useConfirm } from 'primevue/useconfirm';
    import { useToast } from 'primevue/usetoast';
    import axios from 'axios';

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
    import AutoComplete from 'primevue/autocomplete';


    // Directives
    const vTooltip = Tooltip;

    // ----------------- CONFIG -----------------
    const API = 'http://127.0.0.1:8000/api';

    // ----------------- SESSION -----------------
    const session = reactive({
    staffId: null,
    facId:   null,
    groupId: null,
    });
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    console.log(user); 
    /**
     * ดึง session จาก Nuxt Auth ถ้ามี (ป้องกันพังด้วย try/catch)
     * โครงสร้างที่คาดหวังจากคำอธิบายของคุณ:
     * user.user.name => { STAFFID, SCOPES:{ staffdepartment, groupid, ... } }
     */
    async function initSessionFromAuth() {
        try {
            // ใช้ useAuth() ตัวเดียว หลีกเลี่ยง import '#imports' ซ้ำซ้อน
            const { getSession } = await useAuth();
            const authUser = await getSession();

            // ตรวจดูโครงสร้างที่เป็นไปได้หลายแบบ
            const nameObj = authUser?.user?.name || {};
            const STAFFID =
                authUser?.user?.STAFFID              // บางระบบใส่ไว้ตรง user
            ?? authUser?.user?.id                   // หรือ id
            ?? nameObj?.STAFFID
            ?? nameObj?.staffid
            ?? nameObj?.staffId
            ?? null;

            const FACID =
                authUser?.user?.FACID
            ?? authUser?.user?.facid
            ?? nameObj?.SCOPES?.staffdepartment
            ?? nameObj?.SCOPES?.facid
            ?? nameObj?.SCOPES?.facId
            ?? null;

            const GROUPID =
                authUser?.user?.GROUPID
            ?? authUser?.user?.groupid
            ?? nameObj?.SCOPES?.groupid
            ?? null;

            // ถ้าได้ค่าใหม่มา ให้เขียนทับ session + localStorage ทุกครั้ง
            if (STAFFID) session.staffId = Number(STAFFID);
            if (FACID)   session.facId   = Number(FACID);
            session.groupId = GROUPID ?? session.groupId ?? null;

            try {
            localStorage.setItem('app_staffId', session.staffId ?? '');
            localStorage.setItem('app_facId',   session.facId ?? '');
            localStorage.setItem('app_groupId', session.groupId ?? '');
            } catch {}
        } catch (e) {
            // ถ้า auth ล้มเหลว ค่อย fallback ไป localStorage
            loadSessionFromStorage();
        }
    }

    function ensureSessionConsistency(authStaffId) {
        const cached = Number(localStorage.getItem('app_staffId') || 0);
            if (authStaffId && cached && Number(authStaffId) !== cached) {
                try {
                localStorage.removeItem('app_staffId');
                localStorage.removeItem('app_facId');
                localStorage.removeItem('app_groupId');
                } catch {}
                try {
                localStorage.setItem('app_staffId', String(authStaffId));
                localStorage.setItem('app_facId',   String(session.facId ?? ''));
                localStorage.setItem('app_groupId', String(session.groupId ?? ''));
                } catch {}
            }
        }

        onMounted(async () => {
        loadSessionFromStorage();       // อาจเป็นค่าเก่า
        await initSessionFromAuth();    // ดึงค่าใหม่จาก Auth แล้ว override

        // ✅ ล้าง cache เก่า ถ้ามี mismatch
        ensureSessionConsistency(session.staffId);

        if (!session.staffId || !session.facId) return;
        await fetchPlans();
    });


    
    /** เผื่ออยากเซ็ตค่า session เองจากภายนอก */
    function setSession(staffId, facId, groupId = null) {
    session.staffId = staffId ?? null;
    session.facId   = facId   ?? null;
    session.groupId = groupId ?? null;
    // เก็บ localStorage กันรีเฟรชหาย (ตามสะดวก)
    try {
        localStorage.setItem('app_staffId', session.staffId ?? '');
        localStorage.setItem('app_facId',   session.facId ?? '');
        localStorage.setItem('app_groupId', session.groupId ?? '');
    } catch {}
    }

    function loadSessionFromStorage() {
    try {
        const s = localStorage.getItem('app_staffId');
        const f = localStorage.getItem('app_facId');
        const g = localStorage.getItem('app_groupId');
        if (s) session.staffId = Number(s);
        if (f) session.facId   = Number(f);
        if (g) session.groupId = g;
    } catch {}
    }

    //ภาระงานหลัก

//    const mainTasks = [
//         { label: 'งานสอน', value: 'งานสอน' },
//         { label: 'งานวิจัย', value: 'งานวิจัย' },
//         { label: 'งานบริการวิชาการ', value: 'งานบริการวิชาการ' },
//         { label: 'งานอื่นๆ', value: 'งานอื่นๆ' }
//     ];

   const getMainTaskLabel = (mainTask) => {
        return mainTask || 'ยังไม่เลือก';
    };

    //เพิ่มภาระงาน

   async function fetchPositionMainWorks() {
    const positionNameId = user?.user?.name?.POSITIONNAMEID ?? null;
        if (!positionNameId) { positionMains.value = []; return; }
        const res = await axios.get(`${API}/getMainWorks`, { params: { positionnameid: positionNameId }});

        // ⬇️ map ให้เป็น {label,value}
        const data = Array.isArray(res.data?.data) ? res.data.data : [];
        positionMains.value = data
        .map(x => ({ label: x.POSNAMETH, value: x.POSNAMETH }))
        .filter(x => !!x.label);
    } 
   async function fetchAllMainWorks() {
        const res = await axios.get(`${API}/getMainWorksAll`);
        allMainTasks.value = (Array.isArray(res.data?.data) ? res.data.data : []);
    }

    async function fetchPositionSubWorks(mainName) { // [NEW] โหลด sub "ตามตำแหน่ง"
    if (!mainName) { positionSubs.value = []; return; }
    const res = await axios.get(`${API}/getSubWorks`, { params: { mainActivity: mainName } });
    positionSubs.value = Array.isArray(res.data?.data) ? res.data.data : [];
    }

    async function fetchAllSubWorks(mainName) { // [NEW] โหลด sub "ทุกตำแหน่ง"
    // <== เช่น /getSubWorksAll?mainActivity=xxx ที่ไม่กรองตามตำแหน่ง
    const res = await axios.get(`${API}/getSubWorksAll`, { params: { mainActivity: mainName } });
    allSubTasks.value = Array.isArray(res.data?.data) ? res.data.data : [];
    }

 

    const mainTasks = ref([]);
    const subTasks = ref([]);
    const onMainTaskChange = async (e) => {
        const mainName = e?.value ?? newTaskInStep.mainTask; // string
        if (!mainName) { subTasks.value = []; newTaskInStep.description = null; return; }

        if (newTaskInStep.taskType === 'งานตำแหน่งอื่น') {
            const res = await axios.get(`${API}/getSubWorksAll`, { params: { mainActivity: mainName }});
            subTasks.value = Array.isArray(res.data?.data) ? res.data.data : [];
        } else {
            const res = await axios.get(`${API}/getSubWorks`, { params: { mainActivity: mainName }});
            subTasks.value = Array.isArray(res.data?.data) ? res.data.data : [];
        }
        newTaskInStep.description = null;
    };

    
    const allPlans = ref([]);
    
    const allPlansSorted = computed(() => {
        const source = Array.isArray(allPlans.value) ? allPlans.value : [];
        return [...source].sort((a, b) => {
            const dateA = a.updatedDate ? new Date(a.updatedDate) : new Date(a.createdDate);
            const dateB = b.updatedDate ? new Date(b.updatedDate) : new Date(b.createdDate);
            return dateB - dateA;
        });
    });
    const taskStatuses = ref(['รอดำเนินการ', 'อยู่ระหว่างดำเนินการ', 'เสร็จสิ้น']);

    const confirm = useConfirm();
    const toast = useToast();
    const showPlanDialog = ref(false);
    const isEditMode = ref(false);
    const planTypes = [
        { label: 'แผนปฏิบัติการ', value: 'แผนปฏิบัติการ' },
        { label: 'โครงการ', value: 'โครงการ' },
        { label: 'นโยบาย', value: 'นโยบาย' },
        { label: 'มติประชุม', value: 'มติประชุม' }
    ];
    const currentPlan = reactive({
         id: null, 
         planType: null,
         planLabel: '', 
         owner: [], 
         startDate: null, 
         endDate: null, 
         steps: [] 
        });
    const newStepName = ref('');
    const newStepDates = ref([]);
    const expandedPlans = ref([]);
    const expandedSteps = ref([]);
    const activeTabIndex = ref(0);

    // Edit State for Steps and Tasks
    const showEditStepDialog = ref(false);
    const currentEditingStep = reactive({ 
        id: null, 
        name: '', 
        dates: [], 
        index: null 
    });
    const showEditTaskDialog = ref(false);
    const currentEditingTask = reactive({ 
        taskType: 'งานหลัก',
        mainTask: null,
        description: '', 
        responsible: [], 
        dueDate: null, 
        startTime: null, 
        endTime: null, status: '',
        stepId: null, taskId: null,
        taskIndex: null, 
        createdDate: null 
    });
    // State for adding task from main table
    const showAddTaskDialog = ref(false);
    const currentStepToAddTasks = reactive({ id: null, name: '' });
    //const newTaskInStep = reactive({ description: '', responsible: [], dueDate: null, startTime: null, endTime: null, mainTask: null, status: 'รอดำเนินการ',main_tasks: null });
    const newTaskInStep = reactive({ taskType: 'งานหลัก', mainTask: null, description: '', responsible: [], startTime: null, endTime: null, dueDate: null, status: 'รอดำเนินการ', });
    // ----------------- VALIDATIONS ------------
    const isFirstStepValid = computed(() =>
        currentPlan.planLabel && currentPlan.owner.length > 0 && currentPlan.startDate && currentPlan.endDate
    );
    const isSecondStepValid = computed(() => currentPlan.steps.length > 0);
    const isFinalStepValid = computed(() => isFirstStepValid.value && isSecondStepValid.value);
    const isNewStepValid = computed(() =>
        newStepName.value && newStepDates.value && newStepDates.value.length === 2 && newStepDates.value[0] && newStepDates.value[1]
    );
    const isNewTaskInStepValid = computed(() => { // [MOD] รองรับกรณี 'งานอื่นๆ'
        const t = newTaskInStep;
        const timeOk = !t.startTime || !t.endTime || new Date(t.endTime) >= new Date(t.startTime);
        if (t.taskType === 'งานอื่นๆ') {
            // งานอื่นๆ: ต้องกรอกหมายเหตุ
            return !!t.note && t.note.trim() !== '' && !!t.status && timeOk; // [NEW]
        } else {
            // งานหลัก/งานตำแหน่งอื่น: ต้องเลือก description (subtask)
            return !!t.description && t.description.trim() !== '' && !!t.status && timeOk; // [MOD]
        }
    });

    // ----------------- HELPERS ----------------
    const pad = (n) => String(n).padStart(2,'0');
    const toDateStr = (d) => {
    if (!d) return null;
    const dt = new Date(d);
    return `${dt.getFullYear()}-${pad(dt.getMonth()+1)}-${pad(dt.getDate())}`;
    };
    const toDateTimeStr = (d) => {
    if (!d) return null;
    const dt = new Date(d);
    return `${dt.getFullYear()}-${pad(dt.getMonth()+1)}-${pad(dt.getDate())} ${pad(dt.getHours())}:${pad(dt.getMinutes())}:00`;
    };

    const formatDate = (date) => {
        if (!date) return '';
        const d = new Date(date);
        return `${pad(d.getDate())}/${pad(d.getMonth() + 1)}/${d.getFullYear()}`;
    };

    const getPlanProgress = (plan) => {
        if (!plan.steps || plan.steps.length === 0) return 0;
        const total = plan.steps.reduce((sum, step) => sum + getStepProgress(step), 0);
        return Math.round(total / plan.steps.length);
    };
    const getStepProgress = (step) => {
        if (!step) return 0;
        if (step.status === 'เสร็จสิ้น') return 100;
        if (step.status === 'อยู่ระหว่างดำเนินการ') return 50;  // จะใช้ 50% กลาง ๆ
        return 0; // รอดำเนินการ
    };
    const getPlanStatusLabel = (plan) => (getPlanProgress(plan) === 100 ? 'เสร็จสิ้น' : getPlanProgress(plan) > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ');
    const getPlanStatusSeverity = (plan) => (getPlanProgress(plan) === 100 ? 'success' : getPlanProgress(plan) > 0 ? 'warning' : 'info');
    // const getStepStatus = (step) => (getStepProgress(step) === 100 ? 'เสร็จสิ้น' : getStepProgress(step) > 0 ? 'อยู่ระหว่างดำเนินการ' : 'รอดำเนินการ');
    // const getStepSeverity = (step) => (getStepProgress(step) === 100 ? 'success' : getStepProgress(step) > 0 ? 'warning' : 'info');
    const getStepStatus = (step) => step?.status || 'รอดำเนินการ';

    const getStepSeverity = (step) => {
        switch (step?.status) {
            case 'เสร็จสิ้น': return 'success';
            case 'อยู่ระหว่างดำเนินการ': return 'warning';
            default: return 'info';
        }
    };

 


    const getTaskDueDateSeverity = (dueDate) => {
    if (!dueDate) return 'info';
        const now = new Date();
        const due = new Date(dueDate);
        due.setHours(23, 59, 59, 999);
        return due < now ? 'danger' : 'success';
    };
    const getTaskTimeSpent = (task) => {
        // รองรับกรณีมีแค่เวลาเริ่ม + กำลังดำเนินการ -> นับจนถึงตอนนี้
        if (task?.startTime && !task?.endTime && task?.status === 'อยู่ระหว่างดำเนินการ') {
            const start = new Date(task.startTime);
            const now = new Date();
            const diffMin = Math.max(0, Math.round((now - start) / (1000 * 60)));
            return `${diffMin} นาที`;
        }

        // กรณีมี start & end ครบ
        if (!task?.startTime || !task?.endTime) return 'ยังไม่ระบุ';
        const start = new Date(task.startTime);
        const end   = new Date(task.endTime);

        // ถ้า end เร็วกว่า start ให้ถือว่าเป็น 0 (กันพลาดจากการกรอกเวลา)
        const diffMs  = Math.max(0, end - start);
        const diffMin = Math.round(diffMs / (1000 * 60));

        return `${diffMin} นาที`;
    };
    const getTaskStatusSeverityByValue = (status) =>
    status === 'เสร็จสิ้น' ? 'success' : status === 'อยู่ระหว่างดำเนินการ' ? 'warning' : 'info'; 

    function mapApiToState(arr) {
       return (arr || []).map(p => ({
        ...p,
        // ✅ เก็บตัวชี้เจ้าของไว้ใช้กรอง
        staff_id:  p.staff_id  ?? p.staffId  ?? null,
        created_by: p.created_by ?? p.createdBy ?? null,

        startDate: p.startDate ? new Date(p.startDate) : null,
        endDate:   p.endDate   ? new Date(p.endDate)   : null,

        owner: Array.isArray(p.owner)
        ? p.owner.map(o => ({
            id: o.id,
            name: o.name || o.staff_name || o.owner_name || `ID:${o.id}`
            }))
        : [],

        steps: (p.steps || []).map(s => ({
        ...s,
        status: s.status_planstep ?? null, 
        startDate: s.startDate ? new Date(s.startDate) : null,
        endDate:   s.endDate   ? new Date(s.endDate)   : null,
        tasks: (s.tasks || []).map(t => ({
                    ...t,
                    responsible: Array.isArray(t.responsible)
                    ? t.responsible.map(r => ({
                        id: r.id,
                        name: r.name || r.owner_name || `ID:${r.id}`
                    }))
                    : [],
                    mainTask:    t.mainTask ?? t.Main_tasks ?? null,
                    dueDate:     t.dueDate     ? new Date(t.dueDate)     : null,
                    startTime:   t.startTime   ? new Date(t.startTime)   : null,
                    endTime:     t.endTime     ? new Date(t.endTime)     : null,
                    createdDate: t.createdDate ? new Date(t.createdDate) : null,
                })),
            })),
        }));
    }


    // ----------------- API CALLS --------------
    async function fetchPlans() {
        if (!session.staffId || !session.facId) return;

        try {
            const res = await axios.post(`${API}/showplannew`, {
            staff_id: session.staffId,   // ส่งของคนที่ล็อกอิน
            fac_id:   session.facId,
            });

            const mapped = mapApiToState(res.data?.data || []);
            // ✅ โชว์ "ของใครของมัน" ตั้งแต่ชั้น fetch
            allPlans.value = mapped.filter(belongsToMe);
        } catch (e) {
            allPlans.value = [];
            // toast / Swal ตามเดิมถ้าต้องการ
        }
    }
    function belongsToMe(plan) {
        const me = Number(session.staffId);

        // 1) จากฟิลด์ staff ของแผน
        const staffField = Number(
            plan.staff_id ?? plan.staffId ?? plan.created_by ?? plan.createdBy ?? null
        );

        // 2) จาก owner array
        const ownerMatch = Array.isArray(plan.owner)
            && plan.owner.some(o => Number(o.id) === me);

        return staffField === me;
    }


   onMounted(async () => {
        loadSessionFromStorage();
        await initSessionFromAuth();

        // ✅ รอให้ได้ staffId / facId ก่อน ค่อยโหลด
        if (!session.staffId || !session.facId) return;
        await fetchPlans();
    });

    // ----------------- UI ACTIONS -------------
    const openPlanDialog = () => {
    isEditMode.value = false;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    Object.assign(currentPlan, { id: null, planLabel: '', owner: [], startDate: null, endDate: null, steps: [] });
    newStepName.value = '';
    newStepDates.value = [];
    };

    const editPlan = (plan) => {
    isEditMode.value = true;
    showPlanDialog.value = true;
    activeTabIndex.value = 0;
    const clonedPlan = JSON.parse(JSON.stringify(plan));
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

    const confirmDeletePlan = async (planId) => {
        const r = await Swal.fire({
            title: 'ยืนยันการลบ',
            text: 'คุณต้องการลบแผนงานนี้ใช่หรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้',
            icon: 'warning', showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#3085d6',
            confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก'
        });
        if (!r.isConfirmed) return;

        try {
            await axios.delete(`${API}/Deldataplan`, { data: { id: planId } });
            allPlans.value = allPlans.value.filter(p => p.id !== planId);
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบแผนงานเรียบร้อยแล้ว', timer: 1500, showConfirmButton: false });
        } catch (e) {
            console.error(e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบไม่สำเร็จ' });
        }
    };

    const goToNextStep = () => {
        if (isFirstStepValid.value) activeTabIndex.value = 1;
        else Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณากรอกข้อมูลแผนงานให้ครบถ้วน' });
    };

    const goToPrevStep = () => { activeTabIndex.value = 0; };

    const savePlan = async () => {
        if (!isFinalStepValid.value) {
            return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณาตรวจสอบข้อมูลแผนงานและขั้นตอน' });
        }

        const payload = {
            id: currentPlan.id,
            planType: currentPlan.planType,
            planLabel: currentPlan.planLabel,
            startDate: toDateStr(currentPlan.startDate),
            endDate:   toDateStr(currentPlan.endDate), 
            owner: (currentPlan.owner || []).map(o => ({ id: o.id, name: o.name })),
             
             staff_id: session.staffId,  
            fac_id:   session.facId,
            steps: currentPlan.steps.map(s => ({
                name: s.name,
                startDate: toDateStr(s.startDate),
                endDate:   toDateStr(s.endDate),
                tasks: (s.tasks||[]).map(t => ({
                description: t.description,
                dueDate:     toDateStr(t.dueDate),
                startTime:   toDateTimeStr(t.startTime),
                endTime:     toDateTimeStr(t.endTime),
                status:      t.status,
                createdDate: toDateTimeStr(t.createdDate),
                responsible: t.responsible || []
                }))
            }))
        };

        try { 
            //console.log("Payload ที่จะส่งไป:", payload);
            console.log('owner0', currentPlan.owner?.[0]);
            console.log('session', session);
            console.log('payload.staff_id', (currentPlan.owner?.[0]?.id) ?? session.staffId);

            if (isEditMode.value) {
            await axios.post(`${API}/Edtdataplans`, payload);
            const res = await axios.post(`${API}/showplannew`, {
            staff_id: session.staffId, fac_id: session.facId
            });
            const mapped = mapApiToState(res.data?.data || []);
            allPlans.value = mapped.filter(belongsToMe);  

            allPlans.value = mapApiToState(res.data?.data || []);
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขแผนงานเรียบร้อยแล้ว', timer: 1500, showConfirmButton: false });
            } else {
            const res = await axios.post(`${API}/savedataplans`, payload);

            // ถ้า backend ส่ง id กลับมา
            if (res?.data?.id) {
                currentPlan.id = res.data.id;
            }

            await fetchPlans(); // หรือจะรีโหลดตามเดิมก็ได้
            Swal.fire({
                icon:'success',
                title:'สำเร็จ',
                text:'สร้างแผนงานใหม่เรียบร้อยแล้ว',
                timer: 1500,
                showConfirmButton: false
            });
        }
            showPlanDialog.value = false;
        } catch (e) {
            console.error(e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'บันทึกไม่สำเร็จ' });
        }
    };

    const addStep = () => {
        if (!isNewStepValid.value) {
            return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณาใส่ชื่อขั้นตอนและช่วงเวลาให้ครบถ้วน' });
        }
        currentPlan.steps.push({
            id: Date.now(),
            name: newStepName.value,
            startDate: newStepDates.value[0],
            endDate: newStepDates.value[1],
            tasks: []
        });
        newStepName.value = '';
        newStepDates.value = [];
        Swal.fire({ icon:'success', title:'สำเร็จ', text:'เพิ่มขั้นตอนเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
    };

    const confirmRemoveStep = (index) => {
        Swal.fire({
            title: 'ยืนยันการลบ', text: 'คุณต้องการลบขั้นตอนการทำงานนี้ใช่หรือไม่?',
            icon: 'warning', showCancelButton: true, confirmButtonColor: '#d33', cancelButtonColor: '#3085d6',
            confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก'
        }).then((r) => {
            if (r.isConfirmed) {
            currentPlan.steps.splice(index, 1);
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบขั้นตอนเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
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

    const saveEditedStep = async () => {
        if (!currentEditingStep.name || !currentEditingStep.dates || currentEditingStep.dates.length !== 2) {
            return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณากรอกข้อมูลขั้นตอนให้ครบถ้วน' });
        }
        try {
            await axios.post(`${API}/Edtdatastep`, {
            id: currentEditingStep.id,
            name: currentEditingStep.name,
            startDate: toDateStr(currentEditingStep.dates[0]),
            endDate:   toDateStr(currentEditingStep.dates[1]),
            });

            // อัปเดตใน allPlans โดยค้นหาจาก id (ไม่พึ่ง index)
            allPlans.value.forEach(plan => {
            const step = plan.steps?.find(s => s.id === currentEditingStep.id);
            if (step) {
                step.name = currentEditingStep.name;
                step.startDate = currentEditingStep.dates[0];
                step.endDate   = currentEditingStep.dates[1];
            }
            });

            // ถ้า currentPlan มี step เดียวกัน ก็อัปเดตให้ด้วย
            const stepInDialog = currentPlan.steps?.find(s => s.id === currentEditingStep.id);
            if (stepInDialog) {
            stepInDialog.name = currentEditingStep.name;
            stepInDialog.startDate = currentEditingStep.dates[0];
            stepInDialog.endDate   = currentEditingStep.dates[1];
            }

            showEditStepDialog.value = false;
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขขั้นตอนเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error(e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'แก้ไขขั้นตอนไม่สำเร็จ' });
        }
    };


    const openAddTaskDialog = async (stepData, ownersList) => {
    // Log user info from session
        console.log('session:', session);
        let positionNameId = null;
        if (user && user.user && user.user.name && user.user.name.POSITIONNAMEID) {
            positionNameId = user.user.name.POSITIONNAMEID;
            try {
                console.log(positionNameId);
                
                const res = await axios.get(`${API}/getMainWorks`, {
                    params: { positionnameid: positionNameId }
                });
                console.log('getMainWorks response:', res.data);

                const uniqueTasks = [];
                const seen = new Set();
                
                // ✅ แก้ไขตรงนี้: ตรวจสอบก่อนว่า res.data.data เป็น Array
                if (Array.isArray(res.data.data)) {
                    for (const item of res.data.data) {
                        if (!seen.has(item.POSNAMETH)) {
                            seen.add(item.POSNAMETH);
                            uniqueTasks.push(item);
                        }
                    }
                } else {
                    // หาก res.data.data ไม่ใช่อาร์เรย์ (อาจเป็น Object เดียว) ให้จัดการแยกต่างหาก
                    const item = res.data.data;
                    if (item && !seen.has(item.POSNAMETH)) {
                        seen.add(item.POSNAMETH);
                        uniqueTasks.push(item);
                    }
                }

                mainTasks.value = uniqueTasks;

                // คุณสามารถนำ res.data ไปใช้งานต่อ เช่น set mainTasks หรืออื่นๆ ตามต้องการ
            } catch (err) {
                console.error('getMainWorks error:', err);
            }
        }
        showAddTaskDialog.value = true;
        Object.assign(currentStepToAddTasks, { id: stepData.id, name: stepData.name });
        Object.assign(newTaskInStep, { description: '', responsible: ownersList, dueDate: null, startTime: null, endTime: null, status: 'รอดำเนินการ' });  
        resetNewTaskInStep();    
    };

    //เคลลียร์ฟอร์มก่อนเปิด dialog
    const useCustomMainTask = ref(false);
    const useCustomSubTask  = ref(false); 

    const allMainTasks   = ref([]);   // main ทั้งระบบ (ทุกตำแหน่ง)
    const allSubTasks    = ref([]);   // sub ทั้งระบบ (ทุกตำแหน่ง)
    const positionMains  = ref([]);   // main ตามตำแหน่งผู้ใช้
    const positionSubs   = ref([]);   // sub ตามตำแหน่งผู้ใช้ (ขึ้นกับ main)
    const mainTaskOptionLabel = computed(() => {
    // ถ้าของที่โหลดมาเป็นแบบ { POSNAMETH } ใช้คีย์นั้น, ถ้าเป็น {label,value} ก็ใช้ label
    // ทำให้ Dropdown ใช้ร่วมกันได้ทั้งสองรูปแบบ
    const sample = mainTasks.value?.[0] || {};
    return sample.POSNAMETH ? 'POSNAMETH' : 'label';
    });
    const mainTaskOptionValue = computed(() => {
    const sample = mainTasks.value?.[0] || {};
    return sample.POSNAMETH ? 'POSNAMETH' : 'value';
    });
 

    function resetNewTaskInStep() {
        Object.assign(newTaskInStep, {
            taskType: null,
            mainTask: null,
            description: '',
            note: '',
            responsible: [],
            startTime: null,
            endTime: null,
            dueDate: null,
            status: 'รอดำเนินการ'
        });
        useCustomMainTask.value = false;
        useCustomSubTask.value  = false;
        subTasks.value = [];
    }

    //ค้นหาบุคลากร
    const ownerSuggestions = ref([]); 
    // แปลงผล API เป็น { id, name, staffid, posnameth } ตามที่ต้องการใช้ต่อ
    function mapStaffToOption(x) {
        return {
            id: Number(x.staffid) || x.id || null,       // key หลัก
            name: x.namefully || x.name || '',           // ชื่อที่แสดง
            staffid: x.staffid || null,                  // เก็บไว้เสริม
            posnameth: x.posnameth || null,
        };
    }

        let ownerSearchTimer = null;
        async function searchOwners(e) {
        const q = (e.query || '').trim();
        if (ownerSearchTimer) clearTimeout(ownerSearchTimer);

        if (!q || q.length < 3) { ownerSuggestions.value = []; return; }

    ownerSearchTimer = setTimeout(async () => {
            try {
            // ปรับพารามิเตอร์ให้ตรง API ของคุณ
                const res = await axios.get(`${API}/searchDataStaff`, { params: { staffid: q } });
                const arr = Array.isArray(res.data) ? res.data : (res.data?.data || []);
                ownerSuggestions.value = arr.map(mapStaffToOption);
            } catch (err) {
                console.error('searchOwners error:', err);
                ownerSuggestions.value = [];
            }
        }, 250); // debounce
    } 

   function getOwnerDisplay(o) {
        if (!o) return '';
        return o.name || o.staff_name || o.owner_name || o.fullname || o.staff_fullname || `ID:${o.id}`;
    }




    const taskTypes = [
        { label: 'งานหลัก', value: 'งานหลัก' },
        { label: 'งานตำแหน่งอื่น', value: 'งานตำแหน่งอื่น' },
        { label: 'งานอื่นๆ', value: 'งานอื่นๆ' },
    ];
 
    const onTaskTypeChange = async () => {
        const t = newTaskInStep.taskType;
        newTaskInStep.mainTask = null;
        newTaskInStep.description = '';
        useCustomMainTask.value = false;
        useCustomSubTask.value = (t === 'งานอื่นๆ'); // งานอื่นๆ = กรอกเอง
        subTasks.value = [];

        if (t === 'งานอื่นๆ') {
            newTaskInStep.mainTask = 'ภาระงานอื่นๆ';
            return;
        }
        if (t === 'งานหลัก') {
            await fetchPositionMainWorks();
            mainTasks.value = positionMains.value;  // ← ทั้งสองกรณีเป็น {label,value}
        } else if (t === 'งานตำแหน่งอื่น') {
            await fetchAllMainWorks();
            mainTasks.value = allMainTasks.value;   // ← {label,value}
        }
    };

    // ประเภทแผน
    const getPlanTypeSeverity = (t) => {
        switch (t) {
            case 'แผนปฏิบัติการ': return 'success';   // เขียว
            case 'โครงการ':       return 'danger';      // ฟ้า
            case 'นโยบาย':        return 'warning';   // เหลือง
            case 'มติประชุม':     return 'info';      // ฟ้า
            case 'ไม่ระบุ':       return 'secondary'; // เทา
            default:              return 'secondary'; // fallback เป็นเทา
        }
    }
 
    const addTaskToStepFromMain = async () => { // [MOD]
        if (!isNewTaskInStepValid.value) {
            return Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: 'กรุณากรอกข้อมูลให้ครบถ้วน (ตรวจสอบประเภท/รายละเอียด/หมายเหตุ และเวลา)'
            });
        }

        try {
            const payload = {
                step_id: currentStepToAddTasks.id,
                taskType: newTaskInStep.taskType,
                mainTask: newTaskInStep.taskType === 'งานอื่นๆ' ? 'ภาระงานอื่นๆ' : newTaskInStep.mainTask,
                description: newTaskInStep.taskType === 'งานอื่นๆ' ? (newTaskInStep.note || '') : newTaskInStep.description,
                startTime: toDateTimeStr(newTaskInStep.startTime),
                endTime:   toDateTimeStr(newTaskInStep.endTime),
                status:    newTaskInStep.status,
                staff_id:  session.staffId,
                fac_id:    session.facId,
                // ✅ ส่งผู้รับผิดชอบหลายคนไปให้ Back
                responsible: (newTaskInStep.responsible || []).map(o => ({ id: o.id })),
            };

            const res = await axios.post(`${API}/savedatatasks`, payload);

            const plan = allPlans.value.find(p => p.steps.some(s => s.id === currentStepToAddTasks.id));
            const step = plan?.steps.find(s => s.id === currentStepToAddTasks.id);
            if (step) {
            step.tasks = step.tasks || [];
            step.tasks.push({
                id: res.data.id,
                taskType: payload.taskType,
                mainTask: payload.mainTask,
                description: payload.description,
                startTime: newTaskInStep.startTime,
                endTime: newTaskInStep.endTime,
                status: newTaskInStep.status,
                createdDate: new Date(),
                staffId: session.staffId ?? null,
                // ✅ เก็บไว้บนหน้าด้วย
                responsible: (newTaskInStep.responsible || []).map(o => ({ id: o.id, name: o.name })),
            });
            }

            showAddTaskDialog.value = false;
            Swal.fire({ icon: 'success', title: 'สำเร็จ', text: 'เพิ่มภาระงานเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error("เกิดข้อผิดพลาด:", e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'เพิ่มภาระงานไม่สำเร็จ' });
        }
    };
 
    const openEditTaskDialogInTable = async (step, task, taskIndex) => {
        showEditTaskDialog.value = true;

        Object.assign(currentEditingTask, {
            stepId: step.id,
            taskId: task.id,
            taskIndex,
            taskType: task.taskType || 'งานหลัก',
            mainTask: task.mainTask || null,
            description: task.description || '',
            responsible: task.responsible || [],
            dueDate: task.dueDate ? new Date(task.dueDate) : null,
            startTime: task.startTime ? new Date(task.startTime) : null,
            endTime: task.endTime ? new Date(task.endTime) : null,
            status: task.status || '',
            createdDate: task.createdDate ? new Date(task.createdDate) : null,
            staffId: task.staffId ?? session.staffId ?? null,
        });

        // ⬇️ โหลดตัวเลือกภาระงานหลักตามประเภทงาน
        if (currentEditingTask.taskType === 'งานหลัก') {
            await fetchPositionMainWorks();          // ได้ {label, value} แล้ว
            mainTasks.value = positionMains.value;
        } else if (currentEditingTask.taskType === 'งานตำแหน่งอื่น') {
            await fetchAllMainWorks();               // ได้ {label, value} แล้ว
            mainTasks.value = allMainTasks.value;
        } else {
            // งานอื่นๆ ไม่ต้องเลือก mainTask
            mainTasks.value = [{ label: 'ภาระงานอื่นๆ', value: 'ภาระงานอื่นๆ' }];
        }

        // ถ้าต้องการโหลด subtask ตาม mainTask เดิม (ถ้ามี)
        if (currentEditingTask.mainTask) {
            if (currentEditingTask.taskType === 'งานหลัก') {
            const r = await axios.get(`${API}/getSubWorks`,     { params: { mainActivity: currentEditingTask.mainTask }});
            subTasks.value = Array.isArray(r.data?.data) ? r.data.data : [];
            } else if (currentEditingTask.taskType === 'งานตำแหน่งอื่น') {
            const r = await axios.get(`${API}/getSubWorksAll`,  { params: { mainActivity: currentEditingTask.mainTask }});
            subTasks.value = Array.isArray(r.data?.data) ? r.data.data : [];
            } else {
            subTasks.value = [];
            }
        }
    };

    const onEditTaskTypeChange = async () => {
        const t = currentEditingTask.taskType;
        currentEditingTask.mainTask = null;
        currentEditingTask.description = '';
        subTasks.value = [];

        if (t === 'งานอื่นๆ') {
            // พิมพ์เอง ไม่ต้องโหลด main/sub
            return;
        }
        if (t === 'งานหลัก') {
            await fetchPositionMainWorks();
            mainTasks.value = positionMains.value;
        } else if (t === 'งานตำแหน่งอื่น') {
            await fetchAllMainWorks();
            mainTasks.value = allMainTasks.value;
        }
    };
 
    const saveEditedTask = async () => { 
        const invalidTime =
            currentEditingTask.startTime &&
            currentEditingTask.endTime &&
            new Date(currentEditingTask.endTime) < new Date(currentEditingTask.startTime);

        if (!currentEditingTask.description || invalidTime) {
            return Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด',
            text: invalidTime
                ? 'กรุณาตรวจสอบเวลาเริ่มต้น-สิ้นสุด'
                : 'กรุณาระบุภาระงาน'
            });
        }

        const payload = {
            id:          currentEditingTask.taskId,
            taskType:    currentEditingTask.taskType,
            mainTask:    currentEditingTask.mainTask,
            description: currentEditingTask.description,
            startTime:   toDateTimeStr(currentEditingTask.startTime),
            endTime:     toDateTimeStr(currentEditingTask.endTime),
            status:      currentEditingTask.status,
            fac_id:      session.facId,
        };

        try {
            await axios.post(`${API}/Edtdatatasks`, payload); 
            const planIndex = allPlans.value.findIndex(p => p.steps.some(s => s.id === currentEditingTask.stepId));
            if (planIndex === -1) return;
            const stepIndex = allPlans.value[planIndex].steps.findIndex(s => s.id === currentEditingTask.stepId);
            if (stepIndex === -1) return;

            allPlans.value[planIndex].steps[stepIndex].tasks[currentEditingTask.taskIndex] = {
            id: currentEditingTask.taskId,
            taskType: currentEditingTask.taskType, 
            mainTask: currentEditingTask.mainTask,
            description: currentEditingTask.description, 
            startTime: currentEditingTask.startTime,
            endTime: currentEditingTask.endTime,
            status: currentEditingTask.status,
            createdDate: currentEditingTask.createdDate,
            };

            showEditTaskDialog.value = false;
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขภาระงานเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error("เกิดข้อผิดพลาด:", e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'แก้ไขภาระงานไม่สำเร็จ' });
        }
    }; 
     
    async function updateStepStatus(plan, step, newStatus) {
        if (!step?.id) {
            await Swal.fire({ icon:'warning', title:'ยังไม่สามารถบันทึก', text:'ขั้นตอนนี้ยังไม่มี ID' });
            return;
        }
        const oldStatus = step.status ?? null;
        step.status = newStatus;
        step.__saving = true;

        try {
            await axios.post(`${API}/UpdateStepStatus`, {
            id: step.id,
            status: newStatus,
            fac_id: session.facId,
            });

            // (ตัวเลือก) ถ้าต้องการให้ task ใต้ step ถูกดันสถานะตามด้วย
            // if (Array.isArray(step.tasks)) step.tasks.forEach(t => { t.status = newStatus; });

            Swal.fire({ icon:'success', title:'บันทึกแล้ว', text:'อัปเดตสถานะขั้นตอนเรียบร้อย', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error(e);
            step.status = oldStatus;
            Swal.fire({ icon:'error', title:'บันทึกไม่สำเร็จ', text:'อัปเดตสถานะขั้นตอนไม่สำเร็จ' });
        } finally {
            step.__saving = false;
        }
    }
  
    const confirmRemoveTaskInTable = async (step, taskIndex) => {
    const ok = await Swal.fire({ title:'ยืนยันการลบ', text:'คุณต้องการลบภาระงานนี้ใช่หรือไม่?', icon:'warning', showCancelButton:true });
        if (!ok.isConfirmed) return;
        const task = step.tasks[taskIndex];
        try {
            await axios.delete(`${API}/Deldatatask`, { data: { id: task.id } });
            step.tasks.splice(taskIndex, 1);
            Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบภาระงานเรียบร้อยแล้ว', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error(e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบภาระงานไม่สำเร็จ' });
        }
    };

    const confirmRemoveStepById = async (planId, stepId) => {
        const r = await Swal.fire({
            title: 'ยืนยันการลบ',
            text: 'คุณต้องการลบขั้นตอนนี้ใช่หรือไม่? การกระทำนี้ไม่สามารถย้อนกลับได้',
            icon: 'warning', showCancelButton: true, confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก',
            confirmButtonColor: '#d33', cancelButtonColor: '#3085d6'
        });
        if (!r.isConfirmed) return;

        try {
            await axios.delete(`${API}/Deldatastep`, { data: { id: stepId } });
            const plan = allPlans.value.find(p => p.id === planId);
            if (plan) plan.steps = plan.steps.filter(step => step.id !== stepId);
            Swal.fire({ title:'สำเร็จ', text:'ลบขั้นตอนเรียบร้อยแล้ว', icon:'success', timer: 1200, showConfirmButton: false });
        } catch (e) {
            console.error(e);
            Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบขั้นตอนไม่สำเร็จ' });
        }
    };

    
    const descSuggestions = ref([]);
    let descTimer = null;

    const onSearchTaskDesc = (e) => {
        const q = (e.query || '').trim();
        if (descTimer) clearTimeout(descTimer);

        if (!q) { descSuggestions.value = []; return; }

        // debounce กันยิง API ถี่เกินไป
        descTimer = setTimeout(async () => {
            try {
            const res = await axios.get(`${API}/task-suggest`, {
                params: { q, fac_id: session.facId, limit: 10 }
            });
            descSuggestions.value = res.data?.data || [];
            } catch (err) {
            console.error(err);
            descSuggestions.value = [];
            }
        }, 250);
    };
    const editDescSuggestions = ref([]);
    let editDescTimer = null;

    const onSearchEditTaskDesc = (e) => {
    const q = (e.query || '').trim();
        if (editDescTimer) clearTimeout(editDescTimer);
        if (!q) { editDescSuggestions.value = []; return; }

        editDescTimer = setTimeout(async () => {
            try {
            const res = await axios.get(`${API}/task-suggest`, {
                params: { q, fac_id: session.facId, limit: 10 }
            });
            editDescSuggestions.value = res.data?.data || [];
            } catch (err) {
            console.error(err);
            editDescSuggestions.value = [];
            }
        }, 250);
    };
 
    const planNo = (s) => {
        const m = String(s || '').match(/\d+/)
        return m ? parseInt(m[0], 10) : 0
    };

  
    

  
 </script>


<style scoped>
    .custom-scroll::-webkit-scrollbar { width: 6px; }
    .custom-scroll::-webkit-scrollbar-thumb { background-color: #d1d5db; border-radius: 3px; }
</style>
