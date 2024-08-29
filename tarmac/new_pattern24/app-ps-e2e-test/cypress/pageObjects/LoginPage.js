/// <reference types="Cypress" />
class LoginPage {
    username() {
        return cy.get('#username')
    }
    password() {
        return cy.get('#password')
    }
    signInBtn() {
        return cy.get('.ca1220cdf > .c5a3db861')
    }
    continueBtn() {
        return cy.get('.c5a3db861')
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