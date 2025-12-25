<template>
  <div v-if="isLoading" class="loader-overlay">
    <div class="loader-card">
      <ProgressSpinner strokeWidth="4" />
      <div class="mt-3 text-gray-600 font-medium">กำลังโหลดข้อมูล…</div>
    </div>
  </div>
  <div v-show="!isLoading" class="p-4 bg-gray-100 min-h-screen font-sans">
    <Toast /> 
    <div class="flex flex-col sm:flex-row justify-between items-center mb-5 gap-4">
      <h4 class="text-4xl font-extrabold text-primary-800 flex items-center mb-1">
        <i class="pi pi-chart-line mr-3 text-primary-500"></i>
        บันทึกแผนงาน/โครงการ/ภาระงาน
      </h4> 
    </div> 
    <div class="card p-6 shadow-2xl rounded-xl surface-card">
      <div class="flex items-center mb-6">
        <i class="pi pi-sitemap mr-3 text-primary-500 text-2xl"></i>
        <h4 class="text-2xl font-bold text-700 m-0">แบบบันทึกแผนงานและภาระงาน</h4> 
      </div>
       <!-- <Button  icon="pi pi-plus" label="สร้างแผนงาน/โครงการใหม่" class="p-button-info px-4 py-2 rounded-lg font-semibold shadow mb-4" @click="openPlanDialog" />  -->
        
      <div class="grid grid-cols-1 sm:grid-cols-12 gap-3 mb-4 items-center"> 
        <div class="sm:col-6 flex justify-start">
          <Button icon="pi pi-plus" label="สร้างแผนงาน/โครงการใหม่" class="p-button-info px-4 py-2 rounded-lg font-semibold shadow h-[42px]" @click="openPlanDialog" />
        </div> 
        <div class="sm:col-12 flex justify-end">
          <IconField iconPosition="left" class="w-full sm:w-[100%]">
            <InputIcon class="pi pi-search" />
            <InputText v-model="globalSearch"  placeholder="ค้นหาชื่อแผน/ขั้นตอน/ภาระงาน/ประเภทแผน..." class="w-full h-[42px]" />
          </IconField>
        </div>
      </div>
 
      <DataTable :value="filteredPlansSorted" v-model:expandedRows="expandedPlans" dataKey="id" responsiveLayout="scroll" stripedRows paginator :rows="10" :rowsPerPageOptions="[10,20,50]" paginatorPosition="bottom" :showCurrentPageReport="true" currentPageReportTemplate="แสดง {first}-{last} จาก {totalRecords}" >
        <Column expander style="width:2rem"/>
         <Column header="ไตรมาส" style="width:8.5rem;min-width:8rem;text-align:center">
          <template #body="{data}">
            <Tag :value="getQuarter(data.startDate)" class="tag-sm w-full justify-center" severity="info"/>
          </template>
        </Column> 
        <!-- ปี (พ.ศ.) -->
        <Column header="ปีงบประมาณ" style="width:7rem;min-width:6rem;text-align:center">
          <template #body="{ data }">
            <Tag
              :value="(data.planYear ?? '') !== '' && data.planYear != null ? String(data.planYear) : 'ไม่ระบุ'"
              class="tag-sm w-full justify-center"
              severity="info"
            />
          </template>
        </Column>
         <!-- <Column header="ปีงบประมาณ" style="width:7.5rem;min-width:7rem;text-align:center">
          <template #body="{data}">
            <Tag :value="data.planYear || 'ไม่ระบุ'" :severity="getPlanTypeSeverity(data.planplanYear)" class="tag-sm font-medium"/>
          </template>
        </Column>   -->
        <!-- ประเภทแผน -->
        <Column header="ประเภทแผน" style="width:7.5rem;min-width:7rem;text-align:center">
          <template #body="{data}">
            <Tag :value="data.planType || 'ไม่ระบุ'" :severity="getPlanTypeSeverity(data.planType)" class="tag-sm font-medium"/>
          </template>
        </Column>  
        <Column field="planLabel" header="ชื่อแผนงาน/โครงการ" style="min-width:16rem;max-width:28rem">
          <template #body="{data}">
            <div class="flex flex-col items-start">
              <div class="flex items-start gap-2">
                <i class="pi pi-briefcase text-primary-600 text-base mt-1"></i>
                <div class="truncate-2">
                  {{ data.planLabel }}
                </div>
              </div>
              <small class="text-gray-500 mt-1">
                <i class="pi pi-calendar mr-1 text-xs"></i>
                {{ formatDate(data.startDate) }} - {{ formatDate(data.endDate) }}
              </small>
            </div>
          </template>
        </Column> 
        <!-- ผู้รับผิดชอบ (แสดง 2 คน + นับส่วนเกิน) -->
        <Column header="ผู้รับผิดชอบ" style="min-width:12rem;max-width:18rem">
          <template #body="{data}">
            <div class="flex flex-wrap gap-1">
              <span 
                v-for="o in (data.owner || [])" 
                :key="o.id" 
                class="owner-chip"
              >
                {{ getOwnerDisplay(o) }}
              </span>
              <span v-if="!data.owner?.length" class="text-gray-400">
                ยังไม่กำหนด
              </span>
            </div>
          </template>
        </Column> 
        <!-- ความคืบหน้า (แคบลง) -->
        <Column header="ความคืบหน้า" style="width:11rem;min-width:10rem">
          <template #body="{data}">
            <div class="flex items-center gap-2">
              <span class="text-sm text-primary-600 font-bold">{{ getPlanProgress(data) }}%</span>
              <ProgressBar :value="getPlanProgress(data)" class="flex-1 h-2 rounded-md" />
            </div>
          </template>
        </Column> 
        <!-- สถานะ -->
        <Column header="สถานะ" style="width:8rem;min-width:7.5rem;text-align:center">
          <template #body="{data}">
            <Tag :value="getPlanStatusLabel(data)" :severity="getPlanStatusSeverity(data)" class="tag-sm font-semibold" />
          </template>
        </Column>

        <!-- จัดการ -->
        <!-- <Column header="จัดการ" style="width:6.5rem" class="text-center">
          <template #body="{data}">
            <div class="flex gap-1 justify-center">

              <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="editPlan(data)" />
              <Button icon="pi pi-trash"  class="p-button-text p-button-danger  p-button-sm p-button-rounded" @click="confirmDeletePlan(data.id)" />
            </div>
          </template>
        </Column>  -->
       <template>
          <Column header="จัดการ" style="width:8.5rem" class="text-center">
            <template #body="{ data }">
              <div class="flex gap-1 justify-center"> 
                <Button  icon="pi pi-plus"  class="p-button-text p-button-success p-button-sm p-button-rounded" @click="openAddStepDialogForPlan(data)" v-tooltip="'เพิ่มขั้นตอน/กิจกรรม'" /> 
                <Button  icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="editPlan(data)" v-tooltip="'แก้ไขโครงการ'" /> 
                <Button  icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmDeletePlan(data.id)" v-tooltip="'ลบโครงการ'" />
              </div>
            </template>
          </Column>
        </template>
        <template #empty>
          <div class="py-8 text-center text-gray-500">
            <i class="pi pi-search text-2xl block mb-2"></i>
            <div v-if="debouncedSearch">
              ไม่พบผลลัพธ์สำหรับ “{{ globalSearch }}”
            </div>
            <div v-else>
              ไม่มีข้อมูล
            </div>
          </div>
        </template>
 
        <template #expansion="planSlot">
          <div class="p-4 bg-gray-50 border-round-xl ml-4">
            <div class="text-xl font-bold text-700 flex items-center mb-3">
              <i class="pi pi-list mr-2 text-primary-500"></i>
              ขั้นตอน/กิจกรรมการทำงาน
            </div>

            <DataTable :value="planSlot.data.steps" v-model:expandedRows="expandedSteps" dataKey="id" responsiveLayout="scroll">
              <Column expander style="width:3rem"/>
              <Column field="name" header="ชื่อขั้นตอน/กิจกรรม" style="min-width:12rem" class="font-semibold text-700">
                <template #body="{data}">
                  <div class="flex items-center"><i class="pi pi-circle-fill mr-2 text-xs text-blue-500"></i>{{ data.name }}</div>
                </template>
              </Column>
              <Column header="วันเริ่มต้น" style="min-width:8rem"><template #body="{data}">{{ formatDate(data.startDate) }}</template></Column>
              <Column header="วันสิ้นสุด" style="min-width:8rem"><template #body="{data}">{{ formatDate(data.endDate) }}</template></Column>
              <Column header="ผู้รับผิดชอบ" style="min-width:12rem">
                <template #body>
                  <span v-if="planSlot.data.owner?.length">{{ planSlot.data.owner.map(getOwnerDisplay).join(', ') }}</span>
                  <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                </template>
              </Column>
              <!-- <Column header="ผู้รับผิดชอบ" style="min-width:12rem">
                <template #body>
                  <span v-if="planSlot.data.owner?.length"> {{ planSlot.data.owner.map(getOwnerDisplay).join(', ') }} </span>
                  <span v-else class="text-gray-400">ยังไม่กำหนด</span>
                </template>
              </Column> -->
              <Column header="ความคืบหน้า" style="min-width:12rem">
                <template #body="{data}">
                  <div class="flex items-center">
                    <span class="mr-2 text-sm text-primary-600 font-bold">{{ getStepProgress(data) }}%</span>
                    <ProgressBar :value="getStepProgress(data)" class="flex-1" />
                  </div>
                </template>
              </Column>
              <Column header="สถานะ" style="min-width:9rem" class="text-center">
                <template #body="{data}">
                  <Dropdown :modelValue="getStepStatus(data)" :options="taskStatuses" class="w-full"
                            :disabled="data.__saving===true"
                            :class="getTaskStatusSeverityByValue(getStepStatus(data)) + '-tag-dropdown'"
                            @update:modelValue="(val)=>updateStepStatus(planSlot.data,data,val)" />
                </template>
              </Column>
              <Column header= "จัดการ" style="width:12rem" class="text-center">
                <template #body="{data}">
                  <div class="flex gap-2 justify-center">
                    <Button icon="pi pi-plus" label="เพิ่ม" class="p-button-warning p-button-sm px-3 py-1" @click="openAddTaskDialog(data, planSlot.data.owner)"/>
                    <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditStepDialogInTable(planSlot.data.id, data)"/>
                    <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmRemoveStepById(planSlot.data.id, data.id)"/>
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
                    <Column header="ประเภทภาระงาน" style="width:8rem">
                      <template #body="{data}">
                        <Tag :value="data.taskType || 'ไม่ระบุ'"
                             :severity="data.taskType==='งานหลัก' ? 'success' : data.taskType==='งานตำแหน่งอื่น' ? 'warning' : data.taskType==='งานอื่นๆ' ? 'info' : 'secondary'"/>
                      </template>
                    </Column>
                    <Column header="ภาระงาน" style="width:10rem">
                      <template #body="{data}">
                        <Tag v-if="data.mainTask" :value="getMainTaskLabel(data.mainTask)" severity="info"/>
                        <span v-else class="text-gray-400">ยังไม่เลือก</span>
                      </template>
                    </Column>
                    <Column field="description" header="ภาระงานประจำวัน" style="flex:1;min-width:18rem"/>   
                    <Column header="วันที่ลงบันทึก" style="width:7.5rem" class="text-center"><template #body="{data}">{{ formatDate(data.createdDate) }}</template></Column>
                    <Column header="เวลาที่ใช้ไป" style="width:7rem" class="text-center"><template #body="{data}">{{ getTaskTimeSpent(data) }}</template></Column>
                    <Column header="จัดการ" style="width:6rem" class="text-center">
                      <template #body="{data, index}">
                        <div class="flex gap-2 justify-center">
                          <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-sm p-button-rounded" @click="openEditTaskDialogInTable(stepProps.data, data, index)"/>
                          <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-sm p-button-rounded" @click="confirmRemoveTaskInTable(stepProps.data, index)"/>
                        </div>
                      </template>
                    </Column>
                  </DataTable>
                  <div v-if="stepProps.data.tasks?.length===0" class="text-center text-gray-500 text-sm py-4">ยังไม่มีภาระงานสำหรับขั้นตอนนี้</div> 
                </div>
              </template>
            </DataTable>
          </div>
        </template>
      </DataTable> 
      
      <div v-if="allPlans.length===0" class="flex flex-col items-center justify-center p-12 bg-white rounded-lg shadow-inner-lg mt-4">
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
 
      <div v-if="isEditMode || activeTabIndex===0">
        <h3 class="text-xl font-bold text-700 flex items-center mb-4"><i class="pi pi-file mr-2 text-primary-500"></i>1. ข้อมูลแผนงาน / โครงการ</h3>
        <div class="p-fluid grid">
           <div class="field col-3">
            <label class="font-semibold text-lg">ปีงบประมาณ <span class="text-red-500">*</span></label>
            <Dropdown v-model="currentPlan.planYear" :options="planYears" optionLabel="label" optionValue="value" placeholder="เลือกปีงบประมาณ" class="w-full" required/>
          </div>
          <div class="field col-9">
            <label class="font-semibold text-lg">ประเภทแผน <span class="text-red-500">*</span></label>
            <Dropdown v-model="currentPlan.planType" :options="planTypes" optionLabel="label" optionValue="value" placeholder="เลือกประเภทแผน" class="w-full" required/>
          </div>


          <div class="field col-12">
            <label class="font-semibold text-lg">ชื่อแผนปฏิบัติงาน <span class="text-red-500">*</span></label>
            <InputText v-model="currentPlan.planLabel" placeholder="ระบุชื่อแผนปฏิบัติงาน" required/>
          </div>
          <div class="field col-12">
            <label class="font-semibold text-lg">ผู้รับผิดชอบหลัก <span class="text-red-500">*</span></label>
            <AutoComplete v-model="currentPlan.owner" :multiple="true" :suggestions="ownerSuggestions" optionLabel="name" placeholder="พิมพ์ชื่อหรือรหัสพนักงานเพื่อค้นหา…" forceSelection dropdown @complete="searchOwners"/>
            <small class="text-gray-500">พิมพ์อย่างน้อย 3 ตัวอักษร เช่น รหัสพนักงาน หรือชื่อ-สกุล</small>
          </div>
 
          <div class="field col-12 md:col-6">
            <label class="font-semibold text-lg">วันที่เริ่มต้น <span class="text-red-500">*</span></label>
            <Calendar v-model="currentPlan.startDate" dateFormat="dd/mm/yy" showIcon required/>
          </div>
          <div class="field col-12 md:col-6">
            <label class="font-semibold text-lg">วันที่สิ้นสุด <span class="text-red-500">*</span></label>
            <Calendar v-model="currentPlan.endDate" dateFormat="dd/mm/yy" showIcon required/>
          </div>
        </div>
      </div>

      <div v-else-if="!isEditMode && activeTabIndex===1">
        <h3 class="text-xl font-bold text-700 flex items-center mb-4"><i class="pi pi-list mr-2 text-primary-500"></i>2. กำหนดขั้นตอน/กิจกรรมการทำงาน</h3>
        <div class="flex flex-col sm:flex-row items-stretch gap-2 mb-4">
          <InputText v-model="newStepName" placeholder="เพิ่มชื่อขั้นตอนใหม่..." class="w-full"/>
          <Calendar v-model="newStepDates" selectionMode="range" :manualInput="false" placeholder="เลือกวันเริ่มต้น-สิ้นสุด" class="w-full sm:w-80"/>
          <Button icon="pi pi-plus" label="เพิ่ม" @click="addStep" :disabled="!isNewStepValid" class="sm:w-32"/>
        </div>
        <div class="p-4 bg-gray-100 rounded-lg max-h-80 overflow-y-auto custom-scroll">
          <ul v-if="currentPlan.steps.length" class="list-none p-0 m-0">
            <li v-for="(step, i) in currentPlan.steps" :key="step.id" class="p-3 mb-2 bg-white shadow-sm rounded-md">
              <div class="flex items-center justify-between gap-2 mb-2">
                <div class="flex flex-col flex-grow">
                  <span class="text-lg font-medium text-primary-700">{{ i+1 }}. {{ step.name }}</span>
                  <small class="text-gray-500 mt-1"><i class="pi pi-calendar mr-1 text-xs"></i>{{ formatDate(step.startDate) }} - {{ formatDate(step.endDate) }}</small>
                </div>
                <Button icon="pi pi-pencil" class="p-button-text p-button-warning p-button-rounded" @click="openEditStepDialog(step, i)"/>
                <Button icon="pi pi-trash" class="p-button-text p-button-danger p-button-rounded" @click="confirmRemoveStep(i)"/>
              </div>
            </li>
          </ul>
          <div v-else class="text-center text-gray-500 p-4 border-dashed border-2 border-gray-300 rounded-lg">ยังไม่มีการเพิ่มขั้นตอน</div>
        </div>
      </div> 
      <template #footer> 
        <div v-if="!isEditMode" class="flex justify-between w-full pt-4">
          <Button v-if="activeTabIndex>0" label="ย้อนกลับ" icon="pi pi-angle-left" class="p-button-secondary p-button-text" @click="goToPrevStep"/>
          <Button v-else label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-text" @click="showPlanDialog=false"/>
          <div class="flex-grow"></div>
          <Button v-if="activeTabIndex<1" label="ถัดไป" icon="pi pi-angle-right" iconPos="right" class="p-button-warning" @click="goToNextStep"/>
          <Button v-else label="บันทึก" icon="pi pi-save" class="p-button-success" @click="savePlan" :disabled="!isFinalStepValid"/>
        </div> 
        <div v-else class="flex justify-between w-full pt-4">
          <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger p-button-text" @click="showPlanDialog=false"/>
          <div class="flex-grow"></div>
          <Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="savePlan" :disabled="!isFirstStepValid"/>
        </div>
      </template> 
    </Dialog>

    <!-- Dialog: แก้ไขขั้นตอน -->
    <Dialog v-model:visible="showEditStepDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '40vw' }" modal>
      <template #header>
        <div class="flex items-center w-full"><i class="pi pi-pencil mr-2 text-primary-500 text-2xl"></i><h5 class="m-0 text-xl font-bold text-primary-700">แก้ไขขั้นตอน</h5></div>
      </template>
      <div class="p-fluid">
        <div class="field"><label class="font-semibold">ชื่อขั้นตอน</label><InputText v-model="currentEditingStep.name"/></div>
        <div class="field mt-4"><label class="font-semibold text-lg">ช่วงเวลาของขั้นตอน</label><Calendar v-model="currentEditingStep.dates" selectionMode="range" :manualInput="false" placeholder="เลือกวันเริ่มต้น-สิ้นสุด"/></div>
      </div>
      <template #footer>
        <div class="flex justify-end gap-2 pt-4"><Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditStepDialog=false"/><Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedStep"/></div>
      </template>
    </Dialog>
 
    <Dialog v-model:visible="showAddStepForPlanDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '40vw' }" modal>
      <template #header>
        <div class="flex items-center w-full">
          <i class="pi pi-plus-circle mr-2 text-primary-500 text-2xl"></i>
          <h5 class="m-0 text-xl font-bold text-primary-700">
            เพิ่มขั้นตอนในแผน "{{ addStepForm.planLabel }}"
          </h5>
        </div>
      </template>

      <div class="p-fluid">
        <div class="field">
          <label class="font-semibold">ชื่อขั้นตอน <span class="text-red-500">*</span></label>
          <InputText v-model="addStepForm.name" placeholder="ระบุชื่อขั้นตอน"/>
        </div>
        <div class="field">
          <label class="font-semibold">ช่วงเวลา <span class="text-red-500">*</span></label>
          <Calendar v-model="addStepForm.dates" selectionMode="range" :manualInput="false"
                    placeholder="เลือกวันเริ่มต้น-สิ้นสุด"/>
          <small class="text-gray-500" v-if="planDateHint">
            ช่วงแผนงาน: {{ planDateHint }}
          </small>
        </div>
      </div> 
      <template #footer>
        <div class="flex justify-end gap-2 pt-4">
          <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showAddStepForPlanDialog=false" />
          <Button label="บันทึก" icon="pi pi-save" class="p-button-success" :disabled="!isAddStepFormValid" @click="saveNewStepForPlan"/>
        </div>
      </template>
    </Dialog>
 
    <!-- Dialog: แก้ไขภาระงาน -->
    <Dialog v-model:visible="showEditTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '70vw' }" modal>
      <template #header>
        <div class="flex items-center w-full"><i class="pi pi-pencil mr-2 text-primary-500 text-2xl"></i><h5 class="m-0 text-xl font-bold text-primary-700">แก้ไขภาระงาน</h5></div>
      </template>
      <div class="p-fluid formgrid grid">
        <div class="field col-6"><label class="font-semibold">ประเภทภาระงาน</label><Dropdown v-model="currentEditingTask.taskType" :options="taskTypes" optionLabel="label" optionValue="value" class="w-full" @change="onEditTaskTypeChange"/></div> 
        <div class="field col-6"> <label class="font-semibold">ภาระงานหลัก</label> <AutoComplete v-model="currentEditingTask.mainTask" :suggestions="mainTaskSuggestions" @complete="completeMainTask" placeholder="พิมพ์เพื่อค้นหา/เลือกภาระงานหลัก" dropdown @blur="normalizeEditingMainTask()" class="w-full" /> </div>
      </div> 
      <div class="p-fluid formgrid grid">
        <div class="field col-12 md:col-6"><label class="font-semibold">ภาระงานประจำวัน</label><InputText v-model="currentEditingTask.description" placeholder="ระบุภาระงาน..." class="w-full"/></div>
        <div class="field col-12 md:col-3"><label class="font-semibold">เวลาเริ่มต้น</label><Calendar v-model="currentEditingTask.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น" class="w-full"/></div>
        <div class="field col-12 md:col-3"><label class="font-semibold">เวลาสิ้นสุด</label><Calendar v-model="currentEditingTask.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด" class="w-full"/></div>
      </div>
      <template #footer>
        <div class="flex justify-end gap-2 pt-4"><Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showEditTaskDialog=false"/><Button label="บันทึก" icon="pi pi-save" class="p-button-success" @click="saveEditedTask"/></div>
      </template>
    </Dialog> 
    <!-- Dialog: เพิ่มภาระงาน -->
    <Dialog v-model:visible="showAddTaskDialog" :breakpoints="{ '960px': '90vw' }" :style="{ width: '70vw' }" modal>
      <template #header>
        <div class="flex items-center w-full"><i class="pi pi-plus-circle mr-2 text-primary-500 text-2xl"></i><h5 class="m-0 text-xl font-bold text-primary-700">เพิ่มภาระงานสำหรับขั้นตอน "{{ currentStepToAddTasks.name }}"</h5></div>
      </template>
        <div class="p-fluid grid">
            <!-- เลือกประเภทภาระงาน -->
            <div class="field col-12">
                <label class="font-semibold">ประเภทภาระงาน</label>
                <Dropdown v-model="newTaskInStep.taskType" :options="taskTypes" optionLabel="label" optionValue="value" placeholder="เลือกประเภทภาระงาน" class="w-full" @change="onTaskTypeChange"/>
            </div>

            <!-- เลือกภาระงานหลัก (แสดงเมื่อประเภทงานไม่ใช่ 'งานอื่นๆ') --> 
            <div class="field col-12" v-if="newTaskInStep.taskType !== 'งานอื่นๆ'">
                <label class="font-semibold">ภาระงานหลัก</label> 
                <InputText
                    v-model="newTaskInStep.mainTask"
                    placeholder="พิมพ์ภาระงานหลัก"
                    class="w-full"
                    @input="onMainTaskChange(newTaskInStep.mainTask)"
                />
            </div> 
            <!-- ภาระงานประจำวัน (แสดงแบบต่างกันขึ้นอยู่กับประเภทงาน) -->
            <div class="field col-12">
                <label class="font-semibold">ภาระงานประจำวัน</label>
                  <InputText  v-if="newTaskInStep.taskType === 'งานหลัก'" v-model="newTaskInStep.description"  placeholder="พิมพ์ภาระงานประจำวัน" class="w-full" :disabled="!newTaskInStep.mainTask" />  
                <Textarea  v-else v-model="newTaskInStep.description"  placeholder="กรอกภาระงานประจำวัน"  class="w-full" />
            </div>




            <!-- แก้ใหม่ 22/12/68 -->
            <div class="field col-12">
              <label class="font-semibold text-lg">ผู้รับผิดชอบ </label>
              <AutoComplete v-model="currentPlan.owner" :multiple="true" :suggestions="ownerSuggestions" optionLabel="name" placeholder="พิมพ์ชื่อหรือรหัสพนักงานเพื่อค้นหา…" forceSelection dropdown @complete="searchOwners"/>
              <small class="text-gray-500">พิมพ์อย่างน้อย 3 ตัวอักษร เช่น รหัสพนักงาน หรือชื่อ-สกุล</small>
            </div>
                


            <!-- เวลาเริ่มต้น -->
            <div class="field col-6">
                <label class="font-semibold">เวลาเริ่มต้น</label>
                <Calendar v-model="newTaskInStep.startTime" :showTime="true" hourFormat="24" placeholder="เวลาเริ่มต้น"/>
            </div>

            <!-- เวลาสิ้นสุด -->
            <div class="field col-6">
                <label class="font-semibold">เวลาสิ้นสุด</label>
                <Calendar v-model="newTaskInStep.endTime" :showTime="true" hourFormat="24" placeholder="เวลาสิ้นสุด"/>
            </div>
        </div> 
      <template #footer>
        <div class="flex justify-end gap-2 pt-4">
            <Button label="ยกเลิก" icon="pi pi-times" class="p-button-text p-button-danger" @click="showAddTaskDialog=false"/>
            <Button label="บันทึก" icon="pi pi-plus" class="p-button-success" @click="addTaskToStepFromMain" :disabled="!isNewTaskInStepValid"/>
        </div>
      </template>
    </Dialog>
  </div>
</template>

<script setup>
  import { ref, reactive, computed, onMounted, watch } from 'vue'
  import Swal from 'sweetalert2'
  import axios from 'axios'
  import Dialog from 'primevue/dialog'
  import Button from 'primevue/button'
  import DataTable from 'primevue/datatable'
  import Column from 'primevue/column'
  import Tag from 'primevue/tag'
  import ProgressBar from 'primevue/progressbar'
  import InputText from 'primevue/inputtext'
  import Dropdown from 'primevue/dropdown'
  import Calendar from 'primevue/calendar'
  import Textarea from 'primevue/textarea'
  import Toast from 'primevue/toast'
  import AutoComplete from 'primevue/autocomplete' 
  import ProgressSpinner from 'primevue/progressspinner'
  import IconField from 'primevue/iconfield'
  import InputIcon from 'primevue/inputicon'

 
  const globalSearch = ref('')
  const debouncedSearch = ref('')
  let searchTimer = null
  watch(globalSearch, (val) => {
    if (searchTimer) clearTimeout(searchTimer)
    searchTimer = setTimeout(() => {
      debouncedSearch.value = (val || '').toLowerCase().trim()
    }, 200)
  })
 
  function planMatchesQuery(plan, q) {
    if (!q) return true
    const bucket = []
 
    bucket.push(
      plan.planType ?? '', 
      plan.planYear ?? '',
      plan.planLabel ?? '',
      getQuarter(plan.startDate),
      getYear(plan.startDate),
      formatDate(plan.startDate),
      formatDate(plan.endDate),
      (plan.owner || []).map(getOwnerDisplay).join(' ')
    )
 
    for (const s of (plan.steps || [])) {
      bucket.push(
        s.name ?? '',
        s.status ?? '',
        formatDate(s.startDate),
        formatDate(s.endDate)
      ) 

      for (const t of (s.tasks || [])) {
        bucket.push(
          t.taskType ?? '',
          t.mainTask ?? '',
          t.description ?? '',
          t.status ?? '',
          formatDate(t?.createdDate),
          t?.responsible ? t.responsible.map(r => r?.name || '').join(' ') : ''
        )
      }
    }
 
    const haystack = bucket.join(' | ').toLowerCase()
    return haystack.includes(q)
  }
 
  const filteredPlansSorted = computed(() => {
    const base = allPlansSorted.value || []
    const q = debouncedSearch.value
    if (!q) return base
    return base.filter(p => planMatchesQuery(p, q))
  })





 
  const isLoading = ref(true)
  const API = 'http://127.0.0.1:8000/api'
 
  const session = reactive({ staffId: null, facId: null, groupId: null })
  const { getSession } = await useAuth()
  const user = await getSession()

  function loadSessionFromStorage(){
    try{
      const s = localStorage.getItem('app_staffId')
      const f = localStorage.getItem('app_facId')
      const g = localStorage.getItem('app_groupId')
      if(s) session.staffId = Number(s)
      if(f) session.facId = Number(f)
      if(g) session.groupId = g
    }catch{}
  }

  async function initSessionFromAuth(){
    try{
      const authUser = await getSession()
      const nameObj = authUser?.user?.name || {}
      const STAFFID = authUser?.user?.STAFFID ?? authUser?.user?.id ?? nameObj?.STAFFID ?? nameObj?.staffid ?? nameObj?.staffId ?? null
      const FACID   = authUser?.user?.FACID ?? authUser?.user?.facid ?? nameObj?.SCOPES?.staffdepartment ?? nameObj?.SCOPES?.facid ?? nameObj?.SCOPES?.facId ?? null
      const GROUPID = authUser?.user?.GROUPID ?? authUser?.user?.groupid ?? nameObj?.SCOPES?.groupid ?? null
      if(STAFFID) session.staffId = Number(STAFFID)
      if(FACID)   session.facId   = Number(FACID)
      session.groupId = GROUPID ?? session.groupId ?? null
      try{
        localStorage.setItem('app_staffId', session.staffId ?? '')
        localStorage.setItem('app_facId',   session.facId ?? '')
        localStorage.setItem('app_groupId', session.groupId ?? '')
      }catch{}
    }catch{ loadSessionFromStorage() }
  }

 onMounted(async () => {
    isLoading.value = true
    try {
      loadSessionFromStorage()
      await initSessionFromAuth()
      if (session.staffId && session.facId) {
        await fetchPlans()
      }
    } finally {
      isLoading.value = false
    }
  })
 
  const mainTasks = ref([])
  const subTasks  = ref([])
 
  const evalRounds = ref([])             
  const porFormsAll = ref([])          
  const porFormSuggestions = ref([])    
   
   

  const getMainTaskLabel = (x)=> x || 'ยังไม่เลือก'

  async function fetchPositionMainWorks(){
    const positionNameId = user?.user?.name?.POSITIONNAMEID ?? null
    if(!positionNameId){ mainTasks.value=[]; return }
    const res = await axios.get(`${API}/getMainWorks`, { params:{ positionnameid: positionNameId }})
    const data = Array.isArray(res.data?.data) ? res.data.data : []
    mainTasks.value = data.map(x=>({ label:x.POSNAMETH, value:x.POSNAMETH })).filter(x=>!!x.label)
  }
  // async function fetchAllMainWorks(){
  //   const res = await axios.get(`${API}/getMainWorksAll`)
  //   const data = Array.isArray(res.data?.data) ? res.data.data : [] 
  //   mainTasks.value = data
  //     .filter(x => !!x.label)  
  // }

  async function fetchAllMainWorks(){
    const res = await axios.get(`${API}/getMainWorksAll`)
    const data = Array.isArray(res.data?.data) ? res.data.data : []
    mainTasks.value = data
      .map(x => ({
        label: x.POSNAMETH || x.label || '',
        value: x.POSNAMETH || x.value || ''
      }))
      .filter(x => !!x.label)
  }

  // const onMainTaskChange = async(e)=>{
  //   const mainName = e?.value ?? newTaskInStep.mainTask
  //   if(!mainName){ subTasks.value=[]; newTaskInStep.description=null; return }
  //   const url = newTaskInStep.taskType==='งานตำแหน่งอื่น' ? `${API}/getSubWorksAll` : `${API}/getSubWorks`
  //   const res = await axios.get(url, { params:{ mainActivity: mainName }})
  //   subTasks.value = Array.isArray(res.data?.data) ? res.data.data : []
  //   newTaskInStep.description=null
  // }

  const onMainTaskChange = async (valOrEvent) => {
  // รองรับทั้งกรณี e.value (Dropdown) และ string (AutoComplete)
  const mainName = typeof valOrEvent === 'string'
    ? valOrEvent
    : (valOrEvent?.value ?? newTaskInStep.mainTask)

  if (!mainName) {
    subTasks.value = []
    newTaskInStep.description = null
    return
  }

  const url = newTaskInStep.taskType === 'งานตำแหน่งอื่น'
    ? `${API}/getSubWorksAll`
    : `${API}/getSubWorks`

  const res = await axios.get(url, { params: { mainActivity: mainName } })
  subTasks.value = Array.isArray(res.data?.data) ? res.data.data : []
  newTaskInStep.description = null
}

  const mainTaskSuggestions = ref([])

  // === ฟังก์ชันกรองคำแนะนำจาก mainTasks เดิม ===
  function completeMainTask(e) {
    const q = (e.query || '').toLowerCase()
    // ดึง label จาก mainTasks (ซึ่งเป็น [{label, value}])
    const labels = [...new Set((mainTasks.value || [])
      .map(o => o?.label)
      .filter(Boolean))]
    // กรองตามข้อความที่พิมพ์
    mainTaskSuggestions.value = labels
      .filter(l => l.toLowerCase().includes(q))
      .slice(0, 30)
  }
 
  const allPlans = ref([])
  const allPlansSorted = computed(()=>[...(allPlans.value||[])].sort((a,b)=>{
    const A = a.updatedDate ? new Date(a.updatedDate) : new Date(a.createdDate)
    const B = b.updatedDate ? new Date(b.updatedDate) : new Date(b.createdDate)
    return B - A
  }))
  const taskStatuses = ref(['รอดำเนินการ','อยู่ระหว่างดำเนินการ','เสร็จสิ้น'])
  const showPlanDialog = ref(false)
  const isEditMode = ref(false)
  const planTypes = [
    {label:'แผนปฏิบัติการ', value:'แผนปฏิบัติการ'},
    {label:'โครงการ', value:'โครงการ'},
    {label:'นโยบาย', value:'นโยบาย'},
    {label:'มติประชุม', value:'มติประชุม'},
  ]
  const planYears = [
    {label:'2567', value:'2567'},
    {label:'2568', value:'2568'},
    {label:'2569', value:'2569'},
    {label:'2570', value:'2570'},
  ]
  
  const currentPlan = reactive({ id:null, planYear:null, planType:null, planLabel:'', owner:[], startDate:null, endDate:null, steps:[] })
  const newStepName = ref('')
  const newStepDates = ref([])
  const expandedPlans = ref([])
  const expandedSteps = ref([])
  const activeTabIndex = ref(0)

  
 
  const showEditStepDialog = ref(false)
  const currentEditingStep = reactive({ id:null, name:'', dates:[], index:null })
  const showEditTaskDialog = ref(false)
  const currentEditingTask = reactive({ taskType:null, mainTask:null, description:'', responsible:[], dueDate:null, startTime:null, endTime:null, status:'', stepId:null, taskId:null, taskIndex:null, createdDate:null,evalRound: null, porForm: null,})
 
  const showAddTaskDialog = ref(false)
  const currentStepToAddTasks = reactive({ id:null, name:'' })
  const newTaskInStep = reactive({ taskType:null, mainTask:null, description:'', note:'', responsible:[], startTime:null, endTime:null, dueDate:null, status:'รอดำเนินการ',evalRound: null,porForm: null })
  
  const isFirstStepValid = computed(()=> currentPlan.planLabel && currentPlan.owner.length>0 && currentPlan.startDate && currentPlan.endDate)
  const isSecondStepValid = computed(()=> currentPlan.steps.length>0)
  const isFinalStepValid = computed(()=> isFirstStepValid.value && isSecondStepValid.value)
  const isNewStepValid = computed(()=> newStepName.value && newStepDates.value?.length===2 && newStepDates.value[0] && newStepDates.value[1])
  const isNewTaskInStepValid = computed(()=>{
    const t = newTaskInStep
    const timeOk = !t.startTime || !t.endTime || new Date(t.endTime) >= new Date(t.startTime)
 
    if(t.taskType === 'งานอื่นๆ') return !!t.status && timeOk
    return !!t.description?.trim() && !!t.status && timeOk
  })
 
  const pad = (n)=> String(n).padStart(2,'0')
  const toDateStr = (d)=>{ if(!d) return null; const dt=new Date(d); return `${dt.getFullYear()}-${pad(dt.getMonth()+1)}-${pad(dt.getDate())}` }
  const toDateTimeStr = (d)=>{ if(!d) return null; const dt=new Date(d); return `${dt.getFullYear()}-${pad(dt.getMonth()+1)}-${pad(dt.getDate())} ${pad(dt.getHours())}:${pad(dt.getMinutes())}:00` }
  const formatDate = (x) => { if (!x) return ''; const d = new Date(x); const yearBE = d.getFullYear() + 543; return `${pad(d.getDate())}/${pad(d.getMonth()+1)}/${yearBE}`; };

  const getPlanProgress = (plan)=> !plan.steps?.length ? 0 : Math.round(plan.steps.reduce((s,st)=> s+getStepProgress(st),0)/plan.steps.length)
  const getStepProgress = (step)=> step?.status==='เสร็จสิ้น'?100: step?.status==='อยู่ระหว่างดำเนินการ'?50:0
  const getPlanStatusLabel = (plan)=> getPlanProgress(plan)===100?'เสร็จสิ้น': getPlanProgress(plan)>0? 'อยู่ระหว่างดำเนินการ':'รอดำเนินการ'
  const getPlanStatusSeverity = (plan)=> getPlanProgress(plan)===100?'success': getPlanProgress(plan)>0?'warning':'info'
  const getStepStatus = (step)=> step?.status || 'รอดำเนินการ'
  const getTaskTimeSpent = (task)=>{
    if(task?.startTime && !task?.endTime && task?.status==='อยู่ระหว่างดำเนินการ'){
      const diffMin = Math.max(0, Math.round((new Date()-new Date(task.startTime))/(1000*60)))
      return `${diffMin} นาที`
    }
    if(!task?.startTime || !task?.endTime) return 'ยังไม่ระบุ'
    const diffMin = Math.round(Math.max(0, new Date(task.endTime)-new Date(task.startTime))/(1000*60))
    return `${diffMin} นาที`
  }
  const getTaskStatusSeverityByValue = (s)=> s==='เสร็จสิ้น'?'success': s==='อยู่ระหว่างดำเนินการ'?'warning':'info'

  // function mapApiToState(arr){
  //   return (arr||[]).map(p=>({
  //     ...p,
  //     staff_id: p.staff_id ?? p.staffId ?? null,
  //     created_by: p.created_by ?? p.createdBy ?? null,
  //     startDate: p.startDate? new Date(p.startDate):null,
  //     endDate:   p.endDate?   new Date(p.endDate):  null,
  //     owner: Array.isArray(p.owner)? p.owner.map(o=>({ id:o.id, name:o.name||o.staff_name||o.owner_name||`ID:${o.id}` })) : [],
  //     steps: (p.steps||[]).map(s=>({
  //       ...s,
  //       status: s.status_planstep ?? s.status ?? null,
  //       startDate: s.startDate? new Date(s.startDate):null,
  //       endDate:   s.endDate?   new Date(s.endDate):  null,
  //       tasks: (s.tasks||[]).map(t=>({
  //         ...t,
  //         responsible: Array.isArray(t.responsible)? t.responsible.map(r=>({ id:r.id, name:r.name||r.owner_name||`ID:${r.id}` })) : [],
  //         mainTask: t.mainTask ?? t.Main_tasks ?? null,
  //         dueDate: t.dueDate? new Date(t.dueDate):null,
  //         startTime: t.startTime? new Date(t.startTime):null,
  //         endTime: t.endTime? new Date(t.endTime):null,
  //         createdDate: t.createdDate? new Date(t.createdDate):null,
  //       }))
  //     }))
  //   }))
  // }
  function mapApiToState(arr){
    return (arr||[]).map(p=>{
      const rawStart = p.startDate ?? p.start_date ?? null
      // const planYearNorm =
      //   (p.planYear ?? p.plan_year ?? getBudgetYear(rawStart) ?? null)
      const planYearNorm = (p.planYear ?? p.plan_year ?? null)
      return {
        ...p,
        // ให้มี planYear แน่ ๆ และเก็บเป็น string ให้ตรงกับ options ของ Dropdown
        planYear: planYearNorm ? String(planYearNorm) : null,

        staff_id: p.staff_id ?? p.staffId ?? null,
        created_by: p.created_by ?? p.createdBy ?? null,

        startDate: rawStart ? new Date(rawStart) : null,
        endDate:   (p.endDate ?? p.end_date) ? new Date(p.endDate ?? p.end_date) : null,

        owner: Array.isArray(p.owner)
          ? p.owner.map(o=>({ id:o.id, name:o.name||o.staff_name||o.owner_name||`ID:${o.id}` }))
          : [],

        steps: (p.steps||[]).map(s=>({
          ...s,
          status: s.status_planstep ?? s.status ?? null,
          startDate: s.startDate ? new Date(s.startDate) : null,
          endDate:   s.endDate   ? new Date(s.endDate)   : null,
          tasks: (s.tasks||[]).map(t=>({
            ...t,
            responsible: Array.isArray(t.responsible)
              ? t.responsible.map(r=>({ id:r.id, name:r.name||r.owner_name||`ID:${r.id}` }))
              : [],
            mainTask: t.mainTask ?? t.Main_tasks ?? null,
            dueDate:     t.dueDate     ? new Date(t.dueDate)     : null,
            startTime:   t.startTime   ? new Date(t.startTime)   : null,
            endTime:     t.endTime     ? new Date(t.endTime)     : null,
            createdDate: t.createdDate ? new Date(t.createdDate) : null,



            eval_round_year: t.eval_round_year ?? t.d_date ?? null,
            eval_round_code: t.eval_round_code ?? t.evalua ?? null,
            porFormCode:     t.por_form       ?? t.por_form_code ?? t.por_code ?? null,

            evalu_steptasks: t.evalu_steptasks ?? t.eval_round_label ?? ((t.d_evaluationround && t.d_date) ? `${t.d_evaluationround} (${t.d_date})` : null),
            por_detel:       t.por_detel ?? t.por_form_label ?? t.por_form ?? null, 
          }))
        }))
      }
    })
  }


 
  async function fetchPlans(){
    if(!session.staffId || !session.facId) return
    try{
      const res = await axios.post(`${API}/showplannew`, { staff_id:session.staffId, fac_id:session.facId })
      const mapped = mapApiToState(res.data?.data || [])
      allPlans.value = mapped.filter(belongsToMe)
    }catch(e){ allPlans.value = []; console.error(e) }
  }
  function belongsToMe(plan){
    const me = Number(session.staffId)
    const staffField = Number(plan.staff_id ?? plan.staffId ?? plan.created_by ?? plan.createdBy ?? null)
    const ownerMatch = Array.isArray(plan.owner) && plan.owner.some(o=> Number(o.id)===me)
    return staffField===me || ownerMatch
  }
 
  function openPlanDialog(){
    isEditMode.value=false; showPlanDialog.value=true; activeTabIndex.value=0
    Object.assign(currentPlan,{ id:null, planYear:null, planType:null, planLabel:'', owner:[], startDate:null, endDate:null, steps:[] })
    newStepName.value=''; newStepDates.value=[]
  }
  function editPlan(plan){
    isEditMode.value=true; showPlanDialog.value=true; activeTabIndex.value=0
    const cloned = JSON.parse(JSON.stringify(plan))
    cloned.startDate = cloned.startDate? new Date(cloned.startDate):null
    cloned.endDate   = cloned.endDate?   new Date(cloned.endDate):  null
    cloned.steps.forEach(s=>{
      s.startDate = s.startDate? new Date(s.startDate):null
      s.endDate   = s.endDate?   new Date(s.endDate):  null
      s.tasks?.forEach(t=>{
        t.dueDate = t.dueDate? new Date(t.dueDate):null
        t.startTime = t.startTime? new Date(t.startTime):null
        t.endTime   = t.endTime?   new Date(t.endTime):  null
        t.createdDate = t.createdDate? new Date(t.createdDate):null
      })
    })
    Object.assign(currentPlan, cloned)
  }
  async function confirmDeletePlan(planId){
    const r = await Swal.fire({ title:'ยืนยันการลบ', text:'ลบแผนงานนี้?', icon:'warning', showCancelButton:true, confirmButtonColor:'#d33', cancelButtonColor:'#3085d6', confirmButtonText:'ลบ', cancelButtonText:'ยกเลิก' })
    if(!r.isConfirmed) return
    try{
      await axios.post(`${API}/Deldataplan`, { data:{ id:planId } })
      allPlans.value = allPlans.value.filter(p=>p.id!==planId)
      Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบแผนงานเรียบร้อยแล้ว', timer:1500, showConfirmButton:false })
    }catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบไม่สำเร็จ' }) }
  } 
    const showAddStepForPlanDialog = ref(false)
    const addStepForm = reactive({
      planId: null,
      planLabel: '',
      name: '',
      dates: [] 
    })
    const planDateHint = computed(()=>{
      const p = allPlans.value.find(x=> x.id===addStepForm.planId)
      if(!p) return ''
      return `${formatDate(p.startDate)} - ${formatDate(p.endDate)}`
    })
    const isAddStepFormValid = computed(()=>{
      return !!addStepForm.name && addStepForm.dates?.length===2 && addStepForm.dates[0] && addStepForm.dates[1]
    })
    function openAddStepDialogForPlan(plan){
      addStepForm.planId   = plan.id
      addStepForm.planLabel= plan.planLabel || '(ไม่ระบุชื่อแผน)'
      addStepForm.name     = ''
      addStepForm.dates    = []
      showAddStepForPlanDialog.value = true
    }
    async function saveNewStepForPlan(){
      if(!isAddStepFormValid.value){
        return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณาระบุชื่อขั้นตอนและช่วงเวลาให้ครบถ้วน' })
      }
 
      const s = new Date(addStepForm.dates[0])
      const e = new Date(addStepForm.dates[1])
      if(e < s){
        return Swal.fire({ icon:'error', title:'ช่วงเวลาไม่ถูกต้อง', text:'วันสิ้นสุดต้องไม่น้อยกว่าวันเริ่มต้น' })
      }

      const payload = {
        plan_id: addStepForm.planId,
        name: addStepForm.name,
        startDate: toDateStr(addStepForm.dates[0]),
        endDate:   toDateStr(addStepForm.dates[1]),
        fac_id: session.facId,
        staff_id: session.staffId
      }

      try {
        const res = await axios.post(`${API}/savedatastep`, payload)
        const realId = res?.data?.id
 
        const addToPlanState = (planObj)=>{
          planObj.steps = planObj.steps || []
          planObj.steps.push({
            id: realId,
            plan_id: addStepForm.planId,
            name: addStepForm.name,
            startDate: addStepForm.dates[0],
            endDate: addStepForm.dates[1],
            status: 'รอดำเนินการ',
            tasks: []
          })
        }

        const targetPlan = allPlans.value.find(p=> p.id===addStepForm.planId)
        if(targetPlan) addToPlanState(targetPlan)
        if(showPlanDialog.value && currentPlan?.id === addStepForm.planId){
          addToPlanState(currentPlan)
        }

        showAddStepForPlanDialog.value = false
        Swal.fire({ icon:'success', title:'สำเร็จ', text:'เพิ่มขั้นตอนเรียบร้อยแล้ว', timer:1200, showConfirmButton:false })
      } catch(e){
        console.error(e?.response?.data || e)
        Swal.fire({ icon:'error', title:'ผิดพลาด', text:'เพิ่มขั้นตอนไม่สำเร็จ' })
      }
    }
  
  function goToNextStep(){ if(isFirstStepValid.value) activeTabIndex.value=1; else Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณากรอกข้อมูลแผนงานให้ครบถ้วน' }) }
  function goToPrevStep(){ activeTabIndex.value=0 }

  // async function savePlan(){
  //   if(!isFinalStepValid.value) return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณาตรวจสอบข้อมูลแผนงานและขั้นตอน' })
  //   const payload = { id:currentPlan.id, planType:currentPlan.planType, planLabel:currentPlan.planLabel, startDate:toDateStr(currentPlan.startDate), endDate:toDateStr(currentPlan.endDate), owner:(currentPlan.owner||[]).map(o=>({id:o.id,name:o.name})), staff_id:session.staffId, fac_id:session.facId, steps: currentPlan.steps.map(s=>({ id:s.id,name:s.name, startDate:toDateStr(s.startDate), endDate:toDateStr(s.endDate), tasks:(s.tasks||[]).map(t=>({id: t.id, description:t.description, dueDate:toDateStr(t.dueDate), startTime:toDateTimeStr(t.startTime), endTime:toDateTimeStr(t.endTime), status:t.status, createdDate:toDateTimeStr(t.createdDate), responsible:t.responsible||[] })) })) }
  //   try{
  //     if(isEditMode.value){ await axios.post(`${API}/Edtdataplans`, payload); await fetchPlans(); Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขแผนงานเรียบร้อยแล้ว', timer:1500, showConfirmButton:false }) }
  //     else{ const res = await axios.post(`${API}/savedataplans`, payload); if(res?.data?.id) currentPlan.id=res.data.id; await fetchPlans(); Swal.fire({ icon:'success', title:'สำเร็จ', text:'สร้างแผนงานใหม่เรียบร้อยแล้ว', timer:1500, showConfirmButton:false }) }
  //     showPlanDialog.value=false
  //   }catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'บันทึกไม่สำเร็จ' }) }
  // }

  async function savePlan(){ 
    const valid = isEditMode.value ? isFirstStepValid.value : isFinalStepValid.value
      if(!valid){ return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text: isEditMode.value ? 'กรุณากรอกข้อมูลแผนงานให้ครบถ้วน' : 'กรุณาตรวจสอบข้อมูลแผนงานและขั้นตอน' })
    } 
    const basePayload = { id: currentPlan.id, planType: currentPlan.planType, planYear: currentPlan.planYear, planLabel: currentPlan.planLabel, startDate: toDateStr(currentPlan.startDate), endDate: toDateStr(currentPlan.endDate), owner: (currentPlan.owner||[]).map(o=>({id:o.id, name:o.name})), staff_id: session.staffId, fac_id: session.facId, } 
    try{
      if(isEditMode.value){  await axios.post(`${API}/Edtdataplans`, basePayload)
        await fetchPlans() 
      Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขแผนงานเรียบร้อยแล้ว', timer:1500, showConfirmButton:false })
      }else{ const payload = { ...basePayload, steps: currentPlan.steps.map(s=>({ id: s.id, name: s.name, startDate: toDateStr(s.startDate), endDate: toDateStr(s.endDate), tasks: (s.tasks||[]).map(t=>({ id: t.id, description: t.description, dueDate: toDateStr(t.dueDate), startTime: toDateTimeStr(t.startTime), endTime: toDateTimeStr(t.endTime), status: t.status, createdDate: toDateTimeStr(t.createdDate), responsible: t.responsible || [] })) })) }
        const res = await axios.post(`${API}/savedataplans`, payload)
        if(res?.data?.id) currentPlan.id = res.data.id
        await fetchPlans()
        Swal.fire({ icon:'success', title:'สำเร็จ', text:'สร้างแผนงานใหม่เรียบร้อยแล้ว', timer:1500, showConfirmButton:false })
      } 
      showPlanDialog.value = false
    }catch(e){
      console.error(e)
      Swal.fire({ icon:'error', title:'ผิดพลาด', text:'บันทึกไม่สำเร็จ' })
    }
  }
  
  function addStep(){
    if(!isNewStepValid.value) return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณาใส่ชื่อขั้นตอนและช่วงเวลาให้ครบถ้วน' })
    currentPlan.steps.push({ id:Date.now(), name:newStepName.value, startDate:newStepDates.value[0], endDate:newStepDates.value[1], tasks:[] })
    newStepName.value=''; newStepDates.value=[]
    Swal.fire({ icon:'success', title:'สำเร็จ', text:'เพิ่มขั้นตอนเรียบร้อยแล้ว', timer:1200, showConfirmButton:false })
  }
  function confirmRemoveStep(i){
    Swal.fire({ title:'ยืนยันการลบ', text:'ลบขั้นตอนนี้?', icon:'warning', showCancelButton:true, confirmButtonColor:'#d33', cancelButtonColor:'#3085d6', confirmButtonText:'ลบ', cancelButtonText:'ยกเลิก' }).then(r=>{
      if(r.isConfirmed){ currentPlan.steps.splice(i,1); Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบขั้นตอนเรียบร้อยแล้ว', timer:1200, showConfirmButton:false }) }
    })
  }
  function openEditStepDialog(step,i){ showEditStepDialog.value=true; Object.assign(currentEditingStep,{ id:step.id, name:step.name, dates:[step.startDate, step.endDate], index:i }) }
  function openEditStepDialogInTable(planId, stepData){
    const plan = allPlans.value.find(p=>p.id===planId); if(!plan) return
    const idx = plan.steps.findIndex(s=>s.id===stepData.id); if(idx===-1) return
    const s = plan.steps[idx]
    Object.assign(currentEditingStep,{ id:s.id, name:s.name, dates:[new Date(s.startDate), new Date(s.endDate)], index:idx })
    showEditStepDialog.value=true
  }
  async function saveEditedStep(){
    if(!currentEditingStep.name || currentEditingStep.dates?.length!==2) return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text:'กรุณากรอกข้อมูลขั้นตอนให้ครบถ้วน' })
    try{
      await axios.post(`${API}/Edtdatastep`, { id:currentEditingStep.id, name:currentEditingStep.name, startDate:toDateStr(currentEditingStep.dates[0]), endDate:toDateStr(currentEditingStep.dates[1]) })
      allPlans.value.forEach(p=>{ const s=p.steps?.find(x=>x.id===currentEditingStep.id); if(s){ s.name=currentEditingStep.name; s.startDate=currentEditingStep.dates[0]; s.endDate=currentEditingStep.dates[1] } })
      const s2 = currentPlan.steps?.find(x=>x.id===currentEditingStep.id); if(s2){ s2.name=currentEditingStep.name; s2.startDate=currentEditingStep.dates[0]; s2.endDate=currentEditingStep.dates[1] }
      showEditStepDialog.value=false
      Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขขั้นตอนเรียบร้อยแล้ว', timer:1200, showConfirmButton:false })
    }catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'แก้ไขขั้นตอนไม่สำเร็จ' }) }
  }

  // async function openAddTaskDialog(stepData, owners){
  //   try{
  //     const posId = user?.user?.name?.POSITIONNAMEID ?? null
  //     if(posId){
  //       const res = await axios.get(`${API}/getMainWorks`, { params:{ positionnameid: posId } })
  //       const arr = Array.isArray(res.data?.data) ? res.data.data : (res.data?.data ? [res.data.data] : [])
  //       const uniq = []; const seen=new Set()
  //       for(const it of arr){ if(!seen.has(it.POSNAMETH)){ seen.add(it.POSNAMETH); uniq.push(it) } }
  //       mainTasks.value = uniq.map(x=>({ label:x.POSNAMETH, value:x.POSNAMETH }))
  //     }
  //   }catch(e){ console.error('getMainWorks error:', e) }
  //   showAddTaskDialog.value=true
  //   Object.assign(currentStepToAddTasks,{ id:stepData.id, name:stepData.name })
  //   Object.assign(newTaskInStep,{taskType: null, mainTask: null,description:'', responsible:owners, dueDate:null, startTime:null, endTime:null, status:'รอดำเนินการ' })
  // }

  async function openAddTaskDialog(stepData, owners){
    try{
      const posId = user?.user?.name?.POSITIONNAMEID ?? null
      if(posId){
        const res = await axios.get(`${API}/getMainWorks`, { params:{ positionnameid: posId } })
        const arr = Array.isArray(res.data?.data) ? res.data.data : (res.data?.data ? [res.data.data] : [])
        const uniq = []; const seen=new Set()
        for(const it of arr){ if(!seen.has(it.POSNAMETH)){ seen.add(it.POSNAMETH); uniq.push(it) } }
        mainTasks.value = uniq.map(x=>({ label:x.POSNAMETH, value:x.POSNAMETH }))
      }
    }catch(e){ console.error('getMainWorks error:', e) }

    showAddTaskDialog.value = true
    Object.assign(currentStepToAddTasks, { id:stepData.id, name:stepData.name })
    Object.assign(newTaskInStep, {
      taskType: null, mainTask: null, description: '',
      responsible: owners, dueDate: null, startTime: null, endTime: null,
      status: 'รอดำเนินการ', 
      evalRound: null,
      porForm: null
    })
 
    try{
      await fetchEvalRounds() 
      if (evalRounds.value.length){ 
        newTaskInStep.evalRound = evalRounds.value[0].value
        await onEvaluChange()
      }
    }catch(e){
      console.error('fetchEvalRounds error:', e)
    }
  }


  

  const taskTypes = [ {label:'งานหลัก', value:'งานหลัก'}, {label:'งานตำแหน่งอื่น', value:'งานตำแหน่งอื่น'}, {label:'งานอื่นๆ', value:'งานอื่นๆ'} ]

  async function onTaskTypeChange(){
    const t = newTaskInStep.taskType
    newTaskInStep.mainTask = null
    newTaskInStep.description = ''
    subTasks.value = []

    if(!t) return
    if(t==='งานหลัก'){
      await fetchPositionMainWorks()
    }else if(t==='งานตำแหน่งอื่น'){
      await fetchAllMainWorks()        
    }else if(t==='งานอื่นๆ'){ 
    }
  }
  async function onEditTaskTypeChange(){
    const t=currentEditingTask.taskType
    currentEditingTask.mainTask=null; currentEditingTask.description=''; subTasks.value=[]
    if(t==='งานหลัก') await fetchPositionMainWorks(); else if(t==='งานตำแหน่งอื่น') await fetchAllMainWorks()
  }

  async function addTaskToStepFromMain() { 
    if (!isNewTaskInStepValid.value) {
      return Swal.fire({
        icon: 'error', 
        title: 'ข้อผิดพลาด', 
        text: 'กรุณากรอกข้อมูลให้ครบถ้วน (ประเภท/รายละเอียด และเวลา)'
      });
    }

    try {

      const er = newTaskInStep.evalRound;
      const evalLabel = er
        ? `${er.d_evaluationround ?? ''}${er?.d_date ? ` (${er.d_date})` : ''}`.trim() || null
        : null;
       
      const payload = {
        step_id: currentStepToAddTasks.id,
        taskType: newTaskInStep.taskType,
        mainTask: newTaskInStep.taskType === 'งานอื่นๆ' ? 'ภาระงานอื่นๆ' : newTaskInStep.mainTask,
        description: newTaskInStep.description,
        startTime: toDateTimeStr(newTaskInStep.startTime),
        endTime: toDateTimeStr(newTaskInStep.endTime),
        status: 'เสร็จสิ้น',
        staff_id: session.staffId,
        fac_id: session.facId,
        responsible: (newTaskInStep.responsible || []).map(o => ({ id: o.id })),
 
        eval_round_year: newTaskInStep.evalRound?.d_date ?? null,
        eval_round_code: newTaskInStep.evalRound?.evalua ?? null,
        por_form: newTaskInStep.porForm?.value ?? null,

         // ★★ ใหม่: ส่งไปเก็บลงคอลัมน์ table_steptasks
        evalu_steptasks: evalLabel,                    // = รอบประเมิน  
        por_detel: newTaskInStep.porForm?.label ?? null // = แบบ ป. ที่สอดคล้อง  
      }


      const res = await axios.post(`${API}/savedatatasks`, payload)
      const plan = allPlans.value.find(p => p.steps.some(s => s.id === currentStepToAddTasks.id))
      const step = plan?.steps.find(s => s.id === currentStepToAddTasks.id)

      if (step) {
        step.tasks = step.tasks || []
        step.tasks.push({
          id: res.data.id,
          taskType: payload.taskType,
          mainTask: payload.mainTask,
          description: payload.description,   
          startTime: newTaskInStep.startTime,
          endTime: newTaskInStep.endTime,
          status: 'เสร็จสิ้น',
          createdDate: new Date(),
          staffId: session.staffId ?? null,
          responsible: (newTaskInStep.responsible || []).map(o => ({ id: o.id, name: o.name })),
          evalu_steptasks: payload.evalu_steptasks,
          por_detel: payload.por_detel
        })
      }

      showAddTaskDialog.value = false
      Swal.fire({
        icon: 'success', 
        title: 'สำเร็จ', 
        text: 'เพิ่มภาระงานเรียบร้อยแล้ว', 
        timer: 1200, 
        showConfirmButton: false
      })
    } catch (e) {
      console.error(e)
      Swal.fire({
        icon: 'error', 
        title: 'ผิดพลาด', 
        text: 'เพิ่มภาระงานไม่สำเร็จ'
      })
    }
  }
  
  function normalizeEditingMainTask () {
    const v = currentEditingTask.mainTask 
    currentEditingTask.mainTask =
      typeof v === 'object' && v !== null
        ? (v.label ?? v.value ?? '')
        : (v ?? '')
  }

  // async function openEditTaskDialogInTable(step, task, taskIndex){
  //   showEditTaskDialog.value=true
  //   Object.assign(currentEditingTask,{ stepId:step.id, taskId:task.id, taskIndex, taskType:task.taskType||'งานหลัก', mainTask:task.mainTask||null, description:task.description||'', responsible:task.responsible||[], dueDate:task.dueDate?new Date(task.dueDate):null, startTime:task.startTime?new Date(task.startTime):null, endTime:task.endTime?new Date(task.endTime):null, status:task.status||'', createdDate:task.createdDate?new Date(task.createdDate):null, staffId:task.staffId??session.staffId??null, evalRound: null,porForm: null,porFormCode: task.porFormCode ?? null, })
  //   if(currentEditingTask.taskType==='งานหลัก'){ await fetchPositionMainWorks() }
  //   else if(currentEditingTask.taskType==='งานตำแหน่งอื่น'){ await fetchAllMainWorks() }

  //   normalizeEditingMainTask()
  // }
  async function openEditTaskDialogInTable(step, task, taskIndex){
    showEditTaskDialog.value = true

    
    if (!evalRounds.value?.length) {
      await fetchEvalRounds()
    }

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
  
      porFormCode: task.porFormCode ?? null,
      evalRound: null,    
      porForm: null,
    })
 
    if (currentEditingTask.taskType === 'งานหลัก') {
      await fetchPositionMainWorks()
    } else if (currentEditingTask.taskType === 'งานตำแหน่งอื่น') {
      await fetchAllMainWorks()
    }
    normalizeEditingMainTask()
 
    if (task.eval_round_year || task.eval_round_code) {
      const found = (evalRounds.value || []).find(opt =>
        String(opt.value.d_date)  === String(task.eval_round_year) &&
        String(opt.value.evalua)  === String(task.eval_round_code)
      )
      currentEditingTask.evalRound = found ? found.value : null
    }
 
    if (currentEditingTask.evalRound) {
      await onEditEvaluChange()  
      if (currentEditingTask.porFormCode) {
        currentEditingTask.porForm =
          (porFormsAll.value || []).find(it => String(it.value) === String(currentEditingTask.porFormCode)) || null
      }
    }
  }



  // async function saveEditedTask(){
  //   const invalid = currentEditingTask.startTime && currentEditingTask.endTime && new Date(currentEditingTask.endTime) < new Date(currentEditingTask.startTime)
  //   if(!currentEditingTask.description || invalid){
  //     return Swal.fire({ icon:'error', title:'ข้อผิดพลาด', text: invalid? 'กรุณาตรวจสอบเวลาเริ่มต้น-สิ้นสุด':'กรุณาระบุภาระงาน' })
  //   }
  //   const payload={ id:currentEditingTask.taskId, taskType:currentEditingTask.taskType, mainTask:currentEditingTask.mainTask, description:currentEditingTask.description, startTime:toDateTimeStr(currentEditingTask.startTime), endTime:toDateTimeStr(currentEditingTask.endTime), status:'เสร็จสิ้น', fac_id:session.facId,por_form: currentEditingTask.porForm?.value ?? null,por_detel: currentEditingTask.porForm?.label ?? null }
  //     try{
  //       await axios.post(`${API}/Edtdatatasks`, payload)
  //       const pIdx = allPlans.value.findIndex(p=> p.steps.some(s=> s.id===currentEditingTask.stepId))
  //       if(pIdx===-1) return
  //       const sIdx = allPlans.value[pIdx].steps.findIndex(s=> s.id===currentEditingTask.stepId)
  //       if(sIdx===-1) return
  //       allPlans.value[pIdx].steps[sIdx].tasks[currentEditingTask.taskIndex] = { id:currentEditingTask.taskId, taskType:currentEditingTask.taskType, mainTask:currentEditingTask.mainTask, description:currentEditingTask.description, startTime:currentEditingTask.startTime, endTime:currentEditingTask.endTime, status:'เสร็จสิ้น', createdDate:currentEditingTask.createdDate,evalu_steptasks: payload.evalu_steptasks,por_detel: payload.por_detel, }
  //       showEditTaskDialog.value=false
  //       Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขภาระงานเรียบร้อยแล้ว', timer:1200, showConfirmButton:false })
  //     }catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'แก้ไขภาระงานไม่สำเร็จ' }) }
  //   }
  async function saveEditedTask(){
    const invalid = currentEditingTask.startTime && currentEditingTask.endTime &&
                    new Date(currentEditingTask.endTime) < new Date(currentEditingTask.startTime)
    if(!currentEditingTask.description || invalid){
      return Swal.fire({ icon:'error', title:'ข้อผิดพลาด',
        text: invalid ? 'กรุณาตรวจสอบเวลาเริ่มต้น-สิ้นสุด' : 'กรุณาระบุภาระงาน' })
    }
 
    const er = currentEditingTask.evalRound
    const evalLabel = er
      ? `${er.d_evaluationround ?? ''}${er?.d_date ? ` (${er.d_date})` : ''}`.trim() || null
      : null

    const payload = {
      id: currentEditingTask.taskId,
      taskType: currentEditingTask.taskType,
      mainTask: currentEditingTask.mainTask,
      description: currentEditingTask.description,
      startTime: toDateTimeStr(currentEditingTask.startTime),
      endTime: toDateTimeStr(currentEditingTask.endTime),
      status: 'เสร็จสิ้น',
      fac_id: session.facId,
 
      eval_round_year: er?.d_date ?? null,
      eval_round_code: er?.evalua ?? null,
      evalu_steptasks: evalLabel,
      por_form:  currentEditingTask.porForm?.value ?? null,
      por_detel: currentEditingTask.porForm?.label ?? null,
    }

    try{
      await axios.post(`${API}/Edtdatatasks`, payload)
 
      const pIdx = allPlans.value.findIndex(p=> p.steps.some(s=> s.id===currentEditingTask.stepId))
      if (pIdx !== -1) {
        const sIdx = allPlans.value[pIdx].steps.findIndex(s=> s.id===currentEditingTask.stepId)
        if (sIdx !== -1) {
          allPlans.value[pIdx].steps[sIdx].tasks[currentEditingTask.taskIndex] = {
            id: currentEditingTask.taskId,
            taskType: currentEditingTask.taskType,
            mainTask: currentEditingTask.mainTask,
            description: currentEditingTask.description,
            startTime: currentEditingTask.startTime,
            endTime: currentEditingTask.endTime,
            status: 'เสร็จสิ้น',
            createdDate: currentEditingTask.createdDate,

            // เก็บทั้ง label และ code
            evalu_steptasks: payload.evalu_steptasks,
            por_detel: payload.por_detel,
            eval_round_year: payload.eval_round_year,
            eval_round_code: payload.eval_round_code,
            porFormCode: payload.por_form,
          }
        }
      }

      showEditTaskDialog.value = false
      Swal.fire({ icon:'success', title:'สำเร็จ', text:'แก้ไขภาระงานเรียบร้อยแล้ว', timer:1200, showConfirmButton:false })
    }catch(e){
      console.error(e)
      Swal.fire({ icon:'error', title:'ผิดพลาด', text:'แก้ไขภาระงานไม่สำเร็จ' })
    }
  }



  async function updateStepStatus(plan, step, newStatus){
    if(!step?.id){ await Swal.fire({ icon:'warning', title:'ยังไม่สามารถบันทึก', text:'ขั้นตอนนี้ยังไม่มี ID' }); return }
    const old = step.status ?? null; step.status=newStatus; step.__saving=true
    try{
      await axios.post(`${API}/UpdateStepStatus`, { id:step.id, status:newStatus, fac_id:session.facId })
      Swal.fire({ icon:'success', title:'บันทึกแล้ว', text:'อัปเดตสถานะขั้นตอนเรียบร้อย', timer:1200, showConfirmButton:false })
    }catch(e){ console.error(e); step.status=old; Swal.fire({ icon:'error', title:'บันทึกไม่สำเร็จ', text:'อัปเดตสถานะขั้นตอนไม่สำเร็จ' }) }
    finally{ step.__saving=false }
  }

  async function confirmRemoveTaskInTable(step, taskIndex){
    const ok = await Swal.fire({ title:'ยืนยันการลบ', text:'คุณต้องการลบภาระงานนี้ใช่หรือไม่?', icon:'warning', showCancelButton:true })
    if(!ok.isConfirmed) return
    const task = step.tasks[taskIndex]
    try{ await axios.post(`${API}/Deldatatask`, { data:{ id:task.id } }); step.tasks.splice(taskIndex,1); Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบภาระงานเรียบร้อยแล้ว', timer:1200, showConfirmButton:false }) }
    catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบภาระงานไม่สำเร็จ' }) }
  }

  async function confirmRemoveStepById(planId, stepId){
    const r = await Swal.fire({ title:'ยืนยันการลบ', text:'ลบขั้นตอนนี้?', icon:'warning', showCancelButton:true, confirmButtonText:'ลบ', cancelButtonText:'ยกเลิก', confirmButtonColor:'#d33', cancelButtonColor:'#3085d6' })
    if(!r.isConfirmed) return
    try{ await axios.post(`${API}/Deldatastep`, { data:{ id:stepId } }); const plan = allPlans.value.find(p=>p.id===planId); if(plan) plan.steps = plan.steps.filter(s=> s.id!==stepId); Swal.fire({ icon:'success', title:'สำเร็จ', text:'ลบขั้นตอนเรียบร้อยแล้ว', timer:1200, showConfirmButton:false }) }
    catch(e){ console.error(e); Swal.fire({ icon:'error', title:'ผิดพลาด', text:'ลบขั้นตอนไม่สำเร็จ' }) }
  }
  
  const ownerSuggestions = ref([])
  function mapStaffToOption(x){ return { id:Number(x.staffid)||x.id||null, name:x.namefully||x.name||'', staffid:x.staffid||null, posnameth:x.posnameth||null } }
  let ownerSearchTimer=null
  async function searchOwners(e){
    const q=(e.query||'').trim()
    if(ownerSearchTimer) clearTimeout(ownerSearchTimer)
    if(!q || q.length<3){ ownerSuggestions.value=[]; return }
    ownerSearchTimer=setTimeout(async()=>{
      try{
        const res = await axios.get(`${API}/searchDataStaff`, { params:{ staffid:q } })
        const arr = Array.isArray(res.data)? res.data : (res.data?.data||[])
        ownerSuggestions.value = arr.map(mapStaffToOption)
      }catch{ ownerSuggestions.value=[] }
    },250)
  }
  function getOwnerDisplay(o){ return o?.name || o?.staff_name || o?.owner_name || o?.fullname || o?.staff_fullname || `ID:${o?.id}` }
 
  function getPlanTypeSeverity(t){
    switch(t){
      case 'แผนปฏิบัติการ': return 'success'
      case 'โครงการ': return 'danger'
      case 'นโยบาย': return 'warning'
      case 'มติประชุม': return 'info'
      default: return 'secondary'
    }
  }
  function toDate(d) {
    if (!d) return null;
    const dt = typeof d === 'string' ? new Date(d) : d;
    return isNaN(dt) ? null : dt;
  }
 
  function getQuarter(dateInput) {
    const d = toDate(dateInput);
      if (!d) return '-';
    const month = d.getMonth() + 1; 
      if (month >= 10 && month <= 12) return 'ไตรมาส 1 : ต.ค. - ธ.ค.';
      if (month >= 1 && month <= 3)  return 'ไตรมาส 2 : ม.ค. - มี.ค';
      if (month >= 4 && month <= 6)  return 'ไตรมาส 3 : เม.ย. - มิ.ย.';
      if (month >= 7 && month <= 9)  return 'ไตรมาส 4 : ก.ค. - ก.ย.';
    return '-';
  } 
  function getYear(dateInput) {
    const d = toDate(dateInput);
    if (!d) return '-';
    return String(d.getFullYear() + 543);
  } 
  function getBudgetYear(dateInput){
    const d = toDate(dateInput)
    if(!d) return null
    const be = d.getFullYear() + 543
    const m  = d.getMonth() + 1 
    return m >= 10 ? String(be + 1) : String(be)
  }
  function getPlanYearDisplay(p) {
    
    const y = p?.planYear
    return (y === null || y === undefined || y === '') ? 'ไม่ระบุ' : String(y)
  }

  // โหลดรายการ "รอบประเมิน"
  async function fetchEvalRounds(){
    if(!session.staffId || !session.facId){
      console.warn('skip fetchEvalRounds: missing session ids')
      evalRounds.value = []
      return
    }
    const res = await axios.post(`${API}/showDateSet`, {
      staff_id: session.staffId,
      fac_id:   session.facId,
      group_id: session.groupId ?? null
    })
    const raw = res?.data?.data ?? res?.data ?? []
    const arr = Array.isArray(raw) ? raw : []
    evalRounds.value = arr.map(x => ({
      label: `${x.d_evaluationround} (${x.d_date})`,
      value: { d_date: x.d_date, evalua: x.evalua, d_evaluationround: x.d_evaluationround }
    }))
  }

  // เมื่อเลือกรอบประเมิน → โหลด "แบบ ป." ที่สอดคล้อง
  async function onEvaluChange(){
    const sel = newTaskInStep.evalRound
    if(!sel){
      porFormsAll.value = []
      porFormSuggestions.value = []
      newTaskInStep.porForm = null
      return
    }
    try{
      const res = await axios.post(`${API}/showdatatorplan`, {
        p_year:    String(sel.d_date ?? ''),   
        evalua:    sel.evalua ?? null,
        p_staffid: session.staffId
      })
      const raw = res?.data?.data ?? res?.data ?? []
      const list = Array.isArray(raw) ? raw : []
      porFormsAll.value = list.map(it => ({
        label: it.form_label || it.form_name || `แบบ ${it.form_no || it.id}`,
        value: it.form_code  || it.form_no   || it.id
      }))
      porFormSuggestions.value = porFormsAll.value
      newTaskInStep.porForm = null
    }catch(e){
      console.error('showdatatorplan error:', e?.response?.data || e)
      porFormsAll.value = []
      porFormSuggestions.value = []
      newTaskInStep.porForm = null
    }
  }
 
  // AutoComplete filter สำหรับ "แบบ ป."
  function completePorForm(e){
    const q = (e.query || '').toLowerCase()
    porFormSuggestions.value = (porFormsAll.value || []).filter(
      it => (it.label || '').toLowerCase().includes(q)
    ).slice(0, 30)
  }
  async function searchPorFormRemote(e){
    try {
      const q = (e.query || '').trim()
      const sel = newTaskInStep.evalRound
      if (!sel) { porFormSuggestions.value = []; return }

      if (q.length < 2) {           
        porFormSuggestions.value = []
        return
      }

      const res = await axios.post(`${API}/searchdataplan`, {
        q,
        evalua: sel.evalua,
        year:   String(sel.d_date),
        staff_id: session.staffId,
        fac_id:   session.facId,
        limit: 30
      })
      porFormSuggestions.value = Array.isArray(res?.data?.data) ? res.data.data : []
    } catch (err) {
      console.error('searchdataplan error:', err?.response?.data || err)
      porFormSuggestions.value = []
    }
  }
  async function onEditEvaluChange(){
    const sel = currentEditingTask.evalRound
    if(!sel){
      porFormsAll.value = []
      porFormSuggestions.value = []
      currentEditingTask.porForm = null
      return
    }
    try{
      const res = await axios.post(`${API}/showdatatorplan`, {
        p_year:  String(sel.d_date),
        evalua:  sel.evalua,
        p_staffid: session.staffId
      })
      const raw  = res?.data?.data ?? []
      porFormsAll.value = (Array.isArray(raw) ? raw : []).map(it => ({
        label: it.form_label || it.form_name || `แบบ ${it.form_no || it.id}`,
        value: it.form_code  || it.form_no   || it.id
      }))
      porFormSuggestions.value = porFormsAll.value
      // ถ้ามี code เดิม ให้จับคู่ตั้งค่าอัตโนมัติ
      if (currentEditingTask.porFormCode) {
        const pf = porFormsAll.value.find(
          it => String(it.value) === String(currentEditingTask.porFormCode)
        )
        currentEditingTask.porForm = pf || null
      }
    }catch(e){
      console.error('showdatatorplan(edit) error:', e?.response?.data || e)
      porFormsAll.value = []
      porFormSuggestions.value = []
      currentEditingTask.porForm = null
    }
  }
  async function searchPorFormRemoteForEdit(e){
    try {
      const q = (e.query || '').trim()
      const sel = currentEditingTask.evalRound
      if (!sel || q.length < 2) { porFormSuggestions.value = []; return }

      const res = await axios.post(`${API}/searchdataplan`, {
        q,
        evalua: sel.evalua,
        year:   String(sel.d_date),
        staff_id: session.staffId,
        fac_id:   session.facId,
        limit: 30
      })
      porFormSuggestions.value = Array.isArray(res?.data?.data) ? res.data.data : []
    } catch (err) {
      console.error('searchdataplan(edit) error:', err?.response?.data || err)
      porFormSuggestions.value = []
    }
  }




  </script>

  <style scoped>
    .custom-scroll::-webkit-scrollbar{ width:6px }
    .custom-scroll::-webkit-scrollbar-thumb{ background-color:#d1d5db; border-radius:3px }
    .loader-overlay{
      position: fixed; inset: 0; z-index: 9999;
      display: grid; place-items: center;              
      background: rgba(255,255,255,0.75);
      backdrop-filter: blur(2px);
    }
    .loader-card{
      display:flex; flex-direction:column; align-items:center; 
      padding: 1.25rem; border-radius: 0.75rem; 
      background: #fff; box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    }
</style>
