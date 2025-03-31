<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">  
                <div class="formgroup-inline mb-1"> 
                    <!-- {{ user.user }} -->
                    <div class="col md:col-6">  
                        <h3 class="mb-4 card-header"><i class="pi pi-user" style="font-size: x-large;"></i> จัดการ สิทธิ์การใช้งาน</h3>
                    </div>  
                    <br> 
                    <div class="col md:col-16 text-right"> 
                        <Button icon="pi pi-user-edit" severity="help" class="mb-2 mr-2" label="เพิ่มสิทธิ์การใช้งาน" @click="OpenDialogAdd" /> 
                        <!-- <Button icon="pi pi-user" severity="info" class="mb-2 mr-2" label="เพิ่มผู้ประเมิน" @click="OpenDialogAdd" />  -->


                        <!-- เพิ่มข้อมูลรอบประเมิน -->
                        <!-- <Dialog header="จัดการสิทธ์การใช้งาน" v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <form>
                                <InputText v-model="text_edt" type="hidden" /> 
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-3">
                                        <label for="year_text">ชื่อผู้ประเมิน</label>  
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                                <InputText id="year_text" v-model="userItemEvaluaUsaege" placeholder="เพิ่มชื่อผู้ประเมิน" />
                                        </InputGroup>
                                    </div> 
                                    <div class="field col-12 md:col-3">
                                        <label for="year_text">รหัสพนักงาน</label>  
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-sort-numeric-up"></i>
                                            </InputGroupAddon>
                                                <InputText id="year_text" v-model="userItemEvaluaUsaege1" placeholder="รหัสพนักงาน" />
                                        </InputGroup>
                                    </div> 
                                    <div class="field col-12 md:col-3">
                                        <label for="year_text">รหัสคณะ</label>  
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-sort-numeric-up"></i>
                                            </InputGroupAddon>
                                                <InputText id="year_text" v-model="userItemEvaluaUsaege2" placeholder="รหัสคณะ" />
                                        </InputGroup>
                                    </div> 
                                    <div class="field col-12 md:col-3">
                                        <label for="evaluation_text">สิทธิ์การใช้งาน</label>  
                                        <Dropdown id="evaluation_text" v-model="userItemEvalua" :options="userItemEvaluaX" optionLabel="name" placeholder="เลือกสิทธิ์การใช้งาน"></Dropdown> 
                                    </div>
                                </div> 
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDatauser" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog>  -->  

                        <Dialog header="จัดการสิทธ์การใช้งาน" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top">
                            <form>
                                <div class="p-fluid formgrid"> 
                                    <form>
                                        <InputText v-model="text_edt" type="hidden" />
                                        <div class="p-fluid formgrid grid"> 
                                            <div class="field col-12 md:col-2">
                                                <label for="text_nonum">ลำดับ</label>
                                                <InputGroup> 
                                                    <InputText v-model="text_nonum" type="number" placeholder="ลำดับ" autocomplete="off"/> 
                                                </InputGroup> 
                                            </div>
                                            <div class="field col-12 md:col-3">
                                                <label for="userItemEvalua">สิทธิ์การใช้งาน</label>
                                                <Dropdown id="evaluation_text" v-model="userItemEvalua" :options="userItemEvaluaX" optionLabel="name" placeholder="เลือกสิทธิ์การใช้งาน"></Dropdown>
                                            </div>  
                                            <div class="field col-12 md:col-3">
                                                <label for="text_noUse">รหัสพนักงาน</label>
                                                <InputGroup>
                                                    <InputGroupAddon>
                                                        <i class="pi pi-user"></i>
                                                    </InputGroupAddon>
                                                    <InputText v-model="text_noUse" type="text" placeholder="รหัสพนักงาน" autocomplete="off" @keyup="searchUserStaffid" />  
                                                </InputGroup> 
                                                <span v-if="seen">
                                                    <ul id="country-list">
                                                        <li v-for="(li) in listshoeusername" :key="li.id" @click="nameUserclick(li)">{{li.staffid}} : {{li.namefully}}</li>
                                                    </ul>
                                                </span>
                                                <input type="hidden" v-model="text_staffid">
                                                <input type="hidden" v-model="text_namefully">
                                                <input type="hidden" v-model="text_departmentid">
                                                <input type="hidden" v-model="text_departmentname"> 
                                            </div>
                                            <div class="field col-12 md:col-4">
                                                <label for="userItemfaculty">รหัสคณะที่ประเมิน</label>
                                                <InputGroup>
                                                    <InputGroupAddon>
                                                        <i class="pi pi-sort-numeric-down"></i>
                                                    </InputGroupAddon>
                                                    <Dropdown id="evaluation_textfac" v-model="userItemfaculty" :options="userItemfacultyX" optionLabel="name" placeholder="เลือกสิทธิ์การใช้งาน"></Dropdown> &nbsp; &nbsp; 
                                                    <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalistUser" />  
                                                </InputGroup>     
                                            </div>  
                                        </div>  
                                        <hr>
                                        <DataTable :value="products_listUser" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">   
                                            <Column field="ind_number"  header="ลำดับ"  headerStyle="text-align: center; width: 20%;" bodyStyle="text-align: left;" > 
                                                <template #body="Item">
                                                    ลำดับที่ {{ Item.data.ind_number }}
                                                </template>  
                                            </Column>
                                            <Column field="ind_Items"  header="สิทธิ์การใช้งาน"  headerStyle="text-align: center; width: 20%;" bodyStyle="text-align: left;" >
                                                <template #body="Item"> 
                                                    {{ Item.data.userItemEvalua ? Item.data.userItemEvalua.name : '' }}
                                                </template>
                                            </Column>  
                                            <Column field="ind_Items" header="รหัสพนักงาน" style="text-align: left;width: 20%">
                                                <template #body="Item"> 
                                                {{ Item.data.ind_no }}
                                                </template>
                                            </Column>  
                                            <Column field="ind_Items" header="รหัสคณะที่ประเมิน" style="text-align: left;width: 20%">
                                                <template #body="Item"> 
                                                {{ Item.data.ind_Items ? Item.data.ind_Items.name :''}}
                                                </template>
                                            </Column> 
                                            <Column field="options" header="ตัวเลือก" style="text-align: left; width: 20%">
                                                <template #body="Item"> 
                                                    <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="EditRegislick(Item.data)"></Button> &nbsp;
                                                    <Button style="text-align: center;" severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislickUser(Item.data.ind_no)"></Button>
                                                </template>
                                            </Column> 
                                        </DataTable>
                                    </form>
                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataxEditDataUser" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialog" />
                            </template>
                        </Dialog>
                            <!-- แก้ไขข้อมูลการจัดการสิทธิ์ -->
                        <Dialog header="แก้ไขข้อมูล จัดการสิทธิ์" maximizable v-model:visible="DialogEditList" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <form>
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-2">
                                        <label for="text_nonumEdt">ลำดับ</label>
                                        <InputGroup> 
                                            <InputText v-model="text_nonumEdt" type="ind_number" placeholder="ลำดับ" autocomplete="off"/> 
                                        </InputGroup> 
                                    </div>
                                    <div class="field col-12 md:col-3">
                                        <label for="userItemEvaluaEdt">สิทธิ์การใช้งาน</label>
                                        <Dropdown id="evaluation_textEdt" v-model="userItemEvaluaEdt" :options="userItemEvaluaEdt" optionLabel="name" placeholder="เลือกสิทธิ์การใช้งาน"></Dropdown>
                                    </div>  
                                    <div class="field col-12 md:col-3">
                                        <label for="text_noUseEdt">รหัสพนักงาน</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-user"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_noUseEdt" type="text" placeholder="รหัสพนักงาน" autocomplete="off" @keypress="searchUserStaffid"/> 
                                        </InputGroup> 
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="text_SavenoEdt">รหัสคณะ</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-sort-numeric-down"></i>
                                            </InputGroupAddon>
                                            <InputText v-model="text_SavenoEdt" type="text" placeholder="รหัสคณะ" autocomplete="off" />&nbsp; &nbsp;  
                                        </InputGroup>     
                                    </div>  
                                </div> 
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataxEditDataUser" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialog" />
                            </template>
                        </Dialog> 
                        
                    </div> 
                </div>   
                <DataTable :value="products_name" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                    <Column field="ind_number"  header="ลำดับ"  headerStyle="text-align: left; width: 20%;" bodyStyle="text-align: left;" > 
                        <template #body="Item">
                            ลำดับที่ {{ Item.data.ind_number }}
                        </template>  
                    </Column>

                    <Column field="Tb_names" header="สิทธิ์การใช้งาน" headerStyle="text-align: left; width: 20%;" bodyStyle="text-align: left;">
                        <template #body="Item">  
                                {{ Item.data.userItemEvalua ? Item.data.userItemEvalua.name : '' }} 
                        </template>
                    </Column>

                    <Column field="Tb_names" header="รหัสพนักงาน" headerStyle="text-align: left; width: 20%;" bodyStyle="text-align: left;">
                        <template #body="Item">   
                                {{ Item.data.ind_no }} 
                        </template>
                    </Column>

                    <Column field="Tb_ind" header="รหัสคณะที่ประเมิน" headerStyle="text-align: left; width: 20%;" bodyStyle="text-align: left;">
                        <template #body="Item">   
                            {{ Item.data.ind_Items ? Item.data.ind_Items.name :''}}
                        </template>
                    </Column>

                    <Column field="options" header="ตัวเลือก" headerStyle="text-align: left; width: 20%;" bodyStyle="text-align: left;">
                        <template #body="Item">  
                                <!-- <Button icon="pi pi-pencil" severity="success" class="mb-2 mr-2" @click="editData(Item.data)" /> -->
                                <Button icon="pi pi-trash" severity="danger" class="mb-2 mr-2"   @click="delData(Item.data)" />   
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
            products_name: [],
            products_listUser:[],
            text_Saveno: null,
            text_SavenoEdt: null, 
            text_noUse: null,
            text_nonum: null,
            text_nonumEdt: null,  
            // Dialog
            DialogAdd: false, 
            DialogDetail: false, 
            text_edt: null, 
            // userItemEvaluaUsaege: null,
            // userItemEvaluaUsaege1:null, 
            // userItemEvaluaUsaege2:null,
            userItemEvalua: null, 
            userItemEvaluaX: [
                { name: 'เจ้าหน้าที่บุคคล', code: '2' },
                { name: 'ผู้บริหาร', code: '3' },
                { name: 'ผู้บังคับบัญชาเหนือขึ้นไป', code: '4' },
            ], 
            userItemfaculty: null,
            userItemfacultyX: [
                {name:'201092704000 : กองแผนงาน',code:'1'},
                {name:'201092705000 : กองการเจ้าหน้าที่',code:'2'},
                {name:'201092708000 : กองอาคารสถานที่',code:'3'}, 
                {name:'201090000000 : มหาวิทยาลัยมหาสารคาม',code:'4'},
                {name:'201090100000 : คณะมนุษยศาสตร์และสังคมศาสตร์ ',code:'5'},
                {name:'201090101000 : สำนักงานเลขานุการ',code:'6'},
                {name:'201090200000 : คณะศึกษาศาสตร์ ',code:'7'}, 
                {name:'201090300000 : คณะการบัญชีและการจัดการ',code:'8'}, 
                {name:'201090400000 : คณะการท่องเที่ยวและการโรงแรม',code:'9'}, 
                {name:'201090500000 : คณะศิลปกรรมศาสตร์ ',code:'10'},
                {name:'201092708000 : กองอาคารสถานที่',code:'11'}, 
                {name:'201090600000 : วิทยาลัยการเมืองการปกครอง ',code:'12'},
                {name:'201090700000 : บัณฑิตวิทยาลัย',code:'13'},
                {name:'201090800000 : วิทยาลัยดุริยางคศิลป์',code:'14'},
                {name:'201090900000 : สำนักศึกษาทั่วไป',code:'15'},
                {name:'201091000000 : สถาบันวิจัยศิลปะและวัฒนธรรมอีสาน',code:'16'},
                {name:'201091100000 : คณะวิทยาศาสตร์ ',code:'17'}, 
                {name:'201091200000 : คณะเทคโนโลยี  ',code:'18'},
                {name:'201091300000 : คณะวิศวกรรมศาสตร์ ',code:'19'}, 
                {name:'201091400000 : คณะสถาปัตยกรรมศาสตร์ ผังเมืองและนฤมิตศิลป์ ',code:'20'},
                {name:'201091500000 : คณะวิทยาการสารสนเทศ ',code:'21'},
                {name:'201091600000 : คณะสิ่งแวดล้อมและทรัพยากรศาสตร์ ',code:'22'},
                {name:'201091700000 : สถาบันวิจัยวลัยรุกขเวช',code:'23'},
                {name:'201091800000 : คณะพยาบาลศาสตร์ ',code:'24'}, 
                {name:'201091900000 : คณะเภสัชศาสตร์ ',code:'25'},
                {name:'201092000000 : คณะสาธารณสุขศาสตร์ ',code:'26'},
                {name:'201092100000 : คณะแพทยศาสตร์ ',code:'27'}, 
                {name:'201092200000 : คณะสัตวแพทยศาสตร์และสัตวศาสตร์ ',code:'28'},
                {name:'201092300000 : โรงเรียนสาธิตมหาวิทยาลัยมหาสารคาม (ฝ่ายมัธยม)',code:'29'},
                {name:'201092400000 : โรงเรียนสาธิตมหาวิทยาลัยมหาสารคาม (ฝ่ายประถม) ',code:'30'},
                {name:'201092600000 : สำนักคอมพิวเตอร์ ',code:'31'},
                {name:'201091800000 : สำนักวิทยบริการ ',code:'32'},
                {name:'201092700000 : สำนักงานอธิการบดี ',code:'33'},
                {name:'201092701000 : กองกลาง',code:'34'},
                {name:'201092702000 : กองกิจการนิสิต',code:'35'},
                {name:'201092703000 : กองบริการการศึกษา ',code:'36'},
                {name:'201092706000 : กองคลังและพัสดุ ',code:'37'},
                {name:'201092707000 : กองทะเบียนและประมวลผล',code:'38'},
                {name:'201092709000 : กองส่งเสริมการวิจัยและบริการวิชาการ ',code:'39'},  
                {name:'201092710000 : กองประชาสัมพันธ์และกิจการต่างประเทศ ',code:'40'},
                {name:'201092709000 : กองส่งเสริมการวิจัยและบริการวิชาการ ',code:'41'},
                {name:'201092711000 : สำนักตรวจสอบภายใน ',code:'42'}, 
                {name:'201092713000 : ศูนย์วิจัยและศึกษาบรรพชีวินวิทยา ',code:'43'},
                {name:'201092800000 : คณะวัฒนธรรมศาสตร์ ',code:'44'},
                {name:'201092900000 : คณะสัตวแพทยศาสตร์ ',code:'45'},
                {name:'201093000000 : คณะนิติศาสตร์ ',code:'46'},  
            ],
            dateStart: null,
            dateEnd: null, 
            dateAnnounce: null, 
            dataP01:{}, 
            // search StaffID
            seen: false,
            listshoeusername: [],
            text_staffid: null,
            text_namefully: null,
            text_departmentid: null,
            text_departmentname: null, 
        }
    },
    async mounted(){
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES 
        await this.setSession(STAFFID,staffdepartment,groupid);
        //await this.showDatauser(); 
    },
    methods: {
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main
        },
        showDatauser(){  
            axios.post('  http://127.0.0.1:8000/api/showDatauser',{
                use_name: this.use_name,
                use_staffid: this.use_staffid,
                use_usage: this.use_usage,
                use_status: this.use_status,  
            }).then(res => {     
                 //console.log(res.data);  
                this.products_name = res.data;
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
            this. userItemEvaluaUsaege = li.id = null; 
         

            const evalua_ob = this.userItemEvaluaX.filter(f=>f.code==data.evalua)
            this.userItemEvalua = evalua_ob.length > 0 ? evalua_ob[0] : null;   
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
                    axios.post('  http://127.0.0.1:8000/api/delDateSet',{
                        data: data
                    }).then(res => { 
                        // console.log(res.data);   
                        this.showDatauser();
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
            // this.EditRegislick = true;
            this.userItemEvaluaUsaege = null; 
            this.userItemEvaluaUsaege1 = null;  
            this.userItemEvaluaUsaege2 = null;  
            this.userItemEvalua = null;
            this.dateStart = null;
            this.dateEnd = null;
            this.dateAnnounce = null; 
        },
        resetDialog(){
            this.DialogAdd = false; 
            this.DialogDetail = false; 
        },
        saveDatauser(){
             //console.log(this. userItemEvaluaUsaege.code); 
            axios.post('  http://127.0.0.1:8000/api/saveDatauser',{
                use_name: this.use_name,
                use_staffid: this.use_staffid,
                use_usage: this.use_usage,
                use_status: this.use_status,  
 
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
                this.showDatauser(); 
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

        AddDatalistUser(){    
    if(!this.text_noUse || !this.userItemfaculty || !this.userItemEvalua || !this.text_nonum){ 
        Swal.fire("ไม่มีข้อมูล", "กรุณาตรวจสอบข้อมูลให้ครบถ้วน!", "error");
        //console.log(this.text_noUse, this.userItemfaculty, this.userItemEvalua, this.text_nonum);
        return;
    }    

    this.products_listUser.push({
        ind_no: this.text_noUse,    
        ind_Items: this.userItemfaculty, // ใช้ค่าจาก Dropdown ที่ถูกต้อง
        userItemEvalua: this.userItemEvalua, 
        ind_number: Number(this.text_nonum) || 0 // แปลงเป็นตัวเลข ป้องกันข้อผิดพลาด
    }); 

    // เรียงลำดับข้อมูลตาม ind_no
    this.products_listUser.sort((a, b) => a.ind_no - b.ind_no);  

    // รีเซ็ตค่าหลังจากบันทึก
    this.text_noUse = null;
    this.userItemfaculty = null;
    this.userItemEvalua = null;
    this.text_nonum = null;
},


        async searchUserStaffid(){  
            try { 
                if(this.text_noUse.length > 5){
                    const res = await axios.get('  http://127.0.0.1:8000/api/searchDataStaff', {  
                        params: {
                            staffid: this.text_noUse
                        }
                    }); 
                    //console.log(res.data); 
                    this.seen = true;
                    this.listshoeusername=res.data 

                }
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        }, 
        nameUserclick(data){  
            this.seen = false; 
            this.text_noUse = data.staffid+' : '+data.namefully;
            // this.text_Saveno = data.departmentname+' : '+data.departmentid; 
            this.text_staffid = data.staffid;
            this.text_namefully = data.namefully;
            this.text_departmentid = data.departmentid;
            this.text_departmentname = data.departmentname;
        },

        //บันทึกการจัดการสิทธิ์
        saveDataxEditDataUser() {   
            let updatedItem = {
                ind_no: this.text_noUse,
                ind_Items: this.text_Saveno,
                userItemEvalua: this.userItemEvalua, 
                ind_number: this.text_nonum  
            };

            // ค้นหาข้อมูลใน products_listUser และอัพเดต
            const index = this.products_listUser.findIndex(item => item.ind_no === this.text_noUse);
            
            if (index !== -1) {
                this.products_listUser[index] = updatedItem; // อัพเดตข้อมูลที่มีอยู่แล้ว
            }   

            // เรียงลำดับตาม ind_no
            this.products_listUser.sort((a, b) => a.ind_no - b.ind_no);

            // อัพเดต products_name ให้แสดงข้อมูล
            this.products_name = [...this.products_listUser];

            // แสดงแจ้งเตือนว่าบันทึกสำเร็จ
            Swal.fire({
                icon: 'success',
                title: 'บันทึกข้อมูลสำเร็จ!',
                text: 'ข้อมูลได้รับการอัพเดตเรียบร้อยแล้ว',
                confirmButtonText: 'ตกลง'
            }).then(() => {
                // ปิด Dialog หลังจากกดตกลง
                //this.DialogAdd = false; 
                // เคลียร์ฟอร์มหลังจากบันทึก
                this.text_noUse = '';
                this.text_Saveno = '';
                this.userItemEvalua = null;
                this.text_nonum = '';
            });
            this.DialogAdd = false; 
        },

        DeleteRegislickUser(data){
            this.products_listUser = this.products_listUser.filter(product => product.ind_no !== data); 
        },
        cancelDialog(){
            this.DialogAdd = false;
            // this.DialogEditList = false;
            this.cancelDialogEdit = false; 
        },
        
         // แก้ไขสิทธิ์การใช้งาน 
         EditRegislick(data) {
            // เคลียร์ค่าการค้นหาก่อน
            this.text_search_noEdit = null;
            this.text_searchEdit = null;

            if (data) {
                this.DialogEditList = true;  
                this.text_search_noEdit = data.ind_no;
                this.text_searchEdit = data.ind_Items; 
            } 

            // ปิด DialogAdd และเคลียร์ฟอร์มca
            this.DialogAdd = false;  
            this.text_noUse = '';
            this.text_SavenoEdt = '';
            this.userItemEvalua = null;
            this.text_nonumEdt = '';
        }

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
    #country-list{float:left;list-style:none;margin-top:-3px;padding:0;width:25%;position: absolute; z-index:9999 !important;}
	#country-list li{padding: 10px; background: #f0f0f0; border-bottom: #bbb9b9 1px solid;}
	#country-list li:hover{background:#ece3d2;cursor: pointer;}
</style>