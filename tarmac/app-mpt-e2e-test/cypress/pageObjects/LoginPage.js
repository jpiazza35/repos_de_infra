/// <reference types="Cypress" />
class LoginPage {
  username() {
    return cy.get("#signInName");
  }
  password() {
    return cy.get("#password");
  }
  signInBtn() {
    return cy.get("#next");
  }
  //login 
  login(username, password) {
    this.username().wait(2000).type(username);
    this.password().type(password);
    this.signInBtn().click();
  }
}

const loginPage = new LoginPage();
export default loginPage;