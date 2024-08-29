/// <reference types="Cypress" />
import publishData from "../../../pageObjects/PNASupply/PublishData"
import select_ClientAndEngagement from "../../../pageObjects/PNASupply/Select_ClientAndEngagement"

describe('Publish Data tab', { testIsolation: false }, function () {
    before(function () {
        cy.visit('/')
        //cy.userLogin(Cypress.env("clientportal_username"), Cypress.env("clientportal_password"))
        cy.navigateToPnaSupply() 
    })
    beforeEach(function () {
        cy.fixture('01_pnaSupply/pna_supply_data').as('pna_supply_data') 
        cy.fixture('01_pnaSupply/pna_publishData_data').as('publish_data')
        cy.listenToClickEventForDownload()
    });

    // after(function () {
    //     cy.logoutClientPortal();
    // });

    it('06: Select Client and Engagement - Version', function () {
        select_ClientAndEngagement.selectClientParent()
        select_ClientAndEngagement.selectEngagement_Version_2019()
       
    })

    it('06: Navigate to Publish Data tab', function () {
        publishData.publishDataTab().contains(this.pna_supply_data.pnaSupplyTabs[6]).click()
        publishData.breadcrumbPublishData().should('contain', 'Publish Data')
    })

    it('06: Verify the Publish Data table header', function () {
        cy.get('thead tr').within(() => {
            cy.contains('Log Number').should('be.visible')
            cy.contains('Client').should('be.visible')
            cy.contains('Engagement - Version').should('be.visible')
            cy.contains('Publish Requested By').should('be.visible')
            cy.contains('Publish Requested Date').should('be.visible')
            cy.contains('Publish Status').should('be.visible')
            cy.contains('Publish Start Time').should('be.visible')
            cy.contains('Publish Completed Time').should('be.visible')
            cy.contains('Published Version').should('be.visible')
            cy.contains('Active Location Count').should('be.visible')
            cy.contains('Patient Management Factor %').should('be.visible')
        })
    })

    it('06: Verify the Publish button exists', function () {
        publishData.publishDataBtn().contains('Publish').should('be.visible').should('not.be.disabled')
    })
    
    it.skip('06: Verify the content of confirmation popup window', function () {
        publishData.publishDataBtn().click()
        publishData.confirmPopup().should('be.visible').and('contain.text', this.publish_data.confirmPopupMsg)
        publishData.confirmPopup().should('contain', 'Yes').and('contain','No')
    })


})