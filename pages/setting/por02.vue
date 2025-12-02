<template>
    <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP01"></Button>
    </div> 
    <div class="card">
        <h3 class="mb-4" style="text-align: left;">
            <i class="pi pi-folder-open" style="font-size: x-large;"></i> แบบ ป02
        </h3>
        <h4>
            ข้อตกลงและแบบการประเมินผลสัมฤทธิ์ของงานของข้าราชการและพนักงาน 
            สังกัดมหาวิทยาลัยมหาสารคาม (องค์ประกอบที่ 2)
        </h4>
        <br> 
        <div class="p-fluid formgrid grid">  
            <!-- ตาราง ก. สมรรถนะหลัก -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 40%;">ก. สมรรถนะหลัก (สำหรับข้าราชการและพนักงานทุกคน)</th>
                            <th style="width: 20%;">(1)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th>
                            <th style="width: 20%;">(2)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row1, index) in coreCompetencies" :key="index">
                            <td
                                style="text-align: left; cursor: pointer; color: #0d47a1;"
                                @click="openCompetencyDialog('core', row1)"
                            >
                                {{ row1.activity }}
                            </td>  
                            <td>
                                <p>{{ row1.indicator }}</p>
                            </td>   
                            <td>  
                                <b v-if="row1.selfAssessment == '' ||  row1.selfAssessment == null" style="color: red;">0</b> 
                                <b v-if="row1.selfAssessment != 0 " style="color: blue" >{{ row1.selfAssessment }}</b> 
                            </td>
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
                            <th style="width: 50%;">ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ (สำหรับข้าราชการและพนักงานเฉพาะตามตำแหน่งที่รับผิดชอบตามที่ ก.บ.ม. กำหนด)</th>
                            <th style="width: 20%;">(3)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมินตนเอง</th>
                            <th style="width: 20%;">(4)ระดับ<br>สมรรถนะ<br>ที่แสดงออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row2, index) in jobSpecificCompetencies" :key="index"> 
                            <td
                                style="text-align: left; cursor: pointer; color: #0d47a1;"
                                @click="openCompetencyDialog('job', row2, index)"
                            >
                                ข. {{ index + 1 }} {{ row2.WORK_NAME }}
                            </td> 
                            <td>{{ row2.COMPLEVEL }}</td>  

                            <td>  
                                <b v-if="row2.SCOREPERSON == '' || row2.SCOREPERSON == null" style="color: red;">0</b> 
                                <b v-if="row2.SCOREPERSON != 0 " style="color: blue;" >{{ row2.SCOREPERSON }}</b> 
                            </td>
                            <td> 
                                <b v-if="row2.SCORE == null || row2.SCORE == '' " style="color: red;">0</b> 
                                <b v-if="row2.SCORE != 0 " >{{ row2.SCORE }}</b> 
                            </td> 
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- ตาราง ค. สมรรถนะทางการบริหาร -->
            <div class="field col-12 md:col-4"> 
                <table id="ratingTable">
                    <thead>
                        <tr>
                            <th style="width: 60%;">ค. สมรรถนะทางการบริหาร (สำหรับตำแหน่งประเภทบริหารตามที่ ก.บ.ม. กำหนด)</th>
                            <th style="width: 20%;">(5)ระดับ<br>สมรรถนะ<br>ที่คาดหวัง</th>
                            <th style="width: 20%;">ระดับ<br>สมรรถนะ<br>ประเมิน<br>ตนเอง</th>
                            <th style="width: 20%;">(6)ระดับ<br>สมรรถนะ<br>ที่แสดง<br>ออก</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(row3, index) in otherCompetencies" :key="index">
                            <td
                                style="text-align: left; cursor: pointer; color: #0d47a1;"
                                @click="openCompetencyDialog('other', row3)"
                            >
                                {{ row3.activity }}
                            </td> 
                            <td>
                                <b v-if="row3.indicator3 == '' ||  row3.indicator3 == null" style="color: red;">-</b>
                                <span v-if="row3.indicator3 != 0">{{ row3.indicator3 }}</span>  
                            </td>
                            <td>  
                                <b v-if="row3.datatable3 == '' ||  row3.datatable3 == null" style="color: red;">-</b> 
                                <b v-if="row3.datatable3 != 0 " style="color: blue" >{{ row3.datatable3 }}</b> 
                            </td>
                            <td>  
                                <b v-if="row3.selfAssessment3 == '' ||  row3.selfAssessment3 == null" style="color: red;">-</b>  
                                <b v-if="row3.selfAssessment3 != 0 " >{{ row3.selfAssessment3 }}</b> 
                            </td>
                        </tr> 
                    </tbody>
                </table> 
            </div>
        </div> 
    </div>

    <!-- Dialog แสดงคำอธิบายสมรรถนะ -->
    <Dialog
        header="รายละเอียดสมรรถนะ"
        v-model:visible="competencyDialogVisible"
        :modal="true"
        :style="{ width: '60vw' }"
    >
        <h4>{{ selectedCompetency.title }}</h4>
        <p style="white-space: pre-line;">
            {{ selectedCompetency.description }}
        </p>
    </Dialog>

    <br>
    <div class="p-fluid formgrid grid"> 
        <b><h4>ความเห็นเพิ่มเติมของผู้ประเมิน (ระบุข้อมูลเมื่อสิ้นรอบการประเมิน)</h4></b>
        <div class="field col-12 md:col-12">  
            <label for="improvements">1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข</label>
            <p style="margin-left: 20px;">{{ improvements ?? '- ไม่มีข้อมูล -' }}</p>
        </div>
        <div class="field col-9 md:col-9">  
            <label for="suggestions">2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา</label>
            <p style="margin-left: 20px;">{{ suggestions ?? '- ไม่มีข้อมูล -' }}</p> 
        </div>
    </div>  
</template>

<script>
import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2' 
import InputText from 'primevue/inputtext';

export default {
    props: {
        dataPor: {
            type: Object,
            required: true
        },
        tab2Reload: {
            type: String,
            default: '0'
        } 
    },
    data() {
        return {
            // ตาราง ก. สมรรถนะหลัก
            coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '', data_table1: '', selfAssessment:'' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '', data_table1: '', selfAssessment:'' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '', data_table1: '', selfAssessment:'' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '', data_table1: '', selfAssessment:'' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '', data_table1: '', selfAssessment:'' }
            ],
            // ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [], 
             
            // ตาราง ค. สมรรถนะทางการบริหาร
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: '0', datatable3: '', selfAssessment3:''},
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: '0', datatable3: '', selfAssessment3:'' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: '0', datatable3: '', selfAssessment3:'' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: '0', datatable3: '', selfAssessment3:'' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: '0', datatable3: '', selfAssessment3:'' }
            ],  

            postypetext: null,
            posadio: 0,

            improvements: null,
            suggestions: null,
 
            // fallback คำอธิบายสมรรถนะหลัก
            coreDescriptions: {
                1: 'คำอธิบาย ก.1 การมุ่งผลสัมฤทธิ์\n\nความมุ่งมั่นจะปฏิบัติหน้าที่ราชการให้ดีหรือให้เกินมาตรฐานที่มีอยู่ โดยมาตรฐานนี้อาจเป็นผลการปฏิบัติงานที่ผ่านมาของตนเอง หรือเกณฑ์วัดผลสัมฤทธิ์ที่สถาบันอุดมศึกษา กำหนดขึ้น อีกทั้งยังหมายรวมถึงการสร้างสรรค์พัฒนาผลงานหรือกระบวนการปฏิบัติงานตามเป้าหมายที่ยากและท้าท้ายชนิดที่อาจไม่เคยมีผู้ใดสามารถกระทำได้มาก่อน',
                2: 'คำอธิบาย ก.2 การบริการที่ดี\n\nความตั้งใจและความพยายามของข้าราชการ และพนักงานในการให้บริการต่อประชาชน ข้าราชการ หรือหน่วยงานอื่นๆ ที่เกี่ยวข้อง',
                3: 'คำอธิบาย ก.3 การสั่งสมความเชี่ยวชาญในงานอาชีพ\n\nความสนใจใฝ่รู้ สั่งสม ความรู้ความสามารถของตนในการปฏิบัติหน้าที่ราชการด้วยการศึกษา ค้นคว้า และพัฒนาตนเองอย่างต่อเนื่องจนสามารถประยุกต์ใช้ความรู้เชิงวิชาการและเทคโนโลยีต่างๆ เข้ากับการปฏิบัติราชการให้เกิดผลสัมฤทธิ์',
                4: 'คำอธิบาย ก.4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม\n\nการดำรงตนและประพฤติปฏิบัติอย่างถูกต้องเหมาะสมทั้งตามกฎหมาย คุณธรรมจรรยาบรรณแห่งวิชาชีพ และจรรยาข้าราชการ พนักงานเพื่อรักษาศักดิ์ศรีแห่งความเป็นข้าราชการ พนักงาน',
                5: 'คำอธิบาย ก.5 การทำงานเป็นทีม\n\nความตั้งใจที่จะทำงานร่วมกับผู้อื่น เป็นส่วนหนึ่งของทีม หน่วยงาน หรือสถาบันอุดมศึกษา โดยผู้ปฏิบัติมีฐานะเป็นสมาชิก ไม่จำเป็นต้องมีฐานะหัวหน้าทีมรวมทั้งความสามารถในการสร้างและรักษาสัมพันธภาพกับสมาชิกในทีม'
            },
 
            // fallback คำอธิบายสมรรถนะทางการบริหาร
            otherDescriptions: {
                12: 'คำอธิบาย ค.1 สภาวะผู้นำ\n\nตัวอย่าง: สามารถชี้ทิศทาง แบ่งงาน มอบหมายหน้าที่ และเป็นแบบอย่างที่ดีให้กับผู้ใต้บังคับบัญชา',
                13: 'คำอธิบาย ค.2 วิสัยทัศน์\n\nตัวอย่าง: มองภาพรวมระยะยาว วิเคราะห์แนวโน้ม และกำหนดทิศทางการทำงานของหน่วยงานให้สอดคล้องกับยุทธศาสตร์',
                14: 'คำอธิบาย ค.3 การวางกลยุทธ์ภาครัฐ\n\nตัวอย่าง: เข้าใจนโยบายภาครัฐ แปลงนโยบายสู่แผนงาน/โครงการที่ปฏิบัติได้จริง',
                15: 'คำอธิบาย ค.4 ศักยภาพเพื่อนำการปรับเปลี่ยน\n\nตัวอย่าง: ขับเคลื่อนการเปลี่ยนแปลง จัดการกับความต้านทาน และสื่อสารให้บุคลากรเข้าใจ',
                16: 'คำอธิบาย ค.5 การสอนงานและการมอบหมายงาน\n\nตัวอย่าง: ถ่ายทอดความรู้ แนะนำงานอย่างเป็นระบบ มอบหมายงานเหมาะสมกับความสามารถและติดตามผล'
            },

            // master stf_compentency: key = WORK_NAME, value = ทั้ง row (ใช้หา WORK_DATAIL สำหรับ ก. และ ค.)
            competencyMap: {},

            competencyDialogVisible: false,
            selectedCompetency: {
                title: '',
                description: ''
            },
        };   
    }, 
    async mounted(){ 
        const { signIn, getSession, signOut } = await useAuth()
        const user = await getSession();
        
        const {STAFFID, SCOPES} = user.user.name 
        const {staffdepartment, groupid, staffdepartmentname, groupname} = SCOPES
        await this.setSession(
            STAFFID,
            staffdepartment,
            groupid,
            user.user.name.POSTYPENAME,
            user.user.name.POSITIONNAMEID,
            user.user.name.POSITIONNAME
        ); 

        // โหลด master stf_compentency มา map ชื่อ → WORK_DATAIL
        this.loadCompetencyDescriptions();
    },  
    watch: {
        tab2Reload(v) { 
            this.showdataPo();
            this.getjobSpecificCompetencies();
        },  
        dataPor: {
            handler(newVal, oldVal) {
                this.showdataPo();
                this.getjobSpecificCompetencies();
            },
            deep: true 
        },
    },
    methods: {  
        setSession (staffid_Main,facid_Main,groupid_Main,postypename,postypenameid,positionname) {
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main   
            this.postypename = postypename    
            this.postypenameid = postypenameid    
            this.positionname = positionname   
            this.getAadioPosition(staffid_Main);
        },

        async loadCompetencyDescriptions() {
            try {
                // API นี้คืน stf_compentency ทั้งตาราง
                const res = await axios.get('http://127.0.0.1:8000/api/competencies');
                const map = {};
                (res.data || []).forEach(item => {
                    if (item.WORK_NAME) {
                        map[item.WORK_NAME.trim()] = item;
                    }
                });
                this.competencyMap = map;
            } catch (e) {
                console.error('loadCompetencyDescriptions error', e);
            }
        },

        async getAadioPosition(staffid_Main){
            try {   
                if (staffid_Main) {
                    const res = await axios.get(' http://127.0.0.1:8000/api/getDataAdio', {  
                        params: { staffid: staffid_Main }
                    }); 
                    this.posadio = res.data[0].posadid
                } 
            } catch (error) {
                console.error('Error fetching evaluation data:', error);
            } 
        },

        getjobSpecificCompetencies(){
            axios.post('   http://127.0.0.1:8000/api/showdataposp02', { 
                p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                for (let i = 0; i < this.jobSpecificCompetencies.length; i++) {
                    if (res.data[0] && res.data[0][`p${i+6}`] !== undefined) {
                        this.jobSpecificCompetencies[i]['SCORE'] = res.data[0][`p${i+6}`];
                        this.jobSpecificCompetencies[i]['SCOREPERSON'] = res.data[0][`pa_${i+6}`];
                    }
                }
                for (let i = 0; i < this.otherCompetencies.length; i++) {
                    if (res.data[0] && res.data[0][`px_${i+1}`] !== undefined) {
                        this.otherCompetencies[i]['datatable3'] = res.data[0][`px_${i+1}`];
                        this.otherCompetencies[i]['selfAssessment3'] = res.data[0][`pSE_${i+1}`]; 
                    }  
                }
            })
        },

        showdataPo(){  
            let postypetext = this.posadio === '128' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;
            let postypenameid = this.posadio === '128' ? 90 : this.postypenameid;
            let positionname = this.posadio === '128' ? `ระดับชำนาญการพิเศษ` : `ระดับ${this.postypename}`;

            const levelMapping = {
                'ระดับปฏิบัติการ': 1,
                'ระดับปฏิบัติงาน': 1, 
                'ระดับชำนาญการ': 2,
                'ระดับชำนาญงาน': 2,
                'ระดับชำนาญการพิเศษ': 3,
                'ระดับชำนาญงานพิเศษ': 3,
                'อาจารย์': 3,
                'ระดับเชี่ยวชาญ': 4,
                'ระดับเชี่ยวชาญพิเศษ': 5
            };
  
            let personnel = levelMapping[postypetext] || 0;

            this.coreCompetencies = [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: personnel, data_table1: '', selfAssessment: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: personnel, data_table1: '', selfAssessment: '' }
            ];
             
            this.jobSpecificCompetencies = [];  

            const Mapping = { '128': 1 };   
            const blacklist = ['110105', '110999', '110999'];  
            let executive = Mapping[this.posadio] || 0;
            if (blacklist.includes(String(this.staffid_Main))) {
                executive = 0;
            }

            this.otherCompetencies = [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator3: executive, datatable3: '', selfAssessment3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator3: executive, datatable3: '', selfAssessment3: '' }
            ];
  
            this.showPostype(positionname, postypenameid);
  
            axios.post('   http://127.0.0.1:8000/api/showDataPo',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dataPor.d_date,
                record: this.dataPor.evalua,
                postypename: postypetext
            }).then(res => {     
                if (res.data.length > 0) {
                    const data = res.data[0]; 
                    this.coreCompetencies = this.coreCompetencies.map(item => {
                        if (data[`p${item.id}`] !== undefined) {
                            return {
                                ...item,
                                data_table1: data[`p${item.id}`],
                                selfAssessment: data[`pa_${item.id}`]
                            };
                        }
                        return item;
                    });  
                    this.improvements = data.improvements ?? '- ไม่มีข้อมูล -';
                    this.suggestions = data.suggestions ?? '- ไม่มีข้อมูล -'; 
                } 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },

        showPostype(postypename, postypenameid){
            const postypetext = postypename;
            axios.post('   http://127.0.0.1:8000/api/showdatapostypenameAdmin', {
                postypename: postypetext,
                postypenameid: postypenameid
            })
            .then(res => {
                if (res.data.length > 0) { 
                    this.jobSpecificCompetencies = res.data;
                } 
            })
            .catch(error => {
                console.error('Error fetching data:', error); 
            }); 
        },

        showdatator() {  
            axios.post('   http://127.0.0.1:8000/api/showdatator', {
                p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            .then(res => {
                this.assessorText = res.data[0].assessor; 
                this.assessor_positionText = res.data[0].assessor_position;
                this.showscoresum = res.data[0] 
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },

        async printDataP01() { 
            const { signIn, getSession, signOut } = await useAuth() 
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
                postypename: `ระดับ${this.postypename}`,
                postypenameid: this.postypenameid
            } 
            const queryParams = new URLSearchParams(form).toString();
            const url = `   http://127.0.0.1:8000/report_p02?${queryParams}`;
            window.open(url, '_blank');
        },     

        // เมื่อคลิกชื่อสมรรถนะ ให้เปิด Dialog
        openCompetencyDialog(type, row, index = null) {
            let title = '';
            let description = '';

            if (type === 'core') {
                title = row.activity;
                const workName = this.extractNameFromActivity(row.activity);
                const master = this.competencyMap[workName] || null;
                if (master) {
                    description = master.WORK_DATAIL || this.coreDescriptions[row.id] || '';
                } else {
                    description = this.coreDescriptions[row.id] || 'ยังไม่มีคำอธิบายสำหรับรายการนี้';
                }

            } else if (type === 'job') {
                const order = (index !== null ? index + 1 : '');
                title = `ข. ${order} ${row.WORK_NAME}`;

                // WORK_DATAIL + LEVEL_DETAIL (ที่ query ใหม่รวม ORDER_ID + ORDER_DETAIL มาแล้ว)
                const baseDetail = row.WORK_DATAIL || '';
                const levelDetail = row.LEVEL_DETAIL || '';
                description = baseDetail;
                if (levelDetail) {
                    description += `\n\n${levelDetail}`;
                }

            } else if (type === 'other') {
                title = row.activity;
                const workName = this.extractNameFromActivity(row.activity);
                const master = this.competencyMap[workName] || null;
                if (master) {
                    description = master.WORK_DATAIL || this.otherDescriptions[row.id] || '';
                } else {
                    description = this.otherDescriptions[row.id] || 'ยังไม่มีคำอธิบายสำหรับรายการนี้';
                }
            }

            this.selectedCompetency = { title, description };
            this.competencyDialogVisible = true;
        },

        // ตัด prefix เช่น "ก. 1 " หรือ "ค. 3 " ออก เหลือเฉพาะชื่อสมรรถนะ
        extractNameFromActivity(activityText) {
            if (!activityText) return '';
            const parts = activityText.trim().split(/\s+/);
            if (parts.length <= 2) return activityText.trim();
            return parts.slice(2).join(' ');
        }
    }  
}
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
    padding: 8px;
    text-align: center;
    font-size: 14px;
}
th {
    background-color: #ffffff;
}
th, td:first-child {
    width: 35%;
}
td:nth-child(2), td:nth-child(3) {
    width: 32.5%;
}
.add-row-form {
    margin: 5px 0;
    font-size: 14px;
}
.add-button, .save-button, .cancel-button {
    margin: 3px;
    padding: 6px 12px;
    font-size: 12px;
}
.form-container {
    padding: 8px;
    border: 1px solid #ddd;
    background-color: #f0f0f0;
    border-radius: 4px;
    font-size: 14px;
}
.edit-icon, .delete-icon {
    margin: 0 8px;
    cursor: pointer;
    font-size: 16px;
}
.edit-icon {
    color: #ffc107;
}
.delete-icon {
    color: #dc3545;
}
th {
    background-color: #edf2bb;
    color: rgb(5, 5, 5);
}
</style>
