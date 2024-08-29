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
  },

  e2e: {
    baseUrl: "http://localhost:5173/",
    setupNodeEvents(on, config) {
    },
    specPattern: 'cypress/e2e/specs/*/*/*.js',
  },
});
