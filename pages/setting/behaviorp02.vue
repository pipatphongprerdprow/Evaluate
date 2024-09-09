<template>
    <div class="card">
        <h3 class="mb-4" style="text-align: left;"><i class="pi pi-book" style="font-size: x-large;"></i> รายงานพฤติกรรมการปฏิบัติราชการ</h3>
        <h4>แบบรายงานผลการปฏิบัติราชการของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามตามข้อตกลงการประเมินผลสัมฤทธิ์ของงานและข้อตกลงการประเมินพฤติกรรมการปฏิบัติราชการ</h4><br>
        
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
                        <Chips v-model="coreCompetencies[index].chipsValue" />
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
                        <Chips v-model="jobSpecificCompetencies[index].chipsValue" />
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
                        <Chips v-model="otherCompetencies[index].chipsValue" />
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
            <h4 class="mb-4"><i class="" style="font-size: x-large;"></i> ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อเสร็จสิ้นรอบการประเมิน)</h4>
        </div>
        <div>
            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> 1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</h5>
        </div>
        <div class="field col-12">
            <textarea id="address" rows="9" class="custom-textarea"></textarea>
        </div>
        <div>
            <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> 2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา เพื่อจัดทำแผนพัฒนาบุคลากร</h5>
        </div>
        <div class="field col-12">
            <textarea id="address" rows="9" class="custom-textarea"></textarea>
        </div>
        <div class="button-container">
            <Button label="บันทึกพฤติการปฏิบัติราชการ" icon="pi pi-save" class="mb-2 mr-2" @click="saveData" />
        </div>
    </div>
</template>

<script>
import Chips from 'primevue/chips';
import InputNumber from 'primevue/inputnumber';

export default {
    components: {
        Chips,
        InputNumber
    },
    data() {
        return {
            coreCompetencies: [
                { activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', chipsValue: [] },
                { activity: 'ก. 2 การบริการที่ดี', indicator: '1', chipsValue: [] },
                { activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', chipsValue: [] },
                { activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', chipsValue: [] },
                { activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', chipsValue: [] }
            ],
            jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', chipsValue: [] },
                { activity: 'ข. 2 การมุ่งผลสัมฤทธิ์', indicator: '1', chipsValue: [] },
                { activity: 'ข.3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', chipsValue: [] },
                { activity: 'ข.4 การมองภาพองค์รวม', indicator: '1', chipsValue: [] },
                { activity: 'ข.5 การสืบเสาะหาข้อมูล', indicator: '1', chipsValue: [] },
                { activity: 'ข.6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', chipsValue: [] }
            ],
            otherCompetencies: [
                { activity: 'ค. 1 สภาวะผู้นำ', indicator: '0', chipsValue: [] },
                { activity: 'ค. 2 วิสัยทัศน์', indicator: '0', chipsValue: [] },
                { activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0', chipsValue: [] },
                { activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0', chipsValue: [] },
                { activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0', chipsValue: [] }
            ],
            newActivity: '',
            activeFormIndex: null,
            activeCategory: '',
            // other data properties for file handling, etc.
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
        addRow(category) {
            if (category === 'core') {
                this.coreCompetencies.push({ activity: this.newActivity, indicator: '1', chipsValue: [] });
            } else if (category === 'job') {
                this.jobSpecificCompetencies.push({ activity: this.newActivity, indicator: '1', chipsValue: [] });
            } else if (category === 'other') {
                this.otherCompetencies.push({ activity: this.newActivity, indicator: '1', chipsValue: [] });
            }
            this.newActivity = '';
            this.hideForm();
        },
        hideForm() {
            this.activeFormIndex = null;
            this.activeCategory = '';
        },
        handleFileUpload(event) {
            const file = event.target.files[0];
            console.log('Selected file:', file);
            // Handle the file upload logic here
        },
        saveData() {
            // Logic to save data
            console.log('Data saved!');
        }
    }
};
</script>

    <style>
    .edit-icon {
        cursor: pointer;
        margin-left: 10px;
    }

    .delete-icon {
        cursor: pointer;
        margin-left: 10px;
    }

    .add-row-form {
        display: none;
    }

    .form-container {
        padding: 10px;
        background-color: #f9f9f9;
        border: 1px solid #ccc;
        margin-top: 10px;
    }

    .save-button {
        background-color: #4CAF50;
        color: white;
        border: none;
        padding: 10px 20px;
        cursor: pointer;
        margin-right: 10px;
    }

    .cancel-button {
        background-color: #f44336;
        color: white;
        border: none;
        padding: 10px 20px;
        cursor: pointer;
    }

    .button-container {
        text-align: center;
        margin-top: 20px;
    }

    .custom-textarea {
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: 1px solid #ccc;
        box-sizing: border-box;
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
    .custom-textarea {
        width: 100%; /* ความกว้างเต็มที่ */
        max-width: 1200px; /* ความกว้างสูงสุด */
        height: auto; /* ปรับความสูงตามเนื้อหา */
        resize: vertical; /* อนุญาตให้ปรับขนาดความสูงเท่านั้น */
    }
    .button-container {
        text-align: center; /* จัดกึ่งกลางในแนวนอน */
    }
    </style> 
