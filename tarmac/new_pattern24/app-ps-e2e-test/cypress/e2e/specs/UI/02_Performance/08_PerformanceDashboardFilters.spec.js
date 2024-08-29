/// <reference types="Cypress" />
import performDashboardFilters from '../../../../pageObjects/02_Performance/PerformanceDashboardFilters';

describe("Performance - Performance Dashboard Filters", { testIsolation: false }, function () {
    let performFiltersData;
    before(function () {
        let username;
        let password;
        const enableRealData = Cypress.env("enableRealData");
        cy.getUserDetails(enableRealData).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            //cy.logintoPS2(username, password)
        });
        cy.visit('/dashboard')
        performDashboardFilters.dashboardPerformanceButton().click()
    });

    beforeEach(function () {
        cy.fixture('UI/01_Performance/Performance_dashboard_filters_data').then((data) => {
            performFiltersData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it('08: verify Global Data Filters- Performance Dashboard', function () {
            performDashboardFilters.dashboardPerformanceButton().click()
            performDashboardFilters.dashboardPerformanceButton().should('contain', performFiltersData.realData.performanceFiltersLabel.performanceLabel)

            performDashboardFilters.specialityButton().should('contain', performFiltersData.realData.performanceFiltersLabel.specialityButton)
            performDashboardFilters.specialityButton().click()
            performDashboardFilters.specialityLabel().should('contain', performFiltersData.realData.performanceFiltersLabel.specialityLabel)
            performDashboardFilters.pediatricsGenralLabel().should('contain', performFiltersData.realData.performanceFiltersLabel.pediatricsGenralLabel)
            performDashboardFilters.applySpecialtyButton().should('contain', performFiltersData.realData.performanceFiltersLabel.applySpecialtyButton)
            performDashboardFilters.cancelSpecialtyButton().should('contain', performFiltersData.realData.performanceFiltersLabel.cancelSpecialtyButton)

            performDashboardFilters.periodTypeButton().click()
            performDashboardFilters.periodTypeButton().should('contain', performFiltersData.realData.performanceFiltersLabel.periodTypeButton)
            performDashboardFilters.periodTypeLabel().should('contain', performFiltersData.realData.performanceFiltersLabel.periodTypeLabel)
            performDashboardFilters.mainLabel().eq(0).should('contain', performFiltersData.realData.performanceFiltersLabel.mainCompLabel)
            performDashboardFilters.applyPeriodTypeButton().should('contain', performFiltersData.realData.performanceFiltersLabel.applyPeriodTypeButton)
            performDashboardFilters.cancelPeriodTypeButton().should('contain', performFiltersData.realData.performanceFiltersLabel.cancelPeriodTypeButton)

            performDashboardFilters.periodButton().click()
            performDashboardFilters.periodButton().should('contain', performFiltersData.realData.performanceFiltersLabel.periodButton)
            performDashboardFilters.periodLabel().eq(0).should('contain', performFiltersData.realData.performanceFiltersLabel.periodLabel)
            performDashboardFilters.yearMonthLabel().eq(1).should('contain', performFiltersData.realData.performanceFiltersLabel.yearMonthLabel)
            performDashboardFilters.FY2023Button().should('contain', performFiltersData.realData.performanceFiltersLabel.FY2023Button)
            performDashboardFilters.FY2023Button().click()
            performDashboardFilters.FY2023Label().eq(0).should('contain', performFiltersData.realData.performanceFiltersLabel.FY2023Label)
            performDashboardFilters.FY2024Label().eq(1).should('contain', performFiltersData.realData.performanceFiltersLabel.FY2024Label)
            performDashboardFilters.periodMonthButton().click({ force: true })
            performDashboardFilters.periodMonthButton().should('contain', performFiltersData.realData.performanceFiltersLabel.periodMonthButton)
            performDashboardFilters.applyPeriodButton().should('contain', performFiltersData.realData.performanceFiltersLabel.applyPeriodButton)
            performDashboardFilters.cancelPeriodButton().should('contain', performFiltersData.realData.performanceFiltersLabel.cancelPeriodButton)

        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('08: verify Global Data Filters- Performance Dashboard', function () {
            performDashboardFilters.dashboardPerformanceButton().click()
            performDashboardFilters.dashboardPerformanceButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.performanceLabel)

            performDashboardFilters.specialityButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.specialityButton)
            performDashboardFilters.specialityButton().click()
            performDashboardFilters.specialityLabel().should('contain', performFiltersData.mockData.performanceFiltersLabel.specialityLabel)
            performDashboardFilters.familyMedicineLabel().should('contain', performFiltersData.mockData.performanceFiltersLabel.familyMedicineLabel)
            performDashboardFilters.applySpecialtyButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.applySpecialtyButton)
            performDashboardFilters.cancelSpecialtyButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.cancelSpecialtyButton)

            performDashboardFilters.periodTypeButton().click()
            performDashboardFilters.periodTypeButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.periodTypeButton)
            performDashboardFilters.periodTypeLabel().should('contain', performFiltersData.mockData.performanceFiltersLabel.periodTypeLabel)
            performDashboardFilters.mainLabel().eq(0).should('contain', performFiltersData.mockData.performanceFiltersLabel.mainLabel)
            performDashboardFilters.shadowLabel().eq(1).should('contain', performFiltersData.mockData.performanceFiltersLabel.shadowLabel)
            performDashboardFilters.contractLabel().eq(2).should('contain', performFiltersData.mockData.performanceFiltersLabel.contractLabel)
            performDashboardFilters.applyPeriodTypeButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.applyPeriodTypeButton)
            performDashboardFilters.cancelPeriodTypeButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.cancelPeriodTypeButton)

            performDashboardFilters.periodButton().click()
            performDashboardFilters.periodButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.periodButton)
            performDashboardFilters.periodLabel().eq(0).should('contain', performFiltersData.mockData.performanceFiltersLabel.periodLabel)
            performDashboardFilters.yearMonthLabel().eq(1).should('contain', performFiltersData.mockData.performanceFiltersLabel.yearMonthLabel)
            performDashboardFilters.yearCalenderButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.yearCalenderButton)
            performDashboardFilters.yearCalenderButton().click()
            performDashboardFilters.calendarYear2022Label().eq(0).should('contain', performFiltersData.mockData.performanceFiltersLabel.calendarYear2022Label)
            performDashboardFilters.calendarYear2023Label().eq(1).should('contain', performFiltersData.mockData.performanceFiltersLabel.calendarYear2023Label)
            performDashboardFilters.periodMonthButton().click({ force: true })
            performDashboardFilters.periodMonthButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.periodMonthButton)
            performDashboardFilters.applyPeriodButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.applyPeriodButton)
            performDashboardFilters.cancelPeriodButton().should('contain', performFiltersData.mockData.performanceFiltersLabel.cancelPeriodButton)

        })
    }
})