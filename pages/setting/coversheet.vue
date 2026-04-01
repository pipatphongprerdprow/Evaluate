<template>   
    <div v-if="user.user" class="grid">
        <div class="col-12 lg:col-12 xl:col-12"> 
            <div class="card mb-0"> 
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">   
                        <h5 class="mb-4" style="text-align: left;margin-right: 16px;margin-bottom: 0px;">
                            <i class="" style="font-size: x-large"></i> สังกัด: {{ user.user.name.SCOPES?.staffdepartmentname }} 
                        </h5>  
                        <small style="color: red;font-size: larger;">* กรุณาเลือกรอบประเมิน เพื่อทำแบบประเมิน</small>
                    </div>    
                     <div class="col md:col-6">  
                        <label for="product_date"></label>  
                        <Dropdown
                        id="product_date"
                        v-model="product_date"
                        :options="latestProductOnly"
                        autoFilterFocus
                        :optionLabel="(item) => `${item.d_evaluationround} ${item.d_date}`"
                        placeholder="กรุณาเลือกรอบการประเมิน"
                        style="max-width: 500px;width: 100%;border: outset;"
                        @change="showdatator" 
                        /> 
                    </div> 
                </div> 
            </div>
        </div>  
    </div>   

    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="formgroup-inline mb-1">
                <div class="d-flex align-items-center"> </div>
            </div> 
            <!-- <TabView :activeIndex="activeIndex" @tabChange="onTabChange"> -->
            <TabView :activeIndex="activeIndex" @tabChange="onTabChange" :class="{ 'lock-next-tabs': !isP01WeightOk }" >
                <TabPanel header="แบบ ใบปะหน้า" value="0">
                    <div class="col md:col-12 text-right">
                        <!-- <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2" @click="printDataP01" /> -->
                         <Button label="Export" icon="pi pi-file-pdf" class="mr-2 mb-2" @click="printDatacoverpage" />
                    </div> 

                    <div v-if="user.user" class="card"> 
                        <div style="display: flex; justify-content: center">
                            <img src="~/assets/layout/images/kongkang.jpg" alt="Description of image" class="contract-image" />
                        </div>

                        <h4 style="text-align: center">
                            แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) <br>
                            ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคาม
                        </h4> 
                        <br />  
                        <div class="employee-info">
                            <p><strong>ผู้ปฏิบัติงาน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}</p>
                            <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }}</p>
                            <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }}</p>
                            <!-- <p><strong>ระดับตำแหน่ง:</strong> {{ user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME }}</p>  -->
                            <p><strong>ระดับตำแหน่ง:</strong> {{ [160018, '', ''].includes(user.user?.name.STAFFID) ? 'ผู้อำนวยการกอง' : (user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME) }}</p> 

                            <!-- <p>
                                <strong>ชื่อผู้ประเมิน:</strong>
                                <AutoComplete
                                    v-model="assessor"
                                    :suggestions="staffSuggestions"
                                    optionLabel="displayName"
                                    placeholder="ชื่อผู้ประเมิน"
                                    forceSelection
                                    dropdown
                                    @complete="searchStaff"
                                    style="width: 300px;"
                                    :disabled="isTorSaved"
                                /> 
                            </p>  -->
                            <p>
                                <strong>ชื่อผู้ประเมิน:</strong>
                                <AutoComplete
                                    v-model="assessor"
                                    :suggestions="staffSuggestions"
                                    optionLabel="displayName"
                                    placeholder="ชื่อผู้ประเมิน"
                                    forceSelection
                                    dropdown
                                    @complete="searchStaff"
                                    style="width: 300px;"
                                    :disabled="shouldDisableInput" 
                                /> 
                            </p> 
                            <!-- <p>
                                <strong>ตำแหน่งผู้ประเมิน :</strong> 
                                <InputText type="text"  placeholder="ตำแหน่งผู้ประเมิน" v-model="assessor_position" style="width: 265px;" :disabled="isTorSaved" />
                            </p>   -->
                            <p>
                                <strong>ตำแหน่งผู้ประเมิน :</strong>
                                <InputText 
                                    type="text"  
                                    placeholder="ตำแหน่งผู้ประเมิน" 
                                    v-model="assessor_position" 
                                    style="width: 265px;" 
                                    :disabled="shouldDisableInput" 
                                />
                            </p> 
                            <p>
                                <strong>รายละเอียดข้อตกลง ระหว่าง วันที่ : </strong>
                                    {{ displayEvaluationPeriod }}
                            </p> 
                        </div> 
                        <br>
                        
                        <!-- <div class="ml-4 mr-4" style="text-align: center;">
                            <label for="dropdownProportion"><b>สัดส่วน :</b></label> 
                            <Dropdown
                                id="dropdownProportions"
                                v-model="dropdownProportion"
                                :options="dropdownProportions"
                                optionLabel="name"
                                optionValue="value"
                                placeholder="เลือกสัดส่วน"
                                :disabled="isTorSaved"
                            /> 
                        </div>  -->
                        <div class="ml-4 mr-4" style="text-align: center;">
                            <label for="dropdownProportion"><b>สัดส่วน :</b></label> 
                            <Dropdown
                                id="dropdownProportions"
                                v-model="dropdownProportion"
                                :options="dropdownProportions"
                                optionLabel="name"
                                optionValue="value"
                                placeholder="เลือกสัดส่วน"
                                :disabled="shouldDisableInput"
                            /> 
                        </div> 
                        <br> 
                        <!-- <div class="ml-4 mr-4" style="text-align: center;"> 
                            <Button
                                icon="pi pi-save"
                                severity="primary"
                                class="mb-2 mr-2"
                                :label="isTorSaved ? 'บันทึกแล้ว' : 'บันทึกแบบข้อตกลงภาระงาน'"
                                :disabled="isTorSaved || isSaving || !product_date?.d_date"
                                @click="saveDatator"
                            />
                        </div>     -->
                        <div class="ml-4 mr-4" style="text-align: center; margin-top: 1rem;"> 
                            <Button
                                icon="pi pi-save"
                                severity="primary"
                                class="mb-2 mr-2"
                                :label="isExpired ? 'หมดเขตการบันทึก' : (isTorSaved ? 'บันทึกแล้ว' : 'บันทึกแบบข้อตกลงภาระงาน')"
                                :disabled="shouldDisableInput || isSaving || !product_date?.d_date"
                                @click="saveDatator"
                            />
                            <br />
                        </div>
                        <div class="explanation">
                            <h4>คำชี้แจง</h4>
                            <p>
                                1. แบบข้อตกลงภาระงานและพฤติกรรมการปฏิบัติราชการ (Term of Reference : TOR) ข้าราชการและพนักงาน สังกัดมหาวิทยาลัยมหาสารคามนี้ เป็นการกำหนด แผนการปฏิบัติงานของผู้ปฏิบัติงานในมหาวิทยาลัยมหาสารคาม ซึ่งเป็นข้อตกลงร่วมกับผู้บังคับบัญชาก่อนเริ่มปฏิบัติงาน
                            </p>
                            <p>
                                2. การกำหนดข้อตกลงร่วม ผู้ปฏิบัติงานจะต้องกรอกรายละเอียดภาระงานโดยสังเขปในส่วนของภาระงานตามหน้าที่ความรับผิดชอบของตำแหน่ง และ/หรือภาระงาน ด้านอื่นๆ พร้อมกำหนดตัวชี้วัดความสำเร็จของภาระงานแต่ละรายการ ตลอดจนค่าเป้าหมายและค่าน้ำหนักร้อยละ สำหรับในส่วนของพฤติกรรมการปฏิบัติราชการ (สมรรถนะ) ให้ระบุระดับสมรรถนะค่ามาตรฐาน
                            </p>
                            <p>3. สำหรับการกรอกรายละเอียดภาระงานตามภารกิจ ให้อ้างอิงการคำนวณภาระงานขั้นต่ำตามหลักเกณฑ์กรอบมาตรฐานภาระงานที่แนบท้ายประกาศ ก.บ.ม. มหาวิทยาลัยมหาสารคาม ที่บังคับใช้สำหรับการประเมินผลการปฏิบัติราชการ</p>
                            <p>4. การกำหนดตัวชี้วัดความสำเร็จของงาน ทั้งในส่วนของเชิงปริมาณและเชิงคุณภาพ ให้เป็นการกำหนดข้อตกลงภายในหน่วยงานนั้นๆ</p>
                            <p>5. การจัดทำข้อตกลงภาระงานดังกล่าวนี้ เพื่อใช้เป็นกรอบในการประเมินผลการปฏิบัติราชการ เพื่อประกอบการเลื่อนเงินเดือนและค่าจ้างในแต่ละรอบการประเมิน</p>
                        </div>
                    </div>
                </TabPanel>  
                <!-- <TabPanel header="แบบ ป01" value="1">
                    <Por01 :dataPor="product_date" @weight-changed="onP01WeightChanged" />
                </TabPanel> -->
                <TabPanel header="แบบ ป01" value="1">
                    <Por01 ref="p01Ref" :dataPor="product_date" @weight-changed="onP01WeightChanged" />
                </TabPanel> 
                <TabPanel header="แบบ ป02" value="2">
                    <Por02 :dataPor="product_date" :tab2Reload="por02key" />
                </TabPanel> 
                <TabPanel header="แบบ ป03" value="3">
                    <Por03 :dataPor="product_date" :tab3Reload="por03key" /> 
                </TabPanel>  
                <TabPanel header="แบบ ป04" value="4">
                    <Por04 :dataPor="product_date" :tab4Reload="por04key" />
                </TabPanel> 
            </TabView>
        </div>
    </div>
</template> 

<script setup>
const { signIn, getSession, signOut } = await useAuth();
const user = await getSession();
</script>   

<script>
    import { ref } from 'vue';
    import axios from 'axios';
    import Swal from 'sweetalert2';
    import AutoComplete from 'primevue/autocomplete';
    import Por01 from './pages/setting/por_01.vue';
    import Por02 from './pages/setting/por02.vue';
    import Por03 from './pages/setting/por03.vue';
    import Por04 from './pages/setting/por04.vue'; 

    export default {
        components: {
            Por01,
            Por02,
            Por03,
            Por04, 
            AutoComplete,
        },
        name: 'ContractDetails',
        data() {
            return { 
                p01x: '',
                xxx: '2',
                por02key: 0,
                por03key: 0,
                por04key: 0, 

                activeIndex: 0,

                dataStaffid: null,
                staffid_Main: '',
                staffid_name: '',
                year_Main: '',
                facid_Main: '',
                pos_id: '',
                postype_id: '',
                evalua: '',
                groupid_Main: '01',   
                dataP01: {},
                p01TotalWeight: 0,

                //แก้บันทึกแบบข้อตกลงไม่ให้บันทึกซ้า
                isTorSaved: false,
                isSaving: false,

                user: {
                    user: {
                        name: {
                            PREFIXFULLNAME: '',
                            STAFFNAME: '',
                            STAFFSURNAME: '',
                            SCOPES: {
                                staffdepartmentname: ''
                            },
                            POSITIONNAME: '',
                            POSTYPENAME: ''
                        }
                    }
                },

                product_date: {
                    d_evaluationround: '', 
                },  

                assessor: null,             
                assessor_position: null,
                currenttap: 0, 
                staffSuggestions: [], 

                products_date: [], 

                dropdownProportion: null,
                dropdownProportions: [
                    { name: 'สัดส่วน 50:50', value: '50:50' },
                    { name: 'สัดส่วน 70:30', value: '70:30' },
                ],

                dropdownItemYear: { name: 'ปีงบประมาณ 2568', value: 2569 },
                dropdownItemsYear: [
                    { name: 'ปีงบประมาณ 2569', value: 2569 },
                    { name: 'ปีงบประมาณ 2568', value: 2568 },
                    { name: 'ปีงบประมาณ 2567', value: 2567 },
                    { name: 'ปีงบประมาณ 2566', value: 2566 }
                ],
            };
        },
        async mounted() {
            const { signIn, getSession, signOut } = await useAuth();
            const user = await getSession();
            
            const { STAFFID, SCOPES } = user.user.name;
            const { staffdepartment, groupid } = SCOPES; 

            await this.setSession(STAFFID, staffdepartment, groupid, user);
            await this.showDataSet(STAFFID, staffdepartment, groupid);
        }, 
        
        computed: { 

            latestProductOnly() { 
                if (!this.products_date || this.products_date.length === 0) {
                    return [];
                }

                // แสดงเฉพาะรอบที่เปิด
                const result = this.products_date.filter(item => item.status_round == 1);

                return result.sort((a, b) => new Date(b.d_date) - new Date(a.d_date));
            },

            isP01WeightOk() {
                const w = Number(this.p01TotalWeight || 0);
                return Math.abs(w - 100) < 0.01;
            }, 

            displayEvaluationPeriod() { 
                const rawRound = String(this.product_date?.d_evaluationround ?? '');
                const rawDate  = this.product_date?.d_date ?? ''; 
                const dateText =
                    typeof rawDate === 'string'
                    ? rawDate
                    : rawDate instanceof Date
                        ? rawDate.toLocaleDateString('th-TH')
                        : String(rawDate); 
                const combined = `${rawRound} ${dateText}`; 
                const roundNo = (rawRound.match(/รอบที่\s*(\d+)/)?.[1]) || '';
                const roundText = (rawRound.match(/^(.*?รอบที่\s*\d+)/)?.[1]) || (roundNo ? `รอบที่ ${roundNo}` : rawRound); 
                const prop = String(this.dropdownProportion ?? '').replace(/\s+/g,'');
                const is5050 = prop === '50:50'; 
                if (!is5050) return `${rawRound} ${dateText}`.trim(); 
                const yearText = (combined.match(/25\d{2}/)?.[0]) || ''; 
                const map = {
                    '1': 'วันที่ 1 ตุลาคม ถึง วันที่ 31 มีนาคม',
                    '2': 'วันที่ 1 เมษายน ถึง วันที่ 30 กันยายน',
                }; 
                const range = map[roundNo];
                if (!range) return `${roundText}${yearText ? ` ${yearText}` : ''}`.trim(); 
                return `${roundText} ${range}${yearText ? ` ${yearText}` : ''}`.trim();
            },

            isExpired() {
                if (!this.product_date || !this.product_date.d_enddate) return false;
                const endDate = new Date(this.product_date.d_enddate);
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                return today > endDate;
            },

            // แก้ไขตรงนี้:
            shouldDisableInput() {
                // ถ้าหมดเวลาแล้ว (isExpired) ให้ล็อคแน่นอน
                // แต่ถ้ายังไม่หมดเวลา ให้เปิดให้กรอกได้เสมอ (ไม่ต้องเอา isTorSaved มาเกี่ยว)
                return this.isExpired; 
            },

        },

        methods: { 
            setSession(staffid_Main, facid_Main, groupid_Main, user) {
                this.staffid_Main = staffid_Main;
                this.facid_Main = facid_Main;
                this.groupid_Main = groupid_Main;
                this.staffid_name = user.user.name.PREFIXFULLNAME + user.user.name.STAFFNAME + ' ' + user.user.name.STAFFSURNAME;
                this.pos_id = user.user.name.POSID;
                this.postype_id = user.user.name.POSTYPEID;
            },

            por01Data(data) {
                this.dataP01 = {
                    staffid: this.staffid_Main,
                    year: data.d_date,
                    evalua: data.evalua,
                    d_evaluationround: data.d_evaluationround,
                    staffdepartment: this.facid_Main
                };
            },
            // เลือกหลายรอบการประเมิน
            showDataSet() {
                axios.post('http://127.0.0.1:8000/api/showDateSet', {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main 
                })
                .then((res) => {
                    this.products_date = res.data;
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
            }, 
            saveDatator() {
                // if (this.isTorSaved) {
                //     Swal.fire('แจ้งเตือน', 'รอบประเมินนี้เคยบันทึกข้อมูลแล้ว ไม่สามารถบันทึกซ้ำได้', 'warning');
                //     return;
                // }

                if (this.product_date.d_date == null || this.product_date.d_date == undefined) {
                    Swal.fire('error', 'กรุณาเลือก รอบการประเมิน ก่อน', 'error'); 
                    return;
                }

                if (!this.assessor) {
                    Swal.fire('error', 'กรุณากรอกชื่อผู้ประเมินให้ครบถ้วน', 'error');
                    return;
                }

                if (!this.assessor_position) {
                    Swal.fire('error', 'กรุณากรอกชื่อและตำแหน่งผู้ประเมินให้ครบถ้วน', 'error');
                    return;
                }

                if (this.dropdownProportion == null || this.dropdownProportion == undefined) {
                    Swal.fire('error', 'กรุณาเลือก สัดส่วน', 'error');
                    return;
                }

                const assessorName =
                    this.assessor && typeof this.assessor === 'object'
                        ? (this.assessor.displayName || this.assessor.namefully)
                        : (this.assessor || '');

                const formData = {
                    p_year: this.product_date.d_date,
                    evalua: this.product_date.evalua,
                    p_staffid: this.staffid_Main,
                    staffid_name: this.staffid_name,
                    pos_id: this.pos_id,
                    postype_id: this.postype_id,
                    fac_id: this.facid_Main,
                    dropdownProportion: this.dropdownProportion,
                    assessor: assessorName,
                    assessor_position: this.assessor_position,
                    record_evalua: this.displayEvaluationPeriod,
                };

                this.isSaving = true;

                axios.post('http://127.0.0.1:8000/api/saveDatator', formData)
                    .then(response => {
                        // this.isTorSaved = true; // บันทึกเสร็จแล้ว ห้ามกดซ้ำ

                        Swal.fire({
                            position: 'top-end',
                            icon: 'success',
                            title: 'บันทึกข้อตกลงภาระงานเรียบร้อย',
                            showConfirmButton: false,
                            timer: 1500
                        });
                    })
                    .catch(error => {
                        console.error('Error saving data:', error);
                        Swal.fire('error', 'การบันทึกข้อมูลล้มเหลว', 'error');
                    })
                    .finally(() => {
                        this.isSaving = false;
                    });
            },  
            showdatator() {
                // reset ก่อนทุกครั้งที่เปลี่ยนรอบ
                //this.isTorSaved = false;
                this.assessor = null;
                this.assessor_position = null;
                this.dropdownProportion = null;

                axios.post('http://127.0.0.1:8000/api/showdatator', {
                    p_year: this.product_date.d_date,
                    evalua: this.product_date.evalua,
                    p_staffid: this.staffid_Main
                })
                .then(response => {
                    const rows = response.data || [];
                    const dataSet = rows[0] || {};

                    // ถ้ามีข้อมูล แปลว่าเคยบันทึกแล้ว
                    //this.isTorSaved = rows.length > 0;

                    const nameFromDb = dataSet.assessor || '';
                    this.assessor = nameFromDb
                        ? { displayName: nameFromDb, namefully: nameFromDb }
                        : null;

                    this.assessor_position = dataSet.assessor_position || null;
                    this.dropdownProportion = dataSet.persen || null;
                })
                .catch(error => {
                    //this.isTorSaved = false;
                    this.assessor = null;
                    this.assessor_position = null;
                    this.dropdownProportion = null;
                    console.error(error);
                });
            },
        
            onTabChange(event) {
                if (!this.product_date?.d_date) {
                    Swal.fire({
                    icon: 'warning',
                    title: 'แจ้งเตือน',
                    text: 'กรุณาเลือก รอบการประเมิน ก่อน !',
                    confirmButtonText: 'ตกลง'
                    });
                    this.activeIndex = this.currenttap ?? 0;
                    return;
                }

                if (event.index >= 2 && !this.isP01WeightOk) {
                    const w = Number(this.p01TotalWeight || 0);
                    const msg = w > 100
                    ? `คะแนนรวมน้ำหนัก = ${w}% เกิน 100% กรุณาปรับให้เท่ากับ 100%`
                    : `คะแนนรวมน้ำหนัก = ${w}% ยังไม่ครบ 100% กรุณาปรับให้เท่ากับ 100%`;

                    Swal.fire({
                    icon: 'warning',
                    title: 'ยังไปแท็บอื่นไม่ได้',
                    text: msg,
                    confirmButtonText: 'ตกลง'
                    });

                    this.activeIndex = 1;
                    this.currenttap = 1;
                    return;
                }

                this.activeIndex = event.index;
                this.currenttap = event.index;

                if (event.index == 2) this.por02key++;
                else if (event.index == 3) this.por03key++;
                else if (event.index == 4) this.por04key++;

                // ✅ สำคัญ: กลับมาป01 ให้โหลดใหม่เพื่ออัปเดตปุ่มลบทันที
                if (event.index === 1) {
                    this.$nextTick(() => {
                    this.$refs.p01Ref?.showDataPerson?.();
                    });
                }
            }, 
            
            // async printDataP01() { 
            //     const { signIn, getSession, signOut } = await useAuth();
            //     const user = await getSession();     

            //     const form = {
            //         staff_id: this.staffid_Main,
            //         group_id: this.groupid_Main,
            //         fac_id: this.facid_Main,
            //         year_id: this.product_date.d_date,
            //         evalua: this.product_date.evalua,

            //         period_text: this.displayEvaluationPeriod,
            //         persen: this.dropdownProportion,    

            //         PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
            //         STAFFNAME: user.user.name.STAFFNAME,
            //         STAFFSURNAME: user.user.name.STAFFSURNAME,
            //         POSITIONNAME: user.user.name.POSITIONNAME,
            //         GROUPTYPENAME: user.user.name.GROUPTYPENAME,
            //         POSTYPENAME: user.user.name.POSTYPENAME, 
            //         SCOPES: user.user.name.SCOPES.staffdepartmentname 
            //     };

            //     const queryParams = new URLSearchParams(form).toString();
            //     const url = `http://127.0.0.1:8000/printReportCoverpage?${queryParams}`;
            //     window.location.href = url;
            // }, 

            async printDatacoverpage() {
                const { getSession } = await useAuth();
                const user = await getSession(); 

                // ตรวจสอบก่อนว่าเลือกรอบการประเมินหรือยัง
                if (!this.product_date?.d_date) {
                    Swal.fire('แจ้งเตือน', 'กรุณาเลือกรอบการประเมินก่อน Export', 'warning');
                    return;
                }

                try {
                    // แสดง Loading สักครู่
                    Swal.fire({ title: 'กำลังสร้างไฟล์ PDF...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });

                    const response = await axios.post("http://127.0.0.1:8000/api/exportPdf_coverpage", {
                        // ส่งค่า ID ต่างๆ ที่ Backend ต้องการ
                        staff_id: this.staffid_Main,
                        group_id: this.groupid_Main,
                        fac_id: this.facid_Main, // แก้จาก this.dataPor เป็น this.facid_Main
                        year_id: this.product_date.d_date,
                        evalua: this.product_date.evalua,
                        
                        // ข้อมูลสำหรับแสดงผลในหน้าใบปะหน้า
                        PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
                        STAFFNAME: user.user.name.STAFFNAME,
                        STAFFSURNAME: user.user.name.STAFFSURNAME,
                        POSITIONNAME: user.user.name.POSITIONNAME,
                        GROUPTYPENAME: user.user.name.GROUPTYPENAME,
                        POSTYPENAME: user.user.name.POSTYPENAME,
                        SCOPES: user.user.name.SCOPES.staffdepartmentname,
                        
                        // ข้อมูลเพิ่มเติมที่แสดงในใบปะหน้า (สัดส่วน และ รอบวันที่)
                        persen: this.dropdownProportion,
                        period_text: this.displayEvaluationPeriod,
                    }, {
                        responseType: 'blob' // สำคัญมากสำหรับการรับไฟล์ PDF
                    });

                    Swal.close();

                    // สร้าง URL สำหรับเปิด PDF ใน Tab ใหม่
                    const blob = new Blob([response.data], { type: 'application/pdf' });
                    const url = window.URL.createObjectURL(blob);
                    window.open(url, '_blank');
                    
                    // ล้างหน่วยความจำ
                    setTimeout(() => window.URL.revokeObjectURL(url), 100);

                } catch (error) {
                    Swal.close();
                    console.error("Error exporting PDF:", error);
                    Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถสร้างไฟล์ PDF ได้', 'error');
                } 
            },

            searchStaff(event) {
                const query = (event.query || '').trim();
                if (!query || query.length < 2) {
                    this.staffSuggestions = [];
                    return;
                }

                axios.get('http://127.0.0.1:8000/api/searchDataStaff', {
                    params: { staffid: query }
                })
                .then((res) => {
                    const rows = res.data || [];
                    this.staffSuggestions = rows.map(r => ({
                    ...r,
                    displayName: `${r.prefixfullname || r.PREFIXFULLNAME || ''}${r.namefully || ''}`.trim()
                    }));
                })
                .catch(() => {
                    this.staffSuggestions = [];
                });
                },


            onP01WeightChanged(val) {
                this.p01TotalWeight = Number(val || 0);
            }, 
        },  
    };
</script>

<style scoped>
.contract-details {
    font-family: Arial, sans-serif;
}

.employee-info {
    margin-top: 20px;
    padding-left: 30px;
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
 
.explanation {
    margin-top: 20px;
    padding-left: 30px;
}

.flex-row {
    display: flex;
    align-items: center;
    gap: 40px;
}
.lock-next-tabs :deep(.p-tabview-nav li:nth-child(n+3)) {
  pointer-events: none;     /* กดไม่ได้ */
  opacity: 0.45;            /* ทำให้ดูเป็น disabled */
  cursor: not-allowed;
}
</style>
