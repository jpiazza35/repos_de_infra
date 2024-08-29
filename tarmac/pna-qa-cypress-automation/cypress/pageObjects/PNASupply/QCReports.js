class QCReports {

    qcReportsTab() {
        return cy.get('.qcReportsTab')
    }

    breadcrumbQCReports() {
        return cy.get('#breadcrumb')
    }

    qcReportsHeader() {
        return cy.get('h3')
    }

    qcReportsList() {
        return cy.get('div[class="extcon pad10"] p a')
    }

    countOfModifiedRecords() {
        return cy.get('.extcon > :nth-child(2) > a')
    }

    duplicateLocations() {
        return cy.get('.extcon > :nth-child(3) > a')
    }

    totalCFTE() {
        return cy.get('.extcon > :nth-child(4) > a')
    }

    totalWorkDays() {
        return cy.get('.extcon > :nth-child(5) > a')
    }

    providerNightlyReport() {
        return cy.get('.extcon > :nth-child(6) > a')
    }

    sameNPIAssignedToMultiProviders() {
        return cy.get('.extcon > :nth-child(7) > a')
    }

    statusDetail() {
        return cy.get(':nth-child(8) > a')
    }

    statusSummary() {
        return cy.get('.extcon > :nth-child(9) > a')
    }

    supplyRosterUploads() {
        return cy.get(':nth-child(10) > a')
    }

    userAccessList() {
        return cy.get(':nth-child(11) > a')
    }

    activeRecordsWithBlankData() {
        return cy.get(':nth-child(12) > a')
    }

    callStatusCount() {
        return cy.get(':nth-child(13) > a')
    }

    engServiceAreaAndZip() {
        return cy.get(':nth-child(14) > a')
    }

    engSpecialties() {
        return cy.get(':nth-child(15) > a')
    }

    engDemandData() {
        return cy.get(':nth-child(16) > a')
    }









}
const qcReports = new QCReports()
export default qcReports