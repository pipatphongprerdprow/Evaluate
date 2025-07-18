<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">  
                <div class="formgroup-inline mb-1"> 
                    <div class="col md:col-6">  
                        <h3 class="mb-4 card-header"><i class="pi pi-calendar" style="font-size: x-large;"></i> จัดการ รอบประเมิน</h3>
                    </div> 
                    <!-- {{ user.user }} -->
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
                                        <label for="dateStart_text" style="color: red;font-weight: 600;">วันที่ครบกำหนดบันทึกแบบ ป.01</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateStart" />
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dateEnd_text" style="color: red;font-weight: 600;" >วันที่ครบกำหนดบันทึกแบบ ป.03</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateEnd" />
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="announce_text" style="color: red;font-weight: 600;">วันที่ประกาศคะแนน</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateAnnounce" />
                                    </div>
                                </div>
                                <h5 class="mb-4 card-header">กำหนดสิทธิ์การประเมิน</h5>
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user1">ผู้ประเมินคนที่ 1</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user1" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid1" />  
                                        </InputGroup> 
                                        <span v-if="seen">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername1" :key="li.id" @click="nameUserclick1(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully1"> 
                                        <input type="hidden" v-model="text_staff1"> 
                                        <input type="hidden" v-model="text_position1"> 
                                       
                                        
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user2">ผู้ประเมินคนที่ 2</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user2" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid2" />  
                                        </InputGroup> 
                                        <span v-if="seen2">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername2" :key="li.id" @click="nameUserclick2(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully2">  
                                        <input type="hidden" v-model="text_staff2"> 
                                        <input type="hidden" v-model="text_position2"> 
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user3">ผู้ประเมินคนที่ 3</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user3" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid3" />  
                                        </InputGroup> 
                                        <span v-if="seen3">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername3" :key="li.id" @click="nameUserclick3(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully3">   
                                        <input type="hidden" v-model="text_staff3"> 
                                        <input type="hidden" v-model="text_position3"> 
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user4">ผู้ประเมินคนที่ 4</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user4" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid4" />  
                                        </InputGroup> 
                                        <span v-if="seen4">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername4" :key="li.id" @click="nameUserclick4(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully4">   
                                        <input type="hidden" v-model="text_staff4"> 
                                        <input type="hidden" v-model="text_position4"> 
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user5" style="color: red;">**เจ้าหน้าที่บุคคล**</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user5" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid5" />  
                                        </InputGroup> 
                                        <span v-if="seen5">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername5" :key="li.id" @click="nameUserclick5(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully5">   
                                        <input type="hidden" v-model="text_staff5"> 
                                        <input type="hidden" v-model="text_position5"> 
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
                    <Column field="Tb_target" header="วันที่ครบกำหนดบันทึกแบบ ป.01" style="width: 12%; text-align: center;">
                        <template #body="Item"> 
                            <div style="display: flex; justify-content: center; align-items: center;"> 
                                {{ formatDateToThai(Item.data.d_recordingday) }}
                            </div>
                        </template>
                    </Column>
                    <Column field="Tb_score" header="วันที่ครบกำหนดบันทึกแบบ ป.03" style="width: 12%; text-align: center;">
                        <template #body="Item">  
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <em style="color: red;">{{ formatDateToThai(Item.data.d_enddate) }}</em>
                                <!-- {{ Item.data.d_scoringday }}    -->
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
            // คนที่ 1
            seen: false,
            text_user1: null,
            listshoeusername1: null,
            text_staff1: null,
            text_position1: null,
            text_namefully1 : null,
            // คนที่ 2
            seen2: false,
            text_user2: null,
            listshoeusername2: null,
            text_staff2: null,
            text_position2: null,
            text_namefully2 : null,

            // คนที่ 3
            seen3: false,
            text_user3: null,
            listshoeusername3: null,
            text_staff3: null,
            text_position3: null,
            // คนที่ 4
            seen4: false,
            text_user4: null,
            listshoeusername4: null,
            text_staff4: null,
            text_position4: null,
            // คนที่ 5
            seen5: false,
            text_user5: null,
            listshoeusername5: null,
            text_staff5: null,
            text_position5: null, 
             
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
            axios.post('   http://127.0.0.1:8000/api/showDateSet',{
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
            //console.log(data); 
            this.DialogAdd = true;  
            this.text_edt = data.id;
            
            const year_ob = this.dropdownItemsYear.filter(f=>f.code==data.d_date)
            this.dropdownItemYear = year_ob.length > 0 ? year_ob[0] : null;   

            const evalua_ob = this.dropdownItemsEvalua.filter(f=>f.code==data.evalua)
            this.dropdownItemEvalua = evalua_ob.length > 0 ? evalua_ob[0] : null;    

            this.dateStart = data.d_recordingday;
            this.dateEnd = data.d_enddate;
            this.dateAnnounce = data.d_scoringday; 

            this.text_user1 =data.leader1+' : '+ data.leader_name1;
            this.text_staff1 = data.leader1; 
            this.text_position1 = data.leader_position1; 
            this.text_namefully1 = data.leader_name1; 
            this.text_user2 =data.leader2+' : '+ data.leader_name2; 
            this.text_staff2 = data.leader2; 
            this.text_position2 = data.leader_position2; 
            this.text_namefully2 = data.leader_name2; 
            this.text_user3 =data.leader3+' : '+ data.leader_name3; 
            this.text_staff3 = data.leader3; 
            this.text_position3 = data.leader_position3;
            this.text_namefully3 = data.leader_name3;
            this.text_user4 =data.leader4+' : '+ data.leader_name4; 
            this.text_staff4 = data.leader4; 
            this.text_position4 = data.leader_position4;
            this.text_namefully4 = data.leader_name4; 
            this.text_user5 =data.leader5+' : '+ data.leader_name5; 
            this.text_staff5 = data.leader5; 
            this.text_position5 = data.leader_position5;
            this.text_namefully5 = data.leader_name5; 


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
                    axios.post('   http://127.0.0.1:8000/api/delDateSet',{
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
            axios.post('   http://127.0.0.1:8000/api/saveDateSet',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main,
                text_edt: this.text_edt,
                year: this.dropdownItemYear,
                evalua: this.dropdownItemEvalua,
                dateStart: this.dateStart,
                dateEnd: this.dateEnd,
                dateAnnounce: this.dateAnnounce,  
                // user
                text_staff1: this.text_staff1,
                text_position1: this.text_position1,
                text_namefully1: this.text_namefully1, 
                text_staff2: this.text_staff2,
                text_position2: this.text_position2,
                text_namefully2: this.text_namefully2,  
                text_staff3: this.text_staff3,
                text_position3: this.text_position3,
                text_namefully3: this.text_namefully3,   
                text_staff4: this.text_staff4,
                text_position4: this.text_position4,
                text_namefully4: this.text_namefully4,  
                text_staff5: this.text_staff5,
                text_position5: this.text_position5,
                text_namefully5: this.text_namefully5,  
 
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
        // User 1
        async searchUserStaffid1(){  
            try { 
                if (this.previousName && this.text_user1.length < this.previousName.length) {  
                    this.text_staff1 = null;
                    this.text_position1 = null;
                    this.text_namefully1 = null;
                }

                if(this.text_user1.length > 3){
                    const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_user1
                        }
                    }); 
                    //console.log('searchUserStaffid1: ',res.data);  
                    this.seen = true; 
                    this.listshoeusername1=res.data  
                }
                this.previousName = this.text_user1;
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },  
        nameUserclick1(data){   
            //console.log('nameUserclick1: ',data);
            this.seen = false; 
            this.text_user1 = data.staffid+' : '+data.namefully; 
            this.text_staff1 = data.staffid;
            this.text_position1 = data.posnameth;
            this.text_namefully1 = data.namefully;
        },

        // User 2
        async searchUserStaffid2(){  
            try { 
                if (this.previousName && this.text_user2.length < this.previousName.length) {  
                    this.text_staff2 = null;
                    this.text_position2 = null;
                    this.text_namefully2 = null; 
                }
                if(this.text_user2.length > 3){
                    const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_user2
                        }
                    }); 
                    //console.log('searchUserStaffid2: ',res.data);  
                    this.seen2 = true; 
                    this.listshoeusername2=res.data  
                }
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },  
        nameUserclick2(data){   
            //console.log('nameUserclick1: ',data);
            this.seen2 = false; 
            this.text_user2 = data.staffid+' : '+data.namefully; 
            this.text_staff2 = data.staffid;
            this.text_position2 = data.posnameth;
            this.text_namefully2 = data.namefully;
        },
             // User 3
        async searchUserStaffid3(){  
            try { 
                if (this.previousName && this.text_user3.length < this.previousName.length) {  
                    this.text_staff3 = null;
                    this.text_position3 = null;
                    this.text_namefully3 = null; 
                }
                if(this.text_user3.length > 3){
                    const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_user3
                        }
                    }); 
                    //console.log('searchUserStaffid3: ',res.data);  
                    this.seen3 = true; 
                    this.listshoeusername3=res.data  
                }
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },  
        nameUserclick3(data){   
            //console.log('nameUserclick3: ',data);
            this.seen3 = false; 
            this.text_user3 = data.staffid+' : '+data.namefully; 
            this.text_staff3 = data.staffid;
            this.text_position3 = data.posnameth;
            this.text_namefully3 = data.namefully;
        },
             // User 4
        async searchUserStaffid4(){  
            try { 
                if(this.text_user4.length > 3){
                    const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_user4
                        }
                    }); 
                    //console.log('searchUserStaffid1: ',res.data);  
                    this.seen4 = true; 
                    this.listshoeusername4=res.data  
                }
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },  
        nameUserclick4(data){   
            //console.log('nameUserclick4: ',data);
            this.seen4 = false; 
            this.text_user4 = data.staffid+' : '+data.namefully; 
            this.text_staff4 = data.staffid;
            this.text_position4 = data.posnameth;
            this.text_namefully4 = data.namefully;
        },
             // User 5
        async searchUserStaffid5(){  
            try { 
                if(this.text_user5.length > 3){
                    const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_user5
                        }
                    }); 
                    //console.log('searchUserStaffid1: ',res.data);  
                    this.seen5 = true; 
                    this.listshoeusername5=res.data  
                }
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },  
        nameUserclick5(data){   
            //console.log('nameUserclick1: ',data);
            this.seen5 = false; 
            this.text_user5 = data.staffid+' : '+data.namefully; 
            this.text_staff5 = data.staffid;
            this.text_position5 = data.posnameth;
            this.text_namefully5 = data.namefully;
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
  table {
    border-collapse: collapse;
    width: 100%; 
}
th, td {
    border: 1px solid rgb(206, 203, 203);
    text-align: center;
}
#country-list{float:left;list-style:none;margin-top:-3px;padding:0;width:25%;position: absolute; z-index:9999 !important;}
#country-list li{padding: 10px; background: #f0f0f0; border-bottom: #bbb9b9 1px solid;}
#country-list li:hover{background:#ece3d2;cursor: pointer;}
</style>