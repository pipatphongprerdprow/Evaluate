<template>
    <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP01"></Button>
    </div> 
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12"> 
            <div class="card mb-0">
                <!-- {{ dataPor }} --> 
                <div class="formgroup-inline mb-1"> 
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-fw pi-folder-open" style="font-size: x-large;"></i> แบบ ป01
                        </h3>
                    </div>
                    <div class="col md:col-6"> 
                        <!-- {{ currentDate }} -- {{ dataPor.d_recordingday }} -->
                        <!-- <div v-if="!isCurrentDateAfter"> -->
                        <div v-if="currentDate < dataPor.d_recordingday">
                            <Button icon="pi pi-search" severity="help" class="mb-2 mr-6" label="เลือกข้อมูลแบบประเมิน ป.01" @click="OpenDialogP01" /> 
                            <Button icon="pi pi-plus" severity="info" class="mb-2 mr-6" label="เพิ่มข้อมูลแบบประเมิน" @click="OpenDialogAdd" />
                        </div> 
                    </div>  
                </div>  
                <!-- แสดงข้อมูลบันทึก -->
                <table class="table" >
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
                        <template v-for="(h, ind) in products_personX" :key="ind">  
                            <tr>
                                <td style="text-align: left;" colspan="8">
                                    <b style="color: blue;">{{ h.id }}. {{ h.nameH }}</b>
                                </td>
                                <td class="text-center" style="color: blue;"><b>{{ h.p01_weight??0}}%</b></td> 
                                <!-- <td class="text-center" style="color: blue;"><b>{{ h.h_weight }}%</b></td>  -->
                                <td></td>
                                <td></td> 
                            </tr> 
                            <tr v-for="(subP01, idx) in h.subP01sX" :key="idx" style="vertical-align: baseline;"> 
                                <td style="text-align: left;">{{ subP01.p01_no }} {{ subP01.p01_subject }}</td>
                                <td style="text-align: left;">
                                    <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p01_subject }}</b>
                                    <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                        <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                        <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
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
                                <td style=" vertical-align: middle;" class="text-center">{{ subP01.p01_score }}</td>
                                <td style="vertical-align: middle;" class="text-center">{{ subP01.p01_weight }}%</td> 
                                <td style=" vertical-align: middle;" class="text-center">{{ (subP01.p01_score * subP01.p01_weight / 100).toFixed(2) }}</td>
                                
                                <td style=" vertical-align: middle;" class="text-center">
                                    <!-- <div v-if="!isCurrentDateAfter"> -->
                                    <div v-if="currentDate < dataPor.d_recordingday">
                                        <SplitButton label="เลือก" :model="itemsBtu(subP01)" severity="warning" class="mb-2 mr-2"></SplitButton>
                                    </div> 
                                </td> 
                            </tr>
                        </template>
                        <tr>
                            <td style="text-align: right" colspan="8">
                                <b style="color: blue;">(7) ผลรวม</b>
                            </td> 
                            <td class="text-center" style="color: blue;">
                                <b>{{ totalWeight }}%</b> <!-- แสดงผลรวม p01_weight -->
                            </td>
                            <td class="text-center" style="color: blue;">
                                <b>{{ totalCalculatedScore }}</b> <!-- แสดงผลรวมคะแนนที่คำนวณ -->
                            </td>
                            <td></td> 
                        </tr>
                        <tr>
                            <td style="text-align: center; vertical-align: middle;" colspan="9">
                                <b style="color: blue;">(8) สรุปคะแนนส่วนผลสัมฤทธิ์ของงาน =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
                                <b style="color: blue;">ผลรวมของค่าคะแนนถ่วงน้ำหนัก</b>
                                <b style="display: block; text-align: right; color: blue;">{{ totalCalculatedScore}}</b>
                                <div style="display: flex; justify-content: flex-end;">
                                    <hr style="border: 1px solid black; width: 80%;">
                                </div>
                                <b style="display: block; text-align: right; color: blue;">{{ 5 }}</b>
                                <b style="color: blue;">จำนวนระดับค่าเป้าหมาย = 5 </b>
                            </td>
                            <td class="text-center" style="color: blue;  vertical-align: middle;">
                                <!-- <b>{{ totalCalculatedScore }}</b> = --> 
                                <div v-if="currentDate >= dataPor.d_scoringday">
                                    <b> = {{ WeightedScoreSum }}</b> 
                                </div>
                            </td>
                            <td></td>
                        </tr>  
                    </tbody>
                </table>   
            </div> 
        </div> 

        <!-- เลือกข้อมูลแบบประเมิน ป.01 -->
        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAddP01" :breakpoints="{ '960px': '75vw' }" :style="{ width: '90vw' }" :modal="true" position="top"> 
            <form>
                <div class="p-fluid formgrid grid">
                    <div class="field col-12 md:col-12">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th rowspan="2" style="width: 9%;"><br> ตัวเลือก <br> <Checkbox v-model="selectAll" @change="toggleSelectAll" /></th>
                                    <th rowspan="2" style="width: 20%;">(1) <br> กิจกรรม / โครงการ / งาน</th>
                                    <th rowspan="2" style="width: 24%;">
                                        (2) <br> ตัวชี้วัด / เกณฑ์การประเมิน <br>
                                        (1.ถูกต้อง 2.ครบถ้วน <br> 3.ตรงเวลา)
                                    </th>
                                    <th colspan="5" style="width: 15%;">(3) <br> ระดับค่าเป้าหมาย</th>
                                    <th rowspan="2" style="width: 7%;">(4) <br> ค่าคะแนน ที่ได้</th>
                                    <th rowspan="2" style="width: 10%;">(5) <br> น้ำหนัก (ความสำคัญ/ <br> ความยากง่ายของงาน)</th>
                                    <th rowspan="2" style="width: 10%;">(6) <br> ค่าคะแนน <br>ถ่วงน้ำหนัก <br> (4) X (5) 100</th>
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
                                            <b style="color: blue;">{{ item.id }}. {{ item.nameH }} </b>
                                        </td>
                                        <td></td>
                                        <!-- <td class="text-center" style="color: blue;"> <b>{{ h.p_weight??0 }}%</b></td>  --> 
                                        <td></td> 
                                        <td></td>
                                    </tr>
                                    <tr v-for="(subP01, idx) in item.subP01s" :key="idx" style="vertical-align: baseline;">
                                        <!-- <tr v-for="(subP01, idx) in [...item.subP01s].sort((a, b) => {
                                            const aParts = a.p_no.split('.').map(Number);
                                            const bParts = b.p_no.split('.').map(Number);

                                            if (aParts[0] !== bParts[0]) {
                                                return aParts[0] - bParts[0]; // เรียงตามหลักแรก (ก่อนจุด)
                                            }
                                            return (aParts[1] || 0) - (bParts[1] || 0); // เรียงตามหลักหลังจุด ถ้ามี
                                        })" :key="idx" style="vertical-align: baseline;"></tr> -->
                                        <td class="text-center">
                                            <Checkbox :id="'checkOption-' + subP01.p_id" :name="'option-' + subP01.p_id" :value="subP01.p_id" v-model="checkboxValue" />
                                        </td>
                                        <td style="text-align: left;">{{ subP01.p_no }} {{ subP01.p_subject }}</td>
                                        <td style="text-align: left;">
                                            <b>ตัวชี้วัดที่ {{ idx+1 }} {{ subP01.p_subject }}</b>
                                            <p v-for="(subIitem, idI) in subP01.subITems" :key="idI" style="padding-left: 8px;margin-bottom: 5px;">
                                                <div v-if="subIitem.ind_no!=0"><b>ระดับ {{ subIitem.ind_no }}</b> {{ subIitem.ind_Items }}</div>
                                                <div v-if="subIitem.ind_no==0"><b>{{ subIitem.ind_Items }}</b></div>
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
        <Dialog header="จัดการแบบ ป01" maximizable v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '100vw' }" :modal="true" position="top">
            <form>
                <div class="p-fluid formgrid"> 
                    <form>
                        <InputText v-model="text_edt" type="hidden" />
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
                                    <InputText v-model="text_no" type="text" placeholder="ข้อ" autocomplete="off" /> 
                                </InputGroup> 
                            </div>
                            <div class="field col-12 md:col-6">
                                <label for="text_name">ชื่อตัวชี้วัด</label>
                                <InputGroup>
                                    <InputGroupAddon>
                                        <i class="pi pi-book"></i>
                                    </InputGroupAddon>
                                    <Textarea v-model="text_name" rows="1" placeholder="ชื่อตัวชี้วัด" autocomplete="off" /> 
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
                                    <InputText v-model.number="text_weight" type="number" placeholder="น้ำหนัก(ความสำคัญ / ความยากง่ายของงาน)" autocomplete="off" step="0.01" />
                                </InputGroup>
                            </div>  
                        </div> 
                        <hr>
                        <div class="p-fluid formgrid grid">
                            <div class="field col-12 md:col-12"> 
                                <label for="text_search_no">เกณฑ์การประเมิน</label>
                                <InputGroup>  
                                    <InputText v-model="text_search_no" type="number" placeholder="ระดับ" autocomplete="off" class="col-12 md:col-2" /> 
                                    <InputText v-model="text_search" type="text" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off"/> 
                                    <Button icon="pi pi-save" label="บันทึก" severity="warning" @click="AddDatalist" />
                                </InputGroup>  
                            </div>   
                        </div> 
                        <DataTable :value="products_list" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">    
                            <Column field="ind_no" header="ระดับ" style="width: 10%">
                                <template #body="Item">
                                    ระดับที่ {{ Item.data.ind_no }}
                                </template>
                            </Column> 
                            <Column field="ind_Items" header="ชื่อตัวชี้วัด / เกณฑ์การประเมิน" style="text-align: left;width: 80%">
                                <template #body="Item"> 
                                {{ Item.data.ind_Items }}
                                </template>
                            </Column>  
                            <Column field="options" header="ตัวเลือก" style="text-align: center; width: 10%">
                                <template #body="Item"> 
                                    <Button style="text-align: center;" severity="primary" icon="pi pi-pencil" class="p-button-text" outlined rounded @click="EditRegislick(Item.data)"></Button> &nbsp;
                                    <Button style="text-align: center;" severity="danger" icon="pi pi-trash" class="p-button-text" outlined rounded @click="DeleteRegislick(Item.data.ind_no)"></Button>
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

        <!-- แก้ไขข้อมูลเกณฑ์การประเมิน -->
        <Dialog header="แก้ไขข้อมูลเกณฑ์การประเมิน" maximizable v-model:visible="DialogEditList" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
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
                                <InputText v-model="text_searchEdit" type="text" placeholder="รายละเอียดเกณฑ์การประเมิน" autocomplete="off"/>  
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
import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2' 

export default {
    props: {
        // กำหนด props ที่จะรับข้อมูลจาก parent
        dataPor: {
            type: Object,
            required: true
        }
    },
    data() {
        return { 
            staffid_Main: null,
            year_Main: null,
            facid_Main: null,
            groupid_Main: null, 
            currentDate: new Date().toISOString().split('T')[0],
            products_personX: [],
            checkboxValue: [],
            selectedItems: [], 
            selectAll: false,
            DialogAdd: false,
            DialogAddP01: false,
            //เพิ่มมา
            products_person: [],    
                itemsBtu: (item) => [
                    {
                        label: 'แก้ไขข้อมูล',
                        icon: 'pi pi-refresh',
                        command: () => {
                            this.editDatax(item);
                        }
                    },
                    {
                        label: 'ลบข้อมูล',
                        icon: 'pi pi-times',
                        command: () => {
                            this.delDatax(item);
                            
                        }
                    }
                ],  
             // Dialog
            text_edt: null,
            dropdownItemH: null ,
            dropdownItemsH: [],
            text_no: null,
            text_name: null, 
            dropdownItemTarget: null ,
            dropdownItemsTarget: [
                { name: 'ระดับเป้าหมาย 1', value: 1 },
                { name: 'ระดับเป้าหมาย 2', value: 2 },
                { name: 'ระดับเป้าหมาย 3', value: 3 },
                { name: 'ระดับเป้าหมาย 4', value: 4 },
                { name: 'ระดับเป้าหมาย 5', value: 5 },
            ],
            text_weight: null,
            text_search_no: null,
            text_search: null,
            products_list: [], 
            dataP01: {}, 
            totalWeight: {},
            totalCalculatedScore: {},
            WeightedScoreSum :{},
            // 
            DialogEditList: false,
            text_search_noEdit: null,
            text_searchEdit: null,
        } 
    }, 
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
       // console.log(user.user.name);
        const {STAFFID, SCOPES} = user.user.name
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(STAFFID,staffdepartment,groupid); 
        // this.showDataPerson();
    }, 
    watch: {
        // เฝ้าดูการเปลี่ยนแปลงของ dataPor
        dataPor: {
            handler(newVal, oldVal) {
                // console.log('dataPor changed:', newVal);
                this.showDataPerson();
                    // ทำสิ่งที่ต้องการเมื่อ dataPor เปลี่ยนแปลง
            },
            deep: true // ใช้ deep: true เพื่อดูการเปลี่ยนแปลงภายใน object
        },
            checkboxValue(newVal) {
            // ตรวจสอบว่าช่องเลือกทั้งหมดถูกเลือกหรือไม่
            const totalItems = this.products_person.flatMap(item => item.subP01s).length;
            this.selectAll = newVal.length === totalItems;
        },
    },
    computed: {
        // isCurrentDateAfter() {
        //     return new Date(this.currentDate).getTime() > new Date(this.dataPor.d_recordingday).getTime();
        // },
        totalWeight() {
    const total = this.products_personX.reduce((total, h) => {
        return total + h.subP01sX.reduce((subTotal, subP01) => {
            return subTotal + parseFloat(subP01.p01_weight);
        }, 0);
    }, 0);

    const roundedTotal = parseFloat(total.toFixed(2));

    if (roundedTotal > 100) {
        Swal.fire({
            icon: "warning",
            title: "คะแนนเกินกำหนด",
            text: "คะแนนรวมเกิน 100% กรุณาปรับค่าใหม่!",
        });
    }

    return roundedTotal;
},
        totalCalculatedScore() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ
            return this.products_personX.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + (subP01.p01_score * subP01.p01_weight / 100);
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(2) เพื่อให้มีทศนิยม 2 ตำแหน่ง
        },
        WeightedScoreSum() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ และหารด้วย 5
            return this.products_personX.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    // คำนวณคะแนนรวม (subP01.p01_score * subP01.p01_weight / 100) แล้วหารด้วย 5
                    return subTotal + ((subP01.p01_score * subP01.p01_weight / 100) / 5);
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(3) เพื่อแสดงทศนิยม 3 ตำแหน่ง
        }
    }, 
    methods: {  
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main  
        }, 
        // ดึงข้อมูลเข้าตาราง 
        showDataPerson(){  
            //console.log('dataPor: ',this.dataPor); 
            axios.post('   http://127.0.0.1:8000/api/showDataPersonX',{
            staff_id: this.staffid_Main,
            fac_id: this.dataPor.fac_id,
            year_id: this.dataPor.d_date, 
            evalua: this.dataPor.evalua 
            // group_id: this.groupid_Main,  
            }).then(res => {     
                // console.log(res.data);  
                this.products_personX=res.data;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 

        // ดึงข้อมูลมาแก้ไข
        async editDatax(data){    
          await axios.post('   http://127.0.0.1:8000/api/edtDataPersonx',{
              p01_id: data.p01_id
          }).then(res => { 
                // console.log(data);   
                this.DialogAdd = true; 
                this.text_edt = res.data[0].p01_id;   
                this.text_no = res.data[0].p01_no; 
                this.text_name = res.data[0].p01_subject;  
                const target_f = this.dropdownItemsTarget.filter(f=>f.value==res.data[0].p01_target)
                this.dropdownItemTarget = target_f.length > 0 ? target_f[0] : null;    
                this.text_weight = res.data[0].p01_weight;  
                this.products_list = res.data[0].sub_ITem; 
                this.selectDataHEdt(res.data[0].p01_h); 
          })
          .catch(error => {
              console.error('Error:', error);
          });
        }, 
        // ดึงข้อมูลภาระงาน
        selectDataHEdt(he){  
            axios.post('   http://127.0.0.1:8000/api/selectDataPersonH').then(res => {     
                // console.log(res.data); 
                this.dropdownItemsH=res.data;  
                const h_f = res.data.filter(f=>f.id==he); 
                this.dropdownItemH = h_f.length > 0 ? h_f[0] : null;    
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // ลบข้อมูล
        async delDatax(data) {        
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
                    axios.post('   http://127.0.0.1:8000/api/delDataPersonx', {
                        p01_id: data.p01_id
                    }).then(res => { 
                        this.showDataPerson(); 
                        Swal.fire({
                            title: "ลบข้อมูลเสร็จสิ้น!",
                            text: "ข้อมูลของคุณถูกลบแล้ว",
                            icon: "success"
                        });
                    }).catch(error => {
                        console.error('Error:', error);
                    }); 
                }
            }); 
        },
        // printDataP01
        async printDataP01() {  
            const { signIn, getSession, signOut } = await useAuth()
            const user = await getSession(); 
            // console.log(user.user.name);   
            const form = {
                staff_id: this.staffid_Main,
                group_id: this.groupid_Main,
                fac_id: this.dataPor.fac_id,
                year_id: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
                STAFFNAME :user.user.name.STAFFNAME,
                STAFFSURNAME:user.user.name.STAFFSURNAME,
                POSITIONNAME:user.user.name.POSITIONNAME,
                GROUPTYPENAME:user.user.name.GROUPTYPENAME,
                POSTYPENAME:user.user.name.POSTYPENAME, 
                SCOPES:user.user.name.SCOPES.staffdepartmentname
            }
           
            

            const queryParams = new URLSearchParams(form).toString();
            // console.log(queryParams); 
            const url = `   http://127.0.0.1:8000/report_p01?${queryParams}`;
            window.open(url, '_blank');
 
        },

//*================== Start เลือกข้อมูลแบบประเมิน ป.01 ==================*//
        // เปิดหน้าต่างสำหรับบันทึก *ดึงข้อมูล
        OpenDialogP01(){  
            axios.post('   http://127.0.0.1:8000/api/showDataPerson', { 
                fac_id: this.dataPor.fac_id,
                year_id: this.dataPor.d_date,
                evalua: this.dataPor.evalua 
            }).then(res => {     
                //console.log(res.data);
                
                this.DialogAddP01 = true; 
                this.products_person = res.data;
                this.checkboxValue= [];
            })
            .catch(error => {
                console.error('Error:', error);
            }); 
        }, 
        // บันทึกข้อมูล ป01 *ดึงข้อมูล
        async savetablechkem() {    
            let x = []
            this.products_person.forEach((v) => {
                const selectedItems = v.subP01s.filter(item => this.checkboxValue.includes(item.p_id)); 
                x = x.concat(selectedItems);
            }) 
            // console.log(x.length);  
            if(x.length == 0){
                Swal.fire("ไม่มีข้อมูล","กรุณาเลือกข้อคำถามจาก ตัวจัดการ !","error");
            }else{
            await axios.post('   http://127.0.0.1:8000/api/savePushDataP01',{
                data: x,
                staffid_Main: this.staffid_Main,
            }).then(res => { 
                //console.log(res.data);  
                this.showDataPerson(); 
                this.DialogAddP01 = false; 
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบจัดการ ป01 เรียบร้อย!",
                    icon: "success"
                }); 
            })
            .catch(error => {
                console.error('Error:', error);
            });  
            }
        },
        // ปิดหน้าต่างสำหรับบันทึก *ดึงข้อมูล
        cancelDialogs(){
            this.DialogAddP01 = false; 
        },
//*================== End เลือกข้อมูลแบบประเมิน ป.01 ==================*//


//*================== Start เพิ่มข้อมูลแบบประเมิน ==================*//
        // เปิดหน้าต่างสำหรับบันทึก 
        OpenDialogAdd(){
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
        }, 
        // ดึงข้อมูลภาระงาน
        selectDataH(){  
            axios.post('   http://127.0.0.1:8000/api/selectDataPersonH').then(res => {     
                //console.log(res.data); 
                this.dropdownItemsH=res.data;  
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
        // บันทึกตัวชี้วัด / เกณฑ์การประเมิน
        AddDatalist(){    
            if(this.text_search_no == null || this.text_search == null){ 
                Swal.fire("ไม่มีข้อมูล","กรุณาตรวจสอบข้อมูล ลำดับ - ชื่อตัวชี้วัด / เกณฑ์การประเมิน!","error");
            } else {    
                this.products_list.push({
                    ind_no: this.text_search_no,
                    ind_Items: this.text_search
                });   
                this.products_list.sort((a, b) => a.ind_no - b.ind_no);  
                this.text_search_no = null;
                this.text_search = null;
            } 
        },
        // ลบตัวชี้วัด / เกณฑ์การประเมิน
        DeleteRegislick(data){
            this.products_list = this.products_list.filter(product => product.ind_no !== data); 
        },
 
        // แก้ไขตัวชี้วัด / เกณฑ์การประเมิน
        EditRegislick(data){
            //console.log(data);
            this.text_search_noEdit = null;
            this.text_searchEdit = null;
            if(data){
                this.DialogEditList = true; 
                this.text_search_noEdit = data.ind_no;
                this.text_searchEdit = data.ind_Items;
            } 
        },
        cancelDialogEdit(){ 
            this.DialogEditList = false;  
        }, 
        saveDataxEdit(){ 
            // console.log({
            //     text_search_noEdit: this.text_search_noEdit,
            //     text_searchEdit: this.text_searchEdit
            // });

            // สมมติว่าเรามีฟังก์ชันสำหรับอัพเดตข้อมูลใน array
            let updatedItem = {
                ind_no: this.text_search_noEdit,
                ind_Items: this.text_searchEdit
            };

            // ค้นหาข้อมูลที่ต้องการแก้ไขใน products_list และอัพเดต
            const index = this.products_list.findIndex(item => item.ind_no === this.text_search_noEdit);
            if (index !== -1) {
                this.products_list[index] = updatedItem;
            }

            // ปิด Dialog หลังบันทึกข้อมูล
            this.DialogEditList = false;  
        },  
        // บันทึกแบบจัดการ ป.1 
        async saveDatax() {
            await axios.post('   http://127.0.0.1:8000/api/saveDataP01User',{
                staff_id: this.staffid_Main,
                fac_id: this.dataPor.fac_id,
                year_id: this.dataPor.d_date, 
                evalua: this.dataPor.evalua,
                text_edt: this.text_edt,
                dropdownItemH: this.dropdownItemH.id,
                text_no: this.text_no,
                text_name: this.text_name,
                text_target: this.dropdownItemTarget.value,
                text_weight: this.text_weight, 
                products_list: this.products_list
            }).then(res => {  
                //  console.log(res.data); 
                this.DialogAdd = false;
                this.showDataPerson(); 
                Swal.fire({
                    title: "เรียบร้อย!",
                    text: "บันทึกข้อมูล แบบ ป01 เรียบร้อย!",
                    icon: "success"
                });
                
            })
            .catch(error => {
                console.error('Error:', error);
            });
 
        }, 
        // ปิดบันทึกแบบจัดการ ป.1 
        cancelDialog(){
            this.DialogAdd = false;
        },   
        toggleSelectAll() {
            if (!this.products_person) {
                console.error("products_person เป็น undefined หรือ null");
                return;
            } 
            
            if (this.selectAll) {
                this.checkboxValue = this.products_person.flatMap(person =>
                    person.subP01s ? person.subP01s.map(subP01 => subP01.p_id) : []
                );
            } else {
                this.checkboxValue = []; 
            }

            //console.log("selectAll:", this.selectAll);
            //console.log("checkboxValue:", this.checkboxValue);
        }

    }
} 
//*================== End เพิ่มข้อมูลแบบประเมิน ==================*// 
 </script>

<style scoped> 
    label{
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
    .table th, .table td {
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
</style>
