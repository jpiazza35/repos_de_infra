/// <reference types="Cypress" />
class LoginPage {

  signinLabel() {
    return cy.get('.heading');
  }
  username() {
    return cy.get('#UserName')
  }
  password() {
    return cy.get("[name='Password']");
  }
  submitBtn() {
    return cy.get("[type='submit']");
  }
  remembermeChkBox() {
    cy.get('.rememberme');
  }
  forgotPassword() {
    cy.get('.forgotyour');
  }
 

  login(username, password) {
    this.username().type(username);
    this.password().type(password);
    this.submitBtn().click();
  }

  open(url) {
    cy.visit(url);
  }
}
const loginPage = new LoginPage()
export default loginPage