const { defineConfig } = require("cypress");
const { verifyDownloadTasks } = require('cy-verify-downloads');
const { downloadfile } = require('cypress-downloadfile/lib/addPlugin')
const xlsx = require('node-xlsx').default; //these 3 are for parsing the excel file
const fs = require('fs'); // for file
const path = require('path'); // for file path

module.exports = defineConfig({
  projectId: '7didr9',
  chromeWebSecurity: false,
  viewportWidth: 1920,
  viewportHeight: 1080,
  defaultCommandTimeout: 15000,
  responseTimeout: 60000,

  env: {
    url: "http://localhost:5173/", 
    azureb2c_url: "https://auth.dev.cliniciannexus.com/",
    azureb2c_domainhint: "?domainhint=cliniciannexusb2cdev.onmicrosoft.com",
    mpt_username: "bXB1YXRwMUBjbGluaWNpYW5uZXh1c2IyY2Rldi5vbm1pY3Jvc29mdC5jb20=",
    mpt_password: "azc4ZGhxQ2tWeERXTHpNOQ==",
    azureb2c_api_url:"https://auth.dev.cliniciannexus.com/688818c9-34fd-4789-9a6a-1544d58f5ea8/B2C_1A_CN_ROPC/oauth2/v2.0/token",
    grant_type:"password",
    scope:"openid offline_access https://api.dev.cliniciannexus.com/cn-generic-api/api.access", //'openid' required. Add 'offline_access' to obtain a refresh token
    client_id:"bc243b8f-1aae-4490-9819-ee940bcf8743", //client id for the automation tools app in dev
    response_type:"token id_token" //what tokens to receive. token=access_token, id_token=ID Token
  },

  e2e: {
    baseUrl: "http://localhost:5173/",
    setupNodeEvents(on, config) {
      on('task', verifyDownloadTasks)
      on('task', { downloadfile })
      on("task", {
        parseXlsx({ filePath }) {
          return new Promise((resolve, reject) => {
            try {
              const jsonData = xlsx.parse(fs.readFileSync(filePath));
              resolve(jsonData);
            } catch (e) {
              reject(e);
            }
          });
        }
      });
    },
    specPattern: 'cypress/e2e/specs/*/*/*.js',
  },

  component: {
    devServer: {
      framework: "svelte",
      bundler: "vite",
    },
  },
});
