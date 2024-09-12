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
        <img src="~/assets/layout/images/logo-white.svg" alt="Logo" height="20" class="mr-2" />
        
        <span class="font-medium ml-2">Evaluate Personal MSU</span>
    </div>
</template>
<style lang="scss" scoped></style>
