/// <reference types="Cypress" />

class ValueBasedMeasures {

    valBasedMeasureTitle() {
        return cy.get('[data-cy="valueBasedMeasuresTitle"]')
    }
    valBasedMeasureInfoIcon() {
        return cy.get('[data-cy="infoTooltipIcon"]')
    }
    valBasedMeasureInfoToolTip() {
        return cy.get('[data-cy="infoTooltip"]')
    }
    breastCancerScreeningTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    qualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    qualityTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    AWVRate() {
        return cy.get('[data-cy="progressTitle"]')
    }
    PHQ9() {
        return cy.get('[data-cy="progressTitle"]')
    }
    controllingHighBloodPressure() {
        return cy.get('[data-cy="progressTitle"]')
    }
    STIScreening() {
        return cy.get('[data-cy="progressTitle"]')
    }
    screening() {
        return cy.get('[data-cy="progressTitle"]')
    }
    teamwork() {
        return cy.get('[data-cy="progressTitle"]')
    }
    YTDPerformance() {
        return cy.get('[data-cy="progressSubChartTitle"]')
    }
    depressionScreeningTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    depressionScreeningQualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    depressionScreeningYTDPerformance() {
        return cy.get('[data-cy="progressSubChartTitle"]')
    }
    hypertensionTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    hypertensionqualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    hypertensionYTDPerformance() {
        return cy.get('[data-cy="progressSubChartTitle"]')
    }
    wouldRecommendProviderTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    wouldRecommendProviderPatientExpInd() {
        return cy.get('[data-cy="progressTitle"]')
    }
    wouldRecommendProviderYTDPerformance() {
        return cy.get('[data-cy="progressSubChartTitle"]')
    }
    A1CTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    A1CPatientExperience() {
        return cy.get('[data-cy="progressTitle"]')
    }
    A1CYTDPerformance() {
        return cy.get('[data-cy="progressSubChartTitle"]')
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
const valBasedMeasures = new ValueBasedMeasures();
export default valBasedMeasures;
