// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    typescript: false,
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
        // globalAppMiddleware: true,
        
        enableSessionRefreshOnWindowFocus: true,

        provider: {
            type: 'authjs',
            customOAuth: {
            id: 'custom-oauth',
            name: 'Custom OAuth',
            type: 'oauth',
            authorization: {
                url: 'https://erp.msu.ac.th/authen/oauth/_authorize',
                params: {
                client_id: '9cfc597a-f7ce-477c-8a72-56b40bba6dc6',
                response_type: 'code',
                redirect_uri: 'http://localhost:3000/evaluate/api/auth/callback/custom-oauth',
                scope: 'email profile',
                },
            },
            token: {
                url: 'https://erp.msu.ac.th/authen/oauth/token',
            },
            userInfo: {
                url: 'https://erp.msu.ac.th/authen/api/authuser?progcode=budget01',
            },
            clientId: '9cfc597a-f7ce-477c-8a72-56b40bba6dc6',
            clientSecret: 'smGEGF6PuNIqFatazayEKH3X8s3nEfzc5GKnIuPK',
            },
        },
    }
});
