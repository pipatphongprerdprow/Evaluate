<template>
    <div class="col md:col-12 text-right">
        <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataDaily"></Button>
    </div>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header"><i class="pi pi-file" style="font-size: x-large;"></i> บันทึกภาระงานประจำวัน </h3>
                    </div>
                    <br>
                    <div class="col md:col-16 text-right">
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มภาระงาน" @click="OpenDialogAdd" />
                        <Dialog v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '80vw' }" :modal="true" position="top">
                            <template #header>
                                <div class="flex justify-between items-start w-full">
                                    <div class="flex-1">
                                        <h5 class="m-0"><b>บันทึกภาระงานประจำวัน</b></h5>
                                    </div>
                                    <div class="text-center">
                                        <p class="m-0">
                                            <strong>ผู้ปฏิบัติงาน:</strong> {{ user?.user?.name?.PREFIXFULLNAME }} {{ user?.user?.name?.STAFFNAME }} {{ user?.user?.name?.STAFFSURNAME }}
                                            <strong>สังกัด:</strong> {{ user?.user?.name?.SCOPES?.staffdepartmentname }}
                                        </p>
                                    </div>
                                </div>
                            </template>
                            <form>
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-4">
                                        <label for="evaluation_round">รอบประเมิน</label>
                                        <Dropdown
                                            v-model="evaluadaily"
                                            :options="evaluadailys"
                                            optionLabel="label"
                                            optionValue="value"
                                            placeholder="เลือกรอบประเมิน"
                                            class="w-full"
                                            required
                                        />
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="task_date">วันที่ลงบันทึก</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <InputText :value="formatDate(taskDate)" disabled class="w-full" />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="end_date">วันที่กำหนดเสร็จ</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="EndDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี เวลา"
                                                showIcon
                                                showTime
                                                hourFormat="24"
                                                class="w-full"
                                                required
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="acomp_date">วันที่เสร็จจริง</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="AcompDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี เวลา"
                                                showIcon
                                                showTime
                                                hourFormat="24"
                                                class="w-full"
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="file_upload">ชื่อไฟล์</label> &nbsp;&nbsp;
                                        <span style="color: red;">
                                            <b>(ถ้ามี)</b>
                                        </span>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-paperclip"></i>
                                            </InputGroupAddon>
                                            <input
                                                type="file"
                                                @change="onFileChange"
                                                class="w-full border-1 surface-border border-round p-2"
                                                ref="fileInputRef"
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-4">
                                        <label for="document_link">ลิงก์เอกสาร</label>
                                        <span style="color: red;"> &nbsp;&nbsp; <b>(ถ้ามี)</b></span>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-link"></i>
                                            </InputGroupAddon>
                                            <InputText
                                                v-model="documentLink"
                                                type="text"
                                                placeholder="วางลิงก์เอกสาร เช่น https://..."
                                                autocomplete="off"
                                            />
                                        </InputGroup>
                                    </div>

                                    <div class="field col-12 md:col-12">
                                        <label for="daily_task">ภาระงานประจำวัน</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-pencil"></i>
                                            </InputGroupAddon>
                                            <Textarea
                                                v-model="dailyTask"
                                                rows="3"
                                                placeholder="ระบุภาระงานประจำวัน..."
                                                autoResize
                                                class="w-full"
                                                required
                                            />
                                        </InputGroup>
                                    </div>

                                </div>
                            </form>
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" class="mb-2 mr-2" @click="saveDailyTask" />
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialogdialy" />
                            </template>
                        </Dialog>

                        <Dialog v-model:visible="DialogDetail" :breakpoints="{ '960px': '75vw' }" :style="{ width: '70vw' }" :modal="true" position="top">
                            <template #header>
                                <h5 class="m-0"><b>รายละเอียดภาระงาน</b></h5>
                            </template>
                            <div class="p-fluid grid">
                                <div class="col-12 md:col-4">
                                    <p><strong>รอบประเมิน:</strong> {{ selectedTask?.daily_evalua }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่ลงบันทึก:</strong> {{ formatDate(selectedTask?.daily_date) }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่กำหนดเสร็จ:</strong> {{ formatDate(selectedTask?.end_date) }}</p>
                                </div>

                                <div class="col-12 md:col-4">
                                    <p><strong>วันที่เสร็จจริง:</strong> {{ selectedTask?.accomplet_date && selectedTask?.accomplet_date !== '0000-00-00 00:00:00' ? formatDate(selectedTask?.accomplet_date) : 'ยังไม่ระบุ' }}</p>
                                </div>
                                <div class="col-12 md:col-8"> <p><strong>ภาระงาน:</strong> {{ selectedTask?.name_dialywork }}</p>
                                </div>

                                <div class="col-12 md:col-4"> <p><strong>ไฟล์เอกสาร:</strong>
                                        <span v-if="selectedTask?.daily_filename">
                                            <a :href="getFileUrl(selectedTask?.dialy_file)" target="_blank" class="p-button p-component p-button-link">
                                                <i class="pi pi-download"></i> {{ selectedTask?.daily_filename }}
                                            </a>
                                        </span>
                                        <span v-else>ไม่มีไฟล์</span>
                                    </p>
                                </div>
                                <div class="col-12 md:col-4"> <p><strong>ลิงก์เอกสาร:</strong>
                                        <a v-if="selectedTask?.daily_link" :href="selectedTask?.daily_link" target="_blank" class="p-button p-component p-button-link">
                                            <i class="pi pi-external-link"></i> เปิดลิงก์
                                        </a>
                                        <span v-else>ไม่มีลิงก์</span>
                                    </p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>ใช้เวลาทั้งหมด:</strong>&nbsp;
                                        <span v-if="selectedTask?.total_time_display">
                                        {{ selectedTask.total_time_display }}
                                        </span>
                                        <span v-else>ยังไม่เสร็จสิ้น/ไม่ระบุเวลา</span>
                                    </p>
                                </div>

                                <div class="col-12 md:col-4">
                                    <p><strong>ผู้บันทึก:</strong> {{ selectedTask?.name_daily }}</p>
                                </div>
                                <div class="col-12 md:col-4">
                                    <p><strong>สังกัด:</strong> {{ selectedTask?.name_facdialy }}</p>
                                </div>

                                <div class="col-12 md:col-4">
                                    <p><strong>สถานะ:</strong> &nbsp;
                                        <Button
                                            v-if="selectedTask?.status === 'in_progress'"
                                            label="กำลังดำเนินการ"
                                            severity="warning"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else-if="selectedTask?.status === 'completed'"
                                            label="เสร็จสิ้น"
                                            severity="success"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else-if="selectedTask?.status === 'overdue'"
                                            label="เลยกำหนด"
                                            severity="danger"
                                            class="p-button-sm"
                                        />
                                        <Button
                                            v-else
                                            label="ไม่ระบุ"
                                            severity="contrast" class="p-button-sm"
                                            outlined
                                        />
                                    </p>
                                </div>
                            </div>
                            <template #footer>
                                <Button label="ปิด" icon="pi pi-times" @click="DialogDetail = false" style="background-color: red; color: white; border: none;"/>
                            </template>
                        </Dialog>
                    </div>
                </div>
                <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                    <Column field="daily_date" header="วันที่" style="width: 10%; text-align: center;">
                        <template #body="slotProps">
                            <b>{{ formatDate(slotProps.data.daily_date) }}</b>
                        </template>
                    </Column>
                    <Column field="daily_evalua" header="รอบประเมิน" style="width: 10%; text-align: center;">
                        <template #body="slotProps">
                            <b>{{ slotProps.data.daily_evalua }}</b>
                        </template>
                    </Column>
                    <Column field="name_dialywork" header="ภาระงาน" style="width: 25%; text-align: left;">
                        <template #body="slotProps">
                            <b>{{ slotProps.data.name_dialywork }}</b>
                        </template>
                    </Column>
                    <Column field="daily_filename" header="ไฟล์เอกสาร" style="width: 20%; text-align: center;">
                        <template #body="slotProps">
                            <span v-if="slotProps.data.daily_filename">
                                <a :href="getFileUrl(slotProps.data.dialy_file)" target="_blank" class="p-button p-component p-button-link">
                                    <i class="pi pi-download"></i> {{ slotProps.data.daily_filename }}
                                </a>
                            </span>
                            <span v-else>ไม่มีไฟล์</span>
                        </template>
                    </Column>
                    <Column field="daily_link" header="ลิงก์เอกสาร" style="width: 10%; text-align: center;">
                        <template #body="slotProps">
                            <a v-if="slotProps.data.daily_link" :href="slotProps.data.daily_link" target="_blank" class="p-button p-component p-button-link">
                                <i class="pi pi-external-link"></i> เปิดลิงก์
                            </a>
                            <span v-else>ไม่มีลิงก์</span>
                        </template>
                    </Column>
                    <Column field="status" header="สถานะ" style="width: 15%; text-align: center;">
                        <template #body="slotProps">
                            <Button
                                v-if="slotProps.data.status === 'in_progress'"
                                label="กำลังดำเนินการ"
                                severity="warning"
                                class="p-button-sm"
                            />
                            <Button
                                v-else-if="slotProps.data.status === 'completed'"
                                label="เสร็จสิ้น"
                                severity="success"
                                class="p-button-sm"
                            />
                            <Button
                                v-else-if="slotProps.data.status === 'overdue'"
                                label="เลยกำหนด"
                                severity="danger"
                                class="p-button-sm"
                            />
                            <Button
                                v-else
                                label="ไม่ระบุ"
                                severity="contrast" class="p-button-sm"
                                outlined
                            />
                        </template>
                    </Column>
                    <Column field="actions" header="จัดการ" headerStyle="text-align: center;" bodyStyle="text-align: center;" style="width: 10%;">
                        <template #body="slotProps">
                            <Button
                                icon="pi pi-ellipsis-h"
                                class="p-button-text p-button-secondary"
                                @click="toggleOptionsMenu($event, slotProps.data)"
                                aria-haspopup="true"
                                aria-controls="overlay_menu"
                            />
                        </template>
                    </Column>
                </DataTable>
                <Menu ref="optionsMenu" :model="items" :popup="true" />
            </div>
        </div>
    </div>
</template>

<script setup>
import { useAuth } from '#imports';
const { signIn, getSession, signOut } = await useAuth();
const user = await getSession();
</script>

<script>
import axios from 'axios';
import Swal from 'sweetalert2';
import { ref } from 'vue';

export default {
    data() {
        return {
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '01',
            products_date: [],
            DialogAdd: false,
            DialogDetail: false,
            currentRecordId: null,
            taskDate: null, // กำหนดค่าเริ่มต้นเป็น null
            EndDate: null,
            AcompDate:null,
            documentLink: '',
            dailyTask: '',
            selectedFile: null,
            base64FileContent: null,
            dailyFilename: '',
            userStaffId: null,
            userFacId: null,
            userStaffNameDaily: null,
            userStaffDepartmentName: null,
            evaluadaily: null,
            evaluadailys: [
                { label: 'รอบประเมินที่ 1', value: 1 },
                { label: 'รอบประเมินที่ 2', value: 2 },
            ],
            selectedTask: null, // ใช้สำหรับ DialogDetail
            selectedRowData: null, // ใช้สำหรับเก็บข้อมูลแถวที่คลิก Menu เพื่อส่งให้ command
            items: [
                {
                    label: 'ดูรายละเอียด',
                    icon: 'pi pi-info-circle',
                    class: 'detail-menu-item',
                    command: () => {
                        this.OpenDialogDetail(this.selectedRowData);
                    }
                },
                {
                    label: 'แก้ไข',
                    icon: 'pi pi-pencil',
                    class: 'edit-menu-item',
                    command: () => {
                        this.editData(this.selectedRowData);
                    }
                },
                {
                    label: 'ลบ',
                    icon: 'pi pi-trash',
                    class: 'delete-menu-item',
                    command: () => {
                        this.delData(this.selectedRowData);
                    }
                }
            ]
        };
    },
    async mounted() {
        const session = await useAuth().getSession();
        if (session && session.user && session.user.name) {
            const { STAFFID, SCOPES, STAFFNAME, PREFIXFULLNAME, STAFFSURNAME } = session.user.name;
            const { staffdepartment, groupid, staffdepartmentname } = SCOPES;

            this.staffid_Main = String(STAFFID);
            this.facid_Main = String(staffdepartment);
            this.groupid_Main = String(groupid);

            this.userStaffId = String(STAFFID);
            this.userFacId = String(staffdepartment);
            this.userStaffNameDaily = `${PREFIXFULLNAME || ''} ${STAFFNAME || ''} ${STAFFSURNAME || ''}`.trim();
            this.userStaffDepartmentName = String(staffdepartmentname);

            await this.showDataSetUserdialy();
        } else {
            console.warn("User session data not found on mounted.");
        }
    },
    methods: {
        formatDate(dateString) {
            if (!dateString || dateString === '0000-00-00 00:00:00' || dateString === '0000-00-00') return ''; // เพิ่ม '0000-00-00 00:00:00'
            const date = new Date(dateString);

            // ตรวจสอบว่า date เป็นวันที่ที่ถูกต้องหรือไม่
            if (isNaN(date.getTime())) {
                console.warn(`Invalid date string provided to formatDate: ${dateString}`);
                return dateString; // คืนค่าเดิมถ้าไม่สามารถแปลงเป็น Date ได้
            }

            const options = {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false,
                timeZone: 'Asia/Bangkok' // กำหนด timeZone ให้ชัดเจน
            };
            return date.toLocaleDateString('th-TH', options);
        },
        getFileUrl(filename) {
            if (!filename) return '';
            if (filename.startsWith('http://') || filename.startsWith('https://')) {
                return filename;
            }
            return `http://127.0.0.1:8000/storage/uploads/daily_files/${filename}`;
        },
        calculateTotalTime(startDateStr, endDateStr) {
            if (!startDateStr || !endDateStr || endDateStr === '0000-00-00 00:00:00' || endDateStr === '0000-00-00') { // เพิ่ม '0000-00-00 00:00:00'
                return { days: null, hours: null, minutes: null, display: 'ยังไม่เสร็จสิ้น/ไม่ระบุเวลา' };
            }

            const startDate = new Date(startDateStr);
            const endDate = new Date(endDateStr);

            const diffMs = Math.abs(endDate - startDate);

            const totalMinutes = Math.floor(diffMs / (1000 * 60));
            const days = Math.floor(totalMinutes / (24 * 60));
            const remainingMinutesAfterDays = totalMinutes % (24 * 60);
            const hours = Math.floor(remainingMinutesAfterDays / 60);
            const minutes = remainingMinutesAfterDays % 60;

            let displayString = '';
            if (days > 0) {
                displayString += `${days} วัน `;
            }
            if (hours > 0) {
                displayString += `${hours} ชั่วโมง `;
            }
            if (minutes > 0) {
                displayString += `${minutes} นาที`;
            }

            if (displayString.trim() === '') {
                if (diffMs > 0) {
                    displayString = "น้อยกว่า 1 นาที";
                } else {
                    displayString = "เสร็จสิ้นภายในช่วงเวลาเดียวกัน";
                }
            }

            return { days: days, hours: hours, minutes: minutes, display: displayString.trim() };
        },

        async showDataSetUserdialy() {
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/showDateSetUserdaily', {
                    facid_Main: this.facid_Main,
                    groupid_Main: this.groupid_Main,
                    staffid_Main: this.staffid_Main
                });

                this.products_date = response.data.map(item => {
                    const endDate = item.end_date ? new Date(item.end_date) : null;
                    const accompDate = item.accomplet_date && item.accomplet_date !== '0000-00-00 00:00:00' // ตรวจสอบค่า '0000-00-00 00:00:00'
                                    ? new Date(item.accomplet_date) : null;
                    const today = new Date();

                    let status = 'unknown';

                    if (accompDate) {
                        // กรณีมี "วันที่เสร็จจริง" แล้ว
                        if (endDate && accompDate <= endDate) {
                            status = 'completed'; // เสร็จสิ้น (ก่อนหรือตรงตามกำหนด)
                        } else {
                            status = 'overdue'; // เลยกำหนด (เสร็จช้ากว่ากำหนด)
                        }
                    } else {
                        // กรณีที่ยังไม่มี "วันที่เสร็จจริง"
                        if (endDate && today <= endDate) {
                            status = 'in_progress'; // อยู่ระหว่างดำเนินการ (วันที่ปัจจุบันยังไม่เลยกำหนด)
                        } else if (endDate && today > endDate) {
                            status = 'overdue'; // เลยกำหนด (วันที่ปัจจุบันเลยกำหนดแล้วแต่ยังไม่เสร็จ)
                        } else {
                            status = 'unknown'; // กรณีไม่มีทั้ง end_date และ accomp_date
                        }
                    }

                    const totalTime = this.calculateTotalTime(item.daily_date, item.accomplet_date);

                    return {
                        ...item,
                        status: status,
                        total_days: totalTime.days,
                        total_hours: totalTime.hours,
                        total_minutes: totalTime.minutes,
                        total_time_display: totalTime.display
                    };
                });

            } catch (error) {
                console.error('Error fetching data:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาด',
                    text: 'ไม่สามารถโหลดข้อมูลภาระงานได้',
                });
            }
        },
        OpenDialogAdd() {
            this.DialogAdd = true;
            this.clearForm();
            this.taskDate = new Date(); // กำหนด taskDate เป็นเวลาปัจจุบันท้องถิ่น
        },
        OpenDialogDetail(data) {
            this.selectedTask = data;
            this.DialogDetail = true;
        },
        resetDialogdialy() {
            this.DialogAdd = false;
            this.DialogDetail = false;
            this.clearForm();
        },
        onFileChange(event) {
            const file = event.target.files[0];
            this.selectedFile = file;

            if (file) {
                this.dailyFilename = file.name;

                const reader = new FileReader();
                reader.onload = (e) => {
                    this.base64FileContent = e.target.result;
                };
                reader.onerror = (error) => {
                    console.error("FileReader error:", error);
                    this.base64FileContent = null;
                };
                reader.readAsDataURL(file);
            } else {
                this.base64FileContent = null;
                this.dailyFilename = '';
            }
        },

        async saveDailyTask() {
            if (!this.dailyTask || !this.EndDate) {
                Swal.fire({
                    icon: 'warning',
                    title: 'ข้อมูลไม่ครบถ้วน',
                    text: 'กรุณากรอกภาระงานประจำวัน และวันที่กำหนดเสร็จให้ครบถ้วน',
                });
                return;
            }
            if (this.evaluadaily === null) {
                Swal.fire({
                    icon: 'warning',
                    title: 'ข้อมูลไม่ครบถ้วน',
                    text: 'กรุณาเลือกรอบประเมิน',
                });
                return;
            }

            const realTimeDateForSave = new Date();
            const year = realTimeDateForSave.getFullYear();
            const month = String(realTimeDateForSave.getMonth() + 1).padStart(2, '0');
            const day = String(realTimeDateForSave.getDate()).padStart(2, '0');
            const hours = String(realTimeDateForSave.getHours()).padStart(2, '0');
            const minutes = String(realTimeDateForSave.getMinutes()).padStart(2, '0');
            const seconds = String(realTimeDateForSave.getSeconds()).padStart(2, '0');
            const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

            let formattedEndDate = null;
            if (this.EndDate) {
                const endYear = this.EndDate.getFullYear();
                const endMonth = String(this.EndDate.getMonth() + 1).padStart(2, '0');
                const endDay = String(this.EndDate.getDate()).padStart(2, '0');
                const endHours = String(this.EndDate.getHours()).padStart(2, '0');
                const endMinutes = String(this.EndDate.getMinutes()).padStart(2, '0');
                const endSeconds = String(this.EndDate.getSeconds()).padStart(2, '0');
                formattedEndDate = `${endYear}-${endMonth}-${endDay} ${endHours}:${endMinutes}:${endSeconds}`;
            }

            let formattedAcompDate = null;
            if (this.AcompDate) {
                const acompYear = this.AcompDate.getFullYear();
                const acompMonth = String(this.AcompDate.getMonth() + 1).padStart(2, '0');
                const acompDay = String(this.AcompDate.getDate()).padStart(2, '0');
                const acompHours = String(this.AcompDate.getHours()).padStart(2, '0');
                const acompMinutes = String(this.AcompDate.getMinutes()).padStart(2, '0');
                const acompSeconds = String(this.AcompDate.getSeconds()).padStart(2, '0');
                formattedAcompDate = `${acompYear}-${acompMonth}-${acompDay} ${acompHours}:${acompMinutes}:${acompSeconds}`;
            }


            const payload = {
                name_dialywork: this.dailyTask,
                daily_date: formattedDate,
                daily_link: this.documentLink,
                dialy_file: this.base64FileContent,
                daily_filename: this.dailyFilename,
                daily_evalua: this.evaluadaily,
                end_date: formattedEndDate,
                accomplet_date: formattedAcompDate,
                staffid: this.staffid_Main,
                facid: this.facid_Main,
                name_daily: this.userStaffNameDaily,
                name_facdialy: this.userStaffDepartmentName,
            };

            if (this.currentRecordId) {
                payload.id = this.currentRecordId;
            }

            try {
                const res = await axios.post('http://127.0.0.1:8000/api/saveWorkdaily', payload);

                Swal.fire({
                    position: "top-center",
                    icon: "success",
                    title: "บันทึกเรียบร้อยแล้ว !",
                    showConfirmButton: false,
                    timer: 1500
                });
                this.DialogAdd = false;
                this.showDataSetUserdialy();
                this.clearForm();
            } catch (error) {
                console.error('Error saving daily task:', error.response || error);
                let errorMessage = "เกิดข้อผิดพลาดในการบันทึก!";
                if (error.response && error.response.data) {
                    if (error.response.data.error) {
                        errorMessage = "เกิดข้อผิดพลาด: " + error.response.data.error;
                    } else if (error.response.data.message) {
                        errorMessage = "ข้อผิดพลาด: " + error.response.data.message;
                        if (error.response.data.errors) {
                            let validationErrors = '';
                            for (const field in error.response.data.errors) {
                                validationErrors += `\n- ${error.response.data.errors[field].join(', ')}`;
                            }
                            errorMessage += validationErrors;
                        }
                    }
                } else if (error.request) {
                    errorMessage = "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ได้ ตรวจตรวจสอบ Network";
                } else {
                    errorMessage = "ข้อผิดพลาดที่ไม่รู้จัก: " + error.message;
                }

                Swal.fire({
                    position: "top-center",
                    icon: "error",
                    title: errorMessage,
                    showConfirmButton: true,
                });
            }
        },
        editData(data) {
            this.DialogDetail = false;
            this.DialogAdd = true;
            this.currentRecordId = data.id;

            this.taskDate = new Date(); // กำหนด taskDate เป็นเวลาปัจจุบันท้องถิ่น 
            this.EndDate = data.end_date ? new Date(data.end_date) : null;
            // AcompDate ควรเป็น null ถ้าค่าที่ได้จาก DB เป็น '0000-00-00 00:00:00'
            this.AcompDate = data.accomplet_date && data.accomplet_date !== '0000-00-00 00:00:00' && data.accomplet_date !== '0000-00-00'
                        ? new Date(data.accomplet_date) : null;

            this.documentLink = data.daily_link;
            this.evaluadaily = data.daily_evalua ? parseInt(data.daily_evalua, 10) : null;
            this.dailyTask = data.name_dialywork;
            this.dailyFilename = data.daily_filename || '';
            this.base64FileContent = null;
        },
        delData(data) {
            this.DialogDetail = false;
            Swal.fire({
                title: "คุณต้องการลบรายการนี้ใช่หรือไม่?",
                text: "ข้อมูลที่ถูกลบจะไม่สามารถกู้คืนได้!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "ใช่, ลบเลย!",
                cancelButtonText: "ยกเลิก"
            }).then(async (result) => {
                if (result.isConfirmed) {
                    try {
                        const response = await axios.post('http://127.0.0.1:8000/api/delWorkdaily', { id: data.id });
                        Swal.fire({
                            position: "top-center",
                            icon: "success",
                            title: "ลบข้อมูลเรียบร้อยแล้ว",
                            showConfirmButton: false,
                            timer: 1500
                        });
                        this.showDataSetUserdialy(); // Refresh data table
                    } catch (error) {
                        console.error('Error deleting data:', error);
                        Swal.fire({
                            icon: 'error',
                            title: 'ข้อผิดพลาด',
                            text: 'ไม่สามารถลบข้อมูลได้',
                        });
                    }
                }
            });
        },
        clearForm() {
            this.currentRecordId = null;
            this.taskDate = null;
            this.EndDate = null;
            this.AcompDate = null;
            this.documentLink = '';
            this.dailyTask = '';
            this.selectedFile = null;
            this.base64FileContent = null;
            this.dailyFilename = '';
            this.evaluadaily = null;
            if (this.$refs.fileInputRef) {
                this.$refs.fileInputRef.value = '';
            }
        },
        toggleOptionsMenu(event, data) {
            this.selectedRowData = data;
            this.$refs.optionsMenu.toggle(event);
        },
        async printDataDaily() {
            try {
                const response = await axios.post('http://127.0.0.1:8000/api/exportWorkdaily', {
                    staffid_Main: this.staffid_Main,
                    facid_Main: this.facid_Main,
                    groupid_Main: this.groupid_Main
                }, { responseType: 'blob' }); // Important: responseType must be 'blob' for file download

                const url = window.URL.createObjectURL(new Blob([response.data]));
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', `ภาระงานประจำวัน_${this.userStaffNameDaily}.docx`); // Dynamic filename
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                window.URL.revokeObjectURL(url);
            } catch (error) {
                console.error('Error exporting data:', error.response || error);
                Swal.fire({
                    icon: 'error',
                    title: 'ข้อผิดพลาดในการส่งออกไฟล์',
                    text: 'ไม่สามารถส่งออกไฟล์ได้ โปรดลองอีกครั้ง',
                });
            }
        }
    }
};
</script>

<style>
/* สไตล์สำหรับข้อความ (label) ของ Menu Item */
.p-menuitem-link.detail-menu-item .p-menuitem-text {
    color: #007bff !important; /* สีน้ำเงินสำหรับ "ดูรายละเอียด" */
}

.p-menuitem-link.edit-menu-item .p-menuitem-text {
    color: #28a745 !important; /* สีเขียวสำหรับ "แก้ไข" */
}

.p-menuitem-link.delete-menu-item .p-menuitem-text {
    color: #dc3545 !important; /* สีแดงสำหรับ "ลบ" */
}

/* สไตล์สำหรับไอคอน (icon) ของ Menu Item */
.p-menuitem-link.detail-menu-item .p-menuitem-icon {
    color: #007bff !important; /* สีน้ำเงินสำหรับไอคอน "ดูรายละเอียด" */
}

.p-menuitem-link.edit-menu-item .p-menuitem-icon {
    color: #28a745 !important; /* สีเขียวสำหรับไอคอน "แก้ไข" */
}

.p-menuitem-link.delete-menu-item .p-menuitem-icon {
    color: #dc3545 !important; /* สีแดงสำหรับไอคอน "ลบ" */
} 
/* (Optional) สไตล์สำหรับสีพื้นหลังเมื่อ hover หรือ active */
.p-menuitem-link.detail-menu-item:hover {
    background-color: rgba(0, 123, 255, 0.1); /* สีฟ้าอ่อนเมื่อ hover */
}

.p-menuitem-link.edit-menu-item:hover {
    background-color: rgba(40, 167, 69, 0.1); /* สีเขียวอ่อนเมื่อ hover */
}

.p-menuitem-link.delete-menu-item:hover {
    background-color: rgba(220, 53, 69, 0.1); /* สีแดงอ่อนเมื่อ hover */
}

/* ----- สไตล์ใหม่สำหรับ DataTable Cell Wrapping ----- */
/* กำหนดให้ข้อความในเซลล์ตารางขึ้นบรรทัดใหม่ได้ */
.p-datatable .p-datatable-tbody > tr > td {
    white-space: normal; /* อนุญาตให้ข้อความขึ้นบรรทัดใหม่ */
    word-break: break-word; /* บังคับให้คำที่ยาวมากตัดคำลงมา */
    overflow-wrap: break-word; /* อีกคุณสมบัติที่คล้ายกัน ช่วยในการตัดคำ */
    vertical-align: top; /* จัดตำแหน่งข้อความชิดด้านบนในเซลล์ที่มีหลายบรรทัด */
}

/* กำหนดความกว้างสูงสุดสำหรับคอลัมน์เฉพาะ (ตัวอย่าง) */
/* อาจต้องปรับค่า width ใน <Column> tag ของคุณให้สอดคล้องกันด้วย */
.p-datatable .p-datatable-tbody > tr > td:nth-child(3) { /* คอลัมน์ "ภาระงาน" */
    max-width: 300px; /* กำหนดความกว้างสูงสุด */
}
.p-datatable .p-datatable-tbody > tr > td:nth-child(4) { /* คอลัมน์ "ไฟล์เอกสาร" */
    max-width: 150px; /* กำหนดความกว้างสูงสุด */
}
.p-datatable .p-datatable-tbody > tr > td:nth-child(5) { /* คอลัมน์ "ลิงก์เอกสาร" */
    max-width: 120px; /* กำหนดความกว้างสูงสุด */
}

/* สไตล์สำหรับปุ่ม 'เปิดลิงก์' และ 'ดาวน์โหลดไฟล์' ให้มีขนาดเล็กลง */
.p-datatable .p-button.p-button-link {
    padding: 0.25rem 0.5rem; /* ลดขนาด padding */
    font-size: 0.8em; /* ลดขนาดตัวอักษร */
}
.p-datatable .p-button.p-button-link .pi {
    margin-right: 0.25rem; /* ลดระยะห่างไอคอน */
}
</style>