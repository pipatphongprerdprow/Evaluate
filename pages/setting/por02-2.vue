<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    
                    <div class="col md:col-6" >  
                        <label for="examine_date"></label>
                        <Dropdown id="examine_date" v-model="examine_date" :options="examine_dates" optionLabel="d_evaluationround" placeholder="กรุณาเลือกรอบการประเมิน" style=" max-width: 500px; width: 100%" ></Dropdown>
                        <!-- {{ tracking_date }} --> 
                    </div>     
                </div>  

                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th>ชื่อ - สกุล</th>  
                            <th>ตำแหน่ง</th>  
                            <th>สถานะ</th>  
                            <th>ตัวเลือก</th>  
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 40%;">
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b>
                                <Tag v-if="Item.countchk==2 " severity="success" style="font-size: larger;">อนุมัติ</Tag>
                                <Tag v-if="Item.countchk==3 " severity="danger" style="font-size: larger;">ไม่ผ่าน</Tag> 
                            </td>
                            <td style="padding-left: 5px;width: 25%;"><b>{{ Item.posnameth }}</b></td>
                            <td style="text-align: center;width: 20%;">   
                                <div v-if="Item.countchk!=''">
                                    <Button icon="pi pi-check" label="อนุมัติ" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,2)" />
                                    <Button icon="pi pi-times" severity="danger" label="ไม่ผ่าน" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,3)"  /> 
                                </div>
                                <div v-if="Item.countchk==''">
                                    <Button icon="pi pi-bookmark" severity="secondary" label="ไม่มีข้อมูล" rounded class="mb-2 mr-2"/>
                                </div> 
                                {{ Item.countchk }}
                            </td>
                            <td style="text-align: center;width: 15%;">
                                <Button severity="info" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>
                        </tr> 
                    </tbody>
                </table>
               
                <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                    <template v-slot:header>
                        <h3>รายงานแบบแบบประเมิน ป01-ป04</h3>
                        <InputText v-model="dataStaffid" type="hidden" autocomplete="off" style="display: none;"/>   
                    </template>
                    <TabView :activeIndex="activeIndex" @tabChange="onTabChange">  
                        <TabPanel header="รายงาน ป.01 - ป.03" >
                            <div class="grid">
                                <div class="col-12 lg:col-12 xl:col-12">
                                    <div class="card mb-0">  
                                        <hr>
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
                                                            <td style="text-align: left;">{{ row2.activity }}</td> 
                                                            <td>{{ row2.indicator }}</td>
                                                            <td>
                                                                <b v-if="row2.data_table2 == '' " style="color: red;">0</b> 
                                                                <b v-if="row2.data_table2 != 0 " >{{ row2.data_table2 }}</b> 
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
                                </div> 
                            </div>
                        </TabPanel>

                        <TabPanel header="รายงาน ป.04" >
                            <div class="card">
                                <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
                                    <div class="p-fluid formgrid grid">
                                        <div class="card">                      
                                            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>
                                            <!-- ตาราง ก. สมรรถนะหลัก -->
                                            <div class="employee-info"> 
                                                <p><strong>รอบการประเมิน:</strong> {{ examine_date.d_evaluationround }}</p>
                                                <p><strong>ชื่อผู้รับการประเมิน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }} </p>
                                                <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }} </p>
                                                <p><strong>ระดับตำแหน่ง:</strong>{{ user.user.name.POSTYPENAME }} </p>
                                                <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }} </p>
                                                <p><strong>ชื่อผู้ประเมิน:</strong> นางสาวพนมพร ปัจจวงษ์</p>
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
                                                                <b>{{ ((totalScoreSum + totalScoreZeroSum) / 33).toFixed(2) }}</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ 70 }}</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ ((totalScoreSum + totalScoreZeroSum) / 33*70).toFixed(2) }}</b>  
                                                            </td> 
                                                        </tr>
                                                        <tr>
                                                            <td>องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ</td>
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ WeightedScoreSumXT }}</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ 30 }}</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ (WeightedScoreSumXT *30).toFixed(2) }}</b>  
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
                                                                <b>{{ 100}}%</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ (((totalScoreSum + totalScoreZeroSum) / 33 * 70) + (WeightedScoreSumXT * 30)).toFixed(2) }}</b>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                            </table>
                                            <div class="employee-info">
                                                <h4>ระดับผลการประเมินที่ได้</h4>
                                                <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดีเด่น (90-100)</strong></p>
                                                <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดีมาก (80-89)</strong></p>
                                                <p><strong>[ &nbsp;&nbsp;&nbsp; ] ดี (70-79)</strong></p>
                                                <p><strong>[ &nbsp;&nbsp;&nbsp; ] พอใช้ (60-69)</strong></p> 
                                                <p><strong>[ &nbsp;&nbsp;&nbsp; ] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p> <!--<b>&#10003;</b>-->
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
                                                            ชื่อ นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                            ตำแหน่ง นักวิชาการคอมพิวเตอร์<br>
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
                                                        ชื่อ : นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                        ตำแหน่ง : นักวิชาการคอมพิวเตอร์<br>
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
                        </TabPanel> 
 
                    </TabView>
                    <template #footer>
                        <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="DialogAdd = false " />
                    </template>
                </Dialog>  

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
    data() {
        return {
            searchData: null,
            year_Main: 2568,
            staffid_Main: 5009942,
            facid_Main: 201092704000,
            groupid_Main: '01', 
            products: [],
            dropdownItemYear: 2568,
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            DialogAdd: false,
            coreCompetencies: [
                { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1',report: '1' },
                { activity: 'ก. 2 การบริการที่ดี', indicator: '1',report: '1'  },
                { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1',report: '1'},
                { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1',report: '1'},
                { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1',report: '1'}
            ],
            jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1',report: '1'},
                { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1',report: '1'},
                { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1',report: '1'},
                { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1',report: '1'},
                { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1',report: '1'},
                { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1',report: '1'}
                
            ],
            otherCompetencies: [
                { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0',report: '1'},
                { activity: 'ค. 2 วิสัยทัศน์', indicator: '0',report: '1'},
                { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0',report: '1'},
                { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0',report: '1'},
                { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0',report: '1'}
               
            ],
            Summary:[
            {component:'องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน',behavior:'0.10',proportions:'50%',proportion:'50'},
            {component:'องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ',behavior:'0.67',proportions:'50%',proportion:'50'},
            {component:'องค์ประกอบอื่นๆ (ถ้ามี)',behavior:'',proportions:'',proportion:''},
            {component:'รวม',proportions:'100%',proportion:'100'},

            ],
            newActivity: '',
            newIndicator: '',
            newReport: '',
            newEvidence: '',
            activeFormIndex: null,
            activeCategory: '',
 /// New
            dataStaffid: null,
            examine_date: '',
            examine_dates: [], 
            activeIndex: 0,
            //Tab 2 
            products_Tab2: [],
            improvements: null,
            suggestions: null,
            // 3
            products_Tab3T4:[],
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
          
        };
    },
        
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid); 
        this.showDataEvalu();  
        this.showDataSet();
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
        totalScoreSum() {
            return this.coreCompetencies.reduce((sum, row, index) => { 
            const dataTable1Value = parseFloat(row.data_table1) || 0;
            const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0;  
            return sum + (dataTable1Value * 3) + (dataTable2Value * 3); 
            }, 0);
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
        }  
    }, 
    methods: { 
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main  
        },
        showDataSet() {
            axios
                .post('http://localhost:8000/api/showDateSet', {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main
                })
                .then((res) => {
                    // console.log(res.data); 
                    this.examine_dates = res.data;
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        async showDataEvalu(){
            await axios.get('http://localhost:8000/api/showDataEvalu',{
                params: {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main, 
                    group_id: this.groupid_Main
                },
            }).then(res => {     
                // console.log(res.data);  
                this.products=res.data;   
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        editRow(category, index) {
            this.activeFormIndex = index;
            this.activeCategory = category;
        },
        deleteRow(category, index) {
            if (category === 'core') {
                this.coreCompetencies.splice(index, 1);
            } else if (category === 'job') {
                this.jobSpecificCompetencies.splice(index, 1);
            } else if (category === 'other') {
                this.otherCompetencies.splice(index, 1);
            }
        },
        showForm(category, index) {
            this.activeFormIndex = index;
            this.activeCategory = category;
        },
        hideForm() {
            this.activeFormIndex = null;
            this.activeCategory = '';
            this.newActivity = '';
            this.newIndicator = '';
            this.newReport = '';
            this.newEvidence = '';
        },
        addRow(category) {
            const newRow = {
                activity: this.newActivity,
                indicator: this.newIndicator,
                report: this.newReport,
                evidence: this.newEvidence
            };
            if (category === 'core') {
                this.coreCompetencies.push(newRow);
            } else if (category === 'job') {
                this.jobSpecificCompetencies.push(newRow);
            } else if (category === 'other') {
                this.otherCompetencies.push(newRow);
            }
            this.hideForm();
        },
        handleFileUpload(event) {
            const file = event.target.files[0];
            // เพิ่มฟังก์ชันการอัพโหลดไฟล์
        },
        async Btnstatus(staff_id,status){   
            await axios.post('http://localhost:8000/api/postDataChkBtn',{ 
                year: this.dropdownItemYear ,
                staff_id: staff_id ,
                status: status
            }).then(res => {     
                // console.log(res.data);  
                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกข้อมูลสำเร็จ",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.showDataEvalu();
            })
            .catch(error => {
                console.error('Error:', error);
            });  
             
        },
 
        openDataEvalu(staff_id){  
            if(this.examine_date.d_date === undefined){
                Swal.fire("แจ้งเตือนจากระบบ","กรุณาเลือกรอบประเมิน","error");
            }else{  
                this.DialogAdd = true; 
                this.dataStaffid = staff_id
                this.products_Tab2 = [];
                // ตั้งค่า coreCompetencies กลับไปเป็นค่าเริ่มต้น
                this.coreCompetencies = [
                    { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '' },
                    { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '' },
                    { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '' },
                    { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '' },
                    { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '' }
                ];  
                
                // ตั้งค่า jobSpecificCompetencies กลับไปเป็นค่าเริ่มต้น
                this.jobSpecificCompetencies = [
                    { id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
                    { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
                    { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
                    { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
                    { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
                    { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
                ];

                this.improvements = null;
                this.suggestions = null;
            }
        }, 

        onTabChange(event) { 
            // console.log(event.index);
            if (event.index==0) {
                console.log('แบบใบปะหน้า -',event.index); 
            }
            if(event.index==1){
                console.log('รายงาน ป.01 - ป.03 -',event.index);  
                this.tab2Data(this.dataStaffid);  
                this.showdataPoText(this.dataStaffid,this.facid_Main,this.examine_date.d_date,this.examine_date.evalua); 
            } 
            if (event.index==2) {
                console.log('รายงาน ป.04 -',event.index);
                this.chkp04dataT4(this.dataStaffid,this.facid_Main,this.examine_date.d_date,this.examine_date.evalua);   
            }
        },  
        tab2Data(staff_id){  
            axios.post('http://localhost:8000/api/showDataP03New',{
                staff_id: staff_id, 
                fac_id: this.examine_date.fac_id,
                year_id: this.examine_date.d_date, 
                evalua: this.examine_date.evalua   
            }).then(res => {     
                // console.log(res.data);   
                if (res.data && Array.isArray(res.data)) {
                    this.products_Tab2 = res.data;  
                }   
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },

        showdataPoText(staff_id,fac_id,year_id,record){ 
            axios.post('http://localhost:8000/api/showDataPo',{
                staff_id: staff_id,
                fac_id: fac_id,
                year_id: year_id,
                record: record,
            }).then(res => {     
                // console.log(res.data);    
                if(res.data.length > 0){
                    const data = res.data[0];
                    this.coreCompetencies.forEach(item => {
                        if (item.id === 1) {
                            item.data_table1 = data.p1??0;  // Update based on the API response
                        } else if (item.id === 2) {
                            item.data_table1 = data.p2??0;  // Update based on the API response
                        } else if (item.id === 3) {
                            item.data_table1 = data.p3??0;  // Add more conditions if necessary
                        } else if (item.id === 4) {
                            item.data_table1 = data.p4??0;  // Add more conditions if necessary
                        } else if (item.id === 5) {
                            item.data_table1 = data.p5??0;  // Add more conditions if necessary
                        }
                    });

                    this.jobSpecificCompetencies.forEach(item => {
                        if (item.id === 6) {
                            item.data_table2 = data.p6??0;  // Update based on the API response
                        } else if (item.id === 7) {
                            item.data_table2 = data.p7??0;  // Update based on the API response
                        } else if (item.id === 8) {
                            item.data_table2 = data.p8??0;  // Add more conditions if necessary
                        } else if (item.id === 9) {
                            item.data_table2 = data.p9??0;  // Add more conditions if necessary
                        } else if (item.id === 10) {
                            item.data_table2 = data.p10??0;  // Add more conditions if necessary
                        } else if (item.id === 11) {
                            item.data_table2 = data.p11??0;  // Add more conditions if necessary
                        }
                    });

                    // Update other fields
                    this.improvements = data.improvements??'- ไม่มีข้อมูล -';
                    this.suggestions = data.suggestions??'- ไม่มีข้อมูล -';
                }
                
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        chkp04dataT4(staff_id,fac_id,year_id,record){
            axios.post('http://localhost:8000/api/showData04Tab3',{
                staff_id: staff_id,
                fac_id: fac_id,
                year_id: year_id,
                record: record,
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
table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}
.bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
  .card-header {
      text-align: left; /* Aligns text to the left */
      margin: 0; /* Removes default margins */
      padding: 0; /* Removes default padding */
  }
 
  .table th, .table td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: center;
  }
  .table th {
      background-color: #f4f4f4;
      font-weight: bold;
  }
  .signatures {
    display: flex;
    justify-content: space-between; 
    align-items: flex-start;  
    gap: 20px;  
}

  /*เพิ่ม  จากtracking.vue*/

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
  background-color: #edf2bb;
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