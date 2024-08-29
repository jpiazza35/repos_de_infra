/// <reference types="Cypress" />

class ValueBasedCompensation {
    valBasedCompensationTitle() {
        return cy.get('[data-cy="valueBasedTitle"]')
    }
    valBasedCompensationInfoIcon() {
        return cy.get('[data-cy="infoTooltipIcon"]')
    }
    valBasedCompensationInfoToolTip() {
        return cy.get('[data-cy="infoTooltip"]')
    }
    measureTypeDescLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div')
    }
    compEligibleLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div div')
    }
    compEarnedLabel() {
        return cy.get('[data-cy="valueBasedCard"] div div div div')
    }
    outComesLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    patientExperienceLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    qualityLabel() {
        return cy.get('[data-cy="itemMeasureType"]')
    }
    totalLabel() {
        return cy.get('[data-cy="totalMeasureType"]')
    }
    kebabMenu() {
        return cy.get('[data-cy="exportData"] svg')
    }
    exportDataPDF() {
        return cy.get('[data-cy="exportDataPopover"] div div button')
    }
    dashboardPerformanceButton() {
        return cy.get('[data-cy="buttonNavPerformance"]')
    }
}
const valBasedCompensation = new ValueBasedCompensation();
export default valBasedCompensation;
