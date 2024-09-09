
<template>
  <div class="grid">
      <div class="col-12 lg:col-12 xl:col-12">
          <div class="card mb-0"> 
              <div class="formgroup-inline mb-1">
                  <div class="col md:col-6"> 
                      <h3 class="mb-4 card-header"><i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i>แบบป.03</h3> 
                      <B><h4>2.พฤติกรรมการปฏิบัติราชการ</h4></B>
                  </div> 
                  <!-- <div class="col md:col3 text-right">
                      <label for="dropdownItemYear">ปีงบประมาณ : </label> 
                      <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                  </div>  -->
                  <div class=" col md:col3 text-right">
                      <label for="dropdownItemYear" class="label">ปีงบประมาณ :</label>
                      <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                  </div>
                  <!-- <div class="col md:col-3 text-right">  -->
                      <!-- <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" />  -->
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
              <table class="table">
              <!-- <table class="table table-bordered"> -->
                  <thead>
                      <tr>
                          <th rowspan="2" style="width: 20%;"> กิจกรรม / โครงการ / งาน</th>
                          <th rowspan="2" style="width: 30%;">ตัวชี้วัด / เกณฑ์การประเมิน <br>(1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)</th>
                          <th rowspan="2" style="width: 20%;">รายงานผลปฎิบัติราชการตาม<br>ตัวชี้วัด/เกณฑ์การประเมิน</th>
                          <th rowspan="2" style="width: 20%;">หลักฐานที่แสดงถึงผลการปฎิบัติ<br>กราชการตามเกณฑ์การประเมิน <br>(หลักฐานเชิงประจักษ์)</th>
                          <th rowspan="2" style="width: 10%;">ค่าคะแนน <br>ประเมินตนเอง</th>
                      </tr>
                      
                  </thead>
                  <tbody>
                      <template v-for="(item, index) in products_person" :key="index"> 
                              <tr >
                                  <td style="text-align: left;" colspan="8">
                                      <b style="color: blue;">{{ item.id }}. {{ item.nameH }}</b>
                                  </td>  
                                  <!-- <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td> -->
                                  <td></td>
                                  <td></td>
                              </tr>
                              <!-- P01 -->
                              <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                  <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                  <td style="text-align: left;">
                                      <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                      <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                          <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                                      </p>
                                  </td>
                                  <!-- คอลัมน์ที่ 3: แสดงรายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน -->
                                  <td class="text-center">
                                      <div style="text-align: left;"> 
                                          <p v-for="(xx, index) in subP01.sub_ITemP03" :key="index" class="mb-0">
                                              <B>ระดับที่ {{ xx.p03_estimate }}</B> <br>
                                              {{ xx.p03_report }} <br>
                                              <Button icon="pi pi-pencil" severity="warning" text class="mb-2 mr-2" @click="editData(xx)" />
                                              <Button icon="pi pi-times" severity="danger" text class="mb-2 mr-2" @click="delData(xx)" /> 
                                          </p>
                                          <div style="margin-top: 10px;">
                                          <Button label="เพิ่มรายการ" severity="primary" text icon="pi pi-plus" @click="OpenDialogAdd(subP01)" />  
                                          </div>
                                      </div>
                                  </td>
                                  <!-- คอลัมน์ที่ 4: แสดงหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน -->
                                  <td class="text-center">
                                    <div style="text-align: left;">
                                        <a :href="fileUrl" target="_blank">Open Uploaded File</a>
                                        <p v-for="(xx, index) in subP01.sub_ITemDoc" :key="index" class="mb-0">
                                            <a :href="'http://localhost:8000/storage/uploads/'+xx.doc_file" target="_blank">{{ xx.doc_name }}</a> <br>
                                            <Button icon="pi pi-times" severity="danger" text class="mb-2 mr-2" @click="delDataDoc(xx)" />
                                        </p>
                                        <div style="margin-top: 10px;">
                                            <Button label="เพิ่มไฟล์" severity="primary" text icon="pi pi-plus" @click="OpenDialogAddfile(subP01)" />
                                        </div>
                                    </div>
                                </td>
                                  <!-- คอลัมน์ที่ 5: แสดงค่าคะแนนประเมินตนเอง -->
                                  <td class="text-center">{{ subP01.p01_score ?? 0 }}<br>
                                      <Button label="เพิ่ม" icon="pi pi-plus" text class="mb-2 mr-2" @click="addscorep03(subP01.p01_id)" />
                                  </td>

                                  <!-- <td class="text-center">{{ subP01.p_score }}</td> -->
                                  <!-- <td class="text-center">{{ subP01.p_weight }}%</td> 
                                  <td class="text-center">{{ (subP01.p_score * subP01.p_weight / 100).toFixed(2) }}</td> -->
                                  
                                  <!-- <td class="text-center">
                                      <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                  </td>  -->
                                  
                              </tr> 
                      </template> 
                  </tbody>
                </table>
                <B><h4>2.พฤติกรรมการปฏิบัติราชการ</h4></B><br>
        <table id="ratingTable">
          <thead>
              <tr>
                  <th rowspan="4">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                  <th rowspan="4">(1) ระดับสมรรถนะที่คาดหวัง</th>
                  <th rowspan="4">(2) ระดับสมรรถนะที่แสดงออก</th>
              </tr>
          </thead>
          <tbody>
              <tr v-for="(row, index) in coreCompetencies" :key="index">
                  <td>
                      {{ row.activity }}
                      <i class="far fa-edit edit-icon" @click="editRow('core', index)" title="แก้ไข"></i>
                      <i class="fas fa-trash-alt delete-icon" @click="deleteRow('core', index)" title="ลบ"></i>
                  </td>
                  <td>{{ row.indicator }}</td>
                  <td>
                      <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'core'">
                          <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                          <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                          <label for="file">เลือกไฟล์:</label>
                          <input type="file" @change="handleFileUpload"><br><br>
                          <button class="save-button" @click="addRow('core')">บันทึก</button>
                          <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                      </div>
                  </td>
              </tr>
          </tbody>
        </table>
      
        <!-- ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ -->
         <table id="ratingTable">
            <thead>
                <tr>
                    <th rowspan="4">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                    <th rowspan="4">(3) ระดับสมรรถนะที่คาดหวัง</th>
                    <th rowspan="4">(4) ระดับสมรรถนะที่แสดงออก</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(row, index) in jobSpecificCompetencies" :key="index">
                    <td>
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('job', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('job', index)" title="ลบ"></i>
                    </td>
                    <td>{{ row.indicator }}</td>
                    <td>
                        <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'job'">
                            <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                            <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                            <label for="file">เลือกไฟล์:</label>
                            <input type="file" @change="handleFileUpload"><br><br>
                            <button class="save-button" @click="addRow('job')">บันทึก</button>
                            <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table> 
        
        <!-- ตาราง ค. สมรรถนะอื่นๆ -->
         <table id="ratingTable">
            <thead>
                <tr>
                    <th rowspan="4">ค. สมรรถนะทางการบริหาร(สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                    <th rowspan="4">(5) ระดับสมรรถนะที่คาดหวัง</th>
                    <th rowspan="4">(6) ระดับสมรรถนะที่แสดงออก</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(row, index) in otherCompetencies" :key="index">
                    <td>
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i>
                    </td>
                    <td>{{ row.indicator }}</td>
                    <td>
                        <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'other'">
                            <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                            <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                            <label for="file">เลือกไฟล์:</label>
                            <input type="file" @change="handleFileUpload"><br><br>
                            <button class="save-button" @click="addRow('other')">บันทึก</button>
                            <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                        </div>
                    </td></tr></tbody></table>
              </div>
            </div> 
      </template> 
                          
  <script> 

import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2'
  export default {
      data() {
          return { 
              staffid_Main: 5009942,
              year_Main: 2568,
              facid_Main: 201092704000,
              groupid_Main: '01',
              dropdownItemYear: null ,
              // groupid: '01',
              products: [],
              chipsValue: [],
              activeFormIndex: 'index',
              dropdownItemsYear: [
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
              // Dialog
              DialogAdd: false, 
              text_p01_id: null,
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
              products_list: [],
              level: null,
              p01_score: null,
              roundOptions: [
        { label: 'คะแนน 1', value: 1 },
        { label: 'คะแนน 2', value: 2 },
        { label: 'คะแนน 3', value: 3 },
        { label: 'คะแนน 4', value: 4 },
        { label: 'คะแนน 5', value: 5 }
      ],
      dropdownValuesLevel: [
        { level: 1, nameLevel: 'ระดับที่ 1', value: 1 },
        { level: 2, nameLevel: 'ระดับที่ 2', value: 2 },
        { level: 3, nameLevel: 'ระดับที่ 3', value: 3 },
        { level: 4, nameLevel: 'ระดับที่ 4', value: 4 },
        { level: 5, nameLevel: 'ระดับที่ 5', value: 5 }
      ],
      coreCompetencies: [
              { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1',report: '1' },
              { activity: 'ก. 2 การบริการที่ดี', indicator: '1' },
              { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1' },
              { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1' },
              { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1' }
          ],
          jobSpecificCompetencies: [
              { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1' },
              { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1' },
              { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1' },
              { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1' },
              { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1' },
              { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1' }
              
          ],
          otherCompetencies: [
              { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0' },
              { activity: 'ค. 2 วิสัยทัศน์', indicator: '0' },
              { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0' },
              { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0' },
              { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0' }
             
          ],
              text_detail: null,
              // Dialog เพิ่มหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน
              DialogAddfile: false, 
              // upfile 
              doc_p01_id: null,
              doc_edt: null,
              doc_name: null,
              doc_file: null,
              fileUrl: null, 

              newActivity: null, 



              activeFileItem: null,
              persen: '',
              fileName: '',
              p01_detail_add: {},
              p03_file_add: {
                p03: null,
              },
              DialogAddscorep: false, 
              // p01_score: null,
              

          }
      },
      created() { 
          this.dropdownItemYear = this.dropdownItemsYear.find(f => f.value === 2568);
      },
      mounted(){ 
          // this.showDataPerson();
          this.showDataP03();
      },
    methods: { 
      // ดึงข้อมูลเข้าตาราง
      showDataPerson(){
          axios.post('http://localhost:8000/api/showDataPerson',{
          staff_id: this.staffid_Main,
          fac_id: this.facid_Main,
          year_id: this.year_Main, 
          group_id: this.groupid_Main,
          staff_id: this.staff_id,
          facid: this.facid,
          groupid: this.groupid
          }).then(res => {     
          //   console.log(res.data);  
              this.products_person=res.data;
          })
          .catch(error => {
              console.error('Error:', error);
          });
      },
      //p03
        showDataP03() {
        axios.post('http://localhost:8000/api/showDataP03', {
            staff_id: this.staffid_Main,
            fac_id: this.facid_Main,
            year_id: this.year_Main, 
            group_id: this.groupid_Main,
          })
          .then((res) => {
            console.log(res.data);
            //  this.products = res.data;
            //  this.p01_score = res.data[0].p01_score;
          })
          .catch((error) => {
            console.error('Error:', error);
          });
      },
      // รายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน
      OpenDialogAdd(item) {
      // console.log('OpenDialogAdd', item);
       this.DialogAdd = true;
      this.text_p01_id = item.p01_id;
      this.text_edt = null; 
      this.level = null;  
      this.text_detail = null; 
    },
      resetDialog() {
      this.DialogAdd = false;
    },  
    saveData() { 
      axios.post('http://localhost:8000/api/saveDataP03', {
          staff_id: this.staff_id,
          facid: this.facid,
          text_p01_id: this.text_p01_id,  
          text_edt: this.text_edt,  
          level: this.level,  
          text_detail: this.text_detail
        })
        .then((res) => {
          // console.log(res.data); 
          Swal.fire({
            title: 'เรียบร้อย!',
            text: 'บันทึกข้อมูล แบบ ป03 เรียบร้อย!',
            icon: 'success',
          });
          this.DialogAdd = false;
          this.showDataP03();
        })
        .catch((error) => {
          console.error('Error:', error);
        });
    },
    editData(data) { 
      axios.post('http://localhost:8000/api/edtDataP03', {
          p01_id: data.p01_id,
          p03_id: data.p03_id
        })
        .then((res) => {
          // console.log(res.data[0].p03_estimate);
          this.DialogAdd = true;
          this.text_p01_id = res.data[0].p01_id;
          this.text_edt = res.data[0].p03_id; 
          const level_ob = this.dropdownValuesLevel.filter(f=>f.level==res.data[0].p03_estimate)
          this.level = level_ob.length > 0 ? level_ob[0] : null;   
          this.text_detail = res.data[0].p03_report;  
        })
        .catch((error) => {
          console.error('Error:', error);
        });
    }, 
    delData(data) { 
      Swal.fire({
        title: 'คุณต้องการลบรายงานผลปฎิบัติราชการ ใช่หรือไม่ ?',
        text: 'เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
      }).then((result) => {
        if (result.isConfirmed) {
          axios.post('http://localhost:8000/api/delDataP03', {
              p01_id: data.p01_id,
              p03_id: data.p03_id,
            })
            .then((res) => {
              // console.log(res.data);
              this.showDataP03();
              Swal.fire({
                title: 'ลบข้อมูลเสร็จสิ้น!',
                text: 'ข้อมูลของคุณถูกลบแล้ว',
                icon: 'success',
              });
            })
            .catch((error) => {
              console.error('Error:', error);
            });
        }
      });
    },
    // filep03 
    OpenDialogAddfile(item) {
      //console.log(item);
      this.DialogAddfile = true;
      this.doc_p01_id = item.p01_id;
      this.doc_edt = null;
      this.doc_name = null;  
    },
    resetDialogfile() {
      this.DialogAddfile = false;
    }, 
    handleFileChange(event) {
      this.doc_file = event.target.files[0];
    },
    savefileData() {
      let formData = new FormData();
      formData.append('doc_edt', this.doc_edt || "");
      formData.append('doc_p01_id', this.doc_p01_id);
      formData.append('doc_name', this.doc_name);
      formData.append('doc_file', this.doc_file);

      axios.post('http://localhost:8000/api/saveDatadoc', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      }) 
      .then((res) => {
          // console.log(res.data);  
          Swal.fire({
            title: 'เรียบร้อย!',
            text: 'บันทึกข้อมูลไฟล์ แบบ ป03 เรียบร้อย!',
            icon: 'success',
          });
          this.DialogAddfile = false;
          this.showDataP03();
      })
      .catch((error) => {
        console.error('Error:', error);
      });
    }, 
    delDataDoc(data) { 
      Swal.fire({
        title: 'คุณต้องการลบไฟล์หลักฐาน ใช่หรือไม่ ?',
        text: 'เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!',
      }).then((result) => {
        if (result.isConfirmed) {
          axios.post('http://localhost:8000/api/delDatadoc', {
            doc_file: data.doc_file, 
            doc_id: data.doc_id,
            p01_id: data.p01_id,
          })
          .then((res) => {
              // console.log(res.data);
              this.showDataP03();
              Swal.fire({
                title: 'ลบข้อมูลเสร็จสิ้น!',
                text: 'ข้อมูลของคุณถูกลบแล้ว',
                icon: 'success',
              });
            })
            .catch((error) => {
              console.error('Error:', error);
            });
        }
      }); 
    }, 
    // scorep03
    addscorep03(item) { 
      axios.post('http://localhost:8000/api/selectDatascorep', {
        p01_id: item,
      }).then((res) => {
        // console.log('data',res.data); 
        // console.log('item',item); 
          this.DialogAddscorep = true; 
          this.scorep_p01_id = item;   
            // ค้นหาค่าที่ตรงกับ p01_score
          const x = this.roundOptions.filter(f => f.value == res.data[0].p01_score);
            // ถ้าพบค่า ให้ตั้งค่า p01_score ตามค่าแรกที่พบ, ถ้าไม่พบ ให้ตั้งค่าเป็น 0
          this.p01_score = x.length > 0 ? x[0] : 0;

      })
      .catch((error) => {
        console.error('Error:', error);
      });
    },
    resetDialogscorep() {
      this.DialogAddscorep = false;
    }, 

    savescorepData() {
      // console.log('Save score:', data); 
      axios.post('http://localhost:8000/api/savescorep03', {
        p01_score: this.p01_score,
        p01_id: this.scorep_p01_id,
      }).then((res) => {
        // console.log(res.data); 
        this.showDataP03(); 
        Swal.fire({
          title: 'บันทึกข้อมูลเสร็จสิ้น!',
          text: 'บันทึก ค่าคะแนนประเมินตนเอง เสร็จสิ้น',
          icon: 'success',
        });
        this.DialogAddscorep = false;
      })
      .catch((error) => {
        console.error('Error:', error);
      });
       
    }, 
    //สิ้นสุด P03
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
          this.selectDataH(this.dropdownItemYear,this.facid_Main);
      },
      // ดึงข้อมูลภาระงาน
      selectDataH(year,fac){  
          axios.post('http://localhost:8000/api/selectDataPersonH',{
              year: year.value,
              fac: fac,
          }).then(res => {     
              // console.log(res.data); 
              this.dropdownItemsH=res.data;  
          })
          .catch(error => {
              console.error('Error:', error);
          });
      },
      // บันทึกตัวชี้วัด / เกณฑ์การประเมิน
      async AddDatalist(){  
          if(this.text_search_no == null || this.text_search == null){
              Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
          }else{   
              if (this.products_list.length < 5) {
                  this.products_list.push({
                      ind_no: this.text_search_no,
                      ind_Items: this.text_search
                  });  
                  // Sort the products_list by ind_no in asc order
                  this.products_list.sort((a, b) => a.ind_no - b.ind_no); 
              } else {
                  Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");

              } 
              this.text_search_no = null;
              this.text_search = null;
          }
      },
      // ลบตัวชี้วัด / เกณฑ์การประเมิน
      DeleteRegislick(data){
          this.products_list = this.products_list.filter(product => product.ind_no !== data); 
      },
      // บันทึกแบบจัดการ ป.1 
      async saveData(){
          await axios.post('http://localhost:8000/api/saveDataPerson',{
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
          })
          .catch(error => {
              console.error('Error:', error);
          });
      },
      // ปิดหน้าต่างบันทึก
      resetDialog(){
          this.DialogAdd = false; 
      },
      // แก้ไขข้อมูล
      async editData(data){   
        await axios.post('http://localhost:8000/api/edtDataPerson',{
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
              this.selectDataHEdt(res.data[0].p_year,res.data[0].p_facid,res.data[0].h_id);
               
        })
        .catch(error => {
            console.error('Error:', error);
        });
      },
      // ดึงข้อมูลภาระงาน
      selectDataHEdt(year,fac,he){  
          axios.post('http://localhost:8000/api/selectDataPersonH',{
              year: year,
              fac: fac,
          }).then(res => {     
              // console.log(res.data); 
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
                  axios.post('http://localhost:8000/api/delDataPerson',{
                      p_id: data.p_id
                  }).then(res => { 
                      // console.log(res);   
                      this.showDataPerson();
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
  
      
  } 
}

</script>

<style> 
label{
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left; /* Aligns text to the left */
    margin: 0; /* Removes default margins */
    padding: 0; /* Removes default padding */
}
label {
  font-size: medium;
  font-weight: 500;
}
.container {
  text-align: center;
}
.button-container {
  display: flex;
  justify-content: center;
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
  background-color: #ffffff;
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
.edit-icon {
  color: #ffc107;
}
.delete-icon {
  color: #dc3545;
}
th {
  background-color: #f1e989;
  color: rgb(5, 5, 5);
}
</style>
