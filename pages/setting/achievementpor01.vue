<template>
  <div class="grid">
    <div class="col-12 lg:col-12 xl:col-12">
        <div class="card mb-0">
            <h3 class="mb-4 card-header"><i class="pi pi-folder-open" style="font-size: x-large;"></i> ผลสัมฤทธิ์ของงาน</h3>   
            <div class="formgroup-inline mb-1">
                <div class="col md:col-6"> 
                    <FloatLabel>
                        <InputText type="text" id="search" v-model="searchData" class="col-10" autocomplete="off" />
                        <label for="search">ค้นหา</label>
                    </FloatLabel>
                </div> 
            </div>  
            <DataTable :value="products" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                <Column field="Tb_name" header="กิจกรรม/โครงการ/งาน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <B>ข้อที่</B> {{ Item.data.p01_no }} <br>
                <B>เรื่อง</B> {{ Item.data.p01_subject }}
              </template>
            </Column>

            <!-- คอลัมน์ที่ 2: แสดงตัวชี้วัด/เกณฑ์การประเมิน -->
            <Column field="Tb_ind" header="ตัวชี้วัด/เกณฑ์การประเมิน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <B>ตัวชี้วัดที่ {{ Item.data.p01_subject }} </B>
                <p v-for="(xx, index) in Item.data.sub_ITem" :key="index" class="mb-0">
                  <B>ระดับที่ {{ xx.ind_no }}</B> {{ xx.ind_Items }}
                </p>
              </template>
            </Column>

            <!-- คอลัมน์ที่ 3: แสดงรายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน -->
            <Column field="Tb_target" header="รายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน" style="width: 20%">
              <template #body="Item"> 
                  <p v-for="(xx, index) in Item.data.sub_ITemP03" :key="index" class="mb-0">
                    <B>ระดับที่ {{ xx.p03_estimate }}</B> <br>
                    {{ xx.p03_report }} <br>
                    <!-- <Button icon="pi pi-pencil" severity="warning" text class="mb-2 mr-2" @click="editData(xx)" />
                    <Button icon="pi pi-times" severity="danger" text class="mb-2 mr-2" @click="delData(xx)" />  -->
                  </p>
                  <!-- <Button label="เพิ่มรายการ" severity="primary" text icon="pi pi-plus" @click="OpenDialogAdd(Item.data)" />   -->
              </template>
            </Column>

            <!-- คอลัมน์ที่ 4: แสดงหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน -->
            <Column field="Tb_score" header="หลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน (หลักฐานเชิงประจักษ์)" style="width: 20%">
              <template #body="Item"> 
                <!-- <a :href="fileUrl" target="_blank">Open Uploaded File</a> -->
                <p v-for="(xx, index) in Item.data.sub_ITemDoc" :key="index" class="mb-0">  
                    <a :href="'https://survey.msu.ac.th/evaluatebackend/storage/uploads/'+xx.doc_file" target="_blank">{{ xx.doc_name }}</a> <br>
                    <!-- <Button icon="pi pi-times" severity="danger" text class="mb-2 mr-2" @click="delDataDoc(xx)" />  -->
                  </p>
                <!-- <Button label="เพิ่มไฟล์" severity="primary" text icon="pi pi-plus" @click="OpenDialogAddfile(Item.data)" />  -->
              </template>
                </Column>
                <Column field="Tb_score" header="ค่าคะแนน" style="width: 20%">
                <template #body="Item">    
                    {{ Item.data.p01_score??0 }}
                    <Button label="เพิ่ม" icon="pi pi-plus" text class="mb-2 mr-2" @click="addscorep03(Item.data.p01_id)" /> 
                </template>
                </Column> 
                    <Dialog header="จัดการค่าคะแนน" maximizable v-model:visible="DialogAddscorep" :breakpoints="{ '960px': '75vw' }" :style="{ width: '50vw' }" :modal="true" position="top">
                        <div class="form-container">
                            <InputText v-model="scorep_p01_id" type="hidden" />
                        <div class="field">
                            <label for="score">ค่าคะแนน</label>
                            <InputNumber id="score" v-model="p01_score" />
                        </div>
                        <div class="field">
                            <label for="address">ข้อเสนอแนะ</label>
                            <Textarea id="address" rows="4" class="custom-textarea" v-model="address" />
                        </div>
                        <div class="button-container">
                            <Button label="บันทึก" icon="pi pi-check" class="p-button-success" @click="savescorepData" />
                            <Button label="ยกเลิก" icon="pi pi-times" class="p-button-danger" @click="resetDialogscorep" />
                        </div>
                    </div>
            </Dialog>
        </DataTable>     
            <div>
                <h4 class="mb-4"><i class="" style="font-size: x-large;"></i> ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อเสร็จสิ้นรอบการประเมิน)</h4>
            </div>

            <div>
                <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> 1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</h5>
            </div>
             <div class="field">
                <textarea id="strengths-improvements" rows="4" class="custom-textarea" v-model="strengthsImprovements"></textarea>
            </div>
            <div>
                <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> 2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</h5>
            </div>
              <div class="field">
                <textarea id="suggestions" rows="4" class="custom-textarea" v-model="suggestions"></textarea>
            </div>
            <div class="button-container">
                <Button label="บันทึกผลสัมฤทธิ์ของงาน" icon="pi pi-save" class="mb-2 mr-2" @click="saveData1" /> 
            </div>
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

        newActivity: null, 



        activeFileItem: null,
        persen: '',
        fileName: '',
        p01_detail_add: {},
        p03_file_add: {
          p03: null,
        },
        DialogAddscorep: false, 
        p01_score: null, 
        score: 15,
        address:'' 
      };
    },
    mounted() {
      this.showDataP03(); 
    },
    methods: {
      showDataP03() {
        axios.post('https://survey.msu.ac.th/evaluatebackend/api/showDataP03', {
            staff_id: this.staff_id,
            facid: this.facid,
            groupid: this.groupid
          })
          .then((res) => {
            console.log(res.data);
            this.products = res.data;
            this.p01_score = res.data[0].p01_score;
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
        axios.post('https://survey.msu.ac.th/evaluatebackend/api/saveDataP03', {
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
        axios.post('https://survey.msu.ac.th/evaluatebackend/api/edtDataP03', {
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
            axios.post('https://survey.msu.ac.th/evaluatebackend/api/delDataP03', {
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
        // console.log(item);
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

        axios.post('https://survey.msu.ac.th/evaluatebackend/api/saveDatadoc', formData, {
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
            axios.post('https://survey.msu.ac.th/evaluatebackend/api/delDatadoc', {
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
        console.log(item); 
        axios.post('https://survey.msu.ac.th/evaluatebackend/api/selectDatascorep', {
          p01_id: item,
        }).then((res) => {
          console.log(res.data); 
           this.DialogAddscorep = true; 
          this.scorep_p01_id = item; 
          this.p01_score = res.data[0].p01_score??0;   
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
        axios.post('https://survey.msu.ac.th/evaluatebackend/api/savescorep03', {
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
 
    } 
}

</script>

<style scoped> 
.card-header {
    text-align: left; /* Aligns text to the left */
    margin: 0; /* Removes default margins */
    padding: 0; /* Removes default padding */
}
label{
    font-size: medium;
    font-weight: 500;
}
.custom-textarea {
  width: 100%; /* ความกว้างเต็มที่ */
  max-width: 1200px; /* ความกว้างสูงสุด */
  height: auto; /* ปรับความสูงตามเนื้อหา */
  resize: vertical; /* อนุญาตให้ปรับขนาดความสูงเท่านั้น */
}
.button-container {
  text-align: center; /* จัดกึ่งกลางในแนวนอน */
}
.additional-comments {
  border: 1px solid #ddd;
  padding: 16px;
  margin-top: 16px;
  border-radius: 8px;
}
.container {
  width: 95%;
  margin: 0 auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

th, td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: center;
  font-size: 14px;
}
.form-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 16px;
}

.field {
  display: flex;
  flex-direction: column;
}

.field label {
  margin-bottom: 8px;
  font-weight: bold;
}

.custom-textarea {
  width: 100%;
  height: 150px;
  resize: vertical;
}

.button-container {
  display: flex;
  justify-content: center;
  gap: 16px;
  margin-top: 16px;
}

</style>