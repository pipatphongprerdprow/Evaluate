<script setup>
import { useLayout } from './composables/layout';
import { computed } from 'vue';
const { layoutConfig } = useLayout();
// const logoUrl = computed(() => {
//     return require(`@/assets/layout/images/${layoutConfig.darkTheme.value ? 'logo-white' : 'logo-dark'}.svg`);
// });
// const logoUrl = require(`@/assets/layout/images/logo-white.svg`);
</script>

<template>
    <div class="layout-footer">
        <img src="~/assets/layout/images/kongkang.jpg" alt="logo" height="40" class="mr-2"  />
        <span class="font-medium ml-2">Evaluate Personnel MSU</span>
    </div>
</template>
<style lang="scss" scoped></style>
