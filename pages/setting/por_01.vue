<template>
  <div class="col md:col-12 text-right"> 
    <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2" @click="printDataP01" />
  </div> 
  <div class="col md:col-12 text-left" v-if="totalWeight < 100">
    <small style="color: red; font-size: larger;">
        ** น้ำหนัก ความสำคัญ/ ความยากง่ายของงาน คือ {{ totalWeight }}% กรุณากรอกให้ครบ 100% เพื่อทำ แบบ ป.02 / ป03 / ป04 **
    </small>
    </div>
      <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
          <div class="card mb-0">
            <div class="formgroup-inline mb-1">
              <div class="col md:col-5">
                <h3 class="mb-4 card-header">
                  <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i>
                  แบบ ป01
                </h3>
              </div> 
              <div class="col md:col-7">
                <div v-if="currentDate < dataPor.d_recordingday">
                  <Button
                    icon="pi pi-search"
                    severity="help"
                    class="mb-2 mr-6"
                    label="เลือกข้อมูลแบบประเมิน ป.01"
                    @click="OpenDialogP01"
                  />
                  <Button
                    icon="pi pi-plus"
                    severity="info"
                    class="mb-2 mr-6"
                    label="เพิ่มข้อมูลแบบประเมิน"
                    @click="OpenDialogAdd"
                  /> 
                  <Button
                    icon="pi pi-copy"
                    severity="primary"
                    class="mb-2 mr-6"
                    label="คัดลอกข้อมูลแบบประเมิน"
                    @click="copyEvaluationData"
                  />
                </div>
              </div>
            </div>

            <table class="table">
              <thead>
                <tr>
                  <th rowspan="2" style="width: 20%;">(1) <br /> กิจกรรม / โครงการ / งาน</th>
                  <th rowspan="2" style="width: 24%;">
                    (2) <br /> ตัวชี้วัด / เกณฑ์การประเมิน <br />
                    (1.ถูกต้อง 2.ครบถ้วน <br /> 3.ตรงเวลา)
                  </th>
                  <th colspan="5" style="width: 15%;">(3) <br /> ระดับค่าเป้าหมาย</th>
                  <th rowspan="2" style="width: 7%;">(4) <br /> ค่าคะแนน ที่ได้</th>
                  <th rowspan="2" style="width: 10%;">(5) <br /> น้ำหนัก (ความสำคัญ/ <br /> ความยากง่ายของงาน)</th>
                  <th rowspan="2" style="width: 10%;">(6) <br /> ค่าคะแนน <br />ถ่วงน้ำหนัก <br /> (4) X (5) 100</th>
                  <th rowspan="2" style="width: 9%;"><br /> ตัวเลือก <br /></th>
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
                      <b style="color: blue;">{{ h.h_no }}. {{ h.nameH }}</b>
                    </td>
                    <td class="text-center" style="color: blue;">
                      <b>{{ h.p01_weight ?? 0 }}%</b>
                    </td>
                    <td></td>
                    <td></td>
                  </tr>

                  <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                    <!-- <td style="text-align: left;">
                      {{ subP01.p01_no }} {{ subP01.p01_subject }}
                    </td> -->

                    <!-- <td style="text-align:left;">
                      <template v-for="(ln, i) in parseActivityText(subP01.p01_subject).lines" :key="i">
                        <div :style="{ paddingLeft: ln.indent + 'px' }">
                          <b v-if="ln.type === 'main'">{{ ln.text }}</b>
                          <span v-else>• {{ ln.text }}</span>
                        </div>
                      </template>
                    </td> -->

                  <td style="text-align:left;">
                      <template v-for="(ln, i) in parseActivityText(subP01.p01_subject).lines" :key="i"> 
                        <div v-if="ln.type === 'main'" style="font-weight:700; margin-bottom:4px;">
                          {{ ln.text }}
                        </div>  
                        <div v-else class="subline">
                          <span class="subno">{{ ln.no }}</span>
                          <span class="subtext">{{ ln.text }}</span>
                        </div> 
                      </template>
                    </td>
    
                    <td style="text-align: left;">
                      <!-- <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ subP01.p01_subject }}</b> -->
                      <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ getMainSubject(subP01.p01_subject) }}</b>

                      <div
                        v-for="(subIitem, idI) in subP01.subITems"
                        :key="idI"
                        style="padding-left: 8px; margin-bottom: 5px;"
                      >
                        <span v-if="subIitem.ind_no != 0">
                          <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                        </span>
                        <span v-else>
                          <b>{{ subIitem.ind_Items }}</b>
                        </span>
                      </div>
                    </td>

                    <td style="vertical-align: top;" class="text-center">
                      <b v-if="subP01.p01_target == 1">&#10003;</b>
                    </td>
                    <td style="vertical-align: top;" class="text-center">
                      <b v-if="subP01.p01_target == 2">&#10003;</b>
                    </td>
                    <td style="vertical-align: top;" class="text-center">
                      <b v-if="subP01.p01_target == 3">&#10003;</b>
                    </td>
                    <td style="vertical-align: top;" class="text-center">
                      <b v-if="subP01.p01_target == 4">&#10003;</b>
                    </td>
                    <td style="vertical-align: top;" class="text-center">
                      <b v-if="subP01.p01_target == 5">&#10003;</b>
                    </td>

                    <td style="vertical-align: top;" class="text-center">
                      <div v-if="currentDate >= dataPor.d_scoringday">
                        {{ subP01.p01_score }}
                      </div>
                      <div v-else>0</div>
                    </td>

                    <td style="vertical-align: top;" class="text-center">
                      {{ safeNumber(subP01.p01_weight) }}%
                    </td>

                    <td style="vertical-align: top;" class="text-center">
                      <div v-if="currentDate >= dataPor.d_scoringday">
                        {{ ((safeNumber(subP01.p01_score) * safeNumber(subP01.p01_weight)) / 100).toFixed(2) }}
                      </div>
                      <div v-else>0.00</div>
                    </td>
                    <!-- middle ตรงกลาง -->
                    <td style="vertical-align: top;" class="text-center">
                      <div v-if="currentDate < dataPor.d_recordingday">
                        <SplitButton
                          label="เลือก"
                          :model="itemsBtu(subP01)"
                          severity="warning"
                          class="mb-2 mr-2"
                        />
                      </div>
                      <div v-else style="color: brown; font-weight: bold; text-align: center;">
                        ครบกำหนดวันบันทึก ป.01
                      </div>
                    </td>
                  </tr>
                </template>

                <tr>
                  <td style="text-align: right" colspan="8">
                    <b style="color: blue;">(7) ผลรวม</b>
                  </td>
                  <td class="text-center" style="color: blue;">
                    <b>{{ totalWeight }}%</b>
                  </td>
                  <td class="text-center" style="color: blue;">
                    <div v-if="currentDate >= dataPor.d_scoringday">
                      <b>{{ totalCalculatedScore }}</b>
                    </div>
                    <div v-else><b>0</b></div>
                  </td>
                  <td></td>
                </tr>

                <tr>
                  <td style="text-align: center; vertical-align: middle;" colspan="9">
                    <b style="color: blue;">
                      (8) สรุปคะแนนส่วนผลสัมฤทธิ์ของงาน =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </b>
                    <b style="color: blue;">ผลรวมของค่าคะแนนถ่วงน้ำหนัก</b>

                    <b style="display: block; text-align: right; color: blue;">
                      {{ currentDate >= dataPor.d_scoringday ? totalCalculatedScore : 0 }}
                    </b>

                    <div style="display: flex; justify-content: flex-end;">
                      <hr style="border: 1px solid black; width: 80%;" />
                    </div>

                    <b style="display: block; text-align: right; color: blue;">{{ 5 }}</b>
                    <b style="color: blue;">จำนวนระดับค่าเป้าหมาย = 5</b>
                  </td>

                  <td class="text-center" style="color: blue; vertical-align: middle;">
                    <div v-if="currentDate >= dataPor.d_scoringday">
                      <b>= {{ WeightedScoreSum }}</b>
                    </div>
                  </td>
                  <td></td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

    <!-- เลือกข้อมูลแบบประเมิน ป.01 -->
    <Dialog
      header="จัดการแบบ ป01" maximizable v-model:visible="DialogAddP01" :breakpoints="{ '960px': '75vw' }" :style="{ width: '90vw' }" :modal="true" position="top" > 
      <form>
        <div class="p-fluid formgrid grid">
          <div class="field col-12 md:col-12">
            <table class="table">
              <thead>
                <tr>
                  <th rowspan="2" style="width: 9%;">
                    <br /> ตัวเลือก <br />
                    <Checkbox v-model="selectAll" @change="toggleSelectAll" />
                  </th>
                  <th rowspan="2" style="width: 20%;">(1) <br /> กิจกรรม / โครงการ / งาน</th>
                  <th rowspan="2" style="width: 24%;">
                    (2) <br /> ตัวชี้วัด / เกณฑ์การประเมิน <br />
                    (1.ถูกต้อง 2.ครบถ้วน <br /> 3.ตรงเวลา)
                  </th>
                  <th colspan="5" style="width: 15%;">(3) <br /> ระดับค่าเป้าหมาย</th>
                  <th rowspan="2" style="width: 7%;">(4) <br /> ค่าคะแนน ที่ได้</th>
                  <th rowspan="2" style="width: 10%;">(5) <br /> น้ำหนัก (ความสำคัญ/ <br /> ความยากง่ายของงาน)</th>
                  <th rowspan="2" style="width: 10%;">(6) <br /> ค่าคะแนน <br />ถ่วงน้ำหนัก <br /> (4) X (5) 100</th>
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
                  <tr>
                    <td style="text-align: left;" colspan="8">
                      <b style="color: blue;">{{ item.h_no }}. {{ item.nameH }}</b>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>

                  <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;">
                    <td class="text-center">
                      <Checkbox
                        :id="'checkOption-' + subP01.p_id"
                        :name="'option-' + subP01.p_id"
                        :value="subP01.p_id"
                        v-model="checkboxValue"
                      />
                    </td>

                    <td style="text-align: left;">
                      {{ subP01.p_no }} {{ subP01.p_subject }}
                    </td>

                    <td style="text-align: left;">
                      <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ subP01.p_subject }}</b>
                      <div
                        v-for="(subIitem, idI) in subP01.subITems"
                        :key="idI"
                        style="padding-left: 8px; margin-bottom: 5px;"
                      >
                        <span v-if="subIitem.ind_no != 0">
                          <b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}
                        </span>
                        <span v-else>
                          <b>{{ subIitem.ind_Items }}</b>
                        </span>
                      </div>
                    </td>

                    <td class="text-center"><b v-if="subP01.p_target == 1">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 2">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 3">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 4">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 5">&#10003;</b></td>

                    <td class="text-center">{{ safeNumber(subP01.p_score) }}</td>
                    <td class="text-center">{{ safeNumber(subP01.p_weight) }}%</td>
                    <td class="text-center">
                      {{ ((safeNumber(subP01.p_score) * safeNumber(subP01.p_weight)) / 100).toFixed(2) }}
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>
      </form>

      <template #footer>
        <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="savetablechkem" />
        <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialogs" />
      </template>
    </Dialog>

    <!-- เพิ่มข้อมูลแบบประเมิน -->
    <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top" >
      <form>
        <div class="p-fluid formgrid">
          <form>
            <InputText v-model="text_edt" type="hidden" /> 
            <div class="p-fluid formgrid grid">
              <div class="field col-12 md:col-4">
                <label for="dropdownItemH">ประเภทภาระงาน</label>
                <Dropdown
                  id="dropdownItemH"
                  v-model="dropdownItemH"
                  :options="dropdownItemsH"
                  optionLabel="nameH"
                  placeholder="เลือกประเภทภาระงาน"
                />
              </div>

              <div class="field col-12 md:col-2">
                <label for="text_no">ข้อที่</label>
                <InputGroup>
                  <InputGroupAddon><i class="pi pi-calendar-plus"></i></InputGroupAddon>
                  <InputText v-model="text_no" type="text" placeholder="ข้อ" autocomplete="off" />
                </InputGroup>
              </div>

              <div class="field col-12 md:col-6">
                <label for="text_name">ชื่อกิจกรรม / โครงการ / งาน</label>
                <InputGroup>
                  <InputGroupAddon><i class="pi pi-book"></i></InputGroupAddon>
                  <Textarea v-model="text_name" rows="1" placeholder="ชื่อกิจกรรม / โครงการ / งาน" autocomplete="off" />
                </InputGroup>
              </div>

              <div class="field col-12 md:col-3">
                <label for="text_target">ระดับค่าเป้าหมาย</label>
                <Dropdown
                  id="dropdownItemTarget"
                  v-model="dropdownItemTarget"
                  :options="dropdownItemsTarget"
                  optionLabel="name"
                  placeholder="เลือกระดับค่าเป้าหมาย"
                />
              </div>

              <div class="field col-12 md:col-4">
                <label for="text_weight">น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)</label>
                <InputGroup>
                  <InputGroupAddon><i class="pi pi-tags"></i></InputGroupAddon>
                  <InputText
                    v-model.number="text_weight"
                    type="number"
                    placeholder="น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)"
                    autocomplete="off"
                    step="0.01"
                  />
                </InputGroup>
              </div>
            </div> 
            <!-- <hr /> 
            <div class="p-fluid formgrid grid">
              <div class="field col-12 md:col-12">
                <label for="text_search_no">เกณฑ์การประเมิน</label>
                <InputGroup>
                  <InputText v-model="text_search_no" type="number" :min="0" :max="5" placeholder="ระดับ" autocomplete="off" class="col-12 md:col-2" />
                  <InputText v-model="text_search" type="text" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off" />
                  <Button icon="pi pi-plus" label="เพิ่ม" severity="warning" @click.prevent="AddDatalist" />
                </InputGroup>
              </div>
            </div> --> 

            <hr />
              <div class="p-fluid formgrid grid"> 
                <div class="field col-12">
                  <div class="grid align-items-center"> 
                    <div class="col-11">
                      <label>
                        เกณฑ์การประเมิน (เพิ่มได้สูงสุด 5 แถว แล้วกด “เพิ่ม”)
                      </label>
                    </div>  
                    <div class="col-1 text-right">
                      <Button icon="pi pi-plus" label="เพิ่มแถว" severity="info" :disabled="criteriaDrafts.length >= maxCriteriaRows" @click.prevent="addCriteriaRow" />
                    </div>
                    &nbsp;
                  </div> 
                   <div v-for="(row, idx) in criteriaDrafts" :key="idx" class="mb-3 grid align-items-center" >
                    <div class="col-12 md:col-2">
                      <InputText v-model.number="row.ind_no" type="number" placeholder="ระดับ" class="w-full" />
                    </div> 
                    <div class="col-12 md:col-9">
                      <InputText v-model="row.ind_Items" placeholder="รายละเอียดเกณฑ์การประเมิน" class="w-full" />
                    </div> 
                    <div class="col-12 md:col-1 text-center">
                      <Button icon="pi pi-trash" severity="danger" class="p-button-text" rounded outlined :disabled="criteriaDrafts.length === 1"  @click.prevent="removeCriteriaRow(idx)" />
                    </div>
                  </div>

                  <div class="grid justify-content-center mt-3">
                    <div class="col-12 md:col-1 text-center">
                      <Button icon="pi pi-check" label="เพิ่ม" severity="warning" @click.prevent="commitCriteriaDrafts" class="w-full" />
                    </div>
                  </div> 
                  <small class="text-500">
                    ตอนนี้มี {{ criteriaDrafts.length }} / {{ maxCriteriaRows }} แถว
                  </small>
                </div>
              </div> 
            <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
              <Column field="ind_no" header="ระดับ" style="width: 10%">
                <template #body="Item">ระดับที่ {{ Item.data.ind_no }}</template>
              </Column> 
              <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="text-align: left;width: 80%">
                <template #body="Item">{{ Item.data.ind_Items }}</template>
              </Column> 
              <Column field="options" header="ตัวเลือก" style="text-align: center; width: 10%">
                <template #body="Item">
                  <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="EditRegislick(Item.data)" />
                  &nbsp;
                  <Button style="text-align: center;" severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)" />
                </template>
              </Column>
            </DataTable>
          </form>
        </div>
      </form> 
      <template #footer>
        <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDatax" />
        <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialog" />
      </template>
    </Dialog>
 
    <!-- คัดลอกข้อมูลแบบประเมิน -->
    <Dialog header="คัดลอกข้อมูลแบบประเมิน ป01" v-model:visible="DialogCopy" :modal="true" :dismissableMask="true" :draggable="false" :breakpoints="{ '960px': '75vw' }" :style="{ width: '95vw' }" >
      <div class="copy-dialog">
        <div class="grid align-items-start">
          <div class="col-12 md:col-8">
            <div class="copy-title">
              <div class="copy-title-main">เลือกปีงบประมาณและรอบประเมินที่ต้องการคัดลอก</div>
            </div>
            <div class="copy-note">
              * เลือกปี/รอบที่เคยบันทึกแบบ ป01 ไว้ แล้วคัดลอกมาใช้ใน
              ปี {{ dataPor.d_date }} รอบที่ {{ dataPor.evalua }}
            </div>
          </div> 
          <div class="col-12 md:col-4">
            <label class="copy-dd-label">เลือกรอบประเมินที่ต้องการคัดลอก</label>
            <Dropdown v-model="selectedEvalRound" :options="evalRoundOptions" optionLabel="label" placeholder="เลือกรอบ" class="w-full" :showClear="true" :disabled="loadingRounds" />
          </div>
        </div> 
        <!-- โหลดรอบ -->
        <div v-if="loadingRounds" class="copy-loading">
          <i class="pi pi-spin pi-spinner mr-2"></i> กำลังโหลดข้อมูล...
        </div>

        <div v-else-if="!evalRounds || evalRounds.length === 0" class="copy-empty">
          ไม่พบรอบประเมินที่สามารถคัดลอกได้
        </div> 
        <!-- เมื่อเลือกรอบแล้ว ให้โหลดรายการต้นทาง -->
        <div v-if="selectedEvalRound" class="mt-3">
          <div v-if="loadingCopyItems" class="copy-loading">
            <i class="pi pi-spin pi-spinner mr-2"></i> กำลังโหลดรายการต้นทาง...
          </div>

          <div v-else-if="!products_personCopy || products_personCopy.length === 0" class="copy-empty">
            ไม่พบข้อมูลที่เคยบันทึกไว้ในรอบที่เลือก
          </div> 
          <div v-else>
            <div class="mb-2" style="display:flex; gap:.75rem; align-items:center;">
              <Checkbox v-model="selectAllCopy" @change="toggleSelectAllCopy" />
              <span style="font-weight:600;">เลือกทั้งหมด</span>

              <span style="margin-left:auto; color:#666;">
                เลือกแล้ว {{ checkboxValueCopy.length }} รายการ
              </span>
            </div>

            <table class="table">
              <thead>
                <tr>
                  <th rowspan="2" style="width: 9%;">ตัวเลือก</th>
                  <th rowspan="2" style="width: 20%;">(1) กิจกรรม / โครงการ / งาน</th>
                  <th rowspan="2" style="width: 24%;">(2) ตัวชี้วัด / เกณฑ์การประเมิน</th>
                  <th colspan="5" style="width: 15%;">(3) ระดับค่าเป้าหมาย</th>
                  <th rowspan="2" style="width: 7%;">(4) คะแนน</th>
                  <th rowspan="2" style="width: 10%;">(5) น้ำหนัก</th>
                  <th rowspan="2" style="width: 10%;">(6) ถ่วงน้ำหนัก</th>
                </tr>
                <tr>
                  <th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>
                </tr>
              </thead>

              <tbody>
                <template v-for="(h, hi) in products_personCopy" :key="hi">
                   <tr>
                    <td style="text-align:left" colspan="5">
                      <b style="color: blue;">ต้นทาง: {{ h.h_no }}. {{ h.nameH }}</b>
                    </td> 
                    <td colspan="6" style="text-align:left">
                      <span style="font-weight:600;">ย้ายไปอยู่ใต้ (ปีปัจจุบัน):</span>
                      <Dropdown v-model="mapH[h.h_id]" :options="targetHOptions" optionLabel="nameH" optionValue="id" placeholder="เลือก nameH ปลายทาง" class="w-full" :showClear="true" />
                    </td>
                  </tr>

                  <tr
                    v-for="(subP01, idx) in h.subP01s"
                    :key="subP01.p_id"
                    style="vertical-align: baseline;"
                  >
                    <td class="text-center">
                      <Checkbox :value="subP01.p_id" v-model="checkboxValueCopy" />
                    </td>

                    <td style="text-align:left">
                      {{ subP01.p_no }} {{ subP01.p_subject }}
                    </td>

                    <td style="text-align:left">
                      <b>ตัวชี้วัดที่ {{ idx + 1 }} {{ subP01.p_subject }}</b>
                      <div
                        v-for="(it, i2) in subP01.subITems"
                        :key="i2"
                        style="padding-left: 8px; margin-bottom: 5px;"
                      >
                        <span v-if="it.ind_no != 0">
                          <b>ระดับ {{ it.ind_no }}</b> {{ it.ind_Items }}
                        </span>
                        <span v-else>
                          <b>{{ it.ind_Items }}</b>
                        </span>
                      </div>
                    </td>

                    <td class="text-center"><b v-if="subP01.p_target == 1">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 2">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 3">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 4">&#10003;</b></td>
                    <td class="text-center"><b v-if="subP01.p_target == 5">&#10003;</b></td>

                    <td class="text-center">{{ safeNumber(subP01.p_score) }}</td>
                    <td class="text-center">{{ safeNumber(subP01.p_weight) }}%</td>
                    <td class="text-center">
                      {{ ((safeNumber(subP01.p_score) * safeNumber(subP01.p_weight)) / 100).toFixed(2) }}
                    </td>
                  </tr>
                </template>
              </tbody>
            </table> 
            <div class="grid mt-2 align-items-center">
              <div class="col-12 md:col-6">
                <div style="display:flex; gap:.75rem; align-items:center;">
                  <Checkbox v-model="overwriteCopy" :binary="true" />
                  <span>ทับข้อมูลปลายทางก่อนคัดลอก</span>
                </div>
              </div>

              <!-- <div class="col-12 md:col-6">
                <label class="copy-dd-label mt-2">
                  **กรุณา** เลือกประเภทภาระงาน ของปีปัจจุบัน
                </label>
                  <Dropdown v-model="selectedTargetH" :options="targetHOptions" optionLabel="nameH" optionValue="id" placeholder="เลือก ประเภทภาระงาน ปลายทาง" class="w-full" :showClear="true" :disabled="loadingTargetH" />
              </div> -->
            </div>
          </div>
        </div>
      </div> 
      <template #footer>
        <div class="copy-footer">
          <Button label="บันทึก" icon="pi pi-check" class="p-button-success" :disabled=" !selectedEvalRound || loadingRounds || loadingCopyItems || checkboxValueCopy.length === 0 || !selectedTargetH "  @click="confirmCopyEvaluation" />
          <Button label="ยกเลิก" icon="pi pi-times" severity="danger" @click="cancelDialogcopy" />
        </div>
      </template>
    </Dialog> 
    <!-- จบการคัดลอกข้อมูลแบบประเมิน -->


    <!-- แก้ไขข้อมูลเกณฑ์การประเมิน -->
    <Dialog
      header="แก้ไขข้อมูลเกณฑ์การประเมิน"
      maximizable
      v-model:visible="DialogEditList"
      :breakpoints="{ '960px': '75vw' }"
      :style="{ width: '70vw' }"
      :modal="true"
      position="top"
    >
      <form>
        <div class="p-fluid formgrid">
          <form>
            <div class="p-fluid formgrid grid">
              <div class="field col-12 md:col-12">
                <label for="text_search_no">เกณฑ์การประเมิน</label>
              </div>

              <div class="field col-9 md:col-3">
                <label for="text_search_no">ระดับ</label>
                <InputText v-model="text_search_noEdit" type="number" placeholder="ระดับ" autocomplete="off" disabled />
              </div>

              <div class="field col-3 md:col-9">
                <label for="text_search_no">รายละเอียดเกณฑ์การประเมิน</label>
                <InputText v-model="text_searchEdit" type="text" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off" />
              </div>
            </div>
          </form>
        </div>
      </form>

      <template #footer>
        <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataxEdit" />
        <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="cancelDialogEdit" />
      </template>
    </Dialog>
  </div>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";

export default {
  props: {
    dataPor: { type: Object, required: true },
  },
  emits: ["weight-changed"],
  data() {
    return {
      staffid_Main: null,
      facid_Main: null,
      groupid_Main: null,

      currentDate: new Date().toISOString().split("T")[0],

      products_personX: [],
      products_person: [],

      checkboxValue: [],
      selectAll: false,

      DialogAdd: false,
      DialogAddP01: false,

      DialogAddcopy: false,

      DialogCopy: false,
      evalRounds: [],
      selectedEvalRound: null,
      loadingRounds: false,

      products_personCopy: [],     // รายการต้นทางที่โหลดมาโชว์
      checkboxValueCopy: [],       // p_id ที่เลือกคัดลอก
      selectAllCopy: false,
      loadingCopyItems: false,
      overwriteCopy: true,  

      //  nameH ของปี/รอบปัจจุบัน (ปลายทาง)
      targetHOptions: [],
      loadingTargetH: false,
      selectedTargetH: null,   // เลือกปลายทางแบบรวม (ถ้าต้องการ) 
      mapH: {},

      criteriaDrafts: [{ ind_no: null, ind_Items: "" }],
        maxCriteriaRows: 5,



      // Dialog add/edit
      text_edt: null,
      dropdownItemH: null,
      dropdownItemsH: [],
      text_no: null,
      text_name: null,
      dropdownItemTarget: null,
      dropdownItemsTarget: [
        { name: "ระดับเป้าหมาย 1", value: 1 },
        { name: "ระดับเป้าหมาย 2", value: 2 },
        { name: "ระดับเป้าหมาย 3", value: 3 },
        { name: "ระดับเป้าหมาย 4", value: 4 },
        { name: "ระดับเป้าหมาย 5", value: 5 },
      ],
      text_weight: null,
      text_search_no: null,
      text_search: null,
      products_list: [],

      // edit list
      DialogEditList: false,
      text_search_noEdit: null,
      text_searchEdit: null,
    };
  },

  async mounted() {
    const { getSession } = await useAuth();
    const user = await getSession();

    const { STAFFID, SCOPES } = user.user.name;
    const { staffdepartment, groupid } = SCOPES;

    await this.setSession(STAFFID, staffdepartment, groupid);
  },

  watch: {
    dataPor: {
      handler() {
        this.showDataPerson();
      },
      deep: true,
    },

    checkboxValue(newVal) {
      const totalItems = (this.products_person || []).flatMap((item) => item.subP01s || []).length;
      this.selectAll = newVal.length === totalItems;
    },

    // ✅ ให้ parent ได้ค่าแน่นอน + เตือน >100 ที่นี่แทน computed
    totalWeight: {
      handler(val) {
        const num = Number(val || 0);
        this.$emit("weight-changed", num);

        if (num > 100) {
          Swal.fire({
            icon: "warning",
            title: "คะแนนเกินกำหนด",
            text: "คะแนนรวมเกิน 100% กรุณาปรับค่าใหม่!",
          });
        }
      },
      immediate: true,
    }, 

    selectedEvalRound: {
      handler(val) {
        if (!val) {
          this.products_personCopy = [];
          this.checkboxValueCopy = [];
          this.selectAllCopy = false;
          return;
        }
        this.loadCopyItems();
      },
      deep: true,
    },

    // ✅ เพิ่มใหม่: sync ปุ่มเลือกทั้งหมด
    checkboxValueCopy(newVal) {
      const totalItems = (this.products_personCopy || [])
        .flatMap(h => h.subP01s || []).length;
      this.selectAllCopy = totalItems > 0 && newVal.length === totalItems;
    },


  },

  computed: {
    totalWeight() {
      const total = (this.products_personX || []).reduce((sum, h) => {
        return (
          sum +
          (h.subP01sX || []).reduce((s2, sub) => {
            return s2 + this.safeNumber(sub.p01_weight);
          }, 0)
        );
      }, 0);

      return Number(total.toFixed(2));
    },

    totalCalculatedScore() {
      const total = (this.products_personX || []).reduce((sum, h) => {
        return (
          sum +
          (h.subP01sX || []).reduce((s2, sub) => {
            return s2 + (this.safeNumber(sub.p01_score) * this.safeNumber(sub.p01_weight)) / 100;
          }, 0)
        );
      }, 0);

      return total.toFixed(2);
    },

    WeightedScoreSum() {
      const total = (this.products_personX || []).reduce((sum, h) => {
        return (
          sum +
          (h.subP01sX || []).reduce((s2, sub) => {
            return s2 + ((this.safeNumber(sub.p01_score) * this.safeNumber(sub.p01_weight)) / 100) / 5;
          }, 0)
        );
      }, 0);

      return total.toFixed(2);
    },
    evalRoundOptions() {
      return (this.evalRounds || []).map((r) => {
        const evalua = String(r.evalua);
        const year = String(r.year);

        return {
          ...r,
          label: `ปี ${year} | รอบที่ ${evalua} (${this.getRoundDesc(evalua)})`,
        };
      });
    },


  },

  methods: {
    safeNumber(v) {
      const n = parseFloat(v);
      return Number.isFinite(n) ? n : 0;
    },

    itemsBtu(item) {
      return [
        {
          label: "แก้ไขข้อมูล",
          icon: "pi pi-refresh",
          command: () => this.editDatax(item),
        },
        {
          label: "ลบข้อมูล",
          icon: "pi pi-times",
          command: () => this.delDatax(item),
        },
      ];
    },

    setSession(staffid_Main, facid_Main, groupid_Main) {
      this.staffid_Main = staffid_Main;
      this.facid_Main = facid_Main;
      this.groupid_Main = groupid_Main;
    },

    async showDataPerson() {
      if (!this.dataPor || !this.dataPor.d_date || !this.dataPor.evalua) return;

      axios
        .post("http://127.0.0.1:8000/api/showDataPersonX", {
          staff_id: this.staffid_Main,
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,
          evalua: this.dataPor.evalua,
        })
        .then((res) => {
          this.products_personX = res.data || [];

          // ✅ สำคัญ: ยิงค่าไป parent หลัง set data จริง
          this.$nextTick(() => {
            this.$emit("weight-changed", Number(this.totalWeight || 0));
          });
        })
        .catch((error) => console.error("Error:", error));
    },

    async printDataP01() {
      const { getSession } = await useAuth();
      const user = await getSession();

      const form = {
        staff_id: this.staffid_Main,
        group_id: this.groupid_Main,
        fac_id: this.dataPor.fac_id,
        year_id: this.dataPor.d_date,
        evalua: this.dataPor.evalua,
        PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
        STAFFNAME: user.user.name.STAFFNAME,
        STAFFSURNAME: user.user.name.STAFFSURNAME,
        POSITIONNAME: user.user.name.POSITIONNAME,
        GROUPTYPENAME: user.user.name.GROUPTYPENAME,
        POSTYPENAME: user.user.name.POSTYPENAME,
        SCOPES: user.user.name.SCOPES.staffdepartmentname,
      };

      const queryParams = new URLSearchParams(form).toString();
      const url = `http://127.0.0.1:8000/report_p01?${queryParams}`;
      window.open(url, "_blank");
    },

    OpenDialogP01() {
      axios
        .post("http://127.0.0.1:8000/api/showDataPerson", {
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,
          evalua: this.dataPor.evalua,
        })
        .then((res) => {
          this.DialogAddP01 = true;
          this.products_person = res.data || [];
          this.checkboxValue = [];
        })
        .catch((error) => console.error("Error:", error));
    },

    async savetablechkem() {
      let x = [];
      (this.products_person || []).forEach((v) => {
        const selected = (v.subP01s || []).filter((item) => this.checkboxValue.includes(item.p_id));
        x = x.concat(selected);
      });

      if (x.length === 0) {
        Swal.fire("ไม่มีข้อมูล", "กรุณาเลือกข้อคำถามจาก ตัวจัดการ !", "error");
        return;
      }

      try {
        await axios.post("http://127.0.0.1:8000/api/savePushDataP01", {
          data: x,
          staffid_Main: this.staffid_Main,
        });

        this.showDataPerson();
        this.DialogAddP01 = false;

        Swal.fire({
          title: "เรียบร้อย!",
          text: "บันทึกข้อมูล แบบจัดการ ป01 เรียบร้อย!",
          icon: "success",
        });
      } catch (error) {
        console.error("Error:", error);
      }
    },

    cancelDialogs() {
      this.DialogAddP01 = false;
    },

    OpenDialogAdd() {
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
      this.selectDataH();
      this.criteriaDrafts = [{ ind_no: null, ind_Items: "" }];
    },

     OpenDialogAddcopy() {
      this.DialogAddcopy = true;
      this.text_edt = null;
      this.dropdownItemH = null;
      this.text_no = null;
      this.text_name = null;
      this.dropdownItemTarget = null;
      this.text_weight = null;
      this.text_search_no = null;
      this.text_search = null;
      this.products_list = [];
      this.selectDataH();
      this.criteriaDrafts = [{ ind_no: null, ind_Items: "" }];
    },

    selectDataH() {
      axios
        .post("http://127.0.0.1:8000/api/selectDataPersonH", {
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,
          evalua: this.dataPor.evalua,
        })
        .then((res) => {
          this.dropdownItemsH = res.data || [];
        })
        .catch((error) => console.error("Error:", error));
    },

    AddDatalist() {
      if (this.text_search_no == null || this.text_search == null || this.text_search === "") {
        Swal.fire("ไม่มีข้อมูล", "กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!", "error");
        return;
      }

      this.products_list.push({
        ind_no: this.text_search_no,
        ind_Items: this.text_search,
      });

      this.products_list.sort((a, b) => Number(a.ind_no) - Number(b.ind_no));
      this.text_search_no = null;
      this.text_search = null;
    },

    DeleteRegislick(indNo) {
      this.products_list = (this.products_list || []).filter((p) => p.ind_no !== indNo);
    },

    EditRegislick(data) {
      this.text_search_noEdit = null;
      this.text_searchEdit = null;

      if (data) {
        this.DialogEditList = true;
        this.text_search_noEdit = data.ind_no;
        this.text_searchEdit = data.ind_Items;
      }
    },

    cancelDialogEdit() {
      this.DialogEditList = false;
    },

    saveDataxEdit() {
      const updated = { ind_no: this.text_search_noEdit, ind_Items: this.text_searchEdit };
      const index = (this.products_list || []).findIndex((i) => i.ind_no === this.text_search_noEdit);

      if (index !== -1) this.products_list[index] = updated;
      this.DialogEditList = false;
    },

    //บิวแก้100269
    // async saveDatax() {
    //   const errors = this.validateBeforeSave();
    //   if (errors.length > 0) {
    //     Swal.fire({
    //       icon: "warning",
    //       title: "ข้อมูลยังไม่ครบ",
    //       html: `<div style="text-align:left">${errors.map(e => `• ${e}`).join("<br>")}</div>`,
    //       confirmButtonText: "ตกลง",
    //     });
    //     return;
    //   }

    //   try {
    //     await axios.post("http://127.0.0.1:8000/api/saveDataP01User", {
    //       staff_id: this.staffid_Main,
    //       fac_id: this.dataPor.fac_id,
    //       year_id: this.dataPor.d_date,
    //       evalua: this.dataPor.evalua,
    //       text_edt: this.text_edt,
    //       dropdownItemH: this.dropdownItemH?.id,
    //       text_no: this.text_no,
    //       text_name: this.text_name,
    //       text_target: this.dropdownItemTarget?.value,
    //       text_weight: this.text_weight,
    //       products_list: this.products_list,
    //     });

    //     this.DialogAdd = false;
    //     this.showDataPerson();

    //     Swal.fire({
    //       title: "เรียบร้อย!",
    //       text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
    //       icon: "success",
    //     });
    //   } catch (error) {
    //     console.error("Error:", error);
    //   }
    // },

    async saveDatax() {
      const errors = this.validateBeforeSave();
      if (errors.length > 0) {
        Swal.fire({
          icon: "warning",
          title: "ข้อมูลยังไม่ครบ",
          html: `<div style="text-align:left">${errors.map(e => `• ${e}`).join("<br>")}</div>`,
          confirmButtonText: "ตกลง",
        });
        return;
      }

      // ✅ เพิ่ม: แยกหัวข้อหลักจาก text_name
      const parsed = this.parseActivityText(this.text_name);

      try {
        await axios.post("http://127.0.0.1:8000/api/saveDataP01User", {
          staff_id: this.staffid_Main,
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,
          evalua: this.dataPor.evalua,
          text_edt: this.text_edt,
          dropdownItemH: this.dropdownItemH?.id,
          text_no: this.text_no,

          // ✅ เดิม: เก็บ raw ทั้งหมด (รวมข้อย่อย)
          text_name: this.text_name,

          // ✅ เพิ่มใหม่: เก็บเฉพาะหัวข้อหลัก (บรรทัดแรก) เอาไปใช้โชว์ที่อื่น
          text_name_main: parsed.mainTitle,

          text_target: this.dropdownItemTarget?.value,
          text_weight: this.text_weight,
          products_list: this.products_list,
        });

        this.DialogAdd = false;
        this.showDataPerson();

        Swal.fire({
          title: "เรียบร้อย!",
          text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
          icon: "success",
        });
      } catch (error) {
        console.error("Error:", error);
      }
    },
 
    cancelDialog() {
      this.DialogAdd = false;
    },
    cancelDialogcopy() {
      this.DialogAddcopy = false;
    },

    async editDatax(data) {
      try {
        const res = await axios.post("http://127.0.0.1:8000/api/edtDataPersonx", { p01_id: data.p01_id });

        const row = (res.data && res.data[0]) || null;
        if (!row) return;

        this.DialogAdd = true;
        this.text_edt = row.p01_id;
        this.text_no = row.p01_no;
        this.text_name = row.p01_subject;

        const target_f = this.dropdownItemsTarget.filter((f) => f.value == row.p01_target);
        this.dropdownItemTarget = target_f.length > 0 ? target_f[0] : null;

        this.text_weight = row.p01_weight;
        this.products_list = row.sub_ITem || [];

        await this.selectDataHEdt(row.p01_h);
      } catch (error) {
        console.error("Error:", error);
      }
    },

    async selectDataHEdt(he) {
      try {
        const res = await axios.post("http://127.0.0.1:8000/api/selectDataPersonH", {
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,
          evalua: this.dataPor.evalua,
        });

        this.dropdownItemsH = res.data || [];
        const h_f = this.dropdownItemsH.filter((f) => f.id == he);
        this.dropdownItemH = h_f.length > 0 ? h_f[0] : null;
      } catch (error) {
        console.error("Error:", error);
      }
    },

    async delDatax(data) {
      Swal.fire({
        title: "คุณต้องการลบแบบ ป01 ใช่หรือไม่ ?",
        text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, delete it!",
      }).then(async (result) => {
        if (!result.isConfirmed) return;

        try {
          await axios.post("http://127.0.0.1:8000/api/delDataPersonx", { p01_id: data.p01_id });
          this.showDataPerson();

          Swal.fire({
            title: "ลบข้อมูลเสร็จสิ้น!",
            text: "ข้อมูลของคุณถูกลบแล้ว",
            icon: "success",
          });
        } catch (error) {
          console.error("Error:", error);
        }
      });
    },

    toggleSelectAll() {
      if (!this.products_person) return;

      if (this.selectAll) {
        this.checkboxValue = this.products_person.flatMap((person) =>
          (person.subP01s || []).map((sub) => sub.p_id)
        );
      } else {
        this.checkboxValue = [];
      }
    },
    validateBeforeSave() {
      const errors = []; 
      if (!this.dropdownItemH?.id) errors.push("กรุณาเลือกประเภทภาระงาน");
      if (!this.text_no || String(this.text_no).trim() === "") errors.push("กรุณากรอกข้อที่");
      if (!this.text_name || String(this.text_name).trim() === "") errors.push("กรุณากรอกชื่อตัวชี้วัด");
      if (!this.dropdownItemTarget?.value) errors.push("กรุณาเลือกระดับค่าเป้าหมาย"); 
      const w = Number(this.text_weight);
      if (!Number.isFinite(w) || w <= 0) errors.push("กรุณากรอกน้ำหนักให้ถูกต้อง (มากกว่า 0)"); 
      if (!Array.isArray(this.products_list) || this.products_list.length === 0) {
        errors.push("กรุณาเพิ่มเกณฑ์การประเมินอย่างน้อย 1 รายการ");
      } else {
        const hasEmptyText = this.products_list.some(
          (x) => !x.ind_Items || String(x.ind_Items).trim() === ""
        );
        if (hasEmptyText) errors.push("รายละเอียดเกณฑ์การประเมินห้ามว่าง");
      } 
      return errors;
    },

    isSelectedRound(round) {
      if (!this.selectedEvalRound) return false;
      return (
        String(this.selectedEvalRound.year) === String(round.year) &&
        String(this.selectedEvalRound.evalua) === String(round.evalua)
      );
    },

    getRoundDesc(evalua) {
      const round = parseInt(evalua, 10);
      if (round === 1) return "วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์";
      if (round === 2) return "วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม";
      return "";
    },

    // เปิด Dialog + โหลดรอบที่สามารถคัดลอกได้
    copyEvaluationData() {
      this.DialogCopy = true;
      this.selectedEvalRound = null;
      this.loadingRounds = true;

      this.loadTargetHOptions();

      axios
        .post("http://127.0.0.1:8000/api/getEvalRoundsForCopy", {
          staff_id: this.staffid_Main,      // แนะนำส่งไปด้วย จะได้ดึงเฉพาะของคนนี้
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,     // ปลายทาง
          evalua: this.dataPor.evalua,      // ปลายทาง
        })
        .then((res) => {
          this.evalRounds = Array.isArray(res.data) ? res.data : [];
        })
        .catch((error) => {
          console.error("getEvalRoundsForCopy error:", error);
          Swal.fire("ผิดพลาด", "ไม่สามารถโหลดข้อมูลปี/รอบประเมินได้", "error");
          this.evalRounds = [];
        })
        .finally(() => {
          this.loadingRounds = false;
        });
    },

    // ยืนยันคัดลอก
    async confirmCopyEvaluation() {
      if (!this.selectedEvalRound) {
        Swal.fire("ยังไม่ได้เลือก", "กรุณาเลือกปี/รอบต้นทาง", "warning");
        return;
      }
      if (!this.checkboxValueCopy || this.checkboxValueCopy.length === 0) {
        Swal.fire("ยังไม่ได้เลือกข้อ", "กรุณาเลือกข้อที่จะคัดลอกอย่างน้อย 1 ข้อ", "warning");
        return;
      }

      const fromYear = this.selectedEvalRound.year;
      const fromEvalua = this.selectedEvalRound.evalua;
      const toYear = this.dataPor.d_date;
      const toEvalua = this.dataPor.evalua;

      if (String(fromYear) === String(toYear) && String(fromEvalua) === String(toEvalua)) {
        Swal.fire("เลือกซ้ำ", "คุณเลือกปี/รอบเดียวกับปลายทาง กรุณาเลือกต้นทางใหม่", "warning");
        return;
      }

      const missingMap = (this.products_personCopy || [])
        .filter(h => (h.subP01s || []).some(p => this.checkboxValueCopy.includes(p.p_id)))
        .some(h => !this.mapH[h.h_id]);

      if (missingMap) {
        Swal.fire("ยังไม่เลือก nameH ปลายทาง", "กรุณาเลือก nameH ปลายทางให้ครบทุกกลุ่ม", "warning");
        return;
      }



      try {
        await axios.post("http://127.0.0.1:8000/api/copySelectedP01Items", {
          staff_id: this.staffid_Main,
          fac_id: this.dataPor.fac_id,
          from_year: fromYear,
          from_evalua: fromEvalua,
          to_year: toYear,
          to_evalua: toEvalua,
          selected_pids: this.checkboxValueCopy,
          overwrite: this.overwriteCopy,
          target_h_id: this.selectedTargetH, 
          mapH: this.mapH, 
        });

        this.DialogCopy = false;
        await this.showDataPerson();

        Swal.fire({
          icon: "success",
          title: "คัดลอกสำเร็จ!",
          text: `คัดลอกจาก ปี ${fromYear} รอบที่ ${fromEvalua} → ปี ${toYear} รอบที่ ${toEvalua}`,
        });
      } catch (e) {
        console.error(e);
        Swal.fire("ผิดพลาด", "ไม่สามารถคัดลอกข้อมูลได้", "error");
      }
    },

     
    cancelDialogcopy() {
      // ปิด Dialog คัดลอก (DialogCopy)
      this.DialogCopy = false;
      this.selectedEvalRound = null;
    },

    async loadCopyItems() {
      this.loadingCopyItems = true;
      this.products_personCopy = [];
      this.checkboxValueCopy = [];
      this.selectAllCopy = false; 
      try {
        const res = await axios.post("http://127.0.0.1:8000/api/getP01ItemsForCopy", {
          staff_id: this.staffid_Main,
          fac_id: this.dataPor.fac_id,
          from_year: this.selectedEvalRound.year,
          from_evalua: this.selectedEvalRound.evalua,
        });

        this.products_personCopy = Array.isArray(res.data) ? res.data : [];

        this.mapH = {};
          (this.products_personCopy || []).forEach((h, idx) => { 
            if (this.selectedTargetH) {
              this.mapH[h.h_id] = this.selectedTargetH;
              return;
            } 
            const t = this.targetHOptions[idx];
            if (t) this.mapH[h.h_id] = t.id;
        });

      } catch (e) {
        console.error(e);
        Swal.fire("ผิดพลาด", "โหลดข้อมูลต้นทางไม่สำเร็จ", "error");
      } finally {
        this.loadingCopyItems = false;
      }
    },
    toggleSelectAllCopy() {
      if (!this.products_personCopy) return;

      if (this.selectAllCopy) {
        this.checkboxValueCopy = this.products_personCopy.flatMap(h =>
          (h.subP01s || []).map(p => p.p_id)
        );
      } else {
        this.checkboxValueCopy = [];
      }
    },

    async loadTargetHOptions() {
      this.loadingTargetH = true;
      try {
        const res = await axios.post("http://127.0.0.1:8000/api/selectDataPersonH", {
          fac_id: this.dataPor.fac_id,
          year_id: this.dataPor.d_date,   //  ปีปัจจุบัน (ปลายทาง)
          evalua: this.dataPor.evalua,    //  รอบปัจจุบัน (ปลายทาง)
        });
        this.targetHOptions = Array.isArray(res.data) ? res.data : [];
 
        if (!this.selectedTargetH && this.targetHOptions.length > 0) {
          this.selectedTargetH = this.targetHOptions[0].id;
        }
      } catch (e) {
        this.targetHOptions = [];
      } finally {
        this.loadingTargetH = false;
      }
    },



    addCriteriaRow() {
      if (this.criteriaDrafts.length >= this.maxCriteriaRows) return;
      this.criteriaDrafts.push({ ind_no: null, ind_Items: "" });
    },

    removeCriteriaRow(idx) {
      if (this.criteriaDrafts.length === 1) return;
      this.criteriaDrafts.splice(idx, 1);
    },

    commitCriteriaDrafts() {
      const drafts = this.criteriaDrafts.map(x => ({
        ind_no: Number(x.ind_no),
        ind_Items: (x.ind_Items || "").trim()
      }));

      const errors = [];

      if (drafts.some(d => !Number.isFinite(d.ind_no) || d.ind_no < 1 || d.ind_no > 5)) {
        errors.push("กรุณากรอกระดับให้ถูกต้อง (1-5) ให้ครบทุกแถว");
      }
      if (drafts.some(d => !d.ind_Items)) {
        errors.push("กรุณากรอกรายละเอียดเกณฑ์การประเมินให้ครบทุกแถว");
      }

      const dupInDraft = drafts.map(d => d.ind_no).filter((v, i, a) => a.indexOf(v) !== i);
      if (dupInDraft.length > 0) errors.push("ระดับในรายการที่กรอก ห้ามซ้ำกัน");

      const existingLevels = new Set((this.products_list || []).map(x => Number(x.ind_no)));
      if (drafts.some(d => existingLevels.has(d.ind_no))) {
        errors.push("มีระดับที่ซ้ำกับรายการที่เพิ่มไว้แล้วในตารางด้านล่าง");
      }

      if (errors.length > 0) {
        Swal.fire({
          icon: "warning",
          title: "ข้อมูลยังไม่ถูกต้อง",
          html: `<div style="text-align:left">${errors.map(e => `• ${e}`).join("<br>")}</div>`
        });
        return;
      }

      this.products_list = [...(this.products_list || []), ...drafts]
        .sort((a, b) => Number(a.ind_no) - Number(b.ind_no));

      this.criteriaDrafts = [{ ind_no: null, ind_Items: "" }];
    },

    //เรียงหัวข้อหลัก/ย่อย
    parseActivityText(raw) {
      const text = String(raw || "").trim();
      if (!text) return { mainTitle: "", lines: [] };

      const rows = text
        .split(/\r?\n/)
        .map(r => r.trim())
        .filter(Boolean);

      // ตัดเลขหัวข้อหลัก "1. " ออก (ถ้าอยากให้โชว์เลขหัวข้อหลักด้วย บอกได้)
      const cleanMain = (s) =>
        s.replace(/^(\d+\.)\s*/, "")
        .replace(/^[-•]\s*/, "")
        .trim();

      const mainTitle = cleanMain(rows[0]);

      const lines = rows.map((r, idx) => {
        const isMain = idx === 0;

        if (isMain) {
          return { type: "main", text: cleanMain(r) };
        }

        // ข้อย่อย: ตัด bullet ออกก่อน
        let s = r.replace(/^[-•]\s*/, "").trim();

        // แยกเลขข้อออกมาเป็นคอลัมน์: 1. / 1.1. / 12.3.4.
        const m = s.match(/^(\d+(?:\.\d+)*\.)\s*(.*)$/);
        const no = m ? m[1] : "";            // เช่น "1." "1.1."
        const body = m ? (m[2] || "") : s;   // ข้อความหลังเลข

        return {
          type: "sub",
          no,
          text: body.trim(),
        };
      });

      return { mainTitle, lines };
    },


    getMainSubject(raw) {
      const parsed = this.parseActivityText(raw);
      return parsed.mainTitle || "";
    },

















 
  },
};
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
.copy-dialog {
  padding: 0.25rem 0.5rem;
}

.copy-title {
  margin-bottom: 0.75rem;
}
.copy-title-main {
  font-weight: 700;
  font-size: 1.05rem;
}

.copy-loading,
.copy-empty {
  padding: 1rem;
  border-radius: 10px;
  background: #f7f7f7;
  color: #555;
}

.copy-list {
  margin-top: 0.5rem;
}

.copy-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  padding: 0.75rem 0.75rem;
  border-radius: 10px;
  cursor: pointer;
  transition: 0.15s ease;
}

.copy-item:hover {
  background: #f5f8ff;
}

.copy-item.active {
  background: #eef6ff;
  outline: 1px solid rgba(59, 130, 246, 0.35);
}

.copy-label {
  cursor: pointer;
  user-select: none;
}

.copy-label-line1 {
  font-size: 0.98rem;
}

.copy-label-desc {
  color: #555;
  margin: 0 0.35rem;
}

.copy-note {
  margin-top: 0.75rem;
  font-size: 0.9rem;
  color: #6b7280;
}

.copy-footer {
  display: flex;
  justify-content: flex-end;
  gap: 0.5rem;
}
.copy-dd-label{
  display:block;
  font-weight:600;
  margin-bottom: .35rem;
}
 

</style>
