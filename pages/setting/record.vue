<template>
    <div class="grid">
        <div  class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-10"> 
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-credit-card" style="font-size: x-large;"></i> 
                            รายงานการประเมิน
                            <input type="text" v-model="staffidData" style="display: none;" >
                        </h3>    
                    </div>  
                    <div class="col md:col-2">  
                        <Button severity="secondary" label="ค้นหาข้อมูล" class="mb-2 mr-2" icon="pi pi-search" @click="showDataRecord(user.user.image)" /> 
                    </div> 
                </div>   
                <table class="table">
                    <thead> 
                        <tr style="height: 40px;background-color: #edf2bb;">
                            <th>ปีงบประมาณ</th>   
                            <th>รอบการประเมิน</th>  
                            <th>คะแนน</th>   
                            <th>ตัวเลือก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(Item, index) in Table_data" :key="index">
                            <td style="width: 20%;text-align: center"> 
                                <b style="color: brown;">{{ Item.p01_year }}</b>
                            </td>
                            <td v-if="Item.d_evaluationround" style="padding-left: 5px;width: 40%;"><b>{{ Item.d_evaluationround }}</b></td>
                            <td style="padding-left: 5px;width: 20%;"><b>0</b></td>
                            <td style="text-align: center;width: 20%;">
                                <Button severity="danger" label="รายละเอียด" class="mb-2 mr-2" icon="pi pi-plus" @click="openDataEvalu(Item.staffid)" />  
                            </td>
                        </tr> 
                    </tbody>
                </table> 

                <Dialog maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
                    <template v-slot:header>
                        <h3>รายงานการประเมิน</h3>
                    </template> 
                    <div class="row">
                        <div class="p-fluid formgrid grid">
                            <div class="field col-12 md:col-12">
                                <div class="grid">
                                    <div class="col-12 lg:col-12 xl:col-12">
                                        <div class="card mb-0"> 
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th rowspan="2" style="width: 19%;">กิจกรรม / โครงการ / งาน</th>
                                                        <th rowspan="2" style="width: 25%;">ตัวชี้วัด / เกณฑ์การประเมิน</th>
                                                        <th rowspan="2" style="width: 20%;">รางานการปฏิบัติราชการ<br> ตามตัวชี้วัด/เกณฑ์การประเมิน</th>
                                                        <th rowspan="2" style="width: 25%;">หลักฐานที่แสดงถึงผลการปฏิบัติราชการตามเกณฑ์การประเมิน(หลักฐานเชิงประจักษ์)</th>
                                                        <th colspan="5" style="width: 15%;">ระดับค่าเป้าหมาย</th> 
                                                        <th rowspan="2" style="width: 10%;">ค่าคะแนนที่ได้</th>
                                                        <th rowspan="2" style="width: 10%;">น้ำหนัก(ความสำคัญ/ความยากง่ายของงาน)</th>
                                                        <th rowspan="2" style="width: 10%;">ค่าคะแนนถ่วงน้ำหนัก<br>(4) X (5)<br> 100</th>
                                                        
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
                                                    <template v-for="(h, ind) in products_Tab2" :key="ind">
                                                        <tr>
                                                            <td style="text-align: left;" colspan="12">
                                                                <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b> 
                                                            </td> 
                                                        </tr> 
                                                        <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;">
                                                            <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                                            <td style="text-align: left;">
                                                                <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                                                <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <div v-if="subIitem.ind_no!=0" ><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                                                    <div v-if="subIitem.ind_no==0" ><b>{{ subIitem.ind_Items }}</b></div>
                                                                </p>
                                                                <p v-if="subP01.p01_detail != null">
                                                                    
                                                                    <b style="color: red;">ข้อเสนอแนะ</b>
                                                                    <br>
                                                                    <em style="color: red;">{{ subP01.p01_detail }}</em>
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
                                                                    <a v-if="subIitemDoc.doc_file!=null" :href="'http://survey.msu.ac.th/evaluatebackend/storage/uploadsP03/'+subIitemDoc.doc_file" target="_blank"><b>ระดับ</b> <b>{{subIitemDoc.doc_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                    <a v-if="subIitemDoc.doc_link!=null" :href="subIitemDoc.doc_link" target="_blank"><b>ระดับ</b> <b>{{ subIitemDoc.p03ind_no }}</b> {{ subIitemDoc.doc_name }}</a> 
                                                                </p>
                                                                <p v-if="subP01.subITemP03doc.length == 0" style="padding-left: 8px;margin-bottom: 5px;">
                                                                    <b style="color: red;">- ไม่มีข้อมูล -</b>
                                                                </p>
                                                            </td>  
                                                            <td style=" vertical-align: middle;" class="text-center">
                                                                <b v-if="subP01.p01_target==1">&#10003;</b> 
                                                                <b v-if="subP01.p01_target!=1"></b> 
                                                            </td>
                                                            <td style=" vertical-align: middle;" class="text-center">
                                                                <b v-if="subP01.p01_target==2">&#10003;</b> 
                                                                <b v-if="subP01.p01_target!=2"></b> 
                                                            </td>
                                                            <td style=" vertical-align: middle;" class="text-center">
                                                                <b v-if="subP01.p01_target==3">&#10003;</b> 
                                                                <b v-if="subP01.p01_target!=3"></b> 
                                                            </td>
                                                            <td style=" vertical-align: middle;" class="text-center"> 
                                                                <b v-if="subP01.p01_target==4">&#10003;</b> 
                                                                <b v-if="subP01.p01_target!=4"></b> 
                                                            </td>  
                                                            <td style=" vertical-align: middle;" class="text-center"> 
                                                                <b v-if="subP01.p01_target==5">&#10003;</b> 
                                                                <b v-if="subP01.p01_target!=5"></b> 
                                                            </td>
                                                                <!-- เพิ่มตารางช่องค่าคะแนน -->
                                                            <td style=" vertical-align: middle;" class="text-center">{{ subP01.p01_score }}</td>
                                                            <td style=" vertical-align: middle;" class="text-center">{{ subP01.p01_weight }}%</td> 
                                                            <td style=" vertical-align: middle;" class="text-center">{{ (subP01.p01_score * subP01.p01_weight / 100).toFixed(2) }}</td>
                                                        </tr>
                                                        </template>
                                                        <tr>
                                                            <td style="text-align: right" colspan="9">
                                                                <b style="color: blue;">(7) ผลรวม</b>
                                                            </td>
                                                            <td class="text-center" style="color: blue;"><b>15%</b></td> 
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: right; vertical-align: middle;" colspan="10">
                                                                <b style="color: blue;">(8) สรุปคะแนนส่วนผลสัมฤทธิ์ของงาน =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                                <b style="color: blue;">ผลรวมของค่าคะแนนถ่วงน้ำหนัก</b>
                                                                <div style="display: flex; justify-content: flex-end;">
                                                                    <hr style="border: 1px solid black; width: 16%;">
                                                                </div>
                                                                <b style="color: blue;">จำนวนระดับค่าเป้าหมาย = 5 </b>
                                                            </td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>  
                                                    </tbody>
                                                </table>
                                            <hr>
                                            <div class="p-fluid formgrid grid">
                                                <!-- ตาราง ก. สมรรถนะหลัก -->
                                                <div class="field col-12 md:col-4"> 
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 60%;">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                                                                <th style="width: 20%;">(1)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                                                                <th style="width: 20%;">(2)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row1, index) in coreCompetencies" :key="index">
                                                                <td style="text-align: left;">{{ row1.activity }}</td> 
                                                                <td>{{ row1.indicator }}</td>
                                                                <td>  
                                                                    <b v-if="row1.data_table1 == '' " style="color: red;">0</b> 
                                                                    <b v-if="row1.data_table1 != 0 " >{{ row1.data_table1 }}</b> 
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <!-- ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ -->
                                                <div class="field col-12 md:col-4"> 
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 60%;">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                                                                <th style="width: 20%;">(3)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                                                                <th style="width: 20%;">(4)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row2, index) in jobSpecificCompetencies" :key="index">
                                                                <td style="text-align: left;">{{ row2.activity }}</td> 
                                                                <td>{{ row2.indicator }}</td>
                                                                <td>
                                                                    <b v-if="row2.data_table2 == '' " style="color: red;">0</b> 
                                                                    <b v-if="row2.data_table2 != 0 " >{{ row2.data_table2 }}</b> 
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <!-- ตาราง ค. สมรรถนะอื่นๆ -->
                                                <div class="field col-12 md:col-4"> 
                                                    <table id="ratingTable">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 60%;">ค. สมรรถนะทางการบริหาร (สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                                                                <th style="width: 20%;">(5)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                                                                <th style="width: 20%;">(6)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <tr v-for="(row3, index) in otherCompetencies" :key="index">
                                                                <td style="text-align: left;">{{ row3.activity }}</td> 
                                                                <td></td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>

                                           <!-- เกณฑ์การประเมิน -->
                                            
                                           <thead>
                                                    <tr>                                                       
                                                        <th rowspan="9" style="width: 90%;">เกณฑ์การประเมิน</th>
                                                        <th colspan="3" style="width: 10%;">การประเมิน</th> 
                                                    </tr>
                                                    <tr>
                                                        <th>จำนวน <br>สมรรถนะ</th>
                                                        <th>คูณด้วย</th>
                                                        <th>คะแนน</th>
                                                    </tr>
                                            </thead>
                                                <tbody>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก สูงกว่าหรือเท่ากับ ระดับสมรรถนะที่คาดหวัง X 3 คะแนน</td>
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>                                                      
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 1 ระดับ X 2 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 2 ระดับ X 1 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style=" vertical-align: middle;" class="text-left">จำนวนสมรรถนะหลัก /สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ /สมรรถนะทางการบริหาร ที่มีระดับสมรรถนะที่แสดงออก ต่ำกว่า ระดับสมรรถนะที่คาดหวัง 3 ระดับ X 0 คะแนน</td>
                                                        <td></td>
                                                        <td></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="text-align: right" colspan="3">
                                                            <b style="color: blue;"> (8) ผลรวม</b>
                                                        </td>
                                                        <td></td>
                                                        
                                                    </tr>
                                                    <tr>
                                                    <td style="text-align: right; vertical-align: middle;" colspan="3">
                                                        <b style="color: blue;">(9) สรุปคะแนนส่วนพฤติกรรมการปฏิบัติราชการ   (สมรรถนะ) =	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                                        <b style="color: blue;">  ผลรวมคะแนน ใน (8)</b>
                                                        <div style="display: flex; justify-content: flex-end;">
                                                            <hr style="border: 1px solid black; width: 20%;">
                                                        </div>
                                                        <b style="color: blue;">จำนวนสมรรถนะที่ใช้ในการประเมิน X 3 คะแนน</b>
                                                    </td>
                                                    <td></td>
                                                    
                                                </tr>  
                                                </tbody>
                                                    <br>
                                                    <div class="p-fluid formgrid grid"> 
                                                        <B><h4>ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</h4></B>
                                                        <div class="field col-12 md:col-12">  
                                                            <label for="improvements">1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</label>
                                                            <p style="margin-left: 20px;">{{ improvements??'- ไม่มีข้อมูล -' }}</p>
                                                        </div>
                                                        <div class="field col-9 md:col-9">  
                                                            <label for="suggestions">2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</label>
                                                            <p style="margin-left: 20px;">{{ suggestions??'- ไม่มีข้อมูล -' }}</p> 
                                                    </div>
                                                </div>   
                                            </div>
                                        </div> 
                                    </div>
                                </div>  
                            </div>  
                        </div>  
                    <template #footer>
                        <Button label="ตกลง" icon="pi pi-check" class="mb-2 mr-2" @click="DialogAdd = false " />
                    </template>
                </Dialog>  
              </div>
            </div>
        </div>     
    </template>

<script setup> 
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    const staffidData = ref('');
    
    onMounted(async () => { 
        staffidData.value = user ? user.user.image : ''; 
    });
    
</script>
<script> 
    import { ref } from 'vue';
    import axios from 'axios';  
    import Swal from 'sweetalert2'
    export default {
        data() {
            return { 
                year_Main: 2568,
                staffid_Main: 5009942, 
                facid_Main: 201092704000,
                groupid_Main: '01', 
                Table_data: [],
                dropdownItemYear: 2568,
                DialogAdd: false,
                displayDialog: false, 
            };
        }, 
        async mounted(){
            // await this.showDataRecord(); 
        }, 
        methods: { 
            async showDataRecord(staffidData){ 
                await axios.post('/evaluatebackend/api/showDataRecord',{ 
                    staff_id: staffidData
                }).then(res => {     
                    console.log(res.data);  
                    this.Table_data=res.data;   
                })
                .catch(error => {
                    console.error('Error:', error);
                });
            },   
            openDataEvalu(){  
                console.log(this.staffidData);
                
                this.DialogAdd = true; 
                // axios.post('/evaluatebackend/api/showDataValuate',{
                //     staff_id: staff_id,
                //     fac_id: this.facid_Main,
                //     year_id: this.dropdownItemYear.code,
                // }).then(res => {     
                //     // console.log(res.data);  
                //     this.products_person=res.data; 
                //     this.DialogAdd = true; 
                //     //this.showDataP03();
                // })
                // .catch(error => {
                //     console.error('Error:', error);
                // });
            },
            closeCallback(){
                this.DialogAdd = false;
            },
           
        
        },
        // async mounted() {
        //         const  { signIn, getSession, signOut } = await useAuth()
        //         const user = await getSession();
        //     }, 
    }  
</script>

<style>  

</style>