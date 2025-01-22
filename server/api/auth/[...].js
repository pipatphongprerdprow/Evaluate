import { NuxtAuthHandler } from '#auth'
import GoogleProvider from 'next-auth/providers/google'
import { randomBytes } from "crypto" 

function generateState() {
  return randomBytes(16).toString("hex");  // Generates a random 16-byte string
}

export default NuxtAuthHandler({
  secret: process.env.AUTH_SECRET || 'R31FG8G33cBnW7PrmEGj4SHeDV3cBs0rXTIDQDLdT3s=',
  // pages: {
  //   signIn: '/signin'
  // },
  providers: [
    GoogleProvider.default({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET
    }),
    {
      id: 'custom-oauth',  
      name: 'Custom OAuth', 
      type: 'oauth',

      // OAuth 2.0 flow endpoints
      authorization: {
        url: 'https://erp.msu.ac.th/authen/oauth/_authorize',
        params: {
          state: generateState(),
          client_id: '9e054c96-e655-4e11-90b4-24092280b0bb',
          response_type: 'code',
          redirect_uri: 'http://localhost:3000/evaluate/api/auth/callback/custom-oauth',
          scope: '',
        }
      },
      token: 'https://erp.msu.ac.th/authen/oauth/token',  // Token endpoint
      userinfo: 'https://erp.msu.ac.th/authen/api/authuser',  // User info endpoint

      // Client ID and secret for the custom provider, from environment variables
      clientId: '9e054c96-e655-4e11-90b4-24092280b0bb',
      clientSecret: 'uDgyytgePE3hlFIV0Xm9TBwzIfpSEqhPs43h8GdY',

      // Function to extract the profile information from the userinfo response
      profile(profile) {
        console.log(profile);
        
        return {
          id: profile.STAFFID,           // Unique identifier
          name: profile,//`${profile.PREFIXFULLNAME}${profile.STAFFNAME} ${profile.STAFFSURNAME}`,        // User's name
          email: (profile.STAFFEMAIL1??profile.STAFFEMAIL2)??'',      // User's email
          //image: profile ,
        }
      }
    }
  ],
  session: {
    strategy: 'jwt'
  },
  callbacks: {
    jwt: async ({ token, user, account, profile }) => {
      if (user?.email) {
        token.providerInfo = {
          provider: account?.provider,
          access_token: account?.access_token,
          expire_at: account?.expires_at,
          refresh_token: account?.refresh_token,
          //...user
        }

        token.name = profile
      }

      return Promise.resolve(token);
    },
    session: async ({session, token, user}) => {
      session.providerInfo = token?.providerInfo;

      return Promise.resolve({ ...session});
    }
  }
})