/// <reference types="Cypress" />

class ProductivityDashboardFilters {
    dashboardProductivityButton() {
        return cy.get('[data-cy="buttonNavProductivity"]')
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
    pediatricsGeneralLabel() {
        return cy.get('[data-cy="familyMedicine"]')
    }
    familyMedicineLabel() {
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
    calenderYearLabel() {
        return cy.get('[data-cy="mainComp"]')
    }
    fiscalYearLabel() {
        return cy.get('[data-cy="periodTypeList"]')
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
    FY2023Button() {
        return cy.get('[data-cy="yearCalendarButton"]')
    }
    FY2023Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    FY2024Label() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    button2023() {
        return cy.get('[data-cy="yearCalendarButton"]')
    }
    label2019() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    label2020() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    label2021() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    label2022() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    label2023() {
        return cy.get('[data-cy="header"] div div div div div div div ul li button')
    }
    calendarYear2023Label() {
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
    serviceGroupButton() {
        return cy.get('[data-cy="serviceGroupButton"]')
    }
    serviceGroupLabel() {
        return cy.get('[data-cy="header"] div div div div div div div h4')
    }
    showAllLabel() {
        return cy.get('[data-cy="serviceGroupOption-all"]')
    }
    infiniteLabel() {
        return cy.get('[data-cy="serviceGroupOption-0"]')
    }
    anesthesiaServicesLabel() {
        return cy.get('[data-cy="serviceGroupOption-1"]')
    }
    evalMgmtDentalLabel() {
        return cy.get('[data-cy="serviceGroupOption-2"]')
    }
    diagnosticRadiologyLabel() {
        return cy.get('[data-cy="serviceGroupOption-3"]')
    }
    diagnosticTherapeuticLabel() {
        return cy.get('[data-cy="serviceGroupOption-4"]')
    }
    evaluationManagementServicesLabel() {
        return cy.get('[data-cy="serviceGroupOption-5"]')
    }
    HCPCSLabel() {
        return cy.get('[data-cy="serviceGroupOption-6"]')
    }
    laboratoryPathologyLabel() {
        return cy.get('[data-cy="serviceGroupOption-7"]')
    }
    miscellaneousLabel() {
        return cy.get('[data-cy="serviceGroupOption-8"]')
    }
    pharmacyIVLabel() {
        return cy.get('[data-cy="serviceGroupOption-10"]')
    }
    suppliesLabel() {
        return cy.get('[data-cy="serviceGroupOption-11"]')
    }
    surgeryLabel() {
        return cy.get('[data-cy="serviceGroupOption-12"]')
    }
    otherLabel() {
        return cy.get('[data-cy="serviceGroupOption-0"]')
    }
    anesthesiaLabel() {
        return cy.get('[data-cy="serviceGroupOption-1"]')
    }
    cosmeticLabel() {
        return cy.get('[data-cy="serviceGroupOption-2"]')
    }
    dentalLabel() {
        return cy.get('[data-cy="serviceGroupOption-3"]')
    }
    imagingLabel() {
        return cy.get('[data-cy="serviceGroupOption-4"]')
    }
    CTScanLabel() {
        return cy.get('[data-cy="serviceGroupOption-5"]')
    }
    mammographyLabel() {
        return cy.get('[data-cy="serviceGroupOption-6"]')
    }
    MRALabel() {
        return cy.get('[data-cy="serviceGroupOption-7"]')
    }
    nucMedLabel() {
        return cy.get('[data-cy="serviceGroupOption-8"]')
    }
    petScanLabel() {
        return cy.get('[data-cy="serviceGroupOption-9"]')
    }
    radiationTherapyLabel() {
        return cy.get('[data-cy="serviceGroupOption-10"]')
    }
    ultrasoundLabel() {
        return cy.get('[data-cy="serviceGroupOption-11"]')
    }
    xrayLabel() {
        return cy.get('[data-cy="serviceGroupOption-12"]')
    }
    emergencyLabel() {
        return cy.get('[data-cy="serviceGroupOption-13"]')
    }
    homeLabel() {
        return cy.get('[data-cy="serviceGroupOption-14"]')
    }
    hospitalLabel() {
        return cy.get('[data-cy="serviceGroupOption-15"]')
    }
    opthalmologyLabel() {
        return cy.get('[data-cy="serviceGroupOption-16"]')
    }
    officeConsultLabel() {
        return cy.get('[data-cy="serviceGroupOption-17"]')
    }
    officeEstablishedLabel() {
        return cy.get('[data-cy="serviceGroupOption-18"]')
    }
    officeNewLabel() {
        return cy.get('[data-cy="serviceGroupOption-19"]')
    }
    officePsychLabel() {
        return cy.get('[data-cy="serviceGroupOption-20"]')
    }
    preventativeLabel() {
        return cy.get('[data-cy="serviceGroupOption-21"]')
    }
    SNFLabel() {
        return cy.get('[data-cy="serviceGroupOption-22"]')
    }
    phoneOnlineLabel() {
        return cy.get('[data-cy="serviceGroupOption-23"]')
    }
    pathologyLabel() {
        return cy.get('[data-cy="serviceGroupOption-24"]')
    }
    surgicalLabel() {
        return cy.get('[data-cy="serviceGroupOption-25"]')
    }
    applyServiceGroupButton() {
        return cy.get('[data-cy="serviceGroupApplyButton"]')
    }
    cancelServiceGroupButton() {
        return cy.get('[data-cy="serviceGroupCancelButton"]')
    }

}
const prodDashboardFilters = new ProductivityDashboardFilters();
export default prodDashboardFilters;