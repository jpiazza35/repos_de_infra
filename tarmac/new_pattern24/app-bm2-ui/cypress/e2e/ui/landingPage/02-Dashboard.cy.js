import dashboard from '../../../pageObjects/dashboard'

describe('BM 2.0 - Dashboard E2E tests', () => {
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
    cy.visit('/')
  })

  it('01 - Rendering landing page', function () {
    dashboard.getLandingContainer().should('be.visible')
    dashboard.getTopHeader().should('be.visible')
    dashboard.getTopHeaderMessage().should('be.visible')
    dashboard.getTopHeaderMessage().contains(dashboardData.welcomeMessage)
    dashboard.getFooter().should('be.visible')
  })

  it('02 - Dashboard Physician section - Tiles rendering', () => {
    dashboard.getPhysicianSection().should('be.visible')
    dashboard.getPhysicianSection('h2').contains('Physician')
    dashboard.getPhysicianSection('.grid').children().should('have.length', 9)
    tileData.PHYSICIAN_TILES.forEach((tile, index) => {
      dashboard.getPhysicianSection('.grid').children().eq(index).should('be.visible')
      dashboard.getPhysicianSection('.grid').children().eq(index).should('contain.text', tile.title)
    })
  })

  it('03 - Dashboard APP section rendering', () => {
    dashboard.getAppSection().should('be.visible')
    dashboard.getAppSection('h2').contains('Advanced Practice Provider')
    dashboard.getAppSection('.grid').children().should('have.length', 2)
    tileData.ADVANCED_PRACTICE_PROVIDER_TILES.forEach((tile, index) => {
      dashboard.getAppSection('.grid').children().eq(index).should('be.visible')
      dashboard.getAppSection('.grid').children().eq(index).should('contain.text', tile.title)
    })
  })

  it('04 - Dashboard Other Studies section rendering', () => {
    dashboard.getOtherStudiesSection().should('be.visible')
    dashboard.getOtherStudiesSection('h2').contains('Other Studies')
    dashboard.getOtherStudiesSection('.grid').eq(0).should('have.length', 1)
  })

  it('05 - Tutorial Button should be clicable', () => {
    dashboard.getTutorialButton().should('be.visible')
  })

  it('06 - Should toggle the user dropdown menu and have info available', () => {
    navbar.getBtnDropdownUser().click()
    navbar.getDropdownUser().should('be.visible')
    navbar.getUserProfile().should('be.visible')
    navbar.getUserProfileEmail().should('be.visible')
    navbar.getProfileUsername().should('be.visible')
    navbar.getUserProfileName().should('be.visible')
    navbar.getProfilePicture().should('be.visible')
    // TODO: Check user info (name, email, etc)
  })

  it('07 - Should Open the drawer for tutorial after click tutorial button', () => {
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
