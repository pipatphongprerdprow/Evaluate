// src/authService.ts
import axios from 'axios';

const clientId = '9c283af5-56b1-4365-a3b2-b8cb69f22624';
const clientSecret = 'w0nAfUzaq8A3DV43PnJzJWxvrypI5yW9FqiuvE6f';
const redirectUri = 'https://e-office.msu.ac.th/main/callback';
const authUrl = 'https://erp.msu.ac.th/authen/oauth/_authorize?';
const endpointUrl = 'https://erp.msu.ac.th/authen/oauth/token';

class AuthService {
  getAuthorizationUrl() {
    const params = new URLSearchParams({
      client_id: clientId,
      client_secret: clientSecret,
      redirect_uri: redirectUri,
      response_type: 'code',
      scope: '', // Adjust scope as needed
      state: Math.random().toString(36).substring(2)
    });

    return `${authUrl}&${params.toString()}`;
  }

  async exchangeCodeForToken(code) {
    const tokenUrl = endpointUrl; // Replace with your token endpoint URL
    const params = new URLSearchParams({
      grant_type: 'authorization_code',
      code,
      redirect_uri: redirectUri,
      client_id: clientId,
      client_secret: clientSecret
    });

    try {
      const response = await axios.post(tokenUrl, params);
      return response.data;
    } catch (error) {
      console.error('Error exchanging code for token:', error);
      throw error;
    }
  }

  async refreshToken(refreshToken) {
    const tokenUrl = endpointUrl; // Replace with your token endpoint URL
    const params = new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
      client_id: clientId,
      client_secret: clientSecret
    });

    try {
      const response = await axios.post(tokenUrl, params);
      return response.data;
    } catch (error) {
      console.error('Error refreshing token:', error);
      throw error;
    }
  }
}

export default new AuthService();
