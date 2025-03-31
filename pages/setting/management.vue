<template>
    <div class="grid">
        <div class="col-12 lg:col-12 xl:col-12">
            <div class="card mb-0">
                <h3 class="mb-4"><i class="pi pi-fw pi-user" style="font-size: x-large;"></i> การจัดการภายใน</h3> 
                <div class="p-fluid formgrid grid">
                    <div class="field col-12 md:col-8">
                        <label for="evaluator">ผู้ประเมินประจำหน่วยงาน</label>
                        <InputGroup>
                            <InputGroupAddon>
                                <i class="pi pi-user"></i>
                            </InputGroupAddon> 
                            <InputText v-model="evaluator" type="text" placeholder="ผู้ตรวจสอบ" autocomplete="off" @input="Searchuser" />  
                            <InputText v-model="evaluator_val" type="text" />  
                        </InputGroup> 
                        <span v-show="show_evaluator">
                            <ul id="country-list">
                                <li v-for="(li) in userevaluator" :key="li.staffid" @click="nameUserclick(li)">{{li.staffid}} : {{li.fullname}}</li> 
                            </ul>
                        </span>
                    </div> 
                    <div class="field col-12 md:col-4" style="align-content: end;"> 
                        <Button label="บันทึก" icon="pi pi-save" severity="success" @click="SaveData" />
                    </div> 
                </div>  
            </div>
        </div> 
    </div>
  </template>
  
<script>
import axios from 'axios'  
export default {
  data() {
    return {
      fac: '2010927050000', //คณะ
      staffid: '5008668', //ผู้ใช้งาน
      evaluator: null, // ชื่อ
      evaluator_val: null, //รหัสประจำตัว
      show_evaluator: false, //โชว์
      userevaluator: [] //ลูปชื่อ
    };
  },
  mounted(){
    this.showData();
  },
  methods: {
    async showData(){    
        await axios.post('  http://127.0.0.1:8000/api/showUserManag',{
            fac: this.fac
        }).then(res => { 
            // console.log(res.data);
            this.evaluator = res.data[0].staffname
            this.evaluator_val = res.data[0].staffid
        })
        .catch(error => {
            console.error('Error:', error);
        }); 
    }, 
    async Searchuser(event){   
        // console.log(event.target.value.length);
        if(event.target.value.length==0){
            this.show_evaluator = false; 
        }else{
            this.show_evaluator = true; 
            await axios.post('  http://127.0.0.1:8000/api/searchUser',{
                evaluator: this.evaluator
            }).then(res => { 
                this.userevaluator=res.data
            })
            .catch(error => {
                console.error('Error:', error);
            });
        } 
    }, 
    async nameUserclick(data){ 
        // console.log(data);
        this.show_evaluator = false;   
        this.evaluator = data.fullname 
        this.evaluator_val = data.staffid
    },
    async SaveData(){
        await axios.post('  http://127.0.0.1:8000/api/saveDataManag',{
            evaluator: this.evaluator,
            evaluator_val: this.evaluator_val,
            staffid: this.staffid,
            fac: this.fac
        }).then(res => {
          console.log(res.data);
        }).catch(error => {
          console.error('Error:' ,error);
        }); 
    },
  }
};
</script>

  
<style>
    /* เพิ่มสไตล์ที่จำเป็นได้ที่นี่ */
    .p-toast-message {
        font-size: 1.7rem; /* ตั้งค่าขนาดฟอนต์ให้ใหญ่ขึ้น */
    }
 
    #country-list{
        /* float:left; */
        list-style:none;
        margin-top:-3px;
        padding:0;
        width:100%;
        /*width:190px;*/
        /* position: absolute;  */
        /* z-index:9999 !important; */
    }

	#country-list li{
        padding: 10px; 
        background: #f0f0f0; 
        border-bottom: #bbb9b9 1px solid;
    }

	#country-list li:hover{
        background:#ece3d2;
        cursor: pointer;
    } 
</style> 

