<script setup>
import { ref, computed, watch } from 'vue';
import AppMenuItem from './AppMenuItem.vue';
import axios from 'axios';
import { isSuperAdmin } from '~/utils/superAdmins';

const { status, data: sessionData } = useAuthState();

// ใช้ computed เพื่อดึงข้อมูล user จาก session
const groupid = computed(() => sessionData.value?.user?.name?.SCOPES?.groupid || '');
const staff = computed(() => sessionData.value?.user?.name?.STAFFID || '');
const faculty = computed(() => sessionData.value?.user?.name?.SCOPES?.staffdepartment || '');

const allMenus = ref([
    {
        id: 'home',
        label: 'หน้าหลัก',
        items: [
            { label: 'หน้าหลัก', icon: 'pi pi-fw pi-home', to: '/' },
            { label: 'ภาพรวมการประเมิน', icon: 'pi pi-chart-bar', to: '/setting/dashboardstaff' } 
        ]
    },
    {
        id: 'dashboard',
        label: 'dashboard',
        items: [
            { label: 'dashboard', icon: 'pi pi-chart-bar', to: '/setting/dashboard' } 

        ]
        
    }, 
    {
        id: 'tor',
        label: 'แบบบันทึกข้อตกลง(TOR)ป.01-ป.03',
        items: [
            { label: 'แบบบันทึกข้อตกลง', icon: 'pi pi-fw pi-calendar', to: '/setting/coversheet' },
            // { label: 'ลายเซ็นดิจิทัล', icon: 'pi pi-fw pi pi-user-edit', to: '/setting/digitalsignature' }

        ]
        
    }, 

    // {
    //     id: 'signature',
    //     label: 'Digitalsignature',
    //     items: [ 
    //         { label: 'ลายเซ็นดิจิทัล', icon: 'pi pi-fw pi pi-user-edit', to: '/setting/digitalsignature' } 
    //     ]
        
    // }, 
    
    {
        id: 'history',
        label: 'ประวัติการประเมิน',
        items: [{ label: 'ประวัติการประเมิน', icon: 'pi pi-fw pi-clock', to: '/setting/history' }]
    },

    // {
    //     id: 'torday',
    //     label: 'แบบบันทึกภาระงานประจำวัน',
    //     items: [{ label: 'แบบบันทึกภาระงานประจำวัน', icon: 'pi pi-fw pi-calendar', to: '/setting/tordayplannew' }]
    // },
    {
        id: 'executive',
        label: 'ผู้บริหาร',
        items: [
            { label: 'ตรวจติดตามแบบประเมิน', icon: 'pi pi-bell', to: '/setting/tracking' },
            //{ label: 'ตรวจติดตามภาระงานประจำวัน', icon: 'pi pi-file', to: '/setting/checkedialy' },
            //{ label: 'รายงานภาพรวมโครงการ', icon: 'pi pi-chart-bar', to: '/setting/projectoverview' }

        ],
         //items: [{ label: 'ตรวจติดตามภาระงานประจำวัน', icon: 'pi pi-bell', to: '/setting/checkedialy' }]
    },
    {
        id: 'hr',
        label: 'เจ้าหน้าที่บุคคล',
        items: [
            { label: 'จัดการ รอบประเมิน', icon: 'pi pi-fw pi-calendar', to: '/setting/setting_date' },
            { label: 'ตรวจสอบ แบบประเมิน', icon: 'pi pi-fw pi-star', to: '/setting/checkevaluate' },
            { label: 'เพิ่มสิทธิ์การใช้งาน', icon: 'pi pi-fw pi-user-plus', to: '/setting/setting_user' },
            { label: 'Export แบบ ป.04', icon: 'pi pi-fw pi-download', to: '/setting/export_p04' },
            //{ label: 'จัดการสิทธิ์บุคคล', icon: 'pi pi-fw pi-user', to: '/setting/setting_useradmin' }, 
        ]
    }, 
     {
        id: 'superadmin',
        label: 'Supperadmin',
        items: [
            { label: 'จัดการผู้ใช้งาน (Admin)', icon: 'pi pi-fw pi-users', to: '/setting/setting_dateSuperadmin' },
            { label: 'เพิ่มสิทธิ์การใช้งาน (Admin)', icon: 'pi pi-fw pi-user-plus', to: '/setting/setting_userSuperadmin' },
            { label: 'จัดการสัดส่วน', icon: 'pi pi-fw pi-sliders-h', to: '/setting/setting_ratioSuperadmin' },
            { label: 'ประวัติการใช้งาน', icon: 'pi pi-fw pi-history', to: '/setting/auditlog' }
        ]
    },
    {
        id: 'contact',
        label: 'ช่องทางการติดต่อ',
        items: [
            { label: 'ช่องทางการติดต่อ', icon: 'pi pi-fw pi-phone', to: '/setting/contact' } 
        ]
    },  

    {
        id: 'manual',
        label: 'คู่มือการใช้งานระบบ'
    },

   


]); 

const group_chkUser = ref(null);

let roleRequest = 0;

// Reset permissions on logout/account change and ignore responses from the previous session.
watch([status, staff, faculty], async ([currentStatus, currentStaff, currentFaculty]) => {
    const request = ++roleRequest;
    group_chkUser.value = null;
    if (currentStatus !== 'authenticated' || !currentStaff) return;
    try {
        const res = await axios.post('http://127.0.0.1:8000/api/testUser', {
            staff: currentStaff, faculty: currentFaculty
        });
        if (request !== roleRequest) return;
        group_chkUser.value = res.data?.[0]?.status_user || res.data?.status_user || null;
    } catch (error) {
        if (request === roleRequest) group_chkUser.value = null;
        console.error('Unable to load current user permissions');
    }
}, { immediate: true });

// หมวด Supperadmin เห็นเฉพาะ staffid ที่กำหนด
const model = computed(() => {
    const menus = [...roleMenus.value];
    if (status.value === 'authenticated' && isSuperAdmin(staff.value)) {
        if (!menus.some(menu => menu.id === 'hr')) {
            menus.push({ id: 'hr-p04', label: 'เจ้าหน้าที่บุคคล', items: [{ label: 'Export แบบ ป.04', icon: 'pi pi-fw pi-download', to: '/setting/export_p04' }] });
        }
        const manualIndex = menus.findIndex((menu) => menu.id === 'manual');
        menus.splice(manualIndex === -1 ? menus.length : manualIndex, 0,
            allMenus.value.find((menu) => menu.id === 'superadmin'));
    }
    return menus;
});

// // กรองเมนูตาม group_chkUser
const roleMenus = computed(() => {
    if (group_chkUser.value === null) return []; // ถ้าเป็น null คืนค่าเป็นอาร์เรย์ว่าง

    const group = String(group_chkUser.value); // แปลงเป็น string เพื่อป้องกันข้อผิดพลาด
   // console.log("Computed model for group:", group);
    switch (group) {
        case '99':
            return allMenus.value.filter(menu => ['home', 'tor', 'manual','history','torday','contact', 'signature'].includes(menu.id));//ผู้ใช้งานทั่วไป
        case '2':
           // return allMenus.value.filter(menu => ['home', 'tor', 'executive','manual'].includes(menu.id)); //ฝ่ายบุคคล
            return allMenus.value.filter(menu => ['home', 'tor', 'executive', 'hr', 'manual','Ad','torday','history','contact', 'dashboard', 'signature'].includes(menu.id));//ฝ่ายบุคคล
        case '3':
            //return allMenus.value.filter(menu => ['home', 'tor', 'executive', 'hr', 'manual'].includes(menu.id));//หน หน่วยงาน
            return allMenus.value.filter(menu => ['home', 'tor', 'executive','manual','history','contact', 'dashboard', 'signature'].includes(menu.id));//หน หน่วยงาน
        case '4':
            return allMenus.value.filter(menu => [ 'home','executive',,'contact', 'dashboard', 'signature'].includes(menu.id));//ผู้บริหารสูงขึ้นไป
        case '5':
            return allMenus.value.filter(menu => [ 'home', 'tor', 'manual','Ad','torday',,'contact', 'dashboard', 'signature'].includes(menu.id));//admin 
        default:
            return allMenus.value.filter(menu => ['home', 'manual','contact'].includes(menu.id));
    }
});

watch(() => group_chkUser.value, (newVal) => {
    //console.log("group_chkUser updated:", newVal);
});

</script>

<template>
    <ul class="layout-menu">
        <template v-for="(item, i) in model" :key="item.id">
            <AppMenuItem v-if="!item.separator" :item="item" :index="i" />
            <li v-if="item.separator" class="menu-separator"></li>
        </template>
    </ul>
    <div>
        <div v-for="(menuItem, index) in menuItems" :key="index" style="padding-top: 10px; padding-left: 20px;">
            <a :href="menuItem.href" :target="menuItem.target" rel="noopener noreferrer" class="menu-link">
                <i :class="menuItem.icon"></i>
                {{ menuItem.label }}
            </a>
        </div>
    </div>
    <!-- <div> 
        user: {{ staff ?? 0 }} <br>
        faculty: {{ faculty ?? 0 }} <br>
        groupChk: {{ group_chkUser }}
    </div> -->
</template>

<script>
export default {
    data() {
        return {
            menuItems: [
                { 
                    id: 'M1',
                    label: 'คู่มือใช้งานระบบ (User)',
                    icon: 'pi pi-id-card',
                    href: '    http://127.0.0.1:8000/storage/manuals/manual_user.pdf',
                    target: '_blank',
                },
                {
                    id: 'M1',
                    label: 'คู่มือใช้งานระบบ (เจ้าหน้าที่บุคคล)',
                    icon: 'pi pi-user',
                    href: '    http://127.0.0.1:8000/storage/manuals/manual_person.pdf',
                    target: '_blank',
                },
                // {
                //     id: 'M1',
                //     label: 'คู่มือใช้งานระบบ (ผู้บริหาร)',
                //     icon: 'pi pi-users',
                //     href: '    http://127.0.0.1:8000/storage/manuals/manual_executive.pdf',
                //     target: '_blank',
                // },
                {
                    id: 'M1',
                    label: 'คู่มือใช้งานระบบ (ผู้บริหาร)',
                    icon: 'pi pi-users',
                    href: 'https://www.youtube.com/watch?v=gsqtTGVwIKA',
                    target: '_blank',
                },
            ],
        };
    },
};
</script>

<style lang="scss" scoped>
.menu-link {
    display: block;
    text-decoration: none;
    color: white;
    margin-bottom: 10px;
}

table {
    border: 1px solid #b4b4b4;
    border-bottom: none;
    border-right: none;
    border-radius: 5px;
    width: 100%;
}

th,
td {
    border-bottom: 1px solid #b4b4b4;
    border-right: 1px solid #b4b4b4;
}
</style>
