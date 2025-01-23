// plugins/vue-authenticate.js
/*
import VueAuthenticate from 'vue-authenticate'
import axios from 'axios'

export default defineNuxtPlugin(nuxtApp => {
  if (process.client) {
    const vueAuth = new VueAuthenticate(axios, {
      baseUrl: '', // No backend server
      providers: {
        msu: {
          name: 'msu',
          url: 'https://erp.msu.ac.th/authen/api/authuser?progcode=TEST',
          clientId: '99aa3ef7-dc1f-4e64-a5ed-46ccd0b9fea9',
          redirectUri: 'https://survey.msu.ac.th/callback', // Adjust this URL
          authorizationEndpoint: 'https://erp.msu.ac.th/authen/api/authuser?progcode=TEST',
          responseType: 'code',
          requiredUrlParams: ['scope', 'state'],
          optionalUrlParams: ['access_type'],
          scope: ['profile'],
          scopeDelimiter: ' ',
          oauthType: '2.0',
          popupOptions: { width: 452, height: 633 }
        }
      }
    })

    nuxtApp.provide('vueAuth', vueAuth)
  }
})
*/