class LoginPage {
  username() {
    return cy.get('#username')
  }
  password() {
    return cy.get('#password')
  }
  signInBtn() {
    return cy.get('.c6d5cc3be > .ce7494284')
  }
  continueBtn() {
    return cy.get('button[data-action-button-primary="true"]')
  }
  loginMsg() {
    return cy.get('.c9a2292aa > .c74028152')
  }

  login(username, password) {
    this.username().type(username)
    this.continueBtn().click()
    this.password().type(password)
    this.continueBtn().click()
  }
}

const loginPage = new LoginPage()
export default loginPage
