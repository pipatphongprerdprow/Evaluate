<script setup>
import { ref, computed, onMounted } from 'vue';
import AppMenuItem from './AppMenuItem.vue';
import axios from 'axios';
import { watch } from 'vue';

const { getSession } = useAuth();
const user = await getSession();
const groupid = user?.user?.name?.SCOPES?.groupid || '';
const staff = user?.user?.name?.STAFFID || '';
const faculty = user?.user?.name?.SCOPES?.staffdepartment || '';

const allMenus = ref([
    {
        id: 'home',
        label: 'หน้าหลัก',
        items: [{ label: 'หน้าหลัก', icon: 'pi pi-fw pi-home', to: '/' }]
    },
    {
        id: 'tor',
        label: 'แบบบันทึกข้อตกลง(TOR)ป.01-ป.03',
        items: [{ label: 'แบบบันทึกข้อตกลง', icon: 'pi pi-fw pi-calendar', to: '/setting/coversheet' }]
    }, 
    // {
    //     id: 'history',
    //     label: 'ประวัติการประเมิน',
    //     items: [{ label: 'ประวัติการประเมิน', icon: 'pi pi-fw pi-clock', to: '/setting/history' }]
    // },

    {
        id: 'torday',
        label: 'แบบบันทึกภาระงานประจำวัน',
        items: [{ label: 'แบบบันทึกภาระงานประจำวัน', icon: 'pi pi-fw pi-calendar', to: '/setting/tordayplannew' }]
    },
    {
        id: 'executive',
        label: 'ผู้บริหาร',
        items: [
            { label: 'ตรวจติดตามแบบประเมิน', icon: 'pi pi-bell', to: '/setting/tracking' },
            { label: 'ตรวจติดตามภาระงานประจำวัน', icon: 'pi pi-file', to: '/setting/checkedialy' }

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
        ]
    },
    {
        id: 'manual',
        label: 'คู่มือการใช้งานระบบ'
    }
]); 

const group_chkUser = ref(null);

const fetchUserGroup = async () => {
    try {
        //console.log('user: ',user);
        
        const res = await axios.post('    http://127.0.0.1:8000/api/testUser', { staff, faculty }); 
        //console.log('fetchUserGroup: ',res.data);
        
        group_chkUser.value = res.data?.[0]?.status_user || res.data?.status_user || null;
    } catch (error) {
        console.error('Error:', error);
    }
}; 

onMounted(async () => {
    await fetchUserGroup(); 
});

// // กรองเมนูตาม group_chkUser
const model = computed(() => {
    if (group_chkUser.value === null) return []; // ถ้าเป็น null คืนค่าเป็นอาร์เรย์ว่าง

    const group = String(group_chkUser.value); // แปลงเป็น string เพื่อป้องกันข้อผิดพลาด
    // console.log("Computed model for group:", group);
    switch (group) {
        case '99':
            return allMenus.value.filter(menu => ['home', 'tor', 'manual','history','torday'].includes(menu.id));//ผู้ใช้งานทั่วไป
        case '2':
           // return allMenus.value.filter(menu => ['home', 'tor', 'executive','manual'].includes(menu.id)); //ฝ่ายบุคคล
            return allMenus.value.filter(menu => ['home', 'tor', 'executive', 'hr', 'manual','history','torday'].includes(menu.id));//ฝ่ายบุคคล
        case '3':
            //return allMenus.value.filter(menu => ['home', 'tor', 'executive', 'hr', 'manual'].includes(menu.id));//หน หน่วยงาน
            return allMenus.value.filter(menu => ['home', 'tor', 'executive','manual','history'].includes(menu.id));//หน หน่วยงาน
        case '4':
            return allMenus.value.filter(menu => [ 'home','executive',].includes(menu.id));//ผู้บริหารสูงขึ้นไป
        default:
            return allMenus.value.filter(menu => ['home', 'manual'].includes(menu.id));
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
                {
                    id: 'M1',
                    label: 'คู่มือใช้งานระบบ (ผู้บริหาร)',
                    icon: 'pi pi-users',
                    href: '    http://127.0.0.1:8000/storage/manuals/manual_executive.pdf',
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
