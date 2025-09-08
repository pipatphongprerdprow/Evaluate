<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';
import { useLayout } from './composables/layout';
import { useRouter } from 'vue-router'; 
const { layoutConfig, onMenuToggle } = useLayout();
const outsideClickListener = ref(null);
const topbarMenuActive = ref(false);
const router = useRouter();
const inactivityTimeout = ref(null); // ตัวแปรเก็บ timeout

const { signIn, getSession, signOut } = await useAuth();
const sessionData = await getSession();

// ฟังก์ชันรีเซ็ต timeout ทุกครั้งที่มีการใช้งาน
const resetTimeout = () => {
    clearTimeout(inactivityTimeout.value);
    inactivityTimeout.value = setTimeout(() => {
        signOut();
    }, 1000 * 60 * 60 * 6); // 6 ชั่วโมง
};

// ดักจับเหตุการณ์ของผู้ใช้
onMounted(() => {
    bindOutsideClickListener();
    resetTimeout();
    window.addEventListener('mousemove', resetTimeout);
    window.addEventListener('keydown', resetTimeout);
});
onBeforeUnmount(() => {
    unbindOutsideClickListener();
    clearTimeout(inactivityTimeout.value);
    window.removeEventListener('mousemove', resetTimeout);
    window.removeEventListener('keydown', resetTimeout);
});

const logoUrl = computed(() => {
    return `/layout/images/${layoutConfig.darkTheme.value ? 'logo-white' : 'kongkang'}.jpg`;
});

const onTopBarMenuButton = () => {
    topbarMenuActive.value = !topbarMenuActive.value;
};

const onSettingsClick = () => {
    topbarMenuActive.value = false;
    router.push('/utilities/documentation');
};

const topbarMenuClasses = computed(() => {
    return {
        'layout-topbar-menu-mobile-active': topbarMenuActive.value
    };
});

const bindOutsideClickListener = () => {
    if (!outsideClickListener.value) {
        outsideClickListener.value = (event) => {
            if (isOutsideClicked(event)) {
                topbarMenuActive.value = false;
            }
        };

        document.addEventListener('click', outsideClickListener.value);
    }
};

const unbindOutsideClickListener = () => {
    if (outsideClickListener.value) {
        document.removeEventListener('click', outsideClickListener.value);
        outsideClickListener.value = null;
    }
};

const isOutsideClicked = (event) => {
    if (!topbarMenuActive.value) return;
    const sidebarEl = document.querySelector('.layout-topbar-menu');
    const topbarEl = document.querySelector('.layout-topbar-menu-button');

    return !(sidebarEl?.contains(event.target) || topbarEl?.contains(event.target));
};
</script>

<template>
    <div class="layout-topbar">
        <router-link to="/" class="layout-topbar-logo">
            <img src="~/assets/layout/images/kongkang.jpg" alt="logo" />
            <span>Evaluate Personnel MSU</span>
        </router-link>
         

        <button class="p-link layout-menu-button layout-topbar-button" @click="onMenuToggle()">
            <i class="pi pi-bars"></i>
        </button>

        <button class="p-link layout-topbar-menu-button layout-topbar-button" @click="onTopBarMenuButton()">
            <i class="pi pi-ellipsis-v"></i>
        </button>

        <div class="layout-topbar-menu" :class="topbarMenuClasses">
            <template v-if="Object.keys(sessionData).length === 0">
                <button @click="signIn('erpauth')" class="p-link layout-topbar-button pr-4">
                    <i class="pi pi-sign-in"></i>
                    <i style="font-size: 1.25em;margin-left: 0.25em;margin-right: 1em;text-wrap: nowrap;">เข้าสู่ระบบ</i>
                </button>
            </template>
            <template v-else>
                <button @click="signOut()" class="p-link layout-topbar-button pr-4">
                    <i class="pi pi-sign-out"></i>
                    <i style="font-size: 1.25em;margin-left: 0.25em;margin-right: 1em;text-wrap: nowrap;">ออกจากระบบ</i>
                </button>
            </template>
        </div>
    </div>
</template>

<style lang="scss" scoped></style>
