<template>
    <div class="grid">
      <div class="col-12 lg:col-12 xl:col-12">
        <div class="card mb-0">
          <h3 class="mb-4" style="text-align: left;">
            <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป03
          </h3>
          <div class="formgroup-inline mb-1">
            <div class="col md:col-6">
              <FloatLabel>
                <InputText type="text" id="search" v-model="searchData" class="col-10" autocomplete="off" />
                <label for="search">ค้นหา</label>
              </FloatLabel><br>
              <B><h4>1.ผลสัมฤทธิ์ของงาน</h4></B><br>
            </div>
          </div> 
          <DataTable :value="products" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
            <Column field="Tb_name" header="กิจกรรม/โครงการ/งาน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <B>ข้อที่</B> {{ Item.data.p01_no }} <br>
                <B>เรื่อง</B> {{ Item.data.p01_subject }}
              </template>
            </Column>
            <Column field="Tb_ind" header="ตัวชี้วัด/เกณฑ์การประเมิน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <B>ระดับความสำเร็จในการจัดทำ {{ Item.data.p01_subject }} </B>
                <p v-for="(xx, index) in Item.data.sub_ITem" :key="index" class="mb-0">
                  <B>ระดับที่ {{ xx.ind_no }}</B> {{ xx.ind_Items }}
                </p>
              </template>
            </Column>
            
            <Column field="Tb_target" header="รายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน" style="width: 20%">
              <template #body="Item"> 
                  <p v-for="(xx, index) in Item.data.sub_ITemP03" :key="index" class="mb-0">
                    <B>ระดับที่ {{ xx.p03_estimate }}</B> <br>
                    {{ xx.p03_report }} 
                    <Button icon="pi pi-pencil" severity="warning" rounded text raised class="mb-2 mr-2" @click="editData(xx)" />
                    <Button icon="pi pi-times" severity="danger" rounded text raised class="mb-2 mr-2" @click="delData(xx)" /> 
                  </p>
                  <Button label="เพิ่มรายการ" severity="primary" icon="pi pi-plus" @click="OpenDialogAdd(Item.data)" />  
              </template>
            </Column>

            <Column field="Tb_score" header="หลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน (หลักฐานเชิงประจักษ์)" style="width: 20%">
              <template #body="Item"> 
                <!-- <a :href="fileUrl" target="_blank">Open Uploaded File</a> -->
                <p v-for="(xx, index) in Item.data.sub_ITemDoc" :key="index" class="mb-0">  
                    <a :href="'http://localhost:8000/storage/uploads/'+xx.doc_file" target="_blank">{{ xx.doc_name }}</a> 
                    <Button icon="pi pi-times" severity="danger" rounded text raised class="mb-2 mr-2" @click="delDataDoc(xx)" /> 
                  </p>
                <Button label="เพิ่มไฟล์" severity="primary" icon="pi pi-plus" @click="OpenDialogAddfile(Item.data)" /> 
              </template>
            </Column>
            <Column field="Tb_score" header="ค่าคะแนนที่ได้" style="width: 10%">
              <template #body>
                <div style="display: flex; align-items: center;">
                  <Chips v-model="chipsValue" />
                  <i class="pi pi-save" @click="saveChips" style="cursor: pointer; margin-left: 5px; color: green;"></i>
                  <i class="pi pi-trash" @click="deleteChips" style="cursor: pointer; margin-left: 5px; color: red;"></i>
                </div>
              </template>
            </Column>
          </DataTable> 
          <!-- Dialog เพิ่มรายงานผลปฎิบัติราชการตามตัวชี้วัด -->
          <Dialog header="เพิ่มรายงานผลปฎิบัติราชการตามตัวชี้วัด" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
            <div class="p-fluid formgrid grid"> 
              <InputText v-model="text_p01_id" type="text" /> 
              <InputText v-model="text_edt" type="text" />  
              <div class="field col-12 md:col-3"> 
                  <label for="level">ข้อที่</label> 
                  <Dropdown v-model="level" :options="dropdownValuesLevel" optionLabel="nameLevel" placeholder="- กรุณาเลือก -" />
              </div>
              <div class="field col-12 md:col-9">
                  <label for="text_detail">เรื่อง</label>
                  <Textarea v-model="text_detail" rows="3"></Textarea>
              </div>   
              <div class="button-container">
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveData" />
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
              </div>
            </div>
          </Dialog> 
          <!-- Dialog เพิ่มหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน -->
          <Dialog header="เพิ่มหลักฐานเชิงประจักษ์" maximizable v-model:visible="DialogAddfile" :breakpoints="{ '960px': '75vw' }" :style="{ width: '50vw' }" :modal="true" position="top">
            <div class="p-fluid formgrid grid"> 
              <InputText v-model="doc_p01_id" type="text" /> 
              <InputText v-model="doc_edt" type="text" />   
              <div class="field col-12 md:col-9">
                  <label for="doc_name">ชื่อไฟล์</label>
                  <Textarea v-model="doc_name" rows="3"></Textarea>
                  <form>
                    <input type="file" ref="fileInput" @change="handleFileChange">
                  </form>
              </div>   
              <div class="field col-12 md:col-3" style="align-content: space-evenly;">
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="savefileData" />
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
              </div>
            </div>
          </Dialog>

          <!-- แทรกp.02 -->
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
                    </td>
                </tr>
            </tbody>
        </table>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import axios from 'axios';
  import Swal from 'sweetalert2';
  
  export default {
    data() {
      return {
        searchData: null,
        staff_id: 5008886,
        facid: 201092704000,
        groupid: '01',
        products: [],
        chipsValue: [],
        // Dialog รายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน
        DialogAdd: false, 
        text_p01_id: null,
        text_edt: null,
        level: null,
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





        activeFileItem: null,
        persen: '',
        fileName: '',
        p01_detail_add: {},
        p03_file_add: {
          p03: null,
        },
      };
    },
    mounted() {
      this.showDataP03(); 
    },
    methods: {
      showDataP03() {
        axios.post('http://localhost:8000/api/showDataP03', {
            staff_id: this.staff_id,
            facid: this.facid,
            groupid: this.groupid
          })
          .then((res) => {
            // console.log(res.data);
            this.products = res.data;
          })
          .catch((error) => {
            console.error('Error:', error);
          });
      },
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
      //filep03 
      OpenDialogAddfile(item) {
        // console.log(item);
        this.DialogAddfile = true;
        this.doc_p01_id = item.p01_id;
        this.doc_edt = null;
        this.doc_name = null;  
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
       saveChips() {
      // Logic to save the chips value
      console.log('Save chips:', this.chipsValue);
      },
      deleteChips() {
        // Logic to delete the chips value
        this.chipsValue = [];
        console.log('Delete chips');
      },
        editRow(category, index) {
            this.activeFormIndex = index;
            this.activeCategory = category;
        },
        deleteRow(category, index) {
            if (category === 'core') {
                this.coreCompetencies.splice(index, 1);
            } else if (category === 'job') {
                this.jobSpecificCompetencies.splice(index, 1);
            } else if (category === 'other') {
                this.otherCompetencies.splice(index, 1);
            }
        },
        showForm(category, index) {
            this.activeFormIndex = index;
            this.activeCategory = category;
        },
        hideForm() {
            this.activeFormIndex = null;
            this.activeCategory = '';
            this.newActivity = '';
            this.newIndicator = '';
            this.newReport = '';
            this.newEvidence = '';
        },
        addRow(category) {
            const newRow = {
                activity: this.newActivity,
                indicator: this.newIndicator,
                report: this.newReport,
                evidence: this.newEvidence
            };
            if (category === 'core') {
                this.coreCompetencies.push(newRow);
            } else if (category === 'job') {
                this.jobSpecificCompetencies.push(newRow);
            } else if (category === 'other') {
                this.otherCompetencies.push(newRow);
            }
            this.hideForm();
        },
        handleFileUpload(event) {
            const file = event.target.files[0];
            // เพิ่มฟังก์ชันการอัพโหลดไฟล์
        }
        
      }
    };
  </script>
  
  <style scoped>
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
  </style>
  