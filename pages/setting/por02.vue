<template>
     <!-- <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 "></Button>
    </div> --> 
    <div class="card">
        <h3 class="mb-4" style="text-align: left;"><i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป02</h3>
        <h4>ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 2)</h4><br> 
        <div class="p-fluid formgrid grid">  
            <!-- ตาราง ก. สมรรถนะหลัก -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 60%;">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                            <th style="width: 20%;">(1)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">(2)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row1, index) in coreCompetencies" :key="index">
                            <td style="text-align: left;">{{ row1.activity }}</td> 
                            <td>{{ row1.indicator }}</td>
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
                            <th style="width: 60%;">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                            <th style="width: 20%;">(3)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">(4)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row2, index) in jobSpecificCompetencies" :key="index"> 
                            <td style="text-align: left;">ข. {{ index+6 }} {{ row2.WORK_NAME }}</td> 
                            <td>{{ row2.COMPLEVEL }}</td>
                            <td>
                                <b v-if="row2.SCORE == '' " style="color: red;">0</b> 
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
                            <th style="width: 20%;">(6)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row3, index) in otherCompetencies" :key="index">
                            <td style="text-align: left;">{{ row3.activity }}</td> 
                            <td></td>
                            <td></td>
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
import { saveAs } from 'file-saver';
export default {
    props: {
        // กำหนด props ที่จะรับข้อมูลจาก parent
        dataPor: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
           //ตาราง ก. สมรรถนะหลัก
           coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '' }
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [],
            // jobSpecificCompetencies: [
            //     { id: 6, activity: 'ข. 1 การคิดวิเคราะห์12', indicator: '0', data_table2: '' },
            //     { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก111', indicator: '0', data_table2: '' },
            //     { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ111', indicator: '0', data_table2: '' },
            //     { id: 9, activity: 'ข. 4 การมองภาพองค์รวม222', indicator: '0', data_table2: '' },
            //     { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล2222', indicator: '0', data_table2: '' },
            //     { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน122222', indicator: '0', data_table2: '' }
            // ],
            //ตาราง ค. สมรรถนะอื่นๆ
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator: '0', data_table3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator: '0', data_table3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0', data_table3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0', data_table3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0', data_table3: '' }
            ], 
             
        };   
    }, 
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
        // console.log(user.user);
        
        const {STAFFID, SCOPES} = user.user.name 
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid,user.user.name.POSTYPENAME,user.user.name.POSITIONNAMEID); 
       
 
        // this.showdataPo(STAFFID,staffdepartment,this.dataPor.d_date,this.dataPor.evalua);
        // console.log(this.dataPor.d_date); 
        // this.showdataPo(staff_id,this.facid_Main,this.tracking_date.d_date,this.tracking_date.evalua );
    },  
    watch: {
        // เฝ้าดูการเปลี่ยนแปลงของ dataPor
        dataPor: {
            handler(newVal, oldVal) {
                // console.log('dataPor changed:', newVal);
                this.showdataPo();
                this.getjobSpecificCompetencies();
                    // ทำสิ่งที่ต้องการเมื่อ dataPor เปลี่ยนแปลง
            },
            deep: true // ใช้ deep: true เพื่อดูการเปลี่ยนแปลงภายใน object
        }
    },
    methods: {  
        setSession (staffid_Main,facid_Main,groupid_Main,postypename,postypenameid) {
            // console.log('postypename:',postypename);  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main   
            this.postypename = postypename    
            this.postypenameid = postypenameid    
        },
        getjobSpecificCompetencies(){
            //console.log(this.staffid_Main,this.dataPor);
            
            axios.post('http://localhost:8000/api/showdataposp02', { 
               p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                for(let i=0;i<=this.jobSpecificCompetencies.length;i++){
                    //console.log(this.jobSpecificCompetencies[i]);
                     
                    this.jobSpecificCompetencies[i]['SCORE'] = res.data[0][`p${i+6}`];
                    
                }
                 //console.log('Response',res.data);  
                // this.assessorText = res.data[0].assessor; 
                // this.assessor_positionText = res.data[0].assessor_position;
                // this.showscoresum = res.data[0] 
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },
        showdataPo(){  
            // ตั้งค่า coreCompetencies กลับไปเป็นค่าเริ่มต้น
            this.coreCompetencies = [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '' }
            ];  
            
            
            // ตั้งค่า jobSpecificCompetencies กลับไปเป็นค่าเริ่มต้น 
            this.showPostype(this.postypename,this.postypenameid);

            axios.post('http://localhost:8000/api/showDataPo',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dataPor.d_date,
                record: this.dataPor.evalua,
            }).then(res => {     
                // console.log(res.data);    
                if(res.data.length > 0){
                    const data = res.data[0];
                    this.coreCompetencies.forEach(item => {
                        if (item.id === 1) {
                            item.data_table1 = data.p1;  // Update based on the API response
                        } else if (item.id === 2) {
                            item.data_table1 = data.p2;  // Update based on the API response
                        } else if (item.id === 3) {
                            item.data_table1 = data.p3;  // Add more conditions if necessary
                        } else if (item.id === 4) {
                            item.data_table1 = data.p4;  // Add more conditions if necessary
                        } else if (item.id === 5) {
                            item.data_table1 = data.p5;  // Add more conditions if necessary
                        }
                    });

                    // this.jobSpecificCompetencies.forEach(item => {
                    //     if (item.id === 6) {
                    //         item.data_table2 = data.p6;  // Update based on the API response
                    //     } else if (item.id === 7) {
                    //         item.data_table2 = data.p7;  // Update based on the API response
                    //     } else if (item.id === 8) {
                    //         item.data_table2 = data.p8;  // Add more conditions if necessary
                    //     } else if (item.id === 9) {
                    //         item.data_table2 = data.p9;  // Add more conditions if necessary
                    //     } else if (item.id === 10) {
                    //         item.data_table2 = data.p10;  // Add more conditions if necessary
                    //     } else if (item.id === 11) {
                    //         item.data_table2 = data.p11;  // Add more conditions if necessary
                    //     }
                    // });
                } 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        showPostype(postypename,postypenameid){
            // console.log(postypename); 
            var postypetext = `ระดับ`+postypename;
            axios.post('http://localhost:8000/api/showdatapostypename', {
                postypename: postypetext,
                postypenameid: postypenameid
            })
            .then(res => {
                console.log('Response',res.data);  
                if (res.data.length > 0) { 
                    this.jobSpecificCompetencies = res.data;
                }
                // } else {
                //     // Fallback to default data if response doesn't contain expected data
                //     this.jobSpecificCompetencies = [
                //         { id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
                //         { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
                //         { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
                //         { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
                //         { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
                //         { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
                //     ];
                // }  
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            }); 
        },
        showdatator() {  
            //console.log(this.dataPor.d_date,scoreA04); 
            axios.post('http://localhost:8000/api/showdatator', {
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
            axios.post('http://localhost:8000/api/showdataposp02', { 
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
        }   
          

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

