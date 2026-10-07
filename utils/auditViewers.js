// staffid ที่เห็นเมนู "ประวัติการใช้งาน" (ต้องตรงกับ AUDIT_VIEWER_STAFFIDS ฝั่ง Laravel)
export const AUDIT_VIEWER_STAFFIDS = ['5009680', '5009942'];

export function isAuditViewer(staffId) {
    return AUDIT_VIEWER_STAFFIDS.includes(String(staffId ?? ''));
}
