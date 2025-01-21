<template>
  <div class="grid">
    <div class="col-12 lg:col-12 xl:col-12">
        <div class="card mb-0">
            <h3 class="mb-4"><i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01</h3>   
            <div class="formgroup-inline mb-1">
                <div class="col md:col-6"> 
                    <FloatLabel>
                        <InputText type="text" id="search" v-model="searchData" class="col-10" autocomplete="off" />
                        <label for="search">ค้นหา</label>
                    </FloatLabel>
                </div> 
                <!-- <div class="col md:col-6 text-right"> 
                    <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูล" @click="OpenDialogAdd" /> 
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                        <form>
                            <InputText v-model="text_edt" type="hidden" />
                            <div class="p-fluid formgrid grid"> 
                                <div class="field col-12 md:col-4">
                                    <label for="text_no">ข้อที่</label>
                                    <InputGroup>
                                        <InputGroupAddon>
                                            <i class="pi pi-calendar-plus"></i>
                                        </InputGroupAddon>
                                        <InputText v-model="text_no" type="number" placeholder="ข้อ" autocomplete="off" /> 
                                    </InputGroup> 
                                </div>
                                <div class="field col-12 md:col-8">
                                    <label for="text_name">เรื่อง</label>
                                    <InputGroup>
                                        <InputGroupAddon>
                                            <i class="pi pi-book"></i>
                                        </InputGroupAddon>
                                        <Textarea v-model="text_name" rows="1" placeholder="เรื่อง" autocomplete="off" /> 
                                    </InputGroup>  
                                </div> 
                                <div class="field col-12 md:col-4">
                                    <label for="text_target">ระดับค่าเป้าหมาย</label>
                                    <InputGroup>
                                        <InputGroupAddon>
                                            <i class="pi pi-bookmark"></i>
                                        </InputGroupAddon>
                                        <InputText v-model="text_target" type="number" placeholder="ระดับค่าเป้าหมาย" autocomplete="off" />  
                                    </InputGroup>  
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
                </div>  -->
            </div>  
            <DataTable :value="products" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                <Column field="Tb_name" header="กิจกรรม/โครงการ/งาน" style="width: 25%">
                    <template #body="Item"> 
                        <B>ข้อที่</B> {{ Item.data.p01_no }} <br>
                        <B>เรื่อง</B> {{ Item.data.p01_subject }}  
                    </template>
                </Column>
                <Column field="Tb_ind" header="ตัวชี้วัด/เกณฑ์การประเมิน" style="width: 25%">
                    <template #body="Item">  
                        <B>ตัวชี้วัดที่ {{ Item.data.p01_subject }} </B>
                        <p v-for="(xx, index) in Item.data.sub_ITem" :key="index">
                          <B>ระดับที่ {{ xx.ind_no }}</B> {{ xx.ind_Items }}
                        </p>
                    </template>
                </Column>
                <Column field="Tb_target" header="ระดับค่าเป้าหมาย" style="width: 10%">
                    <template #body="Item">   
                        {{ Item.data.p01_target }}
                    </template>
                </Column>
                <Column field="Tb_score" header="ค่าคะแนนที่ได้" style="width: 10%">
                    <template #body="Item">
                        <b style="color: grey;">{{ Item.data.p01_score }}</b>
                    </template>
                </Column>
                <Column field="Tb_weight" header="น้ำหนัก(ความสำคัญ/ความยากง่ายของงาน)" style="width: 10%">
                    <template #body="Item">  
                        {{ Item.data.p01_weight }}%
                    </template>
                </Column>
                <Column field="Tb_balance" header="ค่าคะแนนถ่วงน้ำหนัก" style="width: 10%">
                    <template #body="Item">
                        {{ (Item.data.p01_target * Item.data.p01_weight / 100).toFixed(2) }}
                    </template>
                </Column> 
                <!-- <Column field="options" header="ตัวเลือก" style="width: 10%">
                    <template #body="Item">   
                        <Button icon="pi pi-pencil" severity="success" class="mb-2 mr-2" @click="editData(Item.data)" />
                        <Button icon="pi pi-trash" severity="danger" class="mb-2 mr-2" @click="delData(Item.data)" /> 
                    </template>
                </Column>  -->
            </DataTable>
            <div class="bordered-box">
                <div class="content">
                    <p>(9) ผู้ประเมินและผู้รับการประเมินได้ตกลงร่วมกันและเห็นพ้องกันแล้ว (ระบุข้อมูลใน (1) (2) (3) และ (5) ให้ครบ)         จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อจัดทำข้อตกลง)</p>
                <div class="signatures"><div>
                    <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                    <p>()</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                <div>
                    <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                    <p>()</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                </div>
                </div>
            </div>
            <div class="bordered-box">
                <div class="content">
                    <p>(10) ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</p>
                    <p>1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</p>
                    <p></p>
                    <p>2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</p>
                    <p></p>
                    <p>(11) ผู้ประเมินและผู้รับการประเมินได้เห็นชอบผลการประเมินแล้ว (ระบุข้อมูลใน (4) (6) (7) (8) และ (10) ให้ครบ) จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อสิ้นรอบการประเมิน)</p>
                <div class="signatures"><div>
                    <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                    <p>()</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                <div>
                    <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                    <p>()</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                </div>
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
            searchData: null,
            staff_id: 5008886,
            facid: 201092704000,
            groupid: '01',
            products: [], 
            // Dialog
            DialogAdd: false,
            text_edt: null,
            text_no: null,
            text_name: null,
            text_target: null,
            text_weight: null,
            text_search_no: null,
            text_search: null,
            products_list: [],
            name: 'EvaluationComments'

        }
    },
    mounted(){
    this.showDataP01();
    },
    methods: {
        showDataP01(){
            axios.post('/evaluatebackend/api/showDataP01',{
                staff_id: this.staff_id,
                facid: this.facid,
                groupid: this.groupid,
            }).then(res => {     
                // console.log(res.data); 
                this.products = res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        OpenDialogAdd(){
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
        DeleteRegislick(data){
            this.products_list = this.products_list.filter(product => product.ind_no !== data); 
        },
        async saveData(){
            await axios.post('/evaluatebackend/api/saveDataP01',{
                staff_id: this.staff_id,
                facid: this.facid,
                text_edt: this.text_edt,
                text_no: this.text_no,
                text_name: this.text_name,
                text_target: this.text_target,
                text_weight: this.text_weight, 
                products_list: this.products_list
            }).then(res => {     
                // console.log(res.data);
                Swal.fire({
                title: "เรียบร้อย!",
                text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
                icon: "success"
                });
                this.DialogAdd = false; 
                this.showDataP01();
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        resetDialog(){
        this.DialogAdd = false; 
        },
        async editData(data){ 
            await axios.post('/evaluatebackend/api/edtDataP01',{
                p01_id: data.p01_id
            }).then(res => { 
                // console.log(res);     
                this.DialogAdd = true;
                this.text_edt = res.data[0].p01_id;
                this.text_no = res.data[0].p01_no;
                this.text_name = res.data[0].p01_subject;
                this.text_target = res.data[0].p01_target;
                this.text_weight = res.data[0].p01_weight; 
                this.products_list = res.data[0].sub_ITem;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
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
                    axios.post('/evaluatebackend/api/delDataP01',{
                        p01_id: data.p01_id
                    }).then(res => { 
                        // console.log(res);   
                        this.showDataP01();
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

.signatures div {
  width: 45%;
}

</style>