/// <reference types="Cypress" />
class HomePage {
    //sidebar section
    sidebarSection() {
        return cy.get('#sidebar-wrapper')
    }
    //footer section
    footerSection() {
        return cy.get('.page-footer')
    }
    //side bar navigation
    //get user logged in
    userLoggedIn() {
        return cy.get('.admin-info');
    }
    //project link
    projectLink() {
        return cy.get("a[href='/projects']")
    }
    //client portal link
    clientPortalLink() {
        return cy.get('.p-4.s-zbj9ugosj4HC')
    }
    appWindow() {
        return cy.get('#app')
    }
    //header section
    headerSection() {
        return cy.get('.header');
    }
    //company logo
    logo() {
        return cy.get('.mx-auto')
    }
    //product name
    productName() {
        return cy.get('.app-title')
    }
    productLogo() {
        return cy.get('.app-logo')
    }
    //collapsable siderbar toggle
    sidebarToggle() {
        return cy.get('#sidebarToggle')
    }
    //logout Link
    logoutLink() {
        return cy.get('[data-cy="dropdownLogout"]')
    }
    //user logged in
    userLoggedIn() {
        return cy.get('[data-cy="dropdownUser"]')
    }
}

const homePage = new HomePage();
export default homePage;
