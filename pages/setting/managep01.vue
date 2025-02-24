<template>
<div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
          <Button icon="pi pi-plus" severity="warning" class="mb-2 mr-2" label="เพิ่มแบบตกลง" @click="OpenDialogAdd" /> 
            <Dialog header="เพิ่มแบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Refernce : TOR)" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
              <form>
                <InputText v-model="text_edt" type="hidden" />
                  <div class="p-fluid formgrid grid"> 
                    <div class="field col-12 md:col-4">
                      <label for="text_no">ปีงบประมาณ</label> 
                        <Dropdown id="state" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>  
                    </div>
                    <div class="field col-12 md:col-6">
                        <label for="roundevaluation">รอบประเมิน</label>
                        <Dropdown id="roundevaluation" v-model="selectedRound" :options="roundOptions" optionLabel="name" placeholder="รอบประเมิน"></Dropdown>
                    </div>  
                    <div class="field col-12 md:col-4">
                      <label for="text_target">ป.01-ป.02 สามารถบันทึกได้ถึงวันที่</label>
                      <div class="p-inputgroup">
                        <span class="p-inputgroup-addon">
                          <i class="pi pi-calendar-plus"></i>
                        </span>
                        <Calendar v-model="selectedDate" dateFormat="dd/mm/yy" placeholder="ป.01-ป.02 สามารถบันทึกได้ถึงวันที่" showIcon />
                      </div>
                    </div>
                        <div class="field col-12 md:col-4">
                          <label for="text_weight">วันที่สิ้นสุดการบันทึก</label>
                              <InputGroup>
                                  <InputGroupAddon>
                                    <i class="pi pi-calendar-plus"></i>
                                  </InputGroupAddon>
                                  <Calendar v-model="selectedDate1" dateFormat="dd/mm/yy" placeholder="วันที่สิ้นสุดการบันทึก" showIcon />
                                </InputGroup>
                            </div>
                            <div class="field col-12 md:col-4">
                          <label for="text_weight">วันที่กำหนดแสดงคะแนน</label>
                              <InputGroup>
                                  <InputGroupAddon>
                                    <i class="pi pi-calendar-plus"></i>
                                  </InputGroupAddon>
                                  <Calendar v-model="selectedDate5" dateFormat="dd/mm/yy" placeholder="วันที่กำหนดแสดงคะแนน" showIcon />
                                </InputGroup>
                            </div> 
                          </div> 
                          
                          <label for="text_weight">สังกัด</label>
                        <hr>
                              <!-- <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-12"> 
                                  <label for="text_search_no">ตัวชี้วัด / เกณฑ์การประเมิน</label>
                                      <InputGroup>  
                                        <InputText v-model="text_search_no" type="number" placeholder="ลำดับ" autocomplete="off" class="col-12 md:col-2" /> 
                                          <InputText v-model="text_search" type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/> 
                                          <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" />
                                        </InputGroup>  
                                    </div>   
                                </div>  -->
                              <!-- <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">    
                              <Column field="ind_no" header="ลำดับ" style="width: 10%">
                                    <template #body="Item">
                                    ระดับที่ {{ Item.data.ind_no }}
                              </template>
                            </Column> 
                            <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="width: 80%">
                              <template #body="Item"> 
                                    {{ Item.data.ind_Items }}
                              </template>
                            </Column>  
                            <Column field="options" header="ตัวเลือก" style="width: 10%">
                                <template #body="Item">   
                                  <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
                              </template>
                          </Column> 
                      </DataTable> -->
                    </form>
                  <template #footer>
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="savedata1" /> 
              <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
            </template>
          </Dialog> 
        </div>
      <table>
        <thead>
          <tr>
            <th>ประจำปี</th>
            <th>รอบประเมิน</th>
            <th>วันที่กำหนด ป.01-ป.02</th>
            <th>วันที่ครบกำหนด</th>
            <th>วันที่กำหนดแสดงคะแนน</th>
            <!-- <th>บันทึก</th> -->
            <!-- <th>รายละเอียด</th> -->
            <th>จัดการแบบ ป.01</th>
            <th>ลบ</th>
          </tr>
        </thead>
          <tbody>
            <tr v-for="(evaluator, index) in evaluators" :key="index">
              <td>{{ year }}</td>
              <td>{{ type }}</td>
              <td>
                <!-- <Calendar v-model="selectedDate2" dateFormat="dd/mm/yy" placeholder="วันที่กำหนด ป.01-ป.02" showIcon /> -->
              </td>
              <td>
                <!-- <Calendar v-model="selectedDate3" dateFormat="dd/mm/yy" placeholder="วันที่ครบกำหนด" showIcon /> -->
              </td>
              <td>
                <!-- <Calendar v-model="selectedDate4" dateFormat="dd/mm/yy" placeholder="วันที่กำหนดแสดงคะแนน" showIcon /> -->
              </td>
              <!-- <td>
                {{ evaluator.notes }}
                  <div class="centered-icon-cell">
                <i 
                class="pi pi-save" 
                style="font-size: 1.5em; cursor: pointer; color: green;"
                @click="editNotes(index)"
                ></i>
                </div>
              </td> -->
              <!-- <td class="centered-icon-cell">
                <i 
                class="pi pi-book" 
                style="font-size: 1.5em; cursor: pointer; color: orange;"
                @click="openReportDialog(evaluator)"
                ></i>
              </td> -->
              <td class="centered-icon-cell">
                <i 
                class="pi pi-book" 
                style="font-size: 1.5em; cursor: pointer; color: green;"
                @click="openReportDialog(evaluator)"
                ></i>
              </td>
              <td class="centered-icon-cell">
                <i 
                class="pi pi-trash" 
                style="font-size: 1.5em; cursor: pointer; color: red;"
                @click="deleteEvaluator(index)"     
                ></i>
              </td>
              <!-- <td class="centered-icon-cell">
                <i 
                class="pi pi-book" 
                style="font-size: 1.5em; cursor: pointer; color: green;"
                @click="openReportDialog(evaluator)"
                ></i>
              </td> -->
            </tr>
          </tbody>
        </table> 
          <Dialog :visible="displayDialog" modal @hide="hideDialog" :style="{ width: '90vw' }">
            <template v-slot:header>
                <h3>แบบข้อตกลงป.01</h3>
                <button @click="hideDialog" class="close-button">Close</button> 
            </template>
          <TabView>
            <TabPanel header="แบบป.01">
                <td style="text-align: right;"><strong>รอบประเมิน : </strong>
                  <label>
                    <input type="radio" name="round" value="1" v-model="round">รอบที่1 วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์
                  </label>
                  <label>
                      <input type="radio" name="round" value="2" v-model="round">รอบที่2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม
                  </label>
                  </td>
                    <div class="card mb-0"> 
                        <div class="formgroup-inline mb-1">
                            <div class="col md:col-6"> 
                                <h3 class="mb-4 card-header"><i class="pi pi-fw pi-sliders-h" style="font-size: x-large;"></i> จัดการ แบบประเมิน</h3> 
                            </div> 
                            <div class="ol md:col-3 text-right">
                                <label for="dropdownItemYear">ปีงบประมาณ : </label> 
                                <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                                
                            </div> 
                            <div class="col md:col-3 text-right"> 
                                <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" /> 
                                <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                                    <form>
                                        <InputText v-model="text_edt" type="text" />
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
                                        <div class="p-fluid formgrid grid">
                                            <div class="field col-12 md:col-12"> 
                                                <label for="text_search_no">ตัวชี้วัด / เกณฑ์การประเมิน</label>
                                                <InputGroup>  
                                                    <InputText v-model="text_search_no" type="number" placeholder="ลำดับ" autocomplete="off" class="col-12 md:col-2" /> 
                                                    <InputText v-model="text_search" type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/> 
                                                    <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" />
                                                </InputGroup>  
                                            </div>   
                                        </div> 
                                        <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">    
                                            <Column field="ind_no" header="ลำดับ" style="width: 10%">
                                                <template #body="Item">
                                                    ระดับที่ {{ Item.data.ind_no }}
                                                </template>
                                            </Column> 
                                            <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="width: 80%">
                                                <template #body="Item"> 
                                                    {{ Item.data.ind_Items }}
                                                </template>
                                            </Column>  
                                            <Column field="options" header="ตัวเลือก" style="width: 10%">
                                                <template #body="Item">   
                                                    <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
                                                </template>
                                            </Column> 
                                        </DataTable>
                                    </form>
                                    <template #footer>
                                        <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveData" /> 
                                        <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                                    </template>
                                </Dialog> 
                            </div> 
                        </div>  
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                                    <th rowspan="2" style="width: 30%;">
                                    (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                                    (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                                    </th>
                                    <th colspan="5" style="width: 18%;">(3) <br> ระดับค่าเป้าหมาย</th>
                                    <th rowspan="2" style="width: 5%;">(4) <br> ค่าคะแนน ที่ได้</th>
                                    <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                                    <th rowspan="2" style="width: 8%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
                                    <th rowspan="2" style="width: 9%;"><br> ตัวเลือก <br></th>
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
                                            <td style="text-align: left;">
                                                <b style="color: blue;">{{ item.id }}. {{ item.nameH }}</b>
                                            </td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                        <!-- P01 -->
                                        <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                            <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                            <td style="text-align: left;">
                                                <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                                <p v-for="(subIitem, idI) in item.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                    <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                                                </p>
                                            </td>
                                            <td class="text-center"> 
                                                <b v-if="subP01.p_target==1">&#10003;</b> 
                                                <b v-if="subP01.p_target!=1"></b> 
                                            </td>
                                            <td class="text-center"> 
                                                <b v-if="subP01.p_target==2">&#10003;</b> 
                                                <b v-if="subP01.p_target!=2"></b> 
                                            </td>
                                            <td class="text-center"> 
                                                <b v-if="subP01.p_target==3">&#10003;</b> 
                                                <b v-if="subP01.p_target!=3"></b> 
                                            </td>
                                            <td class="text-center"> 
                                                <b v-if="subP01.p_target==4">&#10003;</b> 
                                                <b v-if="subP01.p_target!=4"></b> 
                                            </td>  
                                            <td class="text-center"> 
                                                <b v-if="subP01.p_target==5">&#10003;</b> 
                                                <b v-if="subP01.p_target!=5"></b> 
                                            </td>
                                            <td class="text-center">{{ subP01.p_score }}</td>
                                            <td class="text-center">{{ subP01.p_weight }}%</td> 
                                            <td class="text-center">{{ (subP01.p_score * subP01.p_weight / 100).toFixed(2) }}</td>
                                            
                                            <td class="text-center">
                                                <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                            </td> 
                                        </tr> 
                                </template> 
                            </tbody>
                        </table>
                    </div> 
                </TabPanel>
              </TabView>
            </Dialog>
          </div>
          </div></div>
        </template>
<script>
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';
import FloatLabel from 'primevue/floatlabel';
import Dropdown from 'primevue/dropdown';
import { useRouter } from 'vue-router';
import { ref } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

export default {
  components: {
    Button,
    Dialog,
    FloatLabel,
    Dropdown
  },
  data() {
    return {
      searchData: null,
      staff_id: 5008886,
      facid: 201092704000,
      groupid: '01',
      products: [],
      selectedRound: null,
      selectedDate: null,
      selectedDate1: null,
      selectedDate2: null,
      selectedDate3: null,
      selectedDate4: null,
      selectedDate5: null,
      roundOptions: [
        { name: 'รอบที่ 1 วันที 1 กันยายน  ถึง วันที่ 28/29 กุมภาพันธ์', code: '2569' },
        { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2568' }
      ],
      dropdownItemYear: null,
      dropdownItemsYear: [
        { name: 'ปีงบประมาณ 2569', code: 2569 },
        { name: 'ปีงบประมาณ 2568', code: 2568 },
        { name: 'ปีงบประมาณ 2567', code: 2567 },
        { name: 'ปีงบประมาณ 2566', code: 2566 },
        { name: 'ปีงบประมาณ 2565', code: 2565 }
      ],
      DialogAdd: false,
      text_edt: null,
      text_no: null,
      text_name: null,
      text_target: null,
      text_weight: null,
      text_search_no: null,
      text_search: null,
      products_list: [],
      newActivity: '',
      newIndicator: '',
      newReport: '',
      newEvidence: '',
      activeFormIndex: null,
      activeCategory: '',
      text_detail: null,
      DialogAddfile: false,
      doc_p01_id: null,
      doc_edt: null,
      doc_name: null,
      doc_file: null,
      fileUrl: null,
      activeFileItem: null,
      persen: '',
      fileName: '',
      p01_detail_add: {},
      p03_file_add: {
        p03: null,
        displayDialog: false
      },
      year: 2567,
      type: 'วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม',
      evaluators: [
        { name: 'Evaluator 1', ratio: 'Ratio 1', date1: 'dd/mm/yy', date2: 'dd/mm/yy', date3: 'dd/mm/yy' }
        // Add more evaluators as needed
      ],
      displayDialog: false,
      selectedEvaluator: {},
      staffid_Main: 5009942,
      year_Main: 2568,
      facid_Main: 201092704000,
      groupid_Main: '01',
      dropdownItemYear: null,
      dropdownItemsYear: [
        { name: 'ปีงบประมาณ 2569', value: 2569 },
        { name: 'ปีงบประมาณ 2568', value: 2568 },
        { name: 'ปีงบประมาณ 2567', value: 2567 },
        { name: 'ปีงบประมาณ 2566', value: 2566 },
        { name: 'ปีงบประมาณ 2565', value: 2565 }
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
      dropdownItemH: null,
      dropdownItemsH: [],
      dropdownItemTarget: null,
      dropdownItemsTarget: [
        { name: 'ระดับเป้าหมาย 1', value: 1 },
        { name: 'ระดับเป้าหมาย 2', value: 2 },
        { name: 'ระดับเป้าหมาย 3', value: 3 },
        { name: 'ระดับเป้าหมาย 4', value: 4 },
        { name: 'ระดับเป้าหมาย 5', value: 5 }
      ]
    };
  },
  mounted() {
    this.showDataP01();
    this.showDataPerson();
  },
  methods: {
    showEvaluators() {
      // Implement the logic to show evaluators based on the selected filters
    },
    openReportDialogs(evaluator) {
      // Handle the dialog open action
      console.log('Opening report dialog for:', evaluator);
    },
    deleteEvaluator(index) {
      // Handle deleting an evaluator
      this.evaluators.splice(index, 1);
    },
    hideDialog() {
      this.displayDialog = false;
    },
    showDataP01() {
      axios.post('http://127.0.0.1:8000/api/showDataP01', {
        staff_id: this.staff_id,
        facid: this.facid,
        groupid: this.groupid
      }).then(res => {
        this.products = res.data;
      }).catch(error => {
        console.error('Error:', error);
      });
    },
    showDataPerson() {
      axios.post('http://127.0.0.1:8000/api/showDataPerson', {
        staff_id: this.staffid_Main,
        fac_id: this.facid_Main,
        year_id: this.year_Main,
        group_id: this.groupid_Main
      }).then(res => {
        this.products_person = res.data;
      }).catch(error => {
        console.error('Error:', error);
      });
    },
    OpenDialogAdd(item) {
      this.DialogAdd = true;
      this.text_edt = item ? item.p01_id : null;
      this.text_no = null;
      this.text_name = null;
      this.text_target = null;
      this.text_weight = null;
      this.text_search_no = null;
      this.text_search = null;
      this.products_list = [];
    },
    resetDialog() {
      this.DialogAdd = false;
    },
    async AddDatalist() {
      if (this.text_search_no == null || this.text_search == null) {
        Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
      } else {
        if (this.products_list.length < 5) {
          this.products_list.push({
            ind_no: this.text_search_no,
            ind_Items: this.text_search
          });
          this.products_list.sort((a, b) => a.ind_no - b.ind_no);
        } else {
          Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");
        }
        this.text_search_no = null;
        this.text_search = null;
      }
    },
    DeleteRegislick(data) {
      this.products_list = this.products_list.filter(product => product.ind_no !== data);
    },
    async saveData() {
      await axios.post('http://127.0.0.1:8000/api/saveDataP01', {
        staff_id: this.staff_id,
        facid: this.facid,
        text_edt: this.text_edt,
        text_no: this.text_no,
        text_name: this.text_name,
        text_target: this.text_target,
        text_weight: this.text_weight,
        products_list: this.products_list
      }).then(res => {
        Swal.fire({
          title: "เรียบร้อย!",
          text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
          icon: "success"
        });
        this.DialogAdd = false;
        this.showDataP01();
      }).catch(error => {
        console.error('Error:', error);
      });
    },
    async savedata1() {
      await axios.post('http://127.0.0.1:8000/api/savedatadate', {
        d_date: this.d_date,
        d_evaluationround: this.d_evaluationround,
        d_enddate: this.d_enddate,
        d_recordingday: this.d_recordingday,
        d_scoringday: this.d_scoringday
      }).then(res => {
        Swal.fire({
          title: "เรียบร้อย!",
          text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
          icon: "success"
        });
        this.DialogAdd = false;
        this.showdatadate();
      }).catch(error => {
        console.error('Error:', error);
      });
    },
    async editData(data) {
      await axios.post('http://127.0.0.1:8000/api/edtDataP01', {
        p01_id: data.p01_id
      }).then(res => {
        this.DialogAdd = true;
        this.text_edt = res.data[0].p01_id;
        this.text_no = res.data[0].p01_no;
        this.text_name = res.data[0].p01_subject;
        this.text_target = res.data[0].p01_target;
        this.text_weight = res.data[0].p01_weight;
        this.products_list = res.data[0].sub_ITem;
      }).catch(error => {
        console.error('Error:', error);
      });
    },
    async delData(data) {
      Swal.fire({
        title: "คุณต้องการลบแบบ ป01 ใช่หรือไม่?",
        text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!"
      }).then((result) => {
        if (result.isConfirmed) {
          axios.post('http://127.0.0.1:8000/api/delDataP01', {
            p01_id: data.p01_id
          }).then(res => {
            this.showDataP01();
            Swal.fire({
              title: "ลบข้อมูลเสร็จสิ้น!",
              text: "ข้อมูลของคุณถูกลบแล้ว",
              icon: "success"
            });
          }).catch(error => {
            console.error('Error:', error);
          });
        }
      });
    }
  },
  setup() {
    const router = useRouter();
    function navigateTo(route) {
      router.push({ path: route });
    }
    return { navigateTo };
  },

        created() { 
    this.dropdownItemYear = this.dropdownItemsYear.find(f => f.value === 2568);
  },
  mounted() { 
    this.showDataPerson();
    this.showDataP01();
  },
  methods: {
    // ดึงข้อมูลเข้าตาราง
    showDataPerson() {
      axios.post('http://127.0.0.1:8000/api/showDataPerson', {
        staff_id: this.staffid_Main,
        fac_id: this.facid_Main,
        year_id: this.year_Main, 
        group_id: this.groupid_Main,
      }).then(res => {     
        this.products_person = res.data;
      }).catch(error => {
        console.error('Error:', error);
      });
    },

    showDataP01() {
      axios.post('http://127.0.0.1:8000/api/showDataP01', {
        staff_id: this.staff_id,
        facid: this.facid,
        groupid: this.groupid,
      }).then(res => {     
        this.products = res.data;
      }).catch(error => {
        console.error('Error:', error);
      });
    },

    openReportDialog(evaluator) {
      this.selectedEvaluator = evaluator;
      this.displayDialog = true;
    },

    hideDialog() {
      this.displayDialog = false;
    },

    OpenDialogAdd() {
      this.DialogAdd = true;
      this.text_edt = null;
      this.text_no = null;
      this.text_name = null;
      this.text_target = null;
      this.text_weight = null;
      this.text_search_no = null;
      this.text_search = null;
      this.products_list = [];
    },

    resetDialog() {
      this.DialogAdd = false;
    },

    selectDataH(year, fac) {  
      axios.post('http://127.0.0.1:8000/api/selectDataPersonH', {
        year: year.value,
        fac: fac,
      }).then(res => {     
        this.dropdownItemsH = res.data;  
      }).catch(error => {
        console.error('Error:', error);
      });
    },

    async AddDatalist() {  
      if(this.text_search_no == null || this.text_search == null){
        Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
      } else {   
        if (this.products_list.length < 5) {
          this.products_list.push({
            ind_no: this.text_search_no,
            ind_Items: this.text_search
          });  
          this.products_list.sort((a, b) => a.ind_no - b.ind_no); 
        } else {
          Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");
        } 
        this.text_search_no = null;
        this.text_search = null;
      }
    },

    DeleteRegislick(data) {
      this.products_list = this.products_list.filter(product => product.ind_no !== data); 
    },

    async saveData() {
      await axios.post('http://127.0.0.1:8000/api/saveDataPerson', {
        staff_id: this.staffid_Main,
        fac_id: this.facid_Main,
        year_id: this.dropdownItemYear.value,  
        text_edt: this.text_edt,
        dropdownItemH: this.dropdownItemH.id,
        text_no: this.text_no,
        text_name: this.text_name,
        text_target: this.dropdownItemTarget.value,
        text_weight: this.text_weight, 
        products_list: this.products_list
      }).then(res => {  
        Swal.fire({
          title: "เรียบร้อย!",
          text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
          icon: "success"
        });
        this.DialogAdd = false; 
        this.showDataPerson();
        this.showDataP01();
      }).catch(error => {
        console.error('Error:', error);
      });
    },

    async editData(data) {   
      await axios.post('http://127.0.0.1:8000/api/edtDataPerson', {
        p_id: data.p_id
      }).then(res => { 
        this.DialogAdd = true; 
        this.text_edt = res.data[0].p_id;   
        this.text_no = res.data[0].p_no; 
        this.text_name = res.data[0].p_subject;  
        const target_f = this.dropdownItemsTarget.filter(f => f.value == res.data[0].p_target)
        this.dropdownItemTarget = target_f.length > 0 ? target_f[0] : null;    
        this.text_weight = res.data[0].p_weight;  
        this.products_list = res.data[0].sub_ITem; 
        this.selectDataHEdt(res.data[0].p_year, res.data[0].p_facid, res.data[0].h_id);
      }).catch(error => {
        console.error('Error:', error);
      });
    },

    async delData(data) {  
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
          axios.post('http://127.0.0.1:8000/api/delDataPerson', {
            p_id: data.p_id
          }).then(res => { 
            this.showDataPerson();
            this.showDataP01();
            Swal.fire({
              title: "ลบข้อมูลเสร็จสิ้น!",
              text: "ข้อมูลของคุณถูกลบแล้ว",
              icon: "success"
            });
          }).catch(error => {
            console.error('Error:', error);
          }); 
        }
      }); 
    },

    async selectDataHEdt(year, fac, he) {  
      axios.post('http://127.0.0.1:8000/api/selectDataPersonH', {
        year: year,
        fac: fac,
      }).then(res => {     
        this.dropdownItemsH = res.data;  
        const h_f = res.data.filter(f => f.id == he); 
        this.dropdownItemH = h_f.length > 0 ? h_f[0] : null;    
      }).catch(error => {
        console.error('Error:', error);
      });
    }
  },
  setup() {
    const router = useRouter();
    function navigateTo(route) {
      router.push({ path: route });
    }
    return { navigateTo };
  }
};
  </script>

  <style scoped>
  .assessment-container {
    width: 100%;
    padding: 20px;
  }

  .filters {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  thead {
    background-color: #212121;
    color: rgb(247, 244, 244);
  }

  th, td {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
  }
  thead th {
    background-color: #090909;
  }

  .centered-button-cell {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
  }

  img {
    width: 24px;
    height: 24px;
  }

  .report-content {
    padding: 20px;
    font-size: 16px;
  }

  .report-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 20px;
  }

  .close-button {
    background: none;
    border: none;
    font-size: 16px;
    cursor: pointer;
  }
  .contract-details {
    font-family: Arial, sans-serif;
  }

  .employee-info{
    margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
    padding-left: 30px
  }
  .explanation p {
    margin: 10px 0;
  }

  .explanation h2 {
    margin-top: 20px;
  }
  .image-container {
    display: flex;
    justify-content: center;
  }
  .contract-image {
    width: 200px; /* Example fixed width */
    height: auto;
  }
  .explanation {
    margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
    padding-left: 30px; /* ปรับการเยื้องเข้าด้านใน */
  }
  .navbar {
    display: flex;
    justify-content: left; /* จัดปุ่มให้กึ่งกลาง */
    align-items: center; /* จัดปุ่มให้กึ่งกลางในแนวตั้ง */
    padding: 15px; /* เพิ่มระยะห่างรอบๆ แถบเมนู */
    background-color: #f5f5f5; /* สีพื้นหลังของแถบเมนู */
    border-bottom: 1px solid #ddd; /* เส้นขอบที่ด้านล่าง */
  }

  .nav-button {
    margin: 0 5px; /* ลดระยะห่างแนวนอนระหว่างปุ่ม */
    padding: 8px 16px; /* ลดระยะห่างภายในปุ่ม */
    font-size: 16px; /* ขนาดของข้อความในปุ่ม */
    border-radius: 4px; /* ลดมุมโค้งของปุ่ม */
  }
  label{
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left; /* Aligns text to the left */
    margin: 0; /* Removes default margins */
    padding: 0; /* Removes default padding */
}
body {
    font-family: 'Prompt', Arial, sans-serif;
    background-color: #f5f5f5;
    margin: 0;
    padding: 0;
}
.container {
    width: 95%;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
h3 {
    text-align: center;
    margin-bottom: 20px;
}
table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
    
}
th, td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
}
th {
    background-color: #090909;
    color: white;
}
th, td:first-child {
    width: 35%; /* Adjusted width for first column */
}
td:nth-child(2), td:nth-child(3) {
    width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
    margin: 5px 0; /* Reduced margin */
    font-size: 14px; /* Smaller font size for form */
    display: none;
}
.add-button, .save-button, .cancel-button {
    margin: 3px; /* Smaller margin */
    padding: 6px 12px; /* Smaller padding */
    font-size: 12px; /* Smaller font size for buttons */
}
.form-container {
    padding: 8px; /* Reduced padding */
    border: 1px solid #ddd;
    background-color: #f0f0f0;
    border-radius: 4px;
    font-size: 14px; /* Smaller font size */
}
.edit-icon, .delete-icon {
    margin: 0 8px; /* Smaller margin */
    cursor: pointer;
    font-size: 16px; /* Slightly larger font size */
}
.bordered-box {
  border: 1px solid rgb(179, 177, 177);
  padding: 20px;
  margin-top: 20px;
}
.content p {
  margin: 10px 0;
}

.signatures {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}
  </style>
