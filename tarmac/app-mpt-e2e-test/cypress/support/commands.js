///<reference types="cypress"/>
const { b64Decode } = require("./decodeUtil")
import loginPage from '../pageObjects/LoginPage'
import homePage from '../pageObjects/HomePage'
import fs from 'fs';
import path from 'path';

const dayjs = require('dayjs')

require('cy-verify-downloads').addCustomCommand();
require('cypress-downloadfile/lib/downloadFileCommand')

Cypress.Commands.add('logintoMPT', () => {
  cy.intercept({
    method: 'GET',
    url: Cypress.env("azureb2c_url") + '**'
  }).as('auth')

  // assert that the request was intercepted
  cy.visit(Cypress.config('baseUrl') + Cypress.env("azureb2c_domainhint"))
  cy.get("body").then($body => {
    if ($body.find("h3.app-title").length == 0) {
      cy.wait('@auth').then(xhr => {
        expect(xhr.request.url).to.contain(Cypress.env("azureb2c_url"))
      })
      const decodedUsername = b64Decode(Cypress.env("mpt_username"));
      const decodedPassword = b64Decode(Cypress.env("mpt_password"));
      loginPage.login(decodedUsername, decodedPassword)
    }
  })
  cy.wait(2000)
  //capture the url and visit that as else it is getting stuck in bad request page
  cy.url().then((url) => {
    cy.visit(url)
  })
});

Cypress.Commands.add('logoutMPT', () => {
  homePage.userLoggedIn().click({ force: true });
  homePage.logoutLink().click({ force: true }).wait(1000);
});

Cypress.Commands.add('generateAccessToken', () => {
  cy.request(
    {
      method: 'POST',
      form: true,
      url: Cypress.env('azureb2c_api_url'),
      homePages: {
        'Content-Type': 'application/json',
      },
      body: {
        "username": b64Decode(Cypress.env("mpt_username")),
        "password": b64Decode(Cypress.env("mpt_password")),
        "grant_type": Cypress.env('grant_type'),
        "scope": Cypress.env('scope'),
        "client_id": Cypress.env('client_id'),
        "reponse_type": Cypress.env('response_type')
      }
    }).then((res) => {
      expect(res.status).to.eq(200);
      const response = res.body
      expect(response).to.have.property('access_token')
      expect(response).to.have.property('refresh_token')
      expect(response).to.have.property('token_type')
      // expect(response).to.have.property('id_token')
      const access_token = response.access_token;
      const refresh_token = response.refresh_token;
      const token_type = response.token_type
      // const id_token = response.id_token;
      cy.writeFile('cypress/fixtures/Auth/auth_data.json', {
        accessToken: token_type + " " + access_token,
        refreshToken: refresh_token
      })
    })
});

Cypress.Commands.add('writeToFixture', (filename, data) => {
  const filePath = `cypress/fixtures/${filename}`;
  return fs.writeFile(filePath, JSON.stringify(data)).then(() => {
    cy.log(`Data written to ${filename}`);
  })
});

//homePage verification
Cypress.Commands.add('headerValidation', () => {
  //verify logo
  homePage.logo().should('be.visible')
  //verify product name and logo should not be visible as sidebar is hidden by default
  homePage.productName().should('not.be.visible')
  homePage.productLogo().should('not.be.visible')
  //verify sidebar toggle
  homePage.sidebarToggle().should('be.visible')
  //verify user logged in
  homePage.userLoggedIn().should('be.visible').should('contain', 'MPT UAT Demo User 01')
});

//Footer Validation
Cypress.Commands.add('footerValidation', () => {
  //Footer validation
  homePage.appWindow().scrollTo('bottom')
  homePage.footerSection().within(() => {
    //Save current year to a variable
    const cyear = dayjs().format('YYYY')
    //© 2023 SullivanCotter
    cy.contains('© ' + cyear + ' Sullivan Cotter. All rights reserved.').should('be.visible')
    cy.contains('Terms')
    cy.contains('Privacy Policy')
    cy.contains('Version:')
  })
});
//Parse excel data in json 
Cypress.Commands.add("parseXlsx", (inputFile) => {
  return cy.task('parseXlsx', { filePath: inputFile })
});

Cypress.Commands.add('exportPageLoadEvents', () => {
  cy.window().then(win => {
    const triggerAutIframeLoad = () => {
      const AUT_IFRAME_SELECTOR = '.aut-iframe';

      // get the application iframe
      const autIframe = win.parent.document.querySelector(AUT_IFRAME_SELECTOR);

      if (!autIframe) {
        throw new ReferenceError(`Failed to get the application frame using the selector '${AUT_IFRAME_SELECTOR}'`);
      }

      autIframe.dispatchEvent(new Event('load'));
      // remove the event listener to prevent it from firing the load event before each next unload (basically before each successive test)
      win.removeEventListener('beforeunload', triggerAutIframeLoad);
    }

    win.addEventListener('beforeunload', triggerAutIframeLoad);
  })
});

Cypress.Commands.add('deleteTokens', () => {
  cy.fixture('Auth/auth_data.json').then((data) => {
    data.accessToken = "";
    data.refreshToken = "";
    cy.writeFile('cypress/fixtures/Auth/auth_data.json', data);
  })
});

Cypress.Commands.add('selectOrg', (orgId, orgName) => {
  cy.get('[data-cy="organization"]').last().click({ scrollBehavior: false }).clear({ scrollBehavior: false }).type(orgId, { scrollBehavior: false })
  cy.get('ul[id=autocomplete-items-list]').within(() => {
    cy.contains(orgName).click()
  })
});

Cypress.Commands.add('validateCsvFile', (partialFilename, expectedRowCount, expectedHeaders) => {
  // Custom task to read the downloads folder
  cy.task('readDownloadsFolder', { partialFilename }).then((matchedFiles) => {
    expect(matchedFiles.length).to.be.greaterThan(0, `No file found with partial filename: ${partialFilename}`);

    const filename = matchedFiles[0]; // Assuming there's only one matching file

    // Custom task to get the CSV row count
    cy.task('getCsvRowCount', { filename }).then((rowCount) => {
      expect(rowCount).to.be.gte(expectedRowCount);

      // Custom task to get the CSV column headers
      cy.task('getCsvHeaderNames', { filename }).then((headerNames) => {
        expect(headerNames).to.deep.equal(expectedHeaders);
      });
    });
  });
});

Cypress.Commands.add('verifyCsvData', (partialFilename, expectedFirstRow, expectedLastRow) => {
  // Custom task to read the downloads folder
  cy.task('readDownloadsFolder', { partialFilename }).then((matchedFiles) => {
    expect(matchedFiles.length).to.be.greaterThan(0, `No file found with partial filename: ${partialFilename}`);
    const filename = matchedFiles[0]; // Assuming there's only one matching file
    // Custom task to read the CSV data
    cy.task('readCsvData', { filename }).then((csvData) => {
      const firstRow = csvData[0];
      const lastRow = csvData[csvData.length - 1];
      const firstRowString = JSON.stringify(firstRow);
      const lastRowString = JSON.stringify(lastRow);
      expect(firstRowString).to.include(expectedFirstRow);
      expect(lastRowString).to.include(expectedLastRow);
    });
  });
});
// Custom command to validate the state of a button
// It takes in a array with the name of the button and expected state of the button
Cypress.Commands.add('validateButtonStates', (buttons) => {
  buttons.forEach((button) => {
    cy.contains(button.name)
      .should('be.visible')
      .and(button.expectedState === 'enabled' ? 'not.be.disabled' : 'be.disabled');
  });
});

// as the element has multiple text nodes and Cypress trim the spaces properly
Cypress.Commands.add('trimmedText', { prevSubject: true }, subject => {
  return new Promise(resolve => {
    resolve(subject.text().replace(/\s+/g, ' ').trim())
  })
});




