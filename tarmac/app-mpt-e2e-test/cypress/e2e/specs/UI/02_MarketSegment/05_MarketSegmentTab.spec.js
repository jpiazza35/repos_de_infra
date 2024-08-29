/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment';

describe("MPT - Market Segment Tab", { testIsolation: false }, function () {

    before(function () {
        // cy.visit('/')
        cy.logintoMPT();
        projectPage.mktSegmentTab().should('be.visible').click();
    });

    beforeEach(function () {
        cy.fixture('MarketSegment/market_segment_data').as('mktSegmentData')
        cy.fixture('Project/project_data').as('projectData')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('05: verify top level filters', function () {
        //org        
        projectPage.orgLabel().should('contain', 'Organization (Name or ID)')
        projectPage.orgField().should('be.visible')
        projectPage.orgField().should('have.attr', 'placeholder', 'Select an Organization')
        //project ID
        projectPage.projectLabel().should('contain', 'Project (Name or ID)')
        projectPage.projectField().should('be.visible')
        projectPage.projectField().should('contain', 'Select a Project')
        //project version
        projectPage.projectVersionLabel().should('contain', 'Project Version (Label or ID)')
        projectPage.projectVersionField().should('be.visible')
        projectPage.projectVersionField().should('contain', 'Select a Project Version')
    });

    it('05: verify the message when org, project ID and project version are not selected', function () {
        let orgerrorMessage;
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentData.orgErrorMessage)

    });

    it('05: verify the message when only org is selected', function () {
        projectPage.orgField().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentData.projectIdErrorMessage)

    });

    it('05: verify the message when only org and project ID are selected', function () {
        projectPage.projectField().contains(this.projectData.ProjectNameIncumbentData).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectField().select(optionValue).wait(500);
        });
        projectPage.alertMessage().trimmedText().should('eq', this.mktSegmentData.projectVersionErrorMessage)

    });

    it('05: verify no sections are displayed when we select incumbent project and version', function () {
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        marketSegment.noDataSection().should('exist')
    });

    it('05: verify the buttons and fields under Market Segment Tab', function () {
        marketSegment.addBtn().should('be.visible').should('be.enabled')
        marketSegment.editBtn().should('be.visible').should('be.enabled')
        marketSegment.deleteBtn().should('be.visible').should('not.be.enabled')
        marketSegment.saveAsBtn().should('be.visible').should('not.be.enabled')
        marketSegment.clearBtn().should('be.visible').should('be.enabled')
        marketSegment.marketSegmentLabel().should('contain', 'Market Segment Name')
        marketSegment.marketSegmentField().should('be.visible').should('be.enabled')
        marketSegment.marketSegmentField().should('have.attr', 'placeholder', 'Enter Market Segment Name')
    });

    it('05: verify full screen functionality', function () {
        marketSegment.fullscrBtn().click()
        marketSegment.fullscrBtn().should('contain', 'Exit Full Screen')
        //except for buttons other sections should be hidden in full screen mode
        homePage.logo().should('not.be.visible')
        homePage.sidebarToggle().should('not.be.visible')
        projectPage.pageTitle().should('not.be.visible')
        //exit full screen mode
        marketSegment.fullscrBtn().click()
        marketSegment.fullscrBtn().should('contain', 'Full Screen')
        homePage.appWindow().scrollTo('top')
        homePage.logo().should('be.visible')
        projectPage.pageTitle().should('be.visible')
    });   

});