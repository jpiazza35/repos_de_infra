Cypress.Commands.add("selectNth", { prevSubject: "element" }, (subject, pos) => {
  cy.wrap(subject)
    .children("option")
    .eq(pos)
    .then(e => {
      cy.wrap(subject).select(e.val(), { force: true });
    });
});

Cypress.Commands.add("AutoCompleteFirstChild", (ctrl, text, selectText) => {
  cy.get(ctrl).click({ force: true }).clear({ force: true }).type(text, { force: true });
  cy.debug();
  cy.wait(2000).then(interception => {
    //cy.get('li.autocomplete-items', { timeout: 3000 }).should('be.visible', {force : true})
    cy.contains("li.autocomplete-items", selectText).click({ force: true });
    //cy.get('li.autocomplete-items(21st Century Oncology-1570)').first().click( {force : true})//;//.should('be.visible', {force : true})
    //cy.get('li.autocomplete-items').first().click( {force : true});
  });
});

Cypress.Commands.add("CheckNotification", text => {
  cy.get("div.k-notification-content", { timeout: 4000 }).should("have.text", text);
});
