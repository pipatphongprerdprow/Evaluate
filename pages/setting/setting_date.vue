<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">  
                <div class="formgroup-inline mb-1"> 
                    <div class="col md:col-6"> 
                        <h3 class="mb-4 card-header"><i class="pi pi-calendar" style="font-size: x-large;"></i> จัดการ รอบประเมิน</h3>   
                    </div> 
                    <div class="col md:col-16 text-right"> 
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูลรอบประเมิน" @click="OpenDialogAdd" /> 
                        <!-- เพิ่มข้อมูลรอบประเมิน -->
                        <Dialog header="จัดการรอบประเมิน" v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <form>
                                <InputText v-model="text_edt" type="hidden" /> 
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="year_text">ปีงบประมาณ</label> 
                                        <Dropdown id="year_text" v-model="dropdownItemYear" :options="dropdownItemsYear" optionLabel="name" placeholder="เลือกปีงบประมาณ"></Dropdown>  
                                    </div> 
                                    <div class="field col-12 md:col-8">
                                        <label for="evaluation_text">รอบประเมิน</label> 
                                        <Dropdown id="evaluation_text" v-model="dropdownItemEvalua" :options="dropdownItemsEvalua" optionLabel="name" placeholder="รอบประเมิน"></Dropdown> 
                                    </div>
                                </div>
                                <div class="p-fluid formgrid grid"> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dateStart_text">วันที่กำหนด (เริ่ม)</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateStart" />
                                    </div> 
                                    <div class="field col-12 md:col-4">
                                        <label for="dateEnd_text">วันที่ครบกำหนด (สิ้นสุด)</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateEnd" />
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="announce_text" style="color: red;font-weight: 600;">วันที่ประกาศคะแนน **</label>  
                                        <InputText type="date" id="inputgroup" v-model="dateAnnounce" />
                                    </div>
                                </div> 
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDataset" /> 
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog> 
                    </div> 
                </div>   
                <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                    <Column field="Tb_name" header="ปีงบประมาณ" style="width: 12%">
                        <template #body="Item">  
                            <b>{{ Item.data.d_date }}</b>
                        </template>
                    </Column>
                    <Column field="Tb_ind" header="รอบประเมิน" style="width: 17%">
                        <template #body="Item">   
                            {{ Item.data.d_evaluationround }}
                        </template>
                    </Column>
                    <Column field="Tb_target" header="วันที่กำหนด" style="width: 17%">
                        <template #body="Item"> 
                            {{ Item.data.d_recordingday }}   
                        </template>
                    </Column>
                    <Column field="Tb_score" header="วันที่ครบกำหนด" style="width: 17%;">
                        <template #body="Item">  
                            <em style="color: red;">{{ Item.data.d_enddate }}</em> 
                        </template>
                    </Column>
                    <Column field="Tb_weight" header="วันที่ประกาศคะแนน" style="width: 17%">
                        <template #body="Item"> 
                            <b style="color: blue;">{{ Item.data.d_scoringday }} </b>
                        </template>
                    </Column>
                    <Column field="Tb_balance" hidden="จัดการประเมิน" style="width: 10%">
                        <template #body="Item"> 
                            {{ Item.data.id }}
                        </template>
                    </Column> 
                    <Column field="options" header="ตัวเลือก" style="width: 10%">
                        <template #body="Item">   
                            <Button icon="pi pi-pencil" severity="success" class="mb-2 mr-2" @click="editData(Item.data)" />
                            <Button icon="pi pi-trash" severity="danger" class="mb-2 mr-2" @click="delData(Item.data)" /> 
                        </template>
                    </Column> 
                </DataTable>
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
            staffid_Main: 5009942,
            facid_Main: 201092704000,
            groupid_Main: '01',
            products_date: [],  
            // Dialog
            DialogAdd: false, 
            text_edt: null, 
            dropdownItemYear: null,
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            dropdownItemEvalua: null,
            dropdownItemsEvalua: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            ], 
            dateStart: null,
            dateEnd: null, 
            dateAnnounce: null, 

        }
    },
    mounted(){
        this.showDataSet(); 
    },
    methods: {
        showDataSet(){  
            axios.post('http://localhost:8000/api/showDateSet',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main,
            }).then(res => {     
                // console.log(res.data);  
                this.products_date = res.data;
            })
            .catch(error => {
                console.error('Error:', error);

            });
        },
        editData(data){ 
            // console.log(data);
            this.DialogAdd = true;  
            this.text_edt = data.id;

            const year_ob = this.dropdownItemsYear.filter(f=>f.code==data.d_date)
            this.dropdownItemYear = year_ob.length > 0 ? year_ob[0] : null;   

            const evalua_ob = this.dropdownItemsEvalua.filter(f=>f.code==data.evalua)
            this.dropdownItemEvalua = evalua_ob.length > 0 ? evalua_ob[0] : null;   
 
            this.dateStart = data.d_recordingday;
            this.dateEnd = data.d_enddate;
            this.dateAnnounce = data.d_scoringday; 
        },
        delData(data){ 
            Swal.fire({
                title: "คุณต้องการลบรอบประเมิน ใช่หรือไม่ ?",
                text: "เมื่อคลิกปุ่ม Yes, delete it! ข้อมูลจะถูกลบทันที!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Yes, delete it!"
                }).then((result) => {
                if (result.isConfirmed) {
                    axios.post('http://localhost:8000/api/delDateSet',{
                        data: data
                    }).then(res => { 
                        // console.log(res);   
                        this.showDataSet();
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
        OpenDialogAdd(){
            this.DialogAdd = true; 
            this.text_edt = null;
            this.dropdownItemYear = null; 
            this.dropdownItemEvalua = null;
            this.dateStart = null;
            this.dateEnd = null;
            this.dateAnnounce = null; 
        },
        resetDialog(){
            this.DialogAdd = false; 
        },
        saveDataset(){
            // console.log(this.dropdownItemYear.code); 
            axios.post('http://localhost:8000/api/saveDateSet',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                group_id: this.groupid_Main,
                text_edt: this.text_edt,
                year: this.dropdownItemYear,
                evalua: this.dropdownItemEvalua,
                dateStart: this.dateStart,
                dateEnd: this.dateEnd,
                dateAnnounce: this.dateAnnounce,  
            }).then(res => {     
                // console.log(res.data); 
                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกเรียบร้อยแล้ว !",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.DialogAdd = false;  
                this.showDataSet(); 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
    }

}
</script>

<style>
.card-header {
    text-align: left; /* Aligns text to the left */
    margin: 0; /* Removes default margins */
    padding: 0; /* Removes default padding */
}
.table th {
      background-color: #edf2bb;
      font-weight: bold;
  }
</style>