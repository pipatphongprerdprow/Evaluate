<template> 
    <div class="grid"> 
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-5"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-star" style="font-size: x-large;"></i> ตรวจสอบ แบบประเมิน</h3>    
                    </div>
                    <!-- {{ products }}  -->

                    <!-- {{ user.user }}     -->

                    <!-- <div class="col md:col-3" >  
                         
                        <label for="tracking_date"></label>
                        <Dropdown  v-model="tracking_fac" :options="tracking_facuty"  optionLabel="label" placeholder="กรุณาเลือกเลือกคณะ" style="max-width: 500px; width: 100%"/> 
                    </div>  -->
                    <div class="col md:col-5" >  
                        <!-- <h3 class="mb- card-header"><i class="" style="font-size: x-large;"></i> ปีงบประมาณ: {{ tracking_date.d_date }}</h3>   -->
                        <label for="tracking_date"></label>
                        <!-- {{ tracking_dates }} -->
                         
                        <Dropdown v-model="tracking_date" :options="tracking_dates" :optionLabel="(item) => `${item.facuties} ${item.d_evaluationround} ${item.d_date}`" placeholder="กรุณาเลือกรอบการประเมิน" style=" max-width: 500px; width: 100%"></Dropdown> 
                    </div> 
                    <div class="col md:col-1" >  
                        <Button class="mb-2 mr-2" icon="pi pi-search" @click="xxr" /> &nbsp; &nbsp; &nbsp; &nbsp;   
                        <!-- <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDatatracking"></Button> -->
                    </div> 
                </div>  
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th style="width: 40%;">ผู้รับการประเมิน</th>  
                            <th>ตำแหน่ง</th>   
                            <th>ประเมิน</th> 
                        </tr>
                    </thead>
                    <tbody>
                        
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 30%;text-align: left;">   
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b> 
                            </td>  
                            <td class="text-center" style="color: blue;"><b>{{ Item.posnameth ? Item.posnameth: '' }} </b></td>  
                            <td style="text-align: center;width: 10%;">  
                                <div v-if="Item.tb_tor">
                                    <Button 
                                        label="รายละเอียด" 
                                        severity="info"
                                        class="mb-2 mr-2" 
                                        icon="pi pi-list" 
                                        @click="openDataEvalu(Item)" 
                                        style="width: 130px;" 
                                    />  
                                </div> 
                                <div v-else>
                                    <p style="color: brown;">-รอข้อมูลการประเมิน-</p>
                                </div> 
                            </td> 
                        </tr>

                    </tbody> 
                </table>    
                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw',height: '100vh' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3 style="text-align: left;">รายงานแบบประเมิน ป01-ป04</h3> 
                            <InputText v-model="dataStaffid" type="hidden" autocomplete="off" style="display: none;"/> 
                           <!-- <p v-if="currentstaff?.length"> <strong>ชื่อผู้รับการประเมิน:</strong>  {{ currentstaff[0]?.prefixfullname || '-' }}  {{ currentstaff[0]?.staffname || '-' }}  {{ currentstaff[0]?.staffsurname || '-' }} </p> -->
                           <p v-if="currentstaff?.length">
                            <strong>ชื่อผู้รับการประเมิน:</strong> {{ currentstaff?.[0]?.prefixfullname || '-' }} {{ currentstaff?.[0]?.staffname || '-' }} {{ currentstaff?.[0]?.staffsurname || '-' }}
                            </p>
                        </template>  
                        <TabView :activeIndex="activeIndex" @tabChange="onTabChange"> 
                            <!-- Tab 1 -->

                            <TabPanel header="แบบใบปะหน้า"> 
                                    <div class="col md:col-12 text-right">
                                        <Button label="Export_ใบปะหน้า" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDatacoversheet"></Button>
                                    </div> 
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
                                        <strong>ระดับตำแหน่ง:</strong> {{ currentstaff[0]?.posnameth=='ผู้บริหาร'&& !currentstaff[0]?.postypenameth   ? 'ชำนาญการพิเศษ' : currentstaff[0]?.postypenameth}} 
                                        <p><strong>ชื่อผู้ประเมิน:</strong> {{ assessorText }}</p> 
                                        <!-- {{ staff_po }} -->
                                        <p><strong>ตำแหน่งผู้ประเมิน :</strong>{{ assessor_positionText }}</p> 
                                        <p><strong>รายละเอียดข้อตกลง ระหว่าง วันที่ :</strong> {{ tracking_date.d_evaluationround }} {{ tracking_date.d_date }}</p>
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

                            <!-- Tab 2 -->
                            <TabPanel header="รายงาน ป.01 - ป.03" >
                                 <div class="col-12 text-right">
                                    <Button label="Export_ป.01" icon="pi pi-file-word" class="mr-2 mb-2" @click="printDataP01" />
                                    <Button label="Export_ป.02" icon="pi pi-file-word" class="mr-2 mb-2" @click="printDataP02" />
                                    <Button label="Export_ป.03" icon="pi pi-file-word" class="mr-2 mb-2" @click="printDataP03" />
                                </div>
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
                                                            <td style="text-align: left;" colspan="10">
                                                                <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b> 
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> <b>{{ h.p01_weight??0 }}%</b></td>
                                                            <td></td>
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
                                                                <!-- วนลูปแสดงระดับ 1 ถึง 5 -->
                                                                <div v-for="level in [1, 2, 3, 4, 5]" :key="level">
                                                                    <div v-if="subP01.subITemP03ind.some(item => item.p03ind_no === level+'')">
                                                                        <b>ระดับ {{ level }}</b>
                                                                        <div v-for="(item, index) in subP01.subITemP03ind.filter(item => item.p03ind_no === level+'')" :key="index">
                                                                            <!-- แสดงรายการที่มีระดับเดียวกัน -->
                                                                            <div>
                                                                                {{ index + 1 }}. {{ item.p03ind_Items }}
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <p v-if="subP01.subITemP03ind.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                                </p>
                                                            </td>
                                                            
                                                            <!-- //รายงานป.01 -->  
                                                            <td style="text-align: left;"> 
                                                                <p v-for="(subIitemDoc, inDoc) in subP01.subITemP03doc.slice().sort((a, b) => a.doc_no - b.doc_no)" 
                                                                :key="inDoc" 
                                                                style="padding-left: 8px;margin-bottom: 5px;"> 
                                                                
                                                                    <a v-if="subIitemDoc.doc_file!=null && subIitemDoc.doc_link==null" 
                                                                    :href="' http://127.0.0.1:8000/storage/uploadsP03/' + subIitemDoc.doc_file" target="_blank">
                                                                        <b>เอกสารลำดับที่</b> <b>{{ subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}
                                                                    </a> 
                                                                    
                                                                    <a v-if="subIitemDoc.doc_link!=null && subIitemDoc.doc_file==null" 
                                                                    :href="subIitemDoc.doc_link" target="_blank">
                                                                        <b>เอกสารลำดับที่</b> <b>{{ subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}
                                                                    </a> 
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
                                                                <b>{{ totalscoretrack??0 }}</b> <!-- แสดงผลรวม p01_weight -->
                                                            </td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalWeighttrack??0 }}%</b> <!-- แสดงผลรวม p01_weight -->
                                                            </td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ WeightedScoreSumtrack??0 }}</b> <!-- แสดงผลรวมคะแนนที่คำนวณ -->
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
                                                            <td class="text-center" style="color: blue;  vertical-align: middle;" >
                                                                <b style="display: block; text-align: right; color: blue; text-align: left;">{{ WeightedScoreSumtrack }}</b>
                                                                <hr style="border: 1px solid black; width: 60%; text-align: left;">
                                                                <b style="display: block; text-align: right; color: blue; text-align: left;">{{5}}</b>
                                                                <div style="text-align: right;">
                                                                    <b>= {{ WeightedScoreSumXT }}</b>
                                                                </div> <!-- แสดงผลรวม/จำนวนระดับเป้าหมาย -->
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
                                                                <!-- <td style="color: blue;"><b>{{ row1.selfAssessment}}</b></td>  -->
                                                                <td>  
                                                                    <b v-if="row1.selfAssessment == '' ||  row1.selfAssessment == null" style="color: red;">0</b> 
                                                                    <b v-if="row1.selfAssessment != 0 " style="color: blue" >{{ row1.selfAssessment }}</b> 
                                                                </td> 
                                                                <td>  
                                                                    <b v-if="row1.data_table1 == '' " style="color: red;">0</b> 
                                                                    <b v-if="row1.data_table1 != 0 "  >{{ row1.data_table1 }}</b> 
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
                                                                <td style="text-align: left;"> ข. {{ index+1 }} {{ row2.WORK_NAME }}</td> 
                                                                <td> {{ row2.COMPLEVEL }} 
                                                                </td> 
                                                                <!-- <td style="color: blue"> <b>{{ row2 }}</b></td> -->
                                                                <td>  
                                                                    <b v-if="row2.SCOREPERSON == '' ||  row2.SCOREPERSON == null " style="color: red;">0</b> 
                                                                    <b v-if="row2.SCOREPERSON != 0 " style="color: blue;">{{ row2.SCOREPERSON }}</b> 
                                                                </td> 
                                                                <td>
                                                                    <b v-if="row2.SCORE == '' ||  row2.SCORE == null " style="color: red;">0</b> 
                                                                    <b v-if="row2.SCORE != 0  ||  row2.SCORE == null" >{{ row2.SCORE }}</b> 
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
                                                                    <b v-if="row3.indicator3 == '' ||  row3.indicator3 == null" style="color: red;">0</b>
                                                                    <span v-if="row3.indicator3 != 0">{{ row3.indicator3 }}</span>  
                                                                </td>
                                                                <td>  
                                                                    <b v-if="row3.datatable3 == '' ||  row3.datatable3 == null" style="color: red;">0</b> 
                                                                    <b v-if="row3.datatable3 != 0 " style="color: blue" >{{ row3.datatable3 }}</b> 
                                                                </td>
                                                                <td>  
                                                                    <b v-if="row3.selfAssessment3 == '' " style="color: red;">0</b> 
                                                                    <b v-if="row3.selfAssessment3 != 0 " >{{ row3.selfAssessment3 }}</b> 
                                                                </td>
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
                                                                <b>{{ totalcorecompetenciesX3 }}</b>  
                                                            </td>
                                                            <td class="text-center" style="color: blue;"><b>3</b></td>   
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalScoreSumX3 }}</b>  
                                                            </td>                                                    
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน</td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalcorecompetenciesX2 }}</b> 
                                                            </td>
                                                            <td class="text-center" style="color: blue;"><b>2</b></td> 
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalScoreSumX2 }}</b>  
                                                            </td>
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน</td>
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalcorecompetenciesX1 }}</b> 
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"><b>1</b></td> 
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalScoreSumX1 }}</b> 
                                                            </td>   
                                                            
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน</td>
                                                        <td class="text-center" style="color: blue;">
                                                                <b>{{ totalcorecompetenciesX0 }}</b> 
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"><b>0</b></td> 
                                                            <td class="text-center" style="color: blue;">
                                                                <b>{{ totalScoreSumX0 }}</b> 
                                                            </td>   
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right" colspan="3">
                                                            <b style="color: blue;"> (8) ผลรวม</b>
                                                        </td>
                                                            <td class="text-center" style="color: blue;"> 
                                                                <b>{{ totalScoreSumX3+totalScoreSumX2+totalScoreSumX1 }}</b>  
                                                            </td> 
                                                    </tr>
                                                    <tr>
                                                    <td style="text-align: center; vertical-align: middle;" colspan="3">
                                                        <b style="color: blue;">(9) สรุปคะแนนส่วนพฤติกรรมการปฏิบัติราชการ   (สมรรถนะ) =	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                        <b style="color: blue;">  ผลรวมคะแนน ใน (8)</b>
                                                        <b style="display: block; text-align: right; color: blue;">{{ totalScoreSumX3 + totalScoreSumX2+totalScoreSumX1 }}</b>   
                                                        <div style="display: flex; justify-content: flex-end;"> 
                                                            <hr style="border: 1px solid black; width: 70%;">
                                                        </div> 
                                                        <b style="display: block; text-align: right; color: blue;"> {{ calculateTotalCoreCompetenciesX() }} </b>
                                                        <!-- <b style="display: block; text-align: right; color: blue;"> {{ 33}} </b> -->
                                                        <b style="color: blue;">จำนวนสมรรถนะที่ใช้ในการประเมิน X 3 คะแนน</b>  
                                                    </td> 
                                                    <td class="text-center" style="color: blue;"> 
                                                         <b> = {{ ((totalScoreSumX3 + totalScoreSumX2+totalScoreSumX1) / calculateTotalCoreCompetenciesX()).toFixed(2) }}</b>   
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
                            <!-- Tab 4 --> 
                            <TabPanel header="รายงาน ป.04">
                                <div class="col md:col-12 text-right">
                                    <Button label="Export_ป.04" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP04"></Button>
                                </div> 
                                <div class="card">
                                    <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
                                    <div class="p-fluid formgrid grid">
                                        <div class="card">                      
                                            <h5 class="mb-4">ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>
                                            <div class="employee-info">  
                                                <p v-if="tracking_date?.d_evaluationround"> 
                                                    <strong>รอบการประเมิน:</strong> {{ tracking_date?.d_evaluationround || '-' }} {{ tracking_date?.d_date || '-' }} 
                                                </p>
                                                <p v-if="currentstaff?.length">
                                                    <strong>ชื่อผู้รับการประเมิน:</strong>  
                                                    {{ currentstaff[0]?.prefixfullname || '-' }} 
                                                    {{ currentstaff[0]?.staffname || '-' }} 
                                                    {{ currentstaff[0]?.staffsurname || '-' }}
                                                </p>
                                                <p><strong>ตำแหน่ง:</strong> {{ currentstaff[0]?.posnameth || '-' }}</p>
                                                <p v-if="currentstaff?.length">
                                                    <strong>ระดับตำแหน่ง:</strong> 
                                                    {{ currentstaff[0]?.posnameth=='ผู้บริหาร'&& !currentstaff[0]?.postypenameth   ? 'ชำนาญการพิเศษ' : currentstaff[0]?.postypenameth}} 
                                                </p>
                                                <p v-if="currentstaff[0]?.facultyid == 201092700000">
                                                    <strong>สังกัด:</strong> {{ currentstaff[0]?.departmentname || '-' }}
                                                </p>
                                                <p v-else>
                                                    <strong>สังกัด:</strong> {{ currentstaff[0]?.facultyname || '-' }}
                                                </p>
                                                <p><strong>ชื่อผู้ประเมิน:</strong>  {{ assessorText??'-' }}</p>  
                                            </div>
                                            <br>
                                            <div class="employee-info" style="border: groove;padding: 15px;">
                                                <h4>คำชี้แจง</h4>
                                                <h5>แบบสรุปการประเมินผลการปฏิบัติราชการนี้มี 5 ส่วน ดังนี้</h5>
                                                <p><strong>ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</strong> เพื่อระบุรายละเอียดต่างๆ ที่เกี่ยวข้องกับตัวผู้รับการประเมิน</p>
                                                <p><strong>ส่วนที่ 2 การสรุปผลการประเมิน</strong> ใช้เพื่อกรอกค่าคะแนนการประเมินในองค์ประกอบด้านผลสัมฤทธิ์ของงาน 
                                                    องค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ และน้ำหนักของทั้งสององค์ประกอบ
                                                </p>
                                                <p><strong>ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</strong> ผู้ประเมินและผู้รับการประเมินร่วมกันจัดทำแผนพัฒนา</p>
                                                <p><strong>ส่วนที่ 4 การรับทราบผลการประเมิน</strong> ผู้รับการประเมินลงนามรับทราบผลการประเมิน</p>
                                                <p><strong>ส่วนที่ 5 ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป</strong> ผู้บังคับบัญชาให้ความเห็น</p>
                                            </div>
                                            <h5 class="mb-4">ส่วนที่ 2 การสรุปผลการประเมิน</h5> 
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
                                                    <template v-for="(Item, index) in products" :key="index"> 
                                                    <tr v-if="dataStaffid==Item?.staffid">  
                                                        <td>องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน</td>
                                                        <td class="text-center" style="color: blue;"> 
                                                            <b>{{ Item?.tb_tor?.achievement_score || '-' }}</b> 
                                                        </td> 
                                                        <td class="text-center" style="color: blue;">  
                                                            <b>{{ Item?.tb_tor?.persen?.split(':')[0] || '-' }}</b>
                                                        </td> 
                                                        <td class="text-center" style="color: blue;">  
                                                            <b>{{ (Item?.tb_tor?.achievement_score * (parseFloat(Item?.tb_tor?.persen?.split(':')[0]) || 0)).toFixed(2) || '-' }}</b>  
                                                        </td> 
                                                    </tr> 
                                                    <tr v-if="dataStaffid==Item?.staffid"> 
                                                        <td>องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ</td>
                                                        <td class="text-center" style="color: blue;"> 
                                                            <b>{{ Item?.tb_tor?.behavior || '-' }}</b>
                                                        </td>  
                                                        <td class="text-center" style="color: blue;">  
                                                            <b>{{ Item?.tb_tor?.persen?.split(':')[1] || '-' }}</b>
                                                        </td> 
                                                        <td class="text-center" style="color: blue;"> 
                                                            <b>{{ ((Item?.tb_tor?.behavior * (parseFloat(Item?.tb_tor?.persen?.split(':')[1]) || 0)).toFixed(2)) || '-' }}</b>  
                                                        </td>  
                                                    </tr>
                                                    <tr v-if="dataStaffid==Item.staffid">
                                                                <td>องค์ประกอบอื่นๆ (ถ้ามี)</td>
                                                                <td></td>
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                            <tr v-if="dataStaffid==Item.staffid" style="font-weight: bold;">
                                                                <td colspan="2" style="text-align: right;">รวม</td>
                                                                <td class="text-center" style="color: blue;"> 
                                                                    <b>{{ 100 }}%</b>  
                                                                </td> 
                                                                <td class="text-center" style="color: blue;">  
                                                                    <b>{{ Item.tb_tor?Item.tb_tor.sum_score:'' }}</b>  
                                                                </td> 
                                                            </tr>
                                                            </template>  
                                                    </tbody>
                                            </table>
                                                <template v-for="(Item, index) in products" :key="index">
                                                    <div v-if="dataStaffid == Item.staffid" class="employee-info">
                                                        <h4>ระดับผลการประเมินที่ได้</h4>
                                                            <p> <strong> [&nbsp;&nbsp;<b v-if="Item?.tb_tor?.sum_score >= 90">&#10003;</b>&nbsp;&nbsp;] ดีเด่น (90-100)</strong> </p>
                                                            <p> <strong> [&nbsp;&nbsp; <b v-if="Item?.tb_tor?.sum_score >= 80 && Item?.tb_tor?.sum_score < 90">&#10003;</b>&nbsp;&nbsp;] ดีมาก (80-89)</strong></p>
                                                            <p> <strong> [&nbsp;&nbsp; <b v-if="Item?.tb_tor?.sum_score >= 70 && Item?.tb_tor?.sum_score < 80">&#10003;</b> &nbsp;&nbsp;] ดี (70-79) </strong></p>
                                                            <p> <strong> [&nbsp;&nbsp; <b v-if="Item?.tb_tor?.sum_score >= 60 && Item?.tb_tor?.sum_score < 70">&#10003;</b> &nbsp;&nbsp;] พอใช้ (60-69)</strong></p>
                                                            <p> <strong> [&nbsp;&nbsp;  <b v-if="Item?.tb_tor?.sum_score < 60">&#10003;</b> &nbsp;&nbsp;] ต้องปรับปรุง (ต่ำกว่า 60) </strong> </p>
                                                    </div>
                                                </template>
                                            <h5 class="mb-4">ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</h5>
                                            <table border="1" cellspacing="0" cellpadding="5">
                                                <thead>
                                                    <tr style="text-align: center;">
                                                        <th>ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา</th>
                                                        <th>วิธีการพัฒนา</th>
                                                        <th>ช่วงเวลาที่ต้องการพัฒนา</th> 
                                                        <th>ผู้บริหาร</th> 
                                                    </tr>
                                                </thead> 
                                                <tbody>
                                                    <tr v-for="(Tab3T4, idx) in products_Tab3T4" :key="idx">
                                                        <td style="text-align: left;">{{ Tab3T4?.p04_re1 || '-' }}</td>
                                                        <td style="text-align: left;">{{ Tab3T4?.p04_re2 || '-' }}</td>
                                                        <td style="text-align: left;">{{ Tab3T4?.p04_re3 || '-' }}</td> 
                                                        <td style="text-align: left;"> 
                                                            <Textarea 
                                                                class="p-inputtextarea p-inputtext p-component" 
                                                                v-on:blur="AddDataXXR" 
                                                                v-model="Tab3T4.px04_re1" 
                                                                rows="4" 
                                                                placeholder="ความคิดเห็นจากผู้บริหาร" />
                                                        </td> 
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
                                                                    
                                                                    ลงชื่อ .................................................................<br>
                                                                            (.......................................................)<br>
                                                                        ตำแหน่ง .................................................................<br>
                                                                    <!-- ชื่อ : {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}<br>
                                                                    ตำแหน่ง : {{ user.user.name.POSITIONNAME }}<br> -->
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
                                                                        (.......................................................)<br>
                                                                    ตำแหน่ง .................................................................<br>
                                                                    <!-- ชื่อ {{ assessorText }}<br>
                                                                    ตำแหน่ง {{ assessor_positionText }}<br> -->
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
                            <Button label="ตกลง" severity="secondary" class="mb-2 mr-2" @click="DialogAdd = false " />
                        </template>
                    </Dialog>
                </div>
            </div>
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
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel';
import { LogarithmicScale } from 'chart.js';
import InputNumber from 'primevue/inputnumber'; 
export default {
    // props: {
    //     dataPor: {
    //         type: Object,
    //         required: true
    //     },
    //     tab4Tracking: {
    //         type: String,
    //         default: '0'
    //     }
    // },
    data() {
        return {
            dataList: [], // ข้อมูลทั้งหมด
            filteredData: [], // ข้อมูลที่กรองแล้ว
            staffid_po: 130102,
            //staff_po: null, 
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '',
            // ปีงบประมาณ
            dropdownItemYear: { name: 'ปีงบประมาณ 2568', code: 2568 },
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 }
            ],
            // รอบประเมิน
            dropdownItemRecord: { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            dropdownItemRecords: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' }
            ],
            tracking_date: '',
            tracking_dates: null,
            tracking_fac: '',
            //tracking_facuty: null,
            

            // ตารางรายชื่อ
            products: [],

            // เพิ่มคะแนนประเมิน
            DialogAdd: false,
            activeIndex: 0,
            dataStaffid: null,
            //Tab 1
            products_Tab1: [],
            p01_score: null,
                        
            postypenameth:[],

            p01_scores: [
                { name: '- ไม่ระบุ -', code: 0 },
                { name: '1 คะแนน', code: 1 },
                { name: '2 คะแนน', code: 2 },
                { name: '3 คะแนน', code: 3 },
                { name: '4 คะแนน', code: 4 },
                { name: '5 คะแนน', code: 5 }
            ],
            p01_detail: null,
            //ตาราง ก. สมรรถนะหลัก
            coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '', data_table1: '',selfAssessment:''},
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '', data_table1: '',selfAssessment:''},
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '', data_table1: '',selfAssessment:''},
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '', data_table1: '',selfAssessment:''},
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '', data_table1: '',selfAssessment:''}
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [],
           
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
            //tap px
            px04_re1: null,
            px04_re2: null,
            px04_re3: null,
            products_Tab3: [], 


            //Tab 4
            products_Tab3T4: [],
            //total weight
            totalscoretrack: {},
            totalWeighttrack: {},
            WeightedScoreSumtrack: {},
            WeightedScoreSumX: 0,
            WeightedScoreSumXT: 0,
            //รวมคะแนน เกณฑ์การประเมิน
            totalcorecompetenciesX3: 0,
            totalcorecompetenciesX2: 0,
            totalcorecompetenciesX1: 0,
            totalcorecompetenciesX0: 0,
            totalScoreSumX3: 0,
            totalScoreSumX2: 0,
            totalScoreSumX1: 0,
            totalScoreSumX0: 0, 
            totalScoreSum: 0, 
            totalScoreFinalSum: 0, 
            assessorText: null,
            assessor_positionText: null,
            currentstaff: {},  
            //datatable3: [],
            printStaffData: {},
        };
    },
    components: {
        TabView,
        TabPanel
    },

    async mounted() {
        const { signIn, getSession, signOut } = await useAuth();
        const user = await getSession();
        // console.log(user.user.name);
        const { STAFFID, SCOPES } = user.user.name;
        const { staffdepartment, groupid, staffdepartmentname, groupname } = SCOPES;
        await this.setSession(STAFFID, staffdepartment, groupid, user.user.name.POSTYPENAME, user.user.name.POSITIONNAMEID);
        // this.showDataEvalu();
        this.showDataSet();   
        // this.showAssesstack(); 
    },   
    methods: { 
        setSession(staffid_Main, facid_Main, groupid_Main, postypename, postypenameid) {
            // console.log('postypename:',postypename);
            this.staffid_Main = staffid_Main;
            this.facid_Main = facid_Main;
            this.groupid_Main = groupid_Main;
            this.postypename = postypename;
            this.postypenameid = postypenameid;
        },
        showDataSet() {
            axios
                .post('   http://127.0.0.1:8000/api/showDateSetleader', {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main
                })
                .then((res) => {
                     console.log(res.data);
                    this.tracking_dates = res.data;
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        // ตารางรายชื่อ
        // xxr() {
        //     if (this.tracking_date.evalua === undefined) {
        //         Swal.fire({
        //             title: 'แจ้งเตือนจากระบบ!',
        //             text: 'กรุณาเลือก รอบประเมิน ก่อน!',
        //             icon: 'error'
        //         });
        //     } else {
        //         this.showDataEvalu();
        //     }
        // },
        xxr() {
            if (this.tracking_date?.evalua === undefined) {
                Swal.fire({
                    title: 'แจ้งเตือนจากระบบ!',
                    text: 'กรุณาเลือก รอบประเมิน ก่อน!',
                    icon: 'error'
                });
            } else {
                // เช็คว่า dataList เป็น array หรือไม่
                if (Array.isArray(this.dataList)) {  
                    // กรองข้อมูลที่ไม่ใช่ "ลูกจ้างชั่วคราว"
                    // this.filteredData = this.dataList.filter(item => item.stftypename !== "ลูกจ้างชั่วคราว");
                    this.filteredData = this.dataList.filter(item => item.stftypename !== "ลูกจ้างชั่วคราว" && item.stftypename !== "พนักงานราชการ"); 
                    // เรียกใช้ฟังก์ชัน showDataEvalu()
                    this.showDataEvalu();
                } else {
                    console.error("dataList is not an array:", this.dataList);
                }
            }
        }, 
        async showDataEvalu() {
            try { 
                const res = await axios.get('   http://127.0.0.1:8000/api/showDataEvalu', {  
                    params: {
                        staff_id: this.staffid_Main,
                        fac_id: this.tracking_date.fac_id,
                        group_id: this.groupid_Main,
                        evalua: this.tracking_date.evalua,
                        p_year: this.tracking_date.d_date
                    }
                });
                this.products = res.data;
                // console.log(res.data);

                // ใช้ Promise.all เพื่อทำการเรียก cvb พร้อมกันหลายๆ รายการ
                //await Promise.all(res.data.map(item => this.cvb(item)));
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            }
        },
        async cvb(item) {
            // console.log(this.tracking_date.evalua);
            try {
                const response = await axios.post('   http://127.0.0.1:8000/api/showdatator', {
                    p_year: this.tracking_date.d_date,
                    evalua: this.tracking_date.evalua,
                    p_staffid: item.staffid
                });
                //console.log(response.data);
                // อัปเดตค่า persen ใน item แทนการใช้ this.persen
                item.persenGetData = response.data[0]?.persen ?? 0;
            } catch (error) {
                console.error('Error fetching data for staff:', error);
            }
        },
        // XX One
        async openDataEvalu(data) {
            
            // console.log('posnameid: ',data.posnameid);
            // console.log('staffid: ',data.staffid);
            
            if (this.tracking_date.d_date === undefined) {
                Swal.fire('แจ้งเตือนจากระบบ', 'กรุณาเลือกรอบประเมิน', 'error');
            } else {
                this.dataStaffid = data.staffid;
                this.printStaffData = data; 

                await this.showDataEvalu();
                await this.showdatator();

                this.currentstaff = this.products.filter((product) => product.staffid === this.dataStaffid);
                this.products_Tab1 = [];
                this.p01_scores = [
                    { name: '0 คะแนน', code: 0 },
                    { name: '1 คะแนน', code: 1 },
                    { name: '2 คะแนน', code: 2 },
                    { name: '3 คะแนน', code: 3 },
                    { name: '4 คะแนน', code: 4 },
                    { name: '5 คะแนน', code: 5 }
                ];

                // ตั้งค่า coreCompetencies กลับไปเป็นค่าเริ่มต้น
                this.coreCompetencies = [
                    { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '',selfAssessment:'' },
                    { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '',selfAssessment:'' },
                    { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '',selfAssessment:'' },
                    { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '',selfAssessment:'' },
                    { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '',selfAssessment:'' }
                ];

                // ตั้งค่า jobSpecificCompetencies กลับไปเป็นค่าเริ่มต้น
                this.jobSpecificCompetencies = [];

                this.improvements = null;
                this.suggestions = null;

                this.showdataPo(data.staffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua,data.posnameid);

                await axios.post('   http://127.0.0.1:8000/api/showDataP03New', {
                    staff_id: data.staffid,
                    fac_id: this.tracking_date.fac_id,
                    year_id: this.tracking_date.d_date,
                    evalua: this.tracking_date.evalua
                })
                .then((res) => {
                    // console.log('openDataEvalu: ',res.data);
                    if (res.data && Array.isArray(res.data)) {
                        this.products_Tab1 = res.data;
                        this.products_Tab1.forEach((h) => {
                            h.subP01sX.forEach((subP01) => {
                                // ตรวจสอบว่าค่า p01_score นั้นถูกต้องหรือไม่
                                const foundScore = this.p01_scores.find((score) => score.code === subP01.p01_score);
                                if (foundScore) {
                                    subP01.p01_score = foundScore.code; // ใช้ค่าที่ถูกต้อง
                                } else {
                                    subP01.p01_score = this.p01_scores[0].code; // ใช้ค่าเริ่มต้น "- ไม่ระบุ -"
                                }
                            });
                        });
                    }
                    this.DialogAdd = true; 
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
            }
        },     
        async saveEvaTab1(subP01) {
            if (subP01.p01_score === 0) {
                Swal.fire('แจ้งเตือน', 'กรุณาเลือกคะแนน !', 'error');
            } else {
                await axios
                    .post('   http://127.0.0.1:8000/api/saveP03Po', {
                        staffid_po: this.staffid_po,
                        p01_id: subP01.p01_id,
                        p01_score: subP01.p01_score,
                        p01_detail: subP01.p01_detail,
                        p01_evalua: this.tracking_date.evalua,
                        p01_staffid: subP01.p01_staffid,
                        p01_year: this.tracking_date.d_date
                    })
                    .then((res) => {
                        //console.log(res.data);
                        Swal.fire({
                            position: 'top-end',
                            icon: 'success',
                            title: 'ข้ลมูลผลการประเมินถูกบันทึกเสร็จสิ้น',
                            showConfirmButton: false,
                            timer: 1000
                        });
                    })
                    .catch((error) => {
                        console.error('Error:', error);
                    });
                await this.showDataEvalu();
            }
        },
        async saveEvaTab1_1() {
            this.coreCompetencies.forEach((item, index) => {
                if (index === 0) {
                    item.data_table1 = item.data_table1 ?? 0; // Update based on the API response
                } else if (index === 1) {
                    item.data_table1 = item.data_table1 ?? 0; // Update based on the API response
                } else if (index === 2) {
                    item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
                } else if (index === 3) {
                    item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
                } else if (index === 4) {
                    item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
                } else if (index === 5) {
                    item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
                }
            });
            this.jobSpecificCompetencies.forEach((item, index) => {
                if (index === 0) {
                    item.SCORE = item.SCORE ?? 0; // Update based on the API response
                } else if (index === 1) {
                    item.SCORE = item.SCORE ?? 0; // Update based on the API response
                } else if (index === 2) {
                    item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
                } else if (index === 3) {
                    item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
                } else if (index === 4) {
                    item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
                } else if (index === 5) {
                    item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
                }
            });
            this.otherCompetencies.forEach((item, index) => {
                if (index === 0) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Update based on the API response
                } else if (index === 1) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Update based on the API response
                } else if (index === 2) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
                } else if (index === 3) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
                } else if (index === 4) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
                } else if (index === 5) {
                    item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
                }
            });
            const payload = {
                staffid_po: this.staffid_po,
                staff_id: this.staffid_Main,
                dataStaffid: this.dataStaffid,
                fac_id: this.facid_Main,
                year: this.tracking_date.d_date,
                record: this.tracking_date.evalua,
                coreCompetencies: this.coreCompetencies,
                jobSpecificCompetencies: this.jobSpecificCompetencies,
                otherCompetencies: this.otherCompetencies,
                improvements: this.improvements,
                suggestions: this.suggestions
            };
            const res = await axios.post('   http://127.0.0.1:8000/api/saveP03PoTab1', payload);
            //console.log(res.data);
            Swal.fire({
                position: 'top-end',
                icon: 'success',
                title: 'บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม เสร็จสิ้น',
                showConfirmButton: false,
                timer: 1500
            });
            await this.showDataEvalu();
        },  
        async onTabChange(event) { 
            // console.log(this.coreCompetencies);
            // console.log('onTabChange: ',event.index);
            if (event.index==0) {
                //console.log('แบบใบปะหน้า -',event.index); 
            }
            if(event.index==1){
                
                //console.log('รายงาน ป.01 - ป.03 -',event.index);  
                await this.showdataPoText(this.dataStaffid,this.facid_Main,this.tracking_date.d_date,this.tracking_date.evalua); 
                await this.tab2Data(this.dataStaffid);  
                
            }  
            if (event.index==2) {
                //console.log('รายงาน ป.04 -',event.index);
                this.chkp04dataT4(this.dataStaffid,this.facid_Main,this.tracking_date.d_date,this.tracking_date.evalua); 
                this.showdatator();
            }
        }, 
        async tab2Data(staff_id) {
            await axios.post('   http://127.0.0.1:8000/api/showDataP03New', {
                staff_id: staff_id,
                fac_id: this.tracking_date.fac_id,
                year_id: this.tracking_date.d_date,
                evalua: this.tracking_date.evalua
            })
            .then((res) => {
                    //console.log(res.data);
                if (res.data && Array.isArray(res.data)) {
                    this.products_Tab2 = res.data;
                }
                this.function_totalscoretrack();
                this.function_totalWeighttrack();
                this.function_WeightedScoreSumtrack();
                this.function_WeightedScoreSumX();
                this.function_WeightedScoreSumXT();  
                this.function_totalcorecompetenciesX3(); 
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        },
        showdataPoText(staff_id, fac_id, year_id, record) {
            // console.log(staff_id);
            
            axios .post('   http://127.0.0.1:8000/api/showDataPo', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    //console.log(res.data);
                    if (res.data.length > 0) {
                        const data = res.data[0];
                        this.coreCompetencies.forEach((item) => {
                            if (item.id === 1) {
                                item.data_table1 = data.p1 ?? 0; // Update based on the API response
                            } else if (item.id === 2) {
                                item.data_table1 = data.p2 ?? 0; // Update based on the API response
                            } else if (item.id === 3) {
                                item.data_table1 = data.p3 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 4) {
                                item.data_table1 = data.p4 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 5) {
                                item.data_table1 = data.p5 ?? 0; // Add more conditions if necessary
                            }
                        });

                        this.jobSpecificCompetencies.forEach((item) => {
                            if (item.id === 6) {
                                item.data_table2 = data.p6 ?? 0; // Update based on the API response
                            } else if (item.id === 7) {
                                item.data_table2 = data.p7 ?? 0; // Update based on the API response
                            } else if (item.id === 8) {
                                item.data_table2 = data.p8 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 9) {
                                item.data_table2 = data.p9 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 10) {
                                item.data_table2 = data.p10 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 11) {
                                item.data_table2 = data.p11 ?? 0; // Add more conditions if necessary
                            }
                        });
                        this.otherCompetencies.forEach((item) => {
                            if (item.id === 6) {
                                item.selfAssessment3 = data.pSE_1 ?? 0; // Update based on the API response
                            } else if (item.id === 7) {
                                item.selfAssessment3 = data.pSE_2 ?? 0; // Update based on the API response
                            } else if (item.id === 8) {
                                item.selfAssessment3 = data.pSE_3 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 9) {
                                item.selfAssessment3 = data.pSE_4 ?? 0; // Add more conditions if necessary
                            } else if (item.id === 10) {
                                item.selfAssessment3 = data.pSE_5 ?? 0; // Add more conditions if necessary 
                            }
                        });

                        // Update other fields
                        this.improvements = data.improvements ?? '- ไม่มีข้อมูล -';
                        this.suggestions = data.suggestions ?? '- ไม่มีข้อมูล -'; 
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        chkp04(staff_id, fac_id, year_id, record) {
            axios
                .post('   http://127.0.0.1:8000/api/showDataPo', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    // console.log(res.data);
                    if (res.data.length > 0) {
                        this.chkP04 = 0;
                    } else {
                        this.chkP04 = 1;
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        AddDatap04() {
            const newData = {
                p04_re1: this.p04_re1,
                p04_re2: this.p04_re2,
                p04_re3: this.p04_re3, 
                px04_re1: this.px04_re1,
                px04_re2: this.px04_re2,
                px04_re3: this.px04_re3,
            };
            this.products_Tab3.push(newData);
            this.p04_re1 = '';
            this.p04_re2 = '';
            this.p04_re3 = '';
            this.px04_re1 = '';
            this.px04_re2 = '';
            this.px04_re3 = '';  
        },
        AddDatap04X() {
            const newData = {
                px04_re1: this.px04_re1,
                px04_re2: this.px04_re2,
                px04_re3: this.px04_re3
            };
            this.products_Tab3.push(newData);
            this.px04_re1 = '';
            this.px04_re2 = '';
            this.px04_re3 = '';
        },
        DeleteRegislick(item) {
            // Add logic to remove the selected item
            this.products_Tab3 = this.products_Tab3.filter((product) => product !== item);
        },
        saveEvaTab3() {
            axios
                .post('   http://127.0.0.1:8000/api/saveEvaTab3', {
                    staff_id: this.dataStaffid,
                    fac_id: this.facid_Main,
                    year_id: this.tracking_date.d_date,
                    record: this.tracking_date.evalua,
                    products_Tab3: this.products_Tab3, 
                })
                .then((res) => {
                    //console.log(res.data);
                    Swal.fire({
                        position: 'top-end',
                        icon: 'success',
                        title: 'บันทึก แผนพัฒนาการปฏิบัติราชการรายบุคคล เสร็จสิ้น',
                        showConfirmButton: false,
                        timer: 1000
                    });
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        chkp04data(staff_id, fac_id, year_id, record) {
            axios
                .post('   http://127.0.0.1:8000/api/showData04Tab3', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    // console.log(res.data);
                    if (res.data.length > 0) {
                        res.data.forEach((p04) => {
                            const newData = {
                                p04_re1: p04.p04_re1,
                                p04_re2: p04.p04_re2,
                                p04_re3: p04.p04_re3
                            };
                            this.products_Tab3.push(newData);
                        });
                    }
                    this.p04_re1 = '';
                    this.p04_re2 = '';
                    this.p04_re3 = '';
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        chkp04dataT4(staff_id, fac_id, year_id, record) {
            axios
                .post('   http://127.0.0.1:8000/api/showData04Tab3', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    // console.log(res.data);
                    if (res.data.length > 0) {
                        this.products_Tab3T4 = res.data;
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },
        /*============= ผู้ประเมิน ==============*/
        showdatator() {
            (this.assessorText = null),
                (this.assessor_positionText = null),
                axios
                    .post('   http://127.0.0.1:8000/api/showdatator', {
                        p_year: this.tracking_date.d_date,
                        evalua: this.tracking_date.evalua,
                        p_staffid: this.dataStaffid
                    })
                    .then((res) => {
                        //console.log('Response',res.data);
                        this.assessorText = res.data[0].assessor;
                        this.assessor_positionText = res.data[0].assessor_position;
                    })
                    .catch((error) => {
                        console.error('Error fetching data:', error);
                    });
        },
        async showPostype(postypename,postypenameid) {
            console.log('showPostype: ',postypename, postypenameid);
            //let postypenameText = postypename ? postypename : `ชำนาญการพิเศษ`;
            let postypenameText = this.postypenameth ;
            // var postypetext =postypename;
            var postypetext = `ระดับ` + postypenameText;
            // var postypetext = `ระดับ` + postypename;
            await axios .post('   http://127.0.0.1:8000/api/showdatapostypenameAdmin', {
                    postypename: postypetext,
                    postypenameid: postypenameid
                })
                .then((res) => {
                    //console.log('showPostype',res.data);
                    if (res.data.length > 0) {  
                        this.jobSpecificCompetencies = res.data;
                    } 
                })
                .catch((error) => {
                    console.error('Error fetching data:', error);
                });
            await this.getjobSpecificCompetencies();
        }, 
        getjobSpecificCompetencies(dataStaffid) {
            //console.log(this.staffid_Main,this.dataPor);

            axios .post('   http://127.0.0.1:8000/api/showdataposp02', { 
                    p_year: this.tracking_date.d_date,
                    evalua: this.tracking_date.evalua,
                    p_staffid: this.dataStaffid
                })
                .then(res => {
                   // console.log('getjobSpecificCompetencies',res.data);
                    
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
                .catch((error) => {
                    console.error('Error fetching data:', error);
                });
        },
        showdataPo(staff_id, facid_Main, d_date, evalua, posnameid) {  
            // ตรวจสอบว่า currentstaff มีค่าหรือไม่
            if (!this.currentstaff || this.currentstaff.length === 0) {
                console.error("Error: currentstaff is undefined or empty.");
                return;
            }

            this.postypenameth = this.currentstaff[0]?.postypenameth  ?? (this.currentstaff[0]?.posnameth === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : 'ปฏิบัติการ');

         //console.log("postypenameth:", this.postypenameth);

            let postypetext = `ระดับ${this.postypenameth}`;   
            // let postypetext = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;
            // let postypenameid = this.positionname === 'ผู้บริหาร' ? 90 : this.postypenameid;
            // let positionname = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;


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
            let xr = levelMapping[postypetext] || 0; 

            this.coreCompetencies = [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: xr, data_table1: '', selfAssessment: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: xr, data_table1: '', selfAssessment: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: xr, data_table1: '', selfAssessment: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: xr, data_table1: '', selfAssessment: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: xr, data_table1: '', selfAssessment: '' }
            ];  
            this.jobSpecificCompetencies = [];

            const Mapping = {
                'ผู้บริหาร': 1
            };  
            let executive = Mapping[this.postypenameth, this.currentstaff[0]?.posnameth] || 0;

            this.otherCompetencies = [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
            ]; 

            // this.showPostype(this.currentstaff[0]?.postypenameth, this.postypenameid); // แก้ไข ตัวป2
            this.showPostype(this.currentstaff[0]?.postypenameth, posnameid);

            axios.post(' http://127.0.0.1:8000/api/showDataPo', {
                staff_id: staff_id,
                fac_id: facid_Main,
                year_id: d_date,
                record: evalua,
                postypename: postypetext
            }).then(res => {     
                if (res.data.length > 0) {
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
                    //this.staff_po = data.staff_po;
                } 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
 
        //29/10/67
        saveScore() {
            axios
                .post('   http://127.0.0.1:8000/api/saveDatator', {
                    score: this.totalScore
                })
                .then((response) => {
                    console.log('บันทึกคะแนนสำเร็จ:', response.data);
                })
                .catch((error) => {
                    console.error('เกิดข้อผิดพลาดในการบันทึกคะแนน:', error);
                });
        },
        saveDatatorScore() {
            //console.log(res.data);
            if (!this.assessor || !this.assessor_position) {
                Swal.fire({
                    icon: 'warning',
                    title: 'กรุณากรอกข้อมูล',
                    text: 'กรุณากรอกชื่อและตำแหน่งผู้ประเมินให้ครบถ้วน'
                });
            } else {
                Swal.fire({
                    title: 'บันทึกสำเร็จ!',
                    text: 'ข้อมูล ระดับการประเมินตนเอง ถูกบันทึกเรียบร้อย!',
                    icon: 'success'
                });
                this.DialogScore = false;
            }
            if (this.product_date.d_date == null || this.product_date.d_date == undefined) {
                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text: 'กรุณาเลือก รอบการประเมิน'
                });
            } else if (this.dropdownProportion == null || this.dropdownProportion == undefined) {
                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด',
                    text: 'กรุณาเลือก สัดส่วน'
                });
            } else {
                // console.log({
                //     p_year: this.product_date.d_date,
                //     evalua: this.product_date.evalua,
                //     p_staffid: this.staffid_Main,
                //     staffid_name: this.staffid_name,
                //     pos_id: this.pos_id,
                //     postype_id: this.postype_id,
                //     fac_id: this.facid_Main,
                //     dropdownProportion: this.dropdownProportion.value,
                //     assessor: this.assessor,
                //     assessor_position: this. assessor_position
                // });

                const formData = {
                    p_year: this.product_date.d_date,
                    evalua: this.product_date.evalua,
                    p_staffid: this.staffid_Main,
                    staffid_name: this.staffid_name,
                    pos_id: this.pos_id,
                    postype_id: this.postype_id,
                    fac_id: this.facid_Main,
                    dropdownProportion: this.dropdownProportion.value,
                    assessor: this.assessor,
                    assessor_position: this.assessor_position
                };

                axios
                    .post('   http://127.0.0.1:8000/api/saveDatator', formData)
                    .then((response) => {
                        this.DialogScore = false;
                        // console.log('showDataP03',res.data);
                    })
                    .catch((error) => {
                        console.error('Error saving data:', error);
                    });
            }
        },
        // คำนวนคะแนน 
        function_totalscoretrack() { 
            this.totalscoretrack = this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + subP01.p01_score;
                }, 0);
            }, 0);
        }, 
        function_totalWeighttrack() { 
            this.totalWeighttrack = this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + parseFloat (subP01.p01_weight);
                }, 0);
            }, 0);
        },
        function_WeightedScoreSumtrack() {
            this.WeightedScoreSumtrack = this.products_Tab2
                .reduce((total, h) => {
                    return total + h.subP01sX.reduce((subTotal, subP01) => {
                        return subTotal + (subP01.p01_score * subP01.p01_weight) / 100;
                    }, 0);
                }, 0)
                .toFixed(3);
        },
        function_WeightedScoreSumX() {
            this.WeightedScoreSumX = this.products_Tab2
                .reduce((total, h) => {
                    return total + h.subP01sX.reduce((subTotal, subP01) => {
                        return subTotal + subP01.p01_weight / 5;
                    }, 0);
                }, 0)
                .toFixed(2);
        },
        function_WeightedScoreSumXT() {
            this.WeightedScoreSumXT = this.products_Tab2
                .reduce((total, h) => {
                    return total + h.subP01sX.reduce((subTotal, subP01) => {
                        return subTotal + (subP01.p01_score * subP01.p01_weight) / 100 / 5;
                    }, 0);
                }, 0)
                .toFixed(2);
        }, 

        function_totalcorecompetenciesX3() {
            //this.totalcorecompetenciesX4 = 0; 
            this.totalcorecompetenciesX3 = 0;
            this.totalcorecompetenciesX2 = 0;
            this.totalcorecompetenciesX1 = 0;
            this.totalcorecompetenciesX0 = 0;
            //console.log('coreCompetencies: ',this.coreCompetencies);

            for (let i = 0; i < this.coreCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.coreCompetencies[i]?.indicator) || 0;
                const dataTable2Value = parseFloat(this.coreCompetencies[i]?.data_table1) || 0;

                // console.log('dataTable1Value: ',dataTable1Value);
                // console.log('dataTable2Value: ',dataTable2Value);
                if ((dataTable1Value - dataTable2Value) <= 0) {
                    this.totalcorecompetenciesX3++;
                }else if ((dataTable1Value - dataTable2Value) == 1) {
                    this.totalcorecompetenciesX2++;
                }else if ((dataTable1Value - dataTable2Value) == 2) {
                    this.totalcorecompetenciesX1++;
                }else if ((dataTable1Value - dataTable2Value) >= 3) {
                    this.totalcorecompetenciesX0++;
                }
            }
            for (let i = 0; i < this.jobSpecificCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.jobSpecificCompetencies[i]?.COMPLEVEL) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[i]?.SCORE) || 0;
                //console.log('jobSpecificCompetencies[i]?.SCORE: ',dataTable2Value);


                //console.log('jobSpecificCompetencies: ',dataTable1Value,dataTable2Value,dataTable1Value - dataTable2Value);
                if ((dataTable1Value - dataTable2Value) <= 0) {
                    this.totalcorecompetenciesX3++;
                }else if ((dataTable1Value - dataTable2Value) == 1) {
                    this.totalcorecompetenciesX2++;
                }else if ((dataTable1Value - dataTable2Value) == 2) {
                    this.totalcorecompetenciesX1++;
                }else if ((dataTable1Value - dataTable2Value) >= 3) {
                    this.totalcorecompetenciesX0++;
                }  

                }
            for (let i = 0; i < this.otherCompetencies.length; i++) {
                const dataTable1Value = parseFloat(this.otherCompetencies[i]?.indicator3) || 0;
                const dataTable2Value = parseFloat(this.otherCompetencies[i]?.selfAssessment3) || 0;

                //console.log('otherCompetencies: ',dataTable1Value,dataTable2Value,dataTable1Value - dataTable2Value);
                if ((dataTable1Value - dataTable2Value) <= 0  && dataTable2Value >= 1) {
                    this.totalcorecompetenciesX3++;
                }else if ((dataTable1Value - dataTable2Value) == 1 ) {
                    this.totalcorecompetenciesX2++;
                }
            }

            // return total;
            this.totalScoreSumX3 = this.totalcorecompetenciesX3*3;
            this.totalScoreSumX2 = this.totalcorecompetenciesX2*2;
            this.totalScoreSumX1 = this.totalcorecompetenciesX1*1;
            this.totalScoreSumX0 = this.totalcorecompetenciesX0*0;
        }, 
        //รวมคะแนนสมรรถนะ*3 
        calculateTotalCoreCompetenciesX() {
            return (
            (this.totalcorecompetenciesX3 || 0) +
            (this.totalcorecompetenciesX2 || 0) +
            (this.totalcorecompetenciesX1 || 0) +
            (this.totalcorecompetenciesX0 || 0)
            ) * 3;
        },

        /*============= ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนาสำหรับผู้บริหาร =============*/ 
        chkp03data(){ 
                this.products_Tab3 = [];
                axios.post('   http://127.0.0.1:8000/api/showData04Tab3',{
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    year_id: this.tracking_date.d_date,
                    record: this.tracking_date.evalua, 
                }).then(res => {     
                   // console.log('showData04Tab3',res.data);     
                    if(res.data.length > 0){
                        res.data.forEach(p04 => {
                            const newData = {
                                px04_re1: p04.px04_re1,
                                px04_re2: p04.px04_re2,
                                px04_re3: p04.px04_re3,
                                id:p04.p02_id
                            };
                            this.products_Tab3.push(newData); 
                        });  
                    }
                    this.px04_re1 = '';
                    this.px04_re2 = '';
                    this.px04_re3 = '';
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            },  
        AddDatap04X(){ 
            axios.post('   http://127.0.0.1:8000/api/saveEvaTab03xx',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.tracking_date.d_date,
                record: this.tracking_date.evalua,
                px04_re1: this.px04_re1,
                px04_re2: this.px04_re2,
                px04_re3: this.px04_re3
            }).then(res => {     
                // console.log(res.data);    
                const newData = {
                    px04_re1: this.px04_re1,
                    px04_re2: this.px04_re2,
                    px04_re3: this.px04_re3,
                    id: res.data
                };
                this.products_Tab3.push(newData); 
                this.px04_re1 = '';
                this.px04_re2 = '';
                this.px04_re3 = '';

                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: "บันทึก แผนพัฒนาการปฏิบัติราชการรายบุคคล เสร็จสิ้น",
                    showConfirmButton: false,
                    timer: 1000
                });
            })
            .catch(error => {
                console.error('Error:', error);
            }); 
        },
        DeleteRegislickPX(item) { 
            // Add logic to remove the selected item  
            axios.post('   http://127.0.0.1:8000/api/delEvaTab03xx',{
                id: item
            }).then(res => {  
                // console.log(res);
                this.products_Tab3 = this.products_Tab3.filter(item => item.id !== res.data);
            })
            .catch(error => {
                console.error('Error:', error);
            });    
        },   
        AddDataXXR(){
            //console.log('📤 Sending data:', this.products_Tab3T4);  

            if (!this.products_Tab3T4.length) {
                console.warn('❗ No data to send');
                return;
            }

            let self = this.products_Tab3T4[0];  // ✅ ดึง object แรกจาก array

            axios.post(' http://127.0.0.1:8000/api/saveexcucive', {
                p02_id: self.p02_id,
                px04_re1: self.px04_re1, 
                record: self.record, 
                fac_id: self.fac_id, 
                year: self.year, 
                staff_id: self.staff_id, 
            })
            .then((res) => {
                console.log('✅ Response data:', res.data);
            })
            .catch((error) => {
                console.error('❌ Error:', error);
            }); 
        },


        ///***********///



        async saveAssess() {
            try {
                const response = await axios.post('   http://127.0.0.1:8000/api/savedataAssess', { 
                    p_staffid: this.staffid_Main,
                    fac_id: this.facid_Main,
                    p_year: this.tracking_date.d_date,
                    evalua: this.tracking_date.evalua, 
                    corecompetencies: this.coreCompetencies,
                    jobspecificcompetencies: this.jobSpecificCompetencies,
                    otherCompetencies: this.otherCompetencies
                    
                }); 
                // console.log( this.staffid_Main,this.facid_Main,this.dataPor.evalua, this.coreCompetencies,this.jobSpecificCompetencies, );
                
                // Assuming the response is successful
                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: 'ข้ลมูลผลการประเมินถูกบันทึกเสร็จสิ้น',
                    showConfirmButton: false,
                    timer: 1000
                });

            } catch (error) {
                console.error('Error saving data:', error);
                Swal.fire({
                    position: 'top-end',
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
                    showConfirmButton: false,
                    timer: 1000
                });
            }
        },    
        async printDatacoversheet() { 
            // console.log('printStaffData: ',this.printStaffData);
            
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession();     
            // const form = {
            //     // staff_id: this.staffid_Main, // รหัสพันงาน
            //     group_id: this.groupid_Main, // กลุ่ม?
            //     fac_id: this.facid_Main, // คณะ
            //     year_id: this.tracking_date.d_date, // ปี
            //     evalua: this.tracking_date.evalua , // รอบ
            //     PREFIXFULLNAME:user.user.name.PREFIXFULLNAME, // คำนำนาย
            //     STAFFNAME :user.user.name.STAFFNAME, // ชื่อ
            //     STAFFSURNAME:user.user.name.STAFFSURNAME, // สกุล
            //     POSITIONNAME:user.user.name.POSITIONNAME, // ตำแหน่ง
            //     GROUPTYPENAME:user.user.name.GROUPTYPENAME, // พนักงาน
            //     POSTYPENAME:user.user.name.POSTYPENAME, // ปฏิบัติการ
            //     SCOPES:user.user.name.SCOPES.staffdepartmentname // สังกัด
            // }
            const form = {
                staff_id: this.printStaffData.staffid, // รหัสพันงาน
                group_id: this.groupid_Main, // กลุ่ม
                fac_id: this.facid_Main, // คณะ
                year_id: this.tracking_date.d_date, // ปี
                evalua: this.tracking_date.evalua , // รอบ
                PREFIXFULLNAME: this.printStaffData.prefixfullname, // คำนำนาย
                STAFFNAME : this.printStaffData.staffname, // ชื่อ
                STAFFSURNAME: this.printStaffData.staffsurname, // สกุล
                POSITIONNAME: this.printStaffData.posnameth, // ตำแหน่ง
                GROUPTYPENAME: this.printStaffData.stftypename, // พนักงาน
                POSTYPENAME: this.printStaffData.postypenameth, // ปฏิบัติการ
                SCOPES: this.printStaffData.departmentname // สังกัด
            }
            // console.log('form: ',form);

            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `    http://127.0.0.1:8000/printReportCoverpage?${queryParams}`;
            window.location.href = url;
 
        },   
        async printDataP01() {  
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession(); 
            // console.log(user.user.name);   
            // const form = {
            //     staff_id: this.staffid_Main,
            //     group_id: this.groupid_Main,
            //     fac_id: this.tracking_date.fac_id,
            //     year_id: this.tracking_date.d_date,
            //     evalua: this.tracking_date.evalua,
            //     PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
            //     STAFFNAME :user.user.name.STAFFNAME,
            //     STAFFSURNAME:user.user.name.STAFFSURNAME,
            //     POSITIONNAME:user.user.name.POSITIONNAME,
            //     GROUPTYPENAME:user.user.name.GROUPTYPENAME,
            //     POSTYPENAME:user.user.name.POSTYPENAME, 
            //     SCOPES:user.user.name.SCOPES.staffdepartmentname
            // }
              const form = {
                staff_id: this.printStaffData.staffid, // รหัสพันงาน
                group_id: this.groupid_Main, // กลุ่ม
                fac_id: this.facid_Main, // คณะ
                year_id: this.tracking_date.d_date, // ปี
                evalua: this.tracking_date.evalua , // รอบ
                PREFIXFULLNAME: this.printStaffData.prefixfullname, // คำนำนาย
                STAFFNAME : this.printStaffData.staffname, // ชื่อ
                STAFFSURNAME: this.printStaffData.staffsurname, // สกุล
                POSITIONNAME: this.printStaffData.posnameth, // ตำแหน่ง
                GROUPTYPENAME: this.printStaffData.stftypename, // พนักงาน
                POSTYPENAME: this.printStaffData.postypenameth, // ปฏิบัติการ
                SCOPES: this.printStaffData.departmentname // สังกัด
            }
            
            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `    http://127.0.0.1:8000/report_p01?${queryParams}`;
            window.open(url, '_blank');
 
        },
        async printDataP02() { 
            const { signIn, getSession, signOut } = await useAuth() 
            const user = await getSession();   
            // const form = {
            //     staff_id: this.staffid_Main,
            //     group_id: this.groupid_Main,
            //     fac_id: this.tracking_date.fac_id,
            //     year_id: this.tracking_date.d_date,
            //     evalua: this.tracking_date.evalua,
            //     PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
            //     STAFFNAME :user.user.name.STAFFNAME,
            //     STAFFSURNAME:user.user.name.STAFFSURNAME,
            //     POSITIONNAME:user.user.name.POSITIONNAME,
            //     GROUPTYPENAME:user.user.name.GROUPTYPENAME,
            //     POSTYPENAME:user.user.name.POSTYPENAME, 
            //     SCOPES:user.user.name.SCOPES.staffdepartmentname,
            //     postypename: `ระดับ${this.postypename}`,
            //     postypenameid: this.postypenameid
            // } 
              const form = {
                staff_id: this.printStaffData.staffid, // รหัสพันงาน
                group_id: this.groupid_Main, // กลุ่ม
                fac_id: this.facid_Main, // คณะ
                year_id: this.tracking_date.d_date, // ปี
                evalua: this.tracking_date.evalua , // รอบ
                PREFIXFULLNAME: this.printStaffData.prefixfullname, // คำนำหน้า
                STAFFNAME : this.printStaffData.staffname, // ชื่อ
                STAFFSURNAME: this.printStaffData.staffsurname, // สกุล
                POSITIONNAME: this.printStaffData.posnameth, // ตำแหน่ง
                GROUPTYPENAME: this.printStaffData.stftypename, // พนักงาน
                POSTYPENAME: this.printStaffData.postypenameth, // ปฏิบัติการ
                SCOPES: this.printStaffData.departmentname, // สังกัด
                postypename: `ระดับ${this.printStaffData.postypenameth}`, // ระดับ
                postypenameid: this.printStaffData.posnameth === 'ผู้บริหาร' ? 90 : this.printStaffData.posnameid
                // postypename: `ระดับ${this.postypename}`, // ระดับ
                // postypenameid: this.postypenameid 
            }

            console.log('printStaffData: ',this.printStaffData);
            console.log('form: ',form);

            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `   http://127.0.0.1:8000/report_p02?${queryParams}`;
            window.open(url, '_blank');
 
        },  
        async printDataP03() { 
                const { signIn, getSession, signOut } = await useAuth()
                const user = await getSession();     
                // const form = {
                //     staff_id: this.staffid_Main,
                //     group_id: this.groupid_Main,
                //     fac_id: this.tracking_date.fac_id,
                //     year_id: this.tracking_date.d_date,
                //     evalua: this.tracking_date.evalua,
                //     PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                //     STAFFNAME :user.user.name.STAFFNAME,
                //     STAFFSURNAME:user.user.name.STAFFSURNAME,
                //     POSITIONNAME:user.user.name.POSITIONNAME,
                //     GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                //     POSTYPENAME:user.user.name.POSTYPENAME, 
                //     SCOPES:user.user.name.SCOPES.staffdepartmentname,
                //     postypename: `ระดับ${this.postypename}`   
                // } 
                 const form = {
                    staff_id: this.printStaffData.staffid, // รหัสพันงาน
                    group_id: this.groupid_Main, // กลุ่ม
                    fac_id: this.facid_Main, // คณะ
                    year_id: this.tracking_date.d_date, // ปี
                    evalua: this.tracking_date.evalua , // รอบ
                    PREFIXFULLNAME: this.printStaffData.prefixfullname, // คำนำหน้า
                    STAFFNAME : this.printStaffData.staffname, // ชื่อ
                    STAFFSURNAME: this.printStaffData.staffsurname, // สกุล
                    POSITIONNAME: this.printStaffData.posnameth, // ตำแหน่ง
                    GROUPTYPENAME: this.printStaffData.stftypename, // พนักงาน
                    POSTYPENAME: this.printStaffData.postypenameth, // ปฏิบัติการ
                    SCOPES: this.printStaffData.departmentname, // สังกัด
                    postypename: `ระดับ${this.printStaffData.postypenameth}`, // ระดับ
                    postypenameid: this.printStaffData.posnameth === 'ผู้บริหาร' ? 90 : this.printStaffData.posnameid
                }

                const queryParams = new URLSearchParams(form).toString();
                // console.log(queryParams); 
                const url = `   http://127.0.0.1:8000/report_p03?${queryParams}`;
                window.open(url, '_blank'); 
        }, 
        async printDataP04() {  
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession()   
            // const form = {
            //     staff_id: this.staffid_Main,
            //     group_id: this.groupid_Main,
            //     fac_id: this.tracking_date.fac_id,
            //     year_id: this.tracking_date.d_date,
            //     evalua: this.tracking_date.evalua ,
            //     PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
            //     STAFFNAME :user.user.name.STAFFNAME,
            //     STAFFSURNAME:user.user.name.STAFFSURNAME,
            //     POSITIONNAME:user.user.name.POSITIONNAME,
            //     GROUPTYPENAME:user.user.name.GROUPTYPENAME,
            //     POSTYPENAME:user.user.name.POSTYPENAME, 
            //     SCOPES:user.user.name.SCOPES.staffdepartmentname     
            // } 

            const form = {
                    staff_id: this.printStaffData.staffid, // รหัสพันงาน
                    group_id: this.groupid_Main, // กลุ่ม
                    fac_id: this.facid_Main, // คณะ
                    year_id: this.tracking_date.d_date, // ปี
                    evalua: this.tracking_date.evalua , // รอบ
                    PREFIXFULLNAME: this.printStaffData.prefixfullname, // คำนำหน้า
                    STAFFNAME : this.printStaffData.staffname, // ชื่อ
                    STAFFSURNAME: this.printStaffData.staffsurname, // สกุล
                    POSITIONNAME: this.printStaffData.posnameth, // ตำแหน่ง
                    GROUPTYPENAME: this.printStaffData.stftypename, // พนักงาน
                    POSTYPENAME: this.printStaffData.postypenameth, // ปฏิบัติการ
                    SCOPES: this.printStaffData.departmentname, // สังกัด 
                }

            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `   http://127.0.0.1:8000/report_p04?${queryParams}`;
            window.open(url, '_blank'); 
        },     

    }, 
    
    filters: {
        removeC: function (value) {
            if (!value) return '';
            return value.split(':')[0];
        } 
    }

}
</script>

<style scoped>
label {
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left;  
    margin: 0;  
    padding: 0;  
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
th,
td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
}
th {
    background-color: #ffffff;
}
th,
td:first-child {
    width: 35%; /* Adjusted width for first column */
}
td:nth-child(2),
td:nth-child(3) {
    width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
    margin: 5px 0; /* Reduced margin */
    font-size: 14px; /* Smaller font size for form */
}
.add-button,
.save-button,
.cancel-button {
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
.edit-icon,
.delete-icon {
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
label {
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left; 
    margin: 0; 
    padding: 0;  
}
.table {
    width: 100%;
    border-collapse: collapse;
}
.table th,
.table td {
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
    text-align: center;  
}
.custom-textarea {
    width: 100%;  
    height: 100px;  
    padding: 10px;  
    border-radius: 5px;  
    border: 1px solid #ccc;  
    font-size: 1rem;  
    resize: none;  
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
th,
td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
}
th {
    background-color: #ffffff;
}
th,
td:first-child {
    width: 35%; /* Adjusted width for first column */
}
td:nth-child(2),
td:nth-child(3) {
    width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
    margin: 5px 0; /* Reduced margin */
    font-size: 14px; /* Smaller font size for form */
}
.add-button,
.save-button,
.cancel-button {
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
.edit-icon,
.delete-icon {
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

.styled-table th,
.styled-table td {
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