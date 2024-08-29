/// <reference types="Cypress" />

class PerformanceDashboardFilters {

    dashboardPerformanceButton() {
        return cy.get('[data-cy="buttonNavPerformance"]')
    }
    resetFilters() {
        return cy.get('[data-cy="resetFiltersButton"]')
    }
    specialityButton() {
        return cy.get('[data-cy="specialtyButton"]')
    }
    specialityLabel() {
        return cy.get('[data-cy="header"] div div div div h4')
    }
    familyMedicineLabel() {
        return cy.get('[data-cy="familyMedicine"]')
    }
    pediatricsGenralLabel() {
        return cy.get('[data-cy="familyMedicine"]')
    }
    applySpecialtyButton() {
        return cy.get('[data-cy="applySpecialtyButton"]')
    }
    cancelSpecialtyButton() {
        return cy.get('[data-cy="cancelSpecialtyButton"]')
    }
    periodTypeButton() {
        return cy.get('[data-cy="periodTypeButton"]')
    }
    periodTypeLabel() {
        return cy.get('[data-cy="header"] div div div div div h4')
    }
    mainLabel() {
        return cy.get('[data-cy="mainComp"]')
    }
    shadowLabel() {
        return cy.get('[data-cy="mainComp"]')
    }
    contractLabel() {
        return cy.get('[data-cy="mainComp"]')
    }
    applyPeriodTypeButton() {
        return cy.get('[data-cy="applyPeriodTypeButton"]')
    }
    cancelPeriodTypeButton() {
        return cy.get('[data-cy="cancelPeriodTypeButton"]')
    }
    periodButton() {
        return cy.get('[data-cy="periodButton"]')
    }
    periodLabel() {
        return cy.get('[data-cy="header"] div div div div div div h4')
    }
    yearMonthLabel() {
        return cy.get('[data-cy="header"] div div div div div div h4')
    }
    yearCalenderButton() {
        return cy.get('[data-cy="yearCalendarButton"]')
    }
    FY2023Button() {
        return cy.get('[data-cy="yearCalendarButton"]')
    }
    calendarYear2022Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    calendarYear2023Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    FY2023Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    FY2024Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    periodMonthButton() {
        return cy.get('[data-cy="periodMonthButton"]')
    }
    periodQuarterButton() {
        return cy.get('[data-cy="periodQuarterButton"]')
    }
    applyPeriodButton() {
        return cy.get('[data-cy="applyPeriodButton"]')
    }
    cancelPeriodButton() {
        return cy.get('[data-cy="cancelPeriodButton"]')
    }
    setCurrentFilterDefault() {
        return cy.get('[data-cy="labelDefaultFilters"]')
    }
    dashboardPerformanceButton() {
        return cy.get('[data-cy="buttonNavPerformance"]')
    }
    monthYear() {
        return cy.get('[data-cy="periodMonth"] div ul li')
    }
}
const performDashboardFilters = new PerformanceDashboardFilters();
export default performDashboardFilters;