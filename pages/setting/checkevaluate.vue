<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-8"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-star" style="font-size: x-large;"></i> ตรวจสอบ แบบประเมิน</h3>    
                    </div> 
                    <div class="col md:col-4"> 
                        <label for="year_text">ปีงบประมาณ: </label> 
                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" optionValue="code" placeholder="เลือกปีงบประมาณ" style="width: 70%;"></Dropdown> 
                    </div>    
                </div>   
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th>ชื่อ - สกุล</th>  
                            <th>ตำแหน่ง</th>  
                            <th>สถานะ</th>  
                            <th>ตัวเลือก</th>  
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 40%;">
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b>
                                <Tag v-if="Item.countchk==2 " severity="success" style="font-size: larger;">อนุมัติ</Tag>
                                <Tag v-if="Item.countchk==3 " severity="danger" style="font-size: larger;">ไม่ผ่าน</Tag> 
                            </td>
                            <td style="padding-left: 5px;width: 25%;"><b>{{ Item.posnameth }}</b></td>
                            <td style="text-align: center;width: 20%;">   
                                <div v-if="Item.countchk!=''">
                                    <Button icon="pi pi-check" label="อนุมัติ" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,2)" />
                                    <Button icon="pi pi-times" severity="danger" label="ไม่ผ่าน" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,3)"  /> 
                                </div>
                                <div v-if="Item.countchk==''">
                                    <Button icon="pi pi-bookmark" severity="secondary" label="ไม่มีข้อมูล" rounded class="mb-2 mr-2"/>
                                </div> 
                            </td>
                            <td style="text-align: center;width: 15%;">
                                <Button severity="info" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>
                        </tr> 
                    </tbody>
                </table>
                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3>รายงานแบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference: TOR)</h3>
                        </template>
                                <TabView>
                                    <TabPanel header="แบบใบปะหน้า">
                                        <div class="col md:col-12 text-right">
                                                <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 "></Button>
                                            </div>
                                            <div class="card">
                                                <h3 class="mb-4" style="text-align: right;">
                                                    <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01-02
                                            </h3>
                                            <div style="display: flex; justify-content: center;">
                                                <img src="~/assets/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
                                            </div>
                                            <h4 style="text-align: center;">
                                                แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม
                                            </h4><br>
                                            <!-- ตาราง ก. สมรรถนะหลัก -->
                                            <div class="employee-info">
                                                <p><strong>ผู้ปฏิบัติงาน:</strong></p>
                                                <p><strong>สังกัด:</strong> </p>
                                                <p><strong>ตำแหน่ง:</strong> </p>
                                                <p><strong>ประเภทตำแหน่ง:</strong> </p>
                                                <p><strong>ประเภทบุคลากร:</strong></p>
                                                <p><strong>รายละเอียดข้อตกลง ระหว่าง วันที่ :</strong> </p>
                                            </div><br>

                                            <div class="explanation">
                                                <h4>คำชี้แจง</h4>
                                                <p>
                                                    1. แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ  (Term of Reference : TOR) ข้าราชการและพนักงาน  สังกัดมหาวิทยาลัยมหาสารคามนี้ เป็นการกำหนด
                                                        แผนการปฏิบัติงานของผู้ปฏิบัติงานในมหาวิทยาลัยมหาสารคาม ซึ่งเป็นข้อตกลงร่วมกับผู้บังคับบัญชาก่อนเริ่มปฏิบัติงาน
                                                </p>
                                                <p>
                                                    2. การกำหนดข้อตกลงร่วม ผู้ปฏิบัติงานจะต้องกรอกรายละเอียดภาระงานโดยสังเขปในส่วนของภาระงานตามหน้าที่ความรับผิดชอบของตำแหน่ง และ/หรือภาระงาน
                                                        ด้านอื่นๆ พร้อมกำหนดตัวชี้วัดความสำเร็จของภาระงานแต่ละรายการ  ตลอดจนค่าเป้าหมาย และค่านำหนักร้อยละ สำหรับในส่วนของพฤติกรรมการปฏิบัติราชการ
                                                        (สมรรถนะ) ให้ระบุระดับสมรรถนะค่ามาตรฐาน
                                                </p>
                                                <p>
                                                    3. สำหรับการกรอกรายละเอียดภาระเอียดภาระงานตามภารกิจ  ให้อ้างอิงการคำนวณภาระงานขั้นต่ำตามหลักเกณฑ์กรอบมาตรฐานภาระงานที่แนบท้ายประกาศ ก.บ.ม. 
                                                        มหาวิทยาลัยมหาสารคาม ที่บังคับใช้สำหรับการประเมินผลการปฏิบัติราชการ

                                                </p>
                                                <p>
                                                    4. การกำหนดตัวชี้วัดความสำเร็จของงาน  ทั้งในส่วนของเชิงปริมาณและเชิงคุณภาพ  ให้เป็นการกำหนดข้อตกลงภายในหน่วยงานนั้นๆ 
                                                </p>
                                                <p>
                                                    5. การจัดทำข้อตกลงภาระงานดังกล่าวนี้  เพื่อใช้เป็นกรอบในการประเมินผลการปฏิบัติราชการ  เพื่อประกอบการเลื่อนเงินเดือนและค่าจ้างในแต่ละรอบการประเมิน
                                                </p>
                                            </div>

                                            <!-- Tabs Section -->
                                            <div class="tabs-section">
                                                <Tabs value="0">
                                                    <TabList>
                                                        <Tab v-for="tab in tabs" :key="tab.value" :value="tab.value">{{ tab.title }}</Tab>
                                                    </TabList>
                                                    <TabPanels>
                                                        <TabPanel v-for="tab in tabs" :key="tab.value" :value="tab.value">
                                                            <p class="m-0">{{ tab.content }}</p>
                                                        </TabPanel>
                                                    </TabPanels>
                                                </Tabs>
                                            </div>
                                        </div>
                                    </TabPanel>

                                    <TabPanel header="แบบ ป01">
                                        <!-- รอข้อมูล -->
                                    </TabPanel>

                                    <TabPanel header="แบบ ป02">
                                        <!-- รอข้อมูล -->
                                    </TabPanel>

                                    <TabPanel header="แบบ ป03">
                                        <!-- รอข้อมูล -->
                                    </TabPanel>

                                    <TabPanel header="แบบ ป04">
                                        <!-- รอข้อมูล -->
                                    </TabPanel>
                                </TabView>
                                     <template #footer>
                                    <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="DialogAdd = false " />
                            </template>
                    </Dialog>
                </div>
            </div>
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
            searchData: null,
            year_Main: 2568,
            staffid_Main: 5009942,
            facid_Main: 201092704000,
            groupid_Main: '01', 
            products: [],
            dropdownItemYear: 2568,
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            DialogAdd: false,
            coreCompetencies: [
                { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1',report: '1' },
                { activity: 'ก. 2 การบริการที่ดี', indicator: '1',report: '1'  },
                { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1',report: '1'},
                { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1',report: '1'},
                { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1',report: '1'}
            ],
            jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1',report: '1'},
                { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1',report: '1'},
                { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1',report: '1'},
                { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1',report: '1'},
                { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1',report: '1'},
                { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1',report: '1'}
                
            ],
            otherCompetencies: [
                { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0',report: '1'},
                { activity: 'ค. 2 วิสัยทัศน์', indicator: '0',report: '1'},
                { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0',report: '1'},
                { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0',report: '1'},
                { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0',report: '1'}
               
            ],
            Summary:[
            {component:'องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน',behavior:'0.10',proportions:'50%',proportion:'50'},
            {component:'องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ',behavior:'0.67',proportions:'50%',proportion:'50'},
            {component:'องค์ประกอบอื่นๆ (ถ้ามี)',behavior:'',proportions:'',proportion:''},
            {component:'รวม',proportions:'100%',proportion:'100'},

            ],
            newActivity: '',
            newIndicator: '',
            newReport: '',
            newEvidence: '',
            activeFormIndex: null,
            activeCategory: ''
          
        };
    },
        
    mounted(){
         this.showDataEvalu();
         //this.showDataPerson();
    },
    methods: { 
        async showDataEvalu(){
            await axios.get('http://localhost:8000/api/showDataEvalu',{
                params: {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main, 
                    group_id: this.groupid_Main,
                    year: this.dropdownItemYear,
                },
            }).then(res => {     
                // console.log(res.data);  
                this.products=res.data;   
            })
            .catch(error => {
                console.error('Error:', error);
            });
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
        },
        async Btnstatus(staff_id,status){   
            await axios.post('http://localhost:8000/api/postDataChkBtn',{ 
                year: this.dropdownItemYear ,
                staff_id: staff_id ,
                status: status
            }).then(res => {     
                // console.log(res.data);  
                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกข้อมูลสำเร็จ",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.showDataEvalu();
            })
            .catch(error => {
                console.error('Error:', error);
            });  
             
        },
 
        openDataEvalu(staff_id){  
            axios.post('http://localhost:8000/api/showDataValuate',{
                staff_id: staff_id,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.code,
            }).then(res => {     
                // console.log(res.data);  
                this.products_person=res.data; 
                this.DialogAdd = true; 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        closeCallback(){
            this.DialogAdd = false; 
        },
        ////************/////////P01 *******************************/
        
    //*================== Start เลือกข้อมูลแบบประเมิน ป.01 ==================*//
         
//*================== End เลือกข้อมูลแบบประเมิน ป.01 ==================*//


//*================== Start เพิ่มข้อมูลแบบประเมิน ==================*//
         
      
    //*================== End เพิ่มข้อมูลแบบประเมิน ==================*//
    //*================== End P01 ==================*//

    }
}

</script>

<style scoped> 
table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}
.bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
  .card-header {
      text-align: left; /* Aligns text to the left */
      margin: 0; /* Removes default margins */
      padding: 0; /* Removes default padding */
  }
 
  .table th, .table td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: center;
  }
  .table th {
      background-color: #f4f4f4;
      font-weight: bold;
  }
  
</style>