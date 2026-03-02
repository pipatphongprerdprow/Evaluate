<template> 
    <div class="grid"> 
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-5"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-credit-card" style="font-size: x-large;"></i> ตรวจติดตามแบบประเมิน</h3>    
                    </div>

                    <!-- {{ products }}  -->

                     <!-- {{ user.user }}    -->

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
                        <Button class="mb-2 mr-2" icon="pi pi-search" :disabled="loading || !tracking_date" @click="xxr" /> &nbsp;&nbsp;&nbsp;&nbsp;
                        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2" :disabled="loading" @click="printDatatracking" />
                    </div>  
                    <div v-if="loading" class="loading-wrap">
                        <ProgressSpinner style="width:60px;height:60px" strokeWidth="6" />
                        <div class="mt-2">กำลังโหลดข้อมูล…</div>
                    </div>
                <table class="table">
                    <thead> 
                        <!-- <tr style="height: 40px;background-color: blanchedalmond;">
                            <th style="width: 60%;">ผู้รับการประเมิน</th>  
                            <th>สัดส่วน</th>  
                            <th>ผลรวมสัดส่วน <br>70 หรือ 50</th>  
                            <th>ผลรวมสัดส่วน <br>30 </th>   
                            <th>ผลสัมฤทธิ์ของงาน</th>  
                            <th>พฤติกรรมการปฏิบัติราชการ</th>  
                            <th>ผลคะแนน</th>  
                            <th>ประเมิน</th>  
                        </tr> --> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th style="width: 60%;">ผู้รับการประเมิน</th>  
                            <th>สัดส่วน</th>  
                            <th>ผลสัมฤทธิ์ของงาน</th>  
                            <th>ผลรวมสัดส่วน <br>70 หรือ 50</th>  
                            <th>พฤติกรรมการปฏิบัติราชการ</th>
                            <th>ผลรวมสัดส่วน <br>30 หรือ 50 </th>   
                            <th>ผลคะแนน</th>  
                            <th>ประเมิน</th>  
                        </tr>
                    </thead>
                    <tbody> 
                        <!-- <tr v-for="(Item, index) in products.filter(item => item.tb_tor).concat(products.filter(item => !item.tb_tor))" :key="index">
                            <td style="padding-left: 5px;width: 30%;text-align: left;">   
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b> 
                            </td> 
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.persen : '' }}</b></td>  

                            <td class="text-center" style="color: red;"><b>{{ calcAchievement(Item) }}</b></td>
                            <td class="text-center" style="color: red;"><b>{{ calcBehavior(Item) }}</b></td> 

                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.achievement_score : '' }}</b></td>    
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.behavior : '' }}</b></td>
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.sum_score : '' }} </b></td>  
                            <td style="text-align: center;width: 10%;">  
                                <div v-if="Item.tb_tor">
                                    <Button 
                                        label="ประเมิน" 
                                        class="mb-2 mr-2" 
                                        icon="pi pi-list" 
                                        @click="openDataEvalu(Item)" 
                                    />  
                                </div>
                                <div v-else>
                                    <p style="color: brown;">-รอข้อมูลการประเมิน-</p>
                                </div> 
                            </td> 
                        </tr> -->

                        <tr v-for="(Item, index) in products.filter(item => item.tb_tor).concat(products.filter(item => !item.tb_tor))" :key="index">
                            <td style="padding-left: 5px;width: 30%;text-align: left;">   
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b> 
                            </td>  
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.persen : '' }}</b></td>  
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.achievement_score : '' }}</b></td>   
                            <td class="text-center" style="color: brown;"><b>{{ calcAchievement(Item) }}</b></td>
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.behavior : '' }}</b></td> 
                            <td class="text-center" style="color: brown;"><b>{{ calcBehavior(Item) }}</b></td>   
                            <td class="text-center" style="color: blue;"><b>{{ Item.tb_tor ? Item.tb_tor.sum_score : '' }} </b></td>  
                            <td style="text-align: center;width: 10%;">  
                                <!-- <div v-if="Item.tb_tor">
                                    <Button  label="ประเมิน" class="mb-2 mr-2" icon="pi pi-list" @click="openDataEvalu(Item)" />  
                                </div> -->
                                <div v-if="Item.tb_tor">
                                    <Button
                                        label="ประเมิน"
                                        class="mb-2 mr-2"
                                        icon="pi pi-list"
                                        :loading="loadingEvaluIndex === index"
                                        :disabled="loadingEvalu"
                                        @click="openDataEvalu(Item, index)"
                                    />
                                </div>

                                <div v-else>
                                    <p style="color: brown;">-รอข้อมูลการประเมิน-</p>
                                </div> 
                            </td> 
                        </tr>

                    </tbody> 
                </table>   
                <!-- <div style="text-align: center;">
                    <Button 
                        label="บันทึกผลคะแนน" 
                        class="mb-2 mr-2" 
                        icon="pi pi-save" 
                        style="background-color:orangered; color: white;" 
                        @click="saveScore"/>
                </div>  -->

                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw',height: '100vh' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3 style="text-align: left;">แบบรายงานผลการปฏิบัติราชการของข้าราชการและพนักงาน</h3>  
                            <InputText v-model="dataStaffid" type="hidden" autocomplete="off" style="display: none;"/> 
                           <!-- <p v-if="currentstaff?.length"> <strong>ชื่อผู้รับการประเมิน:</strong>  {{ currentstaff[0]?.prefixfullname || '-' }}  {{ currentstaff[0]?.staffname || '-' }}  {{ currentstaff[0]?.staffsurname || '-' }} </p> -->
                           <p v-if="currentstaff?.length">
                            <strong>ชื่อผู้รับการประเมิน:</strong> {{ currentstaff?.[0]?.prefixfullname || '-' }} {{ currentstaff?.[0]?.staffname || '-' }} {{ currentstaff?.[0]?.staffsurname || '-' }}
                            </p>
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
                                                        <th rowspan="2" style="width: 15%;">กิจกรรม / โครงการ / งาน</th>
                                                        <th rowspan="2" style="width: 20%;">ตัวชี้วัด / เกณฑ์การประเมิน</th>
                                                        <th rowspan="2" style="width: 20%;">รายงานการปฏิบัติราชการ</th>
                                                        <th rowspan="2" style="width: 20%;">หลักฐานเชิงประจักษ์</th> 
                                                        <th rowspan="2" style="width: 10%;">ค่าคะแนนประเมินตนเอง</th>  
                                                        <th colspan="5" style="width: 15%;">ค่าคะแนนที่ได้</th>  
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
                                                            <td colspan="10" style="text-align: left;">
                                                                <b style="color: blue;">{{ h?.h_no || '-' }}. {{ h?.nameH || '-' }}</b> 
                                                            </td> 
                                                        </tr> 
                                                        <tr v-for="(subP01, idx) in h?.subP01sX || []" :key="idx">
                                                            <!-- <td style="text-align: left;">{{ subP01?.p01_no || '-' }} {{ subP01?.p01_subject || '-' }}</td> -->
                                                             <td style="text-align:left;">
                                                                <template v-for="(ln, i) in parseActivityText(subP01.p01_subject).lines" :key="i">
                                                                    <div v-if="ln.type === 'main'" style="font-weight:700; margin-bottom:4px;">
                                                                    <!-- {{ subP01.p01_no }} {{ ln.text }} -->
                                                                          {{ subP01.p01_no }} {{ stripLeadingNo(ln.text) }}
                                                                    </div>
                                                                    <div v-else class="subline">
                                                                    <span class="subno">{{ ln.no }}</span>
                                                                    <span class="subtext">{{ ln.text }}</span>
                                                                    </div>
                                                                </template>
                                                            </td> 


                                                            <td style="text-align: left;">
                                                                <!-- <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ subP01?.p01_subject || '-' }}</b> -->
                                                                 <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ getMainSubject(subP01.p01_subject) }}</b>

                                                                <div v-for="(subIitem, idI) in subP01?.subITems || []" :key="idI">
                                                                    <div v-if="subIitem?.ind_no !== 0">
                                                                        <b>ระดับ {{ subIitem?.ind_no }}</b> {{ subIitem?.ind_Items || '-' }}
                                                                    </div>
                                                                    <div v-else>
                                                                        <b>{{ subIitem?.ind_Items || '-' }}</b>
                                                                    </div>
                                                                </div>
                                                            </td> 
 
                                                            <td style="text-align: left;">
                                                                <div v-if="(subP01?.subITemP03ind || []).length > 0">
                                                                    <div v-for="level in [1, 2, 3, 4, 5]" :key="level">

                                                                        <div v-if="subP01?.subITemP03ind?.some(item => item?.p03ind_no === level + '')">
                                                                            <b>ระดับ {{ level }}</b>

                                                                            <div v-for="(item, index) in subP01?.subITemP03ind?.filter(item => item?.p03ind_no === level + '')" :key="index">
                                                                                <div>{{ index + 1 }}. {{ item?.p03ind_Items || '-' }}</div>
                                                                            </div>
                                                                        </div>

                                                                    </div>
                                                                </div>

                                                                <div v-else style="color: red;">- ไม่มีข้อมูล -</div>
                                                            </td> 

                                                            <td style="text-align: left;"> 
                                                                <p v-for="(subIitemDoc, inDoc) in (subP01?.subITemP03doc || []).slice().sort((a, b) => a.doc_no - b.doc_no)" 
                                                                :key="inDoc"> 
                                                                    <a v-if="subIitemDoc?.doc_file" 
                                                                    :href="' http://127.0.0.1:8000/storage/uploadsP03/' + subIitemDoc?.doc_file" target="_blank">
                                                                        <b>เอกสารลำดับที่ {{ subIitemDoc?.doc_no }}</b> {{ subIitemDoc?.doc_name || '-' }}
                                                                    </a> 
                                                                    <a v-else-if="subIitemDoc?.doc_link" 
                                                                    :href="subIitemDoc?.doc_link" target="_blank">
                                                                        <b>เอกสารลำดับที่ {{ subIitemDoc?.doc_no }}</b> {{ subIitemDoc?.doc_name || '-' }}
                                                                    </a>
                                                                </p>
                                                                <p v-if="(subP01?.subITemP03doc || []).length === 0" style="color: red;">- ไม่มีข้อมูล -</p>
                                                            </td> 
                                                            <td style="text-align: center;">{{ subP01?.score || '-' }}</td>   
                                                            <td class="text-center" colspan="5">  
                                                                <Dropdown 
                                                                    v-model="subP01.p01_score" 
                                                                    :options="p01_scores" 
                                                                    optionLabel="name" 
                                                                    optionValue="code" 
                                                                    placeholder="เลือกคะแนน" 
                                                                />  
                                                                <textarea  class="p-inputtextarea p-inputtext p-component" v-model="subP01.p01_detail" rows="3"></textarea> 
                                                                <Button label="บันทึกผล" icon="pi pi-save" @click="saveEvaTab1(subP01)" />  
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
                                                                <th>ก. สมรรถนะหลัก</th>
                                                                <th>(1)ระดับสมรรถนะที่คาดหวัง</th>
                                                                <th>ระดับสมรรถนะประเมินตนเอง</th> 
                                                                <th>(2)ระดับสมรรถนะที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody> 
                                                            <tr v-for="(row1, index) in coreCompetencies" :key="index">
                                                                <!-- <td style="text-align: left;">{{ row1.activity }}</td>  -->
                                                                 <td class="clickable" @click="openCompetencyDialog('core', row1)">
                                                                    {{ row1.activity }}
                                                                </td>
                                                                
                                                                <td>{{ row1.indicator }}</td>
                                                                <td>
                                                                    <b v-if="!row1.selfAssessment" style="color: red;">0</b> 
                                                                    <b v-else style="color: blue">{{ row1.selfAssessment }}</b> 
                                                                </td>
                                                                <td>
                                                                    <InputNumber 
                                                                        v-model.number="row1.data_table1" 
                                                                        placeholder="0"
                                                                        :min="0" 
                                                                        :max="5" 
                                                                        showButtons
                                                                    />   
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <!-- ตาราง ข. สมรรถนะเฉพาะ -->
                                                <div class="field col-12 md:col-4"> 
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th>ข. สมรรถนะเฉพาะ</th>
                                                                <th>(3)ระดับสมรรถนะที่คาดหวัง</th>
                                                                <th>ระดับสมรรถนะประเมินตนเอง</th> 
                                                                <th>(4)ระดับสมรรถนะที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row2, index) in jobSpecificCompetencies" :key="index">
                                                                <!-- <td style="text-align: left;"> ข. {{ index+1 }} {{ row2.WORK_NAME }}</td>  -->
                                                                 <td class="clickable" @click="openCompetencyDialog('job', row2, index)">
                                                                    ข. {{ index + 1 }} {{ row2.WORK_NAME }}
                                                                </td>

                                                                <td> {{ row2.COMPLEVEL }}</td>
                                                                <td>
                                                                    <b v-if="!row2.SCOREPERSON" style="color: red;">0</b> 
                                                                    <b v-else style="color: blue;">{{ row2.SCOREPERSON }}</b> 
                                                                </td>
                                                                <td>
                                                                    <InputNumber 
                                                                        v-model.number="row2.SCORE"
                                                                        placeholder="0"
                                                                        :min="0" 
                                                                        :max="5" 
                                                                        showButtons
                                                                    />    
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <!-- ตาราง ค. สมรรถนะทางการบริหาร -->
                                                <div class="field col-12 md:col-4"> 
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th>ค. สมรรถนะทางการบริหาร</th>
                                                                <th>(5)ระดับสมรรถนะที่คาดหวัง</th>
                                                                <th>ระดับสมรรถนะประเมินตนเอง</th>
                                                                <th>(6)ระดับสมรรถนะที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row3, index) in otherCompetencies" :key="index">
                                                                <!-- <td style="text-align: left;">{{ row3.activity }}</td>  -->
                                                                <td class="clickable" @click="openCompetencyDialog('other', row3)">
                                                                    {{ row3.activity }}
                                                                </td>
                                                                <td> 
                                                                    <b v-if="!row3.indicator3" style="color: red;">-</b>
                                                                    <span v-else>{{ row3.indicator3 }}</span>  
                                                                </td>
                                                                <td>  
                                                                    <b v-if="!row3.datatable3" style="color: red;">-</b> 
                                                                    <b v-else style="color: blue">{{ row3.datatable3 }}</b>  
                                                                </td>
                                                               
                                                                <td>  
                                                                    <!-- <template v-if="Number(posadio) === 128 && !['110105','110146', '160018'].includes(String(staffid_Main))"> 
                                                                        <InputNumber 
                                                                            v-model.number="row3.selfAssessment3" 
                                                                            type="text" 
                                                                            placeholder="0" 
                                                                            autocomplete="off" 
                                                                            showButtons
                                                                        />
                                                                    </template>
                                                                    <template v-else>
                                                                        <b><span style="color: red;">-</span></b>
                                                                    </template> -->
                                                                    
                                                                   <template v-if="isTargetExecutive && canScoreExecutive">
                                                                        <InputNumber 
                                                                            v-model.number="row3.selfAssessment3"
                                                                            placeholder="0"
                                                                            :min="0"
                                                                            :max="5"
                                                                            showButtons
                                                                        />
                                                                    </template>
                                                                    <template v-else>
                                                                        <b><span style="color: red;">-</span></b>
                                                                    </template>
                                                                </td>
                                                            </tr> 
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="p-fluid formgrid grid">
                                                <div class="field col-12">
                                                    <h4>ความเห็นเพิ่มเติมของผู้ประเมิน</h4>
                                                    <label>
                                                        1)<span style="color:red;">*</span>
                                                         จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข 
                                                        <span style="color:red;">(ถ้าไม่มีให้ใส่ '-')</span>
                                                    </label>
                                                    <textarea class="p-inputtextarea p-inputtext p-component" v-model="improvements" rows="4"></textarea> 
                                                </div>
                                                <div class="field col-12">  
                                                    <label>
                                                        2)<span style="color:red;">*</span>
                                                        ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา
                                                        <span style="color:red;">(ถ้าไม่มีให้ใส่ '-')</span>
                                                    </label>
                                                    <textarea class="p-inputtextarea p-inputtext p-component" v-model="suggestions" rows="4"></textarea> 
                                                </div> 
                                            </div>   
                                            <div class="button-container">
                                                <Button label="บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม" icon="pi pi-save" @click="saveEvaTab1_1" /> 
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
                                                            <td style="text-align: left;" colspan="10">
                                                                <b style="color: blue;">{{ h.h_no }}. {{ h.nameH }}</b> 
                                                                <!-- {{ h.id }} -->
                                                            </td> 
                                                            <td class="text-center" style="color: blue;"> <b>{{ h.p01_weight??0 }}%</b></td>
                                                            <td></td>
                                                        </tr> 
                                                        <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                                                            <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>

                                                            <!-- แก้แดง -->
                                                            <!-- <td style="text-align: left;">
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
                                                            </td>  -->
                                                            <td style="text-align: left;">
                                                                <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b> 
                                                                <div v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px; margin-bottom: 5px;"> 
                                                                    <div v-if="subIitem.ind_no != 0">
                                                                        <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                                                                    </div> 
                                                                    <div v-else>
                                                                        <b>{{ subIitem.ind_Items }}</b>
                                                                    </div>
                                                                </div> 
                                                                <div v-if="subP01.p01_detail != null">
                                                                    <b style="color: red;">ข้อเสนอแนะ</b><br>
                                                                    <em style="color: red;">{{ subP01.p01_detail }}</em>
                                                                </div>
                                                            </td> 

                                                            <!-- <td style="text-align: left;">
                                                                <p v-for="(subIitemInd, inD) in subP01.subITemP03ind" :key="inD" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <div v-if="subIitemInd.p03ind_no!=0"><b>ระดับ {{ subIitemInd.p03ind_no }}</b> {{ subIitemInd.p03ind_Items }}</div>
                                                                    <div v-if="subIitemInd.p03ind_no==0"><b>{{ subIitemInd.p03ind_Items }}</b></div> 
                                                                </p>
                                                                <p v-if="subP01.subITemP03ind.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                                </p>  
                                                            </td>  -->
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
                                                            <!-- <td style="text-align: left;"> 
                                                                <p v-for="(subIitemDoc, inDoc) in subP01.subITemP03doc" :key="inDoc" style="padding-left: 8px;margin-bottom: 5px;"> 
                                                                    <a v-if="subIitemDoc.doc_file!=null" :href="'   http://127.0.0.1:8000/storage/uploadsP03/'+subIitemDoc.doc_file" target="_blank"><b>ระดับ</b> <b>{{subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                    <a v-if="subIitemDoc.doc_link!=null" :href="subIitemDoc.doc_link" target="_blank"><b>ระดับ</b> <b>{{ subIitemDoc.p03ind_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                </p>
                                                                <p v-if="subP01.subITemP03doc.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                                </p>
                                                            </td>    -->
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
                                                                <!-- <td style="text-align: left;">{{ row1.activity }}</td>  -->
                                                                <td class="clickable" @click="openCompetencyDialog('core', row1)">
                                                                    {{ row1.activity }}
                                                                </td>

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
                                                                <!-- <td style="text-align: left;"> ข. {{ index+1 }} {{ row2.WORK_NAME }}</td>  -->
                                                                <td class="clickable" @click="openCompetencyDialog('job', row2, index)">
                                                                    ข. {{ index + 1 }} {{ row2.WORK_NAME }}
                                                                </td>

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
                                                <!-- <div class="field col-12 md:col-4"> 
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
                                                </div> -->

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
                                                                <!-- <td style="text-align: left;">{{ row3.activity }}</td>  -->
                                                                 <td class="clickable" @click="openCompetencyDialog('other', row3)">
                                                                    {{ row3.activity }}
                                                                </td>
                                                                <td> 
                                                                    <b v-if="row3.indicator3 == '' ||  row3.indicator3 == null" style="color: red;">0</b>
                                                                    <span v-if="row3.indicator3 != 0">{{ row3.indicator3 }}</span>  
                                                                </td>
                                                                <td>  
                                                                    <b v-if="row3.datatable3 == '' ||  row3.datatable3 == null" style="color: red;">0</b> 
                                                                    <b v-if="row3.datatable3 != 0 " style="color: blue" >{{ row3.datatable3 }}</b> 
                                                                </td>
                                                                <td>  
                                                                    <!-- <b v-if="row3.selfAssessment3 == '' " style="color: red;">0</b>  -->
                                                                    <b v-if="row3.selfAssessment3 == '' ||  row3.selfAssessment3 == null" style="color: red;">0</b>
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
                            <!-- Tab 3 -->
                            <TabPanel header="แผนพัฒนาการปฏิบัติราชการรายบุคคล" >
                                <div class="grid">
                                    <div class="col-12 lg:col-12 xl:col-12">
                                        <div class="card mb-0"> 
                                            <div class="p-fluid formgrid grid">
                                                <div class="field col-12 md:col-12"> 
                                                    <label for="list_no_p03">ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา<em style="color: red;">*</em></label>
                                                    <!-- <InputGroup style="text-align: center;">
                                                        <Textarea v-model="p04_re1" rows="4" placeholder="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" :disabled="chkP04 === 1" />
                                                        <Textarea v-model="p04_re2" rows="4" placeholder="วิธีการพัฒนา" :disabled="chkP04 === 1" />
                                                        <Textarea v-model="p04_re3" rows="4" placeholder="ช่วงเวลาที่ต้องการพัฒนา" :disabled="chkP04 === 1" /> 
                                                        <Button label="เพิ่ม" severity="info" @click="AddDatap04" :disabled="chkP04 === 1" />
                                                    </InputGroup> -->
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
                                                <!-- <Column style="text-align: center; width: 10%">
                                                    <template #body="slotProps">
                                                        <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(slotProps.data)" />
                                                    </template>
                                                </Column> -->
                                            </DataTable>  
                                            <!-- <div class="button-container">
                                                <Button label="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" icon="pi pi-save" class="mb-2 mr-2" @click="saveEvaTab3" :disabled="chkP04 === 1" /> 
                                            </div> -->
                                        </div>
                                    </div>
                                </div>
                            </TabPanel>
                            <!-- Tab 4 --> 
                            <TabPanel header="รายงาน ป.04">
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
                                                    <!-- {{ (currentstaff[0]?.postypenameth === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' :currentstaff[0]?.postypenameth) }} --> 
                                                    <!-- {{ posnameth === 'ผู้บริหาร' || currentstaff?.[0]?.postypenameth === 'ชำนาญการ' }} -->
                                                    <!-- {{ currentstaff[0] }} -->
                                                    {{ currentstaff[0]?.posnameth=='ผู้บริหาร'&& !currentstaff[0]?.postypenameth   ? 'ชำนาญการพิเศษ' : currentstaff[0]?.postypenameth}}

                                                </p>
                                                <p v-if="currentstaff[0]?.facultyid == 201092700000">
                                                    <strong>สังกัด:</strong> {{ currentstaff[0]?.departmentname || '-' }}
                                                </p>
                                                <p v-else>
                                                    <strong>สังกัด:</strong> {{ currentstaff[0]?.facultyname || '-' }}
                                                </p>
                                                <p><strong>ชื่อผู้ประเมิน:</strong>  {{ assessorText || '-' }}</p>  
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
                            <Button label="ตกลง" severity="info" class="mb-2 mr-2" @click="DialogAdd = false " />
                        </template>
                    </Dialog>
                    <Dialog
                        header="รายละเอียดสมรรถนะ"
                        v-model:visible="competencyDialogVisible"
                        :modal="true"
                        :style="{ width: '80vw' }"
                        >
                        <h4>{{ selectedCompetency.title }}</h4>
                        <p style="white-space: pre-line;">
                            {{ selectedCompetency.description }}
                        </p>
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
// import { LogarithmicScale } from 'chart.js';
// import InputNumber from 'primevue/inputnumber'; 
// import ProgressSpinner from 'primevue/progressspinner'

//แสดง 1 ค.
const EXECUTIVE_ALLOWLIST = new Set([
    '160018',//นายจีรพันธ์ ภูครองเพชร
    '190015',//นางนงลักษณ์ พุ่มม่วง
    '130069',//นายขรรชัย กลิ่นผกา
    '110143',//นางวราลักษณ์ คุปต์บดินทร
    '190042',//นางฉวีวรรณ คืนสันเทียะ
    '110105',//นายจักริน เพชรสังหาร
    '1140016',//นางบงกชทิพย์ เกาะสมบัต
    '110407',//นายอานุภาพ งามสูงเนิน
    '110138',//นางฉันทลักษณ์ สาชำนาญ
    '120039',//นางสุชาราวตี มาบุญธรรม
    '110142',//นางสาวอุทัยรัตน์ แก้วกู่
    '120032',//นางวิรายา ภมรสมิต
    '1100017',//นางพัชรนันญ ศรีแก่นจันทร
    '190021',//นางศิโรวรรณ อินศร
    '5002279',//นางสาวอนงค์ภาณุช ปะนะทังถิรวิทย
    '140056',//นางฉวีวรรณ อรรคะเศรษฐัง
    '110146',//นายนิวัฒ พัฒนิบูลย
    '110108',//นางสาวดวงแข เนื่องอุดม
    '110144',//นายอุทัย หามนตร
    '110309',//นางมยุรี ผาผง
    '130076',//นางกมลลักษณ์ พักพิงผ่องศิร
    '140066',//นางอมรรัตน์ หลายโคตร
    '190032',//นางชนัญชิดา สุวรรณเลิศ
    '110148',//นางจุฑามาศ ภิญโญศร
    '180010',//นางสิรีวรรณ ตติยรัตน
    '140064',//นางพรทิพย์ พันธุมชัย
    '120043',//นางลัดดาภรณ์ เชื้อในเขา
    '5001661',//นางศรินทร์ยา เกียงขวา
    '5001685',//นางแจ่มจันทร์ หลูปรีชาเศรษฐ
    '310801',//นางสาวกนกวรรณ เชาว์น้อย
    '410402',//นายนพวิทย์ ศรีเวียงธนาธิป
    '314020',//นายไกรษร อุทัยแสง
    '5000094',//นายสวัสดิ์ วิชระโภชน
    '130102' //นางสาวพนมพร ปัจจวงษ
    
    ]);

    //ประเมิน ค.
const EXECUTIVE_SCORE_ALLOWLIST = new Set([
    '160018',//นายจีรพันธ์ ภูครองเพชร
    '190015',//นางนงลักษณ์ พุ่มม่วง
    '130069',//นายขรรชัย กลิ่นผกา
    '110143',//นางวราลักษณ์ คุปต์บดินทร
    '190042',//นางฉวีวรรณ คืนสันเทียะ
    '110105',//นายจักริน เพชรสังหาร
    '1140016',//นางบงกชทิพย์ เกาะสมบัต
    '110407',//นายอานุภาพ งามสูงเนิน
    '110138',//นางฉันทลักษณ์ สาชำนาญ
    '120039',//นางสุชาราวตี มาบุญธรรม
    '110142',//นางสาวอุทัยรัตน์ แก้วกู่
    '120032',//นางวิรายา ภมรสมิต
    '1100017',//นางพัชรนันญ ศรีแก่นจันทร
    '190021',//นางศิโรวรรณ อินศร
    '5002279',//นางสาวอนงค์ภาณุช ปะนะทังถิรวิทย
    '140056',//นางฉวีวรรณ อรรคะเศรษฐัง
    '110146',//นายนิวัฒ พัฒนิบูลย
    '110108',//นางสาวดวงแข เนื่องอุดม
    '110144',//นายอุทัย หามนตร
    '110309',//นางมยุรี ผาผง
    '130076',//นางกมลลักษณ์ พักพิงผ่องศิร
    '140066',//นางอมรรัตน์ หลายโคตร
    '190032',//นางชนัญชิดา สุวรรณเลิศ
    '110148',//นางจุฑามาศ ภิญโญศร
    '180010',//นางสิรีวรรณ ตติยรัตน
    '140064',//นางพรทิพย์ พันธุมชัย
    '120043',//นางลัดดาภรณ์ เชื้อในเขา
    '5001661',//นางศรินทร์ยา เกียงขวา
    '5001685',//นางแจ่มจันทร์ หลูปรีชาเศรษฐ
    '310801',//นางสาวกนกวรรณ เชาว์น้อย
    '410402',//นายนพวิทย์ ศรีเวียงธนาธิป
    '314020',//นายไกรษร อุทัยแสง
    '5000094',//นายสวัสดิ์ วิชระโภชน
    '130102', //นางสาวพนมพร ปัจจวงษ
    //รายชื่อคนที่ประเมิน ค.
    '5001951', //จินดาพร จำรัสเลิศลักษณ์
    '5000224', //จารุณีย์ นิมิตศิริวัฒน์


]);
    
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

            //โหลดข้อมูล
            loadingEvalu: false,
            loadingEvaluIndex: null,

            //สมรรถนะ ค.
            canScoreExecutive: false,
            isTargetExecutive: false,

            // ตารางรายชื่อ
            products: [],

             loading: false,   // ⬅️ เพิ่มตัวนี้

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
                // { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                // { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
                // { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                // { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
                // { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
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
            //datatable3: [] 
            posadio: 0,
            competencyMap: {},

            competencyDialogVisible: false,
            selectedCompetency: {
            title: '',
            description: ''
            },

            // ✅ ถ้าจะใช้ fallback แบบยาวเหมือน P02
            coreDescriptions: {
                1: 'คำอธิบาย ก.1 การมั่งผลสัมฤทธ์\n\n' +
                    'ความมุ่งมั่นจะปฏิบัติหน้าที่ราชการให้ดีหรือให้เกินมาตรฐานที่มีอยู่ โดยมาตรฐานนี้อาจเป็นผลการปฏิบัติงานที่ผ่านมาของตนเอง หรือเกณฑ์วัดผลสัมฤทธิ์ที่สถาบันอุดมศึกษา ' +
                    'กำหนดขึ้น อีกทั้งยังหมายรวมถึงการสร้างสรรค์พัฒนาผลงานหรือกระบวนการปฏิบัติงานตามเป้าหมายที่ยากและท้าท้ายชนิดที่อาจไม่เคยมีผู้ใดสามารถกระทำได้มาก่อน\n\n' +  
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +  
                    'ระดับที่ 1 แสดงความพยายามในการปฏิบัติหน้าที่ราชการให้ดี\n' +
                        '- พยายามทำงานในหน้าที่ให้ถูกต้อง\n' +
                        '- พยายามปฏิบัติงานให้แล้วเสร็จตามกำหนดเวลา\n' +
                        '- มานะอดทน ขยันหมั่นเพียรในการทำงาน\n' +
                        '- แสดงออกว่าต้องการทำงานให้ได้ดีขึ้น\n' + 
                        '- แสดงความเห็นในเชิงปรับปรุงพัฒนาเมื่อเห็นความสูญเปล่า หรือหย่อนประสิทธิภาพในงาน\n\n' +  
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และสามารถทำงานได้ผลงานตามเป้าหมายที่วางไว้\n' + 
                        '- กำหนดมาตรฐาน หรือเป้าหมายในการทำงานเพื่อให้ได้ผลงานที่ดี\n' + 
                        '- ติดตาม และประเมินผลงานของตน โดยเทียบเคียงกับเกณฑ์มาตรฐาน\n' + 
                        '- ทำงานได้ตามเป้าหมายที่ผู้บังคับบัญชากำหนด หรือเป้าหมายของหน่วยงานที่รับผิดชอบ\n' + 
                        '- ทำงานได้ตามเป้าหมายที่ผู้บังคับบัญชากำหนด หรือเป้าหมายของหน่วยงานที่รับผิดชอบ\n' + 
                        '- มีความละเอียดรอบคอบ เอาใจใส่ ตรวจตราความถูกต้อง เพื่อให้ได้งานที่มีคุณภาพ\n\n' +  
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และสามารถปรับปรุงวิธีการทำงานเพื่อให้ได้ผลงานที่มีประสิทธิภาพมากยิ่งขึ้น\n' +
                        '- ปรับปรุงวิธีการที่ทำให้งานได้ดีขึ้น เร็วขึ้น มีคุณภาพดีขึ้น มีประสิทธิภาพมากขึ้น หรือทำให้ผู้บริการพึงพอใจมากขึ้น\n' + 
                        '- เสนอหรือทดลองวิธีการทำงานแบบใหม่ที่คาดว่าจะทำให้งานมีประสิทธิภาพมากขึ้น\n\n' +  
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และสามารถกำหนดเป้าหมายรวมทั้งพัฒนางาน เพื่อให้ได้ผลงานที่โดดเด่น หรือแตกต่างอย่างมีนัยสำคัญ\n' +
                        '- กำหนดเป้าหมายที่ท้าทาย และเป็นไปได้ยาก เพื่อให้ได้ผลงานที่ดีกว่าเดิมอย่างเห็นได้ชัด\n' + 
                        '- พัฒนาระบบ ขั้นตอน วิธีการทำงาน เพื่อให้ได้ผลงานที่โดดเด่น หรือแตกต่างไม่เคยมีผู้ใดทำได้มาก่อน\n\n' +    
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และกล้าตัดสินใจ แม้ว่าการตัดสินใจนั้นจะมีความเสี่ยงเพื่อให้บรรลุเป้าหมายของหน่วยงานหรือสถาบันอุดมศึกษา\n' +
                        '- ตัดสินใจได้ โดยมีการคำนวณผลได้ผลเสียอย่างชัดเจน และดำเนินการ เพื่อให้ภาครัฐและประชาชนได้ประโยชน์สูงสุด\n' +
                        '- บริหารจัดการและทุ่มเทเวลา ตลอดจนทรัพยากร เพื่อให้ได้ประโยชน์สูงสุดต่อภารกิจของหน่วยงานตามที่วางแผนไว้', 

 
                2:  'คำอธิบาย ก.2 การบริการที่ดี\n\n' +
                    'ความตั้งใจและความพยายามของข้าราชการ และพนักงานในการให้บริการต่อประชาชน ข้าราชการ หรือหน่วยงานอื่น ๆ ที่เกี่ยวข้อง\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 ให้บริการพื้นฐานได้อย่างเหมาะสม\n' +
                        '- ให้บริการด้วยท่าทีเป็นมิตร สุภาพ และให้ข้อมูลข่าวสารที่ถูกต้อง ชัดเจน\n' +
                        '- แจ้งความคืบหน้าการดำเนินเรื่อง และประสานงานกับหน่วยงานที่เกี่ยวข้องเพื่อให้บริการต่อเนื่อง\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และช่วยแก้ปัญหาให้ผู้รับบริการ\n' +
                        '- รับผิดชอบช่วยแก้ปัญหาหรือหาแนวทางแก้ไขให้ผู้รับบริการอย่างรวดเร็ว ไม่บ่ายเบี่ยง\n' +
                        '- เก็บข้อขัดข้องจากการให้บริการมาใช้ปรับปรุงคุณภาพการบริการ\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และให้บริการเกินกว่าที่คาดหวัง\n' +
                        '- สละเวลาและความพยายามเพิ่มเติมเพื่อช่วยเหลือผู้รับบริการให้ปัญหาคลี่คลาย\n' +
                        '- ให้ข้อมูลหรือคำแนะนำเพิ่มเติมที่เป็นประโยชน์ แม้ผู้รับบริการไม่ได้ถามโดยตรง\n' +
                        '- เสนอวิธีให้บริการรูปแบบใหม่ ๆ เพื่อให้ผู้รับบริการได้รับประโยชน์สูงสุด\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และเข้าใจความต้องการที่แท้จริงของผู้รับบริการ\n' +
                        '- พยายามทำความเข้าใจเบื้องลึกถึงความจำเป็นและปัญหาของผู้รับบริการ\n' +
                        '- ให้คำแนะนำที่ตอบโจทย์ความจำเป็นที่แท้จริง ไม่ใช่เพียงตามคำร้องขอเบื้องต้น\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และมุ่งประโยชน์ระยะยาวของผู้รับบริการ\n' +
                        '- พร้อมปรับวิธีหรือขั้นตอนการให้บริการ เพื่อประโยชน์สูงสุดของผู้รับบริการในระยะยาว\n' +
                        '- ทำหน้าที่คล้ายที่ปรึกษาที่ผู้รับบริการให้ความไว้วางใจในการตัดสินใจ\n' +
                        '- กล้าเสนอแนวทางที่ต่างจากวิธีที่ผู้รับบริการร้องขอ หากเห็นว่าเป็นประโยชน์แท้จริงต่อเขา',

                3: 'คำอธิบาย ก.3 การสั่งสมความเชี่ยวชาญในงานอาชีพ\n\n' +
                    'ความสนใจใฝ่รู้ สั่งสมความรู้และความสามารถของตนด้วยการศึกษา ค้นคว้า และพัฒนาตนเองอย่างต่อเนื่อง ' +
                    'จนสามารถประยุกต์ใช้ความรู้เชิงวิชาการและเทคโนโลยีต่าง ๆ เข้ากับการปฏิบัติราชการให้เกิดผลสัมฤทธิ์\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 ติดตามและแสวงหาความรู้ใหม่ในสาขาอาชีพของตน\n' +
                        '- สนใจศึกษาเทคโนโลยีและองค์ความรู้ใหม่ ๆ ที่เกี่ยวข้องกับงาน\n' +
                        '- พยายามเพิ่มพูนความรู้ความสามารถของตนจากแหล่งข้อมูลต่าง ๆ\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และมีความรู้ในวิชาการ/เทคโนโลยีใหม่ในสายงานของตน\n' +
                        '- มีความเข้าใจที่ดีในองค์ความรู้หรือเทคโนโลยีใหม่ที่เกี่ยวข้องกับงาน\n' +
                        '- มองเห็นแนวโน้มพัฒนาการทางวิชาการที่มีผลต่อการทำงานของตน\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และนำความรู้หรือเทคโนโลยีใหม่มาปรับใช้ในการทำงาน\n' +
                        '- ประยุกต์ใช้วิทยาการหรือเทคโนโลยีใหม่ในการปรับปรุงวิธีทำงานให้มีประสิทธิภาพยิ่งขึ้น\n' +
                        '- แก้ปัญหาที่เกิดจากการใช้เทคโนโลยีใหม่ในการปฏิบัติงานได้\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และพัฒนาตนเองให้มีความเชี่ยวชาญทั้งลึกและกว้าง\n' +
                        '- มีความรู้เชิงบูรณาการครอบคลุมหลายสาขา และสามารถนำไปใช้ได้หลากหลายบริบท\n' +
                        '- ใช้ความรู้ที่มีในการช่วยกำหนดวิสัยทัศน์หรือแนวทางพัฒนางานในอนาคต\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และส่งเสริมให้องค์กรมีบรรยากาศแห่งความเชี่ยวชาญ\n' +
                        '- สนับสนุนการจัดสรรทรัพยากรและเครื่องมือเพื่อให้บุคลากรได้พัฒนาความเชี่ยวชาญ\n' +
                        '- ผลักดันให้องค์กรนำเทคโนโลยีหรือองค์ความรู้ใหม่ ๆ มาใช้ในงานราชการอย่างต่อเนื่อง',

                4: 'คำอธิบาย ก.4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม\n\n' +
                    'การดำรงตนและประพฤติปฏิบัติอย่างถูกต้องเหมาะสมตามกฎหมาย คุณธรรม จรรยาบรรณแห่งวิชาชีพ ' +
                    'และจรรยาข้าราชการ พนักงาน เพื่อรักษาศักดิ์ศรีแห่งความเป็นข้าราชการ พนักงาน\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 ปฏิบัติงานด้วยความสุจริตและโปร่งใส\n' +
                        '- ปฏิบัติหน้าที่ถูกต้องตามกฎหมายและระเบียบ ไม่เลือกปฏิบัติ\n' +
                        '- แสดงความคิดเห็นตามหลักวิชาชีพด้วยความสุจริตใจ\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และเป็นผู้มีสัจจะเชื่อถือได้\n' +
                        '- รักษาคำพูด มีความรับผิดชอบ และได้รับความไว้วางใจจากผู้อื่น\n' +
                        '- แสดงให้เห็นถึงความภูมิใจในความเป็นข้าราชการ พนักงานของตน\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และยึดมั่นในหลักการและจรรยาบรรณ\n' +
                        '- ยึดหลักวิชาชีพและจรรยาข้าราชการ ไม่ยอมเบี่ยงเบนเพราะอคติหรือผลประโยชน์ส่วนตน\n' +
                        '- พร้อมรับผิดและเสียสละประโยชน์ส่วนตนเพื่อประโยชน์ของราชการ\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และยืนหยัดเพื่อความถูกต้อง\n' +
                        '- กล้าตัดสินใจและปฏิบัติอย่างถูกต้อง เป็นธรรม แม้จะสร้างความไม่พอใจให้ผู้เสียประโยชน์\n' +
                        '- มุ่งพิทักษ์ผลประโยชน์ของทางราชการแม้อยู่ในสถานการณ์ที่กดดัน\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และอุทิศตนเพื่อความยุติธรรมในระดับกว้าง\n' +
                        '- ยืนหยัดปกป้องผลประโยชน์และชื่อเสียงของประเทศชาติ แม้อาจเสี่ยงต่อความมั่นคงในหน้าที่หรือตนเอง',

                5: 'คำอธิบาย ก.5 การทำงานเป็นทีม\n\n' +
                    'ความตั้งใจที่จะทำงานร่วมกับผู้อื่น เป็นส่วนหนึ่งของทีม หน่วยงาน หรือสถาบันอุดมศึกษา ' +
                    'โดยผู้ปฏิบัติมีฐานะเป็นสมาชิก ไม่จำเป็นต้องเป็นหัวหน้าทีม และสามารถสร้างและรักษาสัมพันธภาพที่ดีกับสมาชิกในทีม\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 ทำหน้าที่ของตนในทีมได้สำเร็จ\n' +
                    '- สนับสนุนการตัดสินใจของทีม และปฏิบัติงานตามที่ได้รับมอบหมาย\n' +
                    '- รายงานความคืบหน้าของงานตนเองต่อทีม และให้ข้อมูลที่เป็นประโยชน์ต่อการทำงานร่วมกัน\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และให้ความร่วมมือกับเพื่อนร่วมงาน\n' +
                    '- เข้ากับผู้อื่นในทีมได้ดีและให้ความร่วมมือในการทำงาน\n' +
                    '- กล่าวถึงเพื่อนร่วมงานในเชิงสร้างสรรค์และแสดงความเชื่อมั่นในศักยภาพของทีม\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และช่วยประสานความร่วมมือของทีม\n' +
                    '- รับฟังความคิดเห็นของสมาชิก และพร้อมเรียนรู้จากผู้อื่น\n' +
                    '- วางแผนหรือตัดสินใจร่วมกันบนพื้นฐานของความคิดเห็นของทีม\n' +
                    '- ส่งเสริมสัมพันธภาพภายในทีมให้เกื้อกูลต่อการทำงาน\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และช่วยเหลือเพื่อนร่วมทีมเพื่อให้งานสำเร็จ\n' +
                    '- ให้กำลังใจและยกย่องผลงานของเพื่อนร่วมทีมอย่างจริงใจ\n' +
                    '- ยื่นมือช่วยเหลือเพื่อนร่วมทีมแม้ไม่ได้ร้องขอ และรักษามิตรภาพที่ดี\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และนำทีมให้ปฏิบัติภารกิจบรรลุผล\n' +
                    '- ส่งเสริมความสามัคคีในทีม ไม่ยึดติดความชอบส่วนตัว\n' +
                    '- ช่วยคลี่คลายและจัดการข้อขัดแย้งในทีม\n' +
                    '- ประสานสัมพันธ์และสร้างขวัญกำลังใจ เพื่อให้ทีมบรรลุเป้าหมายของสถาบันอุดมศึกษา'

            },
            otherDescriptions: {
                12: 'คำอธิบาย ค.1 สภาวะผู้นำ\n\n' +
                    'ความสามารถ หรือความตั้งใจที่จะรับบทในการเป็นผู้นำของกลุ่ม กำหนดทิศทาง เป้าหมาย วิธีการทำงาน ' +
                    'ให้ทีมปฏิบัติงานได้อย่างราบรื่น เต็มประสิทธิภาพและบรรลุวัตถุประสงค์ของส่วนราชการ\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' + 
                    'ระดับที่ 1 ดำเนินการประชุมได้ดีและคอยแจ้งข่าวสารความเป็นไปโดยตลอด\n' +
                    '- ดำเนินการประชุมให้เป็นไปตามระเบียบ วาระ วัตถุประสงค์ และเวลา ตลอดจนมอบหมายงานให้แก่บุคคลในกลุ่มได้\n' +
                    '- แจ้งข่าวสารให้ผู้ที่จะได้รับผลกระทบจากการตัดสินใจรับทราบอยู่เสมอแม้ไม่ได้ถูกกำหนดให้ต้องกระทำ\n' +
                    '- อธิบายเหตุผลในการตัดสินใจให้ผู้ที่เกี่ยวข้องทราบ\n\n' + 
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และเป็นผู้นำในการทำงานของกลุ่มและใช้อำนาจอย่างยุติธรรม\n' +
                    '- ส่งเสริมและกระทำการเพื่อให้กลุ่มปฏิบัติหน้าที่ได้อย่างเต็มประสิทธิภาพ\n' +
                    '- กำหนดเป้าหมาย ทิศทางที่ชัดเจน จัดกลุ่มงานและเลือกคนให้เหมาะกับงาน หรือกำหนดวิธีการที่จะทำให้กลุ่มทำงานได้ดีขึ้น\n' +
                    '- รับฟังความคิดเห็นของผู้อื่น\n' +
                    '- สร้างขวัญกำลังใจในการปฏิบัติงาน\n' +
                    '- ปฏิบัติต่อสมาชิกในทีมด้วยความยุติธรรม\n\n' + 
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และให้การดูแลและช่วยเหลือทีมงาน\n' +
                    '- เป็นที่ปรึกษาและช่วยเหลือทีมงาน\n' +
                    '- ปกป้องทีมงาน และชื่อเสียงของส่วนราชการ\n' +
                    '- จัดหาบุคลากร ทรัพยากร หรือข้อมูลที่สำคัญมาให้ทีมงาน\n\n' + 
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และประพฤติตนสมกับเป็นผู้นำ\n' +
                    '- กำหนดธรรมเนียมปฏิบัติประจำกลุ่มและประพฤติตนอยู่ในกรอบของธรรมเนียมปฏิบัตินั้น\n' +
                    '- ประพฤติปฏิบัติตนเป็นแบบอย่างที่ดี\n' +
                    '- ยึดหลักธรรมาภิบาลในการปกครองผู้ใต้บังคับบัญชา\n\n' +    
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และผลักดันให้เกิดการปรับเปลี่ยนอย่างมีประสิทธิภาพ\n' +
                    '- ผลักดันให้การปรับเปลี่ยนสามารถดำเนินไปได้อย่างราบรื่นและประสบความสำเร็จ\n' +
                    '- สร้างขวัญกำลังใจ และความเชื่อมั่นในการขับเคลื่อนให้เกิดการปรับเปลี่ยนอย่างมีประสิทธิภาพ', 

               13: 'คำอธิบาย ค.2 วิสัยทัศน์\n\n' +
                    'ความสามารถในการกำหนดทิศทาง ภารกิจ และเป้าหมายการทำงานที่ชัดเจน ' +
                    'พร้อมทั้งสร้างความร่วมแรงร่วมใจเพื่อให้งานของส่วนราชการบรรลุวิสัยทัศน์ที่ตั้งไว้\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 รู้และเข้าใจวิสัยทัศน์ขององค์กร\n' +
                    '- เข้าใจว่างานที่ตนรับผิดชอบเชื่อมโยงหรือสนับสนุนวิสัยทัศน์ของส่วนราชการอย่างไร\n' +
                    '- สามารถอธิบายให้ผู้อื่นเข้าใจความเชื่อมโยงระหว่างงานกับวิสัยทัศน์ได้\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และช่วยให้ผู้อื่นเข้าใจวิสัยทัศน์ขององค์กร\n' +
                    '- ถ่ายทอดให้บุคลากรเข้าใจภาพรวมของวิสัยทัศน์และเป้าหมายของหน่วยงานภายใต้ส่วนราชการ\n' +
                    '- เปิดโอกาสแลกเปลี่ยนข้อมูลและรับฟังความคิดเห็นเพื่อใช้ประกอบการกำหนดวิสัยทัศน์\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และสร้างแรงจูงใจให้ผู้อื่นร่วมเดินตามวิสัยทัศน์\n' +
                    '- โน้มน้าวให้สมาชิกเกิดความเต็มใจและกระตือรือร้นในการทำงานเพื่อตอบสนองวิสัยทัศน์\n' +
                    '- ให้คำปรึกษาแนะนำแนวทางการทำงานโดยยึดวิสัยทัศน์และเป้าหมายขององค์กรเป็นหลัก\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และกำหนดนโยบายให้สอดคล้องกับวิสัยทัศน์ของส่วนราชการ\n' +
                    '- พัฒนาหรือริเริ่มนโยบายใหม่ๆ เพื่อผลักดันการนำวิสัยทัศน์ไปสู่ผลลัพธ์ที่เป็นรูปธรรม\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และกำหนดวิสัยทัศน์ของส่วนราชการให้สอดคล้องกับวิสัยทัศน์ระดับประเทศ\n' +
                    '- กำหนดวิสัยทัศน์ เป้าหมาย และทิศทางการปฏิบัติหน้าที่ของส่วนราชการให้สอดคล้องวิสัยทัศน์ระดับประเทศ\n' +
                    '- มองการณ์ไกลวิเคราะห์ได้ว่าประเทศจะได้รับผลกระทบอย่างไรจากการเปลี่ยนแปลงทั้งภายในและภายนอก',

                14: 'คำอธิบาย ค.3 การวางกลยุทธ์ภาครัฐ\n\n' +
                    'ความเข้าใจวิสัยทัศน์และนโยบายภาครัฐ แล้วนำมาประยุกต์ใช้ในการกำหนดกลยุทธ์ของส่วนราชการให้เหมาะสมกับบทบาทภารกิจของหน่วยงาน\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 รู้และเข้าใจนโยบาย ภารกิจ และกลยุทธ์ภาครัฐที่เกี่ยวข้องกับหน่วยงาน\n' +
                    '- เข้าใจความเชื่อมโยงของนโยบายและภารกิจของภาครัฐกับภารกิจของหน่วยงานที่ดูแล\n' +
                    '- วิเคราะห์ปัญหา อุปสรรค หรือโอกาสของหน่วยงานได้ในระดับหนึ่ง\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และนำประสบการณ์มาประยุกต์ใช้ในการกำหนดกลยุทธ์\n' +
                    '- ใช้ประสบการณ์ที่มีมาช่วยกำหนดกลยุทธ์ของหน่วยงานให้สอดคล้องกับกลยุทธ์ภาครัฐ\n' +
                    '- ปรับกลยุทธ์ให้เหมาะกับสถานการณ์ที่เปลี่ยนไปโดยอาศัยความเข้าใจระบบราชการ\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และนำทฤษฎีหรือแนวคิดที่ซับซ้อนมาใช้กำหนดกลยุทธ์\n' +
                    '- ประยุกต์ใช้ทฤษฎี แนวคิด หรือองค์ความรู้เชิงลึกเพื่อกำหนดเป้าหมายและกลยุทธ์ของหน่วยงาน\n' +
                    '- นำแนวปฏิบัติที่ประสบความสำเร็จหรือผลการวิจัยมาพัฒนากลยุทธ์เชิงรุกของหน่วยงาน\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และกำหนดกลยุทธ์ให้สอดคล้องกับสถานการณ์สำคัญต่างๆ\n' +
                    '- ประเมินสถานการณ์ด้านเศรษฐกิจ สังคม การเมือง ทั้งในประเทศและต่างประเทศในภาพรวม\n' +
                    '- คาดการณ์แนวโน้มในอนาคตและกำหนดกลยุทธ์ที่ช่วยให้ส่วนราชการบรรลุพันธกิจภายใต้สถานการณ์นั้น\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และบูรณาการองค์ความรู้ใหม่มาใช้กำหนดกลยุทธ์ภาครัฐ\n' +
                    '- ริเริ่มและบูรณาการองค์ความรู้ใหม่จากหลายด้านเพื่อกำหนดกลยุทธ์ภาครัฐในมุมมององค์รวม\n' +
                    '- ปรับทิศทางกลยุทธ์การพัฒนาประเทศอย่างต่อเนื่องให้สอดรับกับบริบทที่เปลี่ยนแปลง',

                15: 'คำอธิบาย ค.4 ศักยภาพเพื่อนำการปรับเปลี่ยน\n\n' +
                    'ความสามารถในการผลักดันหน่วยงานไปสู่การปรับเปลี่ยนที่เป็นประโยชน์ ' +
                    'พร้อมทั้งสื่อสารให้ผู้เกี่ยวข้องเข้าใจและร่วมมือจนการเปลี่ยนแปลงเกิดขึ้นจริงในองค์กร\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 เห็นความจำเป็นของการปรับเปลี่ยนและปรับตัวของตนเอง\n' +
                    '- ปรับพฤติกรรมหรือแผนการทำงานของตนให้สอดคล้องกับการเปลี่ยนแปลง\n' +
                    '- ยอมรับและเรียนรู้เพื่อให้สามารถปรับตัวต่อการเปลี่ยนแปลงนั้นได้\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และช่วยให้ผู้อื่นเข้าใจการปรับเปลี่ยนที่จะเกิดขึ้น\n' +
                    '- อธิบายให้ผู้อื่นเข้าใจถึงความจำเป็นและประโยชน์ของการเปลี่ยนแปลง\n' +
                    '- สนับสนุนและมีส่วนร่วมในความพยายามปรับเปลี่ยนองค์กร พร้อมเสนอแนวทางปรับปรุง\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และกระตุ้นให้ผู้อื่นเห็นความสำคัญของการปรับเปลี่ยน\n' +
                    '- สร้างแรงจูงใจให้บุคลากรเห็นความจำเป็นและร่วมมือกันในการเปลี่ยนแปลง\n' +
                    '- ชี้ให้เห็นความแตกต่างที่มีนัยสำคัญระหว่างสภาพเดิมกับสิ่งที่จะเปลี่ยนไป\n' +
                    '- ช่วยสร้างความเข้าใจกับผู้ที่ยังไม่ยอมรับการเปลี่ยนแปลง\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และวางแผนงานเพื่อรองรับการเปลี่ยนแปลงในองค์กร\n' +
                    '- วางแผนการเปลี่ยนแปลงอย่างเป็นระบบและชี้ให้เห็นประโยชน์ที่องค์กรจะได้รับ\n' +
                    '- เตรียมแผนและติดตามการบริหารการเปลี่ยนแปลงอย่างต่อเนื่อง\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และผลักดันให้การปรับเปลี่ยนเกิดผลอย่างมีประสิทธิภาพ\n' +
                    '- ทำให้กระบวนการเปลี่ยนแปลงดำเนินไปอย่างราบรื่นและประสบผลสำเร็จ\n' +
                    '- สร้างขวัญกำลังใจและความเชื่อมั่นในการขับเคลื่อนการเปลี่ยนแปลงขององค์กร',

                16: 'คำอธิบาย ค.5 การสอนงานและการมอบหมายงาน\n\n' +
                    'ความตั้งใจส่งเสริมการเรียนรู้และการพัฒนาผู้อื่นในระยะยาว ' +
                    'จนสามารถมอบหมายภาระงานและให้อิสระในการตัดสินใจปฏิบัติหน้าที่ราชการได้อย่างเหมาะสม\n\n' +
                    'ระดับที่ 0 ไม่แสดงสมรรถนะด้านนี้ หรือแสดงอย่างไม่ชัดเจน\n\n' +
                    'ระดับที่ 1 สอนงานหรือให้คำแนะนำเกี่ยวกับวิธีปฏิบัติงาน\n' +
                    '- ให้คำแนะนำหรือสาธิตวิธีปฏิบัติงานอย่างเป็นขั้นตอน\n' +
                    '- ชี้แหล่งข้อมูลหรือทรัพยากรที่เกี่ยวข้องเพื่อช่วยพัฒนาการทำงาน\n\n' +
                    'ระดับที่ 2 แสดงสมรรถนะระดับที่ 1 และตั้งใจพัฒนาผู้ใต้บังคับบัญชาให้มีศักยภาพ\n' +
                    '- ให้คำปรึกษาในการพัฒนาตนเอง ส่งเสริมจุดแข็งและช่วยลดจุดอ่อน\n' +
                    '- เปิดโอกาสให้ผู้ใต้บังคับบัญชาแสดงศักยภาพเพื่อสร้างความมั่นใจในการทำงาน\n\n' +
                    'ระดับที่ 3 แสดงสมรรถนะระดับที่ 2 และวางแผนให้โอกาสผู้ใต้บังคับบัญชาแสดงความสามารถ\n' +
                    '- วางแผนพัฒนาผู้ใต้บังคับบัญชาทั้งระยะสั้นและระยะยาว\n' +
                    '- มอบหมายงานและโอกาสเข้ารับการฝึกอบรมหรือพัฒนาอย่างสม่ำเสมอ\n' +
                    '- มอบหมายความรับผิดชอบในระดับที่ต้องตัดสินใจเองบางเรื่อง เพื่อให้ได้ฝึกบริหารจัดการงาน\n\n' +
                    'ระดับที่ 4 แสดงสมรรถนะระดับที่ 3 และช่วยขจัดอุปสรรคต่อการพัฒนาศักยภาพของผู้ใต้บังคับบัญชา\n' +
                    '- ปรับเปลี่ยนทัศนคติหรือปัจจัยที่ขัดขวางการพัฒนาศักยภาพของบุคลากร\n' +
                    '- ทำความเข้าใจสาเหตุของพฤติกรรมแต่ละคนเพื่อนำมาวางแนวทางพัฒนาได้ตรงจุด\n\n' +
                    'ระดับที่ 5 แสดงสมรรถนะระดับที่ 4 และทำให้ส่วนราชการมีระบบการสอนงานและมอบหมายงานที่ชัดเจน\n' +
                    '- สร้างและสนับสนุนให้เกิดระบบสอนงานและมอบหมายความรับผิดชอบอย่างเป็นระบบในส่วนราชการ\n' +
                    '- ส่งเสริมให้เกิดวัฒนธรรมการเรียนรู้อย่างต่อเนื่องในหน่วยงาน'
 
            }, 
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
        await this.loadCompetencyDescriptions();
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

         async withLoading(task) {
            this.loading = true
            try {
            return await task()
            } finally {
            this.loading = false
            }
        },

        showDataSet() {
            axios
                .post('http://127.0.0.1:8000/api/showDateSetleader', {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main
                })
                .then((res) => {
                    // console.log(res.data);
                    this.tracking_dates = res.data;
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        },

        parsePersen(persen) {
            const [wAch, wBeh] = String(persen || '0:0')
            .split(':')
            .map(v => parseFloat(v) || 0);

            return { wAch, wBeh };
        },

        calcAchievement(item) {
            // console.log('calcAchievement: ', item);
            if (!item?.tb_tor?.persen) return '';
            const { wAch } = this.parsePersen(item.tb_tor.persen);
            const ach = parseFloat(item.tb_tor.achievement_score) || 0;
            return (wAch * ach).toFixed(2);
        },

        calcBehavior(item) {
            if (!item?.tb_tor?.persen) return '';
            const { wBeh } = this.parsePersen(item.tb_tor.persen);
            const beh = parseFloat(item.tb_tor.behavior) || 0;
            return (wBeh * beh).toFixed(2);
        },

        // (ถ้าต้องการ) รวมคะแนนถ่วงน้ำหนัก 2 ส่วน
        calcSumScore(item) {
            if (!item?.tb_tor?.persen) return '';
            const { wAch, wBeh } = this.parsePersen(item.tb_tor.persen);
            const ach = parseFloat(item.tb_tor.achievement_score) || 0;
            const beh = parseFloat(item.tb_tor.behavior) || 0;
            return (wAch * ach + wBeh * beh).toFixed(2);
        },




        // ตารางรายชื่อ
         
        // xxr() {
        //     if (this.tracking_date?.evalua === undefined) {
        //         Swal.fire({
        //             title: 'แจ้งเตือนจากระบบ!',
        //             text: 'กรุณาเลือก รอบประเมิน ก่อน!',
        //             icon: 'error'
        //         });
        //     } else {
        //         // เช็คว่า dataList เป็น array หรือไม่
        //         if (Array.isArray(this.dataList)) {   
        //             // กรองข้อมูลที่ไม่ใช่ "ลูกจ้างชั่วคราว"
        //             // this.filteredData = this.dataList.filter(item => item.stftypename !== "ลูกจ้างชั่วคราว");
        //             this.filteredData = this.dataList.filter(item => item.stftypename !== "ลูกจ้างชั่วคราว" && item.stftypename !== "พนักงานราชการ" && item.stftypename !== "ลูกจ้างประจำ"); 
        //             // เรียกใช้ฟังก์ชัน showDataEvalu()
        //             this.showDataEvalu();
        //         } else {
        //             console.error("dataList is not an array:", this.dataList);
        //         }
        //     }
        // }, 
        xxr() {
            if (this.tracking_date?.evalua === undefined) {
                Swal.fire({ title:'แจ้งเตือนจากระบบ!', text:'กรุณาเลือก รอบประเมิน ก่อน!', icon:'error' })
                return
            }

            if (!Array.isArray(this.dataList)) {
                console.error('dataList is not an array:', this.dataList)
                return
            }

            this.filteredData = this.dataList.filter(
                i => i.stftypename !== "ลูกจ้างชั่วคราว"
                && i.stftypename !== "พนักงานราชการ"
                && i.stftypename !== "ลูกจ้างประจำ"
            )

            // ⬇️ แสดงสปินเนอร์ระหว่างโหลดข้อมูล
            this.withLoading(async () => {
                await this.showDataEvalu()
            })
        },

        async showDataEvalu() {
            try { 
                const res = await axios.get('http://127.0.0.1:8000/api/showDataEvalu', {  
                    params: {
                        staff_id: this.staffid_Main,
                        fac_id: this.tracking_date.fac_id,
                        group_id: this.groupid_Main,
                        evalua: this.tracking_date.evalua,
                        p_year: this.tracking_date.d_date
                    }
                }); 
                // console.log('showDataEvalu: ',res.data);
                this.products = res.data;

                // ใช้ Promise.all เพื่อทำการเรียก cvb พร้อมกันหลายๆ รายการ
                //await Promise.all(res.data.map(item => this.cvb(item)));
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            }
        },
        async cvb(item) {
            // console.log(this.tracking_date.evalua);
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/showdatator', {
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
        async getAadioPosition(staffid_Main){ 
            // console.log('getAadioPosition: ',staffid_Main);  
            try {   
                if(staffid_Main){
                    const res = await axios.get('http://127.0.0.1:8000/api/getDataAdio', {  
                        params: {
                            staffid: staffid_Main
                        }
                    }); 
                    console.log('getDataAdio: ',res);   
                    this.posadio = res.data[0].posadid || 0;
                } 
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        }, 
        // async openDataEvalu(data) {
        //     if (this.tracking_date.d_date === undefined) {
        //         Swal.fire('แจ้งเตือนจากระบบ', 'กรุณาเลือกรอบประเมิน', 'error')
        //         return
        //     }

        //     // ⬇️ ทุกงานที่ทำตอนเปิด Dialog ค่อนข้างเยอะ กดครั้งเดียวให้โชว์โหลดตลอดจนเสร็จ
        //     await this.withLoading(async () => {
        //         // this.getAadioPosition(data.staffid) บิวแก้090269
        //         await this.getAadioPosition(data.staffid)
        //         this.dataStaffid = data.staffid

        //         await this.showDataEvalu()
        //         this.currentstaff = this.products.filter(p => p.staffid === this.dataStaffid)

        //         // reset ค่าต่าง ๆ …
        //         this.products_Tab1 = []
        //         this.p01_scores = [
        //         { name: '0 คะแนน', code: 0 }, { name: '1 คะแนน', code: 1 },
        //         { name: '2 คะแนน', code: 2 }, { name: '3 คะแนน', code: 3 },
        //         { name: '4 คะแนน', code: 4 }, { name: '5 คะแนน', code: 5 }
        //         ]
        //         this.coreCompetencies = [
        //         { id:1, activity:'ก. 1 การมุ่งผลสัมฤทธิ์', indicator:'1', data_table1:'', selfAssessment:'' },
        //         { id:2, activity:'ก. 2 การบริการที่ดี', indicator:'1', data_table1:'', selfAssessment:'' },
        //         { id:3, activity:'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator:'1', data_table1:'', selfAssessment:'' },
        //         { id:4, activity:'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator:'1', data_table1:'', selfAssessment:'' },
        //         { id:5, activity:'ก. 5 การทำงานเป็นทีม', indicator:'1', data_table1:'', selfAssessment:'' }
        //         ]
        //         this.jobSpecificCompetencies = []
        //         this.improvements = null
        //         this.suggestions = null

        //         const facxx = this.tracking_date.fac_id ? this.tracking_date.fac_id : this.facid_Main
        //         await this.showdataPo(data.staffid, facxx, this.tracking_date.d_date, this.tracking_date.evalua, data.posnameid)

        //         const res = await axios.post('http://127.0.0.1:8000/api/showDataP03New', {
        //         staff_id: data.staffid,
        //         fac_id: this.tracking_date.fac_id,
        //         year_id: this.tracking_date.d_date,
        //         evalua: this.tracking_date.evalua
        //         })
        //         if (Array.isArray(res.data)) {
        //         this.products_Tab1 = res.data
        //         this.products_Tab1.forEach(h => {
        //             h.subP01sX.forEach(sub => {
        //             const found = this.p01_scores.find(s => s.code === sub.p01_score)
        //             sub.p01_score = found ? found.code : this.p01_scores[0].code
        //             })
        //         })
        //         }
        //         this.DialogAdd = true
        //     })
        //  },
        async openDataEvalu(data, idx = null) {
            if (this.tracking_date?.d_date === undefined) {
                Swal.fire('แจ้งเตือนจากระบบ', 'กรุณาเลือกรอบประเมิน', 'error');
                return;
            }

            // ✅ set loading (เฉพาะปุ่มประเมิน)
            this.loadingEvalu = true;
            this.loadingEvaluIndex = idx;

            // ✅ popup loading
            Swal.fire({
                title: 'กำลังโหลดข้อมูล',
                text: 'กรุณารอสักครู่',
                allowOutsideClick: false,
                allowEscapeKey: false,
                didOpen: () => Swal.showLoading()
            });

            try {
                // =========================
                // ⬇️ ใส่โค้ดเดิมของคุณตรงนี้
                // =========================

                await this.getAadioPosition(data.staffid);
                this.dataStaffid = data.staffid;

                await this.showDataEvalu();
                this.currentstaff = this.products.filter(p => p.staffid === this.dataStaffid);

                this.products_Tab1 = [];
                this.p01_scores = [
                { name: '0 คะแนน', code: 0 }, { name: '1 คะแนน', code: 1 },
                { name: '2 คะแนน', code: 2 }, { name: '3 คะแนน', code: 3 },
                { name: '4 คะแนน', code: 4 }, { name: '5 คะแนน', code: 5 }
                ];

                this.coreCompetencies = [
                { id:1, activity:'ก. 1 การมุ่งผลสัมฤทธิ์', indicator:'1', data_table1:'', selfAssessment:'' },
                { id:2, activity:'ก. 2 การบริการที่ดี', indicator:'1', data_table1:'', selfAssessment:'' },
                { id:3, activity:'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator:'1', data_table1:'', selfAssessment:'' },
                { id:4, activity:'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator:'1', data_table1:'', selfAssessment:'' },
                { id:5, activity:'ก. 5 การทำงานเป็นทีม', indicator:'1', data_table1:'', selfAssessment:'' }
                ];

                this.jobSpecificCompetencies = [];
                this.improvements = null;
                this.suggestions = null;

                const facxx = this.tracking_date.fac_id ? this.tracking_date.fac_id : this.facid_Main;
                await this.showdataPo(data.staffid, facxx, this.tracking_date.d_date, this.tracking_date.evalua, data.posnameid);

                const res = await axios.post('http://127.0.0.1:8000/api/showDataP03New', {
                staff_id: data.staffid,
                fac_id: this.tracking_date.fac_id,
                year_id: this.tracking_date.d_date,
                evalua: this.tracking_date.evalua
                });

                if (Array.isArray(res.data)) {
                this.products_Tab1 = res.data;
                this.products_Tab1.forEach(h => {
                    h.subP01sX.forEach(sub => {
                    const found = this.p01_scores.find(s => s.code === sub.p01_score);
                    sub.p01_score = found ? found.code : this.p01_scores[0].code;
                    });
                });
                }

                this.DialogAdd = true;

            } catch (error) {
                console.error(error);

                // ปิด loading ก่อน แล้วค่อยแจ้ง error
                Swal.close();
                Swal.fire({
                icon: 'error',
                title: 'โหลดข้อมูลไม่สำเร็จ',
                text: 'กรุณาลองใหม่อีกครั้ง'
                });

            } finally {
                // ✅ reset loading state
                this.loadingEvalu = false;
                this.loadingEvaluIndex = null;

                // ✅ ปิด Swal เฉพาะกรณียังเป็น loading อยู่ (กันไปปิด popup error)
                if (Swal.isLoading()) Swal.close();
            }
        }, 
        async saveEvaTab1(subP01) {
            if (subP01.p01_score === null || subP01.p01_score === undefined || subP01.p01_score === '') {
                Swal.fire('แจ้งเตือน', 'กรุณาเลือกคะแนน !', 'error');
            } else {
                await axios
                    .post('http://127.0.0.1:8000/api/saveP03Po', {
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
                            title: 'ข้อมูลผลการประเมินถูกบันทึกเสร็จสิ้น',
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

        // async saveEvaTab1_1() {
        //    // console.log('this.coreCompetencies: ',this.coreCompetencies);
            
        //     this.coreCompetencies.forEach((item, index) => {
        //         if (index === 0) {
        //             item.data_table1 = item.data_table1 ?? 0; // Update based on the API response
        //         } else if (index === 1) {
        //             item.data_table1 = item.data_table1 ?? 0; // Update based on the API response
        //         } else if (index === 2) {
        //             item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
        //         } else if (index === 3) {
        //             item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
        //         } else if (index === 4) {
        //             item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
        //         } else if (index === 5) {
        //             item.data_table1 = item.data_table1 ?? 0; // Add more conditions if necessary
        //         }
        //     });
        //     this.jobSpecificCompetencies.forEach((item, index) => {
        //         if (index === 0) {
        //             item.SCORE = item.SCORE ?? 0; // Update based on the API response
        //         } else if (index === 1) {
        //             item.SCORE = item.SCORE ?? 0; // Update based on the API response
        //         } else if (index === 2) {
        //             item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
        //         } else if (index === 3) {
        //             item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
        //         } else if (index === 4) {
        //             item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
        //         } else if (index === 5) {
        //             item.SCORE = item.SCORE ?? 0; // Add more conditions if necessary
        //         }
        //     });
        //     this.otherCompetencies.forEach((item, index) => {
        //         if (index === 0) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Update based on the API response
        //         } else if (index === 1) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Update based on the API response
        //         } else if (index === 2) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
        //         } else if (index === 3) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
        //         } else if (index === 4) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
        //         } else if (index === 5) {
        //             item.selfAssessment3 = item.selfAssessment3 ?? 0; // Add more conditions if necessary
        //         }
        //     });
        //     const payload = {
        //         staffid_po: this.staffid_po,
        //         staff_id: this.staffid_Main,
        //         dataStaffid: this.dataStaffid,
        //         fac_id: this.tracking_date.fac_id ? this.tracking_date.fac_id :  this.facid_Main,
        //         year: this.tracking_date.d_date,
        //         record: this.tracking_date.evalua,
        //         coreCompetencies: this.coreCompetencies,
        //         jobSpecificCompetencies: this.jobSpecificCompetencies,
        //         otherCompetencies: this.otherCompetencies,
        //         improvements: this.improvements,
        //         suggestions: this.suggestions
        //     };
        //     const res = await axios.post('http://127.0.0.1:8000/api/saveP03PoTab1', payload);
        //     console.log(res.data);
        //     Swal.fire({
        //         position: 'top-end',
        //         icon: 'success',
        //         title: 'บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม เสร็จสิ้น',
        //         showConfirmButton: false,
        //         timer: 1500
        //     });
        //     await this.showDataEvalu();
        // },

        async saveEvaTab1_1() { 
            // ✅ 1) Validate ความเห็นก่อน
            const imp = (this.improvements || '').trim();
            const sug = (this.suggestions || '').trim();

            if (!imp) {
                Swal.fire({
                    icon: 'warning',
                    title: 'กรอกข้อมูลไม่ครบ',
                    text: 'กรุณากรอกข้อ 1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุง'
                });
                return;
            }

            if (!sug) {
                Swal.fire({
                    icon: 'warning',
                    title: 'กรอกข้อมูลไม่ครบ',
                    text: 'กรุณากรอกข้อ 2) ข้อเสนอแนะ'
                });
                return;
            }

            // ✅ 2) ตั้งค่า default ให้ score แบบสั้น ๆ ไม่ต้อง if index
            this.coreCompetencies.forEach(item => {
                item.data_table1 = item.data_table1 ?? 0;
            });

            this.jobSpecificCompetencies.forEach(item => {
                item.SCORE = item.SCORE ?? 0;
            });

            this.otherCompetencies.forEach(item => {
                item.selfAssessment3 = item.selfAssessment3 ?? 0;
            });

            const payload = {
                staffid_po: this.staffid_po,
                staff_id: this.staffid_Main,
                dataStaffid: this.dataStaffid,
                fac_id: this.tracking_date.fac_id ?? this.facid_Main,
                year: this.tracking_date.d_date,
                record: this.tracking_date.evalua,
                coreCompetencies: this.coreCompetencies,
                jobSpecificCompetencies: this.jobSpecificCompetencies,
                otherCompetencies: this.otherCompetencies,
                improvements: imp,
                suggestions: sug
            };

            try {

                Swal.fire({
                    title: 'กำลังบันทึกข้อมูล...',
                    allowOutsideClick: false,
                    didOpen: () => Swal.showLoading()
                });

                const res = await axios.post(
                    'http://127.0.0.1:8000/api/saveP03PoTab1',
                    payload
                );

                console.log('save result:', res.data);

                Swal.fire({
                    position: 'top-end',
                    icon: 'success',
                    title: 'บันทึกข้อมูลสมรรถนะ / ความเห็นเพิ่มเติม เสร็จสิ้น',
                    showConfirmButton: false,
                    timer: 1500
                });

                await this.showDataEvalu();

            } catch (error) {

                console.error('saveEvaTab1_1 error:', error);

                Swal.fire({
                    icon: 'error',
                    title: 'บันทึกไม่สำเร็จ',
                    text: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล'
                });

            }
        },

        async onTabChange(event) {
            // console.log('onTabChange: ',event.index);
            if (event.index == 0) {
                //console.log('ผลสัมฤทธิ์ของงาน -',event.index);
            }
            if (event.index == 1) {
                //console.log('รายงาน ป.01 - ป.03 -',event.index);
                // console.log('tab2Data: ',this.dataStaffid);
                this.tab2Data(this.dataStaffid);
                this.showdataPoText(this.dataStaffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua);
            }
            if (event.index == 2) {
                //console.log('แผนพัฒนาการปฏิบัติราชการรายบุคคล -',event.index);
                console.log('chkp04data: ',this.dataStaffid, this.facid_Main);
                
                this.products_Tab3 = []; 
                this.chkp04(this.dataStaffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua);
                this.chkp04data(this.dataStaffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua);
            }
            if (event.index == 3) {
                //console.log('รายงาน ป.04 -',event.index);
                this.tab2Data(this.dataStaffid);
                await this.chkp04dataT4(this.dataStaffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua);
                await this.chkp03data(this.dataStaffid, this.facid_Main, this.tracking_date.d_date, this.tracking_date.evalua);
                await this.showdatator();
                
            }
        },
        async tab2Data(staff_id) {
            await axios.post('http://127.0.0.1:8000/api/showDataP03New', {
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
            
            axios .post('http://127.0.0.1:8000/api/showDataPo', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    console.log('showDataPo: ',res.data);
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
                .post('http://127.0.0.1:8000/api/showDataPo', {
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
                .post('http://127.0.0.1:8000/api/saveEvaTab3', {
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
                .post('http://127.0.0.1:8000/api/showData04Tab3', {
                    staff_id: staff_id,
                    fac_id: fac_id,
                    year_id: year_id,
                    record: record
                })
                .then((res) => {
                    console.log('showData04Tab3: ',res.data);
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
                .post('http://127.0.0.1:8000/api/showData04Tab3', {
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
                    .post('http://127.0.0.1:8000/api/showdatator', {
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
            //console.log('showPostype: ',postypename, postypenameid);
            //let postypenameText = postypename ? postypename : `ชำนาญการพิเศษ`;
            let postypenameText = this.postypenameth ;
            // var postypetext =postypename;
            var postypetext = `ระดับ` + postypenameText;
            // var postypetext = `ระดับ` + postypename;
            await axios .post('http://127.0.0.1:8000/api/showdatapostypenameAdmin', {
                    postypename: postypetext,
                    postypenameid: postypenameid
                })
                .then((res) => {
                   // console.log('showPostype',res.data);
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

            axios .post('http://127.0.0.1:8000/api/showdataposp02', { 
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
        normalizeLevelName(v) {
            const s = String(v ?? '').trim();
            return s.replace(/^ระดับ\s*/, '').trim();
        },
        
        //บิวแก้260269
        // async showdataPo(staff_id, facid_Main, d_date, evalua, posnameid) {  

        //     if (!this.currentstaff || this.currentstaff.length === 0) {
        //         console.error("Error: currentstaff is undefined or empty.");
        //         return;
        //     } 
        //     const BLACKLIST = ['110105','110146','160018'];
        //     const isBlacklisted = BLACKLIST.includes(String(staff_id));

        //     // const isExecutiveRole = normalizeLevelName(this.currentstaff[0]?.posnameth) === 'ผู้บริหาร';090269
        //     const isExecutiveRole = this.normalizeLevelName(this.currentstaff[0]?.posnameth) === 'ผู้บริหาร';
 
        //     const isSpecialExpert =
        //         // this.posadio === '128' ||090269
        //         String(this.posadio) === '128' ||
        //         (
        //             String(posnameid) === '137' &&
        //             // this.currentstaff[0]?.postypenameth === 'ผู้บริหาร'090269
        //             isExecutiveRole
        //         );
 
        //     if (isSpecialExpert && !isBlacklisted) {
        //         this.postypenameth = 'ชำนาญการพิเศษ';
        //     } else {
        //         // this.postypenameth = this.currentstaff[0]?.postypenameth || 'ปฏิบัติการ';  090269
        //         this.postypenameth = this.normalizeLevelName(this.currentstaff[0]?.postypenameth) || 'ปฏิบัติการ';

        //     }

        //     // let postypetext = `ระดับ${this.postypenameth}`;090269
             
        //     const levelName = this.normalizeLevelName(this.postypenameth);
        //     const postypetext = `ระดับ${levelName}`;
 
        //     const levelMapping = {
        //         'ระดับปฏิบัติการ': 1,
        //         'ระดับปฏิบัติงาน': 1,
        //         'ระดับชำนาญการ': 2,
        //         'ระดับชำนาญงาน': 2,
        //         'ระดับชำนาญการพิเศษ': 3,
        //         'ระดับชำนาญงานพิเศษ': 3,
        //         'อาจารย์': 3,
        //         'ระดับเชี่ยวชาญ': 4,
        //         'ระดับเชี่ยวชาญพิเศษ': 5
        //     };

        //     // let xr = levelMapping[postypetext] || 0;090269
        //     let xr = levelMapping[postypetext] ?? 0;
             
        //     this.coreCompetencies = [
        //         { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: xr, data_table1: '', selfAssessment: '' },
        //         { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: xr, data_table1: '', selfAssessment: '' },
        //         { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: xr, data_table1: '', selfAssessment: '' },
        //         { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: xr, data_table1: '', selfAssessment: '' },
        //         { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: xr, data_table1: '', selfAssessment: '' }
        //     ];

        //     this.jobSpecificCompetencies = [];
 
        //     // const Mapping = { '128': 1 };
        //     // let executive = Mapping[this.posadio] || 0; 
        //     // if (isBlacklisted) { executive = 0; }

        //      //  ให้ขึ้น ค. เฉพาะคนใน allowlist
        //     const staffId = String(this.staffid_Main).trim();  
        //     let executive = EXECUTIVE_ALLOWLIST.has(staffId) ? 1 : 0; 
        //     this.canScoreExecutive = EXECUTIVE_SCORE_ALLOWLIST.has(staffId);
        //     //console.log('staffId:', staffId, 'executive:', executive);



        //     this.otherCompetencies = [
        //         { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
        //         { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
        //         { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
        //         { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
        //         { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
        //     ]; 
        //     // await this.showPostype(this.postypenameth, posnameid);090269
        //     await this.showPostype(levelName, posnameid);
 
        //     try {
        //         const res = await axios.post('http://127.0.0.1:8000/api/showDataPo', {
        //             staff_id: staff_id,
        //             fac_id: facid_Main,
        //             year_id: d_date,
        //             record: evalua,
        //             postypename: postypetext
        //         });

        //         if (res.data.length > 0) {
        //             const data = res.data[0];
        //             this.coreCompetencies = this.coreCompetencies.map(item => {
        //                 if (data[`p${item.id}`] !== undefined) {
        //                     return {
        //                         ...item,
        //                         data_table1: data[`p${item.id}`],
        //                         selfAssessment: data[`pa_${item.id}`]
        //                     };
        //                 }
        //                 return item;
        //             });
        //         }
        //     } catch (error) {
        //         console.error('Error:', error);
        //     }
        // },

        async showdataPo(staff_id, facid_Main, d_date, evalua, posnameid) {
            if (!this.currentstaff || this.currentstaff.length === 0) {
                console.error("Error: currentstaff is undefined or empty.");
                return;
            }

            // ===== 1) ตีความ "ผู้ถูกประเมินเป็นผู้บริหารไหม"
            // posadio มาจาก await this.getAadioPosition(data.staffid) ใน openDataEvalu()
            const targetId = String(staff_id).trim();
            const posadioStr = String(this.posadio).trim();

            // ✅ ผู้ถูกประเมินเป็นผู้บริหาร: posadio=128 หรืออยู่ใน allowlist
            this.isTargetExecutive = (posadioStr === '128') || EXECUTIVE_ALLOWLIST.has(targetId);

            // ===== 2) ตีความ "ผู้ประเมินมีสิทธิ์ให้คะแนน (6) ไหม"
            const scorerId = String(this.staffid_Main).trim(); // คน login
            this.canScoreExecutive = EXECUTIVE_SCORE_ALLOWLIST.has(scorerId);

            // ระดับที่คาดหวังของ ค.(5)
            const executiveExpected = this.isTargetExecutive ? 1 : 0;

            // ===== 3) คำนวณระดับ ก.(1) ตามระดับตำแหน่ง
            const isExecutiveRole =
                this.normalizeLevelName(this.currentstaff[0]?.posnameth) === "ผู้บริหาร";

            const isSpecialExpert =
                (posadioStr === "128") || (String(posnameid).trim() === "137" && isExecutiveRole);

            if (isSpecialExpert) {
                this.postypenameth = "ชำนาญการพิเศษ";
            } else {
                this.postypenameth =
                this.normalizeLevelName(this.currentstaff[0]?.postypenameth) || "ปฏิบัติการ";
            }

            const levelName = this.normalizeLevelName(this.postypenameth);
            const postypetext = `ระดับ${levelName}`;

            const levelMapping = {
                "ระดับปฏิบัติการ": 1,
                "ระดับปฏิบัติงาน": 1,
                "ระดับชำนาญการ": 2,
                "ระดับชำนาญงาน": 2,
                "ระดับชำนาญการพิเศษ": 3,
                "ระดับชำนาญงานพิเศษ": 3,
                "อาจารย์": 3,
                "ระดับเชี่ยวชาญ": 4,
                "ระดับเชี่ยวชาญพิเศษ": 5
            };
            const xr = levelMapping[postypetext] ?? 0;

            // ===== 4) ตั้งค่าเริ่มต้นตาราง
            this.coreCompetencies = [
                { id: 1, activity: "ก. 1 การมุ่งผลสัมฤทธิ์", indicator: xr, data_table1: "", selfAssessment: "" },
                { id: 2, activity: "ก. 2 การบริการที่ดี", indicator: xr, data_table1: "", selfAssessment: "" },
                { id: 3, activity: "ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ", indicator: xr, data_table1: "", selfAssessment: "" },
                { id: 4, activity: "ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม", indicator: xr, data_table1: "", selfAssessment: "" },
                { id: 5, activity: "ก. 5 การทำงานเป็นทีม", indicator: xr, data_table1: "", selfAssessment: "" }
            ];

            this.jobSpecificCompetencies = [];

            this.otherCompetencies = [
                { id: 12, activity: "ค. 1 สภาวะผู้นำ", indicator3: executiveExpected, datatable3: "", selfAssessment3: "" },
                { id: 13, activity: "ค. 2 วิสัยทัศน์", indicator3: executiveExpected, datatable3: "", selfAssessment3: "" },
                { id: 14, activity: "ค. 3 การวางกลยุทธ์ภาครัฐ", indicator3: executiveExpected, datatable3: "", selfAssessment3: "" },
                { id: 15, activity: "ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน", indicator3: executiveExpected, datatable3: "", selfAssessment3: "" },
                { id: 16, activity: "ค. 5 การสอนงานและการมอบหมายงาน", indicator3: executiveExpected, datatable3: "", selfAssessment3: "" }
            ];

            // โหลด ข.
            await this.showPostype(levelName, posnameid);

            // โหลดคะแนนเดิม ก.
            try {
                const res = await axios.post("http://127.0.0.1:8000/api/showDataPo", {
                staff_id: staff_id,
                fac_id: facid_Main,
                year_id: d_date,
                record: evalua,
                postypename: postypetext
                });

                if (Array.isArray(res.data) && res.data.length > 0) {
                const data = res.data[0];
                this.coreCompetencies = this.coreCompetencies.map((item) => {
                    const keyScore = `p${item.id}`;
                    const keySelf = `pa_${item.id}`;
                    if (data[keyScore] !== undefined) {
                    return {
                        ...item,
                        data_table1: data[keyScore] ?? 0,
                        selfAssessment: data[keySelf] ?? 0
                    };
                    }
                    return item;
                });
                }
            } catch (error) {
                console.error("Error:", error);
            }

            // ✅ debug สำคัญ (เปิด console แล้วดู)
            // console.log("[EXEC DEBUG]", {
            //     targetId,
            //     posadio: this.posadio,
            //     isTargetExecutive: this.isTargetExecutive,
            //     scorerId,
            //     canScoreExecutive: this.canScoreExecutive
            // });
        },
 
        //29/10/67
        saveScore() {
            axios
                .post('http://127.0.0.1:8000/api/saveDatator', {
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
                    .post('http://127.0.0.1:8000/api/saveDatator', formData)
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
               // console.log('jobSpecificCompetencies[i]?.SCORE: ',dataTable2Value);


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
                axios.post('http://127.0.0.1:8000/api/showData04Tab3',{
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
            axios.post('http://127.0.0.1:8000/api/saveEvaTab03xx',{
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
            axios.post('http://127.0.0.1:8000/api/delEvaTab03xx',{
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
            console.log('📤 Sending data:', this.products_Tab3T4);  

            if (!this.products_Tab3T4.length) {
                console.warn('❗ No data to send');
                return;
            }

            let self = this.products_Tab3T4[0];  // ✅ ดึง object แรกจาก array

            axios.post('http://127.0.0.1:8000/api/saveexcucive', {
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
                const response = await axios.post('http://127.0.0.1:8000/api/savedataAssess', { 
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
                    title: 'ข้อมูลผลการประเมินถูกบันทึกเสร็จสิ้น',
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
        async printDatatracking() { 
            const { signIn, getSession, signOut } = await useAuth() 
            const user = await getSession();   
            const form = {
                staff_id: this.staffid_Main,
                group_id: this.groupid_Main,
                fac_id: this.tracking_date.fac_id,
                year_id: this.tracking_date.d_date,
                evalua: this.tracking_date.evalua,
                PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                STAFFNAME :user.user.name.STAFFNAME,
                STAFFSURNAME:user.user.name.STAFFSURNAME,
                POSITIONNAME:user.user.name.POSITIONNAME,
                GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                POSTYPENAME:user.user.name.POSTYPENAME, 
                SCOPES:user.user.name.SCOPES.staffdepartmentname,
                postypename: `ระดับ${this.postypename}`,
                postypenameid: this.postypenameid,
                stftypename: this.stftypename,
            } 
            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `http://127.0.0.1:8000/report_tracking?${queryParams}`;
            window.open(url, '_blank');
 
        },     

 
     //110269
        normalizeActivityRaw(raw) {
            let s = String(raw || "").trim();
            if (!s) return "";

            // รองรับกรณีมี <br>
            s = s.replace(/<br\s*\/?>/gi, "\n");

            // ถ้าข้อความยาว ๆ มาจาก API แบบ “1. ... 2. ... 3. ...” แต่ไม่มี \n
            // ให้แทรก \n ก่อนเลขข้อ (ยกเว้นตัวแรก)
            s = s.replace(/(\s)(\d+(?:\.\d+)*\.)\s+/g, "\n$2 ");

            // ลบช่องว่างซ้อน
            s = s.replace(/[ \t]+/g, " ").replace(/\n{2,}/g, "\n");

            return s.trim();
        },

        parseActivityText(raw) {
            const text = this.normalizeActivityRaw(raw);
            if (!text) return { mainTitle: "", lines: [] };

            const rows = text
                .split(/\r?\n/)
                .map(r => r.trim())
                .filter(Boolean);

            const cleanMain = (s) =>
                s.replace(/^(\d+\.)\s*/, "")
                .replace(/^[-•]\s*/, "")
                .trim();

            const mainTitle = cleanMain(rows[0] || "");

            const lines = rows.map((r, idx) => {
                if (idx === 0) return { type: "main", text: cleanMain(r) };

                let s = r.replace(/^[-•]\s*/, "").trim();
                const m = s.match(/^(\d+(?:\.\d+)*\.)\s*(.*)$/);
                const no = m ? m[1] : "";
                const body = m ? (m[2] || "") : s;

                return { type: "sub", no, text: body.trim() };
            });

            return { mainTitle, lines };
        },

        getMainSubject(raw) {
            return this.parseActivityText(raw).mainTitle || "";
        },

        stripLeadingNo(text) {
            return String(text || '').replace(/^\s*\d+(?:\.\d+)*\.\s*/, '').trim();
        },

        async loadCompetencyDescriptions() {
            try {
                const res = await axios.get('http://127.0.0.1:8000/api/competencies');
                const map = {};
                (res.data || []).forEach(it => {
                if (it.WORK_NAME) map[it.WORK_NAME.trim()] = it;
                });
                this.competencyMap = map;
            } catch (e) {
                console.error('loadCompetencyDescriptions error', e);
            }
            },

            extractNameFromActivity(activityText) {
            if (!activityText) return '';
            const parts = String(activityText).trim().split(/\s+/);
            if (parts.length <= 2) return String(activityText).trim();
            // "ก. 1 การมุ่งผลสัมฤทธิ์" -> "การมุ่งผลสัมฤทธิ์"
            return parts.slice(2).join(' ');
            },

            openCompetencyDialog(type, row, index = null) {
            let title = '';
            let description = '';

            if (type === 'core') {
                title = row.activity;
                const workName = this.extractNameFromActivity(row.activity);
                const master = this.competencyMap[workName] || null;

                description =
                (master?.WORK_DATAIL) ||
                (this.coreDescriptions?.[row.id]) ||
                'ยังไม่มีคำอธิบายสำหรับรายการนี้';

            } else if (type === 'job') {
                const order = index !== null ? index + 1 : '';
                title = `ข. ${order} ${row.WORK_NAME}`;

                // ใช้จากรายการ ข. ก่อน (ถ้า API ส่งมา)
                const baseDetail = row.WORK_DATAIL || this.competencyMap[String(row.WORK_NAME || '').trim()]?.WORK_DATAIL || '';
                const levelDetail = row.LEVEL_DETAIL || '';

                description = baseDetail || 'ยังไม่มีคำอธิบายสำหรับรายการนี้';
                if (levelDetail) description += `\n\n${levelDetail}`;

            } else if (type === 'other') {
                title = row.activity;
                const workName = this.extractNameFromActivity(row.activity);
                const master = this.competencyMap[workName] || null;

                description =
                (master?.WORK_DATAIL) ||
                (this.otherDescriptions?.[row.id]) ||
                'ยังไม่มีคำอธิบายสำหรับรายการนี้';
            }

            this.selectedCompetency = { title, description };
            this.competencyDialogVisible = true;
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
.loading-wrap{
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  padding:32px; color:#555;
}

.loading-overlay{
  position: fixed; inset: 0;
  background: rgba(255,255,255,.7);
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  z-index: 9999;
} 

.clickable{
  text-align:left;
  cursor:pointer;
  color:#0d47a1;
}
.clickable:hover{
  text-decoration: underline;
}

</style>