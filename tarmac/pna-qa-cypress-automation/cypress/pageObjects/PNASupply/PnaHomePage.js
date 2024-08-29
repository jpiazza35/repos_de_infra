class PnaHomePage {

get physicianNeedsAssessment() {
    return  cy.get('[data-url="https://pna.test2.sullivancotter.com/"] > .appboxText > .mid')
}

get appName() {
    return cy.get('#productName')
}

get announcementMessage() {
    return cy.get('#divAnnouncements > .box > section > p')
}

get navBarHomeBtn() {
    return cy.get('.nav > :nth-child(1) > a')
}

get navBarPnaSupplyBtn() {
    return cy.get('.nav > :nth-child(2) > a')
}

get navBarReporting() {
    return cy.get(':nth-child(3) > .dropdown-toggle')
}

get navBarAdmin() {
    return cy.get(':nth-child(4) > .dropdown-toggle')
}

get navBarMyProfile() {
    return cy.get(':nth-child(5) > .dropdown-toggle')
}

get breadcrumbHome() {
    return cy.get('#breadcrumb > :nth-child(2)')
}

get announcement() {
    return cy.get('#divAnnouncements > .box > header > h2')
}

get signOut() {
    return cy.get('#lnkSignOut')
}









}
const pnaHomePage = new PnaHomePage()
export default pnaHomePage