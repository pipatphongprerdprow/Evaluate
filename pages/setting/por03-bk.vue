<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-4">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป01
                        </h3>
                    </div>
                    <div class="col md:col-3 text-right">
                        <label for="dropdownItemYear">ปีงบประมาณ :</label>
                        <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                    </div>
                </div>
                <!-- แสดงข้อมูลบันทึก -->
                <table class="table">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                            <th rowspan="2" style="width: 24%;">
                            (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                            (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                            </th>
                            <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                            <th rowspan="2" style="width: 7%;">(4) <br> ค่าคะแนน ที่ได้</th>
                            <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                            <th rowspan="2" style="width: 10%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
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
                        <template v-for="(h, ind) in products_personX" :key="ind">  
                            <tr>
                                <td style="text-align: left;" colspan="9">
                                    <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b>
                                </td>
                                <td class="text-center" style="color: blue;"><b>{{ h.h_weight }}%</b></td> 
                                <td></td>
                            </tr> 
                            <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;"> 
                                <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                <td style="text-align: left;">
                                    <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                    <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                        <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                        <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
                                    </p>
                                </td>
                                <td class="text-center"> 
                                    <b v-if="subP01.p01_target==1">&#10003;</b> 
                                    <b v-if="subP01.p01_target!=1"></b> 
                                </td>
                                <td class="text-center"> 
                                    <b v-if="subP01.p01_target==2">&#10003;</b> 
                                    <b v-if="subP01.p01_target!=2"></b> 
                                </td>
                                <td class="text-center"> 
                                    <b v-if="subP01.p01_target==3">&#10003;</b> 
                                    <b v-if="subP01.p01_target!=3"></b> 
                                </td>
                                <td class="text-center"> 
                                    <b v-if="subP01.p01_target==4">&#10003;</b> 
                                    <b v-if="subP01.p01_target!=4"></b> 
                                </td>  
                                <td class="text-center"> 
                                    <b v-if="subP01.p01_target==5">&#10003;</b> 
                                    <b v-if="subP01.p01_target!=5"></b> 
                                </td>
                                <td class="text-center">{{ subP01.p01_score }}</td>
                                <td class="text-center">{{ subP01.p01_weight }}%</td> 
                                <td class="text-center">{{ (subP01.p01_score * subP01.p01_weight / 100).toFixed(2) }}</td>
                                
                                <td class="text-center">
                                    <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                </td> 
                            </tr>  
                        </template>
                    </tbody>
                </table> 
                <Dialog header="จัดการแบบ ป03" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                    <form>
                        <div class="p-fluid formgrid"> 
                            <form>
                                <InputText v-model="text_edt" type="text" /> 
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-12"> 
                                        <label for="text_search_no">รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน</label>
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
                                    <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="text-align: left;width: 80%">
                                        <template #body="Item"> 
                                        {{ Item.data.ind_Items }}
                                        </template>
                                    </Column>  
                                    <Column field="options" header="ตัวเลือก" style="text-align: center; width: 10%">
                                        <template #body="Item">   
                                            <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
                                        </template>
                                    </Column> 
                                </DataTable>
                            </form>
                            <div class="field-container">
                                <div class="field col-6 md:col-6">
                                    <label for="text_name">หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์)</label>
                                    <div class="card">
                                    <h5>แนบไฟล์</h5>
                                    <form @submit.prevent="uploadFile">
                                        <input type="file" ref="fileInput" @change="handleFileChange">
                                    </form>
                                    </div>
                                </div>
                                <div class="field col-6 md:col-6">
                                    <label for="text_target">ระดับการประเมินตนเอง(ค่าคะแนนที่ได้)</label>
                                    <Dropdown id="dropdownItemTarget" v-model="dropdownItemTarget" :options="dropdownItemsTarget" optionLabel="name" placeholder="เลือกค่าคะแนน" style="width: 250px;"></Dropdown>
                                </div>
                            </div>
                        </div>
                    </form>
                        <template #footer>
                            <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataZ" />
                            <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialog" />
                        </template>
                    </Dialog>
                





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
            dropdownItemYear: { name: 'ปีงบประมาณ 2568', value: 2568 },
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', value: 2569 },
                { name: 'ปีงบประมาณ 2568', value: 2568 },
                { name: 'ปีงบประมาณ 2567', value: 2567 },
                { name: 'ปีงบประมาณ 2566', value: 2566 }
            ], 
            products_personX: [],
            itemsBtu: (item) => [
                {
                    label: 'เพิ่มข้อมูล',
                    icon: 'pi pi-plus',
                    command: () => {
                        this.AddDatax(item);
                    }
                },
                {
                    label: 'แก้ไขข้อมูล',
                    icon: 'pi pi-refresh',
                    command: () => {
                        this.editDatax(item);
                    }
                },
                {
                    label: 'ลบข้อมูล',
                    icon: 'pi pi-times',
                    command: () => {
                        this.delDatax(item);
                        
                    }
                }
            ],
        }
    },
    mounted(){ 
        this.showDataPerson(); 
    },
    methods: {  
        // ดึงข้อมูลเข้าตาราง
        async showDataPerson(){ 
            axios.post('http://localhost:8000/api/showDataPersonX',{
            staff_id: this.staffid_Main,
            fac_id: this.facid_Main,
            year_id: this.dropdownItemYear.value, 
            group_id: this.groupid_Main,
            }).then(res => {     
                // console.log(res.data);  
                this.products_personX=res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
        // เพิ่ม 
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
        // แก้ไข

        // ลบ

















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
  .field-container {
  display: flex;
  justify-content: space-between;
}

.field {
  flex: 1;
  margin-right: 10px;
}
th {
  background-color: #f1e989;
  color: rgb(5, 5, 5);
}

.h, td {
  border: 1px solid #ddd;
  padding: 8px; /* Reduced padding */
  text-align: center;
  font-size: 14px; /* Smaller font size */
}
td:nth-child(2), td:nth-child(3) {
  width: 32.5%; /* Adjusted width for other columns */
}
</style>
