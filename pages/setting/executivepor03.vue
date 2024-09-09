<template>
  <div class="card">
    <h4 class="mb-4">
      <i class="pi pi-spin pi-cog" style="font-size: 2rem"></i> 
      แบบรายงานผลการปฏิบัติราชการของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามตามข้อตกลงการประเมินผลสัมฤทธิ์ของงานและข้อตกลงการประเมินพฤติกรรมการปฏิบัติราชการ
    </h4><br>
    
    <!-- ตาราง ก. สมรรถนะหลัก -->
    <table class="styled-table">
      <thead>
        <tr>
          <th><b>ความรู้/ทักษะ/สมรรถนะที่ต้องการพัฒนา</b></th>
          <th><b>วิธีการพัฒนา</b></th>
          <th><b>ช่วงเวลาที่ต้องการพัฒนา</b></th>
          <th><b>บันทึก</b></th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><textarea id="textarea1" v-model="value1" rows="4" class="custom-textarea"></textarea></td>
          <td><textarea id="textarea2" v-model="value2" rows="4" class="custom-textarea"></textarea></td>
          <td><textarea id="textarea3" v-model="value3" rows="4" class="custom-textarea"></textarea></td>
          <td><Button icon="pi pi-save" label="บันทึก" severity="success" class="mb-2 mr-2" /></td>
        </tr> 
        <tr>
          <td colspan="4" valign="top" style="background-color: #333333; color: #FFFFFF;">
            แผนพัฒนาการปฏิบัติราชการรายบุคคล
          </td>
        </tr>
        <tr>
          <td>1.testtest</td>
          <td>testtest11</td>
          <td>testtest333</td>
          <td><Button icon="pi pi-delete-left" label="ลบ" severity="danger" class="mb-2 mr-2" /></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      value1: '',
      value2: '',
      value3: ''
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


