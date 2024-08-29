/// <reference types="Cypress" />
class HomePage {
    logoutBtn() {
        return cy.get('[data-cy="headerLogout"]')
    }
   
}

const homePage = new HomePage();
export default homePage;
