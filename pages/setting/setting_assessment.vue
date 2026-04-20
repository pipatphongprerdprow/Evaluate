<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                   
                    <div class="col md:col-6"> 
                        <h4 v-if="dataP01" class="mb-4 card-header"><i class="pi pi-fw pi-sliders-h" style="font-size: x-large;"></i>  
                            จัดการ แบบประเมิน {{ dataP01.d_evaluationround }} ปีงบประมาณ : {{ dataP01.year }}  
                            <!-- {{ dataP01 }} -->
                        </h4> 
                    </div>
                    <!-- <div class="col md:col-4 text-left"> 
                        <label for="dropdownItemYear">รอบประเมิน : {{ dataP01.evalua }} </label> 
                    </div>
                    <div class="col md:col-3 text-left"> 
                        <label for="dropdownItemYear">ปีงบประมาณ : {{ dataP01.year }}  {{ user.user.name.SCOPES?.staffdepartment }}</label> 
                    </div>      -->  
                    <div class="col md:col-6 text-right"> 
                        <Button icon="pi pi-plus" severity="warning" class="mb-2 mr-2" label="เพิ่มประเภทภาระงาน" @click="OpenDialogAddwork" /> 
                        <Button icon="pi pi-plus" severity="help" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" /> 
                        <Button  icon="pi pi-copy"  severity="success" class="mb-2" label="คัดลอกข้อมูลรอบประเมิน" @click="copyEvaluationData" />
 
                        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top">
                            <form>
                                <InputText v-model="text_edt" type="hidden" style="display: none;" />
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dropdownItemH">ประเภทภาระงาน</label>
                                        <Dropdown id="dropdownItemH" v-model="dropdownItemH" :options="dropdownItemsH" optionLabel="nameH" placeholder="เลือกประเภทภาระงาน"></Dropdown>
                                    </div>
                                    <div class="field col-12 md:col-2">
                                        <label for="text_no">ข้อที่</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar-plus"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_no" type="number" placeholder="ข้อ" autocomplete="off" /> 
                                        </InputGroup> 
                                    </div>
                                    <div class="field col-12 md:col-6">
                                        <label for="text_name">เรื่อง</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-book"></i>
                                            </InputGroupAddon>
                                            <Textarea v-model="text_name" rows="1" placeholder="เรื่อง" autocomplete="off" /> 
                                        </InputGroup>  
                                    </div> 
                                    <div class="field col-12 md:col-3">
                                        <label for="text_target">ระดับค่าเป้าหมาย</label>
                                        <Dropdown id="dropdownItemTarget" v-model="dropdownItemTarget" :options="dropdownItemsTarget" optionLabel="name" placeholder="เลือกระดับค่าเป้าหมาย"></Dropdown>
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_weight">น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-tags"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_weight" type="number" placeholder="น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)" autocomplete="off" />  
                                        </InputGroup>  
                                    </div>  
                                </div> 
                                <hr>
                                <!-- <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-12"> 
                                        <label for="text_search_no">ตัวชี้วัด / เกณฑ์การประเมิน</label>
                                        <InputGroup>  
                                            <InputText v-model="text_search_no" type="number" placeholder="ลำดับ" autocomplete="off" class="col-12 md:col-2" /> 
                                            <InputText v-model="text_search" type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/>  
                                             <Button icon="pi pi-save" label="บันทึก" severity="warning" @click.prevent="AddDatalist" /> 
                                        </InputGroup>  
                                    </div>   
                                </div>  
                                <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">    
                                    <Column field="ind_no" header="ลำดับ" style="width: 10%">
                                        <template #body="Item">
                                            ลำดับที่ {{ Item.data.ind_no }}
                                        </template>
                                    </Column> 
                                    <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="width: 80%">
                                        <template #body="Item"> 
                                           {{ Item.data.ind_Items }}
                                        </template>
                                    </Column>  
                                    <Column field="options" header="ตัวเลือก" style="width: 10%">
                                        <template #body="Item" >   
                                            <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="Editcriteria(Item.data)"></Button> &nbsp;
                                            <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
                                        </template>
                                    </Column> 
                                </DataTable> -->
 
                                <!-- ฟอร์มบันทึกตัวชี้วัด / เกณฑ์การประเมิน แบบบันทึกหลายรายการ -->
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-12"> 
                                        <div class="flex justify-content-between align-items-center mb-2">
                                            <label class="mb-0" for="indicatorRows">
                                                ตัวชี้วัด / เกณฑ์การประเมิน
                                                <small class="ml-2 text-500">
                                                    (เพิ่มได้สูงสุด {{ maxIndicatorLevels }} ระดับ ต่อหนึ่งรายการ)
                                                </small>
                                            </label>

                                            <div class="flex items-center gap-3 mt-2">
                                                <Button icon="pi pi-plus" label="เพิ่มแถว" class="p-button-sm p-button-rounded p-button-success"  @click="addIndicatorRow" /> 
                                                <Button icon="pi pi-eraser" label="ล้างฟอร์ม" class="p-button-sm p-button-rounded p-button-warning" @click="resetIndicatorForm" />
                                            </div> 
                                        </div> 
                                        <div class="formgrid grid mb-1 text-center text-700">
                                            <div class="col-12 md:col-2 font-bold">ลำดับ</div>
                                            <div class="col-12 md:col-9 font-bold">ชื่อตัวชี้วัด / เกณฑ์การประเมิน</div>
                                            <div class="col-12 md:col-1"></div>
                                        </div> 
                                        <div v-for="(row, idx) in indicatorRows" :key="idx" class="field col-12 mb-2" >
                                            <div class="formgrid grid align-items-center"> 
                                                <div class="col-12 md:col-2">
                                                    <InputText v-model="row.ind_no" type="number" placeholder="ลำดับ" autocomplete="off" />
                                                </div>  
                                                <div class="col-12 md:col-9"> 
                                                    <InputText v-model="row.ind_Items"  type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off" />
                                                </div> 
                                                <div class="col-12 md:col-1 flex justify-content-center md:justify-content-end mt-2 md:mt-0">
                                                    <Button  v-if="indicatorRows.length > 1" icon="pi pi-trash" severity="danger" class="p-button-text p-button-sm" @click="removeIndicatorRow(idx)" />
                                                </div>
                                            </div>
                                        </div> 
                                        <div class="field col-12 mt-2">
                                            <div class="flex justify-content-center">
                                                <Button icon="pi pi-save" label="เพิ่มเข้ารายการ" severity="info" size="small" class="p-button-rounded px-4 btn-add-indicator" @click.prevent="AddDatalist" />
                                            </div>
                                        </div>
                                        <small class="block mt-1 text-600">
                                            * ระบบจะไม่รับค่าลำดับซ้ำ และจำกัดสูงสุด {{ maxIndicatorLevels }} ระดับต่อรายการ
                                        </small>
                                    </div>
                                </div> 
                                <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                                    <Column field="ind_no" header="ลำดับ" style="width: 10%">
                                        <template #body="Item">
                                            ลำดับที่ {{ Item.data.ind_no }}
                                        </template>
                                    </Column>
                                    <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="width: 80%">
                                        <template #body="Item">
                                            {{ Item.data.ind_Items }}
                                        </template>
                                    </Column>
                                    <!-- <Column field="options" header="ตัวเลือก" style="width: 10%">
                                        <template #body="Item">
                                            <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="Editcriteria(Item.data)" ></Button>
                                            &nbsp;
                                            <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)" ></Button>
                                        </template>
                                    </Column> -->
                                    <Column field="options" header="ตัวเลือก" headerStyle="text-align:center; width:10%;" bodyStyle="text-align:center;">
                                        <template #body="Item">
                                            <div class="flex justify-content-center gap-2">
                                                <Button severity="primary" icon="pi pi-pencil" class="p-button-text p-button-rounded icon-btn-sm p-button-sm" outlined @click="Editcriteria(Item.data)" />
                                                <Button severity="danger" icon="pi pi-trash" class="p-button-text p-button-rounded icon-btn-sm p-button-sm" outlined @click="DeleteRegislick(Item.data.ind_no)" />
                                            </div>
                                        </template>
                                    </Column>
                                </DataTable> 
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveData" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog> 

                        <!-- เพิ่มภาระงาน -->
                        <Dialog header="จัดการภาระงาน" maximizable v-model:visible="DialogAddwork" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <form>
                                <InputText v-model="text_edt" type="hidden" style="display: none;" /> 
                                    <div class="field col-12 md:col-2" v-show="false">
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-sort-numeric-up"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_search_nowork" type="number" placeholder="ลำดับที่" autocomplete="off" /> 
                                        </InputGroup> 
                                    </div> 
                                    <div class="p-fluid formgrid grid ">
                                        <div class="field col-12 md:col-2">
                                            <label for="text_search_nowork">ลำดับ</label>
                                            <InputGroup>
                                                <InputGroupAddon>
                                                    <i class="pi pi-sort-numeric-up"></i>
                                                </InputGroupAddon>
                                                    <InputText v-model="text_nowork" type="number" placeholder="ลำดับที่" autocomplete="off" /> 
                                            </InputGroup> 
                                        </div>
                                        

                                        <div class="field col-12 md:col-3">
                                            <label for="text_Evalua">รอบประเมิน</label>
                                            <InputGroup>
                                                <InputGroupAddon>
                                                    <i class="pi pi-calendar"></i>
                                                </InputGroupAddon>
                                                    <Dropdown v-model="text_Evalua" :options="evaluaOptions" optionLabel="label" optionValue="value" placeholder="เลือกรอบประเมิน" class="w-full"/>
                                            </InputGroup>
                                        </div> 
                                        <div class="field col-12 md:col-7"> 
                                            <label for="text_search_nowork">เพิ่มประเภทภาระงาน</label> 
                                            <InputGroup>
                                                <InputGroupAddon>
                                                    <i class="pi pi-book"></i>
                                                </InputGroupAddon>
                                                <Textarea v-model="text_searchwork" rows="1" placeholder="ชื่อภาระงาน" autocomplete="off" /> 
                                            </InputGroup> 
                                        </div>   
                                    </div>  
                                </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDatawork" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialogwork" />
                            </template>
                        </Dialog> 

                        <!-- คัดลอกข้อมูลรอบประเมิน -->
                         <Dialog header="คัดลอกข้อมูลแบบประเมิน ป01" maximizable v-model:visible="DialogCopy" :breakpoints="{ '960px': '75vw' }" :style="{ width: '60vw' }" :modal="true" position="top" >
                            <form>
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-12">
                                        <label>
                                            <b>เลือกปีงบประมาณและรอบประเมินที่ต้องการคัดลอก</b>
                                        </label>

                                        <!-- แสดงรายการปี + รอบ ที่ backend ส่งมา -->
                                        <div
                                            v-for="round in evalRounds"
                                            :key="round.year + '-' + round.evalua"
                                            class="flex align-items-center mb-2"
                                        >
                                            <RadioButton
                                                :inputId="'round-' + round.year + '-' + round.evalua"
                                                name="evalRound"
                                                :value="round"                    
                                                v-model="selectedEvalRound"
                                            />
                                            <label class="ml-2"  :for="'round-' + round.year + '-' + round.evalua" >
                                                <!-- ปี {{ round.year }} รอบที่ {{ round.evalua }} {{ getRoundDesc(round.evalua) }} -->
                                                 รอบที่ {{ round.evalua }}  {{ getRoundDesc(round.evalua) }}  ปี {{ round.year }}
                                            </label>
                                        </div>

                                        <small class="text-gray-600">
                                            * เลือกปี/รอบที่เคยบันทึกแบบ ป01 ไว้ แล้วคัดลอกมาใช้ใน
                                            ปี {{ dataP01.year }} รอบที่ {{ dataP01.evalua }}
                                        </small>
                                    </div>
                                </div>
                            </form>

                            <template #footer>
                                <Button
                                    label="บันทึก"
                                    icon="pi pi-check"
                                    class="mb-2 mr-2"
                                    @click="confirmCopyEvaluation"
                                />
                                <Button
                                    label="ยกเลิก"
                                    icon="pi pi-times"
                                    class="mb-2 mr-2"
                                    severity="danger"
                                    @click="cancelDialogcopy"
                                />
                            </template>
                        </Dialog>

                    </div> 
                </div>  
                <!-- <table class="table table-bordered"> -->
                <table class="table">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                            <th rowspan="2" style="width: 23%;">
                            (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                            (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                            </th>
                            <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                            <th rowspan="2" style="width: 7%;">(4) <br> ค่าคะแนน ที่ได้</th>
                            <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                            <th rowspan="2" style="width: 10%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
                            <th rowspan="2" style="width: 10%;"><br> ตัวเลือก <br></th>
                        </tr>
                        <tr>
                            <th>1</th>  
                            <th>2</th>  
                            <th>3</th>  
                            <th>4</th>  
                            <th>5</th>  
                        </tr>
                    </thead>
                    <tbody>
                        <template v-for="(item, index) in products_person" :key="index"> 
                                <tr >
                                    <td style="text-align: left;" colspan="8">
                                        <b style="color: blue;"> {{ item.h_no }}. {{ item.nameH }}</b>
                                        <!-- {{ item.id }}. -->
                                    </td>  
                                    <!-- <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td> -->
                                    <td></td>
                                    <td></td>
                                    <!-- <td>
                                        <Button severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded  @click="Edtwork(item)"></Button>&nbsp; 
                                        <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="Delework(item)"></Button>
                                    </td> -->
                                     <td class="text-center">
                                        <div class="flex justify-content-center gap-2">
                                            <Button  severity="primary" icon="pi pi-pencil" class="p-button-text p-button-rounded icon-btn-sm p-button-sm" outlined @click="Edtwork(item)" /> 
                                            <!-- <Button  severity="danger" icon="pi pi-trash" class="p-button-text p-button-rounded icon-btn-sm p-button-sm" outlined @click="Delework(item)" /> -->
                                             <Button v-if="!item.subP01s || item.subP01s.length === 0" severity="danger" icon="pi pi-trash" class="p-button-text p-button-rounded icon-btn-sm p-button-sm" outlined @click="Delework(item)"/>
                                        </div>
                                    </td> 
                                </tr>
                                <!-- P01 -->
                                <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                    <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td> 

                                    <!-- แก้แดง -->
                                    <!-- <td style="text-align: left;">
                                        <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                        <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                            <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                            <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div> 
                                        </p>
                                    </td> -->
                                    <td style="text-align: left;">
                                        <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ subP01.p_subject }}</b> 
                                        <div v-for="(subItem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px; margin-bottom: 5px;">
                                            <template v-if="subItem.ind_no != 0"> <b>ระดับ {{ subItem.ind_no }}</b> {{ subItem.ind_Items }} </template>
                                            <template v-else> <b>{{ subItem.ind_Items }}</b> </template>
                                        </div>
                                    </td>

                                    <td style=" vertical-align: middle;" class="text-center"> 
                                        <b v-if="subP01.p_target==1">&#10003;</b> 
                                        <b v-if="subP01.p_target!=1"></b> 
                                    </td>
                                    <td style=" vertical-align: middle;" class="text-center"> 
                                        <b v-if="subP01.p_target==2">&#10003;</b> 
                                        <b v-if="subP01.p_target!=2"></b> 
                                    </td>
                                    <td style=" vertical-align: middle;" class="text-center"> 
                                        <b v-if="subP01.p_target==3">&#10003;</b> 
                                        <b v-if="subP01.p_target!=3"></b> 
                                    </td>
                                    <td style=" vertical-align: middle;" class="text-center">
                                        <b v-if="subP01.p_target==4">&#10003;</b> 
                                        <b v-if="subP01.p_target!=4"></b> 
                                    </td>  
                                    <td style=" vertical-align: middle;" class="text-center"> 
                                        <b v-if="subP01.p_target==5">&#10003;</b> 
                                        <b v-if="subP01.p_target!=5"></b>  
                                    </td>
                                    <td style=" vertical-align: middle;" class="text-center">{{ subP01.p_score }}</td>
                                    <td style=" vertical-align: middle;" class="text-center">{{ subP01.p_weight }}%</td> 
                                    <td style=" vertical-align: middle;" class="text-center">{{ (subP01.p_score * subP01.p_weight / 100).toFixed(2) }}</td>
                                    
                                    <td style=" vertical-align: middle;" class="text-center"> 
                                        <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                    </td> 
                                </tr> 
                        </template> 
                    </tbody>
                </table>
            </div> 
        </div> 
    </div> 
</template>
<script setup> 
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    // console.log(user); 
</script> 
  
  <script> 
  import { ref } from 'vue';
  import axios from 'axios';
  import RadioButton from 'primevue/radiobutton';  
  import Swal from 'sweetalert2'
    export default {
            components: {
            RadioButton,
        },  
        props: { 
            dataP01: {
            type: Object,
            required: true
            }
        },
        data() {
            return { 
                staffid_Main: '',
                year_Main: '',
                facid_Main: '',
                evalua: '',
                groupid_Main: '01',
                dropdownItemYear: null ,
                dropdownItemsYear: [
                    { name: 'ปีงบประมาณ 2572', value: 2572 },
                    { name: 'ปีงบประมาณ 2571', value: 2571 },
                    { name: 'ปีงบประมาณ 2570', value: 2570 }, 
                    { name: 'ปีงบประมาณ 2569', value: 2569 },
                    { name: 'ปีงบประมาณ 2568', value: 2568 },
                    { name: 'ปีงบประมาณ 2567', value: 2567 },
                    { name: 'ปีงบประมาณ 2566', value: 2566 },
                    { name: 'ปีงบประมาณ 2565', value: 2565 },
                ],
                products_person: [],    
                itemsBtu: (item) => [
                    {
                        label: 'แก้ไขข้อมูล',
                        icon: 'pi pi-refresh',
                        command: () => {
                            this.editData(item);
                        }
                    },
                    {
                        label: 'ลบข้อมูล',
                        icon: 'pi pi-times',
                        command: () => {
                            this.delData(item);
                        }
                    }
                ],
                    text_Evalua: null, // เก็บค่าที่ผู้ใช้เลือก เช่น 1 หรือ 2
                    evaluaOptions: [
                    { label: 'รอบประเมินที่ 1', value: 1 },
                    { label: 'รอบประเมินที่ 2', value: 2 }
                ],
                // Dialog
                DialogAdd: false, 
                DialogAddwork: false,
                text_edt: null,
                dropdownItemH: null ,
                dropdownItemsH: [],
                text_no: null,
                text_name: null, 
                dropdownItemTarget: null ,
                dropdownItemsTarget: [
                    { name: 'ระดับเป้าหมาย 1', value: 1 },
                    { name: 'ระดับเป้าหมาย 2', value: 2 },
                    { name: 'ระดับเป้าหมาย 3', value: 3 },
                    { name: 'ระดับเป้าหมาย 4', value: 4 },
                    { name: 'ระดับเป้าหมาย 5', value: 5 },
                ],
                text_weight: null,
                text_search_no: null,
                text_search: null,
                editIndex: null,
                products_list: [], 
                 maxIndicatorLevels: 5, // จำกัดไม่เกิน 5 ระดับ
                indicatorRows: [
                    { ind_no: null, ind_Items: '' }
                ], 

                //เพิ่มภาระงาน
                text_search_nowork: null,
                text_searchwork: null,
                text_nowork:null,
                text_Evalua:null,
                products_listwork: [],

                //คัดลอกรอบประเมิน
                DialogCopy: false,
                evalRounds: [],          // รายการรอบที่ใช้เป็นต้นทาง
                selectedEvalRound: null, // รอบที่เลือกคัดลอกจาก


               
                 
               



                
                
  
            }
        },
        created() { 
            this.dropdownItemYear = this.dropdownItemsYear.find(f => f.value === 2568);
        },
        mounted(){ 
            // this.staffid_Main: '',
            this.staffid_Main = this.dataP01.staffid,
            this.year_Main = this.dataP01.year,
            this.facid_Main = this.dataP01.staffdepartment,
            this.evalua = this.dataP01.evalua,
            this.showDataPerson(this.dataP01.year,this.dataP01.staffdepartment,this.dataP01.evalua);
        },

      methods: { 
        // ดึงข้อมูลเข้าตาราง
        showDataPerson(year_id,fac_id,evalua){
            axios.post('   http://127.0.0.1:8000/api/showDataPerson',{  
            fac_id: fac_id,
            evalua: evalua,
            year_id: year_id,
            //เพิ่มล่าสุด
            //staff_id: staff_id
            }).then(res => {     
               // console.log(res.data);  
                //this.products_person=res.data;
                 this.products_person = res.data.sort((a, b) => {
                    return Number(a.h_no) - Number(b.h_no);
                });
                
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        
        // เปิดหน้าต่างสำหรับบันทึก 
        OpenDialogAdd(){
            this.DialogAdd = true; 
            this.text_edt = null;
            this.dropdownItemH = null;
            this.text_no = null;
            this.text_name = null; 
            this.dropdownItemTarget = null;
            this.text_weight = null;
            this.text_search_no = null;
            this.text_search = null;
            this.products_list = [];
            // this.selectDataH(this.year_Main,this.facid_Main );
            this.selectDataH(this.dataP01.year, this.dataP01.staffdepartment);
        },

         // เปิดหน้าต่างสำหรับบันทึก 
         OpenDialogAddwork(){
            this.DialogAddwork = true; 
            this.text_edt = null; 
            this.text_search_nowork = null;
            this.text_searchwork = null;
            this.text_nowork = null;
            this.text_Evalua = null;
            this.products_listwork = [];
            //this.selectDataH(this.dropdownItemYear,this.facid_Main);
        },

        // ดึงข้อมูลภาระงาน
        selectDataH(year,fac){  
            //console.log(this.dataP01);
            
            axios.post('   http://127.0.0.1:8000/api/selectDataPersonH',{
                fac_id : this.dataP01.staffdepartment,
                year_id :this.dataP01.year ,
                evalua : this.dataP01.evalua ,
            }).then(res => {     
                 //console.log('selectDataH',res.data); 
                this.dropdownItemsH=res.data;  
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // บันทึกตัวชี้วัด / เกณฑ์การประเมิน ตัวเก่า

        // async AddDatalist() {
        //     if (this.text_search_no == null || this.text_search == null) {
        //         Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
        //         return;
        //     }

        //     // ถ้ามี editIndex แสดงว่าเป็นโหมด "แก้ไข"
        //     if (this.editIndex !== null) {
        //         this.products_list[this.editIndex].ind_no = this.text_search_no;
        //         this.products_list[this.editIndex].ind_Items = this.text_search;
        //         this.editIndex = null; // ออกจากโหมดแก้ไข
        //         Swal.fire("แก้ไขข้อมูลสำเร็จ", "", "success");
        //     } else {
        //         // ตรวจสอบจำนวนไม่เกิน 5 รายการ
        //         if (this.products_list.length < 5) {
        //             this.products_list.push({
        //                 ind_no: this.text_search_no,
        //                 ind_Items: this.text_search
        //             });
        //             Swal.fire("เพิ่มข้อมูลสำเร็จ", "", "success");
        //         } else {
        //             Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");
        //         }
        //     }

        //     // จัดเรียงตามลำดับ
        //     this.products_list.sort((a, b) => a.ind_no - b.ind_no);

        //     // ล้าง input
        //     this.text_search_no = null;
        //     this.text_search = null;
        // },

        //บันทึกภาระงาน
        AddDatalistwork(){
            if(this.text_search_nowork == null || this.text_searchwork == null){
                Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
            }else{   
                if (this.products_listwork.length < 5) { 
                    this.products_listwork.push({
                        id: this.text_search_nowork,
                        nameH: this.text_searchwork,
                        staff_id: this.staffid_Main,
                        fac_id: this.facid_Main,
                        year_id: this.year_Main, 
                    });  

                    this.products_listwork.sort((a, b) => a.id - b.id);  
                } else {
                    Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");
                }
            }
        },
        // ลบตัวชี้วัด / เกณฑ์การประเมิน
        DeleteRegislick(data){
            this.products_list = this.products_list.filter(product => product.ind_no !== data); 
        },

        //ลบชื่อภาระงาน 
        DeleteRegislickwork(data){
            this.products_listwork = this.products_listwork.filter(product => product.id!== data); 
        },

        // บันทึกแบบจัดการ ป.1 
        async saveData() {  
            await axios.post('   http://127.0.0.1:8000/api/saveDataPerson', {
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.year_Main,  
                evalua: this.evalua,
                text_edt: this.text_edt,
                dropdownItemH: this.dropdownItemH.id,
                text_no: this.text_no,
                text_name: this.text_name,
                text_target: this.dropdownItemTarget.value,
                text_weight: this.text_weight, 
                products_list: this.products_list, 
            }).then(res => {  
                // console.log(res.data); 
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
                    icon: "success"
                });
                this.DialogAdd = false; 
                this.showDataPerson(this.dataP01.year,this.dataP01.staffdepartment,this.dataP01.evalua);
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire("เกิดข้อผิดพลาด!", "ไม่สามารถบันทึกข้อมูลได้", "error");
                });
        },

        // บันทึกประเภทภาระงาน   
        saveDatawork() {
            // ตรวจสอบว่ามีข้อมูลในแต่ละช่องหรือไม่
            if (!this.text_nowork) {
                Swal.fire({
                    title: "แจ้งเตือน!",
                    text: "กรุณากรอกลำดับที่",
                    icon: "warning"
                });
                return; 
            }

            if (!this.text_Evalua) {
                Swal.fire({
                    title: "แจ้งเตือน!",
                    text: "กรุณาเลือกรอบประเมิน",
                    icon: "warning"
                });
                return;  
            }

            if (!this.text_searchwork) {
                Swal.fire({
                    title: "แจ้งเตือน!",
                    text: "กรุณากรอกชื่อภาระงาน",
                    icon: "warning"
                });
                return;  
            }

            // ถ้าข้อมูลครบถ้วน ก็ทำการบันทึกข้อมูล
            axios.post('http://127.0.0.1:8000/api/saveWork', {
                id: this.text_search_nowork,
                h_no: this.text_nowork,
                h_evalua: this.text_Evalua,
                nameH: this.text_searchwork,
                // fac_id: this.facid_Main,
                // year_id: this.year_Main
                fac_id: this.dataP01.staffdepartment,  
                year_id: this.dataP01.year             
            }).then(res => {
                //console.log(res.data);
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูลภาระงานเรียบร้อย!",
                    icon: "success"
                });
                this.DialogAddwork = false;
                this.showDataPerson(this.dataP01.year, this.dataP01.staffdepartment, this.dataP01.evalua);
            }).catch(error => {
                console.error('Error:', error);
                Swal.fire("เกิดข้อผิดพลาด!", "ไม่สามารถบันทึกข้อมูลได้", "error");
            });
        },

        // ปิดหน้าต่างบันทึก
        resetDialog(){
            this.DialogAdd = false; 
        },
        resetDialogwork(){
            this.DialogAddwork = false; 
        },
        // แก้ไขข้อมูล
        async editData(data){    
        await axios.post('   http://127.0.0.1:8000/api/edtDataPerson',{
            p_id: data.p_id
        }).then(res => { 
                // console.log(res.data);   
                this.DialogAdd = true; 
                this.text_edt = res.data[0].p_id;   
                this.text_no = res.data[0].p_no; 
                this.text_name = res.data[0].p_subject;  
                const target_f = this.dropdownItemsTarget.filter(f=>f.value==res.data[0].p_target)
                this.dropdownItemTarget = target_f.length > 0 ? target_f[0] : null;    
                this.text_weight = res.data[0].p_weight;  
                this.products_list = res.data[0].sub_ITem; 
                this.selectDataHEdt(res.data[0].p_year,res.data[0].p_facid,res.data[0].h_id,res.data[0].evalua);   
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        //แก้ไขประเภทภาระงาน 
        async Edtwork(data) {
                try {
                    const res = await axios.post(' http://127.0.0.1:8000/api/Edtwork', {
                    id: data.id,
                    h_no:data.h_no,
                    nameH:data.nameH,
                    h_evalua:data.h_evalua 
                    }); 
                    //console.log("ข้อมูลที่ได้:", res.data); 
                    this.DialogAddwork = true;
                    this.text_search_nowork = res.data.id;
                    this.text_searchwork = res.data.nameH;
                    this.facid_Main = res.data.fac_id; 
                    this.text_nowork = res.data.h_no;
                    this.text_Evalua = res.data.h_evalua;
                } catch (error) {
                    console.error('Error:', error);
                }
            },  

            // async Delework(id){  
            //     Swal.fire({
            //         title: "คุณต้องการลบแบบ ป01 ใช่หรือไม่ ?",
            //         text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
            //         icon: "warning",
            //         showCancelButton: true,
            //         confirmButtonColor: "#3085d6",
            //         cancelButtonColor: "#d33",
            //         confirmButtonText: "Yes, delete it!"
            //         }).then((result) => {
            //         if (result.isConfirmed) {
            //             axios.post(' http://127.0.0.1:8000/api/Delework',{
            //                 id:id
            //             }).then(res => { 
            //                     //console.log(res.data);   
            //                 this.showDataPerson(this.dataP01.year,this.dataP01.staffdepartment,this.dataP01.evalua);
            //                 Swal.fire({
            //                 title: "ลบข้อมูลเสร็จสิ้น!",
            //                 text: "ข้อมูลของคุณถูกลบแล้ว",
            //                 icon: "success"
            //                 });
            //             })
            //             .catch(error => {
            //                 console.error('Error:', error);
            //             }); 
            //         }
            //     }); 
            // },  

        async Delework(id){  
            Swal.fire({
                title: "คุณต้องการลบหรือไม่ ?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonText: "Yes, delete it!"
            }).then((result) => {
                if (result.isConfirmed) {
                    axios.post('http://127.0.0.1:8000/api/Delework',{ id:id })
                    .then(res => { 
                        this.showDataPerson(this.dataP01.year,this.dataP01.staffdepartment,this.dataP01.evalua);

                        Swal.fire({
                            title: "สำเร็จ!",
                            text: res.data.message,
                            icon: "success"
                        });
                    })
                    .catch(error => {

                        // 🔥 ดัก error จาก backend
                        if (error.response && error.response.data.message) {
                            Swal.fire('แจ้งเตือน', error.response.data.message, 'warning');
                        } else {
                            Swal.fire('ผิดพลาด', 'ไม่สามารถลบข้อมูลได้', 'error');
                        }

                    }); 
                }
            }); 
        },
 
        //แก้ไขเกณฑ์/ตัวชี้วัดของ ป.01
        // Editcriteria(item) {
        //     const index = this.products_list.findIndex(p => p.ind_no === item.ind_no);
        //     if (index !== -1) {
        //         this.text_search_no = item.ind_no;
        //         this.text_search = item.ind_Items;
        //         this.editIndex = index;
        //     }
        // }, 

        // ดึงข้อมูลภาระงาน
        selectDataHEdt(year,fac,he,evalua){  
            //console.log(year,fac,he,evalua);
            
            axios.post('   http://127.0.0.1:8000/api/selectDataPersonH',{
                // year: year,
                // fac: fac,
                // evalua:evalua
                fac_id : this.dataP01.staffdepartment,
                year_id :this.dataP01.year ,
                evalua : this.dataP01.evalua 
            }).then(res => {     
                    //console.log(res.data); 
                this.dropdownItemsH=res.data;  
                const h_f = res.data.filter(f=>f.id==he); 
                this.dropdownItemH = h_f.length > 0 ? h_f[0] : null;    

            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // ลบข้อมูล
        async delData(data){  
            Swal.fire({
                title: "คุณต้องการลบแบบ ป01 ใช่หรือไม่ ?",
                text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                if (result.isConfirmed) {
                    axios.post('   http://127.0.0.1:8000/api/delDataPerson',{
                        p_id: data.p_id
                    }).then(res => { 
                        // console.log(res);   
                        this.showDataPerson(this.dataP01.year,this.dataP01.staffdepartment,this.dataP01.evalua);
                        Swal.fire({
                        title: "ลบข้อมูลเสร็จสิ้น!",
                        text: "ข้อมูลของคุณถูกลบแล้ว",
                        icon: "success"
                        });
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    }); 
                }
            }); 
        },   

        // เปิด Dialog คัดลอกรอบประเมิน
        copyEvaluationData() {
            this.DialogCopy = true;
            this.selectedEvalRound = null; 
            axios.post('http://127.0.0.1:8000/api/getEvalRoundsForCopy', {
                fac_id: this.dataP01.staffdepartment,
                year_id: this.dataP01.year,
                evalua: this.dataP01.evalua,
            })
            .then(res => { 
                this.evalRounds = res.data;
            })
            .catch(error => {
                console.error('getEvalRoundsForCopy error:', error);
                Swal.fire('ผิดพลาด', 'ไม่สามารถโหลดข้อมูลปี/รอบประเมินได้', 'error');
            });
        },

        // ยืนยันคัดลอกข้อมูล
        async confirmCopyEvaluation() {
            if (!this.selectedEvalRound) {
                Swal.fire('ยังไม่ได้เลือกปี/รอบ', 'กรุณาเลือกรอบประเมินที่ต้องการคัดลอก', 'warning');
                return;
            }

            const fromYear   = this.selectedEvalRound.year;
            const fromEvalua = this.selectedEvalRound.evalua;
            const toYear     = this.dataP01.year;
            const toEvalua   = this.dataP01.evalua;

            try {
                await axios.post('http://127.0.0.1:8000/api/copyDataP01FromRound', {
                    fac_id: this.dataP01.staffdepartment,
                    from_year: fromYear,
                    to_year: toYear,
                    from_evalua: fromEvalua,
                    to_evalua: toEvalua,
                    staff_id: this.staffid_Main,    
                });

                this.DialogCopy = false;

                // โหลดข้อมูลปี/รอบปัจจุบันใหม่
                this.showDataPerson(this.dataP01.year, this.dataP01.staffdepartment, this.dataP01.evalua);

                Swal.fire({
                    title: 'คัดลอกสำเร็จ!',
                    text: `คัดลอกข้อมูลจาก ปี ${fromYear} รอบที่ ${fromEvalua} → ปี ${toYear} รอบที่ ${toEvalua} เรียบร้อย`,
                    icon: 'success'
                });
            } catch (error) {
                console.error('Error copyDataP01FromRound:', error);
                Swal.fire('ผิดพลาด', 'ไม่สามารถคัดลอกข้อมูลได้', 'error');
            }
        },
        cancelDialogcopy() {
            this.DialogCopy = false;
            this.selectedEvalRound = null;
        },

        getRoundDesc(evalua) { 
            const round = parseInt(evalua, 10);
            if (round === 1) {
                return 'วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์';
            } else if (round === 2) {
                return 'วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม';
            }
            return '';
        },

        addIndicatorRow() {
            const remaining = this.maxIndicatorLevels - this.products_list.length - this.indicatorRows.length;
            if (remaining <= 0) {
                Swal.fire(
                    'ครบจำนวนระดับแล้ว',
                    `สามารถมีได้สูงสุด ${this.maxIndicatorLevels} ระดับต่อรายการ`,
                    'warning'
                );
                return;
            }

            this.indicatorRows.push({
                ind_no: null,
                ind_Items: ''
            });
        },

        removeIndicatorRow(index) {
            this.indicatorRows.splice(index, 1);
            if (this.indicatorRows.length === 0) {
                this.resetIndicatorForm();
            }
        },

        resetIndicatorForm() {
            this.indicatorRows = [
                { ind_no: null, ind_Items: '' }
            ];
            this.editIndex = null;
        },

        // บันทึกตัวชี้วัดหลายแถวเข้า products_list
        AddDatalist() {
            const validRows = this.indicatorRows.filter(r =>
                r.ind_no !== null &&
                r.ind_no !== '' &&
                r.ind_Items &&
                String(r.ind_Items).trim() !== ''
            );

            if (validRows.length === 0) {
                Swal.fire(
                    'ยังไม่มีข้อมูล',
                    'กรุณากรอกข้อมูลตัวชี้วัดให้ครบอย่างน้อย 1 แถว',
                    'warning'
                );
                return;
            }

            // โหมดแก้ไข
            if (this.editIndex !== null) {
                const row = validRows[0];

                const duplicate = this.products_list.some((p, idx) =>
                    idx !== this.editIndex && Number(p.ind_no) === Number(row.ind_no)
                );
                if (duplicate) {
                    Swal.fire('ลำดับซ้ำ', 'มี "ลำดับ" ซ้ำกับรายการอื่นในตาราง', 'warning');
                    return;
                }

                this.products_list[this.editIndex].ind_no = Number(row.ind_no);
                this.products_list[this.editIndex].ind_Items = row.ind_Items;

                Swal.fire('แก้ไขข้อมูลสำเร็จ', '', 'success');
                this.editIndex = null;
                this.resetIndicatorForm();
                this.products_list.sort((a, b) => a.ind_no - b.ind_no);
                return;
            }

            // โหมดเพิ่มใหม่
            const totalAfterAdd = this.products_list.length + validRows.length;
            if (totalAfterAdd > this.maxIndicatorLevels) {
                const remaining = this.maxIndicatorLevels - this.products_list.length;
                Swal.fire(
                    'เกินจำนวนระดับที่กำหนด',
                    `สามารถเพิ่มได้อีกเพียง ${remaining} ระดับ`,
                    'warning'
                );
                return;
            }

            const existingNos = this.products_list.map(p => Number(p.ind_no));
            const duplicateInExisting = validRows.some(r =>
                existingNos.includes(Number(r.ind_no))
            );
            if (duplicateInExisting) {
                Swal.fire(
                    'ลำดับซ้ำ',
                    'มี "ลำดับ" ซ้ำกับรายการเดิมในตาราง',
                    'warning'
                );
                return;
            }

            validRows.forEach(r => {
                this.products_list.push({
                    ind_no: Number(r.ind_no),
                    ind_Items: r.ind_Items
                });
            });

            this.products_list.sort((a, b) => a.ind_no - b.ind_no);

            Swal.fire(
                'เพิ่มข้อมูลสำเร็จ',
                `เพิ่มตัวชี้วัดจำนวน ${validRows.length} รายการ`,
                'success'
            );

            this.resetIndicatorForm();
        },

        // ลบตัวชี้วัด / เกณฑ์การประเมิน
        DeleteRegislick(ind_no) {
            Swal.fire({
                title: 'ยืนยันการลบ?',
                text: 'คุณต้องการลบตัวชี้วัด / เกณฑ์การประเมิน นี้ใช่หรือไม่',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'ใช่, ลบเลย',
                cancelButtonText: 'ยกเลิก'
            }).then((result) => {
                if (result.isConfirmed) {
                    // ลบออกจาก products_list
                    this.products_list = this.products_list.filter(
                        (product) => product.ind_no !== ind_no
                    );

                    Swal.fire({
                        title: 'ลบแล้ว!',
                        text: 'ลบตัวชี้วัดเรียบร้อย',
                        icon: 'success',
                        timer: 1200,
                        showConfirmButton: false
                    });
                }
            });
        },


        // แก้ไขเกณฑ์/ตัวชี้วัด → ดึงขึ้นมาใส่แถวแรกของฟอร์มหลายแถว
        Editcriteria(item) {
            const index = this.products_list.findIndex(p => p.ind_no === item.ind_no);
            if (index !== -1) {
                this.editIndex = index;
                this.indicatorRows = [{
                    ind_no: this.products_list[index].ind_no,
                    ind_Items: this.products_list[index].ind_Items
                }];
            }
        },

    } 
}
  
  </script>

   
  <style > 

label{
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left;  
    margin: 0;  
    padding: 0;  
}
.table th {
    background-color: #edf2bb;
    font-weight: bold;
}
.btn-add-indicator {
    width: auto !important;       
    padding-left: 1.5rem;
    padding-right: 1.5rem;
    font-size: 0.9rem;
}
.p-button-rounded {
    width: auto !important;       
    padding-left: 1.5rem;
    padding-right: 1.5rem;
    font-size: 0.9rem;
}

.p-button-sm .pi {
        font-size: 0.9rem !important;
    }
.icon-btn-sm {
    width: 36px !important;
    height: 36px !important;
    padding: 0 !important;

    display: flex !important;
    align-items: center !important;
    justify-content: center !important;

    border-radius: 50% !important;
}

.icon-btn-sm {
    width: 36px !important;
    height: 36px !important;
    padding: 0 !important;

    display: flex !important;
    align-items: center !important;
    justify-content: center !important;

    border-radius: 50% !important;
}

.swal2-container {
    z-index: 9999 !important;
    } 

  </style>