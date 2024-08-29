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
    url: "https://ps.dev.cliniciannexus.com/",
    ps2_mock_data_username: "cHBtdC1kZXYtdXNlcjFAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_mock_data_password: "UFBNVFRlc3QxMjMjMQ==",
    ps2_real_data_dev_user1_name: "cHBtdC1kZXYtdXNlcjFAY2xpbmljaWFubmV4dXNzY2EuY29tCg==",
    ps2_real_data_dev_user1_password: "UFBNVFRlc3QxMjMjMQo=",
    ps2_real_data_dev_user5_name: "cHBtdC1kZXYtdXNlcjVAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_real_data_dev_user5_password: "UFBNVFRlc3QxMjMjMQ==",
    ps2_real_data_dev_user6_name: "cHBtdC1kZXYtdXNlcjZAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_real_data_dev_user6_password: "UFBNVFRlc3QxMjMjMQ==",
    ps2_real_data_dev_user9_name: "cHBtdC1kZXYtdXNlcjlAY2xpbmljaWFubmV4dXNzY2EuY29t",
    ps2_real_data_dev_user9_password: "UFBNVFRlc3QxMjMjMQ==",
    ps2_real_data_dev_user18_name: "cHBtdC1kZXYtdXNlcjE4QGNsaW5pY2lhbm5leHVzc2NhLmNvbQ==",
    ps2_real_data_dev_user18_password: "UFBNVFRlc3QxMjMjMQ==",
    api_base_url: 'https://ps.dev.cliniciannexus.com/',
    api_performance_url: "https://ps.dev.cliniciannexus.com/api/performance",
    api_settings_url: "https://ps.dev.cliniciannexus.com/api/settings",
    api_tenant_url: "https://ps.dev.cliniciannexus.com/api/tenant",
    auth0_url: 'https://dev-2nsl2cauo135yhdi.us.auth0.com/oauth/token',
    audience: 'https://ps-dev-api',
    client_id: 'v9tTP7puRZPYOG95jXlFOuxvS3dhWxo7',
    client_secret: '_8UJMmSfZ824GZ4vZshWzJp3OKMxS74HL9z25YnhivOr_0oiRlo-xRo3KfH_iOP0',
    scope: 'openid profile email',
    grant_type: 'password',
    enableRealData: 'on',
  },
  e2e: {
    baseUrl: "https://ps.dev.cliniciannexus.com/",
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    specPattern: 'cypress/e2e/specs/*/*/*.js',
  },
});
