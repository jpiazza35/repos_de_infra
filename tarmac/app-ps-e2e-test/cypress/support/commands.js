///<reference types="cypress"/>
const { b64Decode } = require("./decodeUtil")
import loginPage from '../pageObjects/LoginPage'
import homePage from '../pageObjects/HomePage'

const dayjs = require('dayjs')

Cypress.Commands.add('logintoPS2', () => {
    cy.visit(Cypress.config('baseUrl'))
    const decodedUsername = b64Decode(Cypress.env("ps2_username"));
    const decodedPassword = b64Decode(Cypress.env("ps2_password"));
    loginPage.login(decodedUsername, decodedPassword)
});

Cypress.Commands.add('logoutPS2', () => {
    homePage.logoutBtn().click();
});

Cypress.Commands.add('generateAccessToken', () => {
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
                "username": b64Decode(Cypress.env("ps2_username")),
                "password": b64Decode(Cypress.env("ps2_password")),
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
            const filePath = 'cypress/fixtures/00_Auth/auth_data.json';
            cy.readFile(filePath).then(existingAuthData => {
                const updatedAuthData = {...existingAuthData, ...tokenData};
                cy.writeFile(filePath, updatedAuthData);
                // cy.writeFile('cypress/fixtures/00_Auth/auth_data.json', {
                //     authToken: access_token,
                //     invalidToken: "cypress_invalid_token_test" + access_token,
                //     expiredToken: ""
                // })
            })
        })
    });


    Cypress.Commands.add('deleteTokens', () => {
        cy.fixture('00_Auth/auth_data.json').then((data) => {
            data.authToken = "";
            data.invalidToken = "";
            data.expiredToken = "";
            cy.writeFile('cypress/fixtures/00_Auth/auth_data.json', data);
        })
    });
