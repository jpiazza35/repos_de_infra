//TODO: take them from env variables AUTH0_DOMAIN and AUTH0_CLIENTID
const config = {
  domain: import.meta.env.VITE_AUTH0_DOMAIN,
  clientId: import.meta.env.VITE_AUTH0_CLIENTID,
  audience: import.meta.env.VITE_AUTH0_AUDIENCE,
}

export default config
