<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-star" style="font-size: x-large;"></i> ตรวจสอบ แบบประเมิน</h3>    
                    </div> 
                    <!-- {{ productstaff[0].prefixfullname  }} -->
                    <div class="col md:col-5" >   
                        <Dropdown id="examine_date" v-model="examine_date" :options="examine_dates"  :optionLabel="(item) => `${item.d_evaluationround} ${item.d_date}`" placeholder="กรุณาเลือกรอบการประเมิน" style=" max-width: 500px; width: 100%" ></Dropdown> 
                    </div>   
                    <div class="col md:col-1" >  
                        <Button class="mb-2 mr-2" icon="pi pi-search" @click="xxr" /> 
                    </div>  
                </div> 
                <!-- {{ products }}  -->
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
                            <td style="padding-left: 5px;width: 40%;text-align: left;">
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b> &nbsp;&nbsp;
                                <Tag v-if="Item.countchk==2 " severity="success" style="font-size: small;">อนุมัติ</Tag>
                                <Tag v-if="Item.countchk==3 " severity="danger" style="font-size: small;">ไม่ผ่าน</Tag> 
                            </td>
                            <td style="padding-left: 5px;width: 25%;"><b>{{ Item.posnameth }}</b></td>
                            <td style="text-align: center;width: 20%;">   
                                <div v-if="Item.tb_tor">
                                    <Button icon="pi pi-check" label="อนุมัติ" rounded class="mb-2 mr-2" size="small" @click="Btnstatus(Item.staffid,2)" />
                                    <Button icon="pi pi-times" severity="danger" label="ไม่ผ่าน" rounded class="mb-2 mr-2" size="small" @click="Btnstatus(Item.staffid,3)"  /> 
                                </div>
                                <div v-else>-</div>  
                            </td>
                            <td style="text-align: center;width: 15%;">   
                            <!-- 28 / 11 / 67
                                <div v-if="Item">
                                    <Button severity="info" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                                </div>
                                <div v-else>
                                    <p style="color: brown;">-รอข้อมูลการประเมิน-</p>
                                </div>  
                            --> 
                                <div v-if="Item.tb_tor">
                                    <Button 
                                        label="รายละเอียด" 
                                        severity="info"
                                        class="mb-2 mr-2" 
                                        icon="pi pi-list" 
                                        @click="openDataEvalu(Item.staffid)" 
                                    />  
                                </div>
                                <div v-else>
                                    <p style="color: brown;">-รอข้อมูลการประเมิน-</p> 
                                </div> 
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
                        <TabPanel header="แบบใบปะหน้า">
                            <!-- <div class="col md:col-12 text-right">
                                    <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP01"></Button>
                                </div> -->
                                <div class="card">
                                    <h3 class="mb-4" style="text-align: right;">
                                        <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01-02
                                </h3>
                                <div style="display: flex; justify-content: center;">
                                    <img src="~/assets/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
                                </div>
                                <h4 style="text-align: center;">
                                    แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม
                                </h4><br>
                                <!-- ตาราง ก. สมรรถนะหลัก -->
                                <div class="employee-info">
                                    <p><strong>ผู้ปฏิบัติงาน:</strong> {{ currentstaff[0].prefixfullname }} {{ currentstaff[0].staffname }} {{   currentstaff[0].staffsurname }}</p>
                                    <p v-if="currentstaff[0].facultyid==201092700000"><strong>สังกัด:</strong> {{ currentstaff[0].departmentname }} </p>
                                    <p v-else><strong>สังกัด:</strong> {{ currentstaff[0].facultyname }} </p>
                                    <p><strong>ตำแหน่ง:</strong> {{ currentstaff[0].posnameth }} </p>
                                    <p><strong>ระดับตำแหน่ง:</strong>{{ currentstaff[0].postypenameth }}</p>
                                    <!-- <p><strong>ประเภทบุคลากร:</strong></p> -->
                                    <p><strong>ชื่อผู้ประเมิน:</strong> {{ assessorText }}</p> 
                                    <p><strong>ตำแหน่งผู้ประเมิน :</strong>{{ assessor_positionText }}</p> 
                                    <p><strong>รายละเอียดข้อตกลง ระหว่าง วันที่ :</strong> {{ examine_date.d_evaluationround }} {{ examine_date.d_date }}</p>
                                </div><br> 
                                <div class="explanation">
                                    <h4>คำชี้แจง</h4>
                                    <p>
                                        1. แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ  (Term of Reference : TOR) ข้าราชการและพนักงาน  สังกัดมหาวิทยาลัยมหาสารคามนี้ เป็นการกำหนด
                                            แผนการปฏิบัติงานของผู้ปฏิบัติงานในมหาวิทยาลัยมหาสารคาม ซึ่งเป็นข้อตกลงร่วมกับผู้บังคับบัญชาก่อนเริ่มปฏิบัติงาน
                                    </p>
                                    <p>
                                        2. การกำหนดข้อตกลงร่วม ผู้ปฏิบัติงานจะต้องกรอกรายละเอียดภาระงานโดยสังเขปในส่วนของภาระงานตามหน้าที่ความรับผิดชอบของตำแหน่ง และ/หรือภาระงาน
                                            ด้านอื่นๆ พร้อมกำหนดตัวชี้วัดความสำเร็จของภาระงานแต่ละรายการ  ตลอดจนค่าเป้าหมาย และค่านำหนักร้อยละ สำหรับในส่วนของพฤติกรรมการปฏิบัติราชการ
                                            (สมรรถนะ) ให้ระบุระดับสมรรถนะค่ามาตรฐาน
                                    </p>
                                    <p>
                                        3. สำหรับการกรอกรายละเอียดภาระเอียดภาระงานตามภารกิจ  ให้อ้างอิงการคำนวณภาระงานขั้นต่ำตามหลักเกณฑ์กรอบมาตรฐานภาระงานที่แนบท้ายประกาศ ก.บ.ม. 
                                            มหาวิทยาลัยมหาสารคาม ที่บังคับใช้สำหรับการประเมินผลการปฏิบัติราชการ

                                    </p>
                                    <p>
                                        4. การกำหนดตัวชี้วัดความสำเร็จของงาน  ทั้งในส่วนของเชิงปริมาณและเชิงคุณภาพ  ให้เป็นการกำหนดข้อตกลงภายในหน่วยงานนั้นๆ 
                                    </p>
                                    <p>
                                        5. การจัดทำข้อตกลงภาระงานดังกล่าวนี้  เพื่อใช้เป็นกรอบในการประเมินผลการปฏิบัติราชการ  เพื่อประกอบการเลื่อนเงินเดือนและค่าจ้างในแต่ละรอบการประเมิน
                                    </p>
                                </div> 
                            </div>
                        </TabPanel>

                        <TabPanel header="รายงาน ป.01 - ป.03" >
                            <div class="grid">
                                <div class="col-12 lg:col-12 xl:col-12">
                                    <div class="card mb-0"> 
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th rowspan="2" style="width: 19%;">กิจกรรม / โครงการ / งาน</th>
                                                    <th rowspan="2" style="width: 25%;">ตัวชี้วัด / เกณฑ์การประเมิน</th>
                                                    <th rowspan="2" style="width: 20%;">รางานการปฏิบัติราชการ<br> ตามตัวชี้วัด/เกณฑ์การประเมิน</th>
                                                    <th rowspan="2" style="width: 25%;">หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์)</th>
                                                    <th colspan="5" style="width: 15%;">ระดับค่าเป้าหมาย</th> 
                                                    <th rowspan="2" style="width: 10%;">ค่าคะแนนที่ได้</th>
                                                    <th rowspan="2" style="width: 10%;">น้ำหนัก(ความสำคัญ/ความยากง่ายของงาน)</th>
                                                    <th rowspan="2" style="width: 10%;">ค่าคะแนนถ่วงน้ำหนัก<br>(4) X (5)<br> 100</th>
                                                    
                                                </tr>
                                                <tr>
                                                    <th>1</th>
                                                    <th>2</th>
                                                    <th>3</th>
                                                    <th>4</th>
                                                    <th>5</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <template v-for="(h, ind) in products_Tab2" :key="ind">
                                                    <tr>
                                                        <td style="text-align: left;" colspan="12">
                                                            <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b> 
                                                        </td> 
                                                    </tr> 
                                                    <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                                                        <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                                        <td style="text-align: left;">
                                                            <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                                            <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                                <div v-if="subIitem.ind_no!=0" ><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                                                <div v-if="subIitem.ind_no==0" ><b>{{ subIitem.ind_Items }}</b></div>
                                                            </p>
                                                            <p v-if="subP01.p01_detail != null">
                                                                
                                                                <b style="color: red;">ข้อเสนอแนะ</b>
                                                                <br>
                                                                <em style="color: red;">{{ subP01.p01_detail }}</em>
                                                            </p>
                                                        </td>

                                                        <td style="text-align: left;">
                                                            <p v-for="(subIitemInd, inD) in subP01.subITemP03ind" :key="inD" style="padding-left: 8px;margin-bottom: 5px;">
                                                                <div v-if="subIitemInd.p03ind_no!=0"><b>ระดับ {{ subIitemInd.p03ind_no }}</b> {{ subIitemInd.p03ind_Items }}</div>
                                                                <div v-if="subIitemInd.p03ind_no==0"><b>{{ subIitemInd.p03ind_Items }}</b></div> 
                                                            </p>
                                                            <p v-if="subP01.subITemP03ind.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                            </p>  
                                                        </td>
                                                        
                                                        <td style="text-align: left;"> 
                                                            <p v-for="(subIitemDoc, inDoc) in subP01.subITemP03doc" :key="inDoc" style="padding-left: 8px;margin-bottom: 5px;"> 
                                                                <a v-if="subIitemDoc.doc_file!=null" :href="'http://localhost:8000/storage/uploadsP03/'+subIitemDoc.doc_file" target="_blank"><b>ระดับ</b> <b>{{subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                <a v-if="subIitemDoc.doc_link!=null" :href="subIitemDoc.doc_link" target="_blank"><b>ระดับ</b> <b>{{ subIitemDoc.p03ind_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                            </p>
                                                            <p v-if="subP01.subITemP03doc.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                            </p>
                                                        </td>  
                                                        <td style=" vertical-align: middle;" class="text-center">
                                                            <b v-if="subP01.p01_target==1">&#10003;</b> 
                                                            <b v-if="subP01.p01_target!=1"></b> 
                                                        </td>
                                                        <td style=" vertical-align: middle;" class="text-center">
                                                            <b v-if="subP01.p01_target==2">&#10003;</b> 
                                                            <b v-if="subP01.p01_target!=2"></b> 
                                                        </td>
                                                        <td style=" vertical-align: middle;" class="text-center">
                                                            <b v-if="subP01.p01_target==3">&#10003;</b> 
                                                            <b v-if="subP01.p01_target!=3"></b> 
                                                        </td>
                                                        <td style=" vertical-align: middle;" class="text-center"> 
                                                            <b v-if="subP01.p01_target==4">&#10003;</b> 
                                                            <b v-if="subP01.p01_target!=4"></b> 
                                                        </td>  
                                                        <td style=" vertical-align: middle;" class="text-center"> 
                                                            <b v-if="subP01.p01_target==5">&#10003;</b> 
                                                            <b v-if="subP01.p01_target!=5"></b> 
                                                        </td>
                                                            <!-- เพิ่มตารางช่องค่าคะแนน -->
                                                        <td style=" vertical-align: middle;" class="text-center">{{ subP01.p01_score }}</td>
                                                        <td style=" vertical-align: middle;" class="text-center">{{ subP01.p01_weight }}%</td> 
                                                        <td style=" vertical-align: middle;" class="text-center">{{ (subP01.p01_score * subP01.p01_weight / 100).toFixed(2) }}</td>
                                                    </tr>
                                                    </template>
                                                    <tr>
                                                        <td style="text-align: right" colspan="9">
                                                            <b style="color: blue;">(7) ผลรวม</b>
                                                        </td>
                                                        <td class="text-center" style="color: blue;">
                                                                <b>{{ totalscoretrack }}</b> <!-- แสดงผลรวม p01_weight -->
                                                            </td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalWeighttrack }}%</b> <!-- แสดงผลรวม p01_weight -->
                                                            </td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ WeightedScoreSumtrack }}</b> <!-- แสดงผลรวมคะแนนที่คำนวณ -->
                                                            </td> 
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right; vertical-align: middle;" colspan="10">
                                                            <b style="color: blue;">(8) สรุปคะแนนส่วนผลสัมฤทธิ์ของงาน =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                            <b style="color: blue;">ผลรวมของค่าคะแนนถ่วงน้ำหนัก</b>
                                                            <div style="display: flex; justify-content: flex-end;">
                                                                <hr style="border: 1px solid black; width: 16%;">
                                                            </div>
                                                            <b style="color: blue;">จำนวนระดับค่าเป้าหมาย = 5 </b>
                                                        </td>
                                                        <td class="text-center" style="color: blue;  vertical-align: middle;">
                                                            <b>{{ WeightedScoreSumX }}</b> <!-- แสดงผลรวม/จำนวนระดับเป้าหมาย -->
                                                        </td>
                                                        <td class="text-center" style="color: blue;  vertical-align: middle;">
                                                            <b>{{ WeightedScoreSumXT }}</b> <!-- แสดงผลรวม/จำนวนระดับเป้าหมาย -->
                                                        </td>
                                                    </tr>  
                                                </tbody>
                                            </table>
                                        <hr>
                                        <div class="p-fluid formgrid grid">
                                            <!-- ตาราง ก. สมรรถนะหลัก -->
                                            <div class="field col-12 md:col-4"> 
                                                <table id="ratingTable">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 50%;">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                                                            <th style="width: 20%;">(1)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                                                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th> 
                                                            <th style="width: 20%;">(2)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(row1, index) in coreCompetencies" :key="index">
                                                            <td style="text-align: left;">{{ row1.activity }}</td> 
                                                            <td>{{ row1.indicator }}</td>
                                                            <!-- <td style="color: blue"><b>{{ row1.selfAssessment }}</b></td> -->
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
                                                            <td style="text-align: left;">ข. {{ index+6 }} {{ row2.WORK_NAME }}</td> 
                                                            <td>{{ row2.COMPLEVEL }}</td>
                                                            <!-- <td style="color: blue"><b>{{ row2.SCORESUM }}</b></td> -->
                                                            <td>  
                                                                <b v-if="row2.SCORESUM == '' ||  row2.SCORESUM == null" style="color: red;">0</b> 
                                                                <b v-if="row2.SCORESUM != 0 " style="color: blue" >{{ row2.SCORESUM }}</b> 
                                                            </td>
                                                            <td>
                                                                <b v-if="row2.SCORE == null ||row2.SCORE == '' "  style="color: red;">0</b> 
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
                                                            <th style="width: 50%;">ค. สมรรถนะทางการบริหาร (สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                                                            <th style="width: 20%;">(5)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                                                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th> 
                                                            <th style="width: 20%;">(6)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(row3, index) in otherCompetencies" :key="index">
                                                            <td style="text-align: left;">{{ row3.activity }}</td> 
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                        <!-- เกณฑ์การประเมิน -->
                                        
                                        <thead>
                                                <tr>                                                       
                                                    <th rowspan="9" style="width: 90%;">เกณฑ์การประเมิน</th>
                                                    <th colspan="3" style="width: 10%;">การประเมิน</th> 
                                                </tr>
                                                <tr>
                                                    <th>จำนวน <br>สมรรถนะ</th>
                                                    <th>คูณด้วย</th>
                                                    <th>คะแนน</th>
                                                </tr>
                                        </thead>
                                            <tbody>
                                                <tr>
                                                    <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก สูงกว่าหรือเท่ากับ ระดับสมรรถนะที่คาดหวัง X 3 คะแนน</td>
                                                        <td class="text-center" style="color: blue;"> 
                                                            <b>{{ totalCoreCompetencies }}</b>  
                                                        </td> 
                                                        <td class="text-center" style="color: blue;"><b>3</b></td>   
                                                        <td class="text-center" style="color: blue;">
                                                            <b>{{ totalScoreSum }}</b>  
                                                        </td>                                                      
                                                </tr>
                                                <tr>
                                                    <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน</td>
                                                        <td class="text-center" style="color: blue;">
                                                            <b>{{ totallowScores }}</b> 
                                                        </td>
                                                        <td class="text-center" style="color: blue;"><b>2</b></td> 
                                                        <td class="text-center" style="color: blue;">
                                                            <b>{{ totalScorelowSum }}</b>  
                                                        </td>
                                                </tr>
                                                <tr>
                                                    <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน</td>
                                                        <td class="text-center" style="color: blue;"><b>0</b></td> 
                                                        <td class="text-center" style="color: blue;"><b>1</b></td> 
                                                        <td class="text-center" style="color: blue;"><b>0</b></td>
                                                </tr>
                                                <tr>
                                                    <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน</td>
                                                        <td class="text-center" style="color: blue;"><b>0</b></td> 
                                                        <td class="text-center" style="color: blue;"><b>0</b></td> 
                                                        <td class="text-center" style="color: blue;"><b>0</b></td> 
                                                </tr>
                                                <tr>
                                                    <td style="text-align: right" colspan="3">
                                                        <b style="color: blue;"> (8) ผลรวม</b>
                                                    </td>
                                                        <td class="text-center" style="color: blue;"> 
                                                            <b>{{ totalScoreSum+totalScorelowSum }}</b>  
                                                        </td>
                                                    
                                                </tr>
                                                <tr>
                                                    <td style="text-align: center; vertical-align: middle;" colspan="3">
                                                        <b style="color: blue;">(9) สรุปคะแนนส่วนพฤติกรรมการปฏิบัติราชการ   (สมรรถนะ) =	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                        <b style="color: blue;">  ผลรวมคะแนน ใน (8)</b>
                                                        <b style="display: block; text-align: right; color: blue;">{{ totalScoreSum + totalScorelowSum }}</b>   
                                                        <div style="display: flex; justify-content: flex-end;"> 
                                                            <hr style="border: 1px solid black; width: 70%;">
                                                        </div> 
                                                        <b style="display: block; text-align: right; color: blue;">{{ 33}}</b>
                                                        <b style="color: blue;">จำนวนสมรรถนะที่ใช้ในการประเมิน X 3 คะแนน</b>  
                                                    </td> 
                                                    <td class="text-center" style="color: blue;"> 
                                                         <b> = {{ ((totalScoreSum + totalScorelowSum) / 33).toFixed(2) }}</b>  
                                                    </td> 
                                                </tr>  
                                            </tbody>
                                                <br>
                                                <div class="p-fluid formgrid grid"> 
                                                    <B><h4>ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</h4></B>
                                                    <div class="field col-12 md:col-12">  
                                                        <label for="improvements">1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</label>
                                                        <p style="margin-left: 20px;">{{ improvements??'- ไม่มีข้อมูล -' }}</p>
                                                    </div>
                                                    <div class="field col-9 md:col-9">  
                                                        <label for="suggestions">2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</label>
                                                        <p style="margin-left: 20px;">{{ suggestions??'- ไม่มีข้อมูล -' }}</p> 
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
                                                <p><strong>รอบการประเมิน:</strong> {{ examine_date.d_evaluationround }} {{ examine_date.d_date }}</p>
                                                <p><strong>ชื่อผู้รับการประเมิน:</strong>  {{ currentstaff[0].prefixfullname }} {{ currentstaff[0].staffname }} {{   currentstaff[0].staffsurname }} </p>
                                                <p><strong>ตำแหน่ง:</strong> {{ currentstaff[0].posnameth }} </p>
                                                <p><strong>ระดับตำแหน่ง:</strong>{{ currentstaff[0].postypenameth }}</p>
                                                <p v-if="currentstaff[0].facultyid==201092700000"><strong>สังกัด:</strong> {{ currentstaff[0].departmentname }} </p>
                                                <p v-else><strong>สังกัด:</strong> {{ currentstaff[0].facultyname }} </p>
                                                <p><strong>ชื่อผู้ประเมิน:</strong> {{ assessorText??'-' }}</p>
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
                                                                <b>{{ 100}}%</b>  
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> 
                                                                {{ showscoresum.sum_score }}
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                            </table>
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
                                                            ชื่อ {{ currentstaff[0].prefixfullname }} {{ currentstaff[0].staffname }} {{   currentstaff[0].staffsurname }}<br>
                                                            ตำแหน่ง {{ currentstaff[0].posnameth }}<br>
                                                            วันที่ .......... เดือน .......................... พ.ศ.
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <b>ผู้ประเมิน</b><br>
                                                            <label for="evaluator-acknowledgment-1">[ &nbsp;&nbsp; ] ได้แจ้งผลการประเมินและผู้รับการประเมินได้ลงนามรับทราบ รายบุคคลแล้ว</label><br>
                                                            <label for="evaluator-acknowledgment-2">[ &nbsp;&nbsp; ] ได้แจ้งผลการประเมินเมื่อวันที่ ..............................แต่ผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน โดยมี .......................... เป็นพยาน</label><br>
                                                            ลงชื่อ .................................................................<br>
                                                            ชื่อ {{assessorText}}<br>
                                                            ตำแหน่ง {{assessor_positionText}}<br>
                                                            วันที่ .......... เดือน .......................... พ.ศ...........
                                                        </td>
                                                    <td class="center-align"><br><br>
                                                        ลงชื่อ .................................................................<br>
                                                        ชื่อ {{assessorText}}<br>
                                                        ตำแหน่ง {{assessor_positionText}}<br>
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
                                                        ชื่อ : {{ currentstaff[0].prefixfullname }} {{ currentstaff[0].staffname }} {{   currentstaff[0].staffsurname }}<br>
                                                        ตำแหน่ง : {{ currentstaff[0].posnameth }}<br>
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
                                                            ชื่อ {{assessorText}}<br>
                                                            ตำแหน่ง {{assessor_positionText}}<br>
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
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '', data_table1: '',selfAssessment:''},
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '', data_table1: '',selfAssessment:''},
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '', data_table1: '',selfAssessment:''},
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '', data_table1: '',selfAssessment:''},
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '', data_table1: '',selfAssessment:''}
            ],
            jobSpecificCompetencies: [],
            otherCompetencies: [
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
            examine_dates: null, 
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
            totalCoreCompetencies:0,
            totallowScores:{},
            totalScoreSum:{},
            totalScorelowSum:{},
            totalScoreFinalSum:{},
            //ชื่อผู้ประเมิน ตำแหน่งผู้ประเมิน
            assessorText: null,
            assessor_positionText: null,
            showscoresum:{}, 
            currentstaff: {},
          
        };
    },
        
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID, staffdepartment, groupid, user.user.name.POSTYPENAME, user.user.name.POSITIONNAMEID);  
        // this.showDataEvalu();  
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
            const maxLength = Math.max(this.coreCompetencies.length, this.jobSpecificCompetencies.length);
            let total = 0;

            //กกกกก
            for (let i = 0; i < this.coreCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.coreCompetencies[i]?.indicator) || 0;
                const dataTable2Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;
                // // ตรวจสอบเงื่อนไขและเพิ่มค่า T1 ถ้าเงื่อนไขเป็นจริง
                if ((dataTable1Value - dataTable2Value) <= 0) {
                    total++;
                }
            } 
            //ขขข
            for (let i = 0; i < this.jobSpecificCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.jobSpecificCompetencies[i]?.COMPLEVEL) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[i]?.SCORE) || 0;

                // // ตรวจสอบเงื่อนไขและเพิ่มค่า T1 ถ้าเงื่อนไขเป็นจริง
                if ((dataTable1Value - dataTable2Value) <= 0) {
                    total++;
                }
            } 
            
            //คคค
            for (let i = 0; i < maxLength; i++) {
                // const dataTable1Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;
                // const dataTable2Value = parseFloat(this.jobSpecificCompetencies[i]?.SCORE) || 0;

                // // // ตรวจสอบเงื่อนไขและเพิ่มค่า T1 ถ้าเงื่อนไขเป็นจริง
                // if ((dataTable1Value - dataTable2Value) <= 0) {
                //     total++;
                // }
            } 

            return total;
        },
            //รวมช่องค่าที่ต่ำกว่าสมรรถนะ
        totallowScores() { 
            let total1 = 0; // Initialize total1
            let total2 = 0; // Initialize total2

            // ตรวจสอบเงื่อนไขแรก: data_table1 น้อยกว่า indicator
            for (let i = 0; i < this.coreCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.coreCompetencies[i]?.indicator) || 0;
                const dataTable2Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;
                if (dataTable2Value < dataTable1Value) {
                    total1++; // Increment total1 when condition is met
                }
            }

            // ตรวจสอบเงื่อนไขที่สอง: COMPLEVEL น้อยกว่า SCORE
            for (let j = 0; j < this.jobSpecificCompetencies.length; j++) {
                const dataTable1Value = parseFloat(this.jobSpecificCompetencies[j]?.COMPLEVEL) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[j]?.SCORE) || 0;
                if (dataTable2Value < dataTable1Value) {
                    total2++; // Increment total2 when condition is met
                }
            } 
            // รวมผลลัพธ์ทั้งต่ำกว่าสมรรถนะที่คาดหวัง
            return total1 + total2 ;  
        },
        //รวมคะแนนจำนวนสมรรถนะ*3
        totalScoreSum() {
            let total = 0;  
                // ตรวจสอบและนับค่าจาก coreCompetencies
                for (let i = 0; i < this.coreCompetencies.length; i++) {
                    const dataTable1Value = parseFloat(this.coreCompetencies[i]?.indicator) || 0;
                    const dataTable2Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;

                    if ((dataTable1Value - dataTable2Value) <= 0) {
                        total++;
                    }
                } 
 
                // ตรวจสอบและนับค่าจาก jobSpecificCompetencies
                for (let i = 0; i < this.jobSpecificCompetencies.length; i++) {
                    const dataTable1Value = parseFloat(this.jobSpecificCompetencies[i]?.COMPLEVEL) || 0;
                    const dataTable2Value = parseFloat(this.jobSpecificCompetencies[i]?.SCORE) || 0;

                    if ((dataTable1Value - dataTable2Value) <= 0) {
                        total++;
                    }
                } 
                // คูณค่ารวมทั้งหมดด้วย 3
            return total * 3;
        }, 
        totalScoreSumX() {     
            return this.coreCompetencies.reduce((sum, row, index) => { 
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0;  
                return sum + (dataTable1Value * 3) + (dataTable2Value * 3);
            }, 0);
        },  
        totalScorelowSum() { 
            let total1 = 0;  
            let total2 = 0;  
            for (let i = 0; i < this.coreCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.coreCompetencies[i]?.indicator) || 0;
                const dataTable2Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;
                if (dataTable2Value < dataTable1Value) {
                    total1++;  
                }
            } 
            for (let j = 0; j < this.jobSpecificCompetencies.length; j++) {
                const dataTable1Value = parseFloat(this.jobSpecificCompetencies[j]?.COMPLEVEL) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[j]?.SCORE) || 0;
                if (dataTable2Value < dataTable1Value) {
                    total2++; 
                }
            } 
            // รวมผลลัพธ์ทั้งต่ำกว่าสมรรถนะที่คาดหวัง *2
            return ((total1 + total2) * 2);  
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
        xxr() {
            if (this.examine_date.evalua === undefined) {
                Swal.fire({
                    title: 'แจ้งเตือนจากระบบ!',
                    text: 'กรุณาเลือก รอบประเมิน ก่อน!',
                    icon: 'error'
                });
            } else { 
                this.showDataEvalu();
            }
        },
        async showDataEvalu(){
            await axios.get('http://localhost:8000/api/showDataEvalu',{
                // 28 / 11 / 67
                // params: {
                //     staff_id: this.staffid_Main,
                //     fac_id: this.facid_Main, 
                //     group_id: this.groupid_Main
                // },
                params: {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main,
                    evalua: this.examine_date.evalua,
                    p_year: this.examine_date.d_date 

                }
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
                //console.log(res.data);  
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
                this.currentstaff = this.products.filter((product) => product.staffid === this.dataStaffid);
                this.products_Tab2 = []; 
                // ตั้งค่า coreCompetencies กลับไปเป็นค่าเริ่มต้น
                let postypetext = `ระดับ${this.currentstaff[0].postypenameth}`;
            const levelMapping = {
                'ระดับปฏิบัติการ': 1,
                'ระดับชำนาญการ': 2,
                'ระดับชำนาญการพิเศษ': 3,
                'อาจารย์': 3,
                'ระดับเชี่ยวชาญ': 4,
                'ระดับเชี่ยวชาญพิเศษ': 5
            };
            let xr = levelMapping[postypetext] || 0;
                this.coreCompetencies = [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: xr, data_table1: '',selfAssessment:''},
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: xr, data_table1: '',selfAssessment:''},
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: xr, data_table1: '',selfAssessment:''},
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: xr, data_table1: '',selfAssessment:''},
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: xr, data_table1: '',selfAssessment:''}
            ];  
                
                // ตั้งค่า jobSpecificCompetencies กลับไปเป็นค่าเริ่มต้น
                this.showPostype(this.currentstaff[0].postypenameth,this.postypenameid); 
                // this.jobSpecificCompetencies = [
                //     { id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
                //     { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
                //     { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
                //     { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
                //     { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
                //     { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
                // ]; 
                this.improvements = null;
                this.suggestions = null;

            }
        },  
        onTabChange(event) { 
            // console.log(event.index);
            if (event.index==0) {
                //console.log('แบบใบปะหน้า -',event.index); 
            }
            if(event.index==1){
                //console.log('รายงาน ป.01 - ป.03 -',event.index);  
                this.tab2Data(this.dataStaffid);  
                this.showdataPoText(this.dataStaffid,this.facid_Main,this.examine_date.d_date,this.examine_date.evalua); 
            } 
            if (event.index==2) {
                //console.log('รายงาน ป.04 -',event.index);
                this.chkp04dataT4(this.dataStaffid,this.facid_Main,this.examine_date.d_date,this.examine_date.evalua); 
                this.showdatator();
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
        showdatator(dataStaffid) {   
            axios.post('http://localhost:8000/api/showdatator', {
                p_year: this.examine_date.d_date,
                evalua: this.examine_date.evalua,
                p_staffid: this.dataStaffid
            })
            .then(res => {
                 //console.log('Response',res.data);  
                this.assessorText = res.data[0].assessor; 
                this.assessor_positionText = res.data[0].assessor_position;
                this.showscoresum = res.data[0]  
            })
            .catch(error => {
                //console.error('Error fetching data:', error);
            });
        },
        getjobSpecificCompetencies(dataStaffid) {
            axios.post('http://localhost:8000/api/showdataposp02', {
                p_year: this.examine_date.d_date,
                evalua: this.examine_date.evalua,
                p_staffid: this.dataStaffid
            }).then(res => {
                if (res.data && res.data[0]) {
                    for (let i = 0; i < this.jobSpecificCompetencies.length; i++) {
                        const jobData = res.data[0];
                        // ตรวจสอบและกำหนดค่าให้ jobSpecificCompetencies
                        this.jobSpecificCompetencies[i]['SCORE'] = jobData[`p${i + 6}`] ?? 0; // ค่าเริ่มต้น 0 หากไม่มีข้อมูล
                        this.jobSpecificCompetencies[i]['SCORESUM'] = jobData[`pa_${i + 6}`] ?? 0;

                        // ตรวจสอบและกำหนดค่าให้ coreCompetencies
                        if (this.coreCompetencies[i]) {
                            this.coreCompetencies[i]['selfAssessment'] = jobData[`pa_${i + 1}`] ?? 0;
                        } else {
                            console.warn(`Missing coreCompetencies index ${i}`);
                        }
                    }
                } else {
                    console.warn('Invalid response data from API:', res.data);
                }
            }).catch(error => {
               // console.error('Error fetching data:', error);
            });
        }, 
        async showPostype(postypename,postypenameid){
            // console.log(postypename); 
            var postypetext = `ระดับ`+postypename;
           await axios.post('http://localhost:8000/api/showdatapostypename', {
                postypename: postypetext,
                postypenameid: postypenameid
            })
            .then(res => {
                //console.log('Response',res.data);  
                if (res.data.length > 0) { 
                    this.jobSpecificCompetencies = res.data; 
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
                 }  
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
           await this.getjobSpecificCompetencies(); 
        },
        // async printDataP01() {     
        //     const form = {
        //         staff_id: this.staffid_Main,
        //         group_id: this.groupid_Main,
        //         fac_id: this.facid_Main,
        //         year_id: this.examine_date.d_date,
        //         evalua: this.examine_date.evalua   
        //     }

        //     const queryParams = new URLSearchParams(form).toString();
        //     // console.log(queryParams); 
        //     const url = `http://localhost:8000/printReportCoverpage?${queryParams}`;
        //     window.open(url, '_blank');
 
        // }, 
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