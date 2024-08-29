/// <reference types="Cypress" />
class ManageEngmnt {

    adminDropDown() {
        return cy.get(':nth-child(4) > .dropdown-toggle')
    }

    adminDropDownList() {
        return cy.get('li[class="dropdown open"] ul a')
    }

    manageEngagement() {
        return cy.get('.dropdown-menu > :nth-child(4) > a')
    }

    breadcrumbManageEngmnt() {
        return cy.get('#breadcrumb > :nth-child(3) > a')
    }

    allTabs() {
        return cy.get('#body > .tabholder >.tabpar div')
    }


}
const manageEngmnt = new ManageEngmnt()
export default manageEngmnt