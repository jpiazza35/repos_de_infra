const { defineConfig } = require("cypress");

module.exports = defineConfig({
  projectId: '595adh',
  chromeWebSecurity: false,
  EdgeWebSecurity: false,
  viewportWidth: 1920,
  viewportHeight: 1080,
  //Mobile Resolution
  // viewportWidth:414,
  // viewportHeight:896,
  defaultCommandTimeout: 15000,
  responseTimeout: 60000,

  env: {
    url: "http://localhost:5173/",
    ps2_username: "Y3lwcmVzcy10ZXN0LXVzZXJAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_password: "SGVsbG93b3JsZDEyMzQk",
    api_base_url: 'http://localhost:10000',
    api_performance_url: "https://localhost:10000/api/performance/",
    auth0_url: 'https://dev-2nsl2cauo135yhdi.us.auth0.com/oauth/token',
    audience: 'https://ps-dev-api',
    client_id: 'v9tTP7puRZPYOG95jXlFOuxvS3dhWxo7',
    client_secret: '_8UJMmSfZ824GZ4vZshWzJp3OKMxS74HL9z25YnhivOr_0oiRlo-xRo3KfH_iOP0',
    scope: 'openid profile email',
    grant_type: 'password',
  },
  e2e: {
    baseUrl: "http://localhost:5173/",
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    specPattern: 'cypress/e2e/specs/*/*/*.js',
  },
});
