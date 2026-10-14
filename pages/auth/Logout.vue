<script setup>
const { signOut } = useAuth();
const authHome = useRuntimeConfig().app.baseURL || '/';
</script>

<template>
    <button @click="signOut({ callbackUrl: authHome })">ออกจากระบบ</button>
</template>
