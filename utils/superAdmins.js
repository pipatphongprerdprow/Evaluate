export const SUPERADMIN_STAFFIDS = ['5009680', '5009942'];

export function isSuperAdmin(staffId) {
    return SUPERADMIN_STAFFIDS.includes(String(staffId ?? '').trim());
}
