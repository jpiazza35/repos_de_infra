class Dashboard {
  getLandingContainer() {
    return cy.get('[data-cy="tutorial-container"]')
  }
  getTopHeader() {
    return cy.get('[data-cy="tutorial-topheader"]')
  }
  getTopHeaderMessage() {
    return cy.get('[data-cy="tutorial-message"]')
  }
  getTutorialButton() {
    return cy.get('button[data-cy="tutorial-button"]')
  }
  getFakeTutorialButton() {
    return cy.get('button[data-cy="fake-tutorial-button"]')
  }
  getTutorialDownloadButton() {
    return cy.get('button[data-cy="tutorial-download-button"]')
  }
  getTutorialCloseButton() {
    return cy.get('button[data-cy="tutorial-close-button"]')
  }
  getPhysicianSection(param = '') {
    return cy.get(`[data-cy="physician-section"] ${param}`)
  }
  getAppSection(param = '') {
    return cy.get(`[data-cy="advanced-practice-provider-section"] ${param}`)
  }
  getOtherStudiesSection(param = '') {
    return cy.get(`[data-cy="other-studies-section"] ${param}`)
  }
  getFooter() {
    return cy.get('[data-cy=footer-cy]')
  }
  getFooterText() {
    return cy.get('[data-cy=footer-privacy-text]')
  }
  getTutorialModal() {
    return cy.get('[data-cy="tutorial-modal"]')
  }
}

const dashboard = new Dashboard()
export default dashboard
