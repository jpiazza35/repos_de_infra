import { search } from "../../pages/Search";

describe('Find Clinician Nexus from Google', () => {
    before(function () {
      cy.fixture('testData').then((user) => {
      cy.visit(user.url);
      cy.shouldBeVisible(search.search_field);
    })
  });
  it('Search Clinician Nexus', () => {
    cy.enterText(search.search_field,"Clinician Nexus"+'{enter}' )
    cy.get(search.search_result).eq(0).should('exist');
    });

})
