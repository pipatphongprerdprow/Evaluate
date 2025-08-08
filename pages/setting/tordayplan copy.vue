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
                            <Button icon="pi pi-plus" label="เพิ่มแผนปฎิบัติงาน" class="p-button-warning p-button-sm font-semibold" @click="openPlanDialog"/>
                            <Button icon="pi pi-plus" label="เพิ่มภาระงาน" class="p-button-info p-button-sm font-semibold" @click="openTaskDialog" :disabled="!selectedPlanId"/>
                        </div>
                       <div class="flex-1 flex flex-col sm:flex-row sm:items-center gap-3 justify-end">
                            <label for="plan-dropdown" class="font-bold text-lg text-700 mb-1 sm:mb-0 whitespace-nowrap">เลือกแผนปฏิบัติงาน:</label>
                            <Dropdown
                                id="plan-dropdown"
                                v-model="selectedPlanId"
                                :options="planOptions"
                                optionLabel="label"
                                optionValue="value"
                                placeholder="เลือกแผนปฎิบัติงาน"
                                class="w-full md:w-25rem flex-grow"
                            />

                            <div class="flex gap-2" v-if="selectedPlanId">
                                <Button
                                    icon="pi pi-pencil"
                                    @click="openEditPlanDialog(selectedPlanId)" class="p-button-text p-button-rounded p-button-sm"
                                    v-tooltip.top="'แก้ไขแผน'"
                                />
                                <Button
                                    icon="pi pi-trash"
                                    @click="confirmDeletePlan(selectedPlanId)"
                                    class="p-button-text p-button-danger p-button-rounded p-button-sm"
                                    v-tooltip.top="'ลบแผนนี้และภาระงานที่เกี่ยวข้อง'"
                                />
                            </div>
                        </div>
                        <Dialog v-model:visible="showEditPlanDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '40vw' }" :modal="true" position="top" class="p-dialog-lg">
                            <template #header>
                                <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                                    <i class="pi pi-pencil mr-2 text-primary-500"></i> แก้ไขข้อมูลแผนปฎิบัติงาน
                                </h5>
                            </template>
                            <div class="p-fluid">
                                <div class="field mb-4">
                                    <label for="editPlanLabel" class="font-bold mb-2">ชื่อแผนปฏิบัติงาน:</label>
                                    <InputText id="editPlanLabel" v-model="editPlanForm.planLabel" />
                                </div>
                                <div class="field mb-4">
                                    <label for="editStartDate" class="font-bold mb-2">วันที่เริ่มต้น:</label>
                                    <Calendar id="editStartDate" v-model="editPlanForm.startDate" dateFormat="dd/mm/yy" showIcon />
                                </div>
                                <div class="field mb-4">
                                    <label for="editEndDate" class="font-bold mb-2">วันที่สิ้นสุด:</label>
                                    <Calendar id="editEndDate" v-model="editPlanForm.endDate" dateFormat="dd/mm/yy" showIcon />
                                </div>
                            </div>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-save" class="p-button-success p-button-sm mr-2" @click="saveEditedPlan" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-sm" @click="showEditPlanDialog = false"/>
                            </template>
                        </Dialog>
                    </div>
                    <Divider class="my-5" />
                    <h4 class="text-2xl font-bold text-700 mb-4 flex items-center">
                        <i class="pi pi-list mr-2 text-primary-500"></i>
                        ภาระงานประจำวัน
                        <span v-if="selectedPlanId" class="ml-2 text-primary-600 font-normal text-xl">
                            ( <span class="font-semibold text-primary-700">{{ getPlanLabelById(selectedPlanId) }}</span>
                                <span  v-if="getPlanDateRange(selectedPlanId)"> วันที่ {{ getPlanDateRange(selectedPlanId) }}</span>)
                        </span>
                        <span v-else class="ml-2 text-500 font-normal text-lg">(โปรดเลือกแผนเพื่อแสดงภาระงาน)</span>
                    </h4>

                    <DataTable :value="filteredDailyTasks" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id" class="p-datatable-gridlines p-datatable-sm">
                        <Column field="recordDate" header="วันที่" class="text-center" style="width: 10%;">
                            <template #body="slotProps">
                                <span class="font-medium text-color-secondary">{{ formatDate(slotProps.data.recordDate) }}</span>
                            </template>
                        </Column>
                        <Column field="evaluationRound" header="รอบประเมิน" class="text-center" style="width: 10%;">
                            <template #body="slotProps">
                                <Tag :value="slotProps.data.evaluationRound" class="p-tag-rounded p-tag-info font-medium"></Tag>
                            </template>
                        </Column>
                        <Column field="description" header="ภาระงาน" class="text-left" style="width: 25%;">
                            <template #body="slotProps">
                                <span class="text-700 font-medium">{{ slotProps.data.description }}</span>
                            </template>
                        </Column>
                        <Column field="fileName" header="ไฟล์เอกสาร" class="text-center" style="width: 15%;">
                            <template #body="slotProps">
                                <span v-if="slotProps.data.fileName">
                                    <a :href="getFileUrl(slotProps.data.filePath)" target="_blank" class="p-button p-component p-button-link text-sm flex items-center justify-center">
                                        <i class="pi pi-file-arrow-down mr-1"></i> {{ slotProps.data.fileName }}
                                    </a>
                                </span>
                                <span v-else class="text-500 text-sm">ไม่มีไฟล์</span>
                            </template>
                        </Column>
                        <Column field="documentLink" header="ลิงก์เอกสาร" class="text-center" style="width: 10%;">
                            <template #body="slotProps">
                                <a v-if="slotProps.data.documentLink" :href="slotProps.data.documentLink" target="_blank" class="p-button p-component p-button-link text-sm flex items-center justify-center">
                                    <i class="pi pi-external-link mr-1"></i> เปิดลิงก์
                                </a>
                                <span v-else class="text-500 text-sm">ไม่มีลิงก์</span>
                            </template>
                        </Column>
                        <Column field="status" header="สถานะ" class="text-center" style="width: 15%;">
                            <template #body="slotProps">
                                <Tag
                                    :value="getStatusLabel(slotProps.data.status)"
                                    :severity="getStatusSeverity(slotProps.data.status)"
                                    class="p-tag-rounded p-tag-sm font-bold"
                                />
                            </template>
                        </Column>
                        <Column field="actions" header="จัดการ" headerStyle="text-align: center;" bodyStyle="text-align: center;" style="width: 10%;">
                            <template #body="slotProps">
                                <Button
                                    icon="pi pi-ellipsis-v"
                                    class="p-button-text p-button-secondary p-button-rounded p-button-sm"
                                    @click="toggleOptionsMenu($event, slotProps.data)"
                                    aria-haspopup="true"
                                    aria-controls="overlay_menu"
                                />
                            </template>
                        </Column>
                    </DataTable>
                    <Menu ref="optionsMenu" :model="taskMenuItems" :popup="true" id="overlay_menu" />
                    <ConfirmDialog></ConfirmDialog>
                </div>
            </div>
        </div>

        <Dialog v-model:visible="showPlanDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top" class="p-dialog-lg">
            <template #header>
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center w-full gap-4">
                    <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                        <i class="pi pi-calendar-plus mr-2 text-primary-500"></i>
                        บันทึกแผนปฏิบัติงาน
                    </h5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <div class="text-right text-sm text-gray-600">
                        <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                        <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                    </div>
                </div>
            </template>
            <form @submit.prevent="savePlan" class="p-fluid grid form-layout">
                <div class="field col-12 md:col-4">
                    <label for="evaluation_round_plan" class="font-semibold text-color-secondary">รอบประเมิน <span class="text-red-500">*</span></label>
                    <Dropdown
                        id="evaluation_round_plan"
                        v-model="newPlan.evaluationRound"
                        :options="evaluationRounds"
                        optionLabel="label"
                        optionValue="value"
                        placeholder="เลือกรอบประเมิน"
                        class="w-full"
                        required
                    />
                </div>
                <div class="field col-12 md:col-4">
                    <label for="start_date_plan" class="font-semibold text-color-secondary">วันที่เริ่มต้นแผน <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar
                            id="start_date_plan"
                            v-model="newPlan.startDate"
                            dateFormat="dd/mm/yy"
                            placeholder="วัน/เดือน/ปี เวลา"
                            showIcon
                            showTime
                            hourFormat="24"
                            class="w-full"
                            required
                        />
                    </InputGroup>
                </div>
                <div class="field col-12 md:col-4">
                    <label for="end_date_plan" class="font-semibold text-color-secondary">วันที่สิ้นสุดแผน <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar
                            id="end_date_plan"
                            v-model="newPlan.endDate"
                            dateFormat="dd/mm/yy"
                            placeholder="วัน/เดือน/ปี เวลา"
                            showIcon
                            showTime
                            hourFormat="24"
                            class="w-full"
                        />
                    </InputGroup>
                </div>

                <div class="field col-12 ">
                    <label for="plan_name_item" class="font-semibold text-color-secondary">
                        ชื่อแผนปฎิบัติงาน <span class="text-red-500">*</span>
                    </label>

                    <div class="formgrid grid">
                        <div class="field col-12 md:col-2">
                            <InputGroup>
                                <InputText v-model="newPlanItem.order" type="number"  placeholder="ลำดับ" autocomplete="off" class="w-full" max="10" min = "0"/>
                            </InputGroup>
                        </div>
                        <div class="field col-9">
                            <InputGroup>
                                <InputText v-model="newPlanItem.name" type="text" placeholder="ระบุชื่อแผนปฎิบัติงานย่อย" autocomplete="off" class="w-full " />
                            </InputGroup>
                        </div>
                        <div class="field col-1">
                             <InputGroup>
                                <Button  icon="pi pi-plus" label="เพิ่ม" severity="warning"  class="p-button-sm" @click="addPlanItemToList" />
                            </InputGroup>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <DataTable :value="newPlan.planItems" :rows="5" :paginator="true" responsiveLayout="scroll" dataKey="id" class="p-datatable-sm">
                        <Column field="order" header="ลำดับ" style="width: 15%" class="text-center"></Column>
                        <Column field="name" header="ชื่อแผนปฎิบัติงาน" style="text-align: left;width: 70%"></Column>
                        <Column field="options" header="ตัวเลือก" style="text-align: center; width: 15%">
                            <template #body="Item">
                                <Button icon="pi pi-pencil" class="p-button-text p-button-primary p-button-rounded p-button-sm" @click="editPlanItem(Item.data)" v-tooltip.top="'แก้ไข'"></Button>&nbsp;
                                <Button icon="pi pi-trash" class="p-button-danger p-button-rounded p-button-sm" @click="deletePlanItem(Item.data.id)" v-tooltip.top="'ลบ'"></Button>
                            </template>
                        </Column>
                    </DataTable>
                </div>
            </form>
            <template #footer>
                <Button label="บันทึกแผน" icon="pi pi-save" class="p-button-success p-button-sm mr-2" @click="savePlan" />
                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-sm" @click="closePlanDialog" />
            </template>
        </Dialog>

        <Dialog v-model:visible="showTaskDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top" class="p-dialog-lg">
            <template #header>
                <div class="flex justify-between items-center w-full">
                    <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                        <i class="pi pi-calendar-check mr-2 text-primary-500"></i> บันทึกภาระงานประจำวัน
                    </h5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <div class="text-right text-sm text-gray-600">
                        <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                        <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                    </div>
                </div>
            </template>
            <form @submit.prevent="saveDailyTask" class="p-fluid grid form-layout">
                <div class="field col-12 md:col-4">
                    <label for="selected_plan_for_task" class="font-semibold text-color-secondary">แผนปฏิบัติงาน<span class="text-red-500">*</span></label>
                    <Dropdown
                        id="selected_plan_for_task"
                        v-model="newTask.planId"  :options="planOptions"
                        optionLabel="label"
                        optionValue="value"
                        placeholder="เลือกแผนปฎิบัติงาน"
                        class="w-full"
                        required
                    />
                </div>
                <div class="field col-12 md:col-4">
                    <label for="evaluation_round_task" class="font-semibold text-color-secondary">รอบประเมิน <span class="text-red-500">*</span></label>
                    <Dropdown
                        id="evaluation_round_task"
                        v-model="newTask.evaluationRound"
                        :options="evaluationRounds"
                        optionLabel="label"
                        optionValue="value"
                        placeholder="เลือกรอบประเมิน"
                        class="w-full"
                        required
                    />
                </div>
                <div class="field col-12 md:col-4">
                    <label for="task_date" class="font-semibold text-color-secondary">วันที่ลงบันทึก <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <InputText :value="formatDate(newTask.recordDate)" disabled class="w-full" />
                    </InputGroup>
                </div>

                <div class="field col-12 md:col-4">
                    <label for="end_date_task" class="font-semibold text-color-secondary">วันที่กำหนดเสร็จ <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar
                            id="end_date_task"
                            v-model="newTask.dueDate"
                            dateFormat="dd/mm/yy"
                            placeholder="วัน/เดือน/ปี เวลา"
                            showIcon
                            showTime
                            hourFormat="24"
                            class="w-full"
                            required
                        />
                    </InputGroup>
                </div>
                <div class="field col-12 md:col-4">
                    <label for="acomp_date_task" class="font-semibold text-color-secondary">วันที่เสร็จจริง</label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-calendar"></i></InputGroupAddon>
                        <Calendar
                            id="acomp_date_task"
                            v-model="newTask.completionDate"
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
                    <label for="file_upload_task" class="font-semibold text-color-secondary">ไฟล์เอกสาร <span class="text-red-500 text-xs">(ถ้ามี)</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-paperclip"></i></InputGroupAddon>
                       <input
                            id="file_upload_task"
                            type="file"
                            multiple
                            @change="onFileChange"
                            class="w-full border-1 surface-border border-round p-2"
                            ref="fileInputRef"
                        />
                    </InputGroup>
                    <small v-if="newTask.fileName && !newTask.selectedFile" class="text-600 ml-2 mt-1">ไฟล์เดิม: {{ newTask.fileName }}</small>
                </div>

                <div class="field col-12 md:col-4">
                    <label for="document_link_task" class="font-semibold text-color-secondary">ลิงก์เอกสาร <span class="text-red-500 text-xs">(ถ้ามี)</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-link"></i></InputGroupAddon>
                        <InputText
                            id="document_link_task"
                            v-model="newTask.documentLink"
                            type="text"
                            placeholder="วางลิงก์เอกสาร เช่น https://..."
                            autocomplete="off"
                        />
                    </InputGroup>
                </div>
                <div class="field col-12 md:col-8">
                    <label for="daily_task_description" class="font-semibold text-color-secondary">ภาระงานประจำวัน <span class="text-red-500">*</span></label>
                    <InputGroup>
                        <InputGroupAddon><i class="pi pi-pencil"></i></InputGroupAddon>
                        <Textarea
                            id="daily_task_description"
                            v-model="newTask.description"
                            rows="3"
                            placeholder="ระบุภาระงานประจำวัน..."
                            autoResize
                            class="w-full"
                            required
                        />
                    </InputGroup>
                </div>
            </form>
            <template #footer>
                <Button label="บันทึก" icon="pi pi-check" class="p-button-success p-button-sm mr-2 font-semibold" @click="saveDailyTask" />
                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-sm font-semibold" @click="closeTaskDialog" />
            </template>
        </Dialog>

        <Dialog v-model:visible="showTaskDetailDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top" class="p-dialog-md">
            <template #header>
                <h5 class="m-0 text-2xl font-bold text-primary-700 flex items-center">
                    <i class="pi pi-info-circle mr-2 text-primary-500"></i> รายละเอียดภาระงาน
                </h5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <div class="text-right text-sm text-gray-600">
                    <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                    <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                </div>
            </template>
            <div class="p-fluid grid form-detail-layout" v-if="selectedTaskDetail">
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">แผนปฏิบัติงาน:</strong> {{ getPlanLabelById(selectedTaskDetail.planId) }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">รอบประเมิน:</strong> <Tag :value="selectedTaskDetail.evaluationRound" class="p-tag-info font-medium"></Tag></p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">วันที่ลงบันทึก:</strong> {{ formatDate(selectedTaskDetail.recordDate) }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">วันที่กำหนดเสร็จ:</strong> {{ formatDate(selectedTaskDetail.dueDate) }}</p>
                </div>

                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">วันที่เสร็จจริง:</strong> {{ selectedTaskDetail.completionDate && selectedTaskDetail.completionDate !== '0000-00-00 00:00:00' ? formatDate(selectedTaskDetail.completionDate) : 'ยังไม่ระบุ' }}</p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">ใช้เวลาทั้งหมด:</strong>&nbsp;
                        <span v-if="selectedTaskDetail.totalTimeDisplay">
                        {{ selectedTaskDetail.totalTimeDisplay }}
                        </span>
                        <span v-else class="text-500">ยังไม่เสร็จสิ้น/ไม่ระบุเวลา</span>
                    </p>
                </div>
                 <div class="col-6">
                    <p class="detail-item"><strong class="label-text">ภาระงาน:</strong> {{ selectedTaskDetail.description }}</p>
                </div>

                <div class="col-12 md:col-6">
                    <p class="detail-item"><strong class="label-text">ไฟล์เอกสาร:</strong>
                        <span v-if="selectedTaskDetail.fileName">
                            <a :href="getFileUrl(selectedTaskDetail.filePath)" target="_blank" class="p-button p-component p-button-link p-button-sm flex items-center">
                                <i class="pi pi-file-arrow-down mr-1"></i> {{ selectedTaskDetail.fileName }}
                            </a>
                        </span>
                        <span v-else class="text-500">ไม่มีไฟล์</span>
                    </p>
                </div>
                <div class="col-12 md:col-4">
                    <p class="detail-item"><strong class="label-text">ลิงก์เอกสาร:</strong>
                        <a v-if="selectedTaskDetail.documentLink" :href="selectedTaskDetail.documentLink" target="_blank" class="p-button p-component p-button-link p-button-sm flex items-center">
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

                <div class="col-4">
                    <p class="detail-item"><strong class="label-text">สถานะ:</strong> &nbsp;
                        <Tag
                            :value="getStatusLabel(selectedTaskDetail.status)"
                            :severity="getStatusSeverity(selectedTaskDetail.status)"
                            class="p-tag-rounded p-tag-sm font-bold"
                        />
                    </p>
                </div>
            </div>
            <template #footer>
                <Button label="ปิด" icon="pi pi-times" class="p-button-warning  p-button-sm font-semibold" @click="showTaskDetailDialog = false" />
            </template>
        </Dialog>

        <Dialog v-model:visible="showDeletePlanOptionsDialog" :breakpoints="{ '960px': '75vw' }" :style="{ width: '40vw' }" :modal="true" header="ยืนยันการลบแผน" position="center">
            <div class="p-fluid">
                <p class="mb-4">คุณต้องการลบแผนปฏิบัติงานนี้อย่างไร?</p>
                <div class="field-radiobutton mb-3">
                    <RadioButton id="delete_all" name="deleteOption" value="delete_all" v-model="deletePlanOption" />
                    <label for="delete_all" class="ml-2">ลบแผนนี้และภาระงานทั้งหมดที่เกี่ยวข้อง</label>
                </div>
                <div class="field-radiobutton">
                    <RadioButton id="keep_tasks" name="deleteOption" value="keep_tasks" v-model="deletePlanOption" />
                    <label for="keep_tasks" class="ml-2">ลบเฉพาะแผนนี้ แต่เก็บภาระงานที่เคยผูกไว้ (ภาระงานจะไม่มีแผนรองรับ)</label>
                </div>
            </div>
            <template #footer>
                <Button label="ยืนยัน" icon="pi pi-check" class="p-button-danger p-button-sm mr-2 font-semibold" @click="processDeletePlan" />
                <Button label="ยกเลิก" icon="pi pi-times" class="p-button-secondary p-button-sm font-semibold" @click="showDeletePlanOptionsDialog = false" />
            </template>
        </Dialog>

    </div>
</template> 

<script setup>
    import { ref, reactive, computed, onMounted, watch } from 'vue';
    import { useAuth } from '#imports';
    import axios from 'axios';  
    import Swal from 'sweetalert2';
    import { useConfirm } from "primevue/useconfirm";  
    import Tag from 'primevue/tag';
    import Tooltip from 'primevue/tooltip';
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

    const vTooltip = Tooltip;
 
    const { getSession } = await useAuth();
    const user = ref(null);
    const confirm = useConfirm();  

    onMounted(async () => {
        user.value = await getSession();
        fetchPlans();
        fetchDailyTasks();
    }); 
    const showPlanDialog = ref(false);
    const showEditPlanDialog = ref(false);
    const plans = ref([]);
    const newPlan = reactive({
        id: null,
        evaluationRound: null,
        startDate: null,
        endDate: null,
        planItems: []
    });
    const newPlanItem = reactive({
        id: null,
        order: null,
        name: ''
    });
    const editingPlanItemId = ref(null);

    const selectedPlanId = ref(null);

    const editPlanForm = reactive({
        id: null,
        planLabel: '',
        startDate: null,
        endDate: null,
        planItems: []
    });

    const planOptions = computed(() => {
        const validPlans = plans.value.filter(plan =>
            plan.planItems && plan.planItems.length > 0 && plan.planItems.some(item => item.name)
        );
        return validPlans.map(plan => ({
            label: plan.planItems[0]?.name || `แผนที่ ${plan.id}`,
            value: plan.id
        }));
    });

    watch(selectedPlanId, (newVal) => {
        if (newVal) {
            newTask.planId = newVal;
            console.log('watch(selectedPlanId): newTask.planId updated to', newVal);
        }
    }, { immediate: true }); 
    const showDeletePlanOptionsDialog = ref(false);
    const planToDeleteId = ref(null);
    const deletePlanOption = ref('delete_all');  

    const showTaskDialog = ref(false);
    const showTaskDetailDialog = ref(false);
    const dailyTasks = ref([]);
    const newTask = reactive({
        id: null,
        planId: null,
        evaluationRound: null,
        recordDate: new Date(),
        dueDate: null,
        completionDate: null,
        documentLink: '',
        description: '',
        selectedFile: null,
        base64FileContent: null,
        fileName: '',
        filePath: '',
        status: 'in_progress',
        recorderName: '',
        recorderDepartment: ''
    });
    const selectedTaskDetail = ref(null);
    const fileInputRef = ref(null);

    const filteredDailyTasks = computed(() => {
        if (!selectedPlanId.value) {
            return [];
        }
        console.log('Filtering tasks for planId:', selectedPlanId.value);
        return dailyTasks.value.filter(task => task.planId === selectedPlanId.value);
    });

    const taskMenuItems = ref([
        { label: 'ดูรายละเอียด', icon: 'pi pi-eye', command: () => viewTaskDetail() },
        { label: 'แก้ไข', icon: 'pi pi-pencil', command: () => editTask() },
        { label: 'ลบ', icon: 'pi pi-trash', command: () => confirmDeleteTask() }
    ]);
    const currentSelectedTask = ref(null); 
    const evaluationRounds = ref([
        { label: 'รอบที่ 1', value: 'รอบที่ 1' },
        { label: 'รอบที่ 2', value: 'รอบที่ 2' },
    ]); 
    const formatDate = (dateString) => {
        if (!dateString) return '';
        const date = new Date(dateString);
        if (isNaN(date.getTime())) return '';
        return date.toLocaleDateString('th-TH', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
    };

    const getFileUrl = (filePath) => {
        return `/uploads/tasks/${filePath}`;
    };

    const getPlanLabelById = (planId) => {
        const plan = plans.value.find(p => p.id === planId);
        return plan && plan.planItems && plan.planItems.length > 0 && plan.planItems[0].name ? plan.planItems[0].name : 'ไม่พบแผน';
    };

    const getStatusLabel = (status) => {
        switch (status) {
            case 'in_progress': return 'กำลังดำเนินการ';
            case 'completed': return 'เสร็จสิ้น';
            case 'overdue': return 'เลยกำหนด';
            default: return 'ไม่ระบุ';
        }
    };

    const getStatusSeverity = (status) => {
        switch (status) {
            case 'in_progress': return 'warning';
            case 'completed': return 'success';
            case 'overdue': return 'danger';
            default: return 'contrast';
        }
    };
    const getPlanDateRange = (planId) => {
        const plan = plans.value.find(p => p.id === planId);
        if (plan && plan.startDate && plan.endDate) {
            const startDateObj = typeof plan.startDate === 'string' ? new Date(plan.startDate) : plan.startDate;
            const endDateObj = typeof plan.endDate === 'string' ? new Date(plan.endDate) : plan.endDate;

            const start = startDateObj.toLocaleDateString('th-TH', { day: '2-digit', month: '2-digit', year: 'numeric' });
            const end = endDateObj.toLocaleDateString('th-TH', { day: '2-digit', month: '2-digit', year: 'numeric' });
            return `${start} ถึง ${end}`;
        }
        return '';
    }; 
    const openPlanDialog = (planToEdit = null) => {
        resetPlanForm();
        if (planToEdit) {
            newPlan.id = planToEdit.id;
            newPlan.evaluationRound = planToEdit.evaluationRound;
            newPlan.startDate = planToEdit.startDate ? new Date(planToEdit.startDate) : null;
            newPlan.endDate = planToEdit.endDate ? new Date(planToEdit.endDate) : null;
            newPlan.planItems = JSON.parse(JSON.stringify(planToEdit.planItems || []));
        }
        showPlanDialog.value = true;
    };

    const closePlanDialog = () => {
        showPlanDialog.value = false;
        resetPlanForm();
    };

    const resetPlanForm = () => {
        newPlan.id = null;
        newPlan.evaluationRound = null;
        newPlan.startDate = null;
        newPlan.endDate = null;
        newPlan.planItems = [];
        resetPlanItemForm();
        editingPlanItemId.value = null;
    };

    const resetPlanItemForm = () => {
        newPlanItem.id = null;
        newPlanItem.order = null;
        newPlanItem.name = '';
    };

    const addPlanItemToList = () => {
        if (!newPlanItem.name || newPlanItem.order === null || newPlanItem.order === '') {
            Swal.fire('ข้อผิดพลาด', 'กรุณาระบุลำดับและชื่อแผนปฎิบัติงานย่อย', 'error');
            return;
        }

        if (editingPlanItemId.value) {
            const index = newPlan.planItems.findIndex(item => item.id === editingPlanItemId.value);
            if (index !== -1) {
                newPlan.planItems[index].order = newPlanItem.order;
                newPlan.planItems[index].name = newPlanItem.name;
            }
            editingPlanItemId.value = null;
        } else {
            const newId = newPlan.planItems.length > 0 ? Math.max(...newPlan.planItems.map(item => item.id || 0)) + 1 : 1;
            newPlan.planItems.push({
                id: newId,
                order: newPlanItem.order,
                name: newPlanItem.name
            });
        }
        resetPlanItemForm();
    };

    const editPlanItem = (item) => {
        editingPlanItemId.value = item.id;
        newPlanItem.id = item.id;
        newPlanItem.order = item.order;
        newPlanItem.name = item.name;
    };

    const deletePlanItem = (id) => {
        newPlan.planItems = newPlan.planItems.filter(item => item.id !== id);
        resetPlanItemForm();
    };

    const savePlan = async () => {
        if (!newPlan.evaluationRound || !newPlan.startDate || !newPlan.endDate || newPlan.planItems.length === 0) {
            Swal.fire('ข้อผิดพลาด', 'กรุณากรอกข้อมูลแผนให้ครบถ้วนและเพิ่มรายการแผนปฎิบัติงานย่อยอย่างน้อย 1 รายการ', 'error');
            return;
        }
        if (newPlan.endDate < newPlan.startDate) {
            Swal.fire('ข้อผิดพลาด', 'วันที่สิ้นสุดต้องไม่น้อยกว่าวันที่เริ่มต้น', 'error');
            return;
        }

        try {
            if (newPlan.id) {
                const index = plans.value.findIndex(p => p.id === newPlan.id);
                if (index !== -1) {
                    plans.value[index] = {
                        ...newPlan,
                        startDate: newPlan.startDate ? newPlan.startDate.toISOString() : null,
                        endDate: newPlan.endDate ? newPlan.endDate.toISOString() : null,
                    };
                }
                Swal.fire('สำเร็จ', 'แก้ไขแผนปฎิบัติงานเรียบร้อยแล้ว', 'success');
            } else {
                const newId = plans.value.length > 0 ? Math.max(...plans.value.map(p => p.id)) + 1 : 1;
                const planToAdd = {
                    ...newPlan,
                    id: newId,
                    startDate: newPlan.startDate ? newPlan.startDate.toISOString() : null,
                    endDate: newPlan.endDate ? newPlan.endDate.toISOString() : null,
                    recorderName: user.value?.user?.name?.STAFFNAME + ' ' + user.value?.user?.name?.STAFFSURNAME,
                    recorderDepartment: user.value?.user?.name?.SCOPES?.staffdepartmentname,
                };
                plans.value.push(planToAdd);
                selectedPlanId.value = newId;
                Swal.fire('สำเร็จ', 'บันทึกแผนปฎิบัติงานเรียบร้อยแล้ว', 'success');
            }
            closePlanDialog();
        } catch (error) {
            console.error('Error saving plan:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการบันทึกแผนปฎิบัติงาน', 'error');
        }
    };

    const fetchPlans = async () => {
        try {
            if (plans.value.length === 0) {
                plans.value = [
                    {
                        id: 1,
                        evaluationRound: 'รอบที่ 1',
                        startDate: new Date('2024-01-01T08:00:00').toISOString(),
                        endDate: new Date('2024-03-31T17:00:00').toISOString(),
                        planItems: [
                            { id: 101, order: 1, name: 'แผนงานพัฒนาเว็บไซต์เฟส 1' },
                            { id: 102, order: 2, name: 'แผนงานปรับปรุงระบบฐานข้อมูล' }
                        ],
                        recorderName: 'นาย AAA',
                        recorderDepartment: 'แผนก IT'
                    },
                    {
                        id: 2,
                        evaluationRound: 'รอบที่ 2',
                        startDate: new Date('2024-04-01T08:00:00').toISOString(),
                        endDate: new Date('2024-06-30T17:00:00').toISOString(),
                        planItems: [
                            { id: 201, order: 1, name: 'แผนงานปรับปรุงระบบ' }
                        ],
                        recorderName: 'นาย BBB',
                        recorderDepartment: 'แผนกบุคคล'
                    }
                ];
            }
            if (!selectedPlanId.value && plans.value.length > 0) {
                selectedPlanId.value = plans.value[0].id;
                console.log('Initial selectedPlanId set to:', selectedPlanId.value);
            }
        } catch (error) {
            console.error('Error fetching plans:', error);
            Swal.fire('ข้อผิดพลาด', 'ไม่สามารถดึงข้อมูลแผนปฎิบัติงานได้', 'error');
        }
    };

    const openEditPlanDialog = (planId) => {
        const planToEdit = plans.value.find(p => p.id === planId);
        if (planToEdit) {
            editPlanForm.id = planToEdit.id;
            editPlanForm.planLabel = planToEdit.planItems[0]?.name || '';
            editPlanForm.startDate = planToEdit.startDate ? new Date(planToEdit.startDate) : null;
            editPlanForm.endDate = planToEdit.endDate ? new Date(planToEdit.endDate) : null;
            editPlanForm.planItems = JSON.parse(JSON.stringify(planToEdit.planItems || []));
            showEditPlanDialog.value = true;
        } else {
            Swal.fire('ข้อผิดพลาด', 'ไม่พบแผนที่ต้องการแก้ไข', 'error');
        }
    };

    const saveEditedPlan = async () => {
        if (!editPlanForm.planLabel.trim()) {
            Swal.fire('ข้อผิดพลาด', 'กรุณาระบุชื่อแผนใหม่', 'error');
            return;
        }
        if (!editPlanForm.startDate) {
            Swal.fire('ข้อผิดพลาด', 'กรุณาระบุวันที่เริ่มต้นแผน', 'error');
            return;
        }
        if (editPlanForm.endDate && editPlanForm.startDate && editPlanForm.endDate < editPlanForm.startDate) {
            Swal.fire('ข้อผิดพลาด', 'วันที่สิ้นสุดต้องไม่น้อยกว่าวันที่เริ่มต้น', 'error');
            return;
        }

        try {
            const planToUpdate = plans.value.find(p => p.id === editPlanForm.id);
            if (planToUpdate) {
                if (planToUpdate.planItems.length > 0) {
                    planToUpdate.planItems[0].name = editPlanForm.planLabel.trim();
                } else {
                    planToUpdate.planItems = [{ id: 1, order: 1, name: editPlanForm.planLabel.trim() }];
                }
                planToUpdate.startDate = editPlanForm.startDate ? editPlanForm.startDate.toISOString() : null;
                planToUpdate.endDate = editPlanForm.endDate ? editPlanForm.endDate.toISOString() : null;

                Swal.fire('สำเร็จ', 'แก้ไขแผนและวันที่เรียบร้อยแล้ว', 'success');
                showEditPlanDialog.value = false;
            } else {
                Swal.fire('ข้อผิดพลาด', 'ไม่พบแผนที่ต้องการแก้ไข', 'error');
            }
        } catch (error) {
            console.error('Error saving edited plan:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการแก้ไขแผน', 'error');
        }
    }; 
    const confirmDeletePlan = (planId) => {
        planToDeleteId.value = planId;
        deletePlanOption.value = 'delete_all';  
        showDeletePlanOptionsDialog.value = true;
    }; 
    const processDeletePlan = () => {
        const planId = planToDeleteId.value;
        if (!planId) return;

        if (deletePlanOption.value === 'delete_all') {
             
            deletePlanAndRelatedTasks(planId);
        } else if (deletePlanOption.value === 'keep_tasks') { 
            deletePlanOnlyAndUnlinkTasks(planId);
        }
        showDeletePlanOptionsDialog.value = false;
        planToDeleteId.value = null;
    }; 
    const deletePlanAndRelatedTasks = async (planId) => {
        try {
            plans.value = plans.value.filter(p => p.id !== planId);
            dailyTasks.value = dailyTasks.value.filter(task => task.planId !== planId);
            Swal.fire('สำเร็จ', 'ลบแผนและภาระงานทั้งหมดที่เกี่ยวข้องเรียบร้อยแล้ว', 'success'); 
            if (selectedPlanId.value === planId) {
                selectedPlanId.value = plans.value.length > 0 ? plans.value[0].id : null;
            }
        } catch (error) {
            console.error('Error deleting plan and related tasks:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการลบแผนและภาระงาน', 'error');
        }
    }; 
    const deletePlanOnlyAndUnlinkTasks = async (planId) => {
        try {
            plans.value = plans.value.filter(p => p.id !== planId); 
            dailyTasks.value = dailyTasks.value.map(task => {
                if (task.planId === planId) {
                    return { ...task, planId: null };  
                }
                return task;
            });
            Swal.fire('สำเร็จ', 'ลบแผนเรียบร้อยแล้ว และภาระงานถูกยกเลิกการผูก', 'success');

            if (selectedPlanId.value === planId) {
                selectedPlanId.value = plans.value.length > 0 ? plans.value[0].id : null;
            }
        } catch (error) {
            console.error('Error deleting plan and unlinking tasks:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการลบแผน', 'error');
        }
    };

    // #endregion

    // #region Task Management Functions
    const openTaskDialog = (taskToEdit = null) => {
        console.log('openTaskDialog called with taskToEdit:', taskToEdit);

        if (!taskToEdit && !selectedPlanId.value) {
            Swal.fire('แจ้งเตือน', 'กรุณาเลือกแผนปฎิบัติงานก่อนเพิ่มภาระงาน', 'info');
            return;
        }

        resetTaskForm();

        if (taskToEdit) {
            newTask.id = taskToEdit.id;
            newTask.planId = taskToEdit.planId;
            newTask.evaluationRound = taskToEdit.evaluationRound;
            newTask.recordDate = taskToEdit.recordDate ? new Date(taskToEdit.recordDate) : new Date();
            newTask.dueDate = taskToEdit.dueDate ? new Date(taskToEdit.dueDate) : null;
            newTask.completionDate = taskToEdit.completionDate && taskToEdit.completionDate !== '0000-00-00 00:00:00' ? new Date(taskToEdit.completionDate) : null;
            newTask.documentLink = taskToEdit.documentLink;
            newTask.description = taskToEdit.description;
            newTask.fileName = taskToEdit.fileName;
            newTask.filePath = taskToEdit.filePath;
            newTask.status = taskToEdit.status;
            newTask.recorderName = taskToEdit.recorderName;
            newTask.recorderDepartment = taskToEdit.recorderDepartment;

            newTask.selectedFile = null;
            if (fileInputRef.value) {
                fileInputRef.value.value = '';
            }

            console.log('Loaded task data into newTask (for editing):', { ...newTask });
        } else {
            newTask.planId = selectedPlanId.value;
            newTask.recordDate = new Date();
            newTask.recorderName = user.value?.user?.name?.PREFIXFULLNAME + ' ' + user.value?.user?.name?.STAFFNAME + ' ' + user.value?.user?.name?.STAFFSURNAME;
            newTask.recorderDepartment = user.value?.user?.name?.SCOPES?.staffdepartmentname;
        }
        showTaskDialog.value = true;
    };

    const closeTaskDialog = () => {
        showTaskDialog.value = false;
        resetTaskForm();
    };

    const resetTaskForm = () => {
        newTask.id = null;
        newTask.planId = selectedPlanId.value;
        newTask.evaluationRound = null;
        newTask.recordDate = new Date();
        newTask.dueDate = null;
        newTask.completionDate = null;
        newTask.documentLink = '';
        newTask.description = '';
        newTask.selectedFile = null;
        newTask.base64FileContent = null;
        newTask.fileName = '';
        newTask.filePath = '';
        newTask.status = 'in_progress';
        newTask.recorderName = '';
        newTask.recorderDepartment = '';
        if (fileInputRef.value) {
            fileInputRef.value.value = '';
        }
    };


    const onFileChange = (event) => {
        const files = event.target.files;
        if (files.length > 0) {
            newTask.selectedFile = files[0];
            newTask.fileName = files[0].name;
        } else {
            newTask.selectedFile = null;
            newTask.fileName = '';
            newTask.base64FileContent = null;
        }
    };

    const saveDailyTask = async () => {
        console.log('--- saveDailyTask Debug ---');
        console.log('newTask.id (for update):', newTask.id);
        console.log('newTask.planId:', newTask.planId);
        console.log('newTask.evaluationRound:', newTask.evaluationRound);
        console.log('newTask.dueDate:', newTask.dueDate);
        console.log('newTask.description:', newTask.description);
        console.log('--- End Debug ---');
        if (!newTask.planId || !newTask.evaluationRound || !newTask.dueDate || !newTask.description.trim()) {
            Swal.fire('ข้อผิดพลาด', 'กรุณากรอกข้อมูลภาระงานให้ครบถ้วน', 'error');
            return;
        }

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const dueDate = new Date(newTask.dueDate);
        dueDate.setHours(0, 0, 0, 0);

        let calculatedStatus = 'in_progress';
        if (newTask.completionDate) {
            calculatedStatus = 'completed';
        } else if (dueDate < today) {
            calculatedStatus = 'overdue';
        }
        newTask.status = calculatedStatus;

        const taskDataToSave = {
            ...newTask,
            recordDate: newTask.recordDate ? newTask.recordDate.toISOString() : null,
            dueDate: newTask.dueDate ? newTask.dueDate.toISOString() : null,
            completionDate: newTask.completionDate ? newTask.completionDate.toISOString() : null,
            selectedFile: undefined,
            base64FileContent: undefined,
        };

        try {
            if (newTask.id) {
                const index = dailyTasks.value.findIndex(t => t.id === newTask.id);
                if (index !== -1) {
                    Object.assign(dailyTasks.value[index], taskDataToSave);
                }
                Swal.fire('สำเร็จ', 'แก้ไขภาระงานประจำวันเรียบร้อยแล้ว', 'success');
            } else {
                const newId = dailyTasks.value.length > 0 ? Math.max(...dailyTasks.value.map(t => t.id)) + 1 : 1;
                dailyTasks.value.push({ ...taskDataToSave, id: newId });
                Swal.fire('สำเร็จ', 'บันทึกภาระงานประจำวันเรียบร้อยแล้ว', 'success');
            }
            closeTaskDialog();
        } catch (error) {
            console.error('Error saving daily task:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการบันทึกภาระงานประจำวัน', 'error');
        }
    };

    const fetchDailyTasks = async () => {
        try {
            if (dailyTasks.value.length === 0) {
                dailyTasks.value = [
                    {
                        id: 1,
                        planId: 1,
                        evaluationRound: 'รอบที่ 1',
                        recordDate: new Date('2024-03-10T10:00:00').toISOString(),
                        dueDate: new Date('2024-03-15T17:00:00').toISOString(),
                        completionDate: null,
                        documentLink: 'https://docs.google.com/document/d/12345',
                        description: 'จัดทำเอกสารสรุปความคืบหน้าโครงการ',
                        fileName: 'report_march.pdf',
                        filePath: 'report_march.pdf',
                        status: 'in_progress',
                        recorderName: 'สมชาย รักดี',
                        recorderDepartment: 'แผนก IT',
                        totalTimeDisplay: ''
                    },
                    {
                        id: 2,
                        planId: 1,
                        evaluationRound: 'รอบที่ 1',
                        recordDate: new Date('2024-03-05T09:00:00').toISOString(),
                        dueDate: new Date('2024-03-08T17:00:00').toISOString(),
                        completionDate: new Date('2024-03-07T16:30:00').toISOString(),
                        documentLink: '',
                        description: 'ประชุมทีมเพื่อวางแผนงานเฟสต่อไป',
                        fileName: '',
                        filePath: '',
                        status: 'completed',
                        recorderName: 'สมชาย รักดี',
                        recorderDepartment: 'แผนก IT',
                        totalTimeDisplay: '2 วัน 7 ชั่วโมง'
                    },
                    {
                        id: 3,
                        planId: 2,
                        evaluationRound: 'รอบที่ 2',
                        recordDate: new Date('2024-04-01T11:00:00').toISOString(),
                        dueDate: new Date('2024-04-05T17:00:00').toISOString(),
                        completionDate: null,
                        documentLink: 'https://jira.example.com/browse/PROJ-456',
                        description: 'เตรียมเนื้อหาสำหรับการอบรมพนักงานใหม่',
                        fileName: '',
                        filePath: '',
                        status: 'in_progress',
                        recorderName: 'สมหญิง ใจดี',
                        recorderDepartment: 'แผนกบุคคล',
                        totalTimeDisplay: ''
                    },
                    {
                        id: 4,
                        planId: 1,
                        evaluationRound: 'รอบที่ 1',
                        recordDate: new Date('2024-03-01T09:00:00').toISOString(),
                        dueDate: new Date('2024-03-03T17:00:00').toISOString(),
                        completionDate: null,
                        documentLink: '',
                        description: 'ตรวจสอบความปลอดภัยของระบบ',
                        fileName: '',
                        filePath: '',
                        status: 'overdue',
                        recorderName: 'สมชาย รักดี',
                        recorderDepartment: 'แผนก IT',
                        totalTimeDisplay: ''
                    }
                ];
            }

            dailyTasks.value.forEach(task => {
                const today = new Date();
                today.setHours(0, 0, 0, 0);

                const dueDate = new Date(task.dueDate);
                dueDate.setHours(0, 0, 0, 0);

                if (task.completionDate && task.completionDate !== '0000-00-00 00:00:00') {
                    task.status = 'completed';
                } else if (dueDate < today) {
                    task.status = 'overdue';
                } else {
                    task.status = 'in_progress';
                }
            });

        } catch (error) {
            console.error('Error fetching daily tasks:', error);
            Swal.fire('ข้อผิดพลาด', 'ไม่สามารถดึงข้อมูลภาระงานประจำวันได้', 'error');
        }
    };

    const toggleOptionsMenu = (event, task) => {
        currentSelectedTask.value = task;
        console.log('Task selected via toggleOptionsMenu (currentSelectedTask):', currentSelectedTask.value);
        taskMenuItems.value = [
            { label: 'ดูรายละเอียด', icon: 'pi pi-eye', command: () => viewTaskDetail() },
            { label: 'แก้ไข', icon: 'pi pi-pencil', command: () => editTask() },
            { label: 'ลบ', icon: 'pi pi-trash', command: () => confirmDeleteTask() }
        ];
        optionsMenu.value.toggle(event);
    };

    const viewTaskDetail = () => {
        selectedTaskDetail.value = currentSelectedTask.value;
        showTaskDetailDialog.value = true;
    };

    const editTask = () => {
        console.log('Calling editTask. currentSelectedTask.value before opening dialog:', currentSelectedTask.value);
        openTaskDialog(currentSelectedTask.value);
    }; 
    const confirmDeleteTask = () => {  
        confirm.require({
            message: 'คุณแน่ใจหรือไม่ว่าต้องการลบภาระงานนี้?',
            header: 'ยืนยันการลบ',
            icon: 'pi pi-exclamation-triangle',
            acceptClass: 'p-button-danger',
            accept: () => {
                deleteTask(currentSelectedTask.value.id);
            },
            reject: () => {}
        });
    };

    const deleteTask = async (taskId) => {  
        try {
            dailyTasks.value = dailyTasks.value.filter(task => task.id !== taskId);
            Swal.fire('สำเร็จ', 'ลบภาระงานประจำวันเรียบร้อยแล้ว', 'success');
        } catch (error) {
            console.error('Error deleting task:', error);
            Swal.fire('ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการลบภาระงานประจำวัน', 'error');
        }
    }; 
    const printDataDaily = () => {
        Swal.fire('ฟังก์ชัน Export', 'ฟังก์ชันนี้จะทำการ Export ข้อมูล', 'info');
    }; 
    const optionsMenu = ref(null); 
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
    .p-button-text.p-button-info { color: var(--blue-500); }
    .p-button-text.p-button-info:hover { background-color: var(--blue-50); }
    .p-button-text.p-button-danger { color: var(--red-500); }
    .p-button-text.p-button-danger:hover { background-color: var(--red-50); }
    .p-button-text.p-button-success { color: var(--green-500); }
    .p-button-text.p-button-success:hover { background-color: var(--green-50); }
    .p-button-text.p-button-secondary { color: var(--text-color-secondary); }
    .p-button-text.p-button-secondary:hover { background-color: var(--surface-hover); }
    
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
    input[type="file"] {
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
    input[type="file"]:hover {
        border-color: var(--primary-color);
    }
    input[type="file"]::file-selector-button {
        background-color: var(--primary-color);
        color: var(--primary-color-text);
        border: none;
        padding: 0.5rem 1rem;
        margin-right: 1rem;
        border-radius: var(--border-radius);
        cursor: pointer;
        transition: all 0.2s;
    }
    input[type="file"]::file-selector-button:hover {
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
        .p-4 { padding: 1rem; }
        .p-6 { padding: 1.5rem; }
        h1 { font-size: 1.8rem; }
        h2 { font-size: 1.5rem; }
        h5 { font-size: 1.3rem; }
        .p-button { padding: 0.6rem 0.9rem; font-size: 0.9rem; }
        .p-datatable-gridlines .p-datatable-tbody > tr > td,
        .p-datatable-gridlines .p-datatable-thead > tr > th {
            padding: 0.6rem 0.8rem;
            font-size: 0.85rem;
        }
        .p-dialog-lg, .p-dialog-md {
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