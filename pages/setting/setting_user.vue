    <template>
        <div class="grid">
            <div class="col-12 lg:col-12 xl:col-12">
                <div class="card mb-0">  
                    <div class="formgroup-inline mb-1"> 
                        <div class="col md:col-6">  
                            <h3 class="mb-4 card-header"><i class="pi pi-id-card" style="font-size: x-large;"></i> จัดการ สิทธิ์การเข้าใช้งาน</h3>
                        </div> 
                        <!-- {{ user.user }} --> 
                        <br> 
                        <div class="col md:col-16 text-right">  
                            <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มสิทธิ์การใช้งาน" @click="OpenDialogAdd" /> 
                            <!-- เพิ่มข้อมูลรอบประเมิน --> 
                            <Dialog  v-model:visible="DialogAdd"  :breakpoints="{ '960px': '75vw' }"  :style="{ width: '70vw' }"  :modal="true"  position="top"> 
                            <template #header>
                                <span>
                                    <b>เพิ่มสิทธิ์การใช้งาน</b>&nbsp;&nbsp;
                                <span style="color: red;">
                                    <b>(กรุณาตรวจสอบรายชื่อให้ถูกต้องก่อนกดบันทึกทุกครั้ง)</b>
                                </span>
                                </span>
                            </template>
                                <form>
                                    <InputText v-model="text_edt" type="hidden" />  
                                    <div class="p-fluid formgrid grid"> 
                                        <div class="field col-12 md:col-4">
                                            <label for="text_user1">ชื่อ</label> 
                                            <InputGroup>
                                                <InputGroupAddon>
                                                    <i class="pi pi-user"></i>
                                                </InputGroupAddon>
                                                <InputText v-model="text_user1" type="text" placeholder="ชื่อ" autocomplete="off" @keyup="searchUserStaffid1" />  
                                            </InputGroup> 
                                            <span v-if="seen">
                                                <ul id="country-list">
                                                    <li v-for="(li) in listshoeusername1" :key="li.id" @click="nameUserclick1(li)">{{li.staffid}} : {{li.namefully}}</li>
                                                </ul>
                                            </span>
                                            <input type="hidden" v-model="text_namefullyuse1"> 
                                            <input type="hidden" v-model="text_staffuse1"> 
                                            <input type="hidden" v-model="text_positionuse1"> 
                                            <input type="hidden" v-model="text_departmentnameuse1"> 
                                            <input type="hidden" v-model="text_departmentiduse1"> 
                                            

                                        </div> 
                                        <div class="field col-12 md:col-4">
                                            <label for="text_user2">คณะ/หน่วยงาน</label>
                                            <InputGroup>
                                                <InputGroupAddon>
                                                    <i class="pi pi-building"></i>
                                                </InputGroupAddon>
                                                <InputText v-model="text_departmentiduseid" type="text" placeholder="คณะ/หน่วยงาน" autocomplete="off" @keyup="searchUserStaffid1" />   
                                            </InputGroup>  
                                        </div> 
                                        <div class="field col-12 md:col-4">
                                            <label for="Usage_text">สถานะ/สิทธิ์การเข้าใช้งาน</label> 
                                            <Dropdown id="Usage_text" v-model="dropdownItemUsage" :options="dropdownItemsUsage" optionLabel="name" placeholder="เลือกสิิทธิ์การใช้งาน"></Dropdown>  
                                        </div>  
                                    </div>  
                                </form>
                                <template #footer>
                                    <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataset" /> 
                                    <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                                </template>
                            </Dialog>  
                        </div> 
                    </div>   
                    <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                        <!-- <Column field="Tb_name" header="ชื่อ" style="width: 25%; text-align: center;">
                            <template #body="">  
                                <div style="display: flex; justify-content: center; align-items: center;">
                                    <b>{{ user.user.name.SCOPES?.staffdepartmentname }}</b>
                                </div>
                            </template>
                        </Column> -->
                        <Column field="Tb_name" header="ชื่อ" style="width: 25%; text-align: center;">
                            <template #body="Item">  
                                <div style="display: flex; justify-content: center; align-items: center;">
                                    <b>{{ Item.data.name_use }}</b> 
                                </div>
                            </template>
                        </Column>
                        <Column field="Tb_name" header="คณะ/หน่วยงาน" style="width: 25%; text-align: center;">
                            <template #body="Item">  
                                <div style="display: flex; justify-content: center; align-items: center;">
                                    <b>{{ Item.data.name_fac }}</b>
                                </div>
                            </template>
                        </Column>
                        <Column field="Tb_ind" header="สถานะ/สิทธิ์การเข้าใช้งาน" style="width: 25%; text-align: center;">
                            <template #body="Item">   
                                <div style="display: flex; justify-content: center; align-items: center;">
                                    <b>{{ Item.data.status_name }}</b>
                                </div>
                            </template> 
                        </Column> 
                        <Column field="options" header="ตัวเลือก"  headerStyle="text-align: center;"  bodyStyle="text-align: center;">
                        <template #body="Item">   
                            <div style="display: flex; justify-content: center; align-items: center; gap: 5px;"> 
                                <Button icon="pi pi-pencil" severity="success" class="p-button-sm" @click="editData(Item.data)" />
                                <Button icon="pi pi-trash" severity="danger" class="p-button-sm" @click="delData(Item.data)" />  
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
                dropdownItemUsage: null,
                dropdownItemsUsage: [
                    { name: 'เจ้าหน้าที่บุคคล', code: 2 },
                    { name: 'ผู้บริหาร', code: 3 },
                    { name: 'ผู้บังคับบัญชาเหนือขึ้นไป', code: 4 }, 
                ],
                
                // dateStart: null,
                // dateEnd: null, 
                // dateAnnounce: null, 
                dataP01:{}, 
                // คนที่ 1
                seen: false,
                text_user1: null,
                listshoeusername1: null,
                text_staffuse1: null,
                text_positionuse1: null,
                text_namefullyuse1 : null,
                text_departmentnameuse1 : null,
                text_departmentiduse1 : null,  
                
            }
        },
        async mounted(){
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession();
        // console.log(user.user.name);
            const {STAFFID, SCOPES} = user.user.name
            const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
            
            await this.setSession(STAFFID,staffdepartment,groupid);
            await this.showDataSetUser(STAFFID,staffdepartment,groupid); 
        },
        methods: {
            setSession (staffid_Main,facid_Main,groupid_Main) {
            // console.log('setSession');  
                this.staffid_Main = staffid_Main
                this.facid_Main = facid_Main
                this.groupid_Main = groupid_Main
            },
            showDataSetUser(){  
                axios.post(' http://127.0.0.1:8000/api/showDateSetUser', { 
                    facid_Main: this.facid_Main,
                    groupid_Main: this.groupid_Main,
                })
                .then(response => {
                    // console.log(response); 
                    this.products_date = response.data; // เก็บข้อมูลที่ได้มาใน property dataSet
                })
                .catch(error => {
                    console.error('Error fetching data:', error); // แสดงข้อผิดพลาดหากมี
                });
            }, 
           

            editData(data){ 
                // console.log('data.name_use:', data.name_use);   
                this.DialogAdd = true;  
                this.text_edt = data.id;  
                const Usage_ob = this.dropdownItemsUsage.filter(f=>f.code==data.status_user)
                this.dropdownItemUsage = Usage_ob.length > 0 ? Usage_ob[0] : null;  
                this.text_user1 = data.staffid+' : '+data.name_use; 
                this.text_staffuse1 = data.staffid; 
                this.text_positionuse1 = data.name_posit; 
                this.text_namefullyuse1 = data.name_use; 
                this.text_departmentnameuse1 = data.name_fac; 
                this.text_departmentiduse1 = data.fac_id;    
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
                        axios.post(' http://127.0.0.1:8000/api/deleteDateSetUser',{
                            data: data
                        }).then(res => { 
                            //console.log(res.data);   
                            this.showDataSetUser();
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
                this.dropdownItemUsage = null; 
                this.dropdownItemEvalua = null;
                this.seen = false; 
                this.text_user1 = '';  // รีเซ็ตชื่อ
                this.text_namefullyuse1 = '';  // รีเซ็ตชื่อ
                this.text_staffuse1 = '';  // รีเซ็ตรหัสเจ้าหน้าที่
                this.text_positionuse1 = '';  // รีเซ็ตตำแหน่ง
                this.text_departmentnameuse1 = '';  // รีเซ็ตชื่อหน่วยงาน
                this.text_departmentiduse1 = '';  // รีเซ็ตรหัสหน่วยงาน 
            },
            resetDialog(){
                this.DialogAdd = false; 
                this.DialogDetail = false; 
            },
            saveDataset() {
                // console.log({
                //     text_edt: this.text_edt,
                //     Usage_code: this.dropdownItemUsage.code,
                //     Usage_text: this.dropdownItemUsage.name,
                //     text_staffuse1: this.text_staffuse1,
                //     text_positionuse1: this.text_positionuse1,
                //     text_namefullyuse1: this.text_namefullyuse1, 
                //     text_departmentnameuse1: this.text_departmentnameuse1,
                //     text_departmentiduse1: this.text_departmentiduse1,
                // });

                axios.post(' http://127.0.0.1:8000/api/saveDateSetUser', {  
                    text_edt: this.text_edt,
                    Usage_code: this.dropdownItemUsage.code,
                    Usage_text: this.dropdownItemUsage.name,
                    text_staffuse1: this.text_staffuse1,
                    text_positionuse1: this.text_positionuse1,
                    text_namefullyuse1: this.text_namefullyuse1, 
                    text_departmentnameuse1: this.text_departmentnameuse1,
                    text_departmentiduse1: this.text_departmentiduse1,
                })
                .then(res => {     
                    Swal.fire({
                        position: "top-center",
                        icon: "success",
                        title: "บันทึกเรียบร้อยแล้ว !",
                        showConfirmButton: false,
                        timer: 1500
                    });
                    this.DialogAdd = false;  
                    this.showDataSetUser(); 
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
                        this.text_staffuse1 = null;
                        this.text_positionuse1 = null;
                        this.text_namefullyuse1 = null;
                        this.text_departmentnameuse1 =null;
                        this.text_departmentiduse1 =null; 
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
                console.log('nameUserclick1: ',data);
                this.seen = false; 
                this.text_user1 = data.staffid+' : '+data.namefully; 
                this.text_departmentiduseid = data.departmentid+' : '+data.departmentname;  
                this.text_staffuse1 = data.staffid;
                this.text_positionuse1 = data.posnameth;
                this.text_namefullyuse1 = data.namefully;
                this.text_departmentnameuse1 =data.departmentname;
                this.text_departmentiduse1 = data.departmentid;
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