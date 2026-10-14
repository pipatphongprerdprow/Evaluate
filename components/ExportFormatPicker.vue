<script setup>
import { ref } from 'vue';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';

const emit = defineEmits(['word', 'pdf']);
const visible = ref(false);
function selectFormat(format) {
    visible.value = false;
    emit(format);
}
</script>

<template>
    <span>
        <Button label="Export" icon="pi pi-download" @click="visible = true" />
        <Dialog v-model:visible="visible" header="Export เอกสาร" modal dismissable-mask :draggable="false" class="export-dialog" :style="{ width: '560px', maxWidth: 'calc(100vw - 32px)' }">
            <template #header>
                <div class="export-heading">
                    <span class="export-heading-icon"><i class="pi pi-download" aria-hidden="true" /></span>
                    <div><span class="export-eyebrow">ดาวน์โหลดเอกสาร</span><h2>Export เอกสาร</h2></div>
                </div>
            </template>
            <p class="export-description">เลือกรูปแบบไฟล์ที่เหมาะกับการใช้งานของคุณ</p>
            <div class="export-options">
                <button type="button" class="export-option word-option" @click="selectFormat('word')">
                    <span class="format-icon"><i class="pi pi-file-word" aria-hidden="true" /></span>
                    <span class="format-copy"><span class="format-title">Microsoft Word <span class="format-extension">.DOC</span></span><span class="format-description">สำหรับแก้ไขข้อความและจัดเอกสารเพิ่มเติม</span></span>
                    <i class="pi pi-arrow-right format-arrow" aria-hidden="true" />
                </button>
                <button type="button" class="export-option pdf-option" @click="selectFormat('pdf')">
                    <span class="format-icon"><i class="pi pi-file-pdf" aria-hidden="true" /></span>
                    <span class="format-copy"><span class="format-title">PDF <span class="format-extension">.PDF</span></span><span class="format-description">สำหรับพิมพ์หรือส่งต่อ โดยคงรูปแบบเอกสาร</span></span>
                    <i class="pi pi-arrow-right format-arrow" aria-hidden="true" />
                </button>
            </div>
            <template #footer>
                <div class="export-footer"><span><i class="pi pi-info-circle" aria-hidden="true" /> คลิกเลือกเพื่อส่งออกเอกสาร</span><Button label="ยกเลิก" text severity="secondary" @click="visible = false" /></div>
            </template>
        </Dialog>
    </span>
</template>

<style scoped>
:global(.export-dialog) { border-radius:20px; overflow:hidden; border:1px solid var(--surface-border); box-shadow:0 24px 80px rgba(15,23,42,.2); }
:global(.export-dialog .p-dialog-header) { padding:26px 28px 14px; }
:global(.export-dialog .p-dialog-content) { padding:0 28px 24px; }
:global(.export-dialog .p-dialog-footer) { padding:12px 20px 12px 28px; border-top:1px solid var(--surface-border); background:var(--surface-ground); }
.export-heading { display:flex; align-items:center; gap:14px; }
.export-heading-icon { display:grid; place-items:center; width:48px; height:48px; border-radius:14px; background:var(--primary-50); color:var(--primary-700); }
.export-heading-icon i { font-size:21px; }
.export-eyebrow { font-size:12px; color:var(--text-color-secondary); }
.export-heading h2 { margin:4px 0 0; font-size:22px; font-weight:700; color:var(--text-color); }
.export-description { margin:4px 0 22px; color:var(--text-color-secondary); line-height:1.6; }
.export-options { display:grid; gap:12px; }
.export-option { display:flex; align-items:center; gap:16px; width:100%; padding:20px; border:1px solid var(--surface-border); border-radius:14px; background:var(--surface-card); text-align:left; font:inherit; color:var(--text-color); cursor:pointer; transition:border-color .18s,background .18s,box-shadow .18s; }
.export-option:hover { border-color:var(--format-color); background:var(--format-background); box-shadow:0 4px 14px rgba(15,23,42,.06); }
.export-option:focus-visible { outline:3px solid var(--format-color); outline-offset:3px; }
.word-option { --format-color:#2563eb; --format-background:#eff6ff; }
.pdf-option { --format-color:#dc2626; --format-background:#fff1f2; }
.format-icon { display:grid; place-items:center; flex-shrink:0; width:52px; height:58px; border-radius:12px; color:var(--format-color); background:var(--format-background); }
.format-icon i { font-size:28px; }
.format-copy { display:flex; flex:1; min-width:0; flex-direction:column; gap:7px; }
.format-title { display:flex; align-items:center; flex-wrap:wrap; gap:9px; font-size:16px; font-weight:700; }
.format-extension { border:1px solid var(--surface-border); border-radius:5px; padding:2px 5px; font-size:10px; font-weight:600; color:var(--text-color-secondary); }
.format-description { font-size:13px; color:var(--text-color-secondary); line-height:1.6; }
.format-arrow { color:var(--text-color-secondary); font-size:14px; }
.export-option:hover .format-arrow { color:var(--format-color); }
.export-footer { display:flex; align-items:center; justify-content:space-between; gap:12px; }
.export-footer > span { display:flex; align-items:center; gap:7px; color:var(--text-color-secondary); font-size:12px; }
@media(max-width:480px) {
    :global(.export-dialog .p-dialog-header) { padding:20px 18px 12px; }
    :global(.export-dialog .p-dialog-content) { padding:0 18px 20px; }
    :global(.export-dialog .p-dialog-footer) { padding:10px 12px 10px 18px; }
    .export-option { padding:16px 12px; gap:12px; }
    .format-icon { width:44px; height:50px; }
    .format-title { font-size:15px; }
}
@media(prefers-reduced-motion:reduce) { .export-option { transition:none; } }
</style>
