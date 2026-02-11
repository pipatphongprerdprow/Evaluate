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

                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="openevalua_text" style="color: red;font-weight: 600;">วันที่เปิดรอบประเมิน</label>  
                                        <InputText type="date" id="inputgroup" v-model="openevalua" />
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="closeevalua_text" style="color: red;font-weight: 600;" >วันที่ปิดรอบประเมิน</label>  
                                        <InputText type="date" id="inputgroup" v-model="closeevalua" />
                                    </div>
                                </div>


                                 <!-- <div class="p-fluid formgrid grid"> 
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
                                </div> -->

 

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
                                         <label for="text_user5">ผู้ประเมินคนที่ 5</label>
                                        <!-- <label for="text_user5" style="color: red;">**เจ้าหน้าที่บุคคล**</label> -->
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


                                    <!-- เริ่ม -->

                                    <div class="field col-12 md:col-4">
                                        <label for="text_user6">ผู้ประเมินคนที่ 6</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user6" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid6" />  
                                        </InputGroup> 
                                        <span v-if="seen6">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername6" :key="li.id" @click="nameUserclick6(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully6">   
                                        <input type="hidden" v-model="text_staff6"> 
                                        <input type="hidden" v-model="text_position6"> 
                                    </div> 
 
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user7">ผู้ประเมินคนที่ 7</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user7" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid7" />  
                                        </InputGroup> 
                                        <span v-if="seen7">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername7" :key="li.id" @click="nameUserclick7(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully7">   
                                        <input type="hidden" v-model="text_staff7"> 
                                        <input type="hidden" v-model="text_position7"> 
                                    </div> 

                                    <div class="field col-12 md:col-4">
                                        <label for="text_user8">ผู้ประเมินคนที่ 8</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user8" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid8" />  
                                        </InputGroup> 
                                        <span v-if="seen8">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername8" :key="li.id" @click="nameUserclick8(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully8">   
                                        <input type="hidden" v-model="text_staff8"> 
                                        <input type="hidden" v-model="text_position8"> 
                                    </div> 

                                    <div class="field col-12 md:col-4">
                                        <label for="text_user9" style="color: red;">**เจ้าหน้าที่บุคคล**</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_user9" type="text" placeholder="ชื่อผู้ประเมิน" autocomplete="off" @keyup="searchUserStaffid9" />  
                                        </InputGroup> 
                                        <span v-if="seen9">
                                            <ul id="country-list">
                                                <li v-for="(li) in listshoeusername9" :key="li.id" @click="nameUserclick9(li)">{{li.staffid}} : {{li.namefully}}</li>
                                            </ul>
                                        </span>
                                        <input type="hidden" v-model="text_namefully9">   
                                        <input type="hidden" v-model="text_staff9"> 
                                        <input type="hidden" v-model="text_position9"> 
                                    </div> 
  
                                    <!-- สิ้นสุด -->



 
 
                                </div>  
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataset" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog> 
                        <Dialog header="จัดการ ป.01" v-model:visible="DialogDetail" :breakpoints="{ '960px': '90vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
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
                { name: 'ปีงบประมาณ 2571', code: 2571 },
                { name: 'ปีงบประมาณ 2570', code: 2570 }, 
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                // { name: 'ปีงบประมาณ 2567', code: 2567 },
                // { name: 'ปีงบประมาณ 2566', code: 2566 },
                // { name: 'ปีงบประมาณ 2565', code: 2565 },
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
            // คนที่ 6
            seen6: false,
            text_user6: null,
            listshoeusername6: null,
            text_staff6: null,
            text_position6: null, 
            // คนที่ 7
            seen7: false,
            text_user7: null,
            listshoeusername7: null,
            text_staff7: null,
            text_position7: null,
            // คนที่ 8
            seen8: false,
            text_user8: null,
            listshoeusername8: null,
            text_staff8: null,
            text_position8: null,
            // คนที่ 9
            seen9: false,
            text_user9: null,
            listshoeusername9: null,
            text_staff9: null,
            text_position9: null,
             
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

            // this.text_user1 =data.leader1+' : '+ data.leader_name1;
            if (data.leader1 && data.leader_name1) {
                this.text_user1 = data.leader1 + ' : ' + data.leader_name1
            } else {
                this.text_user1 = ''    
            }
            this.text_staff1 = data.leader1; 
            this.text_position1 = data.leader_position1; 
            this.text_namefully1 = data.leader_name1; 

            // this.text_user2 =data.leader2+' : '+ data.leader_name2;
            if (data.leader2 && data.leader_name2) {
                this.text_user2 = data.leader2 + ' : ' + data.leader_name2
            } else {
                this.text_user2 = ''    
            } 
            this.text_staff2 = data.leader2; 
            this.text_position2 = data.leader_position2; 
            this.text_namefully2 = data.leader_name2; 

            // this.text_user3 =data.leader3+' : '+ data.leader_name3; 
            if (data.leader3 && data.leader_name3) {
                this.text_user3 = data.leader3 + ' : ' + data.leader_name3
            } else {
                this.text_user3 = ''    
            }
            this.text_staff3 = data.leader3; 
            this.text_position3 = data.leader_position3;
            this.text_namefully3 = data.leader_name3;

            // this.text_user4 =data.leader4+' : '+ data.leader_name4; 
            if (data.leader4 && data.leader_name4) {
                this.text_user4 = data.leader4 + ' : ' + data.leader_name4
            } else {
                this.text_user4 = ''    
            }
            this.text_staff4 = data.leader4; 
            this.text_position4 = data.leader_position4;
            this.text_namefully4 = data.leader_name4;  

            // this.text_user5 =data.leader5+' : '+ data.leader_name5; 
            if (data.leader5 && data.leader_name5) {
                this.text_user5 = data.leader5 + ' : ' + data.leader_name5
            } else {
                this.text_user5 = ''    
            }
            this.text_staff5 = data.leader5; 
            this.text_position5 = data.leader_position5;
            this.text_namefully5 = data.leader_name5; 

            // this.text_user6 =data.leader6+' : '+ data.leader_name6; 
            if (data.leader6 && data.leader_name6) {
                this.text_user6 = data.leader6 + ' : ' + data.leader_name6
            } else {
                this.text_user6 = ''    
            }
            this.text_staff6 = data.leader6; 
            this.text_position6 = data.leader_position6;
            this.text_namefully6 = data.leader_name6; 

            // this.text_user7 =data.leader7+' : '+ data.leader_name7; 
            if (data.leader7 && data.leader_name7) {
                this.text_user7 = data.leader7 + ' : ' + data.leader_name7
            } else {
                this.text_user7 = ''    
            } 
            this.text_staff7 = data.leader7; 
            this.text_position7 = data.leader_position7;
            this.text_namefully7 = data.leader_name7; 

            // this.text_user8 =data.leader8+' : '+ data.leader_name8; 
            if (data.leader8 && data.leader_name8) {
                this.text_user8 = data.leader8 + ' : ' + data.leader_name8
            } else {
                this.text_user8 = ''    
            }
            this.text_staff8 = data.leader8; 
            this.text_position8 = data.leader_position8;
            this.text_namefully8 = data.leader_name8; 

            // this.text_user9 =data.leader9+' : '+ data.leader_name9; 
            if (data.leader9 && data.leader_name9) {
                this.text_user9 = data.leader9 + ' : ' + data.leader_name9
            } else {
                this.text_user9 = ''    
            }
            this.text_staff9 = data.leader9; 
            this.text_position9 = data.leader_position9;
            this.text_namefully9 = data.leader_name9; 

 
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
            axios.post('http://127.0.0.1:8000/api/saveDateSet',{
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
                text_staff6: this.text_staff6,
                text_position6: this.text_position6,
                text_namefully6: this.text_namefully6,   
                text_staff7: this.text_staff7,
                text_position7: this.text_position7,
                text_namefully7: this.text_namefully7, 
                text_staff8: this.text_staff8,
                text_position8: this.text_position8,
                text_namefully8: this.text_namefully8, 
                text_staff9: this.text_staff9,
                text_position9: this.text_position9,
                text_namefully9: this.text_namefully9,

 
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
        // async searchUserStaffid1(){  
        //     try { 
        //         if (this.previousName && this.text_user1.length < this.previousName.length) {  
        //             this.text_staff1 = null;
        //             this.text_position1 = null;
        //             this.text_namefully1 = null;
        //         }

        //         if(this.text_user1.length > 3){
        //             const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user1
        //                 }
        //             }); 
        //             console.log('searchUserStaffid1: ',res.data);  
        //             this.seen = true; 
        //             this.listshoeusername1=res.data  
        //         }
        //         this.previousName = this.text_user1;
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  
 
        async searchUserStaffid1(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user1 || this.text_user1.trim().length === 0) {
                this.text_staff1 = null
                this.text_position1 = null
                this.text_namefully1 = null
                this.seen = false
                this.listshoeusername1 = null
                return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user1.length < 4) {
                this.text_staff1 = null
                this.text_position1 = null
                this.text_namefully1 = null
                this.seen = false
                this.listshoeusername1 = null
                return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user1 }
                })
                this.seen = true
                this.listshoeusername1 = res.data
            } catch (e) {
                console.error(e)
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
        // async searchUserStaffid2(){  
        //     try { 
        //         if (this.previousName && this.text_user2.length < this.previousName.length) {  
        //             this.text_staff2 = null;
        //             this.text_position2 = null;
        //             this.text_namefully2 = null; 
        //         }
        //         if(this.text_user2.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user2
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid2: ',res.data);  
        //             this.seen2 = true; 
        //             this.listshoeusername2=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid2(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user2 || this.text_user2.trim().length === 0) {
                this.text_staff2 = null
                this.text_position2 = null
                this.text_namefully2 = null
                this.seen2 = false
                this.listshoeusername2 = null
                return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user2.length < 4) {
                this.text_staff2 = null
                this.text_position2 = null
                this.text_namefully2 = null
                this.seen2 = false
                this.listshoeusername2 = null
                return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user2 }
                })
                this.seen2 = true
                this.listshoeusername2 = res.data
            } catch (e) {
                console.error(e)
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
        // async searchUserStaffid3(){  
        //     try { 
        //         if (this.previousName && this.text_user3.length < this.previousName.length) {  
        //             this.text_staff3 = null;
        //             this.text_position3 = null;
        //             this.text_namefully3 = null; 
        //         }
        //         if(this.text_user3.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user3
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid3: ',res.data);  
        //             this.seen3 = true; 
        //             this.listshoeusername3=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid3(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user3 || this.text_user3.trim().length === 0) {
                    this.text_staff3 = null
                    this.text_position3 = null
                    this.text_namefully3 = null
                    this.seen3 = false
                    this.listshoeusername3 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user3.length < 4) {
                this.text_staff3 = null
                this.text_position3 = null
                this.text_namefully3 = null
                this.seen3 = false
                this.listshoeusername3 = null
                return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user3 }
                })
                this.seen3 = true
                this.listshoeusername3 = res.data
            } catch (e) {
                console.error(e)
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
        // async searchUserStaffid4(){  
        //     try { 
        //         if(this.text_user4.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user4
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen4 = true; 
        //             this.listshoeusername4=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

         async searchUserStaffid4(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user4 || this.text_user4.trim().length === 0) {
                    this.text_staff4 = null
                    this.text_position4 = null
                    this.text_namefully4 = null
                    this.seen4 = false
                    this.listshoeusername4 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user4.length < 4) {
                    this.text_staff4 = null
                    this.text_position4 = null
                    this.text_namefully4 = null
                    this.seen4 = false
                    this.listshoeusername4 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user4 }
                })
                this.seen4 = true
                this.listshoeusername4 = res.data
            } catch (e) {
                console.error(e)
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
        // async searchUserStaffid5(){  
        //     try { 
        //         if(this.text_user5.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user5
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen5 = true; 
        //             this.listshoeusername5=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid5(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user5 || this.text_user5.trim().length === 0) {
                    this.text_staff5 = null
                    this.text_position5 = null
                    this.text_namefully5 = null
                    this.seen5 = false
                    this.listshoeusername5 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user5.length < 4) {
                    this.text_staff5 = null
                    this.text_position5 = null
                    this.text_namefully5 = null
                    this.seen5 = false
                    this.listshoeusername5 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user5 }
                })
                this.seen5 = true
                this.listshoeusername5 = res.data
            } catch (e) {
                console.error(e)
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
          // User 6
        // async searchUserStaffid6(){  
        //     try { 
        //         if(this.text_user6.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user6
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen6 = true; 
        //             this.listshoeusername6=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // }, 
        
        async searchUserStaffid6(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user6 || this.text_user6.trim().length === 0) {
                    this.text_staff6 = null
                    this.text_position6 = null
                    this.text_namefully6 = null
                    this.seen6 = false
                    this.listshoeusername6 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user6.length < 4) {
                    this.text_staff6 = null
                    this.text_position6 = null
                    this.text_namefully6 = null
                    this.seen6 = false
                    this.listshoeusername6 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user6 }
                })
                this.seen6 = true
                this.listshoeusername6 = res.data
            } catch (e) {
                console.error(e)
            }
        }, 
        nameUserclick6(data){   
            //console.log('nameUserclick1: ',data);
            this.seen6 = false; 
            this.text_user6 = data.staffid+' : '+data.namefully; 
            this.text_staff6 = data.staffid;
            this.text_position6 = data.posnameth;
            this.text_namefully6 = data.namefully;
        }, 
        
         // User 7
        // async searchUserStaffid7(){  
        //     try { 
        //         if(this.text_user7.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user7
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen7 = true; 
        //             this.listshoeusername7=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid7(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user7 || this.text_user7.trim().length === 0) {
                    this.text_staff7 = null
                    this.text_position7 = null
                    this.text_namefully7 = null
                    this.seen7 = false
                    this.listshoeusername7 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user7.length < 4) {
                    this.text_staff7 = null
                    this.text_position7 = null
                    this.text_namefully7 = null
                    this.seen7 = false
                    this.listshoeusername7 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user7 }
                })
                this.seen7 = true
                this.listshoeusername7 = res.data
            } catch (e) {
                console.error(e)
            }
        },

        nameUserclick7(data){   
            //console.log('nameUserclick1: ',data);
            this.seen7 = false; 
            this.text_user7 = data.staffid+' : '+data.namefully; 
            this.text_staff7 = data.staffid;
            this.text_position7 = data.posnameth;
            this.text_namefully7 = data.namefully;
        }, 

          // User 8
        // async searchUserStaffid8(){  
        //     try { 
        //         if(this.text_user8.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user8
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen8 = true; 
        //             this.listshoeusername8=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid8(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user8 || this.text_user8.trim().length === 0) {
                    this.text_staff8 = null
                    this.text_position8 = null
                    this.text_namefully8 = null
                    this.seen8 = false
                    this.listshoeusername8 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user8.length < 4) {
                    this.text_staff8 = null
                    this.text_position8 = null
                    this.text_namefully8 = null
                    this.seen8 = false
                    this.listshoeusername8 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user8 }
                })
                this.seen8 = true
                this.listshoeusername8 = res.data
            } catch (e) {
                console.error(e)
            }
        },

        nameUserclick8(data){   
            //console.log('nameUserclick1: ',data);
            this.seen8 = false; 
            this.text_user8 = data.staffid+' : '+data.namefully; 
            this.text_staff8 = data.staffid;
            this.text_position8 = data.posnameth;
            this.text_namefully8 = data.namefully;
        }, 

           // User 9
        // async searchUserStaffid9(){  
        //     try { 
        //         if(this.text_user9.length > 3){
        //             const res = await axios.get(' http://127.0.0.1:8000/api/searchDataStaff', {  
        //                 params: {
        //                     staffid: this.text_user9
        //                 }
        //             }); 
        //             //console.log('searchUserStaffid1: ',res.data);  
        //             this.seen9 = true; 
        //             this.listshoeusername9=res.data  
        //         }
        //     } catch (error) {
        //         console.error('Error fetching evaluation data:', error);
        //     } 
        // },  

        async searchUserStaffid9(){
            try {
                // ✅ เพิ่ม: ถ้าลบจนว่าง -> ล้างค่าที่จะบันทึก
                if (!this.text_user9 || this.text_user9.trim().length === 0) {
                    this.text_staff9 = null
                    this.text_position9 = null
                    this.text_namefully9 = null
                    this.seen9 = false
                    this.listshoeusername9 = null
                    return
                }

                // ✅ เพิ่ม: ถ้าพิมพ์สั้น (<4) ให้ถือว่ายังไม่เลือกคน
                if (this.text_user9.length < 4) {
                    this.text_staff9 = null
                    this.text_position9 = null
                    this.text_namefully9 = null
                    this.seen9 = false
                    this.listshoeusername9 = null
                    return
                }

                // ค้นหาเหมือนเดิม
                const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                params: { staffid: this.text_user9 }
                })
                this.seen9 = true
                this.listshoeusername9 = res.data
            } catch (e) {
                console.error(e)
            }
        },

        nameUserclick9(data){   
            //console.log('nameUserclick1: ',data);
            this.seen9 = false; 
            this.text_user9 = data.staffid+' : '+data.namefully; 
            this.text_staff9 = data.staffid;
            this.text_position9 = data.posnameth;
            this.text_namefully9 = data.namefully;
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