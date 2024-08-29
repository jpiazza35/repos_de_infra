/// <reference types="Cypress" />
class LoginPage {
    username() {
        return cy.get('#username')
    }
    password() {
        return cy.get('#password')
    }
    signInBtn() {
       
        //return cy.get('.cb67fd47b > .ceca60d4e')
        return cy.get('.cc6121580 > .c14249a2a')
    }
    continueBtn() {
        //return cy.get('.ceca60d4e')
        return cy.get('.c14249a2a')
        
    }
    loginMsg() {
        return cy.get('.c9a2292aa > .c74028152')
    }
    //login 
    login(username, password) {
        this.username().type(username);
        this.continueBtn().click()
        this.password().type(password);
        this.signInBtn().click()
        cy.intercept('post', '**/oauth/token').as('token')
        cy.wait(3000)
        // cy.wait('@token').then((xhr) => {
        //     expect(xhr.response.statusCode).to.equal(200)
        // })
    }
}

const loginPage = new LoginPage();
export default loginPage;