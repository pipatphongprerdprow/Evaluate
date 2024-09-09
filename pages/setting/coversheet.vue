<template>
  <div class="card">
      <h3 class="mb-4" style="text-align: right;">
          <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป01-02
      </h3>
      <div style="display: flex; justify-content: center;">
          <img src="@/public/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
      </div>
      <h4 style="text-align: center;">
          แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม
      </h4><br>
      
      <!-- ตาราง ก. สมรรถนะหลัก -->
      <div class="employee-info">
          <p><strong>ผู้ปฏิบัติงาน:</strong> นาย พิพัฒน์พงษ์ เพริดพราว</p>
          <p><strong>สังกัด:</strong> กองแผนงาน</p>
          <p><strong>ตำแหน่ง:</strong> นักวิชาการคอมพิวเตอร์</p>
          <p><strong>ประเภทตำแหน่ง:</strong> ปฏิบัติการ</p>
          <p><strong>คุณวุฒิ:</strong> ปฏิบัติการ</p>
          <p><strong>ประเภทบุคลากร:</strong> พนักงานมหาวิทยาลัย</p>
          <p><strong>รายละเอียดข้อตกลง:</strong> ระหว่าง วันที่ 1 มี.ค. 2567 ถึง วันที่ 31 ส.ค. 2567</p>
      </div>

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

      <!-- Tabs Section -->
      <div class="tabs-section">
          <Tabs value="0">
              <TabList>
                  <Tab v-for="tab in tabs" :key="tab.value" :value="tab.value">{{ tab.title }}</Tab>
              </TabList>
              <TabPanels>
                  <TabPanel v-for="tab in tabs" :key="tab.value" :value="tab.value">
                      <p class="m-0">{{ tab.content }}</p>
                  </TabPanel>
              </TabPanels>
          </Tabs>
      </div>
  </div>
</template>

<script>
export default {
  name: "ContractDetails",

  
};
</script>

<style scoped>
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
  /* additional styling for the image if needed */
}
.explanation {
  margin-top: 20px; /* ปรับระยะห่างจากด้านบน */
  padding-left: 30px; /* ปรับการเยื้องเข้าด้านใน */
}


</style>

