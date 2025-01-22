// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    typescript: false,
    devServer :{
        port: 3000
    },
    app: { 
        baseURL: '/evaluate/',
        head: {
            title: 'Sakai Vue',
            link: [
                {
                    id: 'theme-css',
                    rel: 'stylesheet',
                    type: 'text/css',
                    href: '/evaluate/themes/aura-light-green/theme.css'
                }
            ]
        }
    }, 
    modules: ['nuxt-primevue','@sidebase/nuxt-auth'],
    primevue: {
        options: { ripple: true },
        components: {
            exclude: ['Editor']
        }
    },
    script: [
        {
            strategy: 'lazyOnload',
            src: 'https://www.googletagmanager.com/gtag/js?id=UA-93461466-1'
        },
        {
            id: 'ga-analytics',
            strategy: 'lazyOnload',
            children: `
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', 'UA-93461466-1');
            `
        }
    ],
    css: ['primeicons/primeicons.css', 'primeflex/primeflex.scss', 'primevue/resources/primevue.min.css', '@/assets/styles.scss'],
    //plugins: ['~/plugins/vue-authenticate.js'],
    auth: {
        isEnabled: true,
        disableServerSideAuth: false,
        originEnvKey: 'AUTH_ORIGIN',
        baseURL: 'https://localhost:3000/evaluate/api/auth',
        provider: {
            type: 'authjs',
            trustHost: false,
            defaultProvider: 'erpauth',
            addDefaultCallbackUrl: true
        },
        sessionRefresh: {
          //enablePeriodically: true,
          enableOnWindowFocus: true,
        }
    }
});
