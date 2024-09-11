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
                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" optionValue="code" placeholder="เลือกปีงบประมาณ" style="width: 60%;"></Dropdown> 
                    </div>  
                    <div class="col md:col-4"> 
                        <label for="year_text">รอบประเมิน: </label> 
                        <Dropdown id="evaluation_text" v-model="dropdownItemRecord" :options="dropdownItemRecords" optionLabel="name" placeholder="รอบประเมิน" style="width: 70%;"></Dropdown> 
                    </div>   
                </div>   
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: blanchedalmond;">
                            <th>ชื่อ - สกุล</th>  
                            <th>ตำแหน่ง</th>  
                            <th>รอบการประเมิน</th>  
                            <th>คะแนน</th>  
                            <th>ผู้ประเมิน</th>  
                            <th>ตัวเลือก</th>
                              
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in products" :key="index">
                            <td style="padding-left: 5px;width: 20%;">
                                <b style="color: blue;">{{ Item.prefixfullname }} {{ Item.namefully }} </b>
                                <!-- <Tag v-if="Item.countchk==2 " severity="success" style="font-size: larger;">อนุมัติ</Tag>
                                <Tag v-if="Item.countchk==3 " severity="danger" style="font-size: larger;">ไม่ผ่าน</Tag>  -->
                            </td>

                            <td style="padding-left: 5px;width: 20%;"><b>{{ Item.posnameth }}</b></td>
                            <td style="padding-left: 5px;width: 20%;"><b>{{ }}</b></td>
                            <td style="padding-left: 5px;width: 20%;"><b>{{ }}</b></td>

                            <td style="text-align: center;width: 10%;">   
                                <!-- <div v-if="Item.countchk!=''">
                                    <Button icon="pi pi-check" label="อนุมัติ" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,2)" />
                                    <Button icon="pi pi-times" severity="danger" label="ไม่ผ่าน" rounded class="mb-2 mr-2" @click="Btnstatus(Item.staffid,3)"  /> 
                                </div>
                                <div v-if="Item.countchk==''">
                                    <Button icon="pi pi-bookmark" severity="secondary" label="ไม่มีข้อมูล" rounded class="mb-2 mr-2"/>
                                </div>  -->
                            </td>

                            <td style="text-align: center;width: 10%;">
                                <Button severity="info" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>

                        </tr> 
                    </tbody>
                </table>
                <div class="col md:col-5 text-right">   
                    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                        <template v-slot:header>
                            <h3>รายงานแบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference: TOR)</h3>
                        </template>
                                <TabView>
                                    <TabPanel header="แบบใบปะหน้า">
                                        <h3 class="mb-4" style="text-align: right;">
                                        <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01-02
                                        </h3>
                                        <div class="card">
                                        <div style="display: flex; justify-content: center;">
                                            <img src="~/assets/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
                                        </div>
                                        <h4 style="text-align: center;">
                                            แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Refernce : TOR)ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม
                                        </h4>
                                        <br>
                                        <div class="employee-info">
                                            <p><strong>ผู้ปฏิบัติงาน:</strong> นาย พิพัฒน์พงษ์ เพริดพราว</p>
                                            <p><strong>สังกัด:</strong> กองแผนงาน</p>
                                            <p><strong>ตำแหน่ง:</strong> นักวิชาการคอมพิวเตอร์</p>
                                            <p><strong>ประเภทตำแหน่ง:</strong> ปฏิบัติการ</p>
                                            <p><strong>คุณวุฒิ:</strong> ปริญญาตรี</p>
                                            <p><strong>ประเภทบุคลากร:</strong> พนักงานมหาวิทยาลัย</p>
                                            <p><strong>รายละเอียดข้อตกลง:</strong> ระหว่าง วันที่ 1 มี.ค. 2567 ถึง วันที่ 31 ส.ค. 2567</p>
                                        </div>
                                        <div class="explanation">
                                            <h4>คำชี้แจง</h4>
                                            <p>
                                            1. แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามนี้ 
                                            เป็นการกำหนด แผนการปฏิบัติงานของผู้ปฏิบัติงานในมหาวิทยาลัยมหาสารคาม ซึ่งเป็นข้อตกลงร่วมกับผู้บังคับบัญชาก่อนเริ่มปฏิบัติงาน
                                            </p>
                                            <p>
                                            2. การกำหนดข้อตกลงร่วม ผู้ปฏิบัติงานจะต้องกรอกรายละเอียดภาระงานโดยสังเขปในส่วนของภาระงานตามหน้าที่ความรับผิดชอบของตำแหน่ง และ/หรือภาระงาน ด้านอื่นๆ 
                                            พร้อมกำหนดตัวชี้วัดความสำเร็จของภาระงานแต่ละรายการ ตลอดจนค่าเป้าหมาย และค่านำหนักร้อยละ สำหรับในส่วนของพฤติกรรมการปฏิบัติราชการ (สมรรถนะ) ให้ระบุระดับสมรรถนะค่ามาตรฐาน
                                            </p>
                                            <p>
                                            3. สำหรับการกรอกรายละเอียดภาระงานตามภารกิจ ให้อ้างอิงการคำนวณภาระงานขั้นต่ำตามหลักเกณฑ์กรอบมาตรฐานภาระงานที่แนบท้ายประกาศ ก.บ.ม  
                                            มหาวิทยาลัยมหาสารคาม ที่บังคับใช้สำหรับการประเมินผลการปฏิบัติราชการ
                                            </p>
                                            <p>
                                            4. การกำหนดตัวชี้วัดความสำเร็จของงาน ทั้งในส่วนของเชิงปริมาณและเชิงคุณภาพ ให้เป็นการกำหนดข้อตกลงภายในหน่วยงานนั้นๆ
                                            </p>
                                            <p>
                                            5. จัดทำข้อตกลงภาระงานดังกล่าวนี้ เพื่อใช้เป็นกรอบในการประเมินผลการปฏิบัติราชการ เพื่อประกอบการเลื่อนเงินเดือนแล ะค่าจ้างในแต่ละรอบการประเมิน
                                            </p>
                                        </div>
                                        </div>
                                    </TabPanel>

                                    <TabPanel header="แบบ ป01">
                                        <div class="grid">
                                            <div class="col-12 lg:col-12 xl:col-12">
                                                <div class="card mb-0">
                                                    <div class="formgroup-inline mb-1">
                                                        <div class="col md:col-4">
                                                            <h3 class="mb-4 card-header">
                                                                <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป01
                                                            </h3>
                                                        </div>
                                                        <div class="col md:col-12 text-right">
                                                            <label for="dropdownItemYear">ปีงบประมาณ :</label>
                                                            <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                                                        </div>
                                                    </div>
                                                    <!-- แสดงข้อมูลบันทึก -->
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                                                                <th rowspan="2" style="width: 24%;">
                                                                (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                                                                (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                                                                </th>
                                                                <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                                                                <th rowspan="2" style="width: 8%;">(4) <br> ค่าคะแนน ที่ได้</th>
                                                                <th rowspan="2" style="width: 14%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                                                                <th rowspan="2" style="width: 14%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
                                                                <!-- <th rowspan="2" style="width: 9%;"><br> ตัวเลือก <br></th> -->
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
                                                            <template v-for="(h, ind) in products_personX" :key="ind">  
                                                                <tr>
                                                                    <td style="text-align: left;" colspan="8">
                                                                        <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b>
                                                                    </td>
                                                                    <td class="text-center" style="color: blue;"><b>{{ h.h_weight }}%</b></td> 
                                                                    <!-- <td></td> -->
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
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.p01_target==1">&#10003;</b> 
                                                                        <b v-if="subP01.p01_target!=1"></b> 
                                                                    </td>
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.p01_target==2">&#10003;</b> 
                                                                        <b v-if="subP01.p01_target!=2"></b> 
                                                                    </td>
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.p01_target==3">&#10003;</b> 
                                                                        <b v-if="subP01.p01_target!=3"></b> 
                                                                    </td>
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.p01_target==4">&#10003;</b> 
                                                                        <b v-if="subP01.p01_target!=4"></b> 
                                                                    </td>  
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.p01_target==5">&#10003;</b> 
                                                                        <b v-if="subP01.p01_target!=5"></b> 
                                                                    </td>
                                                                    <td class="text-center">{{ subP01.p01_score }}</td>
                                                                    <td class="text-center">{{ subP01.p01_weight }}%</td> 
                                                                    <td class="text-center">{{ (subP01.p01_score * subP01.p01_weight / 100).toFixed(2) }}</td>
                                                                    
                                                                    <!-- <td class="text-center">
                                                                        <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                                                    </td>  -->
                                                                </tr>  
                                                            </template>
                                                        </tbody>
                                                    </table>   
                                                </div> 
                                            </div> 
                                        </div> 
                                        <div class="bordered-box">
                                            <div class="content">
                                                <p>(9) ผู้ประเมินและผู้รับการประเมินได้ตกลงร่วมกันและเห็นพ้องกันแล้ว (ระบุข้อมูลใน (1) (2) (3) และ (5) ให้ครบ)         จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อจัดทำข้อตกลง)</p>
                                                    <div class="signatures"><div>
                                                        <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                                                        <p>()</p>
                                                        <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                        </div>
                                                    <div>
                                                        <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                                                        <p>()</p>
                                                        <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="bordered-box">
                                            <div class="content">
                                                <p>(10) ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</p>
                                                <p>1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</p>
                                                <p>----</p>
                                                <p>2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</p>
                                                <p>-----</p>
                                                <p>(11) ผู้ประเมินและผู้รับการประเมินได้เห็นชอบผลการประเมินแล้ว (ระบุข้อมูลใน (4) (6) (7) (8) และ (10) ให้ครบ) จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อสิ้นรอบการประเมิน)</p>
                                            <div class="signatures"><div>
                                                <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                                                <p>()</p>
                                                <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                </div>
                                            <div>
                                                <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                                                <p>()</p>
                                                <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                </div>
                                            </div>
                                            </div>
                                        </div>
                                    </TabPanel>

                                    <TabPanel header="แบบ ป02">
                                        <div class="card">
                                            <h3 class="mb-4" style="text-align: right;">
                                            <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป02
                                            </h3>
                                            <h4>ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 2)</h4>
                                            <div class="card">
                                            <!-- <h3 class="mb-4" style="text-align: left;"><i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป02</h3> -->
                                            <!-- ตาราง ก. สมรรถนะหลัก -->
                                            <table id="ratingTable">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="4">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                                                        <th rowspan="4">(1) ระดับสมรรถนะที่คาดหวัง</th>
                                                        <th rowspan="4">(2) ระดับสมรรถนะที่แสดงออก</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="(row, index) in coreCompetencies" :key="index">
                                                        <td>
                                                            <div style="text-align: left;">{{ row.activity }}</div>
                                                            <!-- <i class="far fa-edit edit-icon" @click="editRow('core', index)" title="แก้ไข"></i>
                                                            <i class="fas fa-trash-alt delete-icon" @click="deleteRow('core', index)" title="ลบ"></i> -->
                                                        </td>
                                                        <td>{{ row.indicator }}</td>
                                                        <td>{{ row.report }}</td>
                                                        <td>
                                                            <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'core'">
                                                                <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                                                                <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                                                                <label for="file">เลือกไฟล์:</label>
                                                                <input type="file" @change="handleFileUpload"><br><br>
                                                                <button class="save-button" @click="addRow('core')">บันทึก</button>
                                                                <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                            <!-- ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ -->
                                            <table id="ratingTable">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="4">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                                                        <th rowspan="4">(3) ระดับสมรรถนะที่คาดหวัง</th>
                                                        <th rowspan="4">(4) ระดับสมรรถนะที่แสดงออก</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="(row, index) in jobSpecificCompetencies" :key="index">
                                                        <td>
                                                            <div style="text-align: left;">{{ row.activity }}</div>
                                                            <!-- <i class="far fa-edit edit-icon" @click="editRow('job', index)" title="แก้ไข"></i>
                                                            <i class="fas fa-trash-alt delete-icon" @click="deleteRow('job', index)" title="ลบ"></i> -->
                                                        </td>
                                                        <td>{{ row.indicator }}</td>
                                                        <td>{{ row.report }}</td>
                                                        <td>
                                                            <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'job'">
                                                                <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                                                                <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                                                                <label for="file">เลือกไฟล์:</label>
                                                                <input type="file" @change="handleFileUpload"><br><br>
                                                                <button class="save-button" @click="addRow('job')">บันทึก</button>
                                                                <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            
                                            <!-- ตาราง ค. สมรรถนะอื่นๆ -->
                                            <table id="ratingTable">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="4">ค. สมรรถนะทางการบริหาร(สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                                                        <th rowspan="4">(5) ระดับสมรรถนะที่คาดหวัง</th>
                                                        <th rowspan="4">(6) ระดับสมรรถนะที่แสดงออก</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr v-for="(row, index) in otherCompetencies" :key="index">
                                                        <td>
                                                            <div style="text-align: left;">{{ row.activity }}</div>
                                                            <!-- <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                                                            <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i> -->
                                                        </td>
                                                        <td>{{ row.indicator }}</td>
                                                        <td>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div>
                                                <h4 class="mb-4"><i class="" style="font-size: x-large;"></i> เกณฑ์การประเมิน</h4>
                                            </div>
                                            <table border="1" cellspacing="0" cellpadding="5" style="width: 100%; border-collapse: collapse; text-align: center;">
                                                <thead style="background-color: #f9c331;">
                                                <tr>
                                                    <th rowspan="2" style="width: 60%; text-align: left;">เกณฑ์การประเมิน</th>
                                                    <th colspan="3">(7) การประเมิน</th>
                                                </tr>
                                                <tr>
                                                    <th>จำนวนสมรรถนะ</th>
                                                    <th>คูณด้วย</th>
                                                    <th>คะแนน</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <tr v-for="(item, index) in rows" :key="index">
                                                    <td style="text-align: left;">{{ item.description }}</td>
                                                    <td>{{ item.quantity }}</td>
                                                    <td>{{ item.multiplier }}</td>
                                                    <td>{{ item.score }}</td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" style="text-align: right">
                                                    (8) ผลรวมคะแนน = <strong>{{ totalScore }}</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="3" style="text-align: right">
                                                    (9) สรุปคะแนนส่วนพฤติกรรมการปฏิบัติราชการ   (สมรรถนะ) = <strong style="text-decoration: underline;">ผลรวมคะแนน ใน (8)÷จำนวนสมรรถนะที่ใช้ในการประเมิน X 3 คะแนน</strong> <strong>{{ averageScore }}</strong>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                           
                                            <div class="bordered-box">
                                                    <div class="content">
                                                    <p>(10) ผู้ประเมินและผู้รับการประเมินได้ตกลงร่วมกันและเห็นพ้องกันแล้ว (ระบุข้อมูลใน (1) (2) (3) และ (5) ให้ครบ)         จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อจัดทำข้อตกลง)</p>
                                                        <div class="signatures"><div>
                                                        <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                                                        <p>()</p>
                                                        <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                        </div>
                                                    <div>
                                                        <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                                                        <p>()</p>
                                                        <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                    </div>
                                                    </div>
                                                </div>
                                        </div>
                                        <div class="bordered-box">
                                                <div class="content">
                                                    <p>(11) ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</p>
                                                    <p>1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</p>
                                                    <p>----</p>
                                                    <p>2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</p>
                                                    <p>-----</p>
                                                    <p>(12) ผู้ประเมินและผู้รับการประเมินได้เห็นชอบผลการประเมินแล้ว (ระบุข้อมูลใน (4) (6) (7) (8) และ (10) ให้ครบ) จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อสิ้นรอบการประเมิน)</p>
                                                <div class="signatures"><div>
                                                    <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                                                    <p>()</p>
                                                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                    </div>
                                                <div>
                                                    <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                                                    <p>()</p>
                                                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                                                    </div>
                                                </div>
                                                </div>
                                            </div>
                                        </div>
                                        </div>
                                    </TabPanel>

                                    <TabPanel header="แบบ ป03">
                                        <div class="grid">
                                            <div class="col-12 lg:col-12 xl:col-12">
                                                <div class="card mb-0">
                                                    <div class="formgroup-inline mb-1">
                                                        <div class="col md:col-9">
                                                            <h3 class="mb-4 card-header">
                                                                <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป03
                                                            </h3>
                                                            <B><h4>1.ผลสัมฤทธิ์ของงาน</h4></B>
                                                        </div>
                                                        <div class=" col md:col3 text-right">
                                                        <label for="dropdownItemYear" class="label">ปีงบประมาณ :</label>
                                                        <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                                                    </div>
                                                    </div>
                                                    <!-- แสดงข้อมูลบันทึก -->
                                                    
                                                    <table class="table">
                                                        <thead>
                                                            <tr>
                                                                <th rowspan="2" style="width: 17%;">กิจกรรม / โครงการ / งาน</th>
                                                                <th rowspan="2" style="width: 26%;">ตัวชี้วัด / เกณฑ์การประเมิน</th>
                                                                <th rowspan="2" style="width: 25%;">รางานการปฏิบัติราชการ<br> ตามตัวชี้วัด/เกณฑ์การประเมิน</th>
                                                                <th rowspan="2" style="width: 20%;">หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน<br>(หลักฐานเชิงประจักษ์)</th>
                                                                <th colspan="5" style="width: 11%;">ระดับการประเมินตนเอง<br> (ค่าคะแนนที่ได้)</th>
                                                                <th rowspan="2" style="width: 19%;"><br> ตัวเลือก <br></th>
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
                                                                        <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b>
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
                                                                            <!-- {{ subIitemDoc }} --> 
                                                                            <a v-if="subIitemDoc.doc_file!=null" :href="'http://localhost:8000/storage/uploadsP03/'+subIitemDoc.doc_file" target="_blank"><b>ระดับ</b> <b>{{subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                            <a v-if="subIitemDoc.doc_link!=null" :href="subIitemDoc.doc_link" target="_blank"><b>ระดับ</b> <b>{{ subIitemDoc.p03ind_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                        </p>
                                                                        <p v-if="subP01.subITemP03doc.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                            <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                                        </p>
                                                                    </td> 
                                                                    <td class="text-center"> 
                                                                        <b v-if="subP01.score==1">&#10003;</b>
                                                                        <b v-if="subP01.score!=1"></b>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <b v-if="subP01.score==2">&#10003;</b>
                                                                        <b v-if="subP01.score!=2"></b>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <b v-if="subP01.score==3">&#10003;</b>
                                                                        <b v-if="subP01.score!=3"></b>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <b v-if="subP01.score==4">&#10003;</b>
                                                                        <b v-if="subP01.score!=4"></b>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <b v-if="subP01.score==5">&#10003;</b>
                                                                        <b v-if="subP01.score!=5"></b>
                                                                    </td> 
                                                                    <td class="text-center">
                                                                        <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                                                    </td>
                                                                </tr>
                                                            </template>
                                                        </tbody>
                                                    </table> 
                                                    <br>

                                                    <!-- พฤติกรรมการปฏิบัติราชการ -->
                                                    <B><h4>2.พฤติกรรมการปฏิบัติราชการ</h4></B><br>
                                                    <table id="ratingTable">
                                                    <thead>
                                                        <tr>
                                                            <th rowspan="4">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                                                            <th rowspan="4">(1) ระดับสมรรถนะที่คาดหวัง</th>
                                                            <th rowspan="4">(2) ระดับสมรรถนะที่แสดงออก</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody> 
                                                        <tr v-for="(row, index) in coreCompetencies" :key="index">
                                                            <td style="text-align: left;">
                                                                {{ row.activity }} 
                                                            </td>
                                                            <td>{{ row.indicator }}</td>
                                                            <td> 
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                    </table>

                                                    <!-- ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ -->
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th rowspan="4">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                                                                <th rowspan="4">(3) ระดับสมรรถนะที่คาดหวัง</th>
                                                                <th rowspan="4">(4) ระดับสมรรถนะที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row, index) in jobSpecificCompetencies" :key="index">
                                                                <td style="text-align: left;">
                                                                    {{ row.activity }} 
                                                                </td>
                                                                <td>{{ row.indicator }}</td>
                                                                <td> 
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>

                                                    <!-- ตาราง ค. สมรรถนะอื่นๆ -->
                                                    <table id="ratingTable">
                                                    <thead>
                                                        <tr>
                                                            <th rowspan="4">ค. สมรรถนะทางการบริหาร(สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                                                            <th rowspan="4">(5) ระดับสมรรถนะที่คาดหวัง</th>
                                                            <th rowspan="4">(6) ระดับสมรรถนะที่แสดงออก</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(row, index) in otherCompetencies" :key="index">
                                                            <td style="text-align: left;">
                                                                {{ row.activity }}
                                                                <!-- <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                                                                <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i> -->
                                                            </td>
                                                            <td>{{ row.indicator }}</td>
                                                            <td>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </TabPanel>

                                    <TabPanel header="แบบ ป04">
                                        <div class="card">
                                            <h3 class="mb-4" style="text-align: right;">
                                            <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป04
                                            </h3>
                                            <h4 style="text-align: center;">แบบสรุปการประเมินผลการปฏิบัติราชการของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม</h4>
                                                <div class="p-fluid formgrid grid">
                                                    <div class="card">                      
                                                        <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>
                                                        <!-- ตาราง ก. สมรรถนะหลัก -->
                                                        <div class="employee-info"> 
                                                            <p><strong>ชื่อผู้รับการประเมิน:</strong> นาย พิพัฒน์พงษ์ เพริดพราว</p>
                                                            <p><strong>สังกัด:</strong> กองแผนงาน</p>
                                                            <p><strong>ตำแหน่ง:</strong> นักวิชาการคอมพิวเตอร์</p>
                                                            <p><strong>ประเภทตำแหน่ง:</strong> ปฏิบัติการ</p>
                                                            <p><strong>คุณวุฒิ:</strong> ปริญญาตรี</p>
                                                            <p><strong>ประเภทบุคลากร:</strong> พนักงานมหาวิทยาลัย</p>
                                                            <p><strong>รายละเอียดข้อตกลง:</strong> รอบที่2 วันที่ 1 มี.ค. 2567 ถึง วันที่ 31 ส.ค. 2567</p>
                                                            <p><strong>ชื่อผู้ประเมิน:</strong> </p>
                                                            <p><strong>ตำแหน่ง:</strong> </p>
                                                        </div><br>
                                                        <div class="employee-info">
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
                                                        <table id="ratingTable">
                                                            <thead>
                                                                <tr>
                                                                    <th rowspan="4">องค์ประกอบการประเมิน</th>
                                                                    <th rowspan="4">ค่าคะแนนที่ได้หลังถ่วงน้ำหนัก(ก)</th>
                                                                    <th rowspan="4">สัดส่วนคะแนน(ข)</th>
                                                                    <th rowspan="4">สรุปคะแนน(ก) X (ข)</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr v-for="(row, index) in jobSpecificCompetencies" :key="index">
                                                                    <td>{{ row.activity }}</td>
                                                                    <td>{{ row.indicator }}</td>
                                                                    <td>{{ row.weightedScore }}</td>
                                                                    <td>{{ row.proportion }}</td>
                                                                    <td>{{ row.totalScore }}</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <div class="employee-info">
                                                            <h4>ระดับผลการประเมินที่ได้</h4>
                                                            <p><strong>[  ] ดีเด่น (90-100)</strong></p>
                                                            <p><strong>[  ] ดีมาก (80-89)</strong></p>
                                                            <p><strong>[  ] ดี (70-79)</strong></p>
                                                            <p><strong>[  ] พอใช้ (60-69)</strong></p>
                                                            <p><strong>[  ] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p>
                                                        </div>
                                                            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</h5>
                                                        <table class="styled-table">
                                                            <thead>
                                                                <tr>
                                                                <th><b>ความรู้/ทักษะ/สมรรถนะที่ต้องการพัฒนา</b></th>
                                                                <th><b>วิธีการพัฒนา</b></th>
                                                                <th><b>ช่วงเวลาที่ต้องการพัฒนา</b></th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                <td>1.testtest</td>
                                                                <td>testtest11</td>
                                                                <td>testtest333</td>
                                                                </tr>
                                                            </tbody>
                                                            </table>
                                                            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 4 การรับทราบผลการประเมิน</h5>
                                                            <table class="styled-table">
                                                            <tbody>
                                                                <tr>
                                                                <td>
                                                                    <b>ผู้รับการประเมิน</b><br>
                                                                    <input type="checkbox" id="receiver-acknowledgment">
                                                                    <label for="receiver-acknowledgment">ได้รับทราบผลการประเมินและแผนพัฒนาการปฏิบัติราชการ รายบุคคลแล้ว</label><br>
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
                                                                    <input type="checkbox" id="evaluator-acknowledgment-1">
                                                                    <label for="evaluator-acknowledgment-1">ได้แจ้งผลการประเมินและผู้รับการประเมินได้ลงนามรับทราบ รายบุคคลแล้ว</label><br>
                                                                    <input type="checkbox" id="evaluator-acknowledgment-2">
                                                                    <label for="evaluator-acknowledgment-2">ได้แจ้งผลการประเมินเมื่อวันที่ ..............................แต่ผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน โดยมี .......................... เป็นพยาน</label><br>
                                                                    ลงชื่อ .................................................................<br>
                                                                    ชื่อ นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                                    ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                                                    วันที่ .......... เดือน .......................... พ.ศ.
                                                                </td>
                                                                <td class="center-align"><br><br>
                                                                    ลงชื่อ .................................................................<br>
                                                                    ชื่อ นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                                    ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                                                    วันที่ .......... เดือน .......................... พ.ศ.
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
                                                                    <input type="checkbox" id="evaluator-acknowledgment-1">
                                                                    <label for="evaluator-acknowledgment-1">เห็นด้วยกับผลการประเมิน</label><br>
                                                                    <input type="checkbox" id="evaluator-acknowledgment-2">
                                                                    <label for="evaluator-acknowledgment-2">มีความเห็นต่าง ดังนี้<br>..............................................................................................................</label><br>
                                                                    .....................................................................................................................................<br>
                                                                    .....................................................................................................................................
                                                                </td>
                                                                <td class="center-align"><br><br>
                                                                    ลงชื่อ : .................................................................<br>
                                                                    ชื่อ : นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                                    ตำแหน่ง : นักวิชาการคอมพิวเตอร์<br>
                                                                    วันที่ : .......... เดือน .......................... พ.ศ.
                                                                </td>
                                                                </tr>
                                                                <tr>
                                                                <td>
                                                                    <b>ผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง (ถ้ามี)</b><br>
                                                                    <input type="checkbox" id="evaluator-acknowledgment-1">
                                                                    <label for="evaluator-acknowledgment-1">เห็นด้วยกับผลการประเมิน</label><br>
                                                                    <input type="checkbox" id="evaluator-acknowledgment-2">
                                                                    <label for="evaluator-acknowledgment-2">มีความเห็นต่าง ดังนี้<br>...............................................................................................................</label><br>
                                                                    .......................................................................................................................................<br>
                                                                    .......................................................................................................................................
                                                                </td>
                                                                <td class="center-align"><br><br>
                                                                    ลงชื่อ .................................................................<br>
                                                                    ชื่อ นายพิพัฒน์พงษ์ เพริดพราว<br>
                                                                    ตำแหน่ง ผู้อำนวยการกองแผนงาน<br>
                                                                    วันที่ .......... เดือน .......................... พ.ศ.
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
                                    <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="Dialogclose" />
                            </template>
                        </Dialog>
                    </div>
              </div>
            </div>
        </div>     
</template>
<script> 
import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2'
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
            
            dropdownItemRecord: null,
            // products_personP03: [], 
            /*=========== 1.ผลสัมฤทธิ์ของงาน =============*/                
            products_personP03: [], 
                itemsBtu: (item) => [
                    {
                        label: 'รางานการปฏิบัติราชการ',
                        icon: 'pi pi-sort-amount-down',
                        command: () => {
                            this.OpenDialogAdd(item);
                        }
                    },
                    {
                        label: '(หลักฐาน)รางานการปฏิบัติราชการ',
                        icon: 'pi pi-file',
                        command: () => {
                            this.OpenDialogDoc(item);
                        }
                    },
                    {
                        label: 'ระดับคะแนนประเมินตนเอง',
                        icon: 'pi pi-thumbs-up',
                        command: () => {
                            this.OpenDialogScore(item);
                        }
                    },
                    {
                        label: 'ลบข้อมูล',
                        icon: 'pi pi-times',
                        command: () => {
                            this.delDataDoc(item);

                        }
                    }
                ],
            dropdownItemRecords: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            ],
        //t*****************************P02 Start*******************************
            coreCompetencies: [
                { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1',report: '' },
                { activity: 'ก. 2 การบริการที่ดี', indicator: '1',report: ''  },
                { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1',report: ''},
                { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1',report: ''},
                { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1',report: ''}
            ],
            jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1',report: ''},
                { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1',report: ''},
                { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1',report: ''},
                { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1',report: ''},
                { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1',report: ''},
                { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1',report: ''}
                
            ],
            otherCompetencies: [
                { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0',report: ''},
                { activity: 'ค. 2 วิสัยทัศน์', indicator: '0',report: ''},
                { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0',report: ''},
                { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0',report: ''},
                { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0',report: ''}
               
            ],
                    rows: [
                {
                description: "จำนวนสมรรถนะหลัก/สมรรถนะเฉพาะทางที่ปฏิบัติ/สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก สูงกว่าหรือเท่ากับ ระดับสมรรถนะที่คาดหวัง X 3 คะแนน",
                quantity: 0,
                multiplier: 3,
                score: 0
                },
                {
                description: "จำนวนสมรรถนะหลัก/สมรรถนะเฉพาะทางที่ปฏิบัติ/สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่าระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน",
                quantity: 11,
                multiplier: 2,
                score: 22
                },
                {
                description: "จำนวนสมรรถนะหลัก/สมรรถนะเฉพาะทางที่ปฏิบัติ/สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่าระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน",
                quantity: 0,
                multiplier: 1,
                score: 0
                },
                {
                description: "จำนวนสมรรถนะหลัก/สมรรถนะเฉพาะทางที่ปฏิบัติ/สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่าระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน",
                quantity: 0,
                multiplier: 0,
                score: 0
                }
            ],

            //t*****************************P02 END *******************************
            newActivity: '',
            newIndicator: '',
            newReport: '',
            newEvidence: '',
            activeFormIndex: null,
            activeCategory: '',
           //t*****************************P03 Start*******************************
           /*============= รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน =============*/
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
          
        };
    },
        
    mounted(){
        this.showDataEvalu();
        this.showDataPerson(); 
       // this.showDataP03();          
        
    },
    methods: { 
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
            axios.post('http://localhost:8000/api/showDataValuate',{
                staff_id: staff_id,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.code,
            }).then(res => {     
                // console.log(res.data);  
                this.products_person=res.data; 
                this.DialogAdd = true; 
                //this.showDataP03();
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        closeCallback(){
            this.DialogAdd = false; 
        },

        ////************/////////P01 *******************************/
        // ดึงข้อมูลเข้าตาราง
        showDataPerson(){
            axios.post('http://localhost:8000/api/showDataPersonX',{
            staff_id: this.staffid_Main,
            fac_id: this.facid_Main,
            year_id: this.year_Main, 
            group_id: this.groupid_Main,
            }).then(res => {     
                // console.log(res.data);  
                this.products_personX=res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
        // ดึงข้อมูลมาแก้ไข
        async editDatax(data){    
          await axios.post('http://localhost:8000/api/edtDataPersonx',{
              p01_id: data.p01_id
          }).then(res => { 
                 //console.log(data);   
                    this.DialogAdd = true; 
                    this.text_edt = res.data[0].p01_id;   
                    this.text_no = res.data[0].p01_no; 
                    this.text_name = res.data[0].p01_subject;  
                    const target_f = this.dropdownItemsTarget.filter(f=>f.value==res.data[0].p01_target)
                    this.dropdownItemTarget = target_f.length > 0 ? target_f[0] : null;    
                    this.text_weight = res.data[0].p01_weight;  
                    this.products_list = res.data[0].sub_ITem; 
                    this.selectDataHEdt(res.data[0].p01_year,res.data[0].p01_facid,res.data[0].p01_h); 
          })
          .catch(error => {
              console.error('Error:', error);
          });
        },
        // ดึงข้อมูลภาระงาน
        selectDataHEdt(year,fac,he){  
            axios.post('http://localhost:8000/api/selectDataPersonH',{
                year: year,
                fac: fac,
            }).then(res => {     
                // console.log(res.data); 
                this.dropdownItemsH=res.data;  
                const h_f = res.data.filter(f=>f.id==he); 
                this.dropdownItemH = h_f.length > 0 ? h_f[0] : null;    

            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
     
//*================== Start เลือกข้อมูลแบบประเมิน ป.01 ==================*//
        // เปิดหน้าต่างสำหรับบันทึก *ดึงข้อมูล
        OpenDialogP01(){ 
            axios.post('http://localhost:8000/api/showDataPerson', { 
                fac_id: this.facid_Main,
                year_id: this.year_Main
            }).then(res => {     
                this.DialogAddP01 = true; 
                this.products_person = res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            }); 
        }, 
        // บันทึกข้อมูล ป01 *ดึงข้อมูล
        async savetablechkem() {    
            let x = []
            this.products_person.forEach((v) => {
                const selectedItems = v.subP01s.filter(item => this.checkboxValue.includes(item.p_id)); 
                x = x.concat(selectedItems);
            }) 
            // console.log(x.length);  
            if(x.length == 0){
                Swal.fire("ไม่มีข้อมูล","กรุณาเลือกข้อคำถามจาก ตัวจัดการ !","error");
            }else{
            await axios.post('http://localhost:8000/api/savePushDataP01',{
                data: x
            }).then(res => { 
                // console.log(res.data);  
                this.showDataPerson(); 
                this.DialogAddP01 = false; 
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบจัดการ ป01 เรียบร้อย!",
                    icon: "success"
                }); 
            })
            .catch(error => {
                console.error('Error:', error);
            });  
            }
        },
        // ปิดหน้าต่างสำหรับบันทึก *ดึงข้อมูล
        cancelDialogs(){
            this.DialogAddP01 = false; 
        },
//*================== End เลือกข้อมูลแบบประเมิน ป.01 ==================*//


//*================== P02 เลือกข้อมูลแบบประเมิน ป.02 ==================*//
        computed: {
            totalScore() {
            return this.rows.reduce((sum, row) => sum + row.score, 0);
            },
            averageScore() {
            const total = this.totalScore;
            const count = this.rows.length;
            return (count > 0) ? (total / count * 3).toFixed(2) : '0';
            }
        },
//*================== End เลือกข้อมูลแบบประเมิน ป.02 ==================*//


//*================== Start เพิ่มข้อมูลแบบประเมิน ==================*//
        // เปิดหน้าต่างสำหรับบันทึก 
        OpenDialogAdd(){
            this.DialogAdd = true; 
            this.text_edt = null;
            this.dropdownItemH = null;
            this.text_no = null;
            this.text_name = null; 
            this.dropdownItemTarget = null;
            this.text_weight = null;
            this.text_search_no = null;
            this.text_search = null;
            this.products_list = []; 
            this.selectDataH(this.dropdownItemYear,this.facid_Main);
        },
        // ดึงข้อมูลภาระงาน
        selectDataH(year,fac){   
            axios.post('http://localhost:8000/api/selectDataPersonH',{
                year: year.value,
                fac: fac,
            }).then(res => {     
                // console.log(res.data); 
                this.dropdownItemsH=res.data;  
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // บันทึกตัวชี้วัด / เกณฑ์การประเมิน
        AddDatalist(){    
            if(this.text_search_no == null || this.text_search == null){ 
                Swal.fire("ไม่มีข้อมูล","กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!","error");
            } else {    
                this.products_list.push({
                    ind_no: this.text_search_no,
                    ind_Items: this.text_search
                });   
                this.products_list.sort((a, b) => a.ind_no - b.ind_no);  
                this.text_search_no = null;
                this.text_search = null;
            } 
        },
        // ลบตัวชี้วัด / เกณฑ์การประเมิน
        DeleteRegislick(data){
            this.products_list = this.products_list.filter(product => product.ind_no !== data); 
        },
        // บันทึกแบบจัดการ ป.1 
        async saveDatax() {
            await axios.post('http://localhost:8000/api/saveDataP01User',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dropdownItemYear.value,  
                text_edt: this.text_edt,
                dropdownItemH: this.dropdownItemH.id,
                text_no: this.text_no,
                text_name: this.text_name,
                text_target: this.dropdownItemTarget.value,
                text_weight: this.text_weight, 
                products_list: this.products_list
            }).then(res => {  
                // console.log(res.data); 
                this.DialogAdd = false;
                this.showDataPerson(); 
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
                    icon: "success"
                });
                
            })
            .catch(error => {
                console.error('Error:', error);
            });
 
        }, 
        // ปิดบันทึกแบบจัดการ ป.1 
        cancelDialog(){
            this.DialogAdd = false;
        },
//*================== End เพิ่มข้อมูลแบบประเมิน ==================*//
//*================== End แบบประเมิน ป.01 ==================*//



////************/////////P03 *******************************/
// ดึงข้อมูลเข้าตาราง
            async showDataP03(){
                await axios.post('http://localhost:8000/api/showDataP03New',{
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    year_id: this.dropdownItemYear.value,
                    group_id: this.groupid_Main,
                }).then(res => {
                    console.log(res.data);
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
                axios.post('http://localhost:8000/api/p03indData',{
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
                if(this.list_no_p03 == null || this.list_text_p03 == null){ 
                    Swal.fire("ไม่มีข้อมูล","กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!","error");
                } else { 
                    this.products_list_p03.push({
                        p03ind_no: this.list_no_p03,
                        p03ind_Items: this.list_text_p03
                    }); 
                    this.products_list_p03.sort((a, b) => a.p03ind_no - b.p03ind_no); 
                    this.list_no_p03 = null;
                    this.list_text_p03 = null;  
                }
            }, 
            // ลบรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            DeleteRegislick(data){ 
                this.products_list_p03 = this.products_list_p03.filter(product => product.p03ind_no !== data.p03ind_no);
            },
            // บันทึกรายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน
            saveDataListP03() {   
                if(this.products_list_p03.length == 0){
                    Swal.fire("error","กรุณาตรวจสอบตารางข้อมูล ตัวชี้วัดการประเมิน!","error");
                }else{
                    axios.post('http://localhost:8000/api/saveListP03', {
                        p_id: this.text_edtP03,
                        products_list: this.products_list_p03
                    })
                    .then((res) => {
                        // console.log(res.data);  
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
                const files = event.target.files;
                this.selectedFiles = Array.from(files);
            },
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

                            instance_x.post('http://localhost:8000/api/saveDocP03', formData)
                                .then(res => {
                                   // console.log('Response from server:', res); 
                                   this.showDataP03();
                                    this.Data_Doc(); 
                                    this.radioValue = 'doc';
                                    this.doc_no = null;
                                    this.doc_name = null;
                                    this.doc_link = null;
                                    this.$refs.upload.value = null;
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

                            instance_x.post('http://localhost:8000/api/saveDocP03', formData)
                                .then(res => {
                                    //console.log(res.data); 
                                    this.showDataP03();
                                    this.Data_Doc();
                                    this.radioValue = 'doc';
                                    this.doc_no = null;
                                    this.doc_name = null;
                                    this.doc_link = null;
                                    this.$refs.upload.value = null;
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                });
                        }
                    } else {
                        Swal.fire("error", "กรุณาตรวจสอบ ประเภทการแนปเอกสาร!", "error");
                    }
                } catch (error) {
                    console.error('Error: ', error);
                }
            },
            Data_Doc(){
                axios.post('http://localhost:8000/api/sheachDataDoc', {
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
            delDataDoc(data){  
                axios.post('http://localhost:8000/api/deleteDocP03', {
                    doc_id: data.doc_id, 
                    doc_file: data.doc_file??null
                })
                .then((res) => {  
                    this.products_doc_p03 = this.products_doc_p03.filter(item => item.doc_id !== data.doc_id);
                    Swal.fire("success","ลบข้อมูลสำเร็จ!","success");
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
                    axios.post('http://localhost:8000/api/delDocP03', {
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
            /*============= ค่าคะแนนที่ได้ =============*/
            OpenDialogScore(item){ 
                // console.log(item); 
                this.DialogScore = true;
                this.text_edtP03Score = item.p01_id;;
                this.score_p03 = null; 
                axios.post('http://localhost:8000/api/p03ScoreData',{
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
                    axios.post('http://localhost:8000/api/saveScoreP03', {
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
        ////************/////////ENDP03 *******************************/
      
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
      background-color: #f4f4f4;
      font-weight: bold;
  }
  .table td {
      vertical-align: top;
  }

  
</style>