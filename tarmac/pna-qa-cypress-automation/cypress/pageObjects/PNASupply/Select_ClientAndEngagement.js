/// <reference types="Cypress" />
class Select_ClientAndEngagement {

    clientDropDownArrow() {
        return cy.get(':nth-child(1) > :nth-child(2) > .k-picker > .k-input-button')
    }

    searchClientList() {
        return cy.get('#SearchClient_listbox')
    }

    engagementDropDownArrow() {
        return cy.get(':nth-child(2) > :nth-child(2) > .k-picker > .k-input-button')
    }

    searchEngagementList() {
        return cy.get('#SearchEngagement-list > .k-list-content')
    }

    engagementField() {
        return cy.get('span[aria-controls="SearchEngagement_listbox"] span span')
    }

    clientParent() {
        return cy.get('#SearchClient_listbox > [data-offset-index="2"] > .k-list-item-text')
    }

    clientChild() {
        return cy.get('#SearchClient_listbox > [data-offset-index="0"] > .k-list-item-text')
    }

    clientGrandchild() {
        return cy.get('#SearchClient_listbox > [data-offset-index="1"] > .k-list-item-text')
    }
    
    selectClientParent() {
        this.clientDropDownArrow().click()
        this.clientParent().contains('SullivanCotter Demo_Parent - 10423').click({force: true})
    }

    selectClientChild() {
        this.clientDropDownArrow().click()
        this.clientChild().contains('SullivanCotter Demo_Child - 10424').click({force: true})
    }

    selectClientGrandchild() {
        this.clientDropDownArrow().click()
        this.clientGrandchild().contains('SullivanCotter Demo_Grandchild - 10425').click({force: true})
    }

    selectEngagement_Version_V23() {
        this.engagementDropDownArrow().click()
        this.searchEngagementList().contains('v23').click({force: true})
    }

    selectEngagement_Version_2020() {
        this.engagementDropDownArrow().click()
        this.searchEngagementList().contains('2020').click({force: true})
    }

    selectEngagement_Version_2019() {
        this.engagementDropDownArrow().click()
        this.searchEngagementList().contains('Engagement Demand Test - 2019').click({force: true})
    }










    
}
const select_ClientAndEngagement = new Select_ClientAndEngagement()
export default select_ClientAndEngagement