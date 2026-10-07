import axios from 'axios';
import { watch } from 'vue';

// แนบตัวตนผู้ใช้ (X-Staff-*) ไปกับทุก request ที่เรียก Laravel API
// เพื่อให้ backend บันทึกประวัติการใช้งานได้ว่าใครเป็นคนทำ
// ทำที่ระดับ XMLHttpRequest เพื่อให้ครอบคลุมทุก axios instance (รวม axios.create() ในบางหน้า)
export default defineNuxtPlugin(() => {
    const { data, status } = useAuth();

    const currentStaff = () => {
        const profile = data.value?.user?.name;
        if (!profile?.STAFFID) return null;
        return {
            id: String(profile.STAFFID),
            name: `${profile.PREFIXFULLNAME ?? ''}${profile.STAFFNAME ?? ''} ${profile.STAFFSURNAME ?? ''}`.trim(),
            fac: String(profile.SCOPES?.staffdepartment ?? ''),
            facName: String(profile.SCOPES?.staffdepartmentname ?? '')
        };
    };

    const isBackendApi = (url) => {
        const value = String(url ?? '');
        return value.includes('/api/') && !value.includes('/api/auth');
    };

    if (!XMLHttpRequest.prototype.__auditPatched) {
        const originalOpen = XMLHttpRequest.prototype.open;
        const originalSend = XMLHttpRequest.prototype.send;

        XMLHttpRequest.prototype.open = function (method, url, ...rest) {
            this.__auditUrl = url;
            return originalOpen.call(this, method, url, ...rest);
        };

        XMLHttpRequest.prototype.send = function (body) {
            try {
                const staff = isBackendApi(this.__auditUrl) ? currentStaff() : null;
                if (staff) {
                    this.setRequestHeader('X-Staff-Id', staff.id);
                    this.setRequestHeader('X-Staff-Name', encodeURIComponent(staff.name));
                    this.setRequestHeader('X-Staff-Fac', staff.fac);
                    this.setRequestHeader('X-Staff-Fac-Name', encodeURIComponent(staff.facName));
                }
            } catch (e) {
                // แนบ header ไม่ได้ ก็ยังส่ง request ตามปกติ
            }
            return originalSend.call(this, body);
        };

        XMLHttpRequest.prototype.__auditPatched = true;
    }

    // บันทึกการเข้าสู่ระบบ ครั้งเดียวต่อ session ของ browser (backend กันซ้ำภายใน 30 นาทีอีกชั้น)
    watch(
        [status, () => currentStaff()?.id],
        async ([value, staffId]) => {
            if (value !== 'authenticated' || !staffId) return;

            const key = `audit_login_${staffId}`;
            try {
                if (sessionStorage.getItem(key)) return;
            } catch (e) {
                // sessionStorage ใช้ไม่ได้ ให้ backend กันซ้ำแทน
            }

            try {
                const res = await axios.post('http://127.0.0.1:8000/api/auditlog/login');
                if (res.data?.status === 'ok') sessionStorage.setItem(key, '1');
            } catch (e) {
                // บันทึกไม่สำเร็จ จะลองใหม่ในการโหลดหน้าครั้งถัดไป
            }
        },
        { immediate: true }
    );
});
