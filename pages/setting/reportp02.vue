<template>
    <div class="card">
        <h3 class="mb-4" style="text-align: left;"><i class="pi pi-folder-open" style="font-size: x-large;"></i> รายงานแบบ ป02</h3>
        <h4>ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 2)</h4><br>
        
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
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('core', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('core', index)" title="ลบ"></i>
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
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('job', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('job', index)" title="ลบ"></i>
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

        <!-- ตาราง ค. สมรรถนะอื่นๆ -->
        <table id="ratingTable">
            <thead>
                <tr>
                    <th rowspan="4">ค. สมรรถนะทางการบริหาร (สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                    <th rowspan="4">(5) ระดับสมรรถนะที่คาดหวัง</th>
                    <th rowspan="4">(6) ระดับสมรรถนะที่แสดงออก</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(row, index) in otherCompetencies" :key="index">
                    <td>
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i>
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
                        {{ row.activity }}
                        <i class="far fa-edit edit-icon" @click="editRow('other', index)" title="แก้ไข"></i>
                        <i class="fas fa-trash-alt delete-icon" @click="deleteRow('other', index)" title="ลบ"></i>
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
                    <p>(10) ผู้ประเมินและผู้รับการประเมิน ได้ตกลงร่วมกันและเห็นพ้องกันแล้ว (ระบุข้อมูลใน (1) และหรือ (3) และหรือ (5) ตามระดับสมรรถนะของตำแหน่งที่กำหนดให้ครบ)จึงลงลายมือชื่อไว้เป็นหลักฐาน (ลงนามเมื่อจัดทำข้อตกลง)</p>
                <div class="signatures"><div>
                    <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                    <p>(-)</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                <div>
                    <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                    <p>(-)</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                </div>
                </div>
            </div>
            <div class="bordered-box">
                <div class="content">
                    <p>(11) ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</p>
                    <p>1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</p>
                    <p>-</p>
                    <p>2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</p>
                    <p>-</p>
                    <p>(12) ผู้ประเมินและผู้รับการประเมิน ได้เห็นชอบผลการประเมินแล้ว (ระบุข้อมูลใน (2) และหรือ (4) และหรือ (6) (7) (8) (9) และ (11) ให้ครบ) จึงลงลายมือชื่อไว้เป็นหลักฐาน  (ลงนามเมื่อสิ้นรอบการประเมิน)</p>
                <div class="signatures"><div>
                    <p>ลายมือชื่อ ................................................. (ผู้ประเมิน)</p>
                    <p>(-)</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                <div>
                    <p>ลายมือชื่อ ................................................. (ผู้รับการประเมิน)</p>
                    <p>(-)</p>
                    <p>วันที่ ............ เดือน ........................ พ.ศ. ................</p>
                    </div>
                </div>
                </div>
            </div>
    </div>
</template>

<script>
import InputNumber from 'primevue/inputnumber';

export default {
    components: {
        InputNumber
    },
    data() {
        return {
            coreCompetencies: [
                { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1',report:''},
                { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1' },
                { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1' },
                { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1' }
            ],
            jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1' },
                { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1' },
                { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1' },
                { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1' },
                { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1' },
                { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1' }
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
            inputNumberValue: null
        };
    },
    methods: {
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
        }
    }
};
</script>

<style scoped>
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
.edit-icon {
    color: #ffc107;
}
.delete-icon {
    color: #dc3545;
}
.custom-textarea {
    width: 100%; /* ความกว้างเต็มที่ */
    max-width: 1200px; /* ความกว้างสูงสุด */
    height: auto; /* ปรับความสูงตามเนื้อหา */
    resize: vertical; /* อนุญาตให้ปรับขนาดความสูงเท่านั้น */
}
.button-container {
    text-align: center; /* จัดกึ่งกลางในแนวนอน */
}
.bordered-box {
  border: 1px solid #ddd;
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

.signatures div {
  width: 45%;
}
</style>
