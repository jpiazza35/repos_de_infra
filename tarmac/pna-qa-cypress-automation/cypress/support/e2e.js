
 //"use strict";
// import "./commands";
// import "./filterTestByTags";
// import 'cypress-mochawesome-reporter/register';


import "./commands";
import "./filterTestByTags";
import 'cypress-mochawesome-reporter/register';
require('@cypress/xpath');
import 'cypress-file-upload'
import 'fs'

Cypress.on("uncaught:exception", (err, runnable) => {
    return false;
  });

  Cypress.Commands.add('deleteDownloads', () => {
    //delete all files in the download directory:
    fs.readdirSync('./downloads').forEach((file) => {
        fs.unlinkSync(`./downloads/${file}`)
    })

})