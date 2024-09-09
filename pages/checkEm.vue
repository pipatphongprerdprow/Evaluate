<template>    
    <div class="justify-content-center min-h-screen ">
        <div class="flex flex-column align-items-center justify-content-center"> 
            <div style="border-radius: 56px; padding: 0.3rem; background: linear-gradient(180deg, rgba(33, 150, 243, 0.4) 10%, rgba(33, 150, 243, 0) 30%)">  
                <div v-if="ShowQrcodeStream" class="w-full surface-card py-8 px-5 sm:px-8 flex flex-column align-items-center" style="border-radius: 53px">
                    <span class="text-blue-500 font-bold text-3xl">สแกน QR-Code</span> 
                    <div class="text-600 mb-5">สแกน QR-Code หมายเลขครุภัณฑ์ เพื่อตรวจสอบข้อมูล</div>
                    <div class="grid">
                        <div class="col-12 md:col-12">
                            <span class="p-3 shadow-2 mb-3 inline-block surface-card" style="border-radius: 10px">
                                <i class="pi pi-qrcode" style="font-size: 250px;cursor: pointer;" @click="OpenQRcode" ></i>
                            </span> 
                        </div> 
                    </div> 
                    <InputGroup>  
                        <InputText type="text" placeholder="ค้นหาพัสดุจาก ชื่อ - หมายเลขครุภัณฑ์" autocomplete="off" /> 
                        <Button icon="pi pi-search" label="ค้นหา" severity="warning" />
                    </InputGroup> 
                </div>
                <div v-if="ShowQrcodeStreamScan" class="w-full surface-card py-8 px-5 sm:px-8 flex flex-column align-items-center" style="border-radius: 53px"> 
                    <span class="text-blue-500 font-bold text-3xl">สแกน QR-Code</span> 
                    <div class="text-600 mb-5">สแกน QR-Code หมายเลขครุภัณฑ์ เพื่อตรวจสอบข้อมูล</div> 
                    <qrcode-stream @decode="onDecode"></qrcode-stream>
                    <br>
                    <Button icon="pi pi-qrcode" severity="danger" label="ยกเลิกการสแกน" @click="closeScanQrcode" />
                </div>
            </div> 
        </div>
    </div> 
</template>

<script>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import Swal from 'sweetalert2'  
import { QrcodeStream  } from 'vue-qrcode-reader'
export default {  
    components: { 
        QrcodeStream
    },
    data() {
        return {
            title: "ตรวจสอบครุภัณฑ์", 
            searchData: null,
            staff_id: 5008886,
            facid: 201092704000,
            groupid: '01',  
            // Qr Code
            ShowQrcodeStream: true,
            ShowQrcodeStreamScan: false,
            scanQr: false,
        }
    },
    mounted() {
        
    },
    methods: {
        OpenQRcode(){  
            this.ShowQrcodeStream = false; 
            this.ShowQrcodeStreamScan = true; 
            this.scanQr = true; 
        }, 
        closeScanQrcode(){  
            this.ShowQrcodeStream = true; 
            this.ShowQrcodeStreamScan = false; 
            this.scanQr = false; 
        },
        onDecode(decodedString){ 
            this.scanQr = false;
            console.log(decodedString);
        },
    },
    
}
</script>

<style scoped> 
    label{
        font-size: medium;
        font-weight: 500;
    }

</style>