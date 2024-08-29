const { b64Decode } = require("./decodeUtil");
import loginPage from '../pageObjects/PNASupply/LoginPage'
import header from '../pageObjects/PNASupply/Header'
import pnaHomePage from '../pageObjects/PNASupply/PnaHomePage';
import manageEngmnt from '../pageObjects/Admin_ManageEngagement/ManageEngmnt';


const dayjs = require('dayjs')

require('cy-verify-downloads').addCustomCommand();
require('cypress-downloadfile/lib/downloadFileCommand');
require('cypress-delete-downloads-folder').addCustomCommand();

Cypress.Commands.add('userLogin', (username, password) => {
    const decodedUsername = b64Decode(username);
    const decodedPassword = b64Decode(password);
    loginPage.username().type(decodedUsername)
    loginPage.password().type(decodedPassword, { log: false })
    loginPage.submitBtn().click()

});

Cypress.Commands.add('logoutClientPortal', () => {
    header.logoutLink().click();
});


Cypress.Commands.add('navigateToPnaSupply', () => {
    pnaHomePage.physicianNeedsAssessment.should('contain', 'Provider Needs Assessment').click()
    pnaHomePage.appName.contains('Provider Needs Assessment')
    pnaHomePage.navBarPnaSupplyBtn.should('have.text', 'PNA Supply').click()

});

Cypress.Commands.add('navigateToAdmin', () => {
    pnaHomePage.physicianNeedsAssessment.should('contain', 'Provider Needs Assessment').click()
    manageEngmnt.adminDropDown().contains('Admin ').click()
})

// Parse excel data in json 
Cypress.Commands.add("parseXlsx", (inputFile) => {
    return cy.task('parseXlsx', { filePath: inputFile })
});

Cypress.Commands.add('listenToClickEventForDownload', () => {
    cy.window().document().then(function (doc) {
        doc.addEventListener('click', () => {
            setTimeout(function () { doc.location.reload() }, 2000)
        })
    })
});


Cypress.Commands.add('ExportValidation', (fileName, headerCount) => {
    cy.verifyDownload(fileName + '.xlsx', { timeout: 4000 });
    cy.parseXlsx("cypress/downloads/" + fileName + '.xlsx').then(
        jsonData => {
            expect(jsonData[0].data[0]).to.eqls(headerCount);
            expect(jsonData[0].data.length).to.be.greaterThan(1)
        })
});

Cypress.Commands.add('newEngagementName', () => {

    const uuid = () => Cypress._.random(0,1000)
    const id = uuid()
    const testname = `Regression ${id}`
    cy.get('#EngagementName').type(testname)

  //cy.writeFile('newEngagementName.txt', testname)
})
    




















