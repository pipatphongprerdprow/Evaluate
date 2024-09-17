<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-4"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-credit-card" style="font-size: x-large;"></i> ประวัติการประเมิน</h3>    
                    </div> 
                   
                    <div class="col md:col-4"> 
                        <label for="year_text">ปีงบประมาณ: </label> 
                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ" style="width: 60%;"></Dropdown> 
                    </div>  
                    <div class="col md:col-4"> 
                        <label for="year_text">รอบประเมิน: </label> 
                        <Dropdown id="evaluation_text" v-model="dropdownItemRecord" :options="dropdownItemRecords" optionLabel="name" placeholder="รอบประเมิน" style="width: 70%;"></Dropdown> 
                    </div>   
                </div>   
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th>ผู้รับการประเมิน</th>  
                            <th>สัดส่วน</th>  
                            <th>คะแนน ป.01</th>  
                            <th>คะแนน ป.02</th>  
                            <th>ผลรวม</th>  
                            <th>ประเมิน</th>

                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 20%;text-align: left;">
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b>
                            </td> 
                            <td style="text-align: center;width: 20%;"><b>{{ }}</b></td>
                            <td style="text-align: center;width: 20%;"><b>{{ }}</b></td>
                            <td style="text-align: center;width: 20%;"><b>{{ }}</b></td> 
                            <td style="text-align: center;width: 10%;"><b>{{ }}</b></td> 
                            <td style="text-align: center;width: 10%;">
                                <Button  label="ประเมิน" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>
                        </tr> 
                    </tbody>
                </table>
                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw',height: '100vh' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3 style="text-align: left;">แบบรายงานผลการปฏิบัติราชการของข้าราชการและพนักงาน</h3> 
                            <InputText v-model="dataStaffid" type="hidden" autocomplete="off" style="display: none;"/>    
                        </template>
                        <TabView :activeIndex="activeIndex" @tabChange="onTabChange">
                            <!-- Tab 1 -->
                            <TabPanel header="ผลสัมฤทธิ์ของงาน">
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
                                                        <th colspan="5" style="width: 15%;">ระดับการประเมินตนเอง<br> (ค่าคะแนนที่ได้)</th> 
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
                                                    <template v-for="(h, ind) in products_Tab1" :key="ind">
                                                        <tr>
                                                            <td style="text-align: left;" colspan="9">
                                                                <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b> 
                                                            </td> 
                                                        </tr> 
                                                        <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                                                            <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                                            <td style="text-align: left;">
                                                                <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                                                <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                                                    <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
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
                                                            <td class="text-center" colspan="5">  
                                                                <Dropdown 
                                                                    class="mb-1" 
                                                                    v-model="subP01.p01_score" 
                                                                    :options="p01_scores" 
                                                                    optionLabel="name" 
                                                                    optionValue="code" 
                                                                    placeholder="เลือกคะแนน" 
                                                                    :value="subP01.p01_score || p01_scores[0]" 
                                                                />
                                                                <textarea v-model="subP01.p01_detail" rows="3" class="custom-textarea" ></textarea> 
                                                                <Button label="บันทึกผล" icon="pi pi-save" class="mb-2 mr-2" @click="saveEvaTab1(subP01)" />  
                                                            </td> 
                                                        </tr>
                                                    </template>
                                                </tbody>
                                            </table> 

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
                                                                    <InputText 
                                                                        v-model.number="row1.data_table1" 
                                                                        type="text" 
                                                                        placeholder="0" 
                                                                        autocomplete="off"
                                                                        @input="(event) => event.target.value = event.target.value.replace(/[^0-9]/g, '')" 
                                                                    /> 
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
                                                                    <InputText 
                                                                        v-model.number="row2.data_table2" 
                                                                        type="text" 
                                                                        placeholder="0" 
                                                                        autocomplete="off"
                                                                        @input="(event) => event.target.value = event.target.value.replace(/[^0-9]/g, '')" 
                                                                    />  
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

                                            <div class="p-fluid formgrid grid"> 
                                                <B><h4>ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</h4></B>
                                                <div class="field col-12 md:col-12">  
                                                    <label for="improvements">1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</label>
                                                    <textarea v-model="improvements" rows="4" class="custom-textarea" ></textarea> 
                                                </div>
                                                <div class="field col-12 md:col-12">  
                                                    <label for="suggestions">2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</label>
                                                    <textarea v-model="suggestions" rows="4" class="custom-textarea" ></textarea> 
                                                </div>
                                                
                                            </div>  
                                            <div class="button-container">
                                                <Button label="บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม" icon="pi pi-save" class="mb-2 mr-2" @click="saveEvaTab1_1" /> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </TabPanel> 
                            <!-- Tab 2 -->
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
                                                            <td class="text-center" style="color: blue;"><b>15%</b></td> 
                                                            <td></td>
                                                            <td></td>
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
                                                            <td></td>
                                                            <td></td>
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
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>                                                      
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right" colspan="3">
                                                            <b style="color: blue;"> (8) ผลรวม</b>
                                                        </td>
                                                        <td></td>
                                                        
                                                    </tr>
                                                    <tr>
                                                    <td style="text-align: right; vertical-align: middle;" colspan="3">
                                                        <b style="color: blue;">(9) สรุปคะแนนส่วนพฤติกรรมการปฏิบัติราชการ   (สมรรถนะ) =	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                        <b style="color: blue;">  ผลรวมคะแนน ใน (8)</b>
                                                        <div style="display: flex; justify-content: flex-end;">
                                                            <hr style="border: 1px solid black; width: 20%;">
                                                        </div>
                                                        <b style="color: blue;">จำนวนสมรรถนะที่ใช้ในการประเมิน X 3 คะแนน</b>
                                                    </td>
                                                    <td></td>
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
                            <!-- Tab 3 -->
                            <TabPanel header="แผนพัฒนาการปฏิบัติราชการรายบุคคล" >
                                <div class="grid">
                                    <div class="col-12 lg:col-12 xl:col-12">
                                        <div class="card mb-0"> 
                                            <div class="p-fluid formgrid grid">
                                                <div class="field col-12 md:col-12"> 
                                                    <label for="list_no_p03">ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา<em style="color: red;">*</em></label>
                                                    <InputGroup style="text-align: center;">
                                                        <Textarea v-model="p04_re1" rows="4" placeholder="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" :disabled="chkP04 === 1" />
                                                        <Textarea v-model="p04_re2" rows="4" placeholder="วิธีการพัฒนา" :disabled="chkP04 === 1" />
                                                        <Textarea v-model="p04_re3" rows="4" placeholder="ช่วงเวลาที่ต้องการพัฒนา" :disabled="chkP04 === 1" /> 
                                                        <Button label="เพิ่ม" severity="info" @click="AddDatap04" :disabled="chkP04 === 1" />
                                                    </InputGroup>
                                                </div>
                                            </div>
                                            <DataTable :value="products_Tab3" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                                                <Column field="p04_re1" header="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" style="width: 35%">
                                                    <template #body="slotProps">
                                                        {{ slotProps.data.p04_re1 }}
                                                    </template>
                                                </Column>
                                                <Column field="p04_re2" header="วิธีการพัฒนา" style="width: 35%">
                                                    <template #body="slotProps">
                                                        {{ slotProps.data.p04_re2 }}
                                                    </template>
                                                </Column> 
                                                <Column field="p04_re3" header="ช่วงเวลาที่ต้องการพัฒนา" style="text-align: center; width: 30%">
                                                    <template #body="slotProps">
                                                        {{ slotProps.data.p04_re3 }}
                                                    </template>
                                                </Column>
                                                <Column style="text-align: center; width: 10%">
                                                    <template #body="slotProps">
                                                        <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(slotProps.data)" />
                                                    </template>
                                                </Column>
                                            </DataTable>  
                                            <div class="button-container">
                                                <Button label="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" icon="pi pi-save" class="mb-2 mr-2" @click="saveEvaTab3" :disabled="chkP04 === 1" /> 
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </TabPanel>
                            <!-- Tab 4 -->
                            <TabPanel header="รายงาน ป.04" >
                                <div class="card">
                                    <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
                                        <div class="p-fluid formgrid grid">
                                            <div class="card">                      
                                                <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>
                                                <!-- ตาราง ก. สมรรถนะหลัก -->
                                                <div class="employee-info"> 
                                                    <p><strong>รอบการประเมิน:</strong> </p>
                                                    <p><strong>ชื่อผู้รับการประเมิน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }} </p>
                                                    <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }} </p>
                                                    <p><strong>ระดับตำแหน่ง:</strong> </p>
                                                    <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }} </p>
                                                    <p><strong>ชื่อผู้ประเมิน:</strong> </p>
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
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
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
                                                    <p><strong>[ <b>&#10003;</b> ] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p>
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
                                                                ชื่อ <br>
                                                                ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                                                วันที่ .......... เดือน .......................... พ.ศ...........
                                                            </td>
                                                        <td class="center-align"><br><br>
                                                            ลงชื่อ .................................................................<br>
                                                            ชื่อ <br>
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
                                                                ชื่อ <br>
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
                            <Button label="ตกลง" severity="secondary" class="mb-2 mr-2" @click="DialogAdd = false " />
                        </template>
                    </Dialog>
                </div>
            </div>
        </div>
    </div>     
</template>

<script setup> 
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    console.log(user);
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
            staffid_po: 130102,
            staffid_Main: 5009942,
            facid_Main: 201092704000,
            groupid_Main: '01', 
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
        }
    },
    components: {
        TabView,
        TabPanel
    }, 
    mounted(){ 
        this.showDataEvalu();  
    },
    methods: { 
        // ตารางรายชื่อ
        async showDataEvalu(){
            await axios.get('http://localhost:8000/api/showDataEvalu',{
                params: {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main, 
                    group_id: this.groupid_Main,
                    year: this.dropdownItemYear,
                },
            }).then(res => {     
                // console.log(res.data);  
                this.products=res.data;   
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // เพิ่มคะแนนประเมิน
        openDataEvalu(staff_id){   
            this.dataStaffid = staff_id
            this.products_Tab1 = [];  
            this.p01_scores = [
                { name: '- ไม่ระบุ -', code: 0 },
                { name: '1 คะแนน', code: 1 },
                { name: '2 คะแนน', code: 2 },
                { name: '3 คะแนน', code: 3 },
                { name: '4 คะแนน', code: 4 },
                { name: '5 คะแนน', code: 5 },
            ];

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

            this.showdataPo(staff_id,this.facid_Main,this.dropdownItemYear.code,this.dropdownItemRecord.code);
            axios.post('http://localhost:8000/api/showDataP03New',{
                staff_id: staff_id,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.code,
                record: this.dropdownItemRecord.code,
            }).then(res => {     
                // console.log(res.data);    
                if (res.data && Array.isArray(res.data)) {
                    this.products_Tab1 = res.data; 
                    this.products_Tab1.forEach(h => {
                        h.subP01sX.forEach(subP01 => {
                            // ตรวจสอบว่าค่า p01_score นั้นถูกต้องหรือไม่
                            const foundScore = this.p01_scores.find(score => score.code === subP01.p01_score);
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
            .catch(error => {
                console.error('Error:', error);
            });
        },

        showdataPo(staff_id,fac_id,year_id,record){  
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

                    this.jobSpecificCompetencies.forEach(item => {
                        if (item.id === 6) {
                            item.data_table2 = data.p6;  // Update based on the API response
                        } else if (item.id === 7) {
                            item.data_table2 = data.p7;  // Update based on the API response
                        } else if (item.id === 8) {
                            item.data_table2 = data.p8;  // Add more conditions if necessary
                        } else if (item.id === 9) {
                            item.data_table2 = data.p9;  // Add more conditions if necessary
                        } else if (item.id === 10) {
                            item.data_table2 = data.p10;  // Add more conditions if necessary
                        } else if (item.id === 11) {
                            item.data_table2 = data.p11;  // Add more conditions if necessary
                        }
                    });

                    // Update other fields
                    this.improvements = data.improvements;
                    this.suggestions = data.suggestions;
                }
                
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },

        saveEvaTab1(subP01) {  
            if(subP01.p01_score === 0){
                Swal.fire("แจ้งเตือน","กรุณาเลือกคะแนน !","error");
            }else{
                axios.post('http://localhost:8000/api/saveP03Po',{
                    staffid_po: this.staffid_po,
                    p01_id: subP01.p01_id,
                    p01_score: subP01.p01_score,
                    p01_detail: subP01.p01_detail,
                }).then(res => {     
                    // console.log(res.data);   
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: "ข้ลมูลผลการประเมินถูกบันทึกเสร็จสิ้น",
                        showConfirmButton: false,
                        timer: 1000
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            }
 
        },

        async saveEvaTab1_1() { 
            const payload = {
                staffid_po: this.staffid_po,
                staff_id: this.staffid_Main, 
                fac_id: this.facid_Main, 
                year: this.dropdownItemYear.code,
                record: this.dropdownItemRecord.code,
                coreCompetencies: this.coreCompetencies,
                jobSpecificCompetencies: this.jobSpecificCompetencies,
                otherCompetencies: this.otherCompetencies,
                improvements: this.improvements,
                suggestions: this.suggestions
            }; 
            const res = await axios.post('http://localhost:8000/api/saveP03PoTab1', payload);
                // console.log(res.data);  
                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: "บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม เสร็จสิ้น",
                    showConfirmButton: false,
                    timer: 1500
                }); 
        },

        onTabChange(event) { 
            // console.log(event.index);
            if (event.index==0) {
                console.log('ผลสัมฤทธิ์ของงาน -',event.index); 
            }
            if(event.index==1){
                console.log('รายงาน ป.01 - ป.03 -',event.index); 

                this.tab2Data(this.dataStaffid);  
                this.showdataPoText(this.dataStaffid,this.facid_Main,this.dropdownItemYear.code,this.dropdownItemRecord.code); 
            }
            if (event.index==2) {
                console.log('แผนพัฒนาการปฏิบัติราชการรายบุคคล -',event.index); 
                this.products_Tab3 =[];
                this.chkp04(this.dataStaffid,this.facid_Main,this.dropdownItemYear.code,this.dropdownItemRecord.code); 
                this.chkp04data(this.dataStaffid,this.facid_Main,this.dropdownItemYear.code,this.dropdownItemRecord.code);  
            }
            if (event.index==3) {
                console.log('รายงาน ป.04 -',event.index);
                this.chkp04dataT4(this.dataStaffid,this.facid_Main,this.dropdownItemYear.code,this.dropdownItemRecord.code);   
            }
        },  
        tab2Data(staff_id){  
            axios.post('http://localhost:8000/api/showDataP03New',{
                staff_id: staff_id,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.code,
                record: this.dropdownItemRecord.code,
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

        chkp04(staff_id,fac_id,year_id,record){
            axios.post('http://localhost:8000/api/showDataPo',{
                staff_id: staff_id,
                fac_id: fac_id,
                year_id: year_id,
                record: record,
            }).then(res => {     
                // console.log(res.data);    
                if (res.data.length > 0) {
                    this.chkP04 = 0; 
                }else{
                    this.chkP04 = 1; 
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },

        AddDatap04(){ 
            const newData = {
                p04_re1: this.p04_re1,
                p04_re2: this.p04_re2,
                p04_re3: this.p04_re3,
            };
            this.products_Tab3.push(newData); 
            this.p04_re1 = '';
            this.p04_re2 = '';
            this.p04_re3 = '';
        },
        DeleteRegislick(item) {
            // Add logic to remove the selected item
            this.products_Tab3 = this.products_Tab3.filter((product) => product !== item);
        },
        saveEvaTab3(){  
            axios.post('http://localhost:8000/api/saveEvaTab3',{
                staff_id: this.dataStaffid,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.code,
                record: this.dropdownItemRecord.code,
                products_Tab3: this.products_Tab3
            }).then(res => {     
                console.log(res.data);    
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
        chkp04data(staff_id,fac_id,year_id,record){
            axios.post('http://localhost:8000/api/showData04Tab3',{
                staff_id: staff_id,
                fac_id: fac_id,
                year_id: year_id,
                record: record,
            }).then(res => {     
                // console.log(res.data);     
                if(res.data.length > 0){
                    res.data.forEach(p04 => {
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
            .catch(error => {
                console.error('Error:', error);
            });
        },
        chkp04data(staff_id,fac_id,year_id,record){
            axios.post('http://localhost:8000/api/showData04Tab3',{
                staff_id: staff_id,
                fac_id: fac_id,
                year_id: year_id,
                record: record,
            }).then(res => {     
                // console.log(res.data);     
                if(res.data.length > 0){
                    res.data.forEach(p04 => {
                        const newData = {
                            p04_re1: p04.p04_re1,
                            p04_re2: p04.p04_re2,
                            p04_re3: p04.p04_re3
                        };
                        this.products_Tab3.push(newData); 
                    });  
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
        async mounted() {
                const  { signIn, getSession, signOut } = await useAuth()
                const user = await getSession();
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