/// <reference types="Cypress" />
class SpecialtiesTab {

    specialtiesTabBtn() {
        return cy.get('.manengspec')
    }

    breadcrumbSpecialties() {
        return cy.get('#breadcrumb > :nth-child(4)')
    }

    listOfSpecialtyGroups() {
        return cy.get('#treeview-kendo > ul > li > ul > li')
    }

    primaryCareGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(1) li')
    }

    medSpecialtiesGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(2) li')
    }

    surgicalSpecialtiesGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(3) li')
    }

    hospitalBasedSpecialtiesGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(4) li')
    }

    pediatricSubspecialtiesGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(5) li')
    }

    ancillarySpecialtiesGroup() {
        return cy.get('#treeview-kendo > ul > li > ul > li:nth-child(6) li')
    }

    specialtiesEditBtn() {
        return cy.get('#btnSpecEdit')
    }

    specialtiesSaveBtn() {
        return cy.get('#btnSpecSave')
    }

    specialtiesCancelBtn() {
        return cy.get('#btnSpecCancel')
    }

    selectAllField() {
        return cy.get('.k-treeview-top.k-treeview-bot')
    }

    selectAllCheckbox() {
        return cy.get('.k-treeview-top.k-treeview-bot > .k-checkbox-wrapper > .k-checkbox ')
    }

    allCheckboxes() {
        return cy.get('li[id="treeview-kendo_tv_active"]')
    }





}
const specialtiestTab = new SpecialtiesTab()
export default specialtiestTab