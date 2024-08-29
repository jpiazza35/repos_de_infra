import dashboard from '../../pageObjects/dashboard'
import Footer from '../../../src/components/Footer/Footer.svelte'

describe('Footer Component testing', () => {
  let footer = dashboard
  beforeEach(() => {
    cy.mount(Footer)
  })

  it('01 - Should render Footer', () => {
    footer.getFooter().should('be.visible')
  })

  it('02 - Footer should have content text', () => {
    let currentYear = new Date().getFullYear()
    footer.getFooter().should('be.visible')
    footer.getFooterText().should('be.visible')
    footer.getFooterText().should('have.text', `© ${currentYear} Sullivan Cotter. All rights reserved. Terms | Privacy Policy`)
  })
})
