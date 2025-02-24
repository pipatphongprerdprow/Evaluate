<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                   
                    <div class="col md:col-9"> 
                        <h3 v-if="dataP01" class="mb-4 card-header"><i class="pi pi-fw pi-sliders-h" style="font-size: x-large;"></i>  
                            จัดการ แบบประเมิน {{ dataP01.d_evaluationround }} ปีงบประมาณ : {{ dataP01.year }}  
                            <!-- {{ dataP01 }} -->
                        </h3> 
                    </div>
                    <!-- <div class="col md:col-4 text-left"> 
                        <label for="dropdownItemYear">รอบประเมิน : {{ dataP01.evalua }} </label> 
                    </div>
                    <div class="col md:col-3 text-left"> 
                        <label for="dropdownItemYear">ปีงบประมาณ : {{ dataP01.year }}  {{ user.user.name.SCOPES?.staffdepartment }}</label> 
                    </div>     -->
                    <div class="col md:col-3 text-right"> 
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" /> 
                        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
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
                                        <template #body="Item" >   
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
                <!-- <table class="table table-bordered"> -->
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
                        <template v-for="(item, index) in products_person" :key="index"> 
                                <tr >
                                    <td style="text-align: left;" colspan="8">
                                        <b style="color: blue;">{{ item.id }}. {{ item.nameH }}</b>
                                    </td>  
                                    <!-- <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td> -->
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <!-- P01 -->
                                <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                    <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                    <td style="text-align: left;">
                                        <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                        <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                            <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                            <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
                                        </p>
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
  import Swal from 'sweetalert2'
    export default {
        props: {
            // กำหนด props ที่จะรับข้อมูลจาก parent
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
            axios.post('http://127.0.0.1:8000/api/showDataPerson',{  
            fac_id: fac_id,
            evalua: evalua,
            year_id: year_id
            }).then(res => {     
               // console.log(res.data);  
                this.products_person=res.data;
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
            this.selectDataH(this.dropdownItemYear,this.facid_Main);
        },
        // ดึงข้อมูลภาระงาน
        selectDataH(year,fac){  
            //console.log('ดึงข้อมูลภาระงาน',year,fac);
            
            axios.post('http://127.0.0.1:8000/api/selectDataPersonH',{}).then(res => {     
                // console.log('selectDataH',res.data); 
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
        async saveData() {  
            await axios.post('http://127.0.0.1:8000/api/saveDataPerson', {
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

            // ปิดหน้าต่างบันทึก
            resetDialog(){
                this.DialogAdd = false; 
            },
            // แก้ไขข้อมูล
            async editData(data){    
            await axios.post('http://127.0.0.1:8000/api/edtDataPerson',{
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
                axios.post('http://127.0.0.1:8000/api/selectDataPersonH',{
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
                    axios.post('http://127.0.0.1:8000/api/delDataPerson',{
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
  .table th {
      background-color: #edf2bb;
      font-weight: bold;
  }
  
  </style>