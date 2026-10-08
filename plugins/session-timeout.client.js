import { watch } from 'vue';

// ออกจากระบบอัตโนมัติเมื่อไม่ได้ใช้งานครบตามเวลาที่กำหนด (SESSION_IDLE_TIMEOUT_MS)
// - เก็บเวลาใช้งานล่าสุดใน localStorage จึงใช้ร่วมกันทุกแท็บ และยังนับต่อแม้ปิด browser / คอมพักเครื่อง
// - ผูกกับ session ปัจจุบัน (token ของ ERP) เข้าสู่ระบบใหม่เมื่อไหร่ เริ่มนับใหม่
// - ระหว่างใช้งานอยู่ ขอ session ใหม่เป็นระยะ เพื่อไม่ให้ session ฝั่ง server หมดอายุก่อน
//   (ต้องตรงกับ session.maxAge ใน server/api/auth/[...].js)
// ทดสอบ: 2 นาที  ใช้จริง: 6 * 60 * 60 * 1000 (6 ชั่วโมง)
const SESSION_IDLE_TIMEOUT_MS =  8 * 60 * 60 * 1000 ;

const LAST_ACTIVITY_KEY = 'evaluate_last_activity';
const CHECK_INTERVAL_MS = Math.min(30 * 1000, SESSION_IDLE_TIMEOUT_MS / 8);
const ACTIVITY_THROTTLE_MS = Math.min(15 * 1000, SESSION_IDLE_TIMEOUT_MS / 8);
// ต่ออายุ session ฝั่ง server ให้บ่อยกว่าเวลาหมดอายุเสมอ
const SESSION_REFRESH_MS = Math.min(15 * 60 * 1000, SESSION_IDLE_TIMEOUT_MS / 4);

// ข้อความระยะเวลา เช่น "6 ชั่วโมง", "2 นาที"
const TIMEOUT_TEXT =
    SESSION_IDLE_TIMEOUT_MS >= 60 * 60 * 1000 ? `${SESSION_IDLE_TIMEOUT_MS / (60 * 60 * 1000)} ชั่วโมง` : `${SESSION_IDLE_TIMEOUT_MS / (60 * 1000)} นาที`;
const ACTIVITY_EVENTS = ['mousemove', 'mousedown', 'keydown', 'scroll', 'touchstart', 'wheel'];

export default defineNuxtPlugin(() => {
    const { status, data, getSession, signOut } = useAuth();
    const baseURL = useRuntimeConfig().app.baseURL || '/';

    let memory = null;
    let lastWrite = 0;
    let lastRefresh = Date.now();
    let signingOut = false;

    // ตัวระบุ session ปัจจุบัน: เปลี่ยนทุกครั้งที่เข้าสู่ระบบใหม่
    const sessionMarker = () => {
        const token = data.value?.providerInfo?.access_token;
        return token ? String(token).slice(-24) : String(data.value?.user?.name?.STAFFID ?? '');
    };

    const readLastActivity = () => {
        let saved = memory;
        try {
            saved = JSON.parse(localStorage.getItem(LAST_ACTIVITY_KEY) || 'null');
        } catch (e) {
            // localStorage ใช้ไม่ได้ ใช้ค่าในหน่วยความจำแทน
        }
        // เป็นของ session อื่น (เข้าสู่ระบบใหม่แล้ว) ไม่นับ
        if (!saved || saved.m !== sessionMarker()) return 0;
        memory = saved;
        return Number(saved.t) || 0;
    };

    const writeLastActivity = (time) => {
        lastWrite = time;
        memory = { m: sessionMarker(), t: time };
        try {
            localStorage.setItem(LAST_ACTIVITY_KEY, JSON.stringify(memory));
        } catch (e) {
            // localStorage ใช้ไม่ได้ ใช้ค่าในหน่วยความจำแทน
        }
    };

    const clearStoredState = () => {
        memory = null;
        try {
            localStorage.removeItem(LAST_ACTIVITY_KEY);
            Object.keys(sessionStorage)
                .filter((key) => key.startsWith('audit_login_'))
                .forEach((key) => sessionStorage.removeItem(key));
        } catch (e) {
            // ไม่มีผลกับการออกจากระบบ
        }
    };

    // หมดเวลา: ออกจากระบบทันที แล้วไปหน้าแรกซึ่งจะแจ้งเตือนและให้เข้าสู่ระบบใหม่ (pages/index.vue)
    const expire = async () => {
        if (signingOut) return;
        signingOut = true;
        clearStoredState();
        if (import.meta.dev) console.info('[session-timeout] หมดเวลา ออกจากระบบ');

        await signOut({ callbackUrl: `${baseURL}?timeout=${encodeURIComponent(TIMEOUT_TEXT)}` });
    };

    const isIdleTooLong = () => {
        const last = readLastActivity();
        return last > 0 && Date.now() - last >= SESSION_IDLE_TIMEOUT_MS;
    };

    const check = () => {
        if (status.value !== 'authenticated' || signingOut) return;

        if (import.meta.dev && readLastActivity()) {
            const left = Math.max(0, Math.round((SESSION_IDLE_TIMEOUT_MS - (Date.now() - readLastActivity())) / 1000));
            console.info(`[session-timeout] ไม่ได้ใช้งานมา ${Math.round((Date.now() - readLastActivity()) / 1000)} วินาที เหลือ ${left} วินาที`);
        }

        if (!readLastActivity()) {
            // เพิ่งเข้าสู่ระบบ: เริ่มนับจากตอนนี้
            writeLastActivity(Date.now());
        } else if (isIdleTooLong()) {
            expire();
        }
    };

    const onActivity = () => {
        if (status.value !== 'authenticated' || signingOut) return;

        const now = Date.now();
        if (now - lastWrite < ACTIVITY_THROTTLE_MS) return;

        // กลับมาหลังหายไปนาน: ตรวจก่อนนับว่าใช้งาน
        if (isIdleTooLong()) {
            expire();
            return;
        }
        writeLastActivity(now);

        if (now - lastRefresh >= SESSION_REFRESH_MS) {
            lastRefresh = now;
            getSession().catch(() => {});
        }
    };

    ACTIVITY_EVENTS.forEach((name) => window.addEventListener(name, onActivity, { passive: true }));
    document.addEventListener('visibilitychange', () => {
        if (document.visibilityState === 'visible') check();
    });
    window.addEventListener('focus', check);
    setInterval(check, CHECK_INTERVAL_MS);
    if (import.meta.dev) console.info(`[session-timeout] เริ่มทำงาน ออกจากระบบเมื่อไม่ได้ใช้งาน ${TIMEOUT_TEXT}`);

    // เปิดเว็บมาใหม่ (เช่น ปิด browser ไปหลายวัน) ให้ตรวจทันที
    // session ถูกตัดจากฝั่ง server ระหว่างเปิดหน้าค้างไว้ (เช่น refresh ตอนกลับมาที่หน้าเว็บ)
    // แจ้งเฉพาะกรณีไม่ได้ใช้งานจริง ถ้ากดออกจากระบบเองจะไม่แจ้ง
    watch(
        status,
        (value, oldValue) => {
            if (value === 'authenticated') {
                check();
            } else if (value === 'unauthenticated') {
                const idle = memory && Date.now() - Number(memory.t) >= SESSION_IDLE_TIMEOUT_MS;
                if (oldValue === 'authenticated' && idle && !signingOut) {
                    expire();
                } else {
                    signingOut = false;
                }
            }
        },
        { immediate: true }
    );
});
