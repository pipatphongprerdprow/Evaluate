<template>
    <div class="col md:col-12 text-right">
            <!-- <Button label="Export" icon="pi pi-file-word" class="mr-2 mb-2 " @click="printDataP04"></Button> -->
            <Button label="Export" icon="pi pi-file-pdf" class="mr-2 mb-2 " @click="printDataP04X"></Button>
        </div> 
    <div v-if="user.user" class="card">
        <h4 style="text-align: left">แบบสรุปการประเมินผล</h4>
            <div class="p-fluid formgrid grid"> 
                <div class="card">                 
                    <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</h5>  
                    <!-- ตาราง ก. สมรรถนะหลัก -->
                    <div class="employee-info">   
                        <!-- <p v-if="dataPor"><strong>รอบการประเมิน:</strong> {{dataPor.d_evaluationround}} {{ dataPor.d_date }} </p> -->
                         <p><strong>รอบการประเมิน:</strong> {{ evaluationPeriodText }}</p>
                        <p><strong>ชื่อผู้รับการประเมิน:</strong> {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }} </p>
                        <p><strong>ตำแหน่ง:</strong> {{ user.user.name.POSITIONNAME }} </p>
                        <!-- <p><strong>ระดับตำแหน่ง:</strong>{{ user.user.name.POSTYPENAME }} </p> -->
                         <!-- <p><strong>ระดับตำแหน่ง:</strong>{{ user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME }}</p> -->
                         <p><strong>ระดับตำแหน่ง:</strong> {{ [160018, '', ''].includes(user.user?.name.STAFFID) ? 'ผู้อำนวยการกอง' : (user.user?.name.POSITIONNAME === 'ผู้บริหาร' ? 'ชำนาญการพิเศษ' : user.user?.name.POSTYPENAME) }}</p> 
                        <p><strong>สังกัด:</strong> {{ user.user.name.SCOPES?.staffdepartmentname }} </p>
                        <p><strong>ชื่อผู้ประเมิน:</strong> {{ assessorText }}</p> 
                    </div><br>
                    <div class="employee-info" style="border: groove;padding: 15px;">
                        <h4>คำชี้แจง</h4>
                        <h5>แบบสรุปการประเมินผลการปฏิบัติราชการนี้มีด้วยกัน 5 ส่วน ดังนี้</h5>
                        <p><strong>ส่วนที่ 1 ข้อมูลของผู้รับการประเมิน</strong> เพื่อระบุรายละเอียดต่างๆ ที่เกี่ยวข้องกับตัวผู้รับการประเมิน</p>
                        <p> <strong>ส่วนที่ 2 การสรุปผลการประเมิน</strong> ใช้เพื่อกรอกค่าคะแนนการประเมินในองค์ประกอบด้านผลสัมฤทธิ์ของงาน 
                            องค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ และน้ำหนักของทั้งสององค์ประกอบในแบบสรุปส่วนที่ 2 นี้ ยังใช้สำหรับคำนวณคะแนนผลการปฏิบัติราชการรวมด้วย<br>
                            - สำหรับคะแนนองค์ประกอบด้านผลสัมฤทธิ์ของงาน ให้นำมาจากแบบประเมินผลสัมฤทธิ์ของงาน โดยให้แนบท้ายแบบสรุปฉบับนี้<br>
                            - สำหรับคะแนนองค์ประกอบด้านพฤติกรรมการปฏิบัติราชการ ให้นำมาจากแบบประเมิน สมรรถนะโดยให้แนบท้ายแบบสรุปฉบับนี้</p>
                        <p><strong>ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</strong> ผู้ประเมินและผู้รับการประเมินร่วมกันจัดทำแผนพัฒนา ผลการปฏิบัติราชการ</p>
                        <p><strong>ส่วนที่ 4 การรับทราบผลการประเมิน</strong> ผู้รับการประเมินลงนามรับทราบผลการประเมิน</p>
                        <p><strong>ส่วนที่ 5 ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป</strong> ผู้บังคับบัญชาเหนือขึ้นไปกลั่นกรองผลการประเมิน แผนพัฒนาผลการปฏิบัติราชการ และให้ความเห็น</p>
                    </div>                                                       
                    <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 2 ข้อมูลของผู้รับการประเมิน</h5>
                    <table border="1" cellspacing="0" cellpadding="5">
                        <thead>
                            <tr style="background-color: #F4B366;">
                                <th rowspan="2">องค์ประกอบการประเมิน</th>
                                <th rowspan="2">ค่าคะแนนที่ได้หลังถ่วงน้ำหนัก (ก)</th>
                                <th rowspan="2">สัดส่วนคะแนน (ข)</th>
                                <th rowspan="2">สรุปคะแนน (ก) X (ข)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr> 
                                <td>องค์ประกอบที่ 1 ผลสัมฤทธิ์ของงาน</td>
                                <td class="text-center" style="color: blue;">  
                                    <div v-if="currentDate >= dataPor.d_scoringday">
                                        <b> {{ showscoresum.achievement_score  }}</b>
                                   </div>
                                </td>  
                                <td class="text-center" style="color: blue;">  
                                    <b v-if="showscoresum.persen">{{showscoresum.persen.split(':')[0]}}</b> 
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                    <div v-if="currentDate >= dataPor.d_scoringday">
                                        <b v-if="showscoresum.persen">{{ ((showscoresum.achievement_score )*showscoresum.persen.split(':')[0]).toFixed(2) }} </b> 
                                   </div> 
                                </td> 
                            </tr>
                            <tr>
                                <td>องค์ประกอบที่ 2 พฤติกรรมการปฏิบัติราชการ</td>
                                <td class="text-center" style="color: blue;"> 
                                    <div v-if="currentDate >= dataPor.d_scoringday">
                                        <b>{{ showscoresum.behavior  }}</b>
                                     </div>
                                </td> 
                                <td class="text-center" style="color: blue;">  
                                    <b v-if="showscoresum.persen">{{showscoresum.persen.split(':')[1]}}</b> 
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                    <div v-if="currentDate >= dataPor.d_scoringday"> 
                                        <b v-if="showscoresum.persen">{{ ((showscoresum.behavior )*showscoresum.persen.split(':')[1]).toFixed(2) }} </b> 
                                    </div>
                                </td> 
                            </tr>
                            <tr>
                                <td>องค์ประกอบอื่นๆ (ถ้ามี)</td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr style="font-weight: bold;">
                                <td colspan="2" style="text-align: right;">รวม</td>
                                <td class="text-center" style="color: blue;">  
                                        <b>{{ 100 }}%</b>   
                                </td> 
                                <td class="text-center" style="color: blue;"> 
                                    <div v-if="currentDate >= dataPor.d_scoringday">
                                        {{ showscoresum.sum_score }} 
                                        <!-- {{ Item.tb_tor?Item.tb_tor.sum_score:'' }} -->
                                         
                                     </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br>
                    <div class="employee-info">
                        <h4>ระดับผลการประเมินที่ได้</h4>
                        <p><strong>[&nbsp;&nbsp; 
                            <b v-if="new Date(currentDate) >= new Date(dataPor.d_scoringday) && (showscoresum.sum_score) >= 90">&#10003;</b> 
                            &nbsp;&nbsp;] ดีเด่น (90-100)</strong></p> 
                        <p><strong>[&nbsp;&nbsp; 
                            <b v-if="new Date(currentDate) >= new Date(dataPor.d_scoringday) && (showscoresum.sum_score) >= 80 && (showscoresum.sum_score) < 90">&#10003;</b> 
                            &nbsp;&nbsp;] ดีมาก (80-89)</strong></p> 
                        <p><strong>[&nbsp;&nbsp; 
                            <b v-if="new Date(currentDate) >= new Date(dataPor.d_scoringday) && (showscoresum.sum_score) >= 70 && (showscoresum.sum_score) < 80">&#10003;</b> 
                            &nbsp;&nbsp;] ดี (70-79)</strong></p> 
                        <p><strong>[&nbsp;&nbsp; 
                            <b v-if="new Date(currentDate) >= new Date(dataPor.d_scoringday) && (showscoresum.sum_score) >= 60 && (showscoresum.sum_score) < 70">&#10003;</b> 
                            &nbsp;&nbsp;] พอใช้ (60-69)</strong></p>  
                        <p><strong>[&nbsp;&nbsp; 
                            <b v-if="new Date(currentDate) >= new Date(dataPor.d_scoringday) && (showscoresum.sum_score) < 60">&#10003;</b> 
                            &nbsp;&nbsp;] ต้องปรับปรุง (ต่ำกว่า 60)</strong></p>
                    </div> 
                    
                    <h5 class="mb-4"><i class="" style="font-size: x-large;"></i> ส่วนที่ 3 แผนพัฒนาการปฏิบัติราชการรายบุคคล</h5>
                    <table border="1" cellspacing="0" cellpadding="5">
                        <thead>
                            <tr style="text-align: center;">
                                <th>ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา</th>
                                <th>วิธีการพัฒนา</th>
                                <th>ช่วงเวลาที่ต้องการพัฒนา</th>
                                <th>ข้อเสนอแนะ(ผู้บริหาร)</th> 
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(Tab3T4, idx) in products_Tab3T4" :key="idx"  >
                                <td style="text-align: left;">{{ Tab3T4.p04_re1 }}</td>
                                <td style="text-align: left;">{{ Tab3T4.p04_re2 }}</td>
                                <td style="text-align: left;">{{ Tab3T4.p04_re3 }}</td>
                                <td style="text-align: left;">{{ Tab3T4.px04_re1 }}</td> 
                            </tr> 
                        </tbody>
                    </table> 

                    <h5 class="mb-4">
                        <i class="" style="font-size: x-large;"></i>
                        ส่วนที่ 4 การรับทราบผลการประเมิน
                    </h5>

                    <!-- ส่วนที่4 -->
                    <table class="styled-table sign-table">
                        <tbody>
                            <!-- ผู้รับการประเมิน : ลงนามได้ -->
                            <tr>
                                <td class="left-align">
                                    <b>ผู้รับการประเมิน</b><br>

                                    <label class="sign-check-line">
                                        <input
                                            type="checkbox"
                                            v-model="signForm.receiver_ack"
                                            :disabled="!!signatures.receiver_ack"
                                        />
                                        <span>ได้รับทราบผลการประเมินและแผนพัฒนาการปฏิบัติราชการ รายบุคคลแล้ว</span>
                                    </label>

                                   <div class="signature-button-wrap" v-if="!signatures.receiver_ack">
                                        <Button
                                            label="ลงนามผู้รับการประเมิน"
                                            icon="pi pi-pencil"
                                            severity="success"
                                            size="small"
                                            class="signature-btn"
                                            :disabled="!signForm.receiver_ack || !digitalSignature.usable"
                                            @click="savesignP04('receiver_ack', 'ผู้รับการประเมิน')"
                                        />
                                    </div>

                                    <small
                                        v-if="!digitalSignature.usable && !signatures.receiver_ack"
                                        class="sign-status-text waiting"
                                    >
                                        <i class="pi pi-clock"></i>
                                        ยังไม่มีลายเซ็นดิจิทัล กรุณาตั้งค่าลายเซ็นก่อนลงนาม
                                    </small> 
                                </td>

                                <td class="center-align">
                                    <div v-if="signatures.receiver_ack" class="signature-card signed">
                                        <div class="signed-badge">
                                            ลงนามแล้ว
                                        </div>

                                        <div class="signature-display-area">
                                            <img
                                                v-if="signatures.receiver_ack.signature_image"
                                                :src="signatures.receiver_ack.signature_image"
                                                class="signature-img"
                                            />

                                            <div v-else class="no-signature-image">
                                                ยังไม่มีไฟล์รูปลายเซ็น
                                            </div>
                                        </div>

                                        <div>ลงชื่อ {{ signatures.receiver_ack.signer_name }}</div>
                                        <div>ตำแหน่ง {{ signatures.receiver_ack.signer_position }}</div>
                                        <div>วันที่ {{ formatThaiDate(signatures.receiver_ack.signed_at) }}</div>

                                        <div class="signature-action-wrap">
                                            <Button
                                                label="อัพเดทลายเซ็น"
                                                icon="pi pi-refresh"
                                                severity="warning"
                                                size="small"
                                                class="signature-action-btn"
                                                :loading="updatingReceiverSignature"
                                                :disabled="!digitalSignature.usable"
                                                @click="updateReceiverAckSignatureFromDigital"
                                            />

                                            <Button
                                                label="ลบ"
                                                icon="pi pi-trash"
                                                severity="danger"
                                                size="small"
                                                class="signature-action-btn"
                                                @click="deletesignP04(signatures.receiver_ack)"
                                            />
                                        </div>
                                        <small class="sign-status-text waiting">
                                            หากเปลี่ยนลายเซ็นในหน้าตั้งค่าลายเซ็นดิจิทัลแล้ว กรุณากด “อัพเดทลายเซ็น”
                                        </small>

                                    </div> 
                                    <div v-else class="signature-card waiting">
                                        ลงชื่อ .................................................................<br>
                                        ชื่อ: {{ user.user.name.PREFIXFULLNAME }} {{ user.user.name.STAFFNAME }} {{ user.user.name.STAFFSURNAME }}<br>
                                        ตำแหน่ง: {{ user.user.name.POSITIONNAME }}<br>
                                        วันที่ .......... เดือน .......................... พ.ศ................
                                    </div>
                                </td>
                            </tr>

                            <!-- ผู้ประเมิน : อ่านอย่างเดียว ดึงจากอีกหน้า -->
                            <tr>
                                <td class="left-align readonly-section">
                                    <b>ผู้ประเมิน</b><br>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.evaluator_ack"
                                            disabled
                                        />
                                        <span>ได้แจ้งผลการประเมินและผู้รับการประเมินได้ลงนามรับทราบ รายบุคคลแล้ว</span>
                                    </label>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.evaluator_no_ack"
                                            disabled
                                        />
                                        <span>
                                            ได้แจ้งผลการประเมินแล้ว แต่ผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน
                                        </span>
                                    </label>

                                    <div
                                        v-if="signatures.evaluator_no_ack?.comment"
                                        class="readonly-disagree-comment"
                                    >
                                        <b>รายละเอียดเพิ่มเติม</b><br>
                                        {{ signatures.evaluator_no_ack.comment }}
                                    </div>

                                    <div
                                        v-if="signatures.evaluator_witness1 || signatures.evaluator_witness2"
                                        class="readonly-witness-box"
                                    >
                                        <div class="readonly-witness-title">
                                            พยานกรณีผู้รับการประเมินไม่ลงนามรับทราบผลการประเมิน
                                        </div>

                                        <div class="readonly-witness-grid">
                                            <div class="readonly-witness-card">
                                                <div class="readonly-witness-card-title">พยานคนที่ 1</div>

                                                <template v-if="signatures.evaluator_witness1">
                                                    <img
                                                        v-if="signatures.evaluator_witness1.signature_image"
                                                        :src="signatures.evaluator_witness1.signature_image"
                                                        class="readonly-witness-signature-img"
                                                    />

                                                    <div class="readonly-witness-detail">
                                                        ลงชื่อ {{ signatures.evaluator_witness1.signer_name || '-' }}<br>
                                                        ตำแหน่ง {{ signatures.evaluator_witness1.signer_position || '-' }}<br>
                                                        วันที่ {{ formatThaiDate(signatures.evaluator_witness1.signed_at) }}
                                                    </div>
                                                </template>

                                                <template v-else>
                                                    <div class="readonly-witness-waiting">ยังไม่มีข้อมูลพยานคนที่ 1</div>
                                                </template>
                                            </div>

                                            <div class="readonly-witness-card">
                                                <div class="readonly-witness-card-title">พยานคนที่ 2</div>

                                                <template v-if="signatures.evaluator_witness2">
                                                    <img
                                                        v-if="signatures.evaluator_witness2.signature_image"
                                                        :src="signatures.evaluator_witness2.signature_image"
                                                        class="readonly-witness-signature-img"
                                                    />

                                                    <div class="readonly-witness-detail">
                                                        ลงชื่อ {{ signatures.evaluator_witness2.signer_name || '-' }}<br>
                                                        ตำแหน่ง {{ signatures.evaluator_witness2.signer_position || '-' }}<br>
                                                        วันที่ {{ formatThaiDate(signatures.evaluator_witness2.signed_at) }}
                                                    </div>
                                                </template>

                                                <template v-else>
                                                    <div class="readonly-witness-waiting">ยังไม่มีข้อมูลพยานคนที่ 2</div>
                                                </template>
                                            </div>
                                        </div>
                                    </div>

                                    <small
                                        v-if="getSignature('evaluator_ack', 'evaluator_no_ack')"
                                        class="sign-status-text signed"
                                    >
                                        <i class="pi pi-check-circle"></i>
                                        ลงนามเรียบร้อยแล้ว
                                    </small>

                                    <small
                                        v-else
                                        class="sign-status-text waiting"
                                    >
                                        <i class="pi pi-clock"></i>
                                        * รอลงนาม
                                    </small>
                                </td>

                                <td class="center-align">
                                    <div v-if="getSignature('evaluator_ack', 'evaluator_no_ack')" class="signature-card signed">
                                        <div class="signed-badge">ลงนามแล้ว</div>

                                        <img
                                            v-if="getSignature('evaluator_ack', 'evaluator_no_ack')?.signature_image"
                                            :src="getSignature('evaluator_ack', 'evaluator_no_ack')?.signature_image"
                                            class="signature-img"
                                        />

                                        <div v-else class="typed-signature">
                                            {{ getSignature('evaluator_ack', 'evaluator_no_ack')?.signer_name }}
                                        </div>

                                        <div>ลงชื่อ {{ getSignature('evaluator_ack', 'evaluator_no_ack')?.signer_name }}</div>
                                        <div>ตำแหน่ง {{ getSignature('evaluator_ack', 'evaluator_no_ack')?.signer_position }}</div>
                                        <div>วันที่ {{ formatThaiDate(getSignature('evaluator_ack', 'evaluator_no_ack')?.signed_at) }}</div>
                                    </div>

                                    <div v-else class="signature-card waiting">
                                        <span style="color:#7f1d1d;font-weight:600;">
                                            รอการลงนามจากผู้ประเมิน
                                        </span> <br>
                                        ชื่อ {{ assessorText }}<br>
                                        ตำแหน่ง {{ assessor_positionText }}<br>
                                        วันที่ .......... เดือน .......................... พ.ศ...........
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- ส่วนที่5 -->
                    <h5 class="mb-4">
                        <i class="" style="font-size: x-large;"></i>
                        ส่วนที่ 5 ความเห็นของผู้บังคับบัญชาเหนือขึ้นไป
                    </h5>
                    <table class="styled-table sign-table">
                        <tbody>
                            <!-- ผู้บังคับบัญชาเหนือขึ้นไป : อ่านอย่างเดียว -->
                            <tr>
                                <td class="left-align readonly-section">
                                    <b>ผู้บังคับบัญชาเหนือขึ้นไป</b><br>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.superior_agree"
                                            disabled
                                        />
                                        <span>เห็นด้วยกับผลการประเมิน</span>
                                    </label>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.superior_disagree"
                                            disabled
                                        />
                                        <span>มีความเห็นต่าง ดังนี้</span>
                                    </label>

                                    <div
                                        v-if="signatures.superior_disagree?.comment"
                                        class="readonly-disagree-comment"
                                    >
                                        <b>ความเห็นต่าง</b><br>
                                        {{ signatures.superior_disagree.comment }}
                                    </div>

                                    <small
                                        v-if="getSignature('superior_agree', 'superior_disagree')"
                                        class="sign-status-text signed"
                                    >
                                        <i class="pi pi-check-circle"></i>
                                        ลงนามเรียบร้อยแล้ว
                                    </small>

                                    <small
                                        v-else
                                        class="sign-status-text waiting"
                                    >
                                        <i class="pi pi-clock"></i>
                                        * รอลงนาม
                                    </small>
                                </td>

                                <td class="center-align">
                                    <div v-if="getSignature('superior_agree', 'superior_disagree')" class="signature-card signed">
                                        <div class="signed-badge">ลงนามแล้ว</div>

                                        <img
                                            v-if="getSignature('superior_agree', 'superior_disagree')?.signature_image"
                                            :src="getSignature('superior_agree', 'superior_disagree')?.signature_image"
                                            class="signature-img"
                                        />

                                        <div v-else class="typed-signature">
                                            {{ getSignature('superior_agree', 'superior_disagree')?.signer_name }}
                                        </div>

                                        <div>ลงชื่อ {{ getSignature('superior_agree', 'superior_disagree')?.signer_name }}</div>
                                        <div>ตำแหน่ง {{ getSignature('superior_agree', 'superior_disagree')?.signer_position }}</div>
                                        <div>วันที่ {{ formatThaiDate(getSignature('superior_agree', 'superior_disagree')?.signed_at) }}</div>
                                    </div>

                                    <div v-else class="signature-card waiting">
                                         <span style="color:#7f1d1d;font-weight:600;"> 
                                        รอการลงนามจากผู้บังคับบัญชาเหนือขึ้นไป </span><br>
                                        ลงชื่อ .................................................................<br>
                                        ตำแหน่ง .................................................................<br>
                                        วันที่ .......... เดือน .......................... พ.ศ.............
                                    </div>    
                                </td>
                            </tr>

                            <!-- ผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง : อ่านอย่างเดียว -->
                            <tr>
                                <td class="left-align readonly-section">
                                    <b>ผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง (ถ้ามี)</b><br>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.superior2_agree"
                                            disabled
                                        />
                                        <span>เห็นด้วยกับผลการประเมิน</span>
                                    </label>

                                    <label class="sign-check-line readonly-check">
                                        <input
                                            type="checkbox"
                                            :checked="!!signatures.superior2_disagree"
                                            disabled
                                        />
                                        <span>มีความเห็นต่าง ดังนี้</span>
                                    </label>

                                    <div
                                        v-if="signatures.superior2_disagree?.comment"
                                        class="readonly-disagree-comment"
                                    >
                                        <b>ความเห็นต่าง</b><br>
                                        {{ signatures.superior2_disagree.comment }}
                                    </div>

                                     <small
                                        v-if="getSignature('superior2_agree', 'superior2_disagree')"
                                        class="sign-status-text signed"
                                    >
                                        <i class="pi pi-check-circle"></i>
                                        ลงนามเรียบร้อยแล้ว
                                    </small>

                                    <small
                                        v-else
                                        class="sign-status-text waiting"
                                    >
                                        <i class="pi pi-clock"></i>
                                        * รอลงนาม
                                    </small>  
                                </td>

                                <td class="center-align">
                                    <div v-if="getSignature('superior2_agree', 'superior2_disagree')" class="signature-card signed">
                                        <div class="signed-badge">ลงนามแล้ว</div>

                                        <img
                                            v-if="getSignature('superior2_agree', 'superior2_disagree')?.signature_image"
                                            :src="getSignature('superior2_agree', 'superior2_disagree')?.signature_image"
                                            class="signature-img"
                                        />

                                        <div v-else class="typed-signature">
                                            {{ getSignature('superior2_agree', 'superior2_disagree')?.signer_name }}
                                        </div>

                                        <div>ลงชื่อ {{ getSignature('superior2_agree', 'superior2_disagree')?.signer_name }}</div>
                                        <div>ตำแหน่ง {{ getSignature('superior2_agree', 'superior2_disagree')?.signer_position }}</div>
                                        <div>วันที่ {{ formatThaiDate(getSignature('superior2_agree', 'superior2_disagree')?.signed_at) }}</div>
                                    </div>

                                    <div v-else class="signature-card waiting">
                                        <span style="color:#7f1d1d;font-weight:600;"> 
                                            รอการลงนามจากผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง 
                                        </span><br>
                                        ลงชื่อ .................................................................<br>
                                        ตำแหน่ง .................................................................<br>
                                        วันที่ .......... เดือน .......................... พ.ศ...........
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table> 
                </div>
            </div>  
        </div>  
</template> 


<script setup> 
    const { signIn, getSession, signOut } = await useAuth()
    const user = await getSession();
    // console.log(user);
</script>
<script> 
import { ref } from 'vue';
import axios from 'axios';  
import Swal from 'sweetalert2' 
import TabView from 'primevue/tabview';
import TabPanel from 'primevue/tabpanel'; 
const API_BASE = 'http://127.0.0.1:8000/api';
export default {
    props: {
        dataPor: {
            type: Object,
            required: true
        }, 
        tab4Reload: {
            type: String,
            default: '0'
        } 
    },
    data() { 
        return {  
            staffid_po: 130102,
            staffid_Main: '',
            facid_Main: '',
            groupid_Main: '', 
            currentDate: new Date().toISOString().split('T')[0], 
            // Anurak
            assessorText: [],
            assessor_positionText: [],
            recordEvaluaText: '',
 
            // ปีงบประมาณ
            dropdownItemYear: { name: 'ปีงบประมาณ 2568', code: 2568 },
            dropdownItemsYear: [
                { name: 'ปีงบประมาณ 2569', code: 2569 },
                { name: 'ปีงบประมาณ 2568', code: 2568 },
                { name: 'ปีงบประมาณ 2567', code: 2567 },
                { name: 'ปีงบประมาณ 2566', code: 2566 },
                { name: 'ปีงบประมาณ 2565', code: 2565 },
            ],
            // รอบประเมิน
            dropdownItemRecord: { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            dropdownItemRecords: [
                { name: 'รอบที่ 1 วันที่ 1 กันยายน  ถึง วันที่ 28 กุมภาพันธ์', code: '1' },
                { name: 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', code: '2' },
            ], 
            tracking_date: '',
            tracking_dates: null, 
             
            // ตารางรายชื่อ
            products: [], 

            // เพิ่มคะแนนประเมิน 
            DialogAdd: false, 
            activeIndex: 0,
            dataStaffid: null,
            //Tab 1 
            products_Tab1: [], 
            p01_score: null,
            p01_scores: [
                { name: '- ไม่ระบุ -', code: 0 },
                { name: '1 คะแนน', code: 1 },
                { name: '2 คะแนน', code: 2 },
                { name: '3 คะแนน', code: 3 },
                { name: '4 คะแนน', code: 4 },
                { name: '5 คะแนน', code: 5 },
            ],
            p01_detail: null,
            //ตาราง ก. สมรรถนะหลัก
            coreCompetencies: [
                { id: 1, activity: 'ก. 1 การมุ่งผลสัมฤทธิ์', indicator: '1', data_table1: '' },
                { id: 2, activity: 'ก. 2 การบริการที่ดี', indicator: '1', data_table1: '' },
                { id: 3, activity: 'ก. 3 การสั่งสมความเชี่ยวชาญในงานอาชีพ', indicator: '1', data_table1: '' },
                { id: 4, activity: 'ก. 4 การยึดมั่นในความถูกต้องชอบธรรมและจริยธรรม', indicator: '1', data_table1: '' },
                { id: 5, activity: 'ก. 5 การทำงานเป็นทีม', indicator: '1', data_table1: '' }
            ],
            //ตาราง ข. สมรรถนะเฉพาะตามลักษณะงานที่ปฏิบัติ
            jobSpecificCompetencies: [
                { id: 6, activity: 'ข. 1 การคิดวิเคราะห์', indicator: '1', data_table2: '' },
                { id: 7, activity: 'ข. 2 การดำเนินการเชิงรุก', indicator: '1', data_table2: '' },
                { id: 8, activity: 'ข. 3 ความผูกพันที่มีต่อส่วนราชการ', indicator: '1', data_table2: '' },
                { id: 9, activity: 'ข. 4 การมองภาพองค์รวม', indicator: '1', data_table2: '' },
                { id: 10, activity: 'ข. 5 การสืบเสาะหาข้อมูล', indicator: '1', data_table2: '' },
                { id: 11, activity: 'ข. 6 การตรวจสอบความถูกต้องตามกระบวนงาน', indicator: '1', data_table2: '' }
            ],
            //ตาราง ค. สมรรถนะอื่นๆ
            otherCompetencies: [
                { id: 12, activity: 'ค. 1 สภาวะผู้นำ', indicator: '0', data_table3: '' },
                { id: 13, activity: 'ค. 2 วิสัยทัศน์', indicator: '0', data_table3: '' },
                { id: 14, activity: 'ค. 3 การวางกลยุทธ์ภาครัฐ', indicator: '0', data_table3: '' },
                { id: 15, activity: 'ค. 4 ศักยภาพเพื่อนำการปรับเปลี่ยน', indicator: '0', data_table3: '' },
                { id: 16, activity: 'ค. 5 การสอนงานและการมอบหมายงาน', indicator: '0', data_table3: '' }
            ],
            improvements: null,
            suggestions: null,  
            //Tab 2 
            products_Tab2: [],
            //Tab 3
            p04_re1: null,
            p04_re2: null,
            p04_re3: null,
            px04_re1: null,
            px04_re2: null,
            px04_re3: null,
            products_Tab3: [],
            chkP04: 0,
            //Tab 4
            products_Tab3T4: [],
            //total weight
            totalscoretrack:{},
            totalWeighttrack: {}, 
            WeightedScoreSumtrack:{},
            WeightedScoreSumX :{},
            WeightedScoreSumXT: {},
            //รวมคะแนน เกณฑ์การประเมิน
            totalCoreCompetencies:{},
            totalZeroScores:{},
            totalScoreSum:{},
            totalScoreZeroSum:{},
            totalScoreFinalSum:{}, 
            showscoresum:{} ,

           //ลงนามออนไลน์
            signForm: {
                receiver_ack: false,
            }, 

            updatingReceiverSignature: false,
 
            digitalSignature: {
                usable: false,
                signature_path: '',
                signature_url: '',
                updated_at: null,
            }, 
            signatures: {
                receiver_ack: null,

                evaluator_ack: null,
                evaluator_no_ack: null,

                evaluator_witness1: null,
                evaluator_witness2: null,

                superior_agree: null,
                superior_disagree: null,

                superior2_agree: null,
                superior2_disagree: null,
            },
 
        };
    }, 
    components: {
        TabView,
        TabPanel
    }, 
    async mounted(){  
        const { getSession } = await useAuth()
        const user = await getSession();

        const { STAFFID, SCOPES } = user.user.name
        const { staffdepartment, groupid } = SCOPES

        await this.setSession(STAFFID, staffdepartment, groupid); 

        // โหลดลายเซ็นดิจิทัลประจำตัวจากหน้าตั้งค่าลายเซ็น
        await this.loadMyDigitalSignature();

        // โหลดข้อมูลการลงนาม ป.04
        if (this.dataPor?.d_date && this.dataPor?.evalua) {
            await this.loadP04Signatures(); 
        } else {
            console.warn('ยังไม่โหลดลายเซ็น เพราะ dataPor ยังไม่พร้อม', this.dataPor);
        }
 
    },
    watch: { 
    tab4Reload(v) { 
            this.chkp04dataXr(); 
            this.showdatator(); 
        },

        dataPor: {
            handler(newVal) {
                if (newVal?.d_date && newVal?.evalua && this.staffid_Main) {
                    this.loadP04Signatures();
                }
            },
            deep: true,
            immediate: false
        },
    },
    computed: {
        totalscoretrack() {
            // ใช้ reduce เพื่อคำนวณค่ารวมของ p_weight(รวมค่าคะแนนที่ได้)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + subP01.p01_score ; // เพิ่ม p01_weight ของแต่ละ subP01
                }, 0);
            }, 0);
        },
        totalWeighttrack() {
            // ใช้ reduce เพื่อคำนวณค่ารวมของ p_weight*(รวมน้ำหนักความยากง่ายของงาน)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + subP01.p01_weight; // เพิ่ม p01_weight ของแต่ละ subP01
                }, 0);
            }, 0);
        },
        WeightedScoreSumtrack() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ และหารด้วย 5(รวมค่าคะแนนถ่วงน้ำหนัก)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    // คำนวณคะแนนรวม (subP01.p01_score * subP01.p01_weight / 100) แล้วหารด้วย 5
                    return subTotal + ((subP01.p01_score * subP01.p01_weight / 100));
                }, 0);
            }, 0).toFixed(3); // ใช้ toFixed(3) เพื่อแสดงทศนิยม 3 ตำแหน่ง
        },
        WeightedScoreSumX() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ(รวมน้ำหนักความยากง่ายของงาน/5)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + (subP01.p01_weight/5 );
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(2) เพื่อให้มีทศนิยม 2 ตำแหน่ง
        },
        WeightedScoreSumXT() {
            // คำนวณค่ารวมของคะแนนที่คำนวณ (รวมค่าคะแนนถ่วงน้ำหนัก/5)
            return this.products_Tab2.reduce((total, h) => {
                return total + h.subP01sX.reduce((subTotal, subP01) => {
                    return subTotal + ((subP01.p01_score * subP01.p01_weight / 100) / 5);
                }, 0);
            }, 0).toFixed(2); // ใช้ toFixed(2) เพื่อให้มีทศนิยม 2 ตำแหน่ง
        },
            //รวมคะแนน เกณฑ์การประเมิน
            //รวมช่องสมรรถนะ
        totalCoreCompetencies() { 
            return this.coreCompetencies.reduce((sum, row, index) => { 
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0; 
                return sum + dataTable1Value + dataTable2Value;
            }, 0);
        },
            //รวมช่องค่า0
        totalZeroScores() { 
            let zeroScoreCount = 0; 
            this.coreCompetencies.forEach(row => {
            if (parseFloat(row.data_table1) === 0) {
                zeroScoreCount++;
            }
            });  
            this.jobSpecificCompetencies.forEach(row => {
            if (parseFloat(row.data_table2) === 0) {
                zeroScoreCount++;
            }
            }); 
            return zeroScoreCount;
        },
        //รวมคะแนนจำนวนสมรรถนะ*3
        totalScoreSum(staffid) {
            let sum = 0;

            // คำนวณคะแนนจาก coreCompetencies
            this.coreCompetencies.forEach(row => {
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                sum += dataTable1Value * 3;
            });

            // คำนวณคะแนนจาก jobSpecificCompetencies
            this.jobSpecificCompetencies.forEach(row => {
                const dataTable2Value = parseFloat(row.data_table2) || 0;
                sum += dataTable2Value * 3;
            });

            return sum;
        }, 
        totalScoreSumX() {     
            return this.coreCompetencies.reduce((sum, row, index) => { 
                const dataTable1Value = parseFloat(row.data_table1) || 0;
                const dataTable2Value = parseFloat(this.jobSpecificCompetencies[index]?.data_table2) || 0;  
                return sum + (dataTable1Value * 3) + (dataTable2Value * 3);
            }, 0);
        },  
        totalScoreZeroSum() { 
            let zeroScoreCount = 0;  
            this.coreCompetencies.forEach(row => { 
                if (parseFloat(row.data_table1) === 0) {
                    zeroScoreCount++;
                }
            });  
            this.jobSpecificCompetencies.forEach(row => { 
                if (parseFloat(row.data_table2) === 0) {
                    zeroScoreCount++;
                }
            });  
            return zeroScoreCount * 2;
        },  
        evaluationPeriodText() { 
            if (this.recordEvaluaText && String(this.recordEvaluaText).trim() !== '') {
                return String(this.recordEvaluaText).trim();
            } 
            const r = this.dataPor?.d_evaluationround ?? '';
            const d = this.dataPor?.d_date ?? '';
            return `${r} ${d}`.trim();
        },  
    }, 

    methods: { 
          
        setSession (staffid_Main,facid_Main,groupid_Main) {
           // console.log('setSession');  
            this.staffid_Main = staffid_Main
            this.facid_Main = facid_Main
            this.groupid_Main = groupid_Main  
        },  
        showdatator() { 
            //console.log(this.dataPor.d_date,scoreA04); 
            axios.post('   http://127.0.0.1:8000/api/showdatator', {
                p_year: this.dataPor.d_date,
                evalua: this.dataPor.evalua,
                p_staffid: this.staffid_Main
            })
            // .then(res => {
            //      //console.log('Response',res.data);  
            //     this.assessorText = res.data[0].assessor; 
            //     this.assessor_positionText = res.data[0].assessor_position;
            //     this.showscoresum = res.data[0] 
            // })
            .then(res => {
                const row = res.data?.[0] || {};

                this.assessorText = row.assessor || '';
                this.assessor_positionText = row.assessor_position || '';
                this.showscoresum = row; 
                this.recordEvaluaText = row.record_evalua || '';
            }) 
            .catch(error => {
                console.error('Error fetching data:', error);
            });
        },  
        /*============= ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา =============*/ 
        chkp04dataXr(){  
            this.products_Tab3T4 = [];
            axios.post('   http://127.0.0.1:8000/api/showData04Tab3',{
                staff_id: this.staffid_Main,
                fac_id: this.facid_Main,
                year_id: this.dataPor.d_date,
                record: this.dataPor.evalua, 
            }).then(res => {     
                // console.log('chkp04data',res.data);
                if(res.data.length > 0){
                    this.products_Tab3T4 = res.data;
                } 
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }, 
        // async printDataP04() {  
        //     const { signIn, getSession, signOut } = await useAuth()
        //     const user = await getSession()   
        //     const form = {
        //         staff_id: this.staffid_Main,
        //         group_id: this.groupid_Main,
        //         fac_id: this.dataPor.fac_id,
        //         year_id: this.dataPor.d_date,
        //         evalua: this.dataPor.evalua ,
        //         period_text: this.evaluationPeriodText, 
        //         PREFIXFULLNAME:user.user.name.PREFIXFULLNAME,
        //         STAFFNAME :user.user.name.STAFFNAME,
        //         STAFFSURNAME:user.user.name.STAFFSURNAME,
        //         POSITIONNAME:user.user.name.POSITIONNAME,
        //         GROUPTYPENAME:user.user.name.GROUPTYPENAME,
        //         POSTYPENAME:user.user.name.POSTYPENAME, 
        //         SCOPES:user.user.name.SCOPES.staffdepartmentname  
                
        //     } 
        //     const queryParams = new URLSearchParams(form).toString();
        //     // console.log(queryParams); 
        //     const url = `   http://127.0.0.1:8000/report_p04?${queryParams}`;
        //     window.open(url, '_blank'); 
        // },  

        // async printDataP04X() {
        //     const { getSession } = await useAuth();
        //     const user = await getSession(); 
        //     try {
        //         const response = await axios.post("http://127.0.0.1:8000/api/exportPdf_P04", {
        //             staff_id: this.staffid_Main,
        //             group_id: this.groupid_Main,
        //             fac_id: this.dataPor.fac_id,
        //             year_id: this.dataPor.d_date,
        //             evalua: this.dataPor.evalua,
        //             period_text: this.evaluationPeriodText, 
        //             // ข้อมูลส่วนตัว
        //             PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
        //             STAFFNAME: user.user.name.STAFFNAME,
        //             STAFFSURNAME: user.user.name.STAFFSURNAME,
        //             POSITIONNAME: user.user.name.POSITIONNAME,
        //             GROUPTYPENAME: user.user.name.GROUPTYPENAME,
        //             POSTYPENAME: user.user.name.POSTYPENAME, 
        //             SCOPES: user.user.name.SCOPES.staffdepartmentname,
        //             // ส่ง ID ตำแหน่งเพื่อไป Query สมรรถนะกลุ่ม ข.
        //             postypenameid: user.user.name.POSTYPENAMEID || '' 
        //         }, { responseType: 'blob' });

        //         const url = window.URL.createObjectURL(response.data); 
        //         window.open(url, '_blank');  
        //     } catch (error) {
        //         console.error("Error:", error);
        //     } 
        // }, 

        async printDataP04X() {
            const { getSession } = await useAuth();
            const user = await getSession(); 
 
            try { 
                Swal.fire({
                title: 'กำลังสร้างไฟล์ PDF...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
                });

                const response = await axios.post(
                "http://127.0.0.1:8000/api/exportPdf_P04",
                {
                    staff_id: this.staffid_Main,
                    group_id: this.groupid_Main,
                    fac_id: this.dataPor.fac_id,
                    year_id: this.dataPor.d_date,
                    evalua: this.dataPor.evalua,
                    period_text: this.evaluationPeriodText,  
                    PREFIXFULLNAME: user.user.name.PREFIXFULLNAME,
                    STAFFNAME: user.user.name.STAFFNAME,
                    STAFFSURNAME: user.user.name.STAFFSURNAME,
                    POSITIONNAME: user.user.name.POSITIONNAME,
                    GROUPTYPENAME: user.user.name.GROUPTYPENAME,
                    POSTYPENAME: user.user.name.POSTYPENAME, 
                    SCOPES: user.user.name.SCOPES.staffdepartmentname, 
                    postypenameid: user.user.name.POSTYPENAMEID || ''
                },
                {
                    responseType: 'arraybuffer',
                    headers: { Accept: 'application/pdf' }
                }
                );
                Swal.close();
                const blob = new Blob([response.data], { type: 'application/pdf' });
                const url = window.URL.createObjectURL(blob);

                const preview = window.open('', '_blank');
                if (preview) {
                    preview.document.body.style.margin = '0';
                    const iframe = preview.document.createElement('iframe');
                    iframe.style.width = '100%';
                    iframe.style.height = '100%';
                    iframe.style.border = 'none';
                    iframe.src = url;
                    preview.document.body.appendChild(iframe);
                    preview.addEventListener('beforeunload', () => {
                        try { window.URL.revokeObjectURL(url); } catch (e) {}
                    });
                } else {
                    window.open(url, '_blank');
                    setTimeout(() => window.URL.revokeObjectURL(url), 100);
                }

            } catch (error) {
                Swal.close();
                console.error("Error:", error);
                Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถสร้างไฟล์ PDF ได้', 'error');
            }
        }, 


        //ลงนามออนไลน์
          
        getSignature(key1, key2) {
            return this.signatures[key1] || this.signatures[key2] || null;
        },

        formatThaiDate(dateValue) {
            if (!dateValue) return '';

            const date = new Date(dateValue);

            return date.toLocaleDateString('th-TH', {
                day: 'numeric',
                month: 'long',
                year: 'numeric',
            });
        },

        async getCurrentSigner() {
            const { getSession } = await useAuth();
            const session = await getSession();

            const name = session.user.name;

            if (!this.digitalSignature.usable) {
                await this.loadMyDigitalSignature();
            }

            return {
                signer_staff_id: name.STAFFID,
                signer_name: `${name.PREFIXFULLNAME || ''}${name.STAFFNAME || ''} ${name.STAFFSURNAME || ''}`.trim(),
                signer_position: name.POSITIONNAME || '',
                signature_image:
                    this.digitalSignature.signature_path ||
                    this.digitalSignature.signature_url ||
                    '',
            };
        },
 
        async savesignP04(signKey, roleName) {
            try {
                if (signKey !== 'receiver_ack') {
                    Swal.fire({
                        title: 'ไม่สามารถลงนามได้',
                        text: 'หน้านี้อนุญาตให้ลงนามเฉพาะผู้รับการประเมินเท่านั้น',
                        icon: 'warning',
                    });
                    return;
                }

                if (!this.signForm.receiver_ack) {
                    Swal.fire({
                        title: 'กรุณาติ๊กยืนยันก่อน',
                        text: 'กรุณาติ๊กว่าได้รับทราบผลการประเมินก่อนลงนาม',
                        icon: 'warning',
                    });
                    return;
                }

                const signer = await this.getCurrentSigner();

                if (Number(signer.signer_staff_id) !== Number(this.staffid_Main)) {
                    Swal.fire({
                        title: 'ไม่สามารถลงนามแทนได้',
                        text: 'ผู้รับการประเมินต้องเป็นผู้ลงนามรับทราบด้วยตนเอง',
                        icon: 'warning',
                    });
                    return;
                }

                if (!signer.signature_image) {
                    Swal.fire({
                        title: 'ยังไม่มีลายเซ็นดิจิทัล',
                        text: 'กรุณาไปตั้งค่าลายเซ็นดิจิทัลประจำตัวก่อนลงนาม',
                        icon: 'warning',
                    });
                    return;
                }

                const confirm = await Swal.fire({
                    title: 'ยืนยันการลงนามรับทราบผลการประเมิน?',
                    html: `
                        <div style="text-align:left">
                            <b>บทบาท:</b> ${roleName}<br>
                            <b>ผู้ลงนาม:</b> ${signer.signer_name}<br>
                            <b>ตำแหน่ง:</b> ${signer.signer_position}
                        </div>
                    `,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'ยืนยันลงนาม',
                    cancelButtonText: 'ยกเลิก',
                });

                if (!confirm.isConfirmed) return;

                const payload = {
                    staff_id: this.staffid_Main,
                    fac_id: this.facid_Main,
                    group_id: this.groupid_Main,
                    year_id: this.dataPor.d_date,
                    evalua: this.dataPor.evalua,

                    sign_key: signKey,
                    role_name: roleName,

                    signer_staff_id: signer.signer_staff_id,
                    signer_name: signer.signer_name,
                    signer_position: signer.signer_position,

                    // ใช้ลายเซ็นดิจิทัลจากหน้าตั้งค่า
                    signature_image: signer.signature_image || '',

                    comment: '',
                    signed_at: new Date().toISOString(),
                };

                const res = await axios.post('http://127.0.0.1:8000/api/savesign', payload);

 

                const savedSignature = this.normalizeSignatureRow(res.data?.data || payload);

                this.signatures[signKey] = savedSignature;
                this.signForm.receiver_ack = true;

                Swal.fire({
                    title: 'ลงนามสำเร็จ',
                    text: 'ระบบบันทึกการลงนามรับทราบผลการประเมินเรียบร้อยแล้ว',
                    icon: 'success',
                    timer: 1500,
                    showConfirmButton: false,
                });

            } catch (error) {
                console.error(error);

                Swal.fire({
                    title: 'เกิดข้อผิดพลาด',
                    text: error.response?.data?.message || 'ไม่สามารถลงนามออนไลน์ได้',
                    icon: 'error',
                });
            }
        },

        async loadP04Signatures() {
            try {
                const yearId =
                    this.dataPor?.d_date ||
                    this.dataPor?.year_id ||
                    this.dropdownItemYear?.code;

                const evalua =
                    this.dataPor?.evalua ||
                    this.dataPor?.record ||
                    this.dropdownItemRecord?.code;

                if (!this.staffid_Main || !yearId || !evalua) {
                    console.warn('loadP04Signatures missing data:', {
                        staffid_Main: this.staffid_Main,
                        yearId,
                        evalua,
                        dataPor: this.dataPor,
                    });
                    return;
                }

                const payload = {
                    // staff_id = ผู้รับการประเมิน
                    staff_id: String(this.staffid_Main),

                    // ปีงบประมาณ
                    year_id: Number(yearId),

                    // รอบประเมิน
                    evalua: Number(evalua),
                };

                console.log('loadP04Signatures payload:', payload);

                const res = await axios.post(
                    'http://127.0.0.1:8000/api/getsign',
                    payload
                );

                const rows = res.data?.data || [];

                const nextSignatures = {
                    receiver_ack: null,

                    evaluator_ack: null,
                    evaluator_no_ack: null,
                    evaluator_witness1: null,
                    evaluator_witness2: null,

                    superior_agree: null,
                    superior_disagree: null,

                    superior2_agree: null,
                    superior2_disagree: null,
                };

                rows.forEach(row => {
                    const normalizedRow = this.normalizeSignatureRow(row);

                    if (!normalizedRow?.sign_key) return;
  
                    // ผู้รับการประเมิน
                    if (normalizedRow.sign_key === 'receiver_ack') {
                        nextSignatures.receiver_ack = normalizedRow;
                        return;
                    }

                    // พยานกรณีผู้รับการประเมินไม่ลงนามรับทราบ
                    if (normalizedRow.sign_key === 'assessor_witness1') {
                        nextSignatures.evaluator_witness1 = normalizedRow;
                        return;
                    }

                    if (normalizedRow.sign_key === 'assessor_witness2') {
                        nextSignatures.evaluator_witness2 = normalizedRow;
                        return;
                    }
 
                    // ผู้ประเมิน กรณีเก็บเป็น assessor
                    if (normalizedRow.sign_key === 'assessor') {
                        if (normalizedRow.sign_choice === 'no_ack') {
                            nextSignatures.evaluator_no_ack = normalizedRow;
                        } else {
                            nextSignatures.evaluator_ack = normalizedRow;
                        }
                        return;
                    }

                    // ผู้บังคับบัญชาเหนือขึ้นไป กรณีเก็บเป็น supervisor1
                    if (normalizedRow.sign_key === 'supervisor1') {
                        if (normalizedRow.sign_choice === 'disagree') {
                            nextSignatures.superior_disagree = normalizedRow;
                        } else {
                            nextSignatures.superior_agree = normalizedRow;
                        }
                        return;
                    }

                    // ผู้บังคับบัญชาเหนือขึ้นไปอีกชั้นหนึ่ง กรณีเก็บเป็น supervisor2
                    if (normalizedRow.sign_key === 'supervisor2') {
                        if (normalizedRow.sign_choice === 'disagree') {
                            nextSignatures.superior2_disagree = normalizedRow;
                        } else {
                            nextSignatures.superior2_agree = normalizedRow;
                        }
                        return;
                    }

                    // รองรับกรณี sign_key เป็นชื่อที่หน้า template ใช้อยู่แล้ว
                    if (Object.prototype.hasOwnProperty.call(nextSignatures, normalizedRow.sign_key)) {
                        nextSignatures[normalizedRow.sign_key] = normalizedRow;
                    }
                });

                this.signatures = nextSignatures; 
                
                this.signForm.receiver_ack = !!nextSignatures.receiver_ack;

                console.log('signatures after mapping:', this.signatures);

            } catch (error) {
                console.error('Error loading signatures:', error);

                Swal.fire({
                    icon: 'error',
                    title: 'โหลดข้อมูลการลงนามไม่สำเร็จ',
                    text: error.response?.data?.message || 'เกิดข้อผิดพลาดในการโหลดข้อมูล',
                });
            }
        },
 
        async deletesignP04(signature) {
            try {
                if (!signature?.p04_id) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'ไม่พบรหัสรายการลงนาม',
                    });
                    return;
                }

                const confirm = await Swal.fire({
                    title: 'ยืนยันลบการลงนาม?',
                    text: 'เมื่อลบแล้ว ผู้ใช้งานจะสามารถลงนามใหม่ได้',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'ลบ',
                    cancelButtonText: 'ยกเลิก',
                    confirmButtonColor: '#dc2626',
                    cancelButtonColor: '#64748b',
                });

                if (!confirm.isConfirmed) return;

                const payload = {
                    p04_id: signature.p04_id,
                };

                const res = await axios.post('http://127.0.0.1:8000/api/deletesign', payload);

                const deleted = res.data?.data;

                if (deleted?.sign_key) {
                    this.signatures[deleted.sign_key] = null;

                    if (deleted.sign_key === 'receiver_ack') {
                        this.signForm.receiver_ack = false; 

                        await this.loadMyDigitalSignature();
                    }
                }

                Swal.fire({
                    icon: 'success',
                    title: 'ลบข้อมูลการลงนามสำเร็จ',
                    timer: 1200,
                    showConfirmButton: false,
                });

            } catch (error) {
                console.error(error);

                Swal.fire({
                    icon: 'error',
                    title: 'ลบข้อมูลไม่สำเร็จ',
                    text: error.response?.data?.message || 'เกิดข้อผิดพลาดในการลบข้อมูล',
                });
            }
        },

        async updateReceiverAckSignatureFromDigital() {
            try {
                const signature = this.signatures.receiver_ack;

                if (!signature?.p04_id) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'ไม่พบรายการลงนาม',
                        text: 'ไม่พบรหัสรายการลงนามที่ต้องการอัพเดท',
                    });
                    return;
                }

                this.updatingReceiverSignature = true;

                // โหลดลายเซ็นล่าสุดจากหน้า digitalsignature ก่อน
                await this.loadMyDigitalSignature();

                const signer = await this.getCurrentSigner();

                if (Number(signer.signer_staff_id) !== Number(this.staffid_Main)) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'ไม่สามารถอัพเดทแทนได้',
                        text: 'ผู้รับการประเมินต้องเป็นผู้ปรับปรุงลายเซ็นด้วยตนเอง',
                    });
                    return;
                }

                if (!signer.signature_image) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'ยังไม่มีลายเซ็นดิจิทัล',
                        text: 'กรุณาไปตั้งค่าลายเซ็นดิจิทัลประจำตัวก่อนอัพเดทลายเซ็น',
                    });
                    return;
                }

                const confirm = await Swal.fire({
                    title: 'ยืนยันอัพเดทลายเซ็น?',
                    html: `
                        <div style="text-align:left">
                            ระบบจะนำลายเซ็นล่าสุดจากหน้า <b>ตั้งค่าลายเซ็นดิจิทัล</b>
                            มาแทนลายเซ็นเดิมในแบบ ป.04<br><br>
                            <b>ผู้ลงนาม:</b> ${signer.signer_name}<br>
                            <b>ตำแหน่ง:</b> ${signer.signer_position}<br>
                            <b>หมายเหตุ:</b> วันที่ลงนามเดิมจะไม่ถูกเปลี่ยน
                        </div>
                    `,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: 'อัพเดทลายเซ็น',
                    cancelButtonText: 'ยกเลิก',
                });

                if (!confirm.isConfirmed) return;

                const payload = {
                    p04_id: signature.p04_id,
                    role_name: 'ผู้รับการประเมิน',

                    signer_staff_id: signer.signer_staff_id,
                    signer_name: signer.signer_name,
                    signer_position: signer.signer_position,

                    // ให้ backend อัปเดตวันที่ลงนามใหม่
                    signed_at: new Date().toISOString(),

                    // ใช้ลายเซ็นล่าสุดจาก digital_signatures
                    signature_image: signer.signature_image,

                    comment: signature.comment || '',
                };

                const res = await axios.post(`${API_BASE}/updatesign`, payload);

                const updated = this.normalizeSignatureRow(res.data?.data || res.data);

                if (updated?.sign_key) {
                    this.signatures = {
                        ...this.signatures,
                        [updated.sign_key]: updated,
                    };
                } else {
                    this.signatures.receiver_ack = updated;
                }

                this.signForm.receiver_ack = true;

                Swal.fire({
                    icon: 'success',
                    title: 'อัพเดทลายเซ็นสำเร็จ',
                    text: 'ระบบได้นำลายเซ็นล่าสุดมาแสดงในแบบ ป.04 แล้ว',
                    timer: 1500,
                    showConfirmButton: false,
                });

            } catch (error) {
                console.error(error);

                Swal.fire({
                    icon: 'error',
                    title: 'อัพเดทไม่สำเร็จ',
                    text:
                        error.response?.data?.error ||
                        error.response?.data?.message ||
                        'เกิดข้อผิดพลาดในการอัพเดทลายเซ็น',
                });
            } finally {
                this.updatingReceiverSignature = false;
            }
        },
 
        //แปลงชื่อไฟล์เป็น base64 

        normalizeSignatureRow(row) {
            if (!row) return row;

            const STORAGE_BASE = 'http://127.0.0.1:8000/storage';

            let imageSrc =
                row.signature_image_url ||
                row.signature_url ||
                row.signature_image ||
                '';

            let rawPath =
                row.signature_image_path ||
                row.signature_image ||
                '';

            if (
                imageSrc &&
                !imageSrc.startsWith('http://') &&
                !imageSrc.startsWith('https://') &&
                !imageSrc.startsWith('data:image')
            ) {
                imageSrc = imageSrc
                    .replace(/^\/?storage\//, '')
                    .replace(/^public\//, '');

                imageSrc = `${STORAGE_BASE}/${imageSrc}`;
            }

            if (imageSrc && !imageSrc.startsWith('data:image')) {
                const version = row.updated_at
                    ? new Date(row.updated_at).getTime()
                    : row.signed_at
                        ? new Date(row.signed_at).getTime()
                        : Date.now();

                imageSrc = `${imageSrc}${imageSrc.includes('?') ? '&' : '?'}v=${version}`;
            }

            return {
                ...row,
                signature_image_path: rawPath,
                signature_image: imageSrc,
            };
        },

        async loadMyDigitalSignature() {
            try {
                if (!this.staffid_Main) {
                    this.digitalSignature = {
                        usable: false,
                        signature_path: '',
                        signature_url: '',
                        updated_at: null,
                    };
                    return;
                }

                const res = await axios.post(`${API_BASE}/digital-signature/profile`, {
                    staff_id: String(this.staffid_Main),
                });

                const data = res.data || {};
                const signatureRow = data.signature || data.digital_signature || null;

                this.digitalSignature = {
                    usable: !!(signatureRow?.signature_image || data.signature_url || data.signatureUrl),
                    
                    // ใช้ path สำหรับบันทึกลง p04_signatures
                    // เช่น digital-signatures/130102/signature_xxx.png
                    signature_path: signatureRow?.signature_image || '',

                    // ใช้ url สำหรับแสดงผลเฉย ๆ ถ้าต้องการ preview
                    signature_url: data.signature_url || data.signatureUrl || '',

                    updated_at: data.signature_updated_at || signatureRow?.updated_at || null,
                };

            } catch (error) {
                console.error('loadMyDigitalSignature error:', error);

                this.digitalSignature = {
                    usable: false,
                    signature_path: '',
                    signature_url: '',
                    updated_at: null,
                };
            }
        },

 


    }
} 

</script>

<style scoped> 
label{
    font-size: medium;
    font-weight: 500;
}
.card-header {
    text-align: left; /* Aligns text to the left */
    margin: 0; /* Removes default margins */
    padding: 0; /* Removes default padding */
}
body {
    font-family: 'Prompt', Arial, sans-serif;
    background-color: #f5f5f5;
    margin: 0;
    padding: 0;
}
.container {
    width: 95%;
    margin: 0 auto;
    padding: 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(2, 2, 2, 0.1);
}
h3 {
    text-align: center;
    margin-bottom: 20px;
}
table {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;
    background-color: #fff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}
th, td {
    border: 1px solid #ddd;
    padding: 8px; /* Reduced padding */
    text-align: center;
    font-size: 14px; /* Smaller font size */
}
th {
    background-color: #ffffff;
}
th, td:first-child {
    width: 35%; /* Adjusted width for first column */
}
td:nth-child(2), td:nth-child(3) {
    width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
    margin: 5px 0; /* Reduced margin */
    font-size: 14px; /* Smaller font size for form */
}
.add-button, .save-button, .cancel-button {
    margin: 3px; /* Smaller margin */
    padding: 6px 12px; /* Smaller padding */
    font-size: 12px; /* Smaller font size for buttons */
}
.form-container {
    padding: 8px; /* Reduced padding */
    border: 1px solid #ddd;
    background-color: #f0f0f0;
    border-radius: 4px;
    font-size: 14px; /* Smaller font size */
}
.edit-icon, .delete-icon {
    margin: 0 8px; /* Smaller margin */
    cursor: pointer;
    font-size: 16px; /* Slightly larger font size */
}
.edit-icon {
    color: #ffc107;
}
.delete-icon {
    color: #dc3545;
}
th {
    background-color: #e5e5e3;
    color: rgb(9, 8, 8);
}
.bordered-box {
      border: 1px solid rgb(179, 177, 177);
      padding: 20px;
      margin-top: 20px;
    }
    /* P01 */
    label{
      font-size: medium;
      font-weight: 500;
  }
  .card-header {
      text-align: left; /* Aligns text to the left */
      margin: 0; /* Removes default margins */
      padding: 0; /* Removes default padding */
  }
  .table {
      width: 100%;
      border-collapse: collapse;
  }
  .table th, .table td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: center;
  }
  .table th {
      background-color: #edf2bb;
      font-weight: bold;
  }
  .table td {
      vertical-align: top;
  }
  .button-container {
  text-align: center; /* จัดกึ่งกลางในแนวนอน */
}
.custom-textarea {
  width: 100%; /* ให้เต็มความกว้างของ container */
  height: 100px; /* ปรับความสูงของ textarea */
  padding: 10px; /* เพิ่มช่องว่างด้านใน */
  border-radius: 5px; /* ปรับมุมให้โค้งมน */
  border: 1px solid #ccc; /* กำหนดขอบ */
  font-size: 1rem; /* ขนาดตัวอักษร */
  resize: none; /* ปิดการย่อขยาย */
}
body {
  font-family: 'Prompt', Arial, sans-serif;
  background-color: #f5f5f5;
  margin: 0;
  padding: 0;
}
.container {
  width: 95%;
  margin: 0 auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}
h3 {
  text-align: center;
  margin-bottom: 20px;
}
table {
  width: 100%;
  table-layout: fixed;
  border-collapse: collapse;
  background-color: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 20px;
}
th, td {
  border: 1px solid #ddd;
  padding: 8px; /* Reduced padding */
  text-align: center;
  font-size: 14px; /* Smaller font size */
}
th {
  background-color: #ffffff;
}
th, td:first-child {
  width: 35%; /* Adjusted width for first column */
}
td:nth-child(2), td:nth-child(3) {
  width: 32.5%; /* Adjusted width for other columns */
}
.add-row-form {
  margin: 5px 0; /* Reduced margin */
  font-size: 14px; /* Smaller font size for form */
}
.add-button, .save-button, .cancel-button {
  margin: 3px; /* Smaller margin */
  padding: 6px 12px; /* Smaller padding */
  font-size: 12px; /* Smaller font size for buttons */
}
.form-container {
  padding: 8px; /* Reduced padding */
  border: 1px solid #ddd;
  background-color: #f0f0f0;
  border-radius: 4px;
  font-size: 14px; /* Smaller font size */
}
.edit-icon, .delete-icon {
  margin: 0 8px; /* Smaller margin */
  cursor: pointer;
  font-size: 16px; /* Slightly larger font size */
}
.edit-icon {
  color: #ffc107;
}
.delete-icon {
  color: #dc3545;
}
.styled-table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .styled-table thead tr {
    background-color: #f2f2f2;
  }
  
  .styled-table th, .styled-table td {
    padding: 8px;
    text-align: center;
    border: 1px solid #ddd;
  }

  .styled-table td b {
    word-break: break-word;
  }
  .left-align {
    text-align: left;
  }

  /* //ลงนามออนไลน์ */

.sign-table td {
     vertical-align: top;
}

.left-align {
    text-align: left !important;
}

.center-align {
    text-align: center !important;
}

.sign-check-line {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    margin: 8px 0;
    line-height: 1.6;
    cursor: pointer;
}

.sign-check-line input[type="checkbox"] {
    width: 18px;
    height: 18px;
    margin-top: 4px;
    cursor: pointer;
}

.signature-card {
    min-height: 130px;
    padding: 14px;
    border-radius: 10px;
    border: 1px dashed #b9b9b9;
    background: #fafafa;
    font-size: 14px;
    line-height: 1.8;
}

.signature-card.signed {
    border: 1px solid #22c55e;
    background: #f0fdf4;
    color: #123524;
}

.signature-card.waiting {
    color: #555;
}

.signed-badge {
    display: inline-block;
    background: #22c55e;
    color: white;
    padding: 3px 12px;
    border-radius: 999px;
    font-size: 13px;
    margin-bottom: 8px;
}

.signature-img {
    display: block;
    max-width: 180px;
    max-height: 70px;
    object-fit: contain;
    margin: 4px auto 8px auto;
}

.typed-signature {
    font-size: 22px;
    font-weight: 600;
    color: #0f172a;
    margin: 8px 0;
}

.witness-box {
    margin-top: 10px;
    padding: 10px;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
}

.mt-2 {
    margin-top: 0.5rem;
}

.mt-3 {
    margin-top: 1rem;
}

.mb-2 {
    margin-bottom: 0.5rem;
}

.w-full {
    width: 100%;
}

.readonly-section {
    background: #f8fafc;
}

.readonly-check {
    cursor: default;
    color: #475569;
}

.readonly-check input {
    cursor: not-allowed !important;
}

.readonly-comment {
    margin-top: 8px;
    padding: 10px;
    background: #fff;
    border: 1px dashed #cbd5e1;
    border-radius: 8px;
    color: #334155;
    line-height: 1.6;
}

.text-muted {
    display: block;
    margin-top: 8px;
    color: #64748b;
}

 
.signature-button-wrap {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 12px;
    width: 100%;
}

/* สำหรับ PrimeVue ใน scoped style */
:deep(.signature-btn) {
    width: auto !important;
    min-width: 170px;
    max-width: 230px;
    padding: 6px 18px !important;
    display: inline-flex !important;
    justify-content: center;
    align-items: center;
}

/* กัน label ดันเต็มปุ่ม */
:deep(.signature-btn .p-button-label) {
    flex: unset !important;
}

/* กัน icon กับข้อความห่างเกินไป */
:deep(.signature-btn .p-button-icon) {
    margin-right: 6px;
}

.signature-action-wrap {
    display: flex;
    justify-content: center;
    gap: 8px;
    margin-top: 10px;
    flex-wrap: wrap;
}

:deep(.signature-action-btn) {
    width: auto !important;
    min-width: 80px;
    padding: 5px 12px !important;
}
 
.signature-button-wrap {
    gap: 8px;
    flex-wrap: wrap;
} 
 
.signature-display-area {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 80px;
    margin: 8px 0;
}

.signature-img {
    display: block;
    max-width: 240px;
    max-height: 90px;
    object-fit: contain;
    margin: 4px auto 8px auto;
    background: transparent;
}

.no-signature-image {
    font-size: 14px;
    color: #991b1b;
    font-weight: 600;
    padding: 8px 12px;
    border: 1px dashed #fca5a5;
    border-radius: 8px;
    background: #fff7f7;
}

.signature-display-area {
    height: 120px;
    max-height: 120px;
    overflow: hidden;
}

.signature-display-area .signature-img {
    width: auto !important;
    max-width: 320px !important;
    max-height: 110px !important;
    object-fit: contain !important;
    transform: none !important;
    transform-origin: center;
}

.sign-status-text {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    margin-top: 8px;
    font-weight: 700;
    font-size: 12px;
    line-height: 1.5;
}

.sign-status-text.signed {
    color: #15803d;
}

.sign-status-text.waiting {
    color: #92400e;
}

.readonly-witness-box {
    margin-top: 12px;
    padding: 12px;
    border-radius: 10px;
    border: 1px solid #f59e0b;
    background: #fffbeb;
}

.readonly-witness-title {
    font-weight: 700;
    color: #92400e;
    margin-bottom: 10px;
}

.readonly-witness-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}

.readonly-witness-card {
    border: 1px solid #fbbf24;
    border-radius: 10px;
    background: #ffffff;
    padding: 10px;
    text-align: center;
}

.readonly-witness-card-title {
    font-weight: 700;
    color: #78350f;
    margin-bottom: 6px;
}

.readonly-witness-signature-img {
    max-width: 170px;
    max-height: 70px;
    object-fit: contain;
    margin: 4px auto 8px auto;
    display: block;
}

.readonly-witness-detail {
    font-size: 13px;
    line-height: 1.7;
    color: #374151;
}

.readonly-witness-waiting {
    color: #92400e;
    font-size: 13px;
    padding: 10px 0;
}

.readonly-disagree-comment {
    margin-top: 10px;
    padding: 10px 12px;
    background: #fff1f2;
    border: 1px solid #9f1239;
    border-radius: 8px;
    color: #7f1d1d;
    line-height: 1.7;
    white-space: pre-line;
}

.readonly-disagree-comment::before {
    content: "⚠ ";
    font-weight: 700;
}










</style>



