import { NuxtAuthHandler } from '#auth'
// import GoogleProvider from 'next-auth/providers/google'
// import { randomBytes } from "crypto" 

// function generateState() {
//   return randomBytes(16).toString("hex");  // Generates a random 16-byte string
// }

export default NuxtAuthHandler({
  secret: 'R31FG8G33cBnW7PrmEGj4SHeDV3cBs0rXTIDQDLdT3s=',
  // pages: {
  //   signIn: '/signin'
  // },
  providers: [
    // GoogleProvider.default({
    //   clientId: process.env.GOOGLE_CLIENT_ID,
    //   clientSecret: process.env.GOOGLE_CLIENT_SECRET
    // }),
    {
      id: 'erpauth',  
      name: 'erpauth', 
      type: 'oauth',

      // OAuth 2.0 flow endpoints
      authorization: {
        url: 'https://erp.msu.ac.th/authen/oauth/_authorize',
        params: {
          grant_type: "authorization_code",
          response_type: 'code',
          redirect_uri: 'https://localhost:3000/evaluate/api/auth/callback/erpauth',
          scope: '',
        }
      },
      token: 'https://erp.msu.ac.th/authen/oauth/token',  // Token endpoint
      userinfo: 'https://erp.msu.ac.th/authen/api/authuserinfo?progcode=parcelapp',  // User info endpoint

      // Client ID and secret for the custom provider, from environment variables
      clientId: '9cf535e9-c4cf-48cc-9598-0a99d4a1af62',
      clientSecret: 'JhXQaDxzH69KWjmz1cqtlcAiwRu8VY2FYwkqaGlZ',

      // Function to extract the profile information from the userinfo response
      profile(profile) {
        // console.log(profile);

        const {STAFFID, STAFFNAME, STAFFSURNAME, STAFFEMAIL1} = profile.user
        
        return {
          id: STAFFID,           // Unique identifier
          name: `${STAFFNAME} ${STAFFSURNAME}`,        // User's name
          email: STAFFEMAIL1,      // User's email
          image: STAFFID ,
          ...profile.user
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
          ...user
        }
      }

      return Promise.resolve(token);
    },
    session: async ({session, token, user}) => {
      session.providerInfo = token?.providerInfo;

      return Promise.resolve({ ...session});
    }
  }
})