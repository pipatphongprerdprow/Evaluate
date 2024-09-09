         <template>
            <!-- <div class="container">
                <h3>เพิ่มแบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Refernce : TOR)</h3>
                <form>
                    <table width="800" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#666666">
                    <tbody>
                        <tr>
                        <td width="180" align="right"><strong>ประจำปีงบประมาณ:</strong></td>
                        <td>
                            <div class="field col-12 md:col-3">    
                            <select v-model="year" id="year">
                                <option value="2567">2567</option>
                                <option value="2566">2566</option>
                                <option value="2565">2565</option>
                                <option value="2564">2564</option>
                            </select>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        </tr>
                    <tr>
                        <td align="right"><strong>รอบประเมิน : </strong></td>
                        <td>
                            <label>
                        <input type="radio" name="round" value="1" v-model="round">รอบที่1 วันที่ 1 กันยายน ถึง วันที่ 28/29 กุมภาพันธ์
                    </label>
                    <label>
                        <input type="radio" name="round" value="2" v-model="round">รอบที่2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม
                    </label>
                        </td>

                   
                        </tr>
                        <tr>
                        <td align="right"><strong>ผู้รับการประเมิน : </strong></td>
                        <td>                           
                            <input type="text" v-model="staffname">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>รหัสพนักงาน : </strong></td>
                        <td>
                            <input type="text" v-model="staffid">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>ตำแหน่ง : </strong></td>
                        <td>
                            <input type="text" v-model="position">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>ประเภทตำแหน่ง : </strong></td>
                        <td>
                            <input type="text" v-model="acadposition">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>คุณวุฒิ : </strong></td>
                        <td>
                            <input type="text" v-model="degree">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>ประเภทบุคลากร : </strong></td>
                        <td>
                            <input type="text" v-model="staffmtype">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>สังกัด : </strong></td>
                        <td>
                            <input type="text" v-model="department">
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>ผู้ประเมิน : </strong></td>
                        <td>
                            <input type="text" v-model="Assessor">
                        </td>
                        </tr>
                        <tr>
                        <td width="180" align="right"><strong>ตำแหน่งผู้ประเมิน : </strong></td>
                        <td>
                            <div class="field col-12 md:col-6">    
                            <select v-model="assessor_position" @change="checkFrom1">
                                <option value="1">อธิการบดี</option>
                                <option value="2">รองอธิการบดี</option>
                                <option value="3">ผู้ช่วยอธิการบดี</option>
                                <option value="4">ผู้อำนวยการ</option>
                                <option value="5">รักษาการผู้อำนวยการ</option>
                            </select>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td align="right"><strong>สัดส่วนคะแนน : </strong></td>
                        <td>
                            <div class="field col-12 md:col-3"> 
                            <select v-model="persen" id="persen">
                                <option value="1">70:30</option>
                                <option value="2">50:50</option>
                            </select>
                            </div>
                        </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr>
                        <td colspan="2" align="center">
                            <router-link to="/setting/por_01" class="button-link" @click.native="checkBeforeSave">
                                <Button icon="pi pi-save" severity="primary" class="mb-2 mr-2" label="บันทึกข้อตกลง" @click="confirmSave" />
                            </router-link>
                        </td>
                    </tr>
                    </tbody>
                    </table>
                </form>
            </div> -->
        <div class="container">
        <table>
            <thead>
                <tr>
                    <th>ประจำปี</th>
                    <th>รอบประเมิน</th>
                    <th>สัดส่วนคะแนน</th>
                    <th>ผู้ประเมิน</th>
                    <th>รายละเอียด</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>{{ year }}</td>
                    <td>{{ round }}</td>
                    <td>{{ persen }}</td>
                    <td>{{ Assessor }}</td>
                    <td>{{ details }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<script>
import Swal from 'sweetalert2'
export default {
    name: "CustomTable",
    data() {
        return {
            year: "2567",
            round: "2",
            staffname: "นายพิพัฒน์พงษ์ เพริดพราว",
            staffid: "5009942",
            position: "นักวิชาการคอมพิวเตอร์",
            acadposition: "ปฏิบัติการ",
            degree: "null",
            staffmtype: "พนักงานมหาวิทยาลัย",
            department: "กองแผนงาน",
            Assessor: "นางสาวพนมพร ปัจจวงษ์",
            username: "",
            assessor_position: "1",
            persen: "1",
            copy: true,
            isSaved: false,
            isSaving: false
        };
    },
    methods: {
        checkBeforeSave() {
            this.saveData();
        },
        saveData() {
            this.isSaving = true;
            this.isSaved = false;

            setTimeout(() => {
                this.isSaving = false;
                this.isSaved = true;

                setTimeout(() => {
                    this.isSaved = false;
                }, 3000);
            }, 2000);
        },
        confirmSave() {
            Swal.fire({
                title: "เรียบร้อย!",
                text: "บันทึกข้อมูล ข้อตกลง และภาระงานเรียบร้อย!",
                icon: "success"
                });
                this.DialogAdd = false; 
                this.showDataPerson();
        }
    }
}

</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Prompt:wght@300;400;600&display=swap');

body {
    font-family: 'Prompt', sans-serif;
    background-color: #f4f4f9;
    color: #333;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 130vh;
    margin: 0;
    padding: 20px;
}

.container {
    width: 120%;
    max-width: 1200px;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    text-align: center;
}

.container {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    max-width: 1200px;
    width: 100%;
    margin-top: 20px;
}

h1 {
    text-align: center;
    color: #333;
    margin-bottom: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td {
    padding: 10px;
    vertical-align: top;
}

strong {
    display: block;
    margin-bottom: 5px;
}

input[type="text"],
select {
    width: calc(100% - 20px);
    padding: 8px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

input[type="radio"] {
    margin-right: 5px;
}

input[type="checkbox"] {
    margin-right: 5px;
}

.styled-button {
    background-color: #4CAF50;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
    border-radius: 8px;
}

.button-link {
    text-decoration: none;
}
</style>
  