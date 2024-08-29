///<reference types="cypress"/>
const { b64Decode } = require("./decodeUtil")
import loginPage from '../pageObjects/LoginPage'
import homePage from '../pageObjects/HomePage'
import performDashboardFilters from '../pageObjects/02_Performance/PerformanceDashboardFilters'

const dayjs = require('dayjs')

// Cypress.Commands.add('logintoPS2', () => {
//     cy.visit(Cypress.config('baseUrl'))
//     const decodedUsername = b64Decode(Cypress.env("ps2_username"));
//     const decodedPassword = b64Decode(Cypress.env("ps2_password"));
//     loginPage.login(decodedUsername, decodedPassword)
// });


// const enableRealData = Cypress.env("enableRealData");
Cypress.Commands.add('getUserDetails', (enableRealData, reportingPeriod) => {
    let username;
    let password;
    let url;
    if (enableRealData == 'off') {
        username = b64Decode(Cypress.env("ps2_mock_data_username")).trim();
        password = b64Decode(Cypress.env("ps2_mock_data_password")).trim();
        url = Cypress.env('ps2_mock_data_url');
    } else if (enableRealData == 'on' && reportingPeriod == 'fiscal') {
        username = b64Decode(Cypress.env("ps2_real_data_fy_username")).trim();
        password = b64Decode(Cypress.env("ps2_real_data_fy_password")).trim();
        url = Cypress.env('ps2_real_data_fy_url');
    } else if (enableRealData == 'on' && reportingPeriod == 'calendar') {
        username = b64Decode(Cypress.env("ps2_real_data_cy_username")).trim();
        password = b64Decode(Cypress.env("ps2_real_data_cy_password")).trim();
        url = Cypress.env('ps2_real_data_cy_url');
    }
    else {
        throw new Error(`Invalid falg: ${enableRealData}`);
    }
    return { username, password, url };
});

Cypress.Commands.add('logintoPS2', (username, password, url) => {
    cy.visit(url)
    loginPage.login(username, password);
});

Cypress.Commands.add('logoutPS2', () => {
    homePage.logoutBtn().click();
});

Cypress.Commands.add('generateAccessToken', (username, password) => {
    cy.request(
        {
            method: 'POST',
            form: true,
            url: Cypress.env('auth0_url'),
            homePages: {
                'Content-Type': 'application/json',
            },
            body: {
                "scope": Cypress.env('scope'),
                "grant_type": Cypress.env('grant_type'),
                "username": username,
                "password": password,
                "audience": Cypress.env('audience'),
                "client_id": Cypress.env('client_id'),
                "client_secret": Cypress.env('client_secret')
            }
        }).then((res) => {
            expect(res.status).to.eq(200);
            const response = res.body
            expect(response).to.have.property('access_token')
            const access_token = response.access_token;
            const tokenData = {
                authToken: access_token,
                invalidToken: "cypress_invalid_token_test" + access_token,
                expiredToken: ""
            };
            const filePath = 'cypress/fixtures/API/00_Tenant/auth_data.json';
            cy.readFile(filePath).then(existingAuthData => {
                const updatedAuthData = { ...existingAuthData, ...tokenData };
                cy.writeFile(filePath, updatedAuthData);
            })
        })
});


Cypress.Commands.add('deleteTokens', () => {
    cy.fixture('API/00_Tenant/auth_data.json').then((data) => {
        data.authToken = "";
        data.invalidToken = "";
        data.expiredToken = "";
        cy.writeFile('cypress/fixtures/API/00_Tenant/auth_data.json', data);
    })
});

Cypress.Commands.add('fiscalYearFilterJuly2022', () => {
    performDashboardFilters.periodButton().click()
    performDashboardFilters.FY2023Button().click({ force: true })
    performDashboardFilters.periodMonthButton().click({ force: true })
    performDashboardFilters.monthYear().eq(0).click()
    performDashboardFilters.applyPeriodButton().click()
});
