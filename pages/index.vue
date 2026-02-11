<template> 
    <!-- Loading state -->
    <div v-if="status === 'loading'" class="flex align-items-center justify-content-center" style="min-height: 400px;">
        <i class="pi pi-spin pi-spinner" style="font-size: 3rem;"></i>
    </div>
    
    <!-- Content when authenticated -->
    <div v-else-if="status === 'authenticated'" class="flex flex-column align-items-center justify-content-center" style="width: 100%; max-width: 1200px;"> 
        <div style="border-radius: 56px; padding: 0.3rem; background: linear-gradient(180deg, rgba(33, 150, 243, 0.5) 40%, rgba(33, 150, 243, 0) 60%);width: 70%;">  
            <div class="w-full surface-card py-6 px-5 sm:px-8 flex flex-column align-items-center" style="border-radius: 53px;">
                <span class="text-blue-500 font-bold text-3xl">ระบบประเมินผลการปฏิบัติราชการ</span> 
                <span class="font-bold text-2xl">
                    <span class="text-yellow-500">MSU</span>&nbsp;
                    <span class="text-blue-500">P</span>erformance&nbsp;
                    <span class="text-blue-500">A</span>ppraisal
                </span>
                 {{ user.user.name }}  
                <div class="mb-3 mt-3">
                  <img id="IMG_PICTURE" :src="`${profileImageUrl}${user.user?.name.STAFFID}.jpg`" alt="Profile Picture" style="border-radius: 70px;width: 200px;height: auto;" />   
                </div>   
                <h3 class="text-900 font-bold text-3xl lg:text-2xl mb-2"> 
                    {{ user.user?.name.PREFIXFULLNAME }} {{ user.user?.name.STAFFNAME }} {{ user.user?.name.STAFFSURNAME }}  
                </h3>   
                <router-link to="/" class="w-full flex align-items-center py-5 border-300 border-bottom-1"> 
                    <span class="flex justify-content-center align-items-center border-round" 
                        style="height: 3.5rem; width: 3.5rem; background-color: #299ea3;">
                        <i class="text-50 pi pi-fw pi-id-card text-2xl"></i>
                    </span> 
                    <span class="ml-4 flex flex-column" style="flex: 1;">
                        <span class="text-900 lg:text-xl font-medium mb-0 block">สังกัด</span>
                        <span class="text-600 lg:text-xl">{{ user.user?.name.SCOPES?.staffdepartmentname }} </span>
                    </span>  

                    <span class="flex justify-content-center align-items-center border-round" 
                        style="height: 3.5rem; width: 3.5rem; background-color: #299ea3;">
                        <i class="text-50 pi pi-fw pi-star text-2xl"></i>
                    </span> 
                    <span class="ml-4 flex flex-column" style="flex: 1;">
                        <span class="text-900 lg:text-xl font-medium mb-0 block">ตำแหน่ง</span>
                        <span class="text-600 lg:text-xl">{{ user.user?.name.POSITIONNAME ?? '' }}</span>
                    </span>
                </router-link>
                <router-link to="/" class="w-full flex align-items-center py-5 border-300 border-bottom-1"> 
                    <span class="flex justify-content-center align-items-center border-round" 
                        style="height: 3.5rem; width: 3.5rem; background-color: #299ea3;">
                        <i class="text-50 pi pi-fw pi-briefcase text-2xl"></i>
                    </span> 
                    <span class="ml-4 flex flex-column" style="flex: 1;">
                        <span class="text-900 lg:text-xl font-medium mb-0 block">ระดับตำแหน่ง</span>
                        <span class="text-600 lg:text-xl">{{ user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME }}</span>
                    </span>  

                    <span class="flex justify-content-center align-items-center border-round" 
                        style="height: 3.5rem; width: 3.5rem; background-color: #299ea3;">
                        <i class="text-50 pi pi-fw pi-users text-2xl"></i>
                    </span> 
                    <span class="ml-4 flex flex-column" style="flex: 1;">
                        <span class="text-900 lg:text-xl font-medium mb-0 block">ประเภทบุคลากร</span>
                        <span class="text-600 lg:text-xl">{{ user.user?.name.GROUPTYPENAME }} </span>
                    </span>
                </router-link>
            </div> 
        </div> 
    </div>
    
    <!-- Content for guests (not logged in) -->
    <div v-else class="flex flex-column align-items-center justify-content-center" style="width: 100%; max-width: 1200px;"> 
        <div style="border-radius: 56px; padding: 0.3rem; background: linear-gradient(180deg, rgba(33, 150, 243, 0.5) 40%, rgba(33, 150, 243, 0) 60%);width: 70%;">  
            <div class="w-full surface-card py-6 px-5 sm:px-8 flex flex-column align-items-center" style="border-radius: 53px;">
                <span class="text-blue-500 font-bold text-3xl">ระบบประเมินผลการปฏิบัติงาน</span> 
                <div class="mb-3 mt-5">
                    <i class="pi pi-user text-blue-500" style="font-size: 6rem;"></i>
                </div>   
                <h3 class="text-900 font-bold text-2xl mb-2">ยินดีต้อนรับ</h3>
                <p class="text-600 text-center mb-4">กรุณาเข้าสู่ระบบเพื่อใช้งานระบบประเมินผลการปฏิบัติงาน</p>
                <Button 
                    @click="signIn('erpauth')" 
                    label="เข้าสู่ระบบด้วย รหัส สลีปเงินเดือน" 
                    icon="pi pi-sign-in" 
                    class="p-button-lg"
                    style="background: linear-gradient(90deg, #2196F3, #21CBF3); border: none;"
                />
            </div> 
        </div> 
    </div> 
</template>

<script setup> 
    definePageMeta({
        auth: false
    });
    
    const { status, data: sessionData } = useAuthState();
    const { signIn } = useAuth();
    
    // รอให้ session โหลดเสร็จก่อนแสดงผล
    const user = computed(() => sessionData.value || {});
    console.log(sessionData);
    
    
    // Profile image URL
    const profileImageUrl = 'https://pd.msu.ac.th/staff/picture/';
</script> 
                            
    <style scoped>
             body {
                font-family: 'Prompt', sans-serif;
                background-color: #f4f4f9;
                color: #333;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                height: 130vh;
                margin: 0;
                padding: 20px;
                 }
                            
            .container {
                display: flex;
                flex-direction: column;
                align-items: center;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                max-width: 1200px;
                width: 100%;
                margin-top: 20px;
                        }
                            
            .profile {
                width: 100%;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                text-align: center;
                    }
                            
            .profile img {
                width: 150px;
                height: 150px;
                display: block;
                margin: 0 auto 10px;
                border-radius: 50%;
                border: 1px solid #999;
                        }
                            
            .profile .details {
                text-align: center;
                background-color: #fcff57;
                padding: 10px;
                border-radius: 5px;
                            }
                            
            .profile .details p {
                margin: 5px 0;
                font-weight: 600;
                            }
                            
            .profile p {
                 margin: 10px 0;
                font-weight: 300;
                color: #666;
                        }
                            
            .main-content {
                width: 100%;
                padding: 20px;
                         }
                            
            .note-section,
            .table-section {
                margin-bottom: 20px;
                            }
                            
            .note-section {
                border: 2px solid #000;
                padding: 20px;
                position: relative;
                background-color: #fff;
                border-radius: 8px;
                        }
                            
            .note-section p {
                margin: 0;
                            }
                            
            .note-section .title {
                position: absolute;
                top: -20px;
                left: 20px;
                background-color: #fff;
                padding: 0 10px;
                font-weight: bold;
                color: red;
                            }
                            
            .table-section p {
                font-weight: 600;
                            }
                            
            .table-section table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
                            }
                            
            .table-section table,
            .table-section th,
            .table-section td {
                border: 1px solid #000;
                            }
                            
            .table-section th,
            .table-section td {
                padding: 10px;
                text-align: center;
                font-weight: 300;
                            }
                            
            .table-section th {
                background-color: #c2f094;
                color: black;
                            }
                            
            .instructions {
                color: red;
                font-weight: bold;
                        }
            body {
                font-family: 'Prompt', sans-serif;
                background-color: #f4f4f9;
                color: #333;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                }

            .container {
                width: 100%;
                max-width: 1200px;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                margin-top: 20px;
                        }

            .link-button {
                display: block;
                text-align: center;
                color: #28a745;
                text-decoration: underline;
                cursor: pointer;
                margin-bottom: 20px;
                        }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                }

            th, td {
                border: 1px solid #ccc;
                text-align: center;
                padding: 12px;
                }

            th {
                background-color: #333;
                color: white;
                font-weight: 600;
                }

            td {
                background-color: #f9f9f9;
                }

            tbody tr:nth-child(odd) td {
                background-color: #f1f1f1;
                }
            tbody tr:hover td {
                background-color: #f5f5f5;
                }
    </style> 