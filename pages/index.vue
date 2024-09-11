<template>
    <div class="container">
        <div class="profile">
            <img id="IMG_PICTURE" :src="pImage" alt="Profile Picture" />
            <div class="details">
            <p><span>ชื่อ:</span> {{ profile.name }}</p>
            <p><span>ตำแหน่ง:</span> {{ profile.position }}</p>
            <p><span>ระดับตำแหน่ง:</span> {{ profile.level }}</p>
            <p><span>คุณวุฒิ:</span> {{ profile.qualification }}</p>
            <p><span>ประเภทบุคลากร:</span> {{ profile.staffType }}</p>
            <p><span>สังกัด:</span> {{ profile.department }}</p>
            </div>
        </div>
        <div class="main-content">
            <div class="note-section">
                <p class="title">งานที่ได้รับมอบหมาย (ล่าสุด)</p>
                <p>{{ assignments }}</p>
            </div>
            <br />
            <div class="note-section">
                <p class="title">การประชุม/ฝึกอบรม/สัมมนา/ศึกษาดูงาน (ล่าสุด)</p>
                <p>{{ meetings }}</p>
            </div>
            <div class="table-section">
                <p>สรุปภาระงานประจำปี</p>
                <table>
                    <thead>
                    <tr>
                        <th>ลำดับ</th>
                        <th>รายละเอียดงานปฏิบัติงาน</th>
                        <th>ภาระงานที่ได้</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr v-for="(task, index) in tasks" :key="index">
                        <td>{{ index + 1 }}</td>
                        <td>{{ task.description }}</td>
                        <td>{{ task.workload }}</td>
                    </tr>
                    <tr>
                        <td colspan="2">รวมภาระงานเทียบ/ปี</td>
                        <td>{{ totalWorkload }}</td>
                    </tr> 
                    </tbody>
                </table>
            </div>
            <div class="container">
                <!-- <router-link class="link-button" to="setting/home">
                    เพิ่มแบบข้อตกลงภาระงานและพฤติกรรมการปฎิบัติราชการ (Term of Reference : TOR)
                    </router-link> -->
                    <table>
                        <thead>
                            <tr>
                                <th>ประจำปี</th>
                                <th>รอบประเมิน</th>
                                <th>สัดส่วนคะแนน</th>
                                <th>ผู้ประเมิน</th>
                                <th>รายละเอียด</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                             <tr>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td><Button label="ลบ" severity="danger" icon="pi pi-trash" class="p-button-text" @click="deleteData(slotProps.data)" /></td>
                             </tr>
                        </tbody>
                    </table>
                 </div>
            </div>
        </div>
</template>

<script setup>
    import pImage from '~/assets/layout/images/pipatphong.jpg'
</script>
                            
 <script>
     import profileImage from '@/public/layout/images/pipatphong.jpg';                   
    export default {
        data() {
            return {
                profileImageUrl:"@/assets/layout/images/pipatphong.jpg",
                profile: {
                name: 'ชื่อ',
                position: 'ตำแหน่ง',
                level: 'ระดับตำแหน่ง',
                qualification: 'คุณวุฒิ',
                staffType: 'ประเภทบุคลากร',
                department: 'สังกัด',
                 },
                assignments: 'ไม่มีรายการ',
                meetings: 'ไม่มีรายการ',
                tasks: [
                { description: 'งานที่ต้องศึกษาวิเคราะห์', workload: '' },
                { description: 'งานที่ต้องตรวจสอบ', workload: '' },
                { description: 'งานพัฒนาตนเอง', workload: '' },
                { description: 'ภาระงานอื่นๆ', workload: '' },
                        ],
                    };
                 },
                computed: {
                totalWorkload() {
                 // การคำนวณรวมภาระงานที่นี่
                    return this.tasks.reduce((total, task) => total + (parseFloat(task.workload) || 0), 0);
                        },
                    },
                };
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