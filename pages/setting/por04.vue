<template>
    <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 "></Button>
    </div> 
    <div class="card">
        <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
            <div class="p-fluid formgrid grid">
                <div class="card">                 
                    <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>  
                    <!-- ตาราง ก. สมรรถนะหลัก -->
                    <div class="employee-info">   
                        <p><strong>รอบการประเมิน:</strong> {{dataPor.d_evaluationround}} {{ dataPor.d_date }} </p>
                        <p><strong>ชื่อผู้รับการประเมิน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }} </p>
                        <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }} </p>
                        <p><strong>ระดับตำแหน่ง:</strong>{{ user.user.name.POSTYPENAME }} </p>
                        <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }} </p>
                        <p><strong>ชื่อผู้ประเมิน:</strong> {{ assessorText }}</p> 
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
                                    <b>  {{ showscoresum.achievement_score  }} </b>  
                                </td>  
                                <td class="text-center" style="color: blue;">  
                                    <b v-if="showscoresum.persen">{{showscoresum.persen.split(':')[0]}}</b> 
                                </td> 
                                <td class="text-center" style="color: blue;">  
                                   <b v-if="showscoresum.persen">{{ ((showscoresum.achievement_score )*showscoresum.persen.split(':')[0]).toFixed(2) }} </b> 
                                </td> 
                            </tr>
                            <tr>
                                <td>องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ</td>
                                <td class="text-center" style="color: blue;"> 
                                    <b>{{ showscoresum.behavior  }}</b>  
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                    <b v-if="showscoresum.persen">{{showscoresum.persen.split(':')[1]}}</b> 
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                    <b v-if="showscoresum.persen">{{ ((showscoresum.behavior )*showscoresum.persen.split(':')[1]).toFixed(2) }} </b> 
                                </td> 
                            </tr>
                            <tr>
                                <td>องค์ประกอบอื่นๆ (ถ้ามี)</td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr style="font-weight: bold;">
                                <td colspan="2" style="text-align: right;">รวม</td>
                                <td class="text-center" style="color: blue;"> 
                                    <b>{{ 100 }}%</b>  
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                   {{ showscoresum.sum_score }} 
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br>
                    <div class="employee-info">
                    <h4>ระดับผลการประเมินที่ได้</h4>
                        <p><strong>[&nbsp;&nbsp; <b v-if="(showscoresum.sum_score) >= 90">&#10003;</b> &nbsp;&nbsp;] ดีเด่น (90-100)</strong></p>
                        <p><strong>[&nbsp;&nbsp; <b v-if="(showscoresum.sum_score) >= 80 && (showscoresum.sum_score) < 90">&#10003;</b> &nbsp;&nbsp;] ดีมาก (80-89)</strong></p>
                        <p><strong>[&nbsp;&nbsp; <b v-if="(showscoresum.sum_score) >= 70 && (showscoresum.sum_score) < 80">&#10003;</b> &nbsp;&nbsp;] ดี (70-79)</strong></p>
                        <p><strong>[&nbsp;&nbsp; <b v-if="(showscoresum.sum_score) >= 60 && (showscoresum.sum_score) < 70">&#10003;</b> &nbsp;&nbsp;] พอใช้ (60-69)</strong></p> 
                        <p><strong>[&nbsp;&nbsp; <b v-if="(showscoresum.sum_score) < 60">&#10003;</b> &nbsp;&nbsp;] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p>
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
                                    <label for="evaluator-acknowledgment-2">[ &nbsp;&nbsp; ] ได้แจ้งผลการประเมินเมื่อวันที่ ..............................แต่ผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน 
                                        โดยมี ....................................... เป็นพยาน และ....................................... เป็นพยาน</label><br>
                                    ลงชื่อ .................................................................<br>
                                    ชื่อ {{ assessorText }}<br>
                                    ตำแหน่ง {{ assessor_positionText }}<br>
                                    วันที่ .......... เดือน .......................... พ.ศ...........
                                </td>
                            <td class="center-align"><br><br>
                                ลงชื่อ .................................................................<br>
                                ชื่อ {{ assessorText }}<br>
                                ตำแหน่ง {{ assessor_positionText }}<br>
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
                                    ชื่อ {{ assessorText }}<br>
                                    ตำแหน่ง {{ assessor_positionText }}<br>
                                    วันที่ .......... เดือน .......................... พ.ศ...........
                                </td>
                            </tr>
                        </tbody>
                    </table>
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
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel'; 
export default {
    props: {
        dataPor: {
            type: Object,
            required: true
        }, 
        tab4Reload: {
            type: String,
            default: '0'
        } 
    },
    data() { 
        return {  
            staffid_po: 130102,
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '', 
            // Anurak
            assessorText: [],
            assessor_positionText: [],
            // ปีงบประมาณ
            dropdownItemYear: { name: 'ปีงบประมาณ 2568', code: 2568 },
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            // รอบประเมิน
            dropdownItemRecord: { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            dropdownItemRecords: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            ], 
            tracking_date: '',
            tracking_dates: null, 
             
            // ตารางรายชื่อ
            products: [], 

            // เพิ่มคะแนนประเมิน 
            DialogAdd: false, 
            activeIndex: 0,
            dataStaffid: null,
            //Tab 1 
            products_Tab1: [], 
            p01_score: null,
            p01_scores: [
                { name: '- ไม่ระบุ -', code: 0 },
                { name: '1 คะแนน', code: 1 },
                { name: '2 คะแนน', code: 2 },
                { name: '3 คะแนน', code: 3 },
                { name: '4 คะแนน', code: 4 },
                { name: '5 คะแนน', code: 5 },
            ],
            p01_detail: null,
            //ตาราง ก. สมรรถนะหลัก
            coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '' }
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [
                { id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
                { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
                { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
                { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
                { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
                { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
            ],
            //ตาราง ค. สมรรถนะอื่นๆ
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator: '0', data_table3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator: '0', data_table3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0', data_table3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0', data_table3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0', data_table3: '' }
            ],
            improvements: null,
            suggestions: null,  
            //Tab 2 
            products_Tab2: [],
            //Tab 3
            p04_re1: null,
            p04_re2: null,
            p04_re3: null,
            products_Tab3: [],
            chkP04: 0,
            //Tab 4
            products_Tab3T4: [],
            //total weight
            totalscoretrack:{},
            totalWeighttrack: {}, 
            WeightedScoreSumtrack:{},
            WeightedScoreSumX :{},
            WeightedScoreSumXT: {},
            //รวมคะแนน เกณฑ์การประเมิน
            totalCoreCompetencies:{},
            totalZeroScores:{},
            totalScoreSum:{},
            totalScoreZeroSum:{},
            totalScoreFinalSum:{}, 
            showscoresum:{} 
        };
    }, 
    components: {
        TabView,
        TabPanel
    }, 
    async mounted(){  
       // console.log(this.dataPor);  
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid);
        //this.showdatator()  
    }, 
    watch: { 
        tab4Reload(v) { 
            // console.log("por04 tab4Reload",v);
            this.chkp04dataXr(); 
            this.showdatator();  
        },  
    },
    computed: {
        totalscoretrack() {
            // ใช้ reduce เพื่อคำนวณค่ารวมของ p_weight(รวมค่าคะแนนที่ได้)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + subP01.p01_score ; // เพิ่ม p01_weight ของแต่ละ subP01
                }, 0);
            }, 0);
        },
        totalWeighttrack() {
            // ใช้ reduce เพื่อคำนวณค่ารวมของ p_weight*(รวมน้ำหนักความยากง่ายของงาน)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + subP01.p01_weight; // เพิ่ม p01_weight ของแต่ละ subP01
                }, 0);
            }, 0);
        },
        WeightedScoreSumtrack() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ และหารด้วย 5(รวมค่าคะแนนถ่วงน้ำหนัก)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    // คำนวณคะแนนรวม (subP01.p01_score * subP01.p01_weight / 100) แล้วหารด้วย 5
                    return subTotal + ((subP01.p01_score * subP01.p01_weight / 100));
                }, 0);
            }, 0).toFixed(3); // ใช้ toFixed(3) เพื่อแสดงทศนิยม 3 ตำแหน่ง
        },
        WeightedScoreSumX() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ(รวมน้ำหนักความยากง่ายของงาน/5)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + (subP01.p01_weight/5 );
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(2) เพื่อให้มีทศนิยม 2 ตำแหน่ง
        },
        WeightedScoreSumXT() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ (รวมค่าคะแนนถ่วงน้ำหนัก/5)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + ((subP01.p01_score * subP01.p01_weight / 100) / 5);
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(2) เพื่อให้มีทศนิยม 2 ตำแหน่ง
        },
            //รวมคะแนน เกณฑ์การประเมิน
            //รวมช่องสมรรถนะ
        totalCoreCompetencies() { 
            return this.coreCompetencies.reduce((sum, row, index) => { 
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0; 
                return sum + dataTable1Value + dataTable2Value;
            }, 0);
        },
            //รวมช่องค่า0
        totalZeroScores() { 
            let zeroScoreCount = 0; 
            this.coreCompetencies.forEach(row => {
            if (parseFloat(row.data_table1) === 0) {
                zeroScoreCount++;
            }
            });  
            this.jobSpecificCompetencies.forEach(row => {
            if (parseFloat(row.data_table2) === 0) {
                zeroScoreCount++;
            }
            }); 
            return zeroScoreCount;
        },
        //รวมคะแนนจำนวนสมรรถนะ*3
        totalScoreSum(staffid) {
            let sum = 0;

            // คำนวณคะแนนจาก coreCompetencies
            this.coreCompetencies.forEach(row => {
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                sum += dataTable1Value * 3;
            });

            // คำนวณคะแนนจาก jobSpecificCompetencies
            this.jobSpecificCompetencies.forEach(row => {
                const dataTable2Value = parseFloat(row.data_table2) || 0;
                sum += dataTable2Value * 3;
            });

            return sum;
        }, 
        totalScoreSumX() {     
            return this.coreCompetencies.reduce((sum, row, index) => { 
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0;  
                return sum + (dataTable1Value * 3) + (dataTable2Value * 3);
            }, 0);
        },  
        totalScoreZeroSum() { 
            let zeroScoreCount = 0;  
            this.coreCompetencies.forEach(row => { 
                if (parseFloat(row.data_table1) === 0) {
                    zeroScoreCount++;
                }
            });  
            this.jobSpecificCompetencies.forEach(row => { 
                if (parseFloat(row.data_table2) === 0) {
                    zeroScoreCount++;
                }
            });  
            return zeroScoreCount * 2;
        },  
    }, 
    methods: { 
         insertscore1(scoreA04) { 
        // //console.log(scoreA04); 
        // //console.log(this.dataPor.d_date,this.dataPor.evalua,scoreA04); 
        //     axios.post('http://localhost:8000/api/savepersentor',{
        //             p_staffid: this.staffid_Main, 
        //             p_year: this.dataPor.d_date, 
        //             evalua: this.dataPor.evalua, 
        //             score: scoreA04, 
        //             insert:"achievement_score"
        //         }).then(res => {     
        //             //console.log(res.data); 
        //     });
         },
        // insertscore2(scoreB) { 
        // //console.log(scoreB); 
        // //console.log(this.dataStaffid); 
        //     axios.post('http://localhost:8000/api/savepersentor',{
        //             p_staffid: this.staffid_Main, 
        //             p_year: this.tracking_date.d_date, 
        //             evalua: this.tracking_date.evalua, 
        //             score: scoreB,
        //             insert:"behavior" 

        //         }).then(res => {     
        //             console.log(res.data); 
        //     });
        // },
        // insertscore3(scoreS) { 
        // //console.log(scoreB); 
        // //console.log(this.dataStaffid); 
        //     axios.post('http://localhost:8000/api/savepersentor',{
        //             p_staffid: this.staffid_Main, 
        //             p_year: this.tracking_date.d_date, 
        //             evalua: this.tracking_date.evalua, 
        //             score: scoreS,
        //             insert:"sum_score" 

        //         }).then(res => {     
        //             console.log(res.data); 
        //     });
        // },
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main  
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
        /*============= ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา =============*/ 
        chkp04dataXr(){  
            this.products_Tab3T4 = [];
            axios.post('http://localhost:8000/api/showData04Tab3',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dataPor.d_date,
                record: this.dataPor.evalua, 
            }).then(res => {     
                // console.log('chkp04data',res.data);
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
    box-shadow: 0 0 10px rgba(2, 2, 2, 0.1);
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
    background-color: #e5e5e3;
    color: rgb(9, 8, 8);
}
.bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
    /* P01 */
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
  .button-container {
  text-align: center; /* จัดกึ่งกลางในแนวนอน */
}
.custom-textarea {
  width: 100%; /* ให้เต็มความกว้างของ container */
  height: 100px; /* ปรับความสูงของ textarea */
  padding: 10px; /* เพิ่มช่องว่างด้านใน */
  border-radius: 5px; /* ปรับมุมให้โค้งมน */
  border: 1px solid #ccc; /* กำหนดขอบ */
  font-size: 1rem; /* ขนาดตัวอักษร */
  resize: none; /* ปิดการย่อขยาย */
}
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
.styled-table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .styled-table thead tr {
    background-color: #f2f2f2;
  }
  
  .styled-table th, .styled-table td {
    padding: 8px;
    text-align: center;
    border: 1px solid #ddd;
  }

  .styled-table td b {
    word-break: break-word;
  }
  .left-align {
    text-align: left;
  }
</style>
