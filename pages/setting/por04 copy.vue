<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">  
            <div class="card">
                <!-- {{ dataPor }}  -->
                <!-- {{ user }} -->
                <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
                <div class="p-fluid formgrid grid">
                    <div class="card">                      
                        <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5> 
                        <div class="employee-info"> 
                            <p><strong>รอบการประเมิน:</strong> {{ dataPor.d_evaluationround  }} </p>
                            <p><strong>ชื่อผู้รับการประเมิน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }} </p>
                            <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }} </p>
                            <!-- <p><strong>ระดับตำแหน่ง:</strong> </p> -->
                            <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }} </p>
                            <p><strong>ชื่อผู้ประเมิน:</strong> นางสาวพนมพร ปัจจวงษ์ </p>
                        </div><br>
                        <div class="employee-info" style="border: groove;padding: 15px;">
                            <h4>คำชี้แจง</h4>
                            <h5>แบบสรุปการประเมินผลการปฏิบัติราชการนี้มีด้วยกัน 5 ส่วน ดังนี้</h5>
                            <p><strong>ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</strong> เพื่อระบุรายละเอียดต่างๆ ที่เกี่ยวข้องกับตัวผู้รับการประเมิน</p>
                            <p> <strong>ส่วนที่ 2 การสรุปผลการประเมิน</strong> ใช้เพื่อกรอกค่าคะแนนการประเมินในองค์ประกอบด้านผลสัมฤทธิ์ของงาน 
                                องค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ และน้ำหนักของทั้งสององค์ประกอบในแบบสรุปส่วนที่ 2 นี้ ยังใช้สำหรับคำนวณคะแนนผลการปฏิบัติราชการรวมด้วย<br>
                                - สำหรับคะแนนองค์ประกอบด้านผลสัมฤทธิ์ของงาน ให้นำมาจากแบบประเมินผลสัมฤทธิ์ของงาน โดยให้แนบท้ายแบบสรุปฉบับนี้<br>
                                - สำหรับคะแนนองค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ ให้นำมาจากแบบประเมิน สมรรถนะโดยให้แนบท้ายแบบสรุปฉบับนี้</p>
                            <p><strong>ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</strong> ผู้ประเมินและผู้รับการประเมินร่วมกันจัดทำแผนพัฒนา ผลการปฏิบัติราชการ</p>
                            <p><strong>ส่วนที่ 4 การรับทราบผลการประเมิน</strong> ผู้รับการประเมินลงนามรับทราบผลการประเมิน</p>
                            <p><strong>ส่วนที่ 5 ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป</strong> ผู้บังคับบัญชาเหนือขึ้นไปกลั่นกรองผลการประเมิน แผนพัฒนาผลการปฏิบัติราชการ และให้ความเห็น</p>
                        </div>                                                       
                        <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 2 ข้อมูลของผู้รับการประเมิน</h5>
                        <table border="1" cellspacing="0" cellpadding="5">
                            <thead>
                                <tr style="background-color: #F4B366;">
                                    <th rowspan="2">องค์ประกอบการประเมิน</th>
                                    <th rowspan="2">ค่าคะแนนที่ได้หลังถ่วงน้ำหนัก (ก)</th>
                                    <th rowspan="2">สัดส่วนคะแนน (ข)</th>
                                    <th rowspan="2">สรุปคะแนน (ก) X (ข)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน</td>
                                    <td class="text-center" style="color: blue;"> 
                                        <b>{{  }}XX</b>  
                                    </td> 
                                    <td class="text-center" style="color: blue;"> 
                                        <b>{{  }}XX</b>  
                                    </td>
                                    <td class="text-center" style="color: blue;"> 
                                        <b>{{  }}XX</b>  
                                    </td>
                                </tr>
                                <tr>
                                    <td>องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>องค์ประกอบอื่นๆ (ถ้ามี)</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr style="font-weight: bold;">
                                    <td colspan="2" style="text-align: right;">รวม</td>
                                    <td>100%</td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="employee-info">
                            <h4>ระดับผลการประเมินที่ได้</h4>
                            <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดีเด่น (90-100)</strong></p>
                            <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดีมาก (80-89)</strong></p>
                            <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดี (70-79)</strong></p>
                            <p><strong>[ &nbsp;&nbsp;&nbsp; ] พอใช้ (60-69)</strong></p> 
                            <p><strong>[ &nbsp;&nbsp;&nbsp; ] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p> <!-- <b>&#10003;</b> -->
                        </div>
                        <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</h5>
                        <table border="1" cellspacing="0" cellpadding="5">
                            <thead>
                                <tr style="text-align: center;">
                                    <th>ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา</th>
                                    <th>วิธีการพัฒนา</th>
                                    <th>ช่วงเวลาที่ต้องการพัฒนา</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(Tab3T4, idx) in products_Tab3T4" :key="idx"  >
                                    <td style="text-align: left;">{{ Tab3T4.p04_re1 }}</td>
                                    <td style="text-align: left;">{{ Tab3T4.p04_re2 }}</td>
                                    <td style="text-align: left;">{{ Tab3T4.p04_re3 }}</td> 
                                </tr> 
                            </tbody>
                        </table> 
                            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 4 การรับทราบผลการประเมิน</h5>
                            <table class="styled-table">
                            <tbody>
                                <tr>
                                <td>
                                    <b>ผู้รับการประเมิน</b><br>
                                    <label for="receiver-acknowledgment">[ &nbsp;&nbsp; ] ได้รับทราบผลการประเมินและแผนพัฒนาการปฏิบัติราชการ รายบุคคลแล้ว</label><br>
                                </td>
                                    <td class="center-align"><br><br>
                                        ลงชื่อ .................................................................<br>
                                        ชื่อ: {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}<br>
                                        ตำแหน่ง: {{ user.user.name.POSITIONNAME }}<br>
                                        วันที่ .......... เดือน .......................... พ.ศ.
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>ผู้ประเมิน</b><br>
                                        <label for="evaluator-acknowledgment-1">[ &nbsp;&nbsp; ] ได้แจ้งผลการประเมินและผู้รับการประเมินได้ลงนามรับทราบ รายบุคคลแล้ว</label><br>
                                        <label for="evaluator-acknowledgment-2">[ &nbsp;&nbsp; ] ได้แจ้งผลการประเมินเมื่อวันที่ ..............................แต่ผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน โดยมี .......................... เป็นพยาน</label><br>
                                        ลงชื่อ .................................................................<br>
                                        ชื่อ นางสาวพนมพร ปัจจวงษ์<br>
                                        ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                        วันที่ .......... เดือน .......................... พ.ศ...........
                                    </td>
                                <td class="center-align"><br><br>
                                    ลงชื่อ .................................................................<br>
                                    ชื่อ นางสาวพนมพร ปัจจวงษ์<br>
                                    ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                    วันที่ .......... เดือน .......................... พ.ศ...........
                                </td>
                                </tr>
                            </tbody>
                            </table>
                            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 5  ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป</h5>
                            <table class="styled-table">
                            <tbody>
                                <tr>
                                <td>
                                    <b>ผู้บังคับบัญชาเหนือขึ้นไป</b><br>
                                    <label for="evaluator-acknowledgment-3">[ &nbsp;&nbsp;] เห็นด้วยกับผลการประเมิน</label><br>
                                    <label for="evaluator-acknowledgment-3">[ &nbsp;&nbsp;] มีความเห็นต่าง ดังนี้<br>..............................................................................................................</label><br>
                                    .....................................................................................................................................<br>
                                    .....................................................................................................................................
                                </td>
                                <td class="center-align"><br><br>
                                    ลงชื่อ : .................................................................<br>
                                    ชื่อ : {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}<br>
                                    ตำแหน่ง : {{ user.user.name.POSITIONNAME }}<br>
                                    วันที่ : .......... เดือน .......................... พ.ศ.............
                                </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>ผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง (ถ้ามี)</b><br>
                                        
                                        <label for="evaluator-acknowledgment-5">[ &nbsp;&nbsp;] เห็นด้วยกับผลการประเมิน</label><br>
                                        
                                        <label for="evaluator-acknowledgment-6">[ &nbsp;&nbsp;] มีความเห็นต่าง ดังนี้<br>...............................................................................................................</label><br>
                                        .......................................................................................................................................<br>
                                        .......................................................................................................................................
                                    </td>
                                    <td class="center-align"><br><br>
                                        ลงชื่อ .................................................................<br>
                                        ชื่อ นางสาวพนมพร ปัจจวงษ์<br>
                                        ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                        วันที่ .......... เดือน .......................... พ.ศ...........
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>  
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
import { saveAs } from 'file-saver';

export default {
    props: { 
        dataPor: {
            type: Object,
            required: true
        }
    },
    data() {
        return { 
            staffid_Main: null,
            year_Main: null,
            facid_Main: null,
            groupid_Main: null, 
            products_Tab3T4: [],
            //รวมคะแนน
            WeightedScoreSum:{} 
        }
    }, 

    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid);  
    }, 
    //รวมคะแนน
    computed: { 
           
    }, 
    watch: { 
        dataPor: {
            handler(newVal, oldVal) { 
                this.chkp04dataT4(); 
            },
            deep: true  
        }
    },
    methods: {  
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main  
        }, 
        chkp04dataT4(){
            axios.post('http://localhost:8000/api/showData04Tab3',{
                staff_id: this.staffid_Main,
                fac_id: this.dataPor.fac_id,
                year_id: this.dataPor.d_date, 
                record: this.dataPor.evalua 
            }).then(res => {     
                // console.log(res.data);     
                if(res.data.length > 0){
                    this.products_Tab3T4 = res.data;
                } 
            })
            .catch(error => {
                console.error('Error:', error);
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
    .card-header {
        text-align: left; /* Aligns text to the left */
        margin: 0; /* Removes default margins */
        padding: 0; /* Removes default padding */
    }
    .table {
        width: 100%;
        border-collapse: collapse;
    }
    .table th, .table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    .table th {
        background-color: #edf2bb;
        font-weight: bold;
    }
    .table td {
        vertical-align: top;
    }
    .d-flex {
    display: flex;
    flex-wrap: nowrap;
    }
    .align-items-center {
        align-items: center;
    }
    .ml-auto {
        margin-left: auto;
    }
    .ml-4 {
        margin-left: 1rem;
    }
    .mr-4 {
        margin-right: 1rem;
    }
</style>
