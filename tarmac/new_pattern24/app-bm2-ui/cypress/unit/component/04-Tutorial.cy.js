import dashboard from '../../pageObjects/dashboard'
import Dashboard from '../../../src/pages/homeDashboard/Dashboard.svelte'

describe('Tutorial Component testing', () => {
  beforeEach(() => {
    cy.mount(Dashboard)
  })

  it('01 - Should render Tutorial button on dashboard', () => {
    dashboard.getTutorialButton().should('be.visible')
  })

  it('02 - Tutorial Button should be clicable', () => {
    dashboard.getTutorialButton().should('be.visible')
    dashboard.getTutorialButton().click()
  })

  it('03 - Tutorial Button - Mount tutorial Modal', () => {
    dashboard.getTutorialButton().should('be.visible')
    dashboard.getTutorialButton().click()
    dashboard.getTutorialModal().should('be.visible')
    dashboard.getFakeTutorialButton().should('be.visible')
    dashboard.getTopHeader().should('be.visible')
    dashboard.getTutorialDownloadButton().should('be.visible')
    dashboard.getTutorialCloseButton().should('be.visible')
    dashboard.getTutorialCloseButton().click()
  })
})
