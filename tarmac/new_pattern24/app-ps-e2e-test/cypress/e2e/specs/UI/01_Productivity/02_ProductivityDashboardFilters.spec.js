/// <reference types="Cypress" />
import prodDashboardFilters from '../../../../pageObjects/01_Productivity/ProductivityDashboardFilters';

describe("Productivity - Productivity Dashboard Filters", { testIsolation: false }, function () {
    let prodFiltersData;
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
        cy.fixture('UI/01_Productivity/productivity_dashboard_filters_data').then((data) => {
            prodFiltersData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //real data tests
    if (Cypress.env("enableRealData") == 'on') {
        it.skip('02: verify Productivity Dashboard Filters', function () {
            prodDashboardFilters.dashboardProductivityButton().click()
            prodDashboardFilters.dashboardProductivityButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.productivityLabel)

            prodDashboardFilters.specialityButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.specialityButton)
            prodDashboardFilters.specialityButton().click()
            prodDashboardFilters.specialityLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.specialityLabel)
            prodDashboardFilters.pediatricsGeneralLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.pediatricsGeneralLabel)
            prodDashboardFilters.applySpecialtyButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.applySpecialtyButton)
            prodDashboardFilters.cancelSpecialtyButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.cancelSpecialtyButton)

            prodDashboardFilters.periodTypeButton().click()
            prodDashboardFilters.periodTypeButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.periodTypeButton)
            prodDashboardFilters.periodTypeLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.periodTypeLabel)
            prodDashboardFilters.calenderYearLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.calenderLabel)
            prodDashboardFilters.fiscalYearLabel().eq(0).should('contain', prodFiltersData.realData.productivityFiltersLabel.fiscalYearLabel)
            prodDashboardFilters.applyPeriodTypeButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.applyPeriodTypeButton)
            prodDashboardFilters.cancelPeriodTypeButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.cancelPeriodTypeButton)

            prodDashboardFilters.periodButton().click()
            prodDashboardFilters.periodButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.periodButton)
            prodDashboardFilters.periodLabel().eq(0).should('contain', prodFiltersData.realData.productivityFiltersLabel.periodLabel)

            prodDashboardFilters.yearMonthLabel().eq(1).should('contain', prodFiltersData.realData.productivityFiltersLabel.yearMonthLabel)
            prodDashboardFilters.FY2023Button().click()
            prodDashboardFilters.FY2023Label().eq(0).should('contain', prodFiltersData.realData.productivityFiltersLabel.FY2023Label)
            prodDashboardFilters.FY2024Label().eq(1).should('contain', prodFiltersData.realData.productivityFiltersLabel.FY2024Label)
            prodDashboardFilters.periodMonthButton().click({ force: true })
            prodDashboardFilters.periodMonthButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.periodMonthButton)
            prodDashboardFilters.applyPeriodButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.applyPeriodButton)
            prodDashboardFilters.cancelPeriodButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.cancelPeriodButton)

            prodDashboardFilters.serviceGroupButton().click()
            prodDashboardFilters.serviceGroupButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.serviceGroupButton)
            prodDashboardFilters.serviceGroupLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.serviceGroupLabel)
            prodDashboardFilters.showAllLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.showAllLabel)
            prodDashboardFilters.infiniteLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.infiniteLabel)
            prodDashboardFilters.anesthesiaServicesLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.anesthesiaServicesLabel)
            prodDashboardFilters.evalMgmtDentalLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.evalMgmtDentalLabel)
            prodDashboardFilters.diagnosticRadiologyLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.diagnosticRadiologyLabel)
            prodDashboardFilters.diagnosticTherapeuticLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.diagnosticTherapeuticLabel)
            prodDashboardFilters.evaluationManagementServicesLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.evaluationManagementServicesLabel)
            prodDashboardFilters.HCPCSLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.HCPCSLabel)
            prodDashboardFilters.laboratoryPathologyLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.laboratoryPathologyLabel)
            prodDashboardFilters.miscellaneousLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.miscellaneousLabel)
            prodDashboardFilters.pharmacyIVLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.pharmacyIVLabel)
            prodDashboardFilters.suppliesLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.suppliesLabel)
            prodDashboardFilters.surgeryLabel().should('contain', prodFiltersData.realData.productivityFiltersLabel.surgeryLabel)
            prodDashboardFilters.applyServiceGroupButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.applyServiceGrpButton)
            prodDashboardFilters.cancelServiceGroupButton().should('contain', prodFiltersData.realData.productivityFiltersLabel.cancelServiceGrpButton)
        })
    }
    //mock data tests
    if (Cypress.env("enableRealData") == 'off') {
        it.skip('02: verify Productivity Dashboard Filters', function () {
            prodDashboardFilters.dashboardProductivityButton().click()
            prodDashboardFilters.dashboardProductivityButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.productivityLabel)

            prodDashboardFilters.specialityButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.specialityButton)
            prodDashboardFilters.specialityButton().click()
            prodDashboardFilters.specialityLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.specialityLabel)
            prodDashboardFilters.familyMedicineLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.familyMedicineLabel)
            prodDashboardFilters.applySpecialtyButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.applySpecialtyButton)
            prodDashboardFilters.cancelSpecialtyButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.cancelSpecialtyButton)

            prodDashboardFilters.periodTypeButton().click()
            prodDashboardFilters.periodTypeButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.periodTypeButton)
            prodDashboardFilters.periodTypeLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.periodTypeLabel)
            prodDashboardFilters.calenderYearLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.calenderLabel)
            prodDashboardFilters.applyPeriodTypeButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.applyPeriodTypeButton)
            prodDashboardFilters.cancelPeriodTypeButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.cancelPeriodTypeButton)

            prodDashboardFilters.periodLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.periodLabel)
            prodDashboardFilters.yearMonthLabel().eq(2).should('contain', prodFiltersData.mockData.productivityFiltersLabel.yearMonthLabel)
            prodDashboardFilters.button2023().click({ force: true })
            prodDashboardFilters.label2019().eq(0).should('contain', prodFiltersData.mockData.productivityFiltersLabel.label2019)
            prodDashboardFilters.label2020().eq(1).should('contain', prodFiltersData.mockData.productivityFiltersLabel.label2020)
            prodDashboardFilters.label2021().eq(2).should('contain', prodFiltersData.mockData.productivityFiltersLabel.label2021)
            prodDashboardFilters.label2022().eq(3).should('contain', prodFiltersData.mockData.productivityFiltersLabel.label2022)
            prodDashboardFilters.label2023().eq(4).should('contain', prodFiltersData.mockData.productivityFiltersLabel.label2023)
            prodDashboardFilters.periodMonthButton().click({ force: true })
            prodDashboardFilters.periodMonthButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.periodMonthButton)
            prodDashboardFilters.applyPeriodButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.applyPeriodButton)
            prodDashboardFilters.cancelPeriodButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.cancelPeriodButton)

            prodDashboardFilters.serviceGroupButton().click()
            prodDashboardFilters.serviceGroupButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.serviceGroupButton)
            prodDashboardFilters.serviceGroupLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.serviceGroupLabel)
            prodDashboardFilters.showAllLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.showAllLabel)
            prodDashboardFilters.otherLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.otherLabel)
            prodDashboardFilters.anesthesiaLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.anesthesiaLabel)
            prodDashboardFilters.cosmeticLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.cosmeticLabel)
            prodDashboardFilters.dentalLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.dentalLabel)
            prodDashboardFilters.imagingLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.imagingLabel)
            prodDashboardFilters.CTScanLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.CTScanLabel)
            prodDashboardFilters.mammographyLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.mammographyLabel)
            prodDashboardFilters.MRALabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.MRALabel)
            prodDashboardFilters.nucMedLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.nucMedLabel)
            prodDashboardFilters.petScanLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.petScanLabel)
            prodDashboardFilters.radiationTherapyLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.radiationTherapyLabel)
            prodDashboardFilters.ultrasoundLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.ultrasoundLabel)
            prodDashboardFilters.xrayLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.xrayLabel)
            prodDashboardFilters.emergencyLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.emergencyLabel)
            prodDashboardFilters.homeLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.homeLabel)
            prodDashboardFilters.hospitalLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.hospitalLabel)
            prodDashboardFilters.opthalmologyLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.opthalmologyLabel)
            prodDashboardFilters.officeConsultLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.officeConsultLabel)
            prodDashboardFilters.officeEstablishedLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.officeEstablishedLabel)
            prodDashboardFilters.officeNewLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.officeNewLabel)
            prodDashboardFilters.officePsychLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.officePsychLabel)
            prodDashboardFilters.preventativeLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.preventativeLabel)
            prodDashboardFilters.SNFLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.SNFLabel)
            prodDashboardFilters.phoneOnlineLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.phoneOnlineLabel)
            prodDashboardFilters.pathologyLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.pathologyLabel)
            prodDashboardFilters.surgicalLabel().should('contain', prodFiltersData.mockData.productivityFiltersLabel.surgicalLabel)
            prodDashboardFilters.applyServiceGroupButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.applyServiceGrpButton)
            prodDashboardFilters.cancelServiceGroupButton().should('contain', prodFiltersData.mockData.productivityFiltersLabel.cancelServiceGrpButton)
        })
    }
})