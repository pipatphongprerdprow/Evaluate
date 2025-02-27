<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-4"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-credit-card" style="font-size: x-large;"></i> รายงานการประเมิน</h3>    
                    </div> 
                   
                    <!-- <div class="col md:col-4"> 
                        <label for="year_text">ปีงบประมาณ: </label> 
                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" optionValue="code" placeholder="เลือกปีงบประมาณ" style="width: 60%;"></Dropdown> 
                    </div>  
                    <div class="col md:col-4"> 
                        <label for="year_text">รอบประเมิน: </label> 
                        <Dropdown id="evaluation_text" v-model="dropdownItemRecord" :options="dropdownItemRecords" optionLabel="name" placeholder="รอบประเมิน" style="width: 70%;"></Dropdown> 
                    </div>    -->
                </div>   
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th>ชื่อ - สกุล</th>  
                            <th>ตำแหน่ง</th>  
                            <th>รอบการประเมิน</th>  
                            <th>ปีงบประมาณ</th>
                            <th>คะแนน</th>  
                            <th>ผู้ประเมิน</th>  
                            <th>ตัวเลือก</th>
                              
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 20%;">
                                <b style="color: blue;">{{  }} {{  }} </b>
                            </td>

                            <td style="padding-left: 5px;width: 20%;"><b>{{ }}</b></td>
                            <td style="padding-left: 5px;width: 30%;"><b>{{ }}</b></td>
                            <td style="padding-left: 5px;width: 10%;"><b>{{ }}</b></td>
                            <td style="padding-left: 5px;width: 10%;"><b>{{ }}</b></td>
                            <td style="text-align: center;width: 10%;"><b>{{ }}</b></td>
                            <td style="text-align: center;width: 10%;">
                                <Button severity="info" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>

                        </tr> 
                    </tbody>
                </table>
                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3>รายงานการประเมิน (ส่วนบุคคล)</h3>
                        </template>
                                <TabView>
                                    <TabPanel header="แบบใบปะหน้า">
                                       <!-- รอข้อมูล -->  
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
                                    <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="DialogAdd = false" />
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
                DialogAdd: false,
                displayDialog: false
            };
        },
            
        mounted(){
            this.showDataEvalu();
        },
        
        methods: { 
            async showDataEvalu(){
                await axios.get('https://survey.msu.ac.th/evaluatebackend/api/showDataEvalu',{
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
                await axios.post('https://survey.msu.ac.th/evaluatebackend/api/postDataChkBtn',{ 
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
                axios.post('https://survey.msu.ac.th/evaluatebackend/api/showDataValuate',{
                    staff_id: staff_id,
                    fac_id: this.facid_Main,
                    year_id: this.dropdownItemYear.code,
                }).then(res => {     
                    // console.log(res.data);  
                    this.products_person=res.data; 
                    this.DialogAdd = true; 
                    //this.showDataP03();
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            },
            closeCallback(){
                this.DialogAdd = false;
            },
        },
        // async mounted() {
        //         const  { signIn, getSession, signOut } = await useAuth()
        //         const user = await getSession();
        //     },
    } 
    
    </script>

<style scoped> 
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
    box-shadow: 0 0 10px rgba(2, 2, 2, 0.1);
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
    background-color: #e5e5e3;
    color: rgb(9, 8, 8);
}
.bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
    /* P01 */
    label{
      font-size: medium;
      font-weight: 500;
  }
  .card-header {
      text-align: left; /* Aligns text to the left */
      margin: 0; /* Removes default margins */
      padding: 0; /* Removes default padding */
  }
  .table {
      width: 100%;
      border-collapse: collapse;
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
  .table td {
      vertical-align: top;
  }

  
</style>