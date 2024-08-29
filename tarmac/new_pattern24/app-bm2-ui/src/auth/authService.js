import { createAuth0Client } from '@auth0/auth0-spa-js'
import config from 'auth/authConfig'

const redirectLocation = window.location.origin + '/callback'
let auth0Client = null

async function createClient() {
  auth0Client = await createAuth0Client({
    domain: config.domain,
    clientId: config.clientId,
    authorizationParams: {
      redirect_uri: redirectLocation,
      audience: config.audience,
      scope: 'openid profile email offline_access',
    },
    useRefreshTokens: true,
    cacheLocation: 'localstorage',
  })
  return auth0Client
}

function logout() {
  return auth0Client.logout()
}

async function getUserInfo() {
  const user = await auth0Client.getUser()
  return user.name
}

const auth = {
  createClient,
  logout,
  getUserInfo,
}

export default auth
