/// <reference types="Cypress" />
import dashboardNavigation from '../../../../pageObjects/00_DashboardNavigation/DashboardNavigation';

describe("Productivity - Dashboard Navigation", { testIsolation: false }, function () {
    let dashboardNavigationData;
    before(function () {
        let username;
        let password;
        let url;
        const enableRealData = Cypress.env("enableRealData");
        const reportingPeriod = Cypress.env("reportingPeriod");
        cy.getUserDetails(enableRealData, reportingPeriod).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            url = userDetails.url;
             cy.logintoPS2(username, password, url)
             cy.visit(url)
        });
        
    });

    beforeEach(function () {
        cy.fixture('UI/00_DashboardNavigation/dashboard_navigation_data').then((data) => {
            dashboardNavigationData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });


    // common tests for both mock and real data users

    it('01: verify Dashboard Navigation Productivity', function () {
        cy.get('[data-cy="header"]')
        dashboardNavigation.dashboardProductivityButton().should('contain', dashboardNavigationData.categories[0])
        dashboardNavigation.dashboardProductivityButton().click()
        dashboardNavigation.monthlyFTETrendCard().should('contain', dashboardNavigationData.productivitycardHeaders[0])
        dashboardNavigation.benchMarkCard().should('contain', dashboardNavigationData.productivitycardHeaders[1])
        dashboardNavigation.monthlyTrendCard().should('contain', dashboardNavigationData.productivitycardHeaders[2])
        dashboardNavigation.monthlyServiceGroupCard().should('contain', dashboardNavigationData.productivitycardHeaders[3])
        dashboardNavigation.patientDetailCard().should('contain', dashboardNavigationData.productivitycardHeaders[4])
    });

    it.skip('01: verify Dashboard Navigation Performance', function () {
        dashboardNavigation.dashboardPerformanceButton().should('contain', dashboardNavigationData.dashboardNavigationData.categories[1])
        dashboardNavigation.dashboardPerformanceButton().click()
        dashboardNavigation.compSummaryCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[0])
        dashboardNavigation.fteAllocationCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[1])
        dashboardNavigation.settlementCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[2])
        dashboardNavigation.earningCodesCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[3])
        dashboardNavigation.productivityCompensationCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[4])
        dashboardNavigation.circuitBreakerCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[5])
        dashboardNavigation.valueBasedCompensationCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[6])
        dashboardNavigation.ValueBasedMeasuresCard().should('contain', dashboardNavigationData.dashboardNavigationData.performancecardHeaders[7])
    });

    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it('01: verify Dashboard Headers Productivity', function () {
            dashboardNavigation.dashboardProductivityButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.mockData.name)
            dashboardNavigation.headerDate().eq(0).should('contain', dashboardNavigationData.mockData.productivityHeader)
            dashboardNavigation.headerPeriod().eq(1).should('contain', dashboardNavigationData.mockData.productivitySubHeader)
        });

        it.skip('01: verify Dashboard Headers Performance', function () {
            dashboardNavigation.dashboardPerformanceButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.mockData.name)
            dashboardNavigation.performanceHeaderDate().eq(0).should('contain', dashboardNavigationData.mockData.performanceHeader)
            dashboardNavigation.performancHeaderCompPeriod().eq(1).should('contain', dashboardNavigationData.mockData.performanceSubHeader)
        });
    }

    //fiscal year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'fiscal') {
        it('01: verify Dashboard Headers Productivity', function () {
            dashboardNavigation.dashboardProductivityButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.fy_realData.name)
            dashboardNavigation.headerDate().eq(0).should('contain', dashboardNavigationData.fy_realData.productivityHeader)
            dashboardNavigation.headerPeriod().eq(1).should('contain', dashboardNavigationData.fy_realData.productivitySubHeader)
        });

        it.skip('01: verify Dashboard Headers Performance', function () {
            dashboardNavigation.dashboardPerformanceButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.fy_realData.name)
            dashboardNavigation.performanceHeaderDate().eq(0).should('contain', dashboardNavigationData.fy_realData.performanceHeader)
            dashboardNavigation.performancHeaderCompPeriod().eq(1).should('contain', dashboardNavigationData.fy_realData.performanceSubHeader)
        });
    }

    //calendar year real data tests
    if (Cypress.env("enableRealData") == 'on' && Cypress.env("reportingPeriod") == 'calendar') {

        it('01: verify Dashboard Headers Productivity', function () {
            dashboardNavigation.dashboardProductivityButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.cy_realData.name)
            dashboardNavigation.headerDate().eq(0).should('contain', dashboardNavigationData.cy_realData.productivityHeader)
            dashboardNavigation.headerPeriod().eq(1).should('contain', dashboardNavigationData.cy_realData.productivitySubHeader)
        });

        it.skip('01: verify Dashboard Headers Performance', function () {
            dashboardNavigation.dashboardPerformanceButton().click()
            dashboardNavigation.headerTitle().should('contain', dashboardNavigationData.cy_realData.name)
            dashboardNavigation.performanceHeaderDate().eq(0).should('contain', dashboardNavigationData.cy_realData.performanceHeader)
            dashboardNavigation.performancHeaderCompPeriod().eq(1).should('contain', dashboardNavigationData.cy_realData.performanceSubHeader)
        });
    }
})
