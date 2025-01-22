<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">  
                <div class="formgroup-inline mb-1"> 
                    <div class="col md:col-6">  
                        <h3 class="mb-4 card-header"><i class="pi pi-calendar" style="font-size: x-large;"></i> จัดการ รอบประเมิน</h3>
                    </div> 
                    <!-- {{ user }} -->
                    <br> 
                    <div class="col md:col-16 text-right"> 
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลรอบประเมิน" @click="OpenDialogAdd" /> 
                        <!-- เพิ่มข้อมูลรอบประเมิน -->
                        <Dialog header="จัดการรอบประเมิน" v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <form>
                                <InputText v-model="text_edt" type="hidden" /> 
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="year_text">ปีงบประมาณ</label> 
                                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>  
                                    </div> 
                                    <div class="field col-12 md:col-8">
                                        <label for="evaluation_text">รอบประเมิน</label> 
                                        <Dropdown id="evaluation_text" v-model="dropdownItemEvalua" :options="dropdownItemsEvalua" optionLabel="name" placeholder="รอบประเมิน"></Dropdown> 
                                    </div>
                                </div>
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dateStart_text">วันที่กำหนด (เริ่ม)</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateStart" />
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dateEnd_text">วันที่ครบกำหนด (สิ้นสุด)</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateEnd" />
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="announce_text" style="color: red;font-weight: 600;">วันที่ประกาศคะแนน **</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateAnnounce" />
                                    </div>
                                </div> 
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataset" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog> 
                        <Dialog header="จัดการ ป.01" v-model:visible="DialogDetail" :breakpoints="{ '960px': '90vw' }" :style="{ width: '90vw' }" :modal="true" position="top">
                            <!-- {{ dataP01 }} -->
                            <P01 :dataP01="dataP01"></P01>
                            <template #footer>
                                <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="DialogDetail = false " />
                            </template>
                        </Dialog> 
                    </div> 
                </div>   
                <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                    <Column field="Tb_name" header="สังกัด" style="width: 16%; text-align: center;">
                        <template #body="">  
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <b>{{ user.user.name.SCOPES?.staffdepartmentname }}</b>
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_name" header="ปีงบประมาณ" style="width: 10%; text-align: center;">
                        <template #body="Item">  
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <b>{{ Item.data.d_date }}</b>
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_ind" header="รอบประเมิน" style="width: 20%; text-align: center;">
                        <template #body="Item">   
                            <div v-if="Item.data.d_evaluationround" style="display: flex; justify-content: center; align-items: center;">
                                {{ Item.data.d_evaluationround }}
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_target" header="วันที่กำหนด" style="width: 12%; text-align: center;">
                        <template #body="Item"> 
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <!-- {{ Item.data.d_recordingday }}    -->
                                {{ formatDateToThai(Item.data.d_recordingday) }}
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_score" header="วันที่ครบกำหนด" style="width: 12%; text-align: center;">
                        <template #body="Item">  
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <em style="color: red;">{{ formatDateToThai(Item.data.d_enddate) }}</em>
                                 
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_weight" header="วันที่ประกาศคะแนน" style="width: 10%; text-align: center;">
                        <template #body="Item"> 
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <b style="color: blue;">{{ formatDateToThai(Item.data.d_scoringday) }}</b>
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_balance" header="จัดการแบบประเมิน" style="width: 10%; text-align: center;">
                        <template #body="Item"> 
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <Button icon="pi pi-list" severity="warning" class="mb-2 mr-2" @click="por01Data(Item.data)"  />
                            </div>
                        </template>
                    </Column>
                    <Column field="options" header="ตัวเลือก" style="width: 14%; text-align: center;">
                        <template #body="Item">   
                            <div style="display: flex; justify-content: center; align-items: center;"> 
                                <Button icon="pi pi-pencil" severity="success" class="mb-2 mr-2" @click="editData(Item.data)" />
                                <Button icon="pi pi-trash" severity="danger" class="mb-2 mr-2" v-if="Item.data.chk_btn == 0" @click="delData(Item.data)" />  
                            </div>
                        </template>
                    </Column> 
                </DataTable> 
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
import P01 from "./pages/setting/setting_assessment.vue";

export default {    
    components : {
        P01
    },
    data() {
        return {  
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '01',
            products_date: [],  
            // Dialog
            DialogAdd: false, 
            DialogDetail: false, 
            text_edt: null, 
            dropdownItemYear: null,
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            dropdownItemEvalua: null,
            dropdownItemsEvalua: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28/29 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            ], 
            dateStart: null,
            dateEnd: null, 
            dateAnnounce: null, 
            dataP01:{}, 
        }
    },
    async mounted(){
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        
        await this.setSession(STAFFID,staffdepartment,groupid);
        await this.showDataSet(STAFFID,staffdepartment,groupid); 
    },
    methods: {
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main
        },
        showDataSet(){  
            axios.post('http://localhost:8000/api/showDateSet',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main,
            }).then(res => {     
                 //console.log(res.data);  
                this.products_date = res.data;
            })
            .catch(error => {
                console.error('Error:', error);

            });
        },
        por01Data(data){ 
            // console.log('data: ',data); 
            this.DialogDetail = true;  
            this.dataP01 = {
                staffid:this.staffid_Main,
                year:data.d_date,
                evalua:data.evalua,
                d_evaluationround:data.d_evaluationround, 
                //  staffdepartment: user.name.staffdepartment
                staffdepartment:this.facid_Main
            }
        },

        editData(data){ 
            // console.log(data);
            this.DialogAdd = true;  
            this.text_edt = data.id;

            const year_ob = this.dropdownItemsYear.filter(f=>f.code==data.d_date)
            this.dropdownItemYear = year_ob.length > 0 ? year_ob[0] : null;   

            const evalua_ob = this.dropdownItemsEvalua.filter(f=>f.code==data.evalua)
            this.dropdownItemEvalua = evalua_ob.length > 0 ? evalua_ob[0] : null;   
 
            this.dateStart = data.d_recordingday;
            this.dateEnd = data.d_enddate;
            this.dateAnnounce = data.d_scoringday; 
        },
        delData(data){ 
            Swal.fire({
                title: "คุณต้องการลบรอบประเมิน ใช่หรือไม่ ?",
                text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                if (result.isConfirmed) {
                    axios.post('http://localhost:8000/api/delDateSet',{
                        data: data
                    }).then(res => { 
                        // console.log(res.data);   
                        this.showDataSet();
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
        OpenDialogAdd(){
            this.DialogAdd = true; 
            this.text_edt = null;
            this.dropdownItemYear = null; 
            this.dropdownItemEvalua = null;
            this.dateStart = null;
            this.dateEnd = null;
            this.dateAnnounce = null; 
        },
        resetDialog(){
            this.DialogAdd = false; 
            this.DialogDetail = false; 
        },
        saveDataset(){
            // console.log(this.dropdownItemYear.code); 
            axios.post('http://localhost:8000/api/saveDateSet',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main,
                text_edt: this.text_edt,
                year: this.dropdownItemYear,
                evalua: this.dropdownItemEvalua,
                dateStart: this.dateStart,
                dateEnd: this.dateEnd,
                dateAnnounce: this.dateAnnounce,  
 
            }).then(res => {     
                 //console.log(res.data); 
                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกเรียบร้อยแล้ว !",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.DialogAdd = false;  
                this.showDataSet(); 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
        formatDateToThai(date) {
            if (!date) return '';
            
            const options = {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
            };

            return new Intl.DateTimeFormat('th-TH', options).format(new Date(date));
        },
    }

}
</script>

<style>
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