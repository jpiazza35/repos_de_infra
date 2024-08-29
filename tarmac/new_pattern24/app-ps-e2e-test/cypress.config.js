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
    ps2_mock_data_url: "https://ps.qa.cliniciannexus.com/",
    ps2_real_data_fy_url: "https://ps.qa.cliniciannexus.com/dashboard/?dashboard_key=3",
    ps2_real_data_cy_url: "https://ps.qa.cliniciannexus.com/dashboard/?dashboard_key=1",
    ps2_mock_data_username: "Y3lwcmVzcy10ZXN0LXVzZXJAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_mock_data_password: "SGVsbG93b3JsZDEyMzQk",
    ps2_real_data_fy_username: "cHBtdC1kZXYtdXNlcjJAY2xpbmljaWFubmV4dXNzY2EuY29t==",
    ps2_real_data_fy_password: "UFBNVFRlc3QxMjMjMQ==",
    ps2_real_data_cy_username: "cHBtdC1kZXYtdXNlcjEzQGNsaW5pY2lhbm5leHVzc2NhLmNvbQ==",
    ps2_real_data_cy_password: "UFBNVFRlc3QxMjMjMQ==",
    api_base_url: 'https://ps.qa.cliniciannexus.com/',
    api_performance_url: "https://ps.qa.cliniciannexus.com/api/performance",
    api_productivity_url: "https://ps.qa.cliniciannexus.com/api/productivity",
    api_settings_url: "https://ps.qa.cliniciannexus.com/api/settings",
    api_tenant_url: "https://ps.qa.cliniciannexus.com/api/tenant",
    auth0_url: 'https://dev-2nsl2cauo135yhdi.us.auth0.com/oauth/token',
    audience: 'https://ps-dev-api',
    client_id: 'v9tTP7puRZPYOG95jXlFOuxvS3dhWxo7',
    client_secret: '_8UJMmSfZ824GZ4vZshWzJp3OKMxS74HL9z25YnhivOr_0oiRlo-xRo3KfH_iOP0',
    scope: 'openid profile email',
    grant_type: 'password',
    enableRealData: 'off',
    reportingPeriod: 'calendar',
  },
  e2e: {
    baseUrl: "https://ps.qa.cliniciannexus.com/",
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    specPattern: 'cypress/e2e/specs/*/*/*.js',

    //exclude specs
    excludeSpecPattern: [
      'cypress/e2e/specs/API/03_Performance/*.spec.js',
      'cypress/e2e/specs/UI/02_Performance/*.spec.js',
    ],
  },
});
