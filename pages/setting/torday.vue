<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6">
                        <h3 class="mb-4 card-header">
                            <i class="pi pi-file" style="font-size: x-large;"></i> บันทึกภาระงานประจำวัน
                        </h3>
                    </div>
                    <br>
                    <div class="col md:col-16 text-right">
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มภาระงาน" @click="openDialogAdd" />

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
                            <form @submit.prevent="saveDailyTask">
                                <div class="p-fluid formgrid grid">
                                    <div class="field col-12 md:col-2">
                                        <label for="task_date">วันที่ลงบันทึก</label>
                                        <InputGroup>
                                            <InputGroupAddon>
                                                <i class="pi pi-calendar"></i>
                                            </InputGroupAddon>
                                            <Calendar
                                                v-model="taskDate"
                                                dateFormat="dd/mm/yy"
                                                placeholder="วัน/เดือน/ปี"
                                                showIcon
                                                class="w-full"
                                                required
                                            />
                                        </InputGroup>
                                    </div>
                                    <div class="field col-12 md:col-5">
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
                                        <small v-if="editingTaskId && existingFilename && !currentFile" class="p-text-secondary">
                                            ไฟล์ปัจจุบัน: {{ existingFilename }}
                                            <Button icon="pi pi-times" severity="danger" class="p-button-sm p-button-text ml-2" @click="clearExistingFile" />
                                        </small>
                                    </div>
                                    <div class="field col-12 md:col-5">
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
                                <Button label="ยกเลิก" icon="pi pi-times" class="mb-2 mr-2" severity="danger" @click="resetDialog" />
                            </template>
                        </Dialog>
                    </div>
                </div>
                <DataTable :value="products_date" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">
                    <Column field="daily_date" header="วันที่" style="width: 15%; text-align: center;">
                        <template #body="item">
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <b>{{ item.data.daily_date }}</b>
                            </div>
                        </template>
                    </Column>
                    <Column field="name_dailywork" header="ภาระงาน" style="width: 35%; text-align: left; padding-left: 1rem;">
                        <template #body="item">
                            <b>{{ item.data.name_dailywork }}</b>
                        </template>
                    </Column>
                    <Column field="daily_filename" header="ไฟล์เอกสาร" style="width: 15%; text-align: center;">
                        <template #body="item">
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <a v-if="item.data.daily_filename && item.data.daily_file_url" :href="item.data.daily_file_url" target="_blank" class="p-button p-component p-button-link p-button-text">
                                    <i class="pi pi-file"></i> {{ item.data.daily_filename }}
                                </a>
                                <span v-else-if="item.data.daily_filename && !item.data.daily_file_url">- {{ item.data.daily_filename }} (ไฟล์ไม่พร้อม)</span>
                                <span v-else>-</span>
                            </div>
                        </template>
                    </Column>
                    <Column field="daily_link" header="ลิงก์เอกสาร" style="width: 15%; text-align: center;">
                        <template #body="item">
                            <div style="display: flex; justify-content: center; align-items: center;">
                                <a v-if="item.data.daily_link" :href="item.data.daily_link" target="_blank" class="p-button p-component p-button-info p-button-text">
                                    <i class="pi pi-link"></i> ลิงก์
                                </a>
                                <span v-else>-</span>
                            </div>
                        </template>
                    </Column>
                    <Column field="options" header="ตัวเลือก" headerStyle="text-align: center;" bodyStyle="text-align: center; width: 20%;">
                        <template #body="item">
                            <div style="display: flex; justify-content: center; align-items: center; gap: 5px;">
                                <Button icon="pi pi-pencil" severity="success" class="p-button-sm" @click="editData(item.data)" />
                                <Button icon="pi pi-trash" severity="danger" class="p-button-sm" @click="delData(item.data)" />
                            </div>
                        </template>
                    </Column>
                </DataTable>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';
import Calendar from 'primevue/calendar';
import InputGroup from 'primevue/inputgroup';
import InputGroupAddon from 'primevue/inputgroupaddon';
import InputText from 'primevue/inputtext';
import Textarea from 'primevue/textarea';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';


const { getSession } = await useAuth();
const user = ref(null);


const DialogAdd = ref(false);
const editingTaskId = ref(null);
const taskDate = ref(null);
const documentLink = ref('');
const dailyTask = ref('');
const currentFile = ref(null);
const existingFilename = ref(null);
const fileInputRef = ref(null);
const products_date = ref([]);
const userStaffid = ref(null);
const userFacid = ref(null);
const userNameFull = ref(null);
const userDepartmentName = ref(null);


onMounted(async () => {
    user.value = await getSession();
    if (user.value && user.value.user && user.value.user.name) {
        userStaffid.value = user.value.user.name.STAFFID || null;
        userFacid.value = user.value.user.name.SCOPES?.staffdepartment || null;
        userNameFull.value = `${user.value.user.name.PREFIXFULLNAME || ''} ${user.value.user.name.STAFFNAME || ''} ${user.value.user.name.STAFFSURNAME || ''}`.trim();
        userDepartmentName.value = user.value.user.name.SCOPES?.staffdepartmentname || null;
    }
    await fetchDailyTasks();
});
const fetchDailyTasks = async () => {
    try {
        const response = await axios.get('http://127.0.0.1:8000/api/getDailyTasks', {
            params: {
                staffid: userStaffid.value,
                facid: userFacid.value
            }
        });
        products_date.value = response.data;
    } catch (error) {
        console.error('Error fetching daily tasks:', error);
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาดในการโหลดข้อมูล!',
            text: 'ไม่สามารถโหลดภาระงานประจำวันได้ กรุณาลองใหม่อีกครั้ง',
        });
    }
};

const openDialogAdd = () => {
    editingTaskId.value = null;
    resetDialog();
    DialogAdd.value = true;
};

const onFileChange = (event) => {
    const file = event.target.files[0];
    currentFile.value = file || null;
};


const clearExistingFile = () => {
    existingFilename.value = null;
    currentFile.value = null;
    if (fileInputRef.value) {
        fileInputRef.value.value = '';
    }
};
//ปุ่มบันทึกข้อมูล
const saveDailyTask = async () => {
    if (!taskDate.value || !dailyTask.value) {
        Swal.fire({
            icon: 'error',
            title: 'ข้อผิดพลาด!',
            text: 'กรุณากรอกวันที่ลงบันทึกและภาระงานประจำวัน',
        });
        return;
    }
    // ****** การแก้ไขที่สำคัญที่สุดคือตรงนี้ ******
    const day = String(taskDate.value.getDate()).padStart(2, '0');
    const month = String(taskDate.value.getMonth() + 1).padStart(2, '0');
    const year = taskDate.value.getFullYear();
    const formattedDate = `${day}/${month}/${year}`; // <-- แก้ไขให้เป็นแบบนี้เท่านั้น

    const formData = new FormData();
    formData.append('daily_date', formattedDate);
    formData.append('name_dailywork', dailyTask.value);
    formData.append('daily_link', documentLink.value || '');
    formData.append('staffid', userStaffid.value || '');
    formData.append('facid', userFacid.value || '');
    formData.append('name_daily', userNameFull.value || '');
    formData.append('name_facdialy', userDepartmentName.value || '');

    if (currentFile.value) {
        formData.append('daily_file', currentFile.value);
    } else if (editingTaskId.value && existingFilename.value === null) {
        formData.append('daily_filename', 'CLEAR_FILE_SIGNAL');
    } else if (editingTaskId.value && existingFilename.value) {
        formData.append('daily_filename', existingFilename.value);
    }
 
    try {
        let response;
        if (editingTaskId.value) {
            formData.append('id', editingTaskId.value);
            response = await axios.post('http://127.0.0.1:8000/api/saveDailyTask', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });
            Swal.fire({
                position: 'top-center',
                icon: 'success',
                title: 'อัปเดตภาระงานประจำวันเรียบร้อยแล้ว!',
                showConfirmButton: false,
                timer: 1500,
            });
        } else {
            response = await axios.post('http://127.0.0.1:8000/api/saveDailyTask', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            });
            Swal.fire({
                position: 'top-center',
                icon: 'success',
                title: 'บันทึกภาระงานประจำวันเรียบร้อยแล้ว!',
                showConfirmButton: false,
                timer: 1500,
            });
        }

        DialogAdd.value = false;
        resetDialog();
        await fetchDailyTasks();

    } catch (error) {
        console.error('Error saving daily task:', error);
        // เพิ่มการแสดง error จาก response ของ Axios (ถ้ามี)
        if (error.response && error.response.data && error.response.data.errors) {
            let errorMessages = Object.values(error.response.data.errors).flat().join('\n');
            Swal.fire({
                icon: 'error',
                title: 'เกิดข้อผิดพลาด!',
                html: `ไม่สามารถบันทึกภาระงานประจำวันได้<br>${errorMessages}<br>กรุณาลองใหม่อีกครั้ง`,
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: 'เกิดข้อผิดพลาด!',
                text: 'ไม่สามารถบันทึกภาระงานประจำวันได้ กรุณาลองใหม่อีกครั้ง',
            });
        }
    }
};

const resetDialog = () => {
    taskDate.value = null;
    documentLink.value = '';
    dailyTask.value = '';
    currentFile.value = null;
    existingFilename.value = null;
    editingTaskId.value = null;
    if (fileInputRef.value) {
        fileInputRef.value.value = '';
    }

    DialogAdd.value = false;
};
 
//  กดปุ่ม "แก้ไข" — ดึงข้อมูลมาใส่ใน Dialog
const editData = (item) => {
    editingTaskId.value = item.id; 
    const parts = item.daily_date.split('/'); 
    taskDate.value = new Date(parseInt(parts[2]), parseInt(parts[1]) - 1, parseInt(parts[0]));
    documentLink.value = item.daily_link || '';
    dailyTask.value = item.name_dailywork || '';
    existingFilename.value = item.daily_filename || null;
    currentFile.value = null;
    if (fileInputRef.value) {
        fileInputRef.value.value = '';
    }
    DialogAdd.value = true;
};
// ✅ ลบข้อมูลภาระงาน
const delData = (item) => {
    Swal.fire({
        title: 'คุณต้องการลบภาระงานนี้ใช่หรือไม่?',
        text: 'เมื่อคลิก "ใช่, ลบเลย!" ข้อมูลจะถูกลบทันที!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'ใช่, ลบเลย!',
        cancelButtonText: 'ยกเลิก',
    }).then(async (result) => {
        if (result.isConfirmed) {
            try {
                await axios.post('http://127.0.0.1:8000/api/deleteDailyTask', { id: item.id });
                Swal.fire({
                    icon: 'success',
                    title: 'ลบข้อมูลเสร็จสิ้น!',
                    text: 'ภาระงานประจำวันของคุณถูกลบแล้ว',
                });
                await fetchDailyTasks();
            } catch (error) {
                console.error('Error deleting daily task:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'เกิดข้อผิดพลาด!',
                    text: 'ไม่สามารถลบภาระงานประจำวันได้ กรุณาลองใหม่อีกครั้ง',
                });
            }
        }
    });
};
</script>

<style>
.card-header {
    text-align: left;
    margin: 0;
    padding: 0;
}
.table th {
    background-color: #edf2bb;
    font-weight: bold;
}
table {
    border-collapse: collapse;
    width: 100%;
}
th, td {
    border: 1px solid rgb(206, 203, 203);
    text-align: center;
}
</style>