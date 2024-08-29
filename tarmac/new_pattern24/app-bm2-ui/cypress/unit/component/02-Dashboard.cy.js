import dashboard from '../../pageObjects/dashboard'
import Dashboard from '../../../src/pages/homeDashboard/Dashboard.svelte'

describe('Dashboard Component testing', () => {
  let dashboardData
  let tileData
  beforeEach(() => {
    cy.fixture('dashboard')
      .as('dataFixture')
      .then(data => {
        dashboardData = data
      })
    cy.fixture('tile')
      .as('tileFixture')
      .then(data => {
        tileData = data
      })
    cy.mount(Dashboard)
  })

  it('01 - Should render topheader with Name and welcome message', () => {
    dashboard.getLandingContainer().should('be.visible')
    dashboard.getTopHeader().should('be.visible')
    dashboard.getTopHeaderMessage().should('be.visible')
    dashboard.getTopHeaderMessage().contains(dashboardData.welcomeMessage)
  })

  it('02 - Tutorial Button should be clicable', () => {
    dashboard.getTutorialButton().should('be.visible')
    dashboard.getTutorialButton().click({ multiple: true })
  })

  it('03 - Dashboard Physician section - Tiles rendering', () => {
    dashboard.getPhysicianSection().should('be.visible')
    dashboard.getPhysicianSection('h2').contains('Physician')
    dashboard.getPhysicianSection('.grid').children().should('have.length', 9)
    tileData.PHYSICIAN_TILES.forEach((tile, index) => {
      dashboard.getPhysicianSection('.grid').children().eq(index).should('be.visible')
      dashboard.getPhysicianSection('.grid').children().eq(index).should('contain.text', tile.title)
    })
  })

  it('04 - Dashboard APP section rendering', () => {
    dashboard.getAppSection().should('be.visible')
    dashboard.getAppSection('h2').contains('Advanced Practice Provider')
    dashboard.getAppSection('.grid').children().should('have.length', 2)
    tileData.ADVANCED_PRACTICE_PROVIDER_TILES.forEach((tile, index) => {
      dashboard.getAppSection('.grid').children().eq(index).should('be.visible')
      dashboard.getAppSection('.grid').children().eq(index).should('contain.text', tile.title)
    })
  })

  it('05 - Dashboard Other Studies section rendering', () => {
    dashboard.getOtherStudiesSection().should('be.visible')
    dashboard.getOtherStudiesSection('h2').contains('Other Studies')
    dashboard.getOtherStudiesSection('.grid').eq(0).should('have.length', 1)
  })
})
