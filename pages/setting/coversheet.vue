<template>   
    <div v-if="user.user" class="grid">
        <div  class="col-12 lg:col-12 xl:col-12"> 
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">   
                        <h5 class="mb-4" style="text-align: left;margin-right: 16px;margin-bottom: 0px;">
                            <i class="" style="font-size: x-large"></i> สังกัด: {{ user.user.name.SCOPES?.staffdepartmentname }} 
                        </h5>  
                        <small style="color: red;font-size: larger;">* กรุณาเลือกรอบประเมิน เพื่อทำแบบประเมิน</small>
                    </div>   
                    <!-- {{ product_date.d_evaluationround}} {{ product_date.d_date}} -->
                    <div class="col md:col-6">  
                        <label for="product_date"></label>
                        <Dropdown  id="product_date" 
                            v-model="product_date" 
                            :options="products_date"  autoFilterFocus
                            :optionLabel="(item) => `${item.d_evaluationround} ${item.d_date}`"
                            placeholder="กรุณาเลือกรอบการประเมิน" 
                            style="max-width: 500px;width: 100%;border: outset;" 
                            @change="showdatator" 
                        >
                        </Dropdown>
                    </div>
                </div> 
            </div>
        </div>  
    </div>   
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="formgroup-inline mb-1">
                <div class="d-flex align-items-center">
                    <!-- <h3 class="mb-4 card-header">
                          <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป01
                      </h3>   -->
                </div>
            </div>
            <!-- แสดงข้อมูลบันทึก -->
            <!-- {{ user.user }}  -->  
            <TabView :activeIndex="activeIndex" @tabChange="onTabChange">
                <!-- <TabView @click="xyz"> -->
                <TabPanel header="แบบ ใบปะหน้า" value="0">
                    <div class="col md:col-12 text-right">
                        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP01"></Button>
                    </div> 
                    <div v-if="user.user" class="card"> 
                        <div style="display: flex; justify-content: center">
                            <img src="~/assets/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
                        </div>
                        <h4 style="text-align: center">แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) <br>ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม</h4>
                        <br /> 
                        <!-- ตาราง ก. สมรรถนะหลัก -->
                        <div class="employee-info">
                            <p><strong>ผู้ปฏิบัติงาน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}</p>
                            <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }}</p>
                            <p><strong>ตำแหน่ง:</strong>{{ user.user.name.POSITIONNAME }}</p>
                            <!-- <p><strong>ระดับตำแหน่ง:</strong>{{ user.user.name.POSTYPENAME }}</p> -->
                            <p><strong>ระดับตำแหน่ง:</strong>{{ user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME }}</p> 
                            <!-- <p><strong>ประเภทบุคลากร:</strong></p> --> 
                            <p><strong>ชื่อผู้ประเมิน:</strong> <InputText type="text" placeholder="ชื่อผู้ประเมิน"  v-model="assessor" style="width: 300px;"/></p> 
                            <p><strong>ตำแหน่งผู้ประเมิน :</strong> <InputText type="text" placeholder="ตำแหน่งผู้ประเมิน" v-model="assessor_position" style="width: 265px;" /></p> 
                            <p><strong>รายละเอียดข้อตกลง ระหว่าง วันที่ : </strong> {{ product_date.d_evaluationround }}  {{ product_date.d_date }}</p>
                        </div><br> 
                            <div class="ml-4 mr-4" style="text-align: center;">
                                <label for="dropdownProportion"><b>สัดส่วน :</b></label>
                                <Dropdown id="dropdownProportions" v-model="dropdownProportion" :options="dropdownProportions" optionLabel="name" placeholder="เลือกสัดส่วน"></Dropdown>
                            </div><br>
                                <div class="ml-4 mr-4" style="text-align: center;">
                                    <Button icon="pi pi-save" severity="primary" class="mb-2 mr-2" label="บันทึกแบบข้อตกลงภาระงาน" @click="saveDatator" />  
                                </div>   
                        <div class="explanation">
                            <h4>คำชี้แจง</h4>
                            <p>
                                1. แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามนี้ เป็นการกำหนด แผนการปฏิบัติงานของผู้ปฏิบัติงานในมหาวิทยาลัยมหาสารคาม
                                ซึ่งเป็นข้อตกลงร่วมกับผู้บังคับบัญชาก่อนเริ่มปฏิบัติงาน
                            </p>
                            <p>
                                2. การกำหนดข้อตกลงร่วม ผู้ปฏิบัติงานจะต้องกรอกรายละเอียดภาระงานโดยสังเขปในส่วนของภาระงานตามหน้าที่ความรับผิดชอบของตำแหน่ง และ/หรือภาระงาน ด้านอื่นๆ พร้อมกำหนดตัวชี้วัดความสำเร็จของภาระงานแต่ละรายการ ตลอดจนค่าเป้าหมาย
                                และค่านำหนักร้อยละ สำหรับในส่วนของพฤติกรรมการปฏิบัติราชการ (สมรรถนะ) ให้ระบุระดับสมรรถนะค่ามาตรฐาน
                            </p>
                            <p>3. สำหรับการกรอกรายละเอียดภาระเอียดภาระงานตามภารกิจ ให้อ้างอิงการคำนวณภาระงานขั้นต่ำตามหลักเกณฑ์กรอบมาตรฐานภาระงานที่แนบท้ายประกาศ ก.บ.ม. มหาวิทยาลัยมหาสารคาม ที่บังคับใช้สำหรับการประเมินผลการปฏิบัติราชการ</p>
                            <p>4. การกำหนดตัวชี้วัดความสำเร็จของงาน ทั้งในส่วนของเชิงปริมาณและเชิงคุณภาพ ให้เป็นการกำหนดข้อตกลงภายในหน่วยงานนั้นๆ</p>
                            <p>5. การจัดทำข้อตกลงภาระงานดังกล่าวนี้ เพื่อใช้เป็นกรอบในการประเมินผลการปฏิบัติราชการ เพื่อประกอบการเลื่อนเงินเดือนและค่าจ้างในแต่ละรอบการประเมิน</p>
                        </div>
                    </div>
                </TabPanel> 
                <TabPanel header="แบบ ป01" value="1">
                    <Por01 :dataPor="product_date"></Por01>
                    <!-- รอข้อมูล -->
                </TabPanel>

                <TabPanel header="แบบ ป02" value="2">
                    <Por02 :dataPor="product_date" :tab2Reload="por02key"></Por02>
                    <!-- รอข้อมูล -->
                </TabPanel>

                <TabPanel header="แบบ ป03" value="3">
                    <Por03 :dataPor="product_date" :tab3Reload="por03key"></Por03> 
                    <!-- รอข้อมูล -->
                </TabPanel> 
                <TabPanel header="แบบ ป04" value="4">
                    <Por04 :dataPor="product_date" :tab4Reload="por04key"></Por04>
                    <!-- รอข้อมูล -->
                </TabPanel>
            </TabView>
        </div>
    </div>
</template>

<script setup>
const { signIn, getSession, signOut } = await useAuth();
const user = await getSession();
// console.log(user);
</script> 

<script>
import { ref } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import Por01 from './pages/setting/por_01.vue';
import Por02 from './pages/setting/por02.vue';
import Por03 from './pages/setting/por03.vue';
import Por04 from './pages/setting/por04.vue';

export default {
    components: {
        Por01,
        Por02,
        Por03,
        Por04
    },
    name: 'ContractDetails',
    data() {
        return { 
           
            p01x: '',
            xxx: '2',
            por02key: 0,
            por03key: 0,
            por04key: 0,
            // Anurak
            activeIndex: 0,
//----------------------------
            dataStaffid: null,
            staffid_Main: '',
            staffid_name: '',
            year_Main: '',
            facid_Main: '',
            pos_id: '',
            postype_id: '',
            evalua: '',
            groupid_Main: '01',  
            dataP01: {},
            user: {
                user: {
                    name: {
                            PREFIXFULLNAME: '',
                            STAFFNAME: '',
                            STAFFSURNAME: '',
                            SCOPES: {
                            staffdepartmentname: ''
                            },
                            POSITIONNAME: '',
                            POSTYPENAME: ''
                        }
                    }
            },
            product_date: {
                d_evaluationround: '', 
            },  
            assessor: null,
            assessor_position: null,
            currenttap: 0, 
            // product_date: {
            //     about: 1 ,
            //     d_date : 2569,
            //     d_enddate: "2025-02-28",
            //     d_evaluationround: "รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28/29 กุมภาพันธ์ พ.ศ. 2569",
            //     d_recordingday :  "2024-09-01",
            //     d_scoringday : "2025-03-31",
            //     dateAdd:"2024-09-20 06:39:06",
            //     evalua : 1,
            //     fac_id : "201092704000",
            //     id : 22,
            // },
            //product_date: '',
            products_date: [], 
            dropdownProportion: null,
            dropdownProportions: [
                { name: 'สัดส่วน 50:50', value: '50:50' },
                { name: 'สัดส่วน 70:30', value: '70:30' },
                
            ],
            dropdownItemYear: { name: 'ปีงบประมาณ 2568', value: 2569},
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', value: 2569 },
                { name: 'ปีงบประมาณ 2568', value: 2568 },
                { name: 'ปีงบประมาณ 2567', value: 2567 },
                { name: 'ปีงบประมาณ 2566', value: 2566 }
            ],
            //ตารางรายชื่อ
            // products:[],
            // evaluator: null, // ชื่อ
            // evaluator_val: null, //รหัสประจำตัว
            // show_evaluator: false, //โชว์
            // userevaluator: [] //ลูปชื่อ
            
        };
    },
    async mounted() {
        const { signIn, getSession, signOut } = await useAuth();
        const user = await getSession();
        //console.log(user);
        
        const { STAFFID, SCOPES } = user.user.name;
        const { staffdepartment, groupid, staffdepartmentname, groupname } = SCOPES; 

        await this.setSession(STAFFID, staffdepartment, groupid ,user);
        await this.showDataSet(STAFFID, staffdepartment, groupid);
        //this.showDataEvalu();   
    }, 
    methods: { 
        setSession(staffid_Main, facid_Main, groupid_Main ,user) {
            // console.log('user: ',user.user.name);
            this.staffid_Main = staffid_Main;
            this.facid_Main = facid_Main;
            this.groupid_Main = groupid_Main;
            this.staffid_name = user.user.name.PREFIXFULLNAME+user.user.name.STAFFNAME+" "+user.user.name.STAFFSURNAME ;
            this.pos_id = user.user.name.POSID ;
            this.postype_id = user.user.name.POSTYPEID ;
        },
        por01Data(data) {
            //console.log('data: ',data);
            this.dataP01 = {
                staffid: this.staffid_Main,
                year: data.d_date,
                evalua: data.evalua,
                d_evaluationround: data.d_evaluationround,
                staffdepartment: this.facid_Main
            };
        },
        showDataSet() {
            axios.post(' https://survey.msu.ac.th/evaluatebackend/api/showDateSet', {
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main 
            })
            .then((res) => {
                // console.log(res.data); 
                this.products_date = res.data;
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }, 
        saveDatator() {
            //console.log(res.data); 
            if(this.product_date.d_date == null || this.product_date.d_date == undefined){
                Swal.fire("error","กรุณาเลือก รอบการประเมิน ก่อน","error"); 
            }else{
                if (!this.assessor) {
                    Swal.fire("error","กรุณากรอกชื่อผู้ประเมินให้ครบถ้วน","error");
                }else if(!this.assessor_position){
                    Swal.fire("error","กรุณากรอกชื่อและตำแหน่งผู้ประเมินให้ครบถ้วน","error");
                }else if(this.dropdownProportion == null || this.dropdownProportion == undefined){
                    Swal.fire("error","กรุณาเลือก สัดส่วน","error");
                }else{
                    const formData = {
                        p_year: this.product_date.d_date,
                        evalua: this.product_date.evalua,
                        p_staffid: this.staffid_Main,
                        // p_staffid: this.staffid_Main,
                        staffid_name: this.staffid_name,
                        pos_id: this.pos_id,
                        postype_id: this.postype_id,
                        fac_id: this.facid_Main,
                        dropdownProportion: this.dropdownProportion.value,
                        assessor: this.assessor,
                        assessor_position: this. assessor_position
                    }; 

                    axios.post(' https://survey.msu.ac.th/evaluatebackend/api/saveDatator', 
                        formData
                    ).then(response => { 
                        this.DialogScore = false; 
                        // console.log('showDataP03',res.data);

                        // const data = res.data[0].persen.splin(":"); // 70:30
                        // const persen0 = data[0]; // ค่าข้างหน้า = 70
                        // const persen1 = data[1]; // ค่าข้างหลัง = 30 
                        Swal.fire({
                            position: "top-end",
                            icon: "success",
                            title: "บันทึกข้อตกลงภาระงานเรียบร้อย",
                            showConfirmButton: false,
                            timer: 1500
                        });
                    })
                    .catch(error => {
                        console.error('Error saving data:', error);
                        Swal.fire("error", "การบันทึกข้อมูลล้มเหลว", "error");
                    });  
                }   
            } 
        },
        showdatator() { 
            axios.post(' https://survey.msu.ac.th/evaluatebackend/api/showdatator', {
                p_year: this.product_date.d_date,
                evalua: this.product_date.evalua,
                p_staffid: this.staffid_Main
            })
            .then(response => {
                // console.log('Response',response.data);  
                const dataSet = response.data[0];
                this.assessor = dataSet.assessor;
                this.assessor_position = dataSet.assessor_position; 

                const persen = this.dropdownProportions.filter(f=>f.value==dataSet.persen)
                this.dropdownProportion = persen.length > 0 ? persen[0] : null;  
            })
            .catch(error => {
               // console.error('Error fetching data:', error);
            });
        },   
        // Anurak
        onTabChange(event) { 
             //console.log(event.index);
            if(this.product_date.d_date == null || this.product_date.d_date == undefined){
                Swal.fire("error","กรุณาเลือก รอบการประเมิน ก่อน !","error"); 
            }else{
                if(event.index==2) {   
                    this.por02key++; 
                }else if(event.index==3) {   
                    this.por03key++; 
                }else if(event.index==4) {   
                    this.por04key++; 
                } 
                this.currenttap=event.index
                //console.log(this.currenttap);  
            }
        }, 
        async printDataP01() { 
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession();     
            const form = {
                staff_id: this.staffid_Main,
                group_id: this.groupid_Main,
                fac_id: this.facid_Main,
                year_id: this.product_date.d_date,
                evalua: this.product_date.evalua , 
                PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                STAFFNAME :user.user.name.STAFFNAME,
                STAFFSURNAME:user.user.name.STAFFSURNAME,
                POSITIONNAME:user.user.name.POSITIONNAME,
                GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                POSTYPENAME:user.user.name.POSTYPENAME, 
                SCOPES:user.user.name.SCOPES.staffdepartmentname 
            }

            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = ` https://survey.msu.ac.th/evaluatebackend/printReportCoverpage?${queryParams}`;
            window.location.href = url;
 
        },  
    },  
}
</script>

<style scoped>
.contract-details {
    font-family: Arial, sans-serif;
}

.employee-info {
    margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
    padding-left: 30px;
}
.explanation p {
    margin: 10px 0;
}

.explanation h2 {
    margin-top: 20px;
}
.image-container {
    display: flex;
    justify-content: center;
}
 
.explanation {
    margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
    padding-left: 30px; /* ปรับการเยื้องเข้าด้านใน */
}
.flex-row {
    display: flex;
    align-items: center; /* จัดแนวให้กลางในแนวตั้ง */
    gap: 40px; /* ระยะห่างระหว่าง "สังกัด" และ "Dropdown" */
}

</style>

