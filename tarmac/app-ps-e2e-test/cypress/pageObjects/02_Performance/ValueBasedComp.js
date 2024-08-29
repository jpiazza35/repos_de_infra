/// <reference types="Cypress" />

class ValueBasedComp {

    logoutBtn() {
        return cy.get('.justify-end > .text-center')
    }
    valueBasedCompensationTitle() {
        return cy.get('[data-cy="valueBasedCard"] > .bg-white > .justify-between >')
    }
    measureTypeDesc() {
        return cy.get(':nth-child(2) > .col-span-2')
    }
    compAssigned() {
        return cy.get('[data-cy="valueBasedCard"] > .bg-white > :nth-child(2) >')
    }
    YtdCompEligible() {
        return cy.get('[data-cy="valueBasedCard"] > .bg-white > :nth-child(2) >')
    }
    access() {
        return cy.get('[data-cy="valueBasedCard"] > .bg-white > :nth-child(3) > :nth-child(1)')
    }
    compAssignedAccess() {
        return cy.get('[data-cy="valueBasedCard"] > .bg-white > :nth-child(3) > :nth-child(2)')
    }
    YTDEligibleAccess() {
        return cy.get('.bg-white > :nth-child(3) > :nth-child(3)')
    }
    patientExperience() {
        return cy.get(':nth-child(3) > :nth-child(4)')
    }
    patientExpCompAssign() {
        return cy.get(':nth-child(3) > :nth-child(5)')
    }
    patientExpYtdCompEligible() {
        return cy.get('.text-error')
    }
    quality() {
        return cy.get(':nth-child(3) > :nth-child(7)')
    }
    qualityCompAssign() {
        return cy.get(':nth-child(3) > :nth-child(8)')
    }
    qualityCompEligible() {
        return cy.get(':nth-child(3) > :nth-child(9)')
    }
}

const valBasedComp = new ValueBasedComp();
export default valBasedComp;
