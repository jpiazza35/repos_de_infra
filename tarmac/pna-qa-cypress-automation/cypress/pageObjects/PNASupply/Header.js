class Header {
  getHeader() {
    return cy.get('.header')
  }
  //logo
   logo() {
    return cy.get('.mainlogo');
  }
  //product name
   productName() {
    return cy.get('#productName');
  }
  //environment
   environment() {
    return cy.get('#envwatermark2');
  }
  //contact us
   contactUs() {
    return cy.get('#linkMailto');
  }
  //logout link
   logoutLink()
  {
    return cy.get('#lnkSignOut');
  }
  //user logged in
   userLoggedIn() {
    return cy.get('#welName');
  }
}
const header = new Header()
export default header