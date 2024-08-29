/// <reference types="Cypress" />

class ValueBasedMeasures {

    valBasedMeasureTitle() {
        return cy.get('[data-cy="valueBasedMesauresTitle"]')
    }
    breastCancerScreeningTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    qualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    YTDPerformance() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    breastCancerScreeningYTDPerformanceVal() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    breastCancerScreeningProgressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    depressionScreeningTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    depressionScreeningQualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    depressionScreeningYTDPerformance() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    depressionScreeningYTDPerformanceVal() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    depressionScreeningProgressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    hypertensionTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    hypertensionqualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    hypertensionYTDPerformance() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    hypertensionYTDPerformanceVal() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    hypertensionProgressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    wouldRecommendProviderTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    wouldRecommendProviderPatientExpInd() {
        return cy.get('[data-cy="progressTitle"]')
    }
    wouldRecommendProviderYTDPerformance() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    wouldRecommendProviderYTDPerformanceVal() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    wouldRecommendProviderProgressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }
    A1CTitle() {
        return cy.get('[data-cy="progressTitle"]')
    }
    A1CQualityIndividual() {
        return cy.get('[data-cy="progressTitle"]')
    }
    A1CYTDPerformance() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    A1CYTDPerformanceVal() {
        return cy.get('[data-cy="progressCard"] div div')
    }
    A1CProgressBarMarkVal() {
        return cy.get('[data-cy="progressBarMarkValue"]')
    }

}
const valBasedMeasures = new ValueBasedMeasures();
export default valBasedMeasures;
