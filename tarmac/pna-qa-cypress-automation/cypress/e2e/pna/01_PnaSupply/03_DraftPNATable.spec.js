/// <reference types="Cypress" />
import select_ClientAndEngagement from "../../../pageObjects/PNASupply/Select_ClientAndEngagement"
import draftPNATable from "../../../pageObjects/PNASupply/DraftPNATable"

describe('Draft PNA Table tab', { testIsolation: false }, function () {

    before(function () {
        cy.visit('/')
       // cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToPnaSupply()
        
    })

    beforeEach(function () {
        cy.fixture('01_pnaSupply/pna_data').as('data')
        cy.fixture('01_pnaSupply/pna_draftPNA_data').as('pna_data')
        
    });

    // after(function () {
    //     cy.logoutClientPortal();
    // });

    it('03: Select Client and Engagement - Version', function () {
       select_ClientAndEngagement.selectClientParent()
       select_ClientAndEngagement.selectEngagement_Version_V23()
    })

    it('03: Navigate to Draft PNA Table', function () {
        draftPNATable.draftPNAtab().should('have.text','Draft PNA Table').click()
        draftPNATable.breadcrumbDraftPNA().should('have.text', 'Draft PNA Table')
    }) 

    it.skip('03: Verify the Draft PNA Table search filters', function () {
        draftPNATable.draftPNAFilters().each(($li, index) => {
            cy.wrap($li).should('contain', this.pna_data.draftPNASearchFilters[index])
        })
    })

    it('03: Verify the Population Type Field', function () {
        draftPNATable.populationTypeField().should('be.disabled')
        draftPNATable.populationTypeField().invoke('val', 'Total')
    })

    it('03: Verify the Patient Management dropdown values', function () {
        draftPNATable.patientMngmntDropdownArrow().click()
        draftPNATable.patientMngmntDropdownOptions().each(($li, index) => {
            cy.wrap($li).should('contain.text', this.pna_data.patientMngmntDropdownValues[index])
        })
    })

    it('03: Verify Patient Management default value is 0', function () {
        cy.get(':nth-child(3) > :nth-child(2) > .k-picker').should('contain','0%')
    })

    it('03: Verify the Provider Class dropdown options', function() {
        draftPNATable.providerClassDropdownArrow().click()
        draftPNATable.providerClassDropdownOptions().each(($li, index) => {
            cy.wrap($li).should('have.text', this.pna_data.providerClassValues[index])
        })
    })

    it('03: Verify the provider class Physician is selected by defaul', function () {
        draftPNATable.providerClassDefault().should('be.checked')
    })
    
    it('03: Verify the Provider Class - Select All is checking/selecting all three provider classes', function () {
        draftPNATable.providerClassDropdownArrow().click({force: true})
        draftPNATable.selectAllProviderClasses().uncheck({force: true})
        draftPNATable.providerClassSelectAllOption().contains('Select All').click({force: true})
        cy.wait(1000)
        draftPNATable.selectAllProviderClasses().should('be.checked')
    })

    it('03: Verify the Table Note text', function () {
        draftPNATable.tableAreaNote().should('contain.text', 'Results may vary slightly due to rounding')
    })

    it('03: Verify Service Area dropdown has values', function () {
        draftPNATable.serviceAreaDropdownArrow().click({force: true})
        draftPNATable.serviceAreaDropdownOptions().each(($li, index) => {
            cy.wrap($li).should('have.text', this.pna_data.draftPNAServiceArea[index])
        })
    })

    it('03: Verify the Report Year dropdown values', function () {
        draftPNATable.reportYrDropdownArrow().click()
        draftPNATable.reportYearDropdownValues()
    })

    it('03: Select Service Area and verify the Draft PNA Table data is displayed', function () {
        draftPNATable.serviceAreaDropdownArrow().click({force: true})
        draftPNATable.serviceAreaDropdownOptions().contains(this.pna_data.draftPNAServiceArea[0]).click({force: true})
        draftPNATable.serviceAreaNote().should('be.visible').should('contain.text',this.pna_data.draftPNAServiceArea[0])
        cy.wait(1000)
        draftPNATable.tableBody().contains('tr')
    })

    it('03: Verify the expand/collapse button is present',function () {
        draftPNATable.expandCollapseBtn().should('exist')
    })

    it('03: Verify the table header displays correct report years', function () {
        draftPNATable.reportYrDropdownArrow().click()
        cy.get('div[id="divddlSearchReportYear"] input[type="checkbox"]').uncheck({force: true})
        draftPNATable.reportYrOptions().first().click({force: true})
        draftPNATable.tableHeaderDisplaysCorrectReportYears()
    })

    it('03: Verify the table displays Population number', function () {
        draftPNATable.tableFirstReportYr().should('include.text', 'Pop:')
    })

    it('03: Verify Report Year - Select All is checking/selecting all years', function () {
        draftPNATable.reportYrDropdownArrow().click()
        draftPNATable.reportYrSelectAllOption().should('contain.text','Select All').click({force: true})
        cy.wait(1000)
        draftPNATable.reportYrCheckboxes().should('be.checked')
    })

    it('03: Verify that if all report years are selected in a dropdown, they are displayed in grid ', function() {
        draftPNATable.yearsInGridMatchWithDropdown()
    })
    
    it.skip('03: Verify the file has been exported', function () {
        cy.listenToClickEventForDownload()
        draftPNATable.exportBtn().contains('Export').click({force: true})
        cy.verifyDownload('DraftExport.xlsx',{timeout: 3000})
    })
})

