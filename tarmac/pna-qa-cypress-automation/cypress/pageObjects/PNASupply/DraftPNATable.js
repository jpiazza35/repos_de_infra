/// <reference types="Cypress" />
class DraftPNATable {

draftPNAtab() {
    return cy.get('.draftTableTab')
}

breadcrumbDraftPNA() {
    return cy.get('#breadcrumb > :nth-child(2)')
}

draftPNAFilters() {
   return cy.get('.dynamicSearchFilter')
}

tableAreaNote() {
    return cy.get('#noteArea')
}

draftPNAServiceArea() {
    return cy.get('.dynamicSearch > :nth-child(1) > :nth-child(1)')
}

populationTypeField() {
    return cy.get('#PopulationType')
}

patientMngmntDropdownArrow() {
    return cy.get(':nth-child(3) > :nth-child(2) > .k-picker > .k-input-button')
}

patientMngmntDropdownOptions() {
    return cy.get('ul[id=SearchPatientManagement_listbox] span')
}

providerClassDropdownArrow() {
    return cy.get(':nth-child(5) > :nth-child(2) > .MultiCheckBox > .k-icon')
}

providerClassDropdownOptions() {
    return cy.get(':nth-child(5) > :nth-child(2) > .MultiCheckBoxDetail > .MultiCheckBoxDetailBody > .cont')
}

providerClassDefault() {
    return cy.get(':nth-child(5) > :nth-child(2) > .MultiCheckBoxDetail > .MultiCheckBoxDetailBody > :nth-child(3) input')
}

selectAllProviderClasses() {
    return cy.get(':nth-child(5) > :nth-child(2) > .MultiCheckBoxDetail input[type="checkbox"]')
}

providerClassSelectAllOption() {
    return cy.get(':nth-child(5) > :nth-child(2) > .MultiCheckBoxDetail > .MultiCheckBoxDetailHeader')
}

serviceAreaDropdownArrow() {
    return cy.get('.dynamicSearch > :nth-child(1) > :nth-child(2) > .k-picker > .k-input-button')
}

serviceAreaDropdownOptions() {
    return cy.get('#SearchServiceArea_listbox .k-list-item-text')
}

reportYrDropdownArrow() {
    return cy.get('#divddlSearchReportYear > .MultiCheckBox > .k-icon')
}

reportYrOptions() {
    return cy.get('#divddlSearchReportYear > .MultiCheckBoxDetail > .MultiCheckBoxDetailBody > .cont')
}

reportYrSelectAllOption() {
    return cy.get('#divddlSearchReportYear > .MultiCheckBoxDetail > .MultiCheckBoxDetailHeader')
}

reportYrCheckboxes() {
    return cy.get('#divddlSearchReportYear > .MultiCheckBoxDetail > .MultiCheckBoxDetailBody section > input')
}

tableFirstReportYr() {
    return cy.get('table thead tr:first-of-type th[class="k-header ReportYearGrp_0 wfheaderalign"]')
}

tableHeaderYr() {
    return cy.get('table tr th[colspan="3"]')
}

exportBtn() {
    return cy.get('#exportDraftButton')
}

expandCollapseBtn() {
    return cy.get('#expand-collapse')
}

serviceAreaNote() {
    return cy.get('#noteArea')
}

tableBody() {
    return cy.get('div[class="k-grid-content k-auto-scrollable"] tbody')
}

engagementField() {
    return cy.get('span[aria-controls="SearchEngagement_listbox"] span span')
}

yearsInGridMatchWithDropdown() {
    this.engagementField().then((field) => {
        if(field.text().includes('v23')) {
            this.tableHeaderYr().contains('2023')
            this.tableHeaderYr().contains('2024')
            this.tableHeaderYr().contains('2025')
            this.tableHeaderYr().contains('2026')
            this.tableHeaderYr().contains('2027')
            this.tableHeaderYr().contains('2028')
        } else {
            if(field.text().includes('2020')) {
                this.tableHeaderYr().contains('2020')
                this.tableHeaderYr().contains('2021')
                this.tableHeaderYr().contains('2022')
                this.tableHeaderYr().contains('2023')
                this.tableHeaderYr().contains('2024')
                this.tableHeaderYr().contains('2025')
                
            } else {
                if(field.text().includes('2019')) {
                    this.tableHeaderYr().contains('2019')
                    this.tableHeaderYr().contains('2020')
                    this.tableHeaderYr().contains('2021')
                    this.tableHeaderYr().contains('2022')
                    this.tableHeaderYr().contains('2023')
                    this.tableHeaderYr().contains('2024')
                }
            }
        }
    })
}

tableHeaderDisplaysCorrectReportYears() {
    this.engagementField().then((field) => {
        if(field.text().includes('v23')) {
            this.tableFirstReportYr().should('contain','2023')
        } else {
            if(field.text().includes('2020')) {
                this.tableFirstReportYr().should('contain', '2020')
            } else {
                if(field.text().includes('2019')) {
                    this.tableFirstReportYr().should('contain', '2019')
                }
            }
        }
    })
}

reportYearDropdownValues() {
    this.engagementField().then((field) => {
        if(field.text().includes('v23')) {
            this.reportYrOptions().contains('2023')
            this.reportYrOptions().contains('2024')
            this.reportYrOptions().contains('2025')
            this.reportYrOptions().contains('2026')
            this.reportYrOptions().contains('2027')
            this.reportYrOptions().contains('2028')
        } else {
            if(field.text().includes('2020')) {
                this.reportYrOptions().contains('2020')
                this.reportYrOptions().contains('2021')
                this.reportYrOptions().contains('2022')
                this.reportYrOptions().contains('2023')
                this.reportYrOptions().contains('2024')
                this.reportYrOptions().contains('2025')
                
            } else {
                if(field.text().includes('2019')) {
                    this.reportYrOptions().contains('2019')
                    this.reportYrOptions().contains('2020')
                    this.reportYrOptions().contains('2021')
                    this.reportYrOptions().contains('2022')
                    this.reportYrOptions().contains('2023')
                    this.reportYrOptions().contains('2024')
                }
            }
        }
    })
}

















}
const draftPNATable = new DraftPNATable()
export default draftPNATable