<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <h3 class="mb-4" style="text-align: left;">
                    <!-- <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป.04 -->
                </h3>
                <h3 class="mb-4"><i class="" style="font-size: x-large;"></i> แบบรายงานผลการปฏิบัติราชการของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามตามข้อตกลงการประเมินผลสัมฤทธิ์ของงานและข้อตกลงการประเมินพฤติกรรมการปฏิบัติราชการ</h3> 
                <div class="p-fluid formgrid grid">
                    <div class="card">
                        <h3 class="mb-4" style="text-align: right;"><i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป.04</h3>
                        <h4 style="text-align: center;">แบบสรุปการประเมินผลการปฏิบัติราชการของข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม</h4><br>
                        <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>
                        
                        <!-- ตาราง ก. สมรรถนะหลัก -->
                        <div class="employee-info">
                            <p><strong>ผู้ปฏิบัติงาน:</strong> นาย พิพัฒน์พงษ์ เพริดพราว</p>
                            <p><strong>สังกัด:</strong> กองแผนงาน</p>
                            <p><strong>ตำแหน่ง:</strong> นักวิชาการคอมพิวเตอร์</p>
                            <p><strong>ประเภทตำแหน่ง:</strong> ปฏิบัติการ</p>
                            <p><strong>คุณวุฒิ:</strong> ปฏิบัติการ</p>
                            <p><strong>ประเภทบุคลากร:</strong> พนักงานมหาวิทยาลัย</p>
                            <p><strong>รายละเอียดข้อตกลง:</strong> ระหว่าง วันที่ 1 มี.ค. 2567 ถึง วันที่ 31 ส.ค. 2567</p>
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
                                    <th rowspan="4"> องค์ประกอบการประเมิน</th>
                                    <th rowspan="4">ค่าคะแนนที่ได้หลังถ่วงน้ำหนัก(ก)</th>
                                    <th rowspan="4">สัดส่วนคะแนน(ข)</th>
                                   <th rowspan="4">สรุปคะแนน(ก) X (ข)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(row, index) in jobSpecificCompetencies" :key="index">
                                    <td>
                                        {{ row.activity }}
                                    </td>
                                    <td>{{ row.indicator }}</td>
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
                                    <label for="evaluator-acknowledgment-2">มีความเห็นต่าง ดังนี้<br>......................................................................................................................................</label><br>
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
                                    <label for="evaluator-acknowledgment-2">มีความเห็นต่าง ดังนี้<br>......................................................................................................................................</label><br>
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
            </div> 
        </div>
  </template>
  
<script>
import axios from 'axios'  
export default {
  data() {
    return {
      fac: '2010927050000', //คณะ
      staffid: '5008668', //ผู้ใช้งาน
      evaluator: null, // ชื่อ
      evaluator_val: null, //รหัสประจำตัว
      show_evaluator: false, //โชว์
      userevaluator: [], //ลูปชื่อ
      jobSpecificCompetencies: [
                { activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1' },
                { activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1' },
                { activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1' },
                { activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1' },
                { activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1' },
                { activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1' }
                
            ],
            };
        },
        mounted(){
            this.showData();
        },
        methods: {
            async showData(){    
                await axios.post('   http://127.0.0.1:8000/api/showUserManag',{
                    fac: this.fac
                }).then(res => { 
                    // console.log(res.data);
                    this.evaluator = res.data[0].staffname
                    this.evaluator_val = res.data[0].staffid
                })
                .catch(error => {
                    console.error('Error:', error);
                }); 
            }, 
            async Searchuser(event){   
                // console.log(event.target.value.length);
                if(event.target.value.length==0){
                    this.show_evaluator = false; 
                }else{
                    this.show_evaluator = true; 
                    await axios.post('   http://127.0.0.1:8000/api/searchUser',{
                        evaluator: this.evaluator
                    }).then(res => { 
                        this.userevaluator=res.data
                    })
                    .catch(error => {
                        console.error('Error:', error);
                    });
                } 
            }, 
            async nameUserclick(data){ 
                // console.log(data);
                this.show_evaluator = false;   
                this.evaluator = data.fullname 
                this.evaluator_val = data.staffid
            },
            async SaveData(){
                await axios.post('   http://127.0.0.1:8000/api/saveDataManag',{
                    evaluator: this.evaluator,
                    evaluator_val: this.evaluator_val,
                    staffid: this.staffid,
                    fac: this.fac
                }).then(res => {
                console.log(res.data);
                }).catch(error => {
                console.error('Error:' ,error);
                }); 
            },
        }
        };
</script>

  
<style>
    /* เพิ่มสไตล์ที่จำเป็นได้ที่นี่ */
    .p-toast-message {
        font-size: 1.7rem; /* ตั้งค่าขนาดฟอนต์ให้ใหญ่ขึ้น */
    }
 
    #country-list{
        /* float:left; */
        list-style:none;
        margin-top:-3px;
        padding:0;
        width:100%;
        /*width:190px;*/
        /* position: absolute;  */
        /* z-index:9999 !important; */
    }

	#country-list li{
        padding: 10px; 
        background: #f0f0f0; 
        border-bottom: #bbb9b9 1px solid;
    }

	#country-list li:hover{
        background:#ece3d2;
        cursor: pointer;
    }
    .employee-info {
    padding: 5px; /* Adjust the value as needed */
    margin: 5px; /* Adjust the value as needed */
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
.card {
  padding: 20px;
  margin: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #fff;
}

.styled-table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}

.styled-table th, .styled-table td {
  padding: 10px;
  border: 1px solid #ddd;
  vertical-align: top;
}

.custom-textarea {
  width: 100%;
  resize: none;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  margin-top: 10px;
}
.center-align {
  text-align: center;
  margin-top: 60px;
  
}

</style> 

