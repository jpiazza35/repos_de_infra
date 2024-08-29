import { defineConfig } from 'cypress'

export default defineConfig({
  projectId: '6zacwi',
  chromeWebSecurity: false,
  EdgeWebSecurity: false,
  viewportWidth: 1920,
  viewportHeight: 1080,
  defaultCommandTimeout: 15000,
  responseTimeout: 60000,
  env: {
    url: 'http://localhost:5173/',
    bm2_username: 'Y3lwcmVzcy10ZXN0LXVzZXJAY2xpbmljaWFubmV4dXNzY2EuY29t', // Change the value for the correct BM 2.0
    bm2_password: 'SGVsbG93b3JsZDEyMzQk',
    auth0_url: 'https://dev-2nsl2cauo135yhdi.us.auth0.com/oauth/token',
    api_base_url: 'http://localhost:10000',
    audience: 'https://ps-dev-api',
    client_id: 'v9tTP7puRZPYOG95jXlFOuxvS3dhWxo7',
    client_secret: '_8UJMmSfZ824GZ4vZshWzJp3OKMxS74HL9z25YnhivOr_0oiRlo-xRo3KfH_iOP0',
  },
  component: {
    specPattern: 'cypress/unit/component/*.js',
    devServer: {
      framework: 'svelte',
      bundler: 'vite',
    },
  },
  e2e: {
    baseUrl: 'http://localhost:5173',
    specPattern: 'cypress/e2e/*/*/*.js',
    devServer: {
      framework: 'svelte',
      bundler: 'vite',
    },
  },
})
