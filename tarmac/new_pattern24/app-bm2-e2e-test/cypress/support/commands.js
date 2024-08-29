// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })


//Action Commands
Cypress.Commands.add('enterText', (elementLocator,inputText) => {
    cy.get(elementLocator).type(inputText);
});
Cypress.Commands.add('enterTextBasedOnIndex', (elementLocator,index,inputText) => {
    cy.get(elementLocator).eq(index).type(inputText);
});
Cypress.Commands.add('clickOn', (elementLocator) => {
    cy.get(elementLocator).click();
});
Cypress.Commands.add('clickOnIndex', (elementLocator,index) => {
    cy.get(elementLocator).eq(index).click();
});
Cypress.Commands.add('clickBaseOnText', (containText) => {
    cy.contains(containText).click();
});
Cypress.Commands.add('doubleClickOn', (elementLocator) => {
    cy.get(elementLocator).dblclick();
});
Cypress.Commands.add('rightClickOn', (elementLocator) => {
    cy.get(elementLocator).rightclick();
});
Cypress.Commands.add('clearTextField', (elementLocator) => {
    cy.get(elementLocator).clear();
});
Cypress.Commands.add('clickContainText', (elementLocator,containText) => {
    cy.get(elementLocator).contains(containText).click({force: true});
});

//Assertions
Cypress.Commands.add('shouldHaveText', (elementLocator,expectedText) => {
    cy.get(elementLocator).should('have.text',expectedText)
});
Cypress.Commands.add('shouldHaveTextBaseOnIndex', (elementLocator,index, expectedText) => {
    cy.get(elementLocator).eq(index).should('have.text',expectedText)
});
Cypress.Commands.add('shouldContainText', (elementLocator,expectedText) => {
    cy.get(elementLocator).should('contain',expectedText)
});
Cypress.Commands.add('shouldContainTextWithIndex', (elementLocator,expectedText, index) => {
    cy.get(elementLocator).eq(index).should('contain',expectedText)
});
Cypress.Commands.add('shouldBeVisible', (elementLocator) => {
    cy.get(elementLocator).should('be.visible');
});
Cypress.Commands.add('shouldNotBeVisible', (elementLocator) => {
    cy.get(elementLocator).should('not.be.visible');
});
Cypress.Commands.add('shouldExist', (elementLocator) => {
    cy.get(elementLocator).should('exist');
});
Cypress.Commands.add('shouldExist', (elementLocator) => {
    cy.get(elementLocator).should('not.exist');
});
Cypress.Commands.add('shouldBeDisabled', (elementLocator) => {
    cy.get(elementLocator).should('be.disabled');
});
Cypress.Commands.add('shouldNotBeDisabled', (elementLocator) => {
    cy.get(elementLocator).should('not.be.disabled');
});
Cypress.Commands.add('shouldEnabled', (elementLocator) => {
    cy.get(elementLocator).should('be.enabled');
});
Cypress.Commands.add('shouldNotEnabled', (elementLocator) => {
    cy.get(elementLocator).should('not.be.enabled');
});
Cypress.Commands.add('shouldBeChecked', (elementLocator) => {
    cy.get(elementLocator).should('be.checked');
});
Cypress.Commands.add('shouldNotBeChecked', (elementLocator) => {
    cy.get(elementLocator).should('not.be.checked');
});

// Waits
Cypress.Commands.add('customWait', (seconds) => {
    cy.log('Waiting for '+seconds+'seconds')
    cy.wait(seconds+1000);
});

Cypress.Commands.add('waitUntilVisibilityOf', (elementLocator) => {
    cy.get(elementLocator, { timeout: 60000 }).should('be.visible');
});
Cypress.Commands.add(
    'waitUntilVisibilityOfElementWithContainText',
    (elementLocator, textContain) => {
        cy.get(elementLocator)
            .contains(textContain, { timeout: 15000 })
            .should('be.visible');
    }
);
Cypress.Commands.add(
    'waitUntilInVisibilityOfElementWithContainText',
    (elementLocator, textContain) => {
        cy.get(elementLocator)
            .contains(textContain, { timeout: 15000 })
            .should('not.exist');
    }
);
Cypress.Commands.add('waitUntilInVisibilityOfElement', (elementLocator) => {
    cy.get(elementLocator).should('be.visible');
});
Cypress.Commands.add('waitUntilInVisibilityOfElement', (elementLocator) => {
    cy.get(elementLocator).should('not.exist');
});

//Dropdown
Cypress.Commands.add('selectDropdown', (elementPath, selectText) => {
    cy.get(elementPath).contains(selectText).click({ force: true });
});