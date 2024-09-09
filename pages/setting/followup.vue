  <template>
    <div class="assessment-container">
      <div class="filters">
        <label>
          รายชื่อผู้รับการประเมิน
          <input type="radio" name="dateRange" value="option1" checked> วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์
          <input type="radio" name="dateRange" value="option2"> วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม ปีงบประมาณ
        </label>
        <FloatLabel>
          <Dropdown 
            id="yearDropdown" 
            :options="years" 
            v-model="year" 
            optionLabel="label"
            placeholder="เลือกปี"
          />
          <label for="yearDropdown">ปีงบประมาณ</label>
        </FloatLabel>
        <FloatLabel>
          <Dropdown 
            id="typeDropdown" 
            :options="types" 
            v-model="type" 
            optionLabel="label"
            placeholder="เลือกประเภท"
          />
          <label for="typeDropdown">ประเภท</label>
        </FloatLabel>
      </div>
      
      <table>
        <thead>
          <tr>
            <th>ลำดับ</th>
            <th>ผู้รับการประเมิน</th>
            <th>สัดส่วน</th>
            <th>รายงาน</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(evaluator, index) in evaluators" :key="index">
            <td>{{ index + 1 }}</td>
            <td>{{ evaluator.name }}</td>
            <td>{{ evaluator.ratio }}</td>
            <td class="centered-button-cell">
              <Button 
                icon="pi pi-book" 
                severity="warning" 
                class="mb-2 mr-2" 
                label="รายงาน" 
                @click="openReportDialog(evaluator)" 
              />
            </td>
          </tr>
        </tbody>
      </table>  
      <Dialog :visible="displayDialog" modal @hild="hideDialog" :style="{ width: '90vw' }">
        <template v-slot:header>
          <h3>รายงานแบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference: TOR)</h3>
          <button @click="hideDialog" class="close-button">Close</button> 
        </template>
        <TabView>
          <TabPanel header="แบบใบปะหน้า">
            <h3 class="mb-4" style="text-align: right;">
              <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01-02
            </h3>
            <div class="card">
              <div style="display: flex; justify-content: center;">
                <img src="@/public/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
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
            <div class="card">
              <h3 class="mb-4" style="text-align: right;">
                <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01
              </h3>
              <h4>ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 1)</h4>
              <div class="grid">
          <div class="col-12 lg:col-12 xl:col-12">
              <div class="card mb-0"> 
                  <div class="formgroup-inline mb-1">
                      <div class="col md:col-6"> 
                          <h3 class="mb-4 card-header"><i class="pi pi-fw pi-sliders-h" style="font-size: x-large;"></i> จัดการ แบบประเมิน</h3> 
                      </div> 
                      <div class="ol md:col-3 text-right">
                          <label for="dropdownItemYear">ปีงบประมาณ : </label> 
                          <Dropdown id="dropdownItemYear" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>
                      </div> 
                      <div class="col md:col-3 text-right"> 
                          <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" /> 
                          <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                              <form>
                                  <InputText v-model="text_edt" type="text" />
                                  <div class="p-fluid formgrid grid"> 
                                      <div class="field col-12 md:col-4">
                                          <label for="dropdownItemH">ประเภทภาระงาน</label>
                                          <Dropdown id="dropdownItemH" v-model="dropdownItemH" :options="dropdownItemsH" optionLabel="nameH" placeholder="เลือกประเภทภาระงาน"></Dropdown>
                                      </div>
                                      <div class="field col-12 md:col-2">
                                          <label for="text_no">ข้อที่</label>
                                          <InputGroup>
                                              <InputGroupAddon>
                                                  <i class="pi pi-calendar-plus"></i>
                                              </InputGroupAddon>
                                              <InputText v-model="text_no" type="number" placeholder="ข้อ" autocomplete="off" /> 
                                          </InputGroup> 
                                      </div>
                                      <div class="field col-12 md:col-6">
                                          <label for="text_name">เรื่อง</label>
                                          <InputGroup>
                                              <InputGroupAddon>
                                                  <i class="pi pi-book"></i>
                                              </InputGroupAddon>
                                              <Textarea v-model="text_name" rows="1" placeholder="เรื่อง" autocomplete="off" /> 
                                          </InputGroup>  
                                      </div> 
                                      <div class="field col-12 md:col-3">
                                          <label for="text_target">ระดับค่าเป้าหมาย</label>
                                          <Dropdown id="dropdownItemTarget" v-model="dropdownItemTarget" :options="dropdownItemsTarget" optionLabel="name" placeholder="เลือกระดับค่าเป้าหมาย"></Dropdown>
                                      </div> 
                                      <div class="field col-12 md:col-4">
                                          <label for="text_weight">น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)</label>
                                          <InputGroup>
                                              <InputGroupAddon>
                                                  <i class="pi pi-tags"></i>
                                              </InputGroupAddon>
                                              <InputText v-model="text_weight" type="number" placeholder="น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)" autocomplete="off" />  
                                          </InputGroup>  
                                      </div>  
                                  </div> 
                                  <hr>
                                  <div class="p-fluid formgrid grid">
                                      <div class="field col-12 md:col-12"> 
                                          <label for="text_search_no">ตัวชี้วัด / เกณฑ์การประเมิน</label>
                                          <InputGroup>  
                                              <InputText v-model="text_search_no" type="number" placeholder="ลำดับ" autocomplete="off" class="col-12 md:col-2" /> 
                                              <InputText v-model="text_search" type="text" placeholder="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" autocomplete="off"/> 
                                              <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" />
                                          </InputGroup>  
                                      </div>   
                                  </div> 
                                  <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">    
                                      <Column field="ind_no" header="ลำดับ" style="width: 10%">
                                          <template #body="Item">
                                              ระดับที่ {{ Item.data.ind_no }}
                                          </template>
                                      </Column> 
                                      <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="width: 80%">
                                          <template #body="Item"> 
                                              {{ Item.data.ind_Items }}
                                          </template>
                                      </Column>  
                                      <Column field="options" header="ตัวเลือก" style="width: 10%">
                                          <template #body="Item">   
                                              <Button severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
                                          </template>
                                      </Column> 
                                  </DataTable>
                              </form>
                              <template #footer>
                                  <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveData" /> 
                                  <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                              </template>
                          </Dialog> 
                      </div> 
                  </div>  
                  <table class="table" border="1" width="100%">
                  <!-- <table class="table table-bordered"> -->
                      <thead>
                          <tr>
                              <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                              <th rowspan="2" style="width: 24%;">
                              (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                              (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                              </th>
                              <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                              <th rowspan="2" style="width: 7%;">(4) <br> ค่าคะแนน ที่ได้</th>
                              <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                              <th rowspan="2" style="width: 10%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
                              <th rowspan="2" style="width: 9%;"><br> ตัวเลือก <br></th>
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
                          <template v-for="(item, index) in products_person" :key="index"> 
                                  <tr >
                                      <td style="text-align: left;">
                                          <b style="color: blue;">{{ item.id }}. {{ item.nameH }}</b>
                                      </td>
                                      <td></td>
                                      <td></td>
                                      <td></td>
                                      <td></td>
                                      <td></td>
                                      <td></td>
                                      <td></td>
                                      <td class="text-center" style="color: blue;"><b>{{ item.h_weight }}%</b></td>
                                      <td></td>
                                      <td></td>
                                  </tr>
                                  <!-- P01 -->
                                  <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;"> 
                                      <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                      <td style="text-align: left;">
                                          <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                          <p v-for="(subIitem, idI) in item.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                              <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                                          </p>
                                      </td>
                                      <td class="text-center"> 
                                          <b v-if="subP01.p_target==1">&#10003;</b> 
                                          <b v-if="subP01.p_target!=1"></b> 
                                      </td>
                                      <td class="text-center"> 
                                          <b v-if="subP01.p_target==2">&#10003;</b> 
                                          <b v-if="subP01.p_target!=2"></b> 
                                      </td>
                                      <td class="text-center"> 
                                          <b v-if="subP01.p_target==3">&#10003;</b> 
                                          <b v-if="subP01.p_target!=3"></b> 
                                      </td>
                                      <td class="text-center"> 
                                          <b v-if="subP01.p_target==4">&#10003;</b> 
                                          <b v-if="subP01.p_target!=4"></b> 
                                      </td>  
                                      <td class="text-center"> 
                                          <b v-if="subP01.p_target==5">&#10003;</b> 
                                          <b v-if="subP01.p_target!=5"></b> 
                                      </td>
                                      <td class="text-center">{{ subP01.p_score }}</td>
                                      <td class="text-center">{{ subP01.p_weight }}%</td> 
                                      <td class="text-center">{{ (subP01.p_score * subP01.p_weight / 100).toFixed(2) }}</td>
                                      
                                      <td class="text-center">
                                          <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                      </td> 
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
                              <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'other'">
                                  <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                                  <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                                  <label for="file">เลือกไฟล์:</label>
                                  <input type="file" @change="handleFileUpload"><br><br>
                                  <button class="save-button" @click="addRow('other')">บันทึก</button>
                                  <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                              </div>
                          </td>
                      </tr>
                  </tbody>
               </table>
               <div>
                  <h4 class="mb-4"><i class="" style="font-size: x-large;"></i> เกณฑ์การประเมิน</h4>
              </div>
              <table id="ratingTable">
                  <thead>
                      <tr>
                          <th rowspan="3">เกณฑ์การประเมิน</th>
                          <th rowspan="3">จำนวนสมรรถนะ</th>
                          <th rowspan="3">คูณด้วย</th>
                          <th rowspan="3">คะแนน</th>
                      </tr>
                  </thead>
                  <tbody>
                      <tr v-for="(row, index) in score" :key="index">
                          <td>
                              <div style="text-align: left;">{{ row.activity }}</div>
                              <!-- <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                              <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i> -->
                          </td>
                          <td>{{ row.indicator }}</td>
                          <td>{{ row.multiplier }}</td>
                          <td>{{ row.score }}</td>
                      </tr>
                  </tbody>
              </table>
              <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'other'">
                  <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                  <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                  <label for="file">เลือกไฟล์:</label>
                  <input type="file" @change="handleFileUpload"><br><br>
                  <button class="save-button" @click="addRow('other')">บันทึก</button>
                  <button class="cancel-button" @click="hideForm">ยกเลิก</button>
              </div>
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
          <div class="card">
            <h3 class="mb-4" style="text-align: right;">
              <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป03
            </h3>
            <B><h4>1.ผลสัมฤทธิ์ของงาน</h4></B>   
      <div class="col-12 lg:col-12 xl:col-12">
        <div class="card mb-0">
          <h3 class="mb-4" style="text-align: left;">
            <!-- <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป03 -->
          </h3>
          <div class="formgroup-inline mb-1">
            <div class="col md:col-6">
              <FloatLabel>
                <InputText type="text" id="search" v-model="searchData" class="col-10" autocomplete="off" />
                <label for="search">ค้นหา</label>
              </FloatLabel><br>
            </div>
          </div> 
          <DataTable :value="products" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
            <Column field="Tb_name" header="กิจกรรม/โครงการ/งาน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <div style="text-align: left;">
                <B>ข้อที่</B> {{ Item.data.p01_no }} <br>
                <B>เรื่อง</B> {{ Item.data.p01_subject }}
                </div>
              </template>
            </Column>
            <Column field="Tb_ind" header="ตัวชี้วัด/เกณฑ์การประเมิน" style="width: 25%;vertical-align: baseline;">
              <template #body="Item">
                <div style="text-align: left;">
                <B>ตัวชี้วัดที่ {{ Item.data.p01_subject }} </B>
                <p v-for="(xx, index) in Item.data.sub_ITem" :key="index" class="mb-0">
                  <B>ระดับที่ {{ xx.ind_no }}</B> {{ xx.ind_Items }}
                </p>
                </div>
              </template>
            </Column>
            
            <Column field="Tb_target" header="รายงานผลปฎิบัติราชการตามตัวชี้วัด/เกณฑ์การประเมิน" style="width: 20%">
              <template #body="Item">
                <div style="text-align: left"> 
                  <p v-for="(xx, index) in Item.data.sub_ITemP03" :key="index" class="mb-0">
                    <B>ระดับที่ {{ xx.p03_estimate }}</B> <br>
                    {{ xx.p03_report }} 
                    <!-- <Button icon="pi pi-pencil" severity="warning" rounded text raised class="mb-2 mr-2" @click="editData(xx)" />
                    <Button icon="pi pi-times" severity="danger" rounded text raised class="mb-2 mr-2" @click="delData(xx)" />  -->
                  </p>
                  <!-- <Button label="เพิ่มรายการ" severity="primary" icon="pi pi-plus" @click="OpenDialogAdd(Item.data)" />   -->
                  </div>
              </template>
            </Column>

            <Column field="Tb_score" header="หลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน (หลักฐานเชิงประจักษ์)" style="width: 20%">
              <template #body="Item"> 
                <div style="text-align: left">
                <!-- <a :href="fileUrl" target="_blank">Open Uploaded File</a> -->
                <p v-for="(xx, index) in Item.data.sub_ITemDoc" :key="index" class="mb-0">  
                    <a :href="'http://localhost:8000/storage/uploads/'+xx.doc_file" target="_blank">{{ xx.doc_name }}</a> 
                    <!-- <Button icon="pi pi-times" severity="danger" rounded text raised class="mb-2 mr-2" @click="delDataDoc(xx)" />  -->
                  </p>
                <!-- <Button label="เพิ่มไฟล์" severity="primary" icon="pi pi-plus" @click="OpenDialogAddfile(Item.data)" />  -->
                </div>
              </template>
            </Column>
            <Column field="Tb_score" header="ค่าคะแนนประเมินตนเอง" style="width: 10%">
              <template #body="Item">
                <b style="color: grey;">{{ Item.data.p01_score }}</b>
              </template> 
            </Column>
          </DataTable> 
          <!-- Dialog เพิ่มรายงานผลปฎิบัติราชการตามตัวชี้วัด -->
          <Dialog header="เพิ่มรายงานผลปฎิบัติราชการตามตัวชี้วัด" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
            <div class="p-fluid formgrid grid"> 
              <InputText v-model="text_p01_id" type="text" /> 
              <InputText v-model="text_edt" type="text" />  
              <div class="field col-12 md:col-3"> 
                  <label for="level">ข้อที่</label> 
                  <Dropdown v-model="level" :options="dropdownValuesLevel" optionLabel="nameLevel" placeholder="- กรุณาเลือก -" />
              </div>
              <div class="field col-12 md:col-9">
                  <label for="text_detail">เรื่อง</label>
                  <Textarea v-model="text_detail" rows="3"></Textarea>
              </div>   
              <!-- <div class="button-container">
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveData" />
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
              </div> -->
            </div>
          </Dialog> 
          <!-- Dialog เพิ่มหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน -->
          <Dialog header="เพิ่มหลักฐานเชิงประจักษ์" maximizable v-model:visible="DialogAddfile" :breakpoints="{ '960px': '75vw' }" :style="{ width: '50vw' }" :modal="true" position="top">
            <div class="p-fluid formgrid grid"> 
              <InputText v-model="doc_p01_id" type="text" /> 
              <InputText v-model="doc_edt" type="text" />   
              <div class="field col-12 md:col-9">
                  <label for="doc_name">ชื่อไฟล์</label>
                  <Textarea v-model="doc_name" rows="3"></Textarea>
                  <form>
                    <input type="file" ref="fileInput" @change="handleFileChange">
                  </form>
              </div>   
              <div class="field col-12 md:col-3" style="align-content: space-evenly;">
                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="savefileData" />
                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
              </div>
            </div>
          </Dialog>
        </div>
        <br>

          <!-- แทรกp.02 -->
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
                    <td>
                        <div style="text-align: left;">{{ row.activity }}</div>
                        <!-- <i class="far fa-edit edit-icon" @click="editRow('core', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('core', index)" title="ลบ"></i> -->
                    </td>
                    <td>{{ row.indicator }}</td>
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
                        <div style="text-align: left">{{ row.activity }}</div>
                        <!-- <i class="far fa-edit edit-icon" @click="editRow('job', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('job', index)" title="ลบ"></i> -->
                    </td>
                    <td>{{ row.indicator }}</td>
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
                        <div class="add-row-form form-container" v-show="activeFormIndex === index && activeCategory === 'other'">
                            <label for="activity">กิจกรรม/โครงการ/งาน:</label>
                            <input type="text" v-model="newActivity" style="width: 80%; padding: 8px; margin: 5px 0;"><br>
                            <label for="file">เลือกไฟล์:</label>
                            <input type="file" @change="handleFileUpload"><br><br>
                            <button class="save-button" @click="addRow('other')">บันทึก</button>
                            <button class="cancel-button" @click="hideForm">ยกเลิก</button>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="bordered-box">
                    <div class="content">
                      <p>ผู้รับการประเมินได้รายงานผลการปฏิบัติราชการ และผู้ประเมินได้รับรายงานผลการปฏิบัติราชการเรียบร้อยแล้ว จึงลงลายมือชื่อไว้เป็นหลักฐาน</p>
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

                        <!-- <label>
                        <input type="radio" name="round" value="1" v-model="round">รอบที่1 วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์
                    </label>
                    <label>
                        <input type="radio" name="round" value="2" v-model="round">รอบที่2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม
                    </label> -->
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
          </Dialog>
        </div>
      </template>
    <script>
    import Button from 'primevue/button';
    import Dialog from 'primevue/dialog';
    import FloatLabel from 'primevue/floatlabel';
    import Dropdown from 'primevue/dropdown';
    import { useRouter } from 'vue-router';
    import { ref } from 'vue';
    import axios from 'axios';  
    import Swal from 'sweetalert2'
    export default {
      components: {
        Button,
        Dialog,
        FloatLabel,
        Dropdown
      },
      data() {
        return {
          searchData: null,
            staff_id: 5008886,
            facid: 201092704000,
            groupid: '01',
            products: [], 
            // Dialog
            DialogAdd: false,
            text_edt: null,
            text_no: null,
            text_name: null,
            text_target: null,
            text_weight: null,
            text_search_no: null,
            text_search: null,
            products_list: [],
            coreCompetencies: [
                    { activity: 'องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน', indicator: '',report: '',report:''},
                    { activity: 'องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ', indicator: '',report:'1'},
                    { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1',report:'1'},
                    { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1',report:'1'},
                    { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1',report:'1'}
                ],
                jobSpecificCompetencies: [
                    { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1',report:'1'},
                    { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1',report:'1'},
                    { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1',report:'1'},
                    { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1',report:'1'},
                    { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1',report:'1'},
                    { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1',report:'1'}
                    
                ],
                otherCompetencies: [
                    { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0' },
                    { activity: 'ค. 2 วิสัยทัศน์', indicator: '0' },
                    { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0' },
                    { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0' },
                    { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0' }
                  
                ],
                score: [
                    { activity: 'จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก สูงกว่าหรือเท่ากับ ระดับสมรรถนะที่คาดหวัง X 3 คะแนน', indicator: '0' },
                    { activity: 'จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน', indicator: '0' },
                    { activity: 'จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน', indicator: '0' },
                    { activity: 'จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน', indicator: '0' },
                ],
                newActivity: '',
                newIndicator: '',
                newReport: '',
                newEvidence: '',
                activeFormIndex: null,
                activeCategory: '',
                text_detail: null,
              // Dialog เพิ่มหลักฐานที่แสดงถึงผลการปฎิบัติกราชการตามเกณฑ์การประเมิน
                DialogAddfile: false, 
                // upfile 
                doc_p01_id: null,
                doc_edt: null,
                doc_name: null,
                doc_file: null,
                fileUrl: null,
                activeFileItem: null,
                persen: '',
                fileName: '',
                p01_detail_add: {},
                p03_file_add: {
                p03: null,
                displayDialog: false,
              },
            
          years: [
            { label: '2567', value: 2567 },
            { label: '2566', value: 2566 },
            { label: '2565', value: 2565 }
          ],
          types: [
            { label: 'ทั้งหมด', value: 'ทั้งหมด' },
            { label: 'ข้าราชการ', value: 'ข้าราชการ' },
            { label: 'ลูกจ้างประจำ', value: 'ลูกจ้างประจำ' },
            { label: 'ลูกจ้างชั่วคราว', value: 'ชั่วคราว' },
            { label: 'พนักงาน', value: 'พนักงาน' },
            // Add other types as needed
          ],
          year: 2567,
          type: 'ทั้งหมด',
          evaluators: [
            {
              name: 'นาย พิพัฒน์พงษ์ เพริดพราว',
              ratio: '70:30',
              reportIcon: 'path/to/report-icon.png' // Use the correct path for the icon
            }
            // Add more evaluators as needed
          ],
          displayDialog: false,
          selectedEvaluator: {}
        };
        

      },
      mounted(){
        this.showDataP01();
        this.showDataP03();
        },
      methods: {
          showEvaluators() {
            // Implement the logic to show evaluators based on the selected filters
          },
          hideDialog() {
            this.displayDialog = false;
          },
          showDataP01(){
                axios.post('http://localhost:8000/api/showDataP01',{
                    staff_id: this.staff_id,
                    facid: this.facid,
                    groupid: this.groupid,
                }).then(res => {     
                    // console.log(res.data); 
                    this.products = res.data;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
              },
          showDataP03() {
              axios.post('http://localhost:8000/api/showDataP03', {
                    staff_id: this.staff_id,
                    facid: this.facid,
                    groupid: this.groupid
                })
                .then((res) => {
                  // console.log(res.data);
                  this.products = res.data;
                })
                .catch((error) => {
                  console.error('Error:', error);
                });
            },
          OpenDialogAdd(item) {
                // console.log('OpenDialogAdd', item);
                this.DialogAdd = true;
                this.text_p01_id = item.p01_id;
                this.text_edt = null; 
                this.level = null;  
                this.text_detail = null; 
              },
          resetDialog() {
              this.DialogAdd = false;
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
        OpenDialogAdd(){
                this.DialogAdd = true; 
                this.text_edt = null;
                this.text_no = null;
                this.text_name = null;
                this.text_target = null;
                this.text_weight = null;
                this.text_search_no = null;
                this.text_search = null;
                this.products_list = [];
            },
            async AddDatalist(){  
                if(this.text_search_no == null || this.text_search == null){
                    Swal.fire("กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!");
                }else{   
                    if (this.products_list.length < 5) {
                        this.products_list.push({
                            ind_no: this.text_search_no,
                            ind_Items: this.text_search
                        });  
                        // Sort the products_list by ind_no in asc order
                        this.products_list.sort((a, b) => a.ind_no - b.ind_no); 
                    } else {
                        Swal.fire("ตัวชี้วัด / เกณฑ์การประเมิน ครบ 5 ระดับแล้ว!");

                    } 
                    this.text_search_no = null;
                    this.text_search = null;
                }
            },
            DeleteRegislick(data){
                this.products_list = this.products_list.filter(product => product.ind_no !== data); 
            },
            async saveData(){
                await axios.post('http://localhost:8000/api/saveDataP01',{
                    staff_id: this.staff_id,
                    facid: this.facid,
                    text_edt: this.text_edt,
                    text_no: this.text_no,
                    text_name: this.text_name,
                    text_target: this.text_target,
                    text_weight: this.text_weight, 
                    products_list: this.products_list
                }).then(res => {     
                    // console.log(res.data);
                    Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
                    icon: "success"
                    });
                    this.DialogAdd = false; 
                    this.showDataP01();
                })
                .catch(error => {
                    console.error('Error:', error);
                });
                },
                resetDialog(){
                this.DialogAdd = false; 
                },
                saveData() { 
                axios.post('http://localhost:8000/api/saveDataP03', {
                    staff_id: this.staff_id,
                    facid: this.facid,
                    text_p01_id: this.text_p01_id,  
                    text_edt: this.text_edt,  
                    level: this.level,  
                    text_detail: this.text_detail
                  })
                  .then((res) => {
                    // console.log(res.data); 
                    Swal.fire({
                      title: 'เรียบร้อย!',
                      text: 'บันทึกข้อมูล แบบ ป03 เรียบร้อย!',
                      icon: 'success',
                    });
                    this.DialogAdd = false;
                    this.showDataP03();
                  })
                  .catch((error) => {
                    console.error('Error:', error);
                  });
              },
              editData(data) { 
                axios.post('http://localhost:8000/api/edtDataP03', {
                    p01_id: data.p01_id,
                    p03_id: data.p03_id
                  })
                  .then((res) => {
                    // console.log(res.data[0].p03_estimate);
                    this.DialogAdd = true;
                    this.text_p01_id = res.data[0].p01_id;
                    this.text_edt = res.data[0].p03_id; 
                    const level_ob = this.dropdownValuesLevel.filter(f=>f.level==res.data[0].p03_estimate)
                    this.level = level_ob.length > 0 ? level_ob[0] : null;   
                    this.text_detail = res.data[0].p03_report;  
                  })
                  .catch((error) => {
                    console.error('Error:', error);
                  });
              }, 
              delData(data) { 
                Swal.fire({
                  title: 'คุณต้องการลบรายงานผลปฎิบัติราชการ ใช่หรือไม่ ?',
                  text: 'เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!',
                  icon: 'warning',
                  showCancelButton: true,
                  confirmButtonColor: '#3085d6',
                  cancelButtonColor: '#d33',
                  confirmButtonText: 'Yes, delete it!',
                }).then((result) => {
                  if (result.isConfirmed) {
                    axios.post('http://localhost:8000/api/delDataP03', {
                        p01_id: data.p01_id,
                        p03_id: data.p03_id,
                      })
                      .then((res) => {
                        // console.log(res.data);
                        this.showDataP03();
                        Swal.fire({
                          title: 'ลบข้อมูลเสร็จสิ้น!',
                          text: 'ข้อมูลของคุณถูกลบแล้ว',
                          icon: 'success',
                        });
                      })
                      .catch((error) => {
                        console.error('Error:', error);
                      });
                  }
                });
              },
              //filep03 
              OpenDialogAddfile(item) {
                // console.log(item);
                this.DialogAddfile = true;
                this.doc_p01_id = item.p01_id;
                this.doc_edt = null;
                this.doc_name = null;  
              },
              handleFileChange(event) {
                this.doc_file = event.target.files[0];
              },
              savefileData() {
                let formData = new FormData();
                formData.append('doc_edt', this.doc_edt || "");
                formData.append('doc_p01_id', this.doc_p01_id);
                formData.append('doc_name', this.doc_name);
                formData.append('doc_file', this.doc_file);

                axios.post('http://localhost:8000/api/saveDatadoc', formData, {
                  headers: {
                    'Content-Type': 'multipart/form-data'
                  }
                }) 
                .then((res) => {
                    // console.log(res.data);  
                    Swal.fire({
                      title: 'เรียบร้อย!',
                      text: 'บันทึกข้อมูลไฟล์ แบบ ป03 เรียบร้อย!',
                      icon: 'success',
                    });
                    this.DialogAddfile = false;
                    this.showDataP03();
                })
                .catch((error) => {
                  console.error('Error:', error);
                });
              }, 
              delDataDoc(data) { 
                Swal.fire({
                  title: 'คุณต้องการลบไฟล์หลักฐาน ใช่หรือไม่ ?',
                  text: 'เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!',
                  icon: 'warning',
                  showCancelButton: true,
                  confirmButtonColor: '#3085d6',
                  cancelButtonColor: '#d33',
                  confirmButtonText: 'Yes, delete it!',
                }).then((result) => {
                  if (result.isConfirmed) {
                    axios.post('http://localhost:8000/api/delDatadoc', {
                      doc_file: data.doc_file, 
                      doc_id: data.doc_id,
                      p01_id: data.p01_id,
                    })
                    .then((res) => {
                        // console.log(res.data);
                        this.showDataP03();
                        Swal.fire({
                          title: 'ลบข้อมูลเสร็จสิ้น!',
                          text: 'ข้อมูลของคุณถูกลบแล้ว',
                          icon: 'success',
                        });
                      })
                      .catch((error) => {
                        console.error('Error:', error);
                      });
                  }
                }); 
              },
              async savescorep03() {
            // console.log('Save score:', this.p01_score);
            try {
              await axios.post('http://localhost:8000/api/savescorep03', {
                p01_score: this.p01_score,
              });
            } catch (error) {
              console.error('Error saving score:', error);
            }
          },
          deletescorep03() {
            console.log('Delete score:', this.p01_score);
            try {
              axios.post('http://localhost:8000/api/deletescorep03', {
                p01_score: this.p01_score,
              });
              this.p01_score = [];
            } catch (error) {
              console.error('Error deleting score:', error);
            }
          },


            async editData(data){ 
                await axios.post('http://localhost:8000/api/edtDataP01',{
                    p01_id: data.p01_id
                }).then(res => { 
                    // console.log(res);     
                    this.DialogAdd = true;
                    this.text_edt = res.data[0].p01_id;
                    this.text_no = res.data[0].p01_no;
                    this.text_name = res.data[0].p01_subject;
                    this.text_target = res.data[0].p01_target;
                    this.text_weight = res.data[0].p01_weight; 
                    this.products_list = res.data[0].sub_ITem;
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            },
            async delData(data){  
                Swal.fire({
                    title: "คุณต้องการลบแบบ ป01 ใช่หรือไม่ ?",
                    text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Yes, delete it!"
                    }).then((result) => {
                    if (result.isConfirmed) {
                        axios.post('http://localhost:8000/api/delDataP01',{
                            p01_id: data.p01_id
                        }).then(res => { 
                            // console.log(res);   
                            this.showDataP01();
                            Swal.fire({
                            title: "ลบข้อมูลเสร็จสิ้น!",
                            text: "ข้อมูลของคุณถูกลบแล้ว",
                            icon: "success"
                            });
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        }); 
                    }
                }); 
            }, 
            

        openReportDialog(evaluator) {
          this.selectedEvaluator = evaluator;
          this.displayDialog = true;
        },
        hideDialog() {
          this.displayDialog = false;
        }
      },
      setup() {
        const router = useRouter();
        
        function navigateTo(route) {
          router.push({ path: route });
        }
        return { navigateTo };
      } 
    };
      </script>

      <style scoped>
      .assessment-container {
        width: 100%;
        padding: 20px;
      }

      .filters {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20px;
      }

      table {
        width: 100%;
        border-collapse: collapse;
      }

      thead {
        background-color: #212121;
        color: rgb(247, 244, 244);
      }

      th, td {
        padding: 10px;
        text-align: center;
        border: 1px solid #ddd;
      }

      .centered-button-cell {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100%;
      }

      img {
        width: 24px;
        height: 24px;
      }

      .report-content {
        padding: 20px;
        font-size: 16px;
      }

      .report-buttons {
        display: flex;
        justify-content: flex-end;
        margin-top: 20px;
      }

      .close-button {
        background: none;
        border: none;
        font-size: 16px;
        cursor: pointer;
      }
      .contract-details {
        font-family: Arial, sans-serif;
      }

      .employee-info{
        margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
        padding-left: 30px
      }
      .explanation p {
        margin: 10px 0;
      }

      .explanation h2 {
        margin-top: 20px;
      }
      .image-container {
        display: flex;
        justify-content: center;
      }
      .contract-image {
        width: 200px; /* Example fixed width */
        height: auto;
      }
      .explanation {
        margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
        padding-left: 30px; /* ปรับการเยื้องเข้าด้านใน */
      }
      .navbar {
        display: flex;
        justify-content: left; /* จัดปุ่มให้กึ่งกลาง */
        align-items: center; /* จัดปุ่มให้กึ่งกลางในแนวตั้ง */
        padding: 15px; /* เพิ่มระยะห่างรอบๆ แถบเมนู */
        background-color: #f5f5f5; /* สีพื้นหลังของแถบเมนู */
        border-bottom: 1px solid #ddd; /* เส้นขอบที่ด้านล่าง */
      }

      .nav-button {
        margin: 0 5px; /* ลดระยะห่างแนวนอนระหว่างปุ่ม */
        padding: 8px 16px; /* ลดระยะห่างภายในปุ่ม */
        font-size: 16px; /* ขนาดของข้อความในปุ่ม */
        border-radius: 4px; /* ลดมุมโค้งของปุ่ม */
      }
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
        background-color: #090909;
        color: white;
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
        display: none;
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
    .bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
    .content p {
      margin: 10px 0;
    }

    .signatures {
      display: flex;
      justify-content: space-between;
      margin-top: 20px;
    }
      </style>
