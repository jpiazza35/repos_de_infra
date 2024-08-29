import navbar from '../../../pageObjects/navbar'

describe('BM 2.0 - Navbar E2E tests', () => {
  let dashboardData
  beforeEach(() => {
    cy.fixture('dashboard')
      .as('dataFixture')
      .then(data => {
        dashboardData = data
      })
    cy.visit('/')
  })

  it('01 - Rendering navbar within all the content on that', function () {
    navbar.getLandingNavbar().should('be.visible')
    navbar.getClientPortalContainer().should('be.visible')
    navbar.getClientPortalLink().should('be.visible')
    navbar.getLogoSidebar().should('be.visible')
    navbar.getBtnDropdownUser().should('be.visible')
    navbar.getEmulateButton().should('be.visible')
    navbar.getProfileUsername().should('be.visible')
  })

  it('02 - Should click on Emulate button', () => {
    navbar.getEmulateButton().should('be.visible')
    navbar.getEmulateButton().click()
  })

  it('03 - Should click on Sulivan logo', () => {
    navbar.getLogoSulivan().should('be.visible')
    navbar.getLogoSulivan().should('be.visible')
    cy.get('[data-cy="tile-physician-marketReport"]').as('marketReportTile')
    cy.get('@marketReportTile').should('be.visible')
    cy.get('@marketReportTile').click()
    cy.url().should('include', 'physician/marketReport')
    navbar.getLogoSulivan().click()
    cy.url().should('not.include', 'physician/marketReport')
  })

  it('04 - Should Click on Client Portal and redirect to the right link', () => {
    navbar.getClientPortalContainer().should('be.visible')
    navbar.getClientPortalLink().contains('Client Portal')
    navbar.getClientPortalLink().should('have.attr', 'href')
    navbar.getClientPortalLink().should('have.attr', 'href').and('contains', 'https://clientportal.dev2.sullivancotter.com/Home/HomePage')
    // navbar.getClientPortalLink().click()
  })

  it('05 - Should allow click in the options of profile dropdown', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getUserProfile().should('be.visible')
    navbar.getProfileSettings().click()
    navbar.getNotificationSettings().click()
    navbar.getProfileLogout().click()
  })

  it('06 - Should click on profile dropdown and check it properties', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getUserProfile().should('be.visible')
    navbar.getUserProfileEmail().should('be.visible')
    navbar.getProfileUsername().should('be.visible')
    navbar.getUserProfileName().should('be.visible')
    navbar.getProfilePicture().should('be.visible')

    navbar.getProfileSettings().should('be.visible').and('include.text', 'Account Settings')
    navbar.getProfileEditSettings().should('be.visible').and('include.text', 'Edit my profile')
    navbar.getNotificationSettings().should('be.visible').and('include.text', 'Notification Settings')
    navbar.getProfileLogout().should('be.visible').and('include.text', 'Log out')
  })
  it('07 - Should click on profile dropdown and check it email and username', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getUserProfile().should('be.visible')
    navbar.getUserProfileEmail().should('be.visible').and('have.text', 'john.snow@cliniciannexus.com')
    navbar.getProfileUsername().should('be.visible').and('have.text', 'JS')
    navbar.getUserProfileName().should('be.visible').and('have.text', 'John Snow')
    navbar.getProfilePicture().should('be.visible')
  })
})
