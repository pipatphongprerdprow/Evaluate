<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header"><i class="pi pi-id-card" style="font-size: x-large;"></i> จัดการ สิทธิ์การเข้าใช้งาน</h3>
                    </div>
                    <!-- {{ user.user.name }} -->
                    <br>
                    <div class="col md:col-16 text-right">
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มสิทธิ์การใช้งาน" @click="OpenDialogAdd" />
                        <Dialog v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
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
                                <input type="hidden" v-model="text_iduse1"> <div class="p-fluid formgrid grid">
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
                                        <input type="text" v-model="text_namefullyuse1">
                                        <input type="text" v-model="text_staffuse1">
                                        <input type="text" v-model="text_positionuse1">
                                        <input type="text" v-model="text_departmentnameuse1">
                                        <input type="text" v-model="text_departmentiduse1">
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="text_user2">คณะ/หน่วยงานที่ประเมิน</label>
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
                    <Column field="options" header="ตัวเลือก" headerStyle="text-align: center;" bodyStyle="text-align: center;">
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
</script>

<script>
import { ref } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2'
import P01 from "./pages/setting/setting_assessment.vue"; // ตรวจสอบ path นี้ว่าถูกต้อง

export default {
    components : {
        P01
    },
    data() {
        return {
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '01',
            staffdepartmentname: '',
            products_date: [],
            // Dialog
            DialogAdd: false,
            DialogDetail: false, // ตัวนี้ดูเหมือนไม่ได้ใช้
            text_edt: null,
            dropdownItemUsage: null,
            dropdownItemsUsage: [
                //{ name: 'เจ้าหน้าที่บุคคล', code: 2 },
                { name: 'ผู้บริหาร', code: 3 },
                { name: 'ผู้บังคับบัญชาเหนือขึ้นไป', code: 4 },
            ],

            // dataP01:{}, // ตัวนี้ดูเหมือนไม่ได้ใช้
            // คนที่ 1
            seen: false,
            text_user1: null,
            listshoeusername1: null,
            text_staffuse1: null,
            text_positionuse1: null,
            text_namefullyuse1 : null,
            text_departmentnameuse1 : null,
            text_departmentiduse1 : null,
            text_departmentiduseid: null, // เพิ่มตัวนี้เข้ามาสำหรับช่องคณะ/หน่วยงานในฟอร์ม
            text_iduse1: null, // *** เพิ่มตัวแปรนี้เพื่อเก็บ ID ของผู้ใช้ที่เลือกจากการค้นหา ***
        }
    },
    async mounted(){
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();

        const {STAFFID, SCOPES} = user.user.name  
        const {staffdepartment, groupid, staffdepartmentname} = SCOPES // ไม่ได้ใช้ staffdepartmentname, groupname ใน setSession หรือ showDataSetUser

        await this.setSession(STAFFID,staffdepartment,groupid, staffdepartmentname);
        await this.showDataSetUser(); // ไม่ต้องส่ง parameter เพราะฟังก์ชัน showDataSetUser ใน PHP ไม่ได้รับแล้ว
    },
    methods: {
        setSession (staffid_Main,facid_Main,groupid_Main, staffdepartmentname) {
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main
            this.staffdepartmentname = staffdepartmentname
        },
        showDataSetUser(){
            axios.post('http://127.0.0.1:8000/api/showDateSetUser', {
                // ไม่ต้องส่ง facid_Main, groupid_Main ไปแล้ว หาก backend ไม่ได้ใช้ filter
                facid_Main: this.facid_Main,
                groupid_Main: this.groupid_Main,
            })
            .then(response => {
                this.products_date = response.data;
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },

        editData(data){
            this.DialogAdd = true;
            this.text_edt = data.id; // ใช้ ID นี้ในการอัปเดตข้อมูล
            const Usage_ob = this.dropdownItemsUsage.filter(f=>f.code==data.status_user)
            this.dropdownItemUsage = Usage_ob.length > 0 ? Usage_ob[0] : null;
            this.text_user1 = data.staffid+' : '+data.name_use;
            this.text_departmentiduseid = data.fac_id+' : '+data.name_fac; // แสดงคณะ/หน่วยงาน
            this.text_staffuse1 = data.staffid;
            this.text_positionuse1 = data.name_posit;
            this.text_namefullyuse1 = data.name_use;
            this.text_departmentnameuse1 = data.name_fac;
            this.text_departmentiduse1 = data.fac_id;
            this.text_iduse1 = data.id; // *** ตั้งค่า ID จากข้อมูลที่เลือกมาแก้ไขด้วย ***
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
                    axios.post('http://127.0.0.1:8000/api/deleteDateSetUser',{
                        data: data
                    }).then(res => {
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
            this.text_edt = null; // รีเซ็ต ID การแก้ไข
            this.dropdownItemUsage = null;
            // this.dropdownItemEvalua = null; // ถ้าไม่ได้ใช้ก็ลบทิ้งได้
            this.seen = false;
            this.text_user1 = '';
            this.text_namefullyuse1 = '';
            this.text_staffuse1 = '';
            this.text_positionuse1 = '';
            this.text_departmentnameuse1 = '';
            this.text_departmentiduse1 = '';
            this.text_departmentiduseid = ''; // *** รีเซ็ตช่องคณะ/หน่วยงานในฟอร์ม ***
            this.text_iduse1 = null; // *** รีเซ็ต ID ของผู้ใช้ที่เลือกจากการค้นหา ***
        },
        resetDialog(){
            this.DialogAdd = false;
            this.DialogDetail = false;
        },
        saveDataset() {
            // console.log สำหรับตรวจสอบค่าก่อนส่ง
            // console.log({
            //     text_edt: this.text_edt, // มีค่าเมื่อกดแก้ไข
            //     user_id_from_search: this.text_iduse1, // ID ของผู้ใช้ที่ได้จากการค้นหา
            //     Usage_code: this.dropdownItemUsage?.code, // ใช้ ?. เพื่อป้องกัน error ถ้า dropdownItemUsage เป็น null
            //     Usage_text: this.dropdownItemUsage?.name,
            //     text_staffuse1: this.text_staffuse1,
            //     text_positionuse1: this.text_positionuse1,
            //     text_namefullyuse1: this.text_namefullyuse1,
            //     text_departmentnameuse1: this.text_departmentnameuse1,
            //     text_departmentiduse1: this.text_departmentiduse1,
            // });

            axios.post('http://127.0.0.1:8000/api/saveDateSetUser', {
                text_edt: this.text_edt,
                user_id_from_search: this.text_iduse1, // ส่ง ID ของผู้ใช้ที่เลือกจากการค้นหาไปด้วย
                Usage_code: this.dropdownItemUsage ? this.dropdownItemUsage.code : null, // ตรวจสอบ null
                Usage_text: this.dropdownItemUsage ? this.dropdownItemUsage.name : null, // ตรวจสอบ null
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
                this.showDataSetUser(); // รีเฟรชข้อมูลในตารางหลังจากบันทึก/อัปเดต
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    position: "top-center",
                    icon: "error",
                    title: "เกิดข้อผิดพลาดในการบันทึก!",
                    text: error.message || "โปรดลองอีกครั้ง",
                    showConfirmButton: true,
                });
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
                // รีเซ็ตค่าเมื่อความยาวลดลง
                if (this.previousName && this.text_user1.length < this.previousName.length) {
                    this.text_staffuse1 = null;
                    this.text_positionuse1 = null;
                    this.text_namefullyuse1 = null;
                    this.text_departmentnameuse1 =null;
                    this.text_departmentiduse1 =null;
                    this.text_departmentiduseid = null; // รีเซ็ตช่องคณะ/หน่วยงาน
                    this.text_iduse1 = null; // *** รีเซ็ต ID ผู้ใช้ที่เลือกจากการค้นหา ***
                }

                if(this.text_user1.length > 3){
                    const res = await axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                        params: {
                            staffid: this.text_user1
                        }
                    });
                    this.seen = true;
                    this.listshoeusername1=res.data
                } else { // ถ้า text_user1 สั้นกว่า 4 ตัวอักษร ให้ซ่อนรายการค้นหา
                    this.seen = false;
                    this.listshoeusername1 = null;
                }
                this.previousName = this.text_user1;
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
                this.seen = false; // ซ่อนรายการเมื่อเกิดข้อผิดพลาด
                this.listshoeusername1 = null;
            }
        },
        nameUserclick1(data){
            console.log('User selected:',data); // ตรวจสอบข้อมูลที่ได้จากการเลือก
            this.seen = false;
            this.text_user1 = data.staffid+' : '+data.namefully; 
            this.text_staffuse1 = data.staffid;
            this.text_positionuse1 = data.posnameth;
            this.text_namefullyuse1 = data.namefully;

            console.log('Matched departmentid starting with 927',this.facid_Main,this.staffdepartmentname); // ตรวจสอบค่าที่ได้จาก user session

                this.text_departmentnameuse1 = this.staffdepartmentname;
                this.text_departmentiduse1 = this.facid_Main;
                this.text_departmentiduseid = this.facid_Main+' : '+this.staffdepartmentname; 

            // const subSrtDepar = data.departmentid.substring(4, 7); 
            // console.log('subSrtDepar:', subSrtDepar); // ตรวจสอบค่าที่ได้จากการตัดสตริง 
            // if (subSrtDepar === "927") {
            //     console.log('Matched departmentid starting with 927');
            //     console.log('Matched departmentid starting with 927'.user.user.staffdepartment);
                
            //     this.text_departmentnameuse1 = data.departmentname;
            //     this.text_departmentiduse1 = data.departmentid;
            //     this.text_departmentiduseid = data.departmentid+' : '+data.departmentname; 
            // } else {
            //     console.log('Other facultyid',data.facultyid);
                
            //     this.text_departmentnameuse1 = data.facultyname;
            //     this.text_departmentiduse1 = data.facultyid;
            //     this.text_departmentiduseid = data.facultyid+' : '+data.facultyname; 
            // }

            // this.text_iduse1 = data.id; // *** เก็บ ID ของผู้ใช้ที่เลือกจากผลการค้นหา ***
        },
    }

}
</script>

<style>
.card-header {
    text-align: left;
    margin: 0;
    padding: 0;
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
#country-list{
    float:left;
    list-style:none;
    margin-top:-3px;
    padding:0;
    width:calc(33.33% - 1.5rem); /* ปรับความกว้างให้ตรงกับ col-4 และมีระยะห่าง */
    position: absolute;
    z-index:9999 !important;
    background: #f0f0f0; /* เพิ่มพื้นหลัง */
    border: 1px solid #ccc; /* เพิ่มเส้นขอบ */
    max-height: 200px; /* จำกัดความสูง */
    overflow-y: auto; /* เพิ่ม scrollbar ถ้าข้อมูลเยอะ */
    box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* เพิ่มเงา */
}
#country-list li{
    padding: 10px;
    border-bottom: #bbb9b9 1px solid;
    cursor: pointer;
}
#country-list li:last-child {
    border-bottom: none; /* ลบเส้นขอบล่างของรายการสุดท้าย */
}
#country-list li:hover{
    background:#ece3d2;
}
</style>