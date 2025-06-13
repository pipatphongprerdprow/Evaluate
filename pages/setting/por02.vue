<template>
     <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP01"></Button>
    </div> 
    <div class="card">
        <h3 class="mb-4" style="text-align: left;"><i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป02</h3>
        <h4>ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 2)</h4><br> 
        <!-- {{ jobSpecificCompetencies }}   -->
        <div class="p-fluid formgrid grid">  
            <!-- ตาราง ก. สมรรถนะหลัก -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 40%;">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                            <th style="width: 20%;">(1)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th>
                            <th style="width: 20%;">(2)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row1, index) in coreCompetencies" :key="index">
                            <td style="text-align: left;">{{ row1.activity }}</td>  
                            <td>
                                <p>{{ row1.indicator }}</p>
                            </td>   
                            <!-- <td style="color: blue"><b>{{row1.selfAssessment}}</b></td> -->
                            <td>  
                                <b v-if="row1.selfAssessment == '' ||  row1.selfAssessment == null" style="color: red;">0</b> 
                                <b v-if="row1.selfAssessment != 0 " style="color: blue" >{{ row1.selfAssessment }}</b> 
                            </td>
                            <td>  
                                <b v-if="row1.data_table1 == '' " style="color: red;">0</b> 
                                <b v-if="row1.data_table1 != 0 " >{{ row1.data_table1 }}</b> 
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div> 
            <!-- ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 50%;">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                            <th style="width: 20%;">(3)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th>
                            <th style="width: 20%;">(4)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row2, index) in jobSpecificCompetencies" :key="index"> 
                            <td style="text-align: left;">ข. {{ index+1 }} {{ row2.WORK_NAME }}</td> 
                            <td>{{ row2.COMPLEVEL }}</td>  

                            <td>  
                                <b v-if="row2.SCOREPERSON == '' || row2.SCOREPERSON == null" style="color: red;">0</b> 
                                <b v-if="row2.SCOREPERSON != 0 " style="color: blue;" >{{ row2.SCOREPERSON }}</b> 
                            </td>
                            <td> 
                                <b v-if="row2.SCORE == null ||row2.SCORE == '' " style="color: red;">0</b> 
                                <b v-if="row2.SCORE != 0 " >{{ row2.SCORE }}</b> 
                            </td> 
                        </tr>
                    </tbody>
                </table>
            </div>
            <!-- ตาราง ค. สมรรถนะอื่นๆ -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 60%;">ค. สมรรถนะทางการบริหาร (สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                            <th style="width: 20%;">(5)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมิน<br>ตนเอง</th>
                            <th style="width: 20%;">(6)ระดับ<br>สมรรถนะ<br>ที่แสดง<br>ออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row3, index) in otherCompetencies" :key="index">
                            <td style="text-align: left;">{{ row3.activity }}</td> 
                            <td>
                                <!-- {{ row3.indicator3 }} -->
                                <b v-if="row3.indicator3 == '' ||  row3.indicator3 == null" style="color: red;">-</b>
                                <span v-if="row3.indicator3 != 0">{{ row3.indicator3 }}</span>  
                            </td>
                            <td>  
                                <b v-if="row3.datatable3 == '' ||  row3.datatable3 == null" style="color: red;">-</b> 
                                <b v-if="row3.datatable3 != 0 " style="color: blue" >{{ row3.datatable3 }}</b> 
                            </td>
                            <td>  
                                <b v-if="row3.selfAssessment3 == '' " style="color: red;">-</b> 
                                <b v-if="row3.selfAssessment3 != 0 " >{{ row3.selfAssessment3 }}</b> 
                            </td>
                        </tr> 
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>
<!-- <script setup> 
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    // console.log(user);
</script>  -->
<script>
import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2' 
 

import InputText from 'primevue/inputtext';
export default {
    props: {
        // กำหนด props ที่จะรับข้อมูลจาก parent
        dataPor: {
            type: Object,
            required: true
        },
        tab2Reload: {
            type: String,
            default: '0'
        } 
    },
    data() {
        return {
           //ตาราง ก. สมรรถนะหลัก
           coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '', data_table1: '',selfAssessment:'' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '', data_table1: '',selfAssessment:'' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '', data_table1: '',selfAssessment:'' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '', data_table1: '',selfAssessment:'' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '', data_table1: '',selfAssessment:'' }
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [], 
             
            //ตาราง ค. สมรรถนะอื่นๆ
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: '0', datatable3: '',selfAssessment3:''},
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: '0', datatable3: '',selfAssessment3:'' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: '0', datatable3: '',selfAssessment3:'' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: '0', datatable3: '',selfAssessment3:'' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: '0', datatable3: '',selfAssessment3:'' }
            ],  
            postypetext: null,
             
        };   
    }, 
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
        //console.log(user.user);
        
        const {STAFFID, SCOPES} = user.user.name 
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid,user.user.name.POSTYPENAME,user.user.name.POSITIONNAMEID,user.user.name.POSITIONNAME); 
       
        
        // this.showdataPo(STAFFID,staffdepartment,this.dataPor.d_date,this.dataPor.evalua);
        // console.log(this.dataPor.d_date); 
        // this.showdataPo(staff_id,this.facid_Main,this.tracking_date.d_date,this.tracking_date.evalua );
    },  
    watch: {
        tab2Reload(v) { 
            // console.log("por02 tab2Reload",v);
            this.showdataPo();
            this.getjobSpecificCompetencies();

        },  
        dataPor: {
            handler(newVal, oldVal) {
                // console.log('dataPor changed:', newVal);
                this.showdataPo();
                this.getjobSpecificCompetencies();
                    // ทำสิ่งที่ต้องการเมื่อ dataPor เปลี่ยนแปลง
            },
            deep: true // ใช้ deep: true เพื่อดูการเปลี่ยนแปลงภายใน object
        },
        
    },
    methods: {  
        setSession (staffid_Main,facid_Main,groupid_Main,postypename,postypenameid,positionname) {
            // console.log('postypename:',postypename);  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main   
            this.postypename = postypename    
            this.postypenameid = postypenameid    
            this.positionname = positionname   
        },
        getjobSpecificCompetencies(){
            //console.log(this.staffid_Main,this.dataPor);
            
            axios.post('   http://127.0.0.1:8000/api/showdataposp02', { 
               p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                for (let i = 0; i < this.jobSpecificCompetencies.length; i++) { // แก้ไขเงื่อนไขที่นี่
                    // ตรวจสอบว่า `res.data[0][`p${i+6}`]` มีค่าก่อนตั้งค่า
                    if (res.data[0] && res.data[0][`p${i+6}`] !== undefined) {
                        this.jobSpecificCompetencies[i]['SCORE'] = res.data[0][`p${i+6}`];
                        this.jobSpecificCompetencies[i]['SCOREPERSON'] = res.data[0][`pa_${i+6}`];
                        // this.otherCompetencies[i]['datatable3'] = res.data[0][`px_${i+1}`];   
                        // this.otherCompetencies[i]['selfAssessment3'] = res.data[0][`pSE_${i+1}`];   
                    } else {
                        console.warn(`Missing data for p${i+6}`);
                    }
                }
                for (let i = 0; i < this.otherCompetencies.length; i++) { // แก้ไขเงื่อนไขที่นี่
                        // ตรวจสอบว่า `res.data[0][`p${i+6}`]` มีค่าก่อนตั้งค่า
                        if (res.data[0] && res.data[0][`px_${i+1}`] !== undefined) {
                            // this.jobSpecificCompetencies[i]['SCORE'] = res.data[0][`p${i+6}`];
                            // this.jobSpecificCompetencies[i]['SCOREPERSON'] = res.data[0][`pa_${i+6}`];
                            this.otherCompetencies[i]['datatable3'] = res.data[0][`px_${i+1}`];
                            this.otherCompetencies[i]['selfAssessment3'] = res.data[0][`pSE_${i+1}`]; 
                        } else {
                             console.warn(`Missing data for px_${i+1}`); 
                            //  console.warn(`Missing data for pSE_${i+1}`); 
                             
                        }  
                    }
                // console.log('Response', res.data);
            })
        },
        showdataPo(){  
            //console.log('positionname: ',this.positionname);   
            //console.log(this.indicator);
            let postypetext = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;
            let postypenameid = this.positionname === 'ผู้บริหาร' ? 90 : this.postypenameid;
            let positionname = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;

            // console.log('postypetext:', postypetext);
            // console.log('postypenameid:', postypenameid);
            
             
            const levelMapping = {
                'ระดับปฏิบัติการ': 1,
                'ระดับปฏิบัติงาน': 1, 
                'ระดับชำนาญการ': 2,
                'ระดับชำนาญงาน': 2,
                'ระดับชำนาญการพิเศษ': 3,
                'ระดับชำนาญงานพิเศษ': 3,
                'อาจารย์': 3,
                'ระดับเชี่ยวชาญ': 4,
                'ระดับเชี่ยวชาญพิเศษ': 5
            };
  
            // ตรวจสอบค่าของ postypetext ใน levelMapping
            let personnel = levelMapping[postypetext] || 0;
             //console.log('personnel:', personnel);

            // ตั้งค่า coreCompetencies ตามระดับที่ได้จาก levelMapping
            this.coreCompetencies = [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: personnel, data_table1: '', selfAssessment: '' }
            ];
             
            this.jobSpecificCompetencies = [];  
            // ปรับ Mapping ให้ใช้ this.positionname แทน postypetext
            const Mapping = {
                'ผู้บริหาร': 1
            };  
            let executive = Mapping[this.positionname] || 0;
            // console.log('executive:', executive); 
            // ตั้งค่า otherCompetencies
            this.otherCompetencies = [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
            ];
 
            // ตั้งค่า jobSpecificCompetencies กลับไปเป็นค่าเริ่มต้น 
            // this.showPostype(this.postypename,this.postypenameid);
            this.showPostype(positionname,postypenameid);
  
            
            axios.post('   http://127.0.0.1:8000/api/showDataPo',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dataPor.d_date,
                record: this.dataPor.evalua,
                postypename: postypetext
            }).then(res => {     
                // console.log('showDataPo > ',res.data);    
                if(res.data.length > 0){
                    const data = res.data[0]; 
                    this.coreCompetencies = this.coreCompetencies.map(item => {
                        if (data[`p${item.id}`] !== undefined) {
                            return {
                                ...item,
                                data_table1: data[`p${item.id}`],
                                selfAssessment: data[`pa_${item.id}`]
                            };
                        }
                        return item;
                    });  
                } 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        showPostype(postypename,postypenameid){
            //console.log('postypename: ',postypename);  
            // console.log('postypenameid: ',postypenameid);  
            var postypetext =postypename;
            axios.post('   http://127.0.0.1:8000/api/showdatapostypenameAdmin', {
                postypename: postypetext,
                postypenameid: postypenameid
            })
            .then(res => {
               //console.log('showPostype: ',res.data);  
                if (res.data.length > 0) { 
                    this.jobSpecificCompetencies = res.data;
                } 
            })
            .catch(error => {
                console.error('Error fetching data:', error); 
            }); 
        },
        showdatator() {  
            //console.log(this.dataPor.d_date,scoreA04); 
            axios.post('   http://127.0.0.1:8000/api/showdatator', {
                p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                 //console.log('Response',res.data);  
                this.assessorText = res.data[0].assessor; 
                this.assessor_positionText = res.data[0].assessor_position;
                this.showscoresum = res.data[0] 
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },
        showjobSpecificCompetencies (){
            axios.post('   http://127.0.0.1:8000/api/showdataposp02', { 
               p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                 //console.log('Response',res.data);  
                // this.assessorText = res.data[0].assessor; 
                // this.assessor_positionText = res.data[0].assessor_position;
                // this.showscoresum = res.data[0] 
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },   
        async printDataP01() { 
            const { signIn, getSession, signOut } = await useAuth() 
            const user = await getSession();   
            const form = {
                staff_id: this.staffid_Main,
                group_id: this.groupid_Main,
                fac_id: this.dataPor.fac_id,
                year_id: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                STAFFNAME :user.user.name.STAFFNAME,
                STAFFSURNAME:user.user.name.STAFFSURNAME,
                POSITIONNAME:user.user.name.POSITIONNAME,
                GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                POSTYPENAME:user.user.name.POSTYPENAME, 
                SCOPES:user.user.name.SCOPES.staffdepartmentname,
                postypename: `ระดับ${this.postypename}`,
                postypenameid: this.postypenameid
            } 
            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `   http://127.0.0.1:8000/report_p02?${queryParams}`;
            window.open(url, '_blank');
 
        },     

    }  
}
</script>


<style scoped>
body {
    font-family: 'Prompt', Arial, sans-serif;
    background-color: #f5f5f5;
    margin: 0;
    padding: 0;
}
.container {
    width: 95%;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
h3 {
    text-align: center;
    margin-bottom: 20px;
}
table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}
th, td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
}
th {
    background-color: #ffffff;
}
th, td:first-child {
    width: 35%; /* Adjusted width for first column */
}
td:nth-child(2), td:nth-child(3) {
    width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
    margin: 5px 0; /* Reduced margin */
    font-size: 14px; /* Smaller font size for form */
}
.add-button, .save-button, .cancel-button {
    margin: 3px; /* Smaller margin */
    padding: 6px 12px; /* Smaller padding */
    font-size: 12px; /* Smaller font size for buttons */
}
.form-container {
    padding: 8px; /* Reduced padding */
    border: 1px solid #ddd;
    background-color: #f0f0f0;
    border-radius: 4px;
    font-size: 14px; /* Smaller font size */
}
.edit-icon, .delete-icon {
    margin: 0 8px; /* Smaller margin */
    cursor: pointer;
    font-size: 16px; /* Slightly larger font size */
}
.edit-icon {
    color: #ffc107;
}
.delete-icon {
    color: #dc3545;
}
th {
    background-color: #edf2bb;
    color: rgb(5, 5, 5);
}
</style>

