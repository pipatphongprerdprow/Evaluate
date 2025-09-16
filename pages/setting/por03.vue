<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="col md:col-12 text-right">
                <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP03"></Button>
            </div>   
              <!-- {{ user }} -->​  
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-9">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป03
                        </h3>
                        <B><h4>1.ผลสัมฤทธิ์ของงาน</h4></B>
                    </div> 
                </div> 
                <!-- แสดงข้อมูลบันทึก --> 
                <table class="table">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width: 17%;">กิจกรรม / โครงการ / งาน</th>
                            <th rowspan="2" style="width: 26%;">ตัวชี้วัด / เกณฑ์การประเมิน</th>
                            <th rowspan="2" style="width: 25%;">รายงานการปฏิบัติราชการ<br> ตามตัวชี้วัด/เกณฑ์การประเมิน</th>
                            <th rowspan="2" style="width: 20%;">หลักฐานที่แสดงถึง<br> ผลการปฏิบัติราชการ<br>ตามเกณฑ์การประเมิน<br>(หลักฐานเชิงประจักษ์)</th>
                            <th colspan="5" style="width: 11%;">ระดับการประเมินตนเอง<br> (ค่าคะแนนที่ได้)</th>
                            <th v-if="currentDate >= dataPor.d_scoringday" rowspan="2" style="width: 9%;">ค่าคะแนนที่ได้</th>
                            <th rowspan="2" style="width: 10%;"><br> ตัวเลือก <br></th>
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
                        <template v-for="(h, ind) in products_personP03" :key="ind"> 
                            <tr>
                                <td style="text-align: left;" colspan="9">
                                    <b style="color: blue;">{{ h.h_no }}. {{ h.nameH }}</b>
                                </td>
                                <td class="text-center" style="color: blue;"><b></b></td>

                            </tr>
                            <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                                <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                <td style="text-align: left;">
                                    <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                    <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                        <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                        <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
                                    </p>
                                    <!-- <p v-if="subP01.p01_detail != null">  
                                        <b style="color: red;">ข้อเสนอแนะ</b>
                                        <br>
                                        <em style="color: red;">{{ subP01.p01_detail }}</em>
                                    </p> -->
                                    <p v-if="subP01.p01_detail !== null && currentDate >= dataPor.d_scoringday">  
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
                                                    <b>{{ index + 1 }}.</b> {{ item.p03ind_Items }}
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <p v-if="subP01.subITemP03ind.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                        <b style="color: red;">- ไม่มีข้อมูล -</b>
                                    </p>
                                </td> 


                                <!-- <td style="text-align: left;"> 
                                    <p v-for="(subIitemDoc, inDoc) in subP01.subITemP03doc" :key="inDoc" style="padding-left: 8px;margin-bottom: 5px;"> 
                                        <a v-if="subIitemDoc.doc_file!=null && subIitemDoc.doc_link==null" :href="'   http://127.0.0.1:8000/storage/uploadsP03/'+subIitemDoc.doc_file" target="_blank"><b>ระดับ</b> <b>{{subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                        <a v-if="subIitemDoc.doc_link!=null && subIitemDoc.doc_file==null" :href="subIitemDoc.doc_link" target="_blank"><b>ระดับ</b> <b>{{ subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                    </p>
                                    <p v-if="subP01.subITemP03doc.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                        <b style="color: red;">- ไม่มีข้อมูล -</b>
                                    </p>
                                </td>  -->
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
                                    <b v-if="subP01.score==1">&#10003;</b>
                                    <b v-if="subP01.score!=1"></b>
                                </td>
                                <td style=" vertical-align: middle;" class="text-center">
                                    <b v-if="subP01.score==2">&#10003;</b>
                                    <b v-if="subP01.score!=2"></b>
                                </td>
                                <td style=" vertical-align: middle;" class="text-center">
                                    <b v-if="subP01.score==3">&#10003;</b>
                                    <b v-if="subP01.score!=3"></b>
                                </td>
                                <td style=" vertical-align: middle;" class="text-center">
                                    <b v-if="subP01.score==4">&#10003;</b>
                                    <b v-if="subP01.score!=4"></b>
                                </td>
                                <td style=" vertical-align: middle;" class="text-center">
                                    <b v-if="subP01.score==5">&#10003;</b>
                                    <b v-if="subP01.score!=5"></b>
                                </td> 
                                <td v-if="currentDate >= dataPor.d_scoringday" style="vertical-align: middle;" class="text-center">
                                    {{ subP01.p01_score }}
                                </td> 
                                <td style=" vertical-align: middle;" class="text-center">
                                    <!-- {{ currentDate }} -- {{ dataPor.d_enddate }} -->
                                    <div v-if="currentDate < dataPor.d_enddate"> 
                                        <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                    </div>
                                    <div v-else style="color: brown; font-weight: bold; text-align: center;"> ครบกำหนดวันบันทึก ป.03 </div>
                                </td>
                            </tr>
                        </template>
                    </tbody>
                </table>  
            </div> 
            <br>
            <div class="card mb-0">
                <!-- พฤติกรรมการปฏิบัติราชการ -->
                <B><h4>2.พฤติกรรมการปฏิบัติราชการ</h4></B>
                <!-- {{jobSpecificCompetencies}} -->
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
                                    <td>{{ row1.indicator }}</td>
                                    <!-- <td> 
                                        <InputText 
                                            v-model="row1.selfAssessment"
                                            type="text" 
                                            placeholder="0" 
                                            autocomplete="off"  
                                            @input="validateNumericInput(index)"
                                            showButtons
                                        />    
                                    </td>  -->
                                    <td>
                                        <InputNumber 
                                            v-model.number="row1.selfAssessment" 
                                            type="text" 
                                            placeholder="0" 
                                            autocomplete="off" 
                                            :min="0" 
                                            :max="5"
                                            showButtons
                                        />
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
                                    <!-- <td>
                                        <InputText 
                                            v-model="row2.selfAssessment"
                                            type="text" 
                                            placeholder="0" 
                                            autocomplete="off"  
                                            @input="validateNumericInputR2(index)"
                                            showButtons
                                        />    
                                    </td> -->
                                    <td>
                                        <InputNumber 
                                            v-model.number="row2.selfAssessment" 
                                            type="text" 
                                            placeholder="0" 
                                            autocomplete="off" 
                                            showButtons
                                        />
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
                                        <b v-if="row3.indicator3 == '' ||  row3.indicator3 == null" style="color: red;">-</b>
                                        <span v-if="row3.indicator3 != 0">{{ row3.indicator3 }}</span>  
                                    </td>
                                    <!-- <td>  
                                        <b v-if="row3.datatable3 == '' ||  row3.datatable3 == null" style="color: red;">-</b> 
                                        <b v-if="row3.datatable3 != 0 " style="color: blue" >{{ row3.datatable3 }}</b> 
                                    </td> -->
                                    <td> 
                                        <!-- <template v-if="posadio === '128'"> -->
                                        <template v-if="posadio === '128' && String(staffid_Main) !== '110105'">
                                            <InputNumber 
                                                v-model.number="row3.datatable3" 
                                                type="text" 
                                                placeholder="0" 
                                                autocomplete="off" 
                                                showButtons
                                            />
                                        </template>
                                        <template v-else>
                                            <b><span style="color: red;">-</span></b>
                                        </template>
                                    </td>
                                    <td>  
                                        <!-- <b v-if="row3.selfAssessment3 == '' " style="color: red;">-</b>  -->
                                         <b v-if="row3.selfAssessment3 == '' ||  row3.selfAssessment3 == null" style="color: red;">-</b>
                                        <b v-if="row3.selfAssessment3 != 0 " >{{ row3.selfAssessment3 }}</b> 
                                    </td>
                                </tr> 
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> 
            <div class="ml-4 mr-4" style="text-align: center;">
            <Button icon="pi pi-save" severity="primary" class="mb-2 mr-2" label="บันทึกระดับสมรรถนะประเมินตนเอง" @click="saveAssess" />  
        </div>  
            <br>
            <!-- เพิ่มทักษะที่ต้องการพัฒนา -->
            <div class="card mb-0"> 
                <div class="p-fluid formgrid grid">
                    <div class="field col-12 md:col-12"> 
                        <label for="list_no_p03">ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา<em style="color: red;"></em></label>
                        <InputGroup style="text-align: center;">
                            <Textarea v-model="p04_re1" rows="4" placeholder="ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา" />
                            <Textarea v-model="p04_re2" rows="4" placeholder="วิธีการพัฒนา" />
                            <Textarea v-model="p04_re3" rows="4" placeholder="ช่วงเวลาที่ต้องการพัฒนา" /> 
                            <Button label="เพิ่ม" severity="info" @click="AddDatap04" />
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
                            <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(slotProps.data.id)" />
                        </template>
                    </Column>
                </DataTable>  
            </div>

        </div>
    </div>
       
        <!-- รางานการปฏิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน -->
        <Dialog header="จัดการ รายงานการปฏิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
            <form> 
                <InputText v-model="text_edtP03" type="hidden" style="display: none;" /> 
                <!-- <div class="p-fluid formgrid grid">
                    <div class="field col-12 md:col-12">
                        <label for="list_no_p03">รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน <em style="color: red;font-size: small">*ถ้ามี 1 ระดับ ให้ใส่ ระดับ 0</em></label>
                        <InputGroup style="text-align: center;">
                            <InputText v-model="list_no_p03" type="number" placeholder="ลำดับ" autocomplete="off" class="col-12 md:col-2" />
                            <InputText v-model="list_text_p03" type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/>
                            <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" />
                        </InputGroup>
                    </div>
                </div> -->
                <div class="p-fluid formgrid mb-2">  
                    <label for="list_no_p03">รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน <em style="color: red;font-size: small">*ถ้ามี 1 ระดับ ให้ใส่ ระดับ 0</em></label> 
                    <div class="p-fluid formgrid grid"> 
                        <div class="col-12 md:col-2">
                            <label for="list_no_p03">ระดับ</label>
                            <Dropdown v-model="list_no_p03" :options="list_no_p03s" optionLabel="name" placeholder="เลือกระดับ"></Dropdown>  
                        </div> 
                        <!-- <div class="col-12 md:col-2">
                            <label for="list_no_p03">ระดับ</label>
                            <InputText v-model="list_no_p03" type="number" placeholder="เลือกระดับ" autocomplete="off" />   
                        </div> -->


                        <div class="col-12 md:col-8">
                            <label for="list_text_p03">รายงานชื่อตัวชี้วัด / เกณฑ์การประเมิน</label>
                            <InputText v-model="list_text_p03" type="text" placeholder="รายงานชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/>  
                        </div>  
                        <div class="col-12 md:col-2" style="align-self: end;">
                            <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" /> 
                        </div> 
                        <!-- <div class="field col-12 md:col-12">  
                            <label for="improvements">1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</label>
                                <textarea v-model="improvements" rows="4" class="custom-textarea" ></textarea> 
                        </div> -->
                    </div>   
                </div>   
                <DataTable :value="products_list_p03" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                    <Column field="p03ind_no" header="ลำดับ" style="width: 10%">
                        <template #body="Item"> 
                            ระดับที่ {{ Item.data.p03ind_no }}
                        </template>
                    </Column>
                    <Column field="p03ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="text-align: left;width: 35%">
                        <template #body="Item">
                        {{ Item.data.p03ind_Items }}
                        </template>
                    </Column>  
                    <Column field="options" header="ตัวเลือก" style="text-align: center; width: 10%">
                        <template #body="Item"> 
                            <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="EditRegislickP03(Item.data)"></Button>&nbsp;
                            <Button style="text-align: center;" severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislicklist(Item.index)"></Button> 
                        </template>
                    </Column>
                </DataTable> 
            </form>
            <template #footer>
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataListP03" />
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="DialogAdd= false" />
            </template>
        </Dialog> 
        <!-- แก้ไขการปฏิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน -->
        <Dialog header="แก้ไขข้อมูลเกณฑ์การประเมิน" maximizable v-model:visible="DialogEditListP03" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
            <form>
                <div class="p-fluid formgrid"> 
                    <form> 
                        <div class="p-fluid formgrid grid">
                            <div class=" col-12 md:col-12"> 
                                <label for="text_search_no">เกณฑ์การประเมิน</label>
                            </div>
                            <div class=" col-12 md:col-3"> 
                                <label for="text_search_no">ระดับ</label>
                                <InputText v-model="text_search_noEditP03" type="number" placeholder="ระดับ" autocomplete="off" disabled />  
                            </div>
                            <div class="col-12 md:col-9"> 
                                <label for="text_search_no">รายละเอียดเกณฑ์การประเมิน</label> 
                                <textarea id="text_search_no" v-model="text_searchEditP03" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off" class="w-full p-2 border rounded-md" rows="4" ></textarea>
                            </div>    
                        </div> 
                    </form>
                </div>
            </form>
            <template #footer>
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataxEditP03" />&nbsp;
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialogEdiP03" />
            </template>
        </Dialog>


        <!-- (หลักฐาน)รางานการปฏิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน -->
        <Dialog header="จัดการ หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์)" maximizable v-model:visible="DialogDoc" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
            <form>
                <InputText v-model="text_edtDoc" type="hidden" style="display: none;" /> 
                <div class="p-fluid formgrid"> 
                    <div class="field col-12 md:col-6">
                        <label for="radioValueDoc">เลือกประเภทการแนปเอกสาร</label> 
                        <b style="color: red;"> (รองรับขนาดไฟล์ไม่เกิน 8 Mb) </b>

                        <!-- <Dropdown v-model="radioValueDoc" :options="radioValueDocs" optionLabel="name" placeholder="เลือกระดับการประเมินตนเอง"></Dropdown>  -->
                        <div class="grid">
                            <div class="col-12 md:col-4">
                                <div class="field-radiobutton mb-0">
                                    <RadioButton id="option1" name="option" value="doc" v-model="radioValue" />
                                    <label for="option1">ไฟล์เอกสาร</label>
                                </div>
                            </div>
                            <div class="col-12 md:col-4">
                                <div class="field-radiobutton mb-0">
                                    <RadioButton id="option2" name="option" value="link" v-model="radioValue" />
                                    <label for="option2">ลิงค์เอกสาร</label>
                                </div>
                            </div>  
                        </div>
                    </div> 
                </div>   
                <div class="p-fluid formgrid grid"> 
                    <div class="col-12 md:col-2">
                        <label for="doc_no">ลำดับ</label>
                        <InputText v-model="doc_no" type="number" placeholder="ลำดับเอกสาร" autocomplete="off"/>  
                    </div> 
                    <div class="col-12 md:col-10">
                        <label for="doc_no">ชื่อไฟล์</label>
                        <InputText v-model="doc_name" type="text" placeholder="ชื่อไฟล์" autocomplete="off"/>  
                    </div>  
                </div>  
                <div class="p-fluid formgrid grid mt-2"> 
                    <div class="col-12 md:col-10" v-if="radioValue == 'doc' ">
                        <label for="doc_no">แนบเอกสาร</label>  
                        <input ref="upload"
                            type="file"
                            name="file-upload" 
                            autocomplete="off"
                            @change="handleFileChange">  
                    </div> 
                    <div class="col-12 md:col-10" v-if="radioValue == 'link' ">
                        <label for="doc_no">แนบลิงค์เอกสาร</label>
                        <InputText v-model="doc_link" type="text" placeholder="แนบลิงค์เอกสาร ( URL )" autocomplete="off"/>  
                    </div> 
                    <div class="col-12 md:col-2" style="align-content: flex-end;">
                        <Button icon="pi pi-check" label="บันทึก" class="mb-2 mr-2" @click="saveDataDoc" /> 
                    </div> 
                </div> 
                <hr>
                <div class="p-fluid formgrid grid">  
                    <div class="field col-12 md:col-12">  
                        <DataTable :value="products_doc_p03" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                            <Column field="doc_no" header="ลำดับเอกสาร" style="width: 15%">
                                <template #body="Item">
                                    เอกสารลำดับที่ {{ Item.data.doc_no }}
                                </template>
                            </Column>
                            <Column field="doc_name" header="ชื่อไฟล์" style="text-align: left;width: 35%">
                                <template #body="Item"> 
                                    <a v-if="Item.data.doc_file!=null" :href="'   http://127.0.0.1:8000/storage/uploadsP03/'+Item.data.doc_file" target="_blank">{{ Item.data.doc_name }}</a> 
                                    <a v-if="Item.data.doc_link!=null" :href="Item.data.doc_link" target="_blank">{{ Item.data.doc_name }}</a> 
                                </template>
                            </Column>  
                            <Column field="options" header="ตัวเลือก" style="text-align: center; width: 15%">
                                <template #body="Item">
                                    <Button severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="EditDataDocFilename(Item.data)"></Button> &nbsp; 
                                    <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="delDataDocX(Item.data)"></Button>
                                </template>
                            </Column>
                        </DataTable>  
                    </div>  
                </div> 
            </form>
                <template #footer> 
                    <Button label="ตกลง"  class="mb-2 mr-2" severity="contrast" @click="DialogDoc = false" />
                </template>
        </Dialog>

         <!-- แก้ไขชื่อหลักฐานเชิงปนะจักษ์ -->
         <Dialog header="แก้ไขข้อมูลชื่อหลักฐานเชิงประจักษ์" maximizable v-model:visible="DialogEditFileP03" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
            <form>
                <div class="p-fluid formgrid"> 
                    <form> 
                        <InputText v-model="text_docid" type="hidden" style="display: none;" /> 
                        <InputText v-model="text_p01id" type="hidden" style="display: none;" /> 
                        <div class="p-fluid formgrid grid">
                            <div class=" col-12 md:col-12"> 
                                <label for="text_search_no"></label>
                            </div>
                            <div class=" col-12 md:col-3"> 
                                <label for="text_search_no">ลำดับเอกสาร</label>
                                <InputText v-model="text_search_noEditFileP03" type="number" placeholder="ลำดับเอกสาร" autocomplete="off" />  
                            </div>
                            <!-- <div class=" col-12 md:col-9"> 
                                <label for="text_search_no">รายละเอียดชื่อเอกสารแนบ</label>
                                <InputText v-model="text_searchEditFileP03" type="text" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off"/>  
                            </div>  -->
                            <div class="col-12 md:col-9"> 
                                <label for="text_search_no">รายละเอียดชื่อเอกสารแนบ</label> 
                                <textarea id="text_search_no" v-model="text_searchEditFileP03" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off" class="w-full p-2 border rounded-md" rows="4" ></textarea>
                            </div>   
                        </div> 
                    </form>
                </div>
            </form>
            <template #footer>
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataxEditFileP03" />&nbsp;
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialogEditFileP03" />
            </template>
        </Dialog>

        <!-- /*============= ระดับการประเมินตนเอง (ค่าคะแนนที่ได้) =============*/ -->  
        <Dialog header="ระดับคะแนนประเมินตนเอง (ค่าคะแนนที่ได้) " maximizable v-model:visible="DialogScore" :breakpoints="{ '960px': '75vw' }" :style="{ width: '30vw' }" :modal="true" position="top">
            <form> 
                <div class="p-fluid formgrid">
                    <InputText v-model="text_edtP03Score" type="hidden" style="display: none;" />
                    <div class="field col-12 md:col-12">
                        <label for="list_no_p03">ระดับการประเมินตนเอง</label>   
                        <Dropdown v-model="score_p03" :options="score_p03s" optionLabel="name" placeholder="เลือกระดับการประเมินตนเอง"></Dropdown> 
                    </div>
                </div>  
            </form>
                <template #footer>
                    <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataScoreP03" />
                    <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="DialogScore = false" />
                </template>
        </Dialog>


</template> 
<script>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2'
 


import InputText from 'primevue/inputtext';
    export default { 
        props: {
            dataPor: {
                type: Object,
                required: true
            }, 
            tab3Reload: {
                type: String,
                default: '0'
            } 
        },
        data() {
            return { 
                staffid_Main: null,
                year_Main: null,
                facid_Main: null,
                groupid_Main: null, 
                currentDate: new Date().toISOString().split('T')[0], 
/*=========== 1.ผลสัมฤทธิ์ของงาน =============*/                
            products_personP03: [], 
            itemsBtu: (item) => [
                {
                    label: 'รายงานการปฏิบัติราชการ',
                    icon: 'pi pi-sort-amount-down',
                    command: () => {
                        this.OpenDialogAdd(item);
                    }
                },
                {
                    label: '(หลักฐาน)รายงานการปฏิบัติราชการ',
                    icon: 'pi pi-file',
                    command: () => {
                        this.OpenDialogDoc(item);
                    }
                },
                //  {
                //     label: 'ระดับคะแนนประเมินตนเอง',
                //         icon: 'pi pi-thumbs-up',
                //         command: () => {
                //             this.OpenDialogScore(item);
                //         }
                // },
                {
                    label: 'ลบข้อมูล',
                    icon: 'pi pi-times',
                    command: () => {
                        this.delDataDoc(item);

                    }
                }
            ],
/*=========== 2.พฤติกรรมการปฏิบัติราชการ =============*/ 
                //ตาราง ก. สมรรถนะหลัก
           coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '', data_table1: '', selfAssessment: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '', data_table1: '', selfAssessment: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '', selfAssessment: '', data_table1: '', selfAssessment: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '', data_table1: '', selfAssessment: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '', data_table1: '', selfAssessment: '' }
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [],
                //{ id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
            //     { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
            //     { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
            //     { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
            //     { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
            //     { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
            // ],
            //ตาราง ค. สมรรถนะอื่นๆ
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator: '0', datatable3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator: '0', datatable3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0', datatable3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0', datatable3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0', datatable3: '' }
            ],
                posadio: 0,


/*============= รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน =============*/
                DialogAdd: false,
                list_no_p03: { name: '- เลือกระดับ -', value: 0 },
                list_no_p03s: [
                    { name: 'ระดับที่ 1', value: 1 },
                    { name: 'ระดับที่ 2', value: 2 },
                    { name: 'ระดับที่ 3', value: 3 },
                    { name: 'ระดับที่ 4', value: 4 },
                    { name: 'ระดับที่ 5', value: 5 },
                    // { name: 'ระดับที่ 6', value: 6 },
                    // { name: 'ระดับที่ 7', value: 7 },
                    // { name: 'ระดับที่ 8', value: 8 },
                    // { name: 'ระดับที่ 9', value: 9 },
                    // { name: 'ระดับที่ 10', value: 10 },
                    // { name: 'ระดับที่ 11', value: 11 },
                    // { name: 'ระดับที่ 12', value: 12 },
                    // { name: 'ระดับที่ 13', value: 13 },
                    // { name: 'ระดับที่ 14', value: 14 },
                    // { name: 'ระดับที่ 15', value: 15 },
                    // { name: 'ระดับที่ 16', value: 16 },
                    // { name: 'ระดับที่ 17', value: 17 },
                    // { name: 'ระดับที่ 18', value: 18 },
                    // { name: 'ระดับที่ 19', value: 19 },
                    // { name: 'ระดับที่ 20', value: 20 },
                    // { name: 'ระดับที่ 21', value: 21 },
                    // { name: 'ระดับที่ 22', value: 22 },
                    // { name: 'ระดับที่ 23', value: 23 },
                    // { name: 'ระดับที่ 24', value: 24 },
                    // { name: 'ระดับที่ 25', value: 25 },
                    // { name: 'ระดับที่ 26', value: 26 },
                    // { name: 'ระดับที่ 27', value: 27 },
                    // { name: 'ระดับที่ 28', value: 28 },
                    // { name: 'ระดับที่ 29', value: 29 },
                    // { name: 'ระดับที่ 30', value: 30 },
                    // { name: 'ระดับที่ 31', value: 31 },
                    // { name: 'ระดับที่ 32', value: 32 },
                    // { name: 'ระดับที่ 33', value: 33 },
                    // { name: 'ระดับที่ 34', value: 34 },
                    // { name: 'ระดับที่ 35', value: 35 },
                    // { name: 'ระดับที่ 36', value: 36 },
                    // { name: 'ระดับที่ 37', value: 37 },
                    // { name: 'ระดับที่ 38', value: 38 },
                    // { name: 'ระดับที่ 39', value: 39 },
                    // { name: 'ระดับที่ 40', value: 40 }, 
                ],
                text_edtP03: null,
                list_no_p03: null,
                list_text_p03: null,
                products_list_p03: [],
/*============= หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์) =============*/
                DialogDoc: false,
                text_edtDoc: null,
                radioValueDoc: { name: 'ไฟล์เอกสาร', value: 1 },
                radioValueDocs: [
                    { name: 'ไฟล์เอกสาร', value: 1 },
                    { name: 'ลิงค์เอกสาร', value: 2 }
                ],
                radioValue: null,
                doc_no: null,
                doc_name: null,
                doc_link: null,
                products_doc_p03: [],
                selectedFiles: [],
                base64Files: [] ,
/*============= ระดับการประเมินตนเอง (ค่าคะแนนที่ได้) =============*/
                DialogScore: false,
                text_edtP03Score: null,
                score_p03: null,
                score_p03s: [
                    { name: 'ค่าคะแนนที่ 1', value: 1 },
                    { name: 'ค่าคะแนนที่ 2', value: 2 },
                    { name: 'ค่าคะแนนที่ 3', value: 3 },
                    { name: 'ค่าคะแนนที่ 4', value: 4 },
                    { name: 'ค่าคะแนนที่ 5', value: 5 }
                ], 
/*============= ?? =============*/ 
                products_TabP03: [],  
/*============= ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา =============*/ 
                p04_re1: null,
                p04_re2: null,
                p04_re3: null,
                products_Tab3: [],  
                //แก้ไขรายงานปฏิบัติราชการ
                DialogEditListP03: false,
                text_search_noEditP03: null,
                text_search_idEditP03: null,
                text_searchEditP03: null,
                //แก้ไขชื่อไฟล์
                DialogEditFileP03: false,
                text_search_noEditFileP03: null,
                text_searchEditFileP03: null,
                text_docid: null,
                text_p01id: null, 

            }   
        }, 
        async mounted(){  
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession(); 
            //console.log(user.user.name); 
            const {STAFFID, SCOPES} = user.user.name
            const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
            await this.setSession(STAFFID,staffdepartment,groupid,user.user.name.POSTYPENAME,user.user.name.POSITIONNAMEID,user.user.name.POSITIONNAME);   
        }, 
        watch: { 
            tab3Reload(v) { 
                // console.log("por03 tab3Reload",v);
                this.showDataP03();   
            }, 
            // เฝ้าดูการเปลี่ยนแปลงของ dataPor
            dataPor: {
                handler(newVal, oldVal) {
                    // console.log('dataPor changed:', newVal);
                    this.showDataP03();
                    this.showdataPo();
                    this.chkp03data();
                    this.getjobSpecificCompetencies(); 
                    this.showAssess();
                    // ทำสิ่งที่ต้องการเมื่อ dataPor เปลี่ยนแปลง
                },
                deep: true // ใช้ deep: true เพื่อดูการเปลี่ยนแปลงภายใน object
            }
        },
        methods: { 
            setSession (staffid_Main,facid_Main,groupid_Main,postypename,postypenameid,positionname) { 
                this.staffid_Main = staffid_Main
                this.facid_Main = facid_Main
                this.groupid_Main = groupid_Main  
                this.postypename = postypename    
                this.postypenameid = postypenameid
                this.positionname = positionname   
                this.getAadioPosition(staffid_Main); 
                // console.log('setSession: ',staffid_Main,facid_Main,groupid_Main);  
            },
            async getAadioPosition(staffid_Main){
                // console.log('getAadioPosition: ',staffid_Main); 
                try {   
                    if(staffid_Main){
                        const res = await axios.get(' http://127.0.0.1:8000/api/getDataAdio', {  
                            params: {
                                staffid: staffid_Main
                            }
                        }); 
                        // console.log('getDataAdio: ',res.data);  
                        this.posadio = res.data[0].posadid
                    } 
                } catch (error) {
                    console.error('Error fetching evaluation data:', error);
                } 
            },
            // กรองเฉพาะตัวเลข
            validateNumericInput(index) { 
                const input = this.coreCompetencies[index].selfAssessment;
                this.coreCompetencies[index].selfAssessment = input.replace(/[^0-9]/g, ''); // Only allow numeric input
            },
            validateNumericInputR2(index) { 
                const input = this.jobSpecificCompetencies[index].selfAssessment;
                this.jobSpecificCompetencies[index].selfAssessment = input.replace(/[^0-9]/g, ''); // Only allow numeric input
            },
            // ดึงข้อมูลเข้าตาราง
            async showDataP03(){
                await axios.post('   http://127.0.0.1:8000/api/showDataP03New',{
                    staff_id: this.staffid_Main,
                    fac_id: this.dataPor.fac_id,
                    year_id: this.dataPor.d_date, 
                    evalua: this.dataPor.evalua 
                }).then(res => {
                   //console.log('showDataP03',res.data);
                    this.products_personP03=res.data;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            }, 
/*============= รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน =============*/
            // เปิดหน้าต่างสำหรับบันทึก P03
            OpenDialogAdd(item){ 
                // console.log(item); 
                this.DialogAdd = true;
                this.text_edtP03 = item.p01_id;
                this.list_no_p03 = null;
                this.list_text_p03 = null;
                this.products_list_p03 = [];
                axios.post('   http://127.0.0.1:8000/api/p03indData',{
                    p01_id: item.p01_id,
                }).then(res => {
                    // console.log(res.data); 
                    if(res.data.length > 0){
                        res.data.forEach(ind => {
                            this.products_list_p03.push({
                                p03ind_id: ind.p03ind_id,
                                p03ind_no: ind.p03ind_no,
                                p03ind_Items: ind.p03ind_Items
                            });
                        }); 
                        this.products_list_p03.sort((a, b) => a.p03ind_no - b.p03ind_no);  
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            },
            // เพิ่มรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            AddDatalist(){  

                if(this.list_no_p03.length === 0){ 
                    Swal.fire("ไม่มีข้อมูล","กรุณาตรวจสอบข้อมูล ลำดับ!","error"); 
                } else if(this.list_text_p03 == null){ 
                    Swal.fire("ไม่มีข้อมูล","กรุณาตรวจสอบข้อมูลชื่อตัวชี้วัด / เกณฑ์การประเมิน!","error");
                } else { 
                    this.products_list_p03.push({
                        p03ind_no: this.list_no_p03.value,
                        p03ind_Items: this.list_text_p03
                    }); 
                    
                    this.products_list_p03.sort((a, b) => a.p03ind_no - b.p03ind_no); 
                    this.list_text_p03 = null;
                } 
                
            }, 
            // ลบรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            DeleteRegislicklist(index){ 
                // console.log(data); 
                 //this.products_list_p03 = this.products_list_p03.filter(product => product.p03ind_no !== data.p03ind_no); 
                 this.products_list_p03.splice(index, 1); // ลบรายการจาก products_list_p03 ที่ตำแหน่ง index
            },
            // บันทึกรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            saveDataListP03() {   
                if(this.products_list_p03.length == 0){
                    Swal.fire("error","กรุณาตรวจสอบตารางข้อมูล ตัวชี้วัดการประเมิน!","error");
                }else{
                    axios.post('   http://127.0.0.1:8000/api/saveListP03', {
                        p_id: this.text_edtP03,
                        products_list: this.products_list_p03
                    })
                    .then((res) => {
                         console.log(res.data);  
                        Swal.fire({
                            title: "บันทึกสำเร็จ!",
                            text: "ข้อมูล ตัวชี้วัด/ เกณฑ์การประเมิน ถูกบันทึกเรียบร้อย!",
                            icon: "success"
                        });
                        this.DialogAdd = false;
                        this.showDataP03();
                    })
                    .catch((error) => {
                        console.error('Error:', error);
                    });
                }
            },
/*============= หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์) =============*/
            OpenDialogDoc(item){ 
                //console.log(item); 
                this.DialogDoc = true;
                this.text_edtDoc = item.p01_id; 
                this.radioValue = 'doc';
                this.doc_no = null;
                this.doc_name = null;
                this.doc_link = null;
                this.products_doc_p03 = []; 
                this.Data_Doc();
            }, 
            handleFileChange(event) {
                const files = event.target.files; // ไฟล์ที่ถูกเลือก
                const maxFileSize = 10 * 1024 * 1024; // ขนาดไฟล์สูงสุด 10 MB
                const validFiles = []; // สำหรับเก็บไฟล์ที่ผ่านการตรวจสอบ

                // วนลูปตรวจสอบไฟล์แต่ละไฟล์
                Array.from(files).forEach(file => {
                    if (file.size > maxFileSize) {
                        alert(`ไฟล์ ${file.name} ไฟล์มีขนาดเกิน 15 MB `); // แจ้งเตือนเมื่อไฟล์เกินขนาด
                    } else {
                        validFiles.push(file); // เก็บไฟล์ที่ผ่านเงื่อนไข
                    }
                });

                // เก็บเฉพาะไฟล์ที่ผ่านการตรวจสอบใน selectedFiles
                this.selectedFiles = validFiles;

                // แสดงไฟล์ที่ผ่านการอัปโหลดใน console
                console.log("ไฟล์ที่อัปโหลด:", this.selectedFiles);
            }, 
            // handleFileChange(event) {
            //     const files = event.target.files;
            //     this.selectedFiles = Array.from(files);
            // },
            add_data_file(file){
                return new Promise((resolve, reject) => {
                    const reader = new FileReader();
                    reader.readAsDataURL(file);
                    reader.onload = function () {
                        const base64String = reader.result.split(',')[1]; // Remove data URL prefix
                        const extension = file.name.split('.').pop(); // Extract file extension 
                        resolve({ filedata: base64String, filename: file.name, filex: extension });
                    };
                    reader.onerror = function (error) {
                        console.error('Error reading file: ', error);
                        reject(error);
                    };
                });
            }, 
            async saveDataDoc() {
                const file = this.selectedFiles[0];
                //console.log(file);
                try {
                    if (this.radioValue === 'doc') {
                        if (!this.doc_no) {
                            Swal.fire("error", "กรุณากรอก ลำดับ!", "error");
                        } else if (!this.doc_name) {
                            Swal.fire("error", "กรุณากรอก ชื่อไฟล์!", "error");
                        } else if (!file) {
                            Swal.fire("error", "กรุณาเลือกไฟล์แนบ!", "error");
                        } else {
                            const fileData = await this.add_data_file(file);
                            const formData = new FormData();
                            formData.append("text_edtDoc", this.text_edtDoc);
                            formData.append("doc_type", this.radioValue);
                            formData.append("doc_no", this.doc_no);
                            formData.append("doc_name", this.doc_name);
                            formData.append("file", JSON.stringify(fileData));

                            const instance_x = axios.create({
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                }
                            });

                            instance_x.post('   http://127.0.0.1:8000/api/saveDocP03', formData)
                                .then(res => {
                                    this.showDataP03();
                                    this.Data_Doc();
                                    this.resetFormFields();  // รีเซ็ตฟิลด์หลังจากบันทึกสำเร็จ
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }
                    } else if (this.radioValue === 'link') {
                        if (!this.doc_no) {
                            Swal.fire("error", "กรุณากรอก ลำดับ!", "error");
                        } else if (!this.doc_name) {
                            Swal.fire("error", "กรุณากรอก ชื่อไฟล์!", "error");
                        } else if (!this.doc_link) {
                            Swal.fire("error", "กรุณากรอกข้อมูล แนบลิงค์เอกสาร!", "error");
                        } else {
                            const formData = new FormData();
                            formData.append("text_edtDoc", this.text_edtDoc);
                            formData.append("doc_type", this.radioValue);
                            formData.append("doc_no", this.doc_no);
                            formData.append("doc_name", this.doc_name);
                            formData.append("doc_link", this.doc_link);

                            const instance_x = axios.create({
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                }
                            });

                            instance_x.post('   http://127.0.0.1:8000/api/saveDocP03', formData)
                                .then(res => {
                                    this.showDataP03();
                                    this.Data_Doc();
                                    this.resetFormFields();  // รีเซ็ตฟิลด์หลังจากบันทึกสำเร็จ
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }
                    } else {
                        Swal.fire("error", "กรุณาตรวจสอบ ประเภทการแนปเอกสาร!", "error");
                    }
                } catch (error) {
                    console.error('Error processing file:', error);
                }
            },
            resetFormFields() {
                this.radioValue = 'doc';
                this.doc_no = null;
                this.doc_name = null;
                this.doc_link = null;
                this.selectedFiles = [];  // เคลียร์ selected files
                this.$refs.upload.value = '';  // รีเซ็ตฟิลด์อัปโหลดไฟล์
            },

            Data_Doc(){
                axios.post('   http://127.0.0.1:8000/api/sheachDataDoc', {
                    p_id: this.text_edtDoc
                })
                .then((res) => {
                    // console.log(res.data);  
                    this.products_doc_p03 = res.data;
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
            },
             // หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์)
            delDataDocX(data){  
                axios.post('   http://127.0.0.1:8000/api/deleteDocP03', {
                    doc_id: data.doc_id, 
                    doc_file: data.doc_file??null
                })
                .then((res) => {  
                    this.products_doc_p03 = this.products_doc_p03.filter(item => item.doc_id !== data.doc_id);
                    Swal.fire("success","ลบข้อมูลสำเร็จ!","success");
                    this.showDataP03();
                })
                .catch((error) => {
                    // console.error('Error:', error);
                    Swal.fire("error","เกิดข้อผิดพลาดในการลบข้อมูล!","error");
                }); 
            },
            // ลบรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            async delDataDoc(data) {        
            Swal.fire({
                title: "คุณต้องการลบแบบ ป03 ใช่หรือไม่ ?",
                text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Yes, delete it!"
            }).then((result) => {
                if (result.isConfirmed) {
                    axios.post('   http://127.0.0.1:8000/api/delDocP03', {
                        p01_id: data.p01_id
                    }).then(res => { 
                        this.showDataP03();
                        this.Data_Doc();
                        this.radioValue = 'doc';
                        this.doc_no = null;
                        this.doc_name = null;
                        this.doc_link = null;
                        this.$refs.upload.value = null;

                        Swal.fire({
                            title: "ลบข้อมูลเสร็จสิ้น!",
                            text: "ข้อมูลของคุณถูกลบแล้ว",
                            icon: "success"
                        });
                    }).catch(error => {
                        console.error('Error:', error);
                    }); 
                }
            }); 
            },
            async mounted() {
                const  { signIn, getSession, signOut } = await useAuth()
                const user = await getSession();
            }, 
/*============= ค่าคะแนนที่ได้ =============*/
            OpenDialogScore(item){ 
                // console.log(item); 
                this.DialogScore = true;
                this.text_edtP03Score = item.p01_id;;
                this.score_p03 = null; 
                axios.post('   http://127.0.0.1:8000/api/p03ScoreData',{
                    p01_id: item.p01_id,
                }).then(res => {
                    // console.log(res.data); 
                    if(res.data.length > 0){
                        const score = this.score_p03s.filter(f=>f.value==res.data[0].p01_score)
                        this.score_p03 = score.length > 0 ? score[0] : null;     
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            }, 
            saveDataScoreP03() {    
                if(this.score_p03.length == 0){
                    Swal.fire("error","กรุณาตรวจสอบข้อมูล ระดับการประเมินตนเอง!","error");
                }else{
                    axios.post('   http://127.0.0.1:8000/api/saveScoreP03', {
                        p_id: this.text_edtP03Score,
                        score_p03: this.score_p03.value
                    })
                    .then((res) => {
                        // console.log(res.data);  
                        Swal.fire({
                            title: "บันทึกสำเร็จ!",
                            text: "ข้อมูล ระดับการประเมินตนเอง ถูกบันทึกเรียบร้อย!",
                            icon: "success"
                        });
                        this.DialogScore = false;
                        this.showDataP03();
                    })
                    .catch((error) => {
                        console.error('Error:', error);
                    });
                }
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
                    } else {
                        console.warn(`Missing data for p${i+6}`);
                    }
                }
                for (let i = 0; i < this.otherCompetencies.length; i++) { // แก้ไขเงื่อนไขที่นี่
                    // ตรวจสอบว่า `res.data[0][`p${i+6}`]` มีค่าก่อนตั้งค่า
                    if (res.data[0] && res.data[0][`pSE_${i+1}`] !== undefined) {
                        this.otherCompetencies[i]['selfAssessment3'] = res.data[0][`pSE_${i+1}`]; 
                    } else {
                        console.warn(`Missing data for p${i+6}`);
                    }
                }
                
                // console.log('Response', res.data);
            })
            }, 
            showdataPo(){  
                 //console.log('positionname: ',this.positionname);

                 // Biw 7/8/68 อันเก่า ก่อนเปลี่ยน 
                // let postypetext = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;
                // let postypenameid = this.positionname === 'ผู้บริหาร' ? 90 : this.postypenameid;
                // let positionname = this.positionname === 'ผู้บริหาร' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;


                let postypetext = this.posadio === '128' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;
                let postypenameid = this.posadio === '128' ? 90 : this.postypenameid;
                let positionname = this.posadio === '128' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;

                 // 👇 ยกเว้น staffid 110105 → กลับไปใช้เงื่อนไขปกติ
                if (String(this.staffid_Main) === '110105') {
                    postypetext   = `ระดับ${this.postypename}`;
                    postypenameid = this.postypenameid;
                    positionname  = `ระดับ${this.postypename}`;
                }

                // console.log('postypetext: ',postypetext);
                // console.log('postypenameid: ',postypenameid);
                
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

                // ตั้งค่า coreCompetencies กลับไปเป็นค่าเริ่มต้น
                this.coreCompetencies = [
                    { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: xr, data_table1: '',selfAssessment:'' },
                    { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: xr, data_table1: '',selfAssessment:''  },
                    { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: xr, data_table1: '',selfAssessment:''  },
                    { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: xr, data_table1: '',selfAssessment:''  },
                    { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: xr, data_table1: '',selfAssessment:''  }
                ];   
                this.jobSpecificCompetencies = []; 
                    // jobSpecificCompetencies: [
                    //     { id: 6, activity: 'ข. 1 การคิดวิเคราะห์12', indicator: '0', data_table2: '' },
                    //     { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก111', indicator: '0', data_table2: '' },
                    //     { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ111', indicator: '0', data_table2: '' },
                    //     { id: 9, activity: 'ข. 4 การมองภาพองค์รวม222', indicator: '0', data_table2: '' },
                    //     { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล2222', indicator: '0', data_table2: '' },
                    //     { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน122222', indicator: '0', data_table2: '' }
                    // ], 
                    // ปรับ Mapping ให้ใช้ this.positionname แทน postypetext


                    // Biw 7/8/68 อันเก่า ก่อนเปลี่ยน
                    // const Mapping = {
                    //     'ผู้บริหาร': 1
                    // };  
                    // let executive = Mapping[this.positionname] || 0;

                    //160968บิว
                    //  const Mapping = {
                    //     '128': 1
                    // };  
                    // let executive = Mapping[this.posadio] || 0;
                    const Mapping = { '128': 1 };
                    let executive = Mapping[this.posadio] || 0;

                        // 👇 ยกเว้น staffid 110105 → ไม่ให้เป็น executive
                        if (String(this.staffid_Main) === '110105') {
                            executive = 0;
                    }


                    // console.log('executive:', executive); 
                    // ตั้งค่า otherCompetencies
                    this.otherCompetencies = [
                        { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                        { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
                        { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                        { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
                        { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
                    ];
                //console.log(this.coreCompetencies);
                
                
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
                var postypetext = postypename;
                axios.post('   http://127.0.0.1:8000/api/showdatapostypenameAdmin', {
                    postypename: postypetext,
                    postypenameid: postypenameid
                })
                .then(res => {
                    // console.log('Response',res.data);  
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
                    this.assessorText = res.data[0].assessor; 
                    this.assessor_positionText = res.data[0].assessor_position;
                    this.showscoresum = res.data[0] 
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                });
            } ,
/*============= ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา =============*/ 
            chkp03data(){ 
                this.products_Tab3 = [];
                axios.post('   http://127.0.0.1:8000/api/showData04Tab3',{
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    year_id: this.dataPor.d_date,
                    record: this.dataPor.evalua, 
                }).then(res => {     
                    // console.log('chkp03data',res.data);     
                    if(res.data.length > 0){
                        res.data.forEach(p04 => {
                            const newData = {
                                p04_re1: p04.p04_re1,
                                p04_re2: p04.p04_re2,
                                p04_re3: p04.p04_re3,
                                id:p04.p02_id
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
            AddDatap04(){ 
                axios.post('   http://127.0.0.1:8000/api/saveEvaTab03xx',{
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    year_id: this.dataPor.d_date,
                    record: this.dataPor.evalua,
                    p04_re1: this.p04_re1,
                    p04_re2: this.p04_re2,
                    p04_re3: this.p04_re3
                }).then(res => {     
                    // console.log(res.data);    
                    const newData = {
                        p04_re1: this.p04_re1,
                        p04_re2: this.p04_re2,
                        p04_re3: this.p04_re3,
                        id: res.data
                    };
                    this.products_Tab3.push(newData); 
                    this.p04_re1 = '';
                    this.p04_re2 = '';
                    this.p04_re3 = '';

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
            DeleteRegislick(item) { 
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
            async saveAssess() {
                try {
                    const response = await axios.post('   http://127.0.0.1:8000/api/savedataAssess', { 
                        p_staffid: this.staffid_Main,
                        fac_id: this.facid_Main,
                        p_year: this.dataPor.d_date,
                        evalua: this.dataPor.evalua, 
                        corecompetencies: this.coreCompetencies,
                        jobspecificcompetencies: this.jobSpecificCompetencies,
                        otherCompetencies:this.otherCompetencies, 
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
            showAssess( ) {
                axios .post('   http://127.0.0.1:8000/api/showdataAssess', { 
                    staff_id:this.staffid_Main,
                    fac_id: this.facid_Main,
                    year: this.dataPor.d_date,
                    record: this.dataPor.evalua, 
                    coreCompetencies: this.coreCompetencies,
                    jobSpecificCompetencies: this.jobSpecificCompetencies,
                    otherCompetencies:this.otherCompetencies,   
                })
                .then((res) => {
                    //console.log(res.data);
                    if (res.data.length > 0) {
                        const data = res.data[0];
                        this.coreCompetencies.forEach((item) => {
                            if (item.id === 1) {
                                item.selfAssessment = data.pa_1 ?? 0;  
                            } else if (item.id === 2) {
                                item.selfAssessment = data.pa_2 ?? 0;  
                            } else if (item.id === 3) {
                                item.selfAssessment = data.pa_3 ?? 0;  
                            } else if (item.id === 4) {
                                item.selfAssessment = data.pa_4 ?? 0;  
                            } else if (item.id === 5) {
                                item.selfAssessment = data.pa_5 ?? 0;  
                            }
                        });

                        this.jobSpecificCompetencies.forEach((item) => {
                            if (item.id === 6) {
                                item.selfAssessment = data.pa_6 ?? 0;  
                            } else if (item.id === 7) {
                                item.selfAssessment = data.pa_7 ?? 0;  
                            } else if (item.id === 8) {
                                item.selfAssessment = data.pa_8 ?? 0;  
                            } else if (item.id === 9) {
                                item.selfAssessment = data.pa_9 ?? 0;  
                            } else if (item.id === 10) {
                                item.selfAssessment = data.pa_10 ?? 0;  
                            } else if (item.id === 11) {
                                item.selfAssessment = data.pa_11 ?? 0;  
                            }
                        });
                        this.otherCompetencies.forEach((item) => {
                            if (item.id === 1) {
                                item.datatable3 = data.px_1 ?? 0;  
                            } else if (item.id === 7) {
                                item.datatable3 = data.px_2 ?? 0;  
                            } else if (item.id === 8) {
                                item.datatable3 = data.px_3 ?? 0;  
                            } else if (item.id === 9) {
                                item.datatable3 = data.px_4 ?? 0;  
                            } else if (item.id === 10) {
                                item.datatable3 = data.px_5 ?? 0;    
                            }
                        });

                        // Update other fields
                        this.improvements = data.improvements ?? '- ไม่มีข้อมูล -';
                        this.suggestions = data.suggestions ?? '- ไม่มีข้อมูล -';
                    }
                        for (let i = 0; i < this.jobSpecificCompetencies.length; i++) { // แก้ไขเงื่อนไขที่นี่
                        // ตรวจสอบว่า `res.data[0][`p${i+6}`]` มีค่าก่อนตั้งค่า
                        if (res.data[0] && res.data[0][`pa_${i+6}`] !== undefined) {
                            this.jobSpecificCompetencies[i]['selfAssessment'] = res.data[0][`pa_${i+6}`]; 
                        } else {
                            console.warn(`Missing data for pa_${i+6}`);
                        }
                        
                    }
                    for (let i = 0; i < this.otherCompetencies.length; i++) { // แก้ไขเงื่อนไขที่นี่
                        // ตรวจสอบว่า `res.data[0][`p${i+6}`]` มีค่าก่อนตั้งค่า
                        if (res.data[0] && res.data[0][`px_${i+1}`] !== undefined) {
                            this.otherCompetencies[i]['datatable3'] = res.data[0][`px_${i+1}`]; 
                        } else {
                            console.warn(`Missing data for px_${i+1}`);
                        }
                        
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                }); 
            }, 
            async printDataP03() { 
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
                    postypename: `ระดับ${this.postypename}`   
                } 
                const queryParams = new URLSearchParams(form).toString();
                // console.log(queryParams); 
                const url = `   http://127.0.0.1:8000/report_p03?${queryParams}`;
                window.open(url, '_blank'); 
            },  
            
            
             // แก้ไขตัวชี้วัด / เกณฑ์การประเมิน
            EditRegislickP03(data){
                //console.log(data);
                this.text_search_idEditP03 = null;
                this.text_search_noEditP03 = null;
                this.text_searchEditP03 = null;
                if(data){
                    this.DialogEditListP03 = true; 
                    this.text_search_idEditP03 = data.p03ind_id;
                    this.text_search_noEditP03 = data.p03ind_no;
                    this.text_searchEditP03 = data.p03ind_Items;
                } 
            },
            cancelDialogEdiP03(){ 
                this.DialogEditListP03 = false;  
            }, 
            saveDataxEditP03(){ 
                // console.log({
                //     text_search_noEditP03: this.text_search_noEditP03,
                //     text_searchEditP03: this.text_searchEditP03
                // });

                // สมมติว่าเรามีฟังก์ชันสำหรับอัพเดตข้อมูลใน array
                let updatedItem = {
                    p03ind_id: this.text_search_idEditP03,
                    p03ind_no: this.text_search_noEditP03,
                    p03ind_Items: this.text_searchEditP03
                };

                // ค้นหาข้อมูลที่ต้องการแก้ไขใน products_list และอัพเดต
                const index = this.products_list_p03.findIndex(item => item.p03ind_id === this.text_search_idEditP03);
                //console.log(index);
                
                if (index !== -1) {
                    this.products_list_p03[index] = updatedItem;
                }

                // ปิด Dialog หลังบันทึกข้อมูล
                this.DialogEditListP03 = false;  
            },


            //// แก้ไขหลักฐานเชิงประจัก เฉพาะชื่อไฟล์ 

            EditDataDocFilename(data){
                // console.log(data);
                this.text_docid = null;
                this.text_p01id = null; 
                this.text_search_noEditFileP03 = null;
                this.text_searchEditFileP03 = null;
                if(data){ 
                    this.DialogEditFileP03 = true; 
                    this.text_docid = data.doc_id;
                    this.text_p01id = data.p01_id; 
                    this.text_search_noEditFileP03 = data.doc_no;
                    this.text_searchEditFileP03 = data.doc_name;
                } 
            }, 
            cancelDialogEditFileP03(){ 
                this.DialogEditFileP03 = false;  
            }, 
            // saveDataxEditFileP03(){ 
            //     console.log({
            //         text_search_noEditFileP03: this.text_search_noEditFileP03,
            //         text_searchEditFileP03: this.text_searchEditFileP03
            //     });

            //     // สมมติว่าเรามีฟังก์ชันสำหรับอัพเดตข้อมูลใน array
            //     let updatedItem = {
            //         doc_no: this.text_search_noEditFileP03,
            //         doc_name: this.text_searchEditFileP03
            //     };

            //     // ค้นหาข้อมูลที่ต้องการแก้ไขใน products_list และอัพเดต
            //     const index = this.products_doc_p03.findIndex(item => item.doc_no === this.text_search_noEditFileP03);
            //     console.log(index);
                
            //     if (index !== -1) {
            //         this.products_doc_p03[index] = updatedItem;
            //     }

            //     // ปิด Dialog หลังบันทึกข้อมูล
            //     this.DialogEditFileP03 = false;  
            // },
            saveDataxEditFileP03() {
                // console.log({
                //     text_docid: this.text_docid,
                //     text_p01id: this.text_p01id, 
                //     text_search_noEditFileP03: this.text_search_noEditFileP03,
                //     text_searchEditFileP03: this.text_searchEditFileP03
                // }); 
                axios.post('   http://127.0.0.1:8000/api/edtDataTitalFile', {
                    doc_id: this.text_docid, 
                    p01_id: this.text_p01id, 
                    doc_no: this.text_search_noEditFileP03, 
                    doc_name: this.text_searchEditFileP03, 
                })
                .then((res) => {
                    // console.log(res.data);   
                    this.DialogEditFileP03 = false;
                    this.Data_Doc(); 
                    this.showDataP03();
                })
                .catch((error) => {
                    console.error('Error:', error);
                }); 
            }

        },
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
    .field-container {
    display: flex;
    justify-content: space-between;
    }

    .field {
    flex: 1;
    margin-right: 10px;
    }
    th {
    background-color: #f1e989;
    color: rgb(5, 5, 5);
    }

    .h, td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
    }
 

    table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
  }

  th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: center;
    vertical-align: middle;
  }

  th {
    background-color: #edf2bb;
    font-weight: bold;
  }​
  

  td {
    text-align: center;
  }

  /* ให้ขนาดตารางแต่ละส่วนเท่ากัน */
  table#ratingTable {
    table-layout: fixed;
  }

  table#ratingTable th,
  table#ratingTable td {
    width: 33.33%; /* แบ่งแต่ละคอลัมน์เป็น 1/3 */
  }

  /* จัดการให้แต่ละส่วนมีระยะห่างเท่ากัน */
  table + table {
    margin-top: 20px;
  }
  .custom-textarea {
    width: 100%;
    max-width: 600px;
    padding: 10px;
    border-radius: 5px;
    border: 1px solid #ccc;
    font-size: 1rem;
    }

    .field {
        margin-bottom: 20px;
    }

    .button-container {
        text-align: center;
    }

    .p-button {
        margin: 10px 0;
    }
  
    </style>
