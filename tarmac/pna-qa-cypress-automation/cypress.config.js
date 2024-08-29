const { defineConfig } = require('cypress');
const {verifyDownloadTasks} = require('cy-verify-downloads');
const{downloadfile} = require('cypress-downloadfile/lib/addPlugin');
const xlsx = require("node-xlsx").default;
const fs = require("fs");
const { removeDirectory } = require('cypress-delete-downloads-folder');
const path = require("path");
const { beforeRunHook, afterRunHook } = require('cypress-mochawesome-reporter/lib');


module.exports = defineConfig({
  projectId: "ifto1a",
  chromeWebSecurity: false,
  viewportWidth: 1920,
  viewportHeight: 1080,
  failOnStatusCode: false,
  defaultCommandTimeout: 15000,
  responseTimeout: 60000,
  "reporter": "cypress-multi-reporters",
  "reporterOptions": {
    "reporterEnabled": "cypress-mochawesome-reporter, mocha-junit-reporter",
    "cypressMochawesomeReporterReporterOptions": {
      "reportDir": "cypress/reports",
      "charts": true,
      "reportPageTitle": "My Test Suite",
      "embeddedScreenshots": true,
      "inlineAssets": true
  },
  "mochaJunitReporterReporterOptions": {
    "mochaFile": "cypress/reports/junit/results-[hash].xml"
  }
},
"video": false,




  env: {
    url: "https://clientportal.test2.sullivancotter.com/signin",
    clientportal_username: "ZGVtb3VzZXIyQHN1bGxpdmFuY290dGVyLmNvbQ==",
    clientportal_password: "VGVzdDEyMyMx",
  },
   


  e2e: {

    //experimentalSessionAndOrigin: true,
    shareAcrossSpecs: true,
    //retries:2,
    baseUrl: "https://clientportal.test2.sullivancotter.com/",    //'https://pb.test2.sullivancotter.com//",


    setupNodeEvents(on, config) {
      require('cypress-mochawesome-reporter/plugin')(on);
      on('task', verifyDownloadTasks);
      on('task', {downloadfile} );
      on('task', { removeDirectory });
      on('task', {
        parseXlsx({filePath}) {
          return new Promise((resolve, reject) => {
            try {
              const jsonData = xlsx.parse(fs.readFileSync(filePath));
              resolve(jsonData);
            } catch (e) {
              reject(e);
            }
          });
        }
      })

      on("task", {
        isFileExist( filePath ) {
         return new Promise((resolve, reject) => {
           try {
             let isExists = fs.existsSync(filePath)
             resolve(isExists);
           } catch (e) {
             reject(e);
           }
         });
       }
     });

      
    },
    specPattern: 'cypress/e2e/**/**/*.js',
  },

});