<template> 
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <h3 class="mb-4"><i class="pi pi-sliders-v" style="font-size: x-large;"></i> จัดการด้านการประเมิน </h3>   
                <div class="formgroup-inline mb-1">
                    <div class="col md:col-6"> 
                        <FloatLabel>
                            <InputText type="text" id="search" v-model="searchData" class="col-10" autocomplete="off"/>
                            <label for="search">ค้นหา</label> 
                        </FloatLabel>
                    </div> 
                    
                    <div class="col md:col-6 text-right">  
                        <Button icon="pi pi-plus" severity="info" class="mb-2 mr-2" label="เพิ่มข้อมูล" @click="OpenDialogAdd" />
                        <Dialog header="การจัดการด้านประเมิน" v-model:visible="DialogAdd" :breakpoints="{ '960px': '75vw' }" :style="{ width: '60vw' }" :modal="true"> 
                            <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-2">
                                    <label for="No_ass">ข้อ / ลำดับ</label>
                                    <InputText v-model="No_ass" type="number" />
                                </div>
                            </div>
                            <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-12">
                                    <label for="Name_ass">ชื่อกิจกรรม/โครงการ</label> 
                                    <Textarea v-model="Name_ass" rows="3"></Textarea>
                                </div>  
                            </div>
                            <label for="Name_ass">ตัวชี้วัด/เกณฑ์การประเมิน</label> 
                            <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-1">
                                    <label for="firstname2">ข้อที่ 1</label> 
                                    <InputText v-model="No1" type="text" />
                                </div>
                                <div class="field col-12 md:col-11"> 
                                    <InputText id="lastname2" type="text" />
                                </div>
                                <div class="field col-12 md:col-1">
                                    <label for="firstname2">ข้อที่ 2</label> 
                                    <InputText v-model="No2" type="text" />
                                </div>
                                <div class="field col-12 md:col-11"> 
                                    <InputText id="lastname2" type="text" />
                                </div>
                                <div class="field col-12 md:col-1">
                                    <label for="firstname2">ข้อที่ 3</label>
                                    <InputText v-model="No3" type="text" /> 
                                </div>
                                <div class="field col-12 md:col-11"> 
                                    <InputText id="lastname2" type="text" />
                                </div>
                                <div class="field col-12 md:col-1">
                                    <label for="firstname2">ข้อที่ 4</label>
                                    <InputText v-model="No4" type="text" /> 
                                </div>
                                <div class="field col-12 md:col-11"> 
                                    <InputText id="lastname2" type="text" />
                                </div>
                                <div class="field col-12 md:col-1">
                                    <label for="firstname2">ข้อที่ 5</label>
                                    <InputText v-model="No5" type="text" /> 
                                </div>
                                <div class="field col-12 md:col-11"> 
                                    <InputText id="lastname2" type="text" />
                                </div>
                                 
                            </div> 
                            <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-2">
                                    <label for="No_ass">น้ำหนัก</label>
                                    <InputText v-model="No_ass" type="number" />
                                </div>
                            </div>
                            <!-- <div class="p-fluid formgrid grid">
                                <div class="field col-12 md:col-12">
                                    <label for="Name_ass">ตัวชี้วัด/เกณฑ์การประเมิน</label>
                                    <InputText v-model="Name_ass1" type="text" placeholder="แบบที่ 1" />
                                    <InputText v-model="Name_ass2" type="text" placeholder="แบบที่ 2" />
                                    <InputText v-model="Name_ass3" type="text" placeholder="แบบที่ 3" />
                                    <InputText v-model="Name_ass4" type="text" placeholder="แบบที่ 4" />
                                    <InputText v-model="Name_ass5" type="text" placeholder="แบบที่ 5" />
                                </div> 
                                <div class="mb-1">
                                    <label for="Name_ass" style="padding-right: 50px;">ระดับค่าเป้าหมาย</label>
                                    <p for="Name_ass">1<input type="radio" value="1" v-model="Name_ass6" ></p>
                                    <p for="Name_ass">2<input type="radio" value="2" v-model="Name_ass7" ></p>
                                    <p for="Name_ass">3<input type="radio" value="3" v-model="Name_ass8" ></p>
                                    <p for="Name_ass">4<input type="radio" value="4" v-model="Name_ass9" ></p>
                                    <p for="Name_ass">5<input type="radio" value="5" v-model="Name_ass10" ></p>
                                </div>
                                <div class="field col-12 md:col-2">
                                    <label for="No_ass">ค่าคะแนนที่ได้</label>
                                    <InputText v-model="No_ass11" type="number" />
                                </div>
                                <div class="field col-12 md:col-4">
                                    <label for="No_ass">น้ำหนัก(ความสำคัญ/ความยากง่ายของงาน)</label>
                                    <InputText v-model="No_ass12" type="number"  placeholder="%"/>
                                </div>
                                <div class="field col-12 md:col-4">
                                    <label for="No_ass">ค่าคะแนนถ่วงน้ำหนัก</label>
                                    <InputText v-model="No_ass13" type="number" />
                                </div>
                            </div> -->
                            <template #footer>
                                <Button label="บันทึก" icon="pi pi-check" severity="success" @click="saveData" />
                                <Button label="ยกเลิก" icon="pi pi-times" severity="danger" @click="OpenDialogAdd" />
                            </template>
                        </Dialog>
                    </div>
                </div>  
                <DataTable :value="products" :rows="10" :paginator="true" responsiveLayout="scroll" dataKey="id">  
                    <Column header="กิจกรรม/โครงการ/งาน" style="width: 18%" :sortable="true">
                        <template #body="Item">
                           
                        </template>
                        
                    </Column>
                    <Column header="ตัวชี้วัด/เกณฑ์การประเมิน" style="width: 30%" :sortable="true">
                        <template #body="Item"> 
                            
                        </template>
                    </Column>
                    <Column header="ระดับค้าเป้าหมาย" style="width: 10%" :sortable="true">
                        <template #body="Item"> 
                            
                        </template>
                    </Column> 
                    <Column header="ค่าคะแนนที่ได้" style="width: 5%" :sortable="true">
                        <template #body="Item"> 
                            
                        </template>
                    </Column> 
                    <Column header="น้ำหนัก(ความสำคัญ/ความยากง่ายของงาน)" style="width: 50%" :sortable="true">
                        <template #body="Item"> 
                            
                        </template>
                    </Column>
                    <Column header="ค่าคะแนนถ่วงน้ำหนัก" style="width: 20%">
                        <template #body="Item">  
                            <Button label="แก้ไข" severity="success" icon="pi pi-pencil" class="p-button-text"></Button>
                            <Button label="ลบ" severity="danger" icon="pi pi-trash" class="p-button-text"></Button>
                        </template>
                    </Column> 
                </DataTable>
            </div> 
        </div> 
    </div> 
  </template>
   
<script>  
export default {
    data() {
        return { 
            searchData: null,
            staff_id: 5001234,
            products: [ 
                { id: 1, name: 'Product 1', unit: 'pcs', check: 'No', options: 'Option 1' }, 
                { id: 2, name: 'Product 2', unit: 'pcs', check: 'No', options: 'Option 2' }, 
                { id: 3, name: 'Product 3', unit: 'pcs', check: 'No', options: 'Option 3' }, 
                { id: 4, name: 'Product 4', unit: 'pcs', check: 'No', options: 'Option 4' }, 
                { id: 5, name: 'Product 5', unit: 'pcs', check: 'No', options: 'Option 5' }, 
            ],
            DialogAdd: false,  
            No_ass: null,
            Name_ass: null,
            xx1: null,
            No1: "1"
            
        }
    },
    mounted(){
       this.xx();
    },
    methods: {   
        OpenDialogAdd(){
            this.DialogAdd = !this.DialogAdd;
        }, 
        saveData(){
            console.log({
                No_ass: this.No_ass,
                Name_ass: this.Name_ass
            });
            
        },
        async xx(){
            const { data } = await useFetch('/api/test');
            console.log(data);
            this.xx1 = data;
        },
        async mounted() {
            const  { signIn, getSession, signOut } = await useAuth()
            const user = await getSession();
        },
    }
}
</script>
  
<style>
.text-center {
  text-align: center;
}

</style>