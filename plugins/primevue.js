import PrimeVue from 'primevue/config';
import Button from 'primevue/button';

export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.use(PrimeVue);
  nuxtApp.vueApp.component('Button', Button);
});