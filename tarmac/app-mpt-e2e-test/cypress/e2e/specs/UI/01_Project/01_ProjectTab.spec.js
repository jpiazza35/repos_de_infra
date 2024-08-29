/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails';

describe("MPT - Project Tab", { testIsolation: false }, function () {
    before(function () {
        cy.logintoMPT();
        // cy.visit('/')
    });

    beforeEach(function () {
        cy.fixture('Project/project_data').as('projectData')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('01: verify header and footer of project page', function () {
        cy.headerValidation();
        cy.footerValidation();
    });

    it('01: verify sidebar navigation', function () {
        //verify sidebar nav is hidden by default
        homePage.sidebarSection().should('not.be.visible')
        //verify sidebar nav links 
        homePage.sidebarToggle().click()
        homePage.sidebarSection().should('be.visible')
        homePage.productLogo().should('be.visible')
        homePage.productName().should('be.visible').should('contain', 'Market Pricing')
        //verify client portal link - it should redirect to clientportal url
        homePage.clientPortalLink().eq(1).should('contain', 'Client Portal').click()
        cy.url().should('include', Cypress.env("clientPortalUrl"))
        //navigate back to mpt
        cy.visit('/')
    });

    it('01: verify user is able to navigate to project list page', function () {
        homePage.sidebarToggle().click()
        homePage.projectLink().should('contain', 'Project List').click()
        cy.url().should('include', '/projects')
        //verify page title
        projectPage.pageTitle().should('contain', 'Projects')
    });

    it('01: verify top level filters in project list page', function () {
        //org        
        projectPage.orgLabel().should('contain', 'Organization')
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
        //verify organization is required field
        projectPage.orgLabel().should('have.class', 'required')
    });

    it('01: verify the tabs of project list page', function () {
        // 6 tabs should be visible
        projectPage.projectTab().should('be.visible').should('contain', 'Project')
        projectPage.mktSegmentTab().should('be.visible').should('contain', 'Market Segment')
        projectPage.mktSegmentMappingTab().should('be.visible').should('contain', 'Market Segment Mapping')
        projectPage.jobMatchingTab().should('be.visible').should('contain', 'Job Matching')
        projectPage.marketPricingSheetTab().should('be.visible').should('contain', 'Market Pricing Sheet')
        projectPage.jobSummaryTab().should('be.visible').should('contain', 'Market Summary Tables')
        // verify Project tab is selected by default
        projectPage.projectTab().should('have.class', 'active')
    });

    it('01: verify the buttons in project page', function () {
        //verify buttons are visible on the page and are enabled
        //add button
        projectPage.addBtn().should('be.visible').should('be.enabled')
        projectPage.addBtn().should('contain', 'Add Project')
        //download template button
        projectPage.downloadTemplateBtn().should('be.visible').should('be.enabled')
        projectPage.downloadTemplateBtn().should('contain', 'Download Template')
        //export button
        projectPage.exportBtn().should('be.visible').should('be.disabled')
        projectPage.exportBtn().should('contain', 'Export')
        //clear button
        projectPage.clearBtn().should('be.visible').should('be.enabled')
        projectPage.clearBtn().should('contain', 'Clear')
        //full screen button
        projectPage.fullScreenBtn().should('be.visible').should('be.enabled')
        projectPage.fullScreenBtn().should('contain', 'Full Screen')
    });

    it('01: verify full screen functionality', function () {
        projectPage.fullScreenBtn().click()
        projectPage.fullScreenBtn().should('contain', 'Exit Full Screen')
        //except for buttons other sections should be hidden in full screen mode
        homePage.logo().should('not.be.visible')
        homePage.sidebarToggle().should('not.be.visible')
        projectPage.pageTitle().should('not.be.visible')
        //exit full screen mode
        projectPage.fullScreenBtn().click()
        projectPage.fullScreenBtn().should('contain', 'Full Screen')
        homePage.appWindow().scrollTo('top')
        homePage.logo().should('be.visible')
        projectPage.pageTitle().should('be.visible')
    });

    it('01: verify message in project grid if no org is selected', function () {
        projectPage.alertMessage().trimmedText().should('eq', this.projectData.OrgErrorMessage)
    });

    it('01: verify download of the Incumbent Template file', function () { //Bug 82082
        cy.exportPageLoadEvents();
        projectPage.downloadTemplateBtn().click()
        projectPage.downloadIncumbentTemplateBtn().click({ force: true })
        //verify the file is downloaded
        cy.verifyDownload('mpt_incumbent_template.csv', { timeout: 2000 });
        //data to validate
        cy.parseXlsx("cypress/downloads/mpt_incumbent_template.csv").then(
            jsonData => {
                //Verify Table header matches
                expect(jsonData[0].data[0]).to.eqls(this.projectData.IncumbentTemplateData);
                //verify the excel file has no data
                expect(jsonData[0].data.length).to.equal(1);
            })
    });

    it('01: verify download of the Job Template file', function () { //Bug 82082
        cy.exportPageLoadEvents();
        projectPage.downloadTemplateBtn().click()
        projectPage.downloadJobTemplateBtn().click({ force: true })
        //verify the file is downloaded
        cy.verifyDownload('mpt_job_template.csv', { timeout: 2000 });
        //data to validate
        cy.parseXlsx("cypress/downloads/mpt_job_template.csv").then(
            jsonData => {
                //Verify Table header matches
                expect(jsonData[0].data[0]).to.eqls(this.projectData.JobTemplateData);
                //verify the excel file has no data
                expect(jsonData[0].data.length).to.equal(1);
            })
    });

    it.skip('01: verify user is able to search an org and select from auto populate list', function () {
        cy.selectOrg(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName)
        //verify that no projects message is shown
        projectPage.noProjectsMsg().should('contain', 'No projects exist for this organization')
    });

})