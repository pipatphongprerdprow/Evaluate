    <script setup>
        import { ref } from 'vue';
        import AppMenuItem from './AppMenuItem.vue'; 
            const model = ref([
                {
                    label: 'หน้าหลัก',
                    items: [
                        { label: 'หน้าหลัก', icon: 'pi pi-fw pi-home', to: '/' },
                    ]
                },
                 // {
                    //     label: 'ตั้งค่าระบบ',
                    //     items: [
                    //         { label: 'จัดการ รอบประเมิน', icon: 'pi pi-fw pi-calendar', to: '/setting/setting_date' }, 
                    //         { label: 'จัดการ แบบประเมิน', icon: 'pi pi-fw pi-sliders-h', to: '/setting/setting_assessment' }, 
                    //         { label: 'ตรวจสอบ แบบประเมิน', icon: 'pi pi-fw pi-star', to: '/setting/checkevaluate' }, 
                    //     ]
                // },
                {
                    label: 'แบบบันทึกข้อตกลง(TOR)ป.01-ป.03',
                    items: [ 
                        { label: 'แบบบันทึกข้อตกลง', icon: 'pi pi-fw pi-calendar', to: '/setting/coversheet' },
                        
                    ]
                }, 
                {
                    label: 'ผู้บริหาร',
                    items: [ 
                        { label: 'ตรวจติดตามแบบประเมิน', icon: 'pi pi-bell', to: '/setting/tracking' },
                    ]
                }, 
                {
                    label: 'เจ้าหน้าที่บุคคล',
                    items: [
                        { label: 'จัดการ รอบประเมิน', icon: 'pi pi-fw pi-calendar', to: '/setting/setting_date' }, 
                        // { label: 'จัดการ แบบประเมิน', icon: 'pi pi-fw pi-sliders-h', to: '/setting/setting_assessment' }, 
                        { label: 'ตรวจสอบ แบบประเมิน', icon: 'pi pi-fw pi-star', to: '/setting/checkevaluate' },  
                    ]
                },
                {
                    label: 'คู่มือการใช้งานระบบ', items: [  
                        // { label: 'คู่มือใช้งานระบบ (User)', icon: 'pi pi-id-card', href:'http://localhost:8000/storage/uploadsP03/P03_219_c1ba1af8-e110-49ba-aab0-b6f1c80d5848.pdf', target: '_blank' }, 
                        // {  label: 'คู่มือใช้งานระบบ (เจ้าหน้าที่บุคคล)', icon: 'pi pi-id-card', to: '/storage/uploadsP03/personnel_manual.pdf/', target: '_blank' },
                        // {  label: 'คู่มือใช้งานระบบ (ผู้บริหาร)', icon: 'pi pi-id-card', to:'/storage/uploadsP03/manager_manual.pdf/', target: '_blank' }
                    ]
                }   
                ]);  
            </script>  
                <template>
                    <ul class="layout-menu"> 
                        <template v-for="(item, i) in model" :key="item">
                            <app-menu-item v-if="!item.separator" :item="item" :index="i"></app-menu-item>
                            <li v-if="item.separator" class="menu-separator"></li>
                        </template>
                
                        <!-- <li>
                            <a href="https://www.primefaces.org/primeblocks-vue/#/" target="_blank">
                                <img src="/layout/images/banner-primeblocks.png" alt="Prime Blocks" class="w-full mt-3" />
                            </a>
                        </li>  -->
                    </ul>
                    <div>
                        <div v-for="(menuItem, index) in menuItems" :key="index">
                        <a :href="menuItem.href" :target="menuItem.target" rel="noopener noreferrer" class="menu-link">
                            <i :class="menuItem.icon"></i>
                            {{ menuItem.label }}
                        </a>
                        </div>
                    </div>
                </template> 
            <script>
                export default {
                data() {
                    return {
                        menuItems: [
                                {
                                    label: 'คู่มือใช้งานระบบ (User)',
                                    icon: 'pi pi-id-card',
                                    href: 'http://localhost:8000/storage/manuals/manual_user.pdf',
                                    target: '_blank',
                                },
                                {
                                    label: 'คู่มือใช้งานระบบ (เจ้าหน้าที่บุคคล)',
                                    icon: 'pi pi-user',
                                    href: 'http://localhost:8000/storage/manuals/manual_person.pdf',
                                    target: '_blank',
                                },
                                {
                                    label: 'คู่มือใช้งานระบบ (ผู้บริหาร)',
                                    icon: 'pi pi-users',
                                    href: 'http://localhost:8000/storage/manuals/manual_executive.pdf',
                                    target: '_blank',
                                },
                            ],
                        };
                    },
                };
            </script>
            <style lang="scss" scoped></style>
            <style>
                table {  
                    border: 1px solid #b4b4b4;
                    border-bottom: none;
                    border-right: none;
                    border-radius: 5px;
                    width: 100%;
                } 

                th, td { 
                    border-bottom: 1px solid #b4b4b4;
                    border-right: 1px solid #b4b4b4;
                }
                .menu-link {
                    display: block;
                    text-decoration: none;
                    color: white;
                    margin-bottom: 10px;
                }
            </style>



