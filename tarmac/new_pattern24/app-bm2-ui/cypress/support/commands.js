// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
import { b64Decode } from './decodeUtil'
import loginPage from '../pageObjects/loginPage'
import dashboard from '../pageObjects/dashboard'

Cypress.Commands.add('logintoBM2', () => {
  cy.visit(Cypress.config('baseUrl'))
  const decodedUsername = b64Decode(Cypress.env('bm2_username'))
  const decodedPassword = b64Decode(Cypress.env('bm2_password'))
  loginPage.login(decodedUsername, decodedPassword)
})

Cypress.Commands.add('logoutBM2', () => {
  homePage.logoutBtn().click()
})

Cypress.Commands.add('generateToken', () => {
  const options = {
    method: 'POST',
    url: Cypress.env('auth0_url'),
    body: {
      scope: 'openid profile email',
      grant_type: 'password',
      username: b64Decode(Cypress.env('bm2_username')),
      password: b64Decode(Cypress.env('bm2_password')),
      audience: Cypress.env('audience'),
      client_id: Cypress.env('client_id'),
      client_secret: Cypress.env('client_secret'),
    },
  }
  cy.request(options).then(function (response) {
    cy.log(response.body.access_token)
    Cypress.env('token', response.body.access_token)
  })
})

Cypress.Commands.add('deleteToken', () => {
  Cypress.env('token', '')
})
