<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป01</h3> 
                    </div> 
                    <div class="ol md:col-3 text-right">
                        <label for="dropdownItemYear">ปีงบประมาณ : </label> 
                        <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown> 
                    </div> 
                    <div class="col md:col-3 text-right"> 
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" /> 
                        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                            <form> 
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-3">
                                        <Button icon="pi pi-search" severity="help" class="mb-2 mr-2" label="เลือกข้อมูลแบบประเมิน ป.01" @click="OpenDialogP01" />  
                                        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAddP01" :breakpoints="{ '960px': '75vw' }" :style="{ width: '90vw' }" :modal="true" position="top">
                                            <form> 
                                                <div class="p-fluid formgrid grid"> 
                                                    <div class="field col-12 md:col-12">
                                                        <table class="table">
                                                            <thead>
                                                                <tr>
                                                                    <th rowspan="2" style="width: 9%;"><br> ตัวเลือก <br></th>
                                                                    <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                                                                    <th rowspan="2" style="width: 24%;">
                                                                    (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                                                                    (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                                                                    </th>
                                                                    <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                                                                    <th rowspan="2" style="width: 7%;">(4) <br> ค่าคะแนน ที่ได้</th>
                                                                    <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                                                                    <th rowspan="2" style="width: 10%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th> 
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
                                                                                <b style="color: blue;">{{ item.id }}. {{ item.nameH }}</b>
                                                                            </td>  
                                                                            <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td>
                                                                            <td></td>
                                                                            <td></td>
                                                                        </tr>
                                                                        <!-- P01 -->
                                                                        <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                                                            <td class="text-center">  
                                                                                <Checkbox :id="'checkOption-' + subP01.p_id" :name="'option-' + subP01.p_id" :value="subP01.p_id" v-model="checkboxValue" />
                                                                            </td> 
                                                                            <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                                                            <td style="text-align: left;">
                                                                                <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                                                                <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                                                    <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                                                                    <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
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
                                                                        </tr> 
                                                                </template> 
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </form>
                                            <template #footer>
                                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="savetablechkem" /> 
                                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialogs"   />
                                            </template>
                                        </Dialog> 
                                    </div>
                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialog"  />
                            </template>
                        </Dialog> 
                    </div> 
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
                staffid_Main: 5009942,
                year_Main: 2568,
                facid_Main: 201092704000,
                groupid_Main: '01',
                dropdownItemYear: null ,
                dropdownItemsYear: [
                    { name: 'ปีงบประมาณ 2569', value: 2569 },
                    { name: 'ปีงบประมาณ 2568', value: 2568 },
                    { name: 'ปีงบประมาณ 2567', value: 2567 },
                    { name: 'ปีงบประมาณ 2566', value: 2566 },
                    { name: 'ปีงบประมาณ 2565', value: 2565 },
                ],  
                // เปิดหน้าต่างสำหรับบันทึก 
                DialogAdd: false, 
                // เลือกข้อมูลแบบประเมิน ป.01
                DialogAddP01: false, 
                products_person: [], 
                checkboxValue: [],
            }
        },
        created() { 
            this.dropdownItemYear = this.dropdownItemsYear.find(f => f.value === 2568);
        },
        mounted(){ 
        
        },
      methods: {  
        // เปิดหน้าต่างสำหรับบันทึก 
        OpenDialogAdd(){
            this.DialogAdd = true;  
        }, 
        OpenDialogP01(){ 
            axios.post('http://localhost:8000/api/showDataPerson',{ 
                fac_id: this.facid_Main,
                year_id: this.year_Main
            }).then(res => {     
                //   console.log(res.data);  
                this.DialogAddP01 = true; 
                this.products_person=res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            }); 
            
        },
        cancelDialog(){
            this.DialogAdd = false;
             
        },
        cancelDialogs(){
            this.DialogAddP01 = false; 
        },
        savetablechkem() {   
            // const selectedItems = this.products_person.filter(item => item.subP01s  this.checkboxValue.includes(item.id)); 
            // const x = this.products_person.reduce((a,c)=>{
            //     console.log(c);
                
            //     //const selectedItems = c.filter(item => c.subP01s.includes(item.id)); 
            //     return a = a.push("")
            // },[])
            // console.log(x);

            let x = []
            this.products_person.forEach((v,i)=>{
                const selectedItems = v.subP01s.filter(item=>this.checkboxValue.includes(item.p_id)); 
                // x.push(selectedItems)//
                x = x.concat(selectedItems);
            })

            console.log(x);
            
        },
    } 
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
  
  </style>