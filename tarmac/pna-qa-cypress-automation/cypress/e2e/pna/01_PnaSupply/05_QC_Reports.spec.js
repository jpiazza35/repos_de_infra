/// <reference types="Cypress" />
import qcReports from "../../../pageObjects/PNASupply/QCReports"
import select_ClientAndEngagement from "../../../pageObjects/PNASupply/Select_ClientAndEngagement"
describe('QC Reports tab', { testIsolation: false }, function () {
    before(function () {
        cy.visit('/')
        //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToPnaSupply() 
    })
    beforeEach(function () {
        cy.fixture('01_pnaSupply/pna_qcReports_data').as('qc_data')
        cy.listenToClickEventForDownload()
    });

    // after(function () {
    //     cy.logoutClientPortal();
    // });

    it('05: Select Client and Engagement - Version', function () {
        select_ClientAndEngagement.selectClientParent()
        select_ClientAndEngagement.selectEngagement_Version_V23()
    })

    it('05: Navigate to QC Reports', function () {
        qcReports.qcReportsTab().contains('QC Reports').click()
        qcReports.breadcrumbQCReports().should('contain', 'QC Reports')
    })

    it('05: Delete all previously downloaded files', function () {
        cy.task("isFileExist", 'cypress/downloads').then(() => {
            cy.deleteDownloadsFolder()
        })
    })

    it('05: Verify the header of QC Reports list', function () {
        qcReports.qcReportsHeader().should('have.text', 'Quality Control Reports')
    })

    it('05: Verify the list of QC Reports', function () {
        qcReports.qcReportsList().should('have.length', 15)
        qcReports.qcReportsList().each(($li, index) => {
            cy.wrap($li).contains(this.qc_data.listOfQCReports[index])
        })
    })

    it('05: Verify the Count of Modified Records by Username report download file', function () {
        qcReports.countOfModifiedRecords().contains(this.qc_data.listOfQCReports[0]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[0], this.qc_data.countOfModifiedRecordsDownloadData)
    })

    it('05: Verify the Provider with Duplicate Locations - Nightly Report download file', function () {
        qcReports.duplicateLocations().contains(this.qc_data.listOfQCReports[1]).click({force: true})
        //cy.ExportValidation(this.qc_data.listOfQCReports[1], this.qc_data.providerNameVariationNightlyReportDownloadData)
    })

    it('05: Verify the Total cFTE >1 per Provider for all Active Locations download file', function () {
        qcReports.totalCFTE().contains(this.qc_data.listOfQCReports[2]).click({force: true})
        //cy.ExportValidation(this.qc_data.listOfQCReports[2], this.qc_data.totalCFTEGreaterThan1DownloadData)
    })

    it('05: Verify the Total Work Days > 7 days per Provider for all Active Locations report download file', function () {
        qcReports.totalWorkDays().contains(this.qc_data.listOfQCReports[3]).click({force: true})
        //cy.ExportValidation(this.qc_data.listOfQCReports[3], this.qc_data.totalWorkDaysGreaterThan7DownloadData)
     })

    it('05: Verify the Provider Name Variation - Nightly Report download file', function () {
        qcReports.providerNightlyReport().contains(this.qc_data.listOfQCReports[4]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[4], this.qc_data.providerNameVariationNightlyReportDownloadData)
    })

    it('05: Verify the Same NPI Assigned to Multiple Providers download file', function () {
        qcReports.sameNPIAssignedToMultiProviders().contains(this.qc_data.listOfQCReports[5]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[5], this.qc_data.sameNPIAssignedToMultiProvidersDownloadData)
    })

    it('05: Verify the Status Detail download file', function () {
        qcReports.statusDetail().contains(this.qc_data.listOfQCReports[6]).click()
        cy.ExportValidation(this.qc_data.listOfQCReports[6], this.qc_data.statusDetailDownloadData)
    })

    it('05: Verify the Status Summary download file', function () {
        qcReports.statusSummary().contains(this.qc_data.listOfQCReports[7]).click()
        cy.ExportValidation(this.qc_data.listOfQCReports[7], this.qc_data.statusSummaryDownloadData)
    })

    it('05: Verify the Supply Roster Datasource Uploads download file', function () {
        qcReports.supplyRosterUploads().contains(this.qc_data.listOfQCReports[8]).click()
        cy.ExportValidation(this.qc_data.listOfQCReports[8], this.qc_data.supplyRosterDatasourceUploadsDownloadData)
    })

    it('05: Verify the User Access List download file', function () {
        qcReports.userAccessList().contains(this.qc_data.listOfQCReports[9]).click()
        cy.ExportValidation(this.qc_data.listOfQCReports[9], this.qc_data.userAccessListDownloadData)
    })

    it('05: Verify the Active records with Blank Data download file', function () {
        cy.contains(':nth-child(12) > a', 'Active records with Blank Data').should('be.visible').click()
        cy.parseXlsx('cypress/downloads/Active records with Blank Data.xlsx').then(jsonData => {
            expect(jsonData[0].data[0]).to.eqls(this.qc_data.activeRecordsWithBlankDataDownloadData);
            expect(jsonData[0].data.length).to.be.greaterThan(1);
        })
    })

    it('05: Verify the Call Status Count Per Username download file', function () {
        qcReports.callStatusCount().contains(this.qc_data.listOfQCReports[11]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[11], this.qc_data.callStatusCountDownloadData)
    })

    it('05: Verify the Engagement Service Area and Zip Codes download file', function () {
        qcReports.engServiceAreaAndZip().contains(this.qc_data.listOfQCReports[12]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[12], this.qc_data.engmntServiceAreaAndZipDownloadData)
    })

    it('05: Verify the Engagement Specialties download file', function () {
        qcReports.engSpecialties().contains(this.qc_data.listOfQCReports[13]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[13], this.qc_data.engmntSpecialtiesDownloadData)
    })

    it('05: Verify the Engagement Demand Data download file', function () {
        qcReports.engDemandData().contains(this.qc_data.listOfQCReports[14]).click({force: true})
        cy.ExportValidation(this.qc_data.listOfQCReports[14], this.qc_data.engmntDemandDownloadData)
    })
})



   











