import navbar from '../../pageObjects/navbar'
import Navbar from '../../../src/components/Navbar/Navbar.svelte'

describe('Navigation  Tests', () => {
  beforeEach(() => {
    cy.mount(Navbar)
  })

  it('01 - Should display the navigation bar', () => {
    navbar.getLandingNavbar().should('be.visible')
    navbar.getClientPortalContainer().should('be.visible')
  })

  it('02 - Mobile - Should open the sidebar when the hamburger button is clicked', () => {
    cy.viewport(375, 667)
    cy.wait(500)
    navbar.getBtnOpenSidebar().should('be.visible')
    navbar.getBtnOpenSidebar().click()
  })

  it('03 - Should toggle the user dropdown menu', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getDropdownUser().should('be.visible')
  })

  it('04 - Should Click on Client Porta and redirect to the right link', () => {
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

  it('06 - Dropdown user info values should be shown', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getUserProfile().should('be.visible')
    navbar.getUserProfileEmail().should('be.visible')
    navbar.getProfileUsername().should('be.visible')
    navbar.getUserProfileName().should('be.visible')
    navbar.getProfilePicture().should('be.visible')
  })

  it('07 - Emulate button click', () => {
    navbar.getEmulateButton().should('be.visible')
    navbar.getEmulateButton().click()
  })
})
