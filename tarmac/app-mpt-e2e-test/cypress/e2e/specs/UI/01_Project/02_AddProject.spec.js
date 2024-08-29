/// <reference types="Cypress" />
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails'
import dayjs from 'dayjs'

describe("MPT - Add Project", { testIsolation: false }, function () {
    before(function () {
        // cy.visit('/projects')
        cy.logintoMPT();
    });

    beforeEach(function () {
        cy.fixture('Project/project_data').as('projectData')
    });

    after(function () {
        cy.logoutMPT();
    });

    Cypress.Commands.add('orgToAddProject', (orgId, orgName) => {
        cy.reload()
        cy.selectOrg(orgId, orgName)
        cy.wait(1000)
        //click on Add Project button
        projectPage.addBtn().click()
        projectDetails.modalTitle().should('contain', 'Project Details')
        //collapse Benchmark Data Types section as the org and project fields are hidden
        projectDetails.benchmarkDataTypeInfoCardHeader().click()
    });

    it('02: Add Project - No Data', function () {
        cy.orgToAddProject(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName);
        projectDetails.projectNameField().click().clear().type(this.projectData.ProjectNameNoData)
        //enter project version label
        projectDetails.projectVersionLabelField().click().clear().type(this.projectData.ProjectVersionLabel)
        //select no data radio button
        projectDetails.noDataRadioBtn().click()
        //click on save and then close the popup
        projectDetails.saveBtn().click().wait(1000)
        projectDetails.confirmationNotification().should('be.visible')
        projectDetails.closeBtn().click()
    });

    it('02: Verify if project with no data is created', function () {
        //verify project with no data is created
        projectPage.projectGrid().within(() => {
            cy.contains(this.projectData.ProjectNameNoData).should('be.visible')
        })
    });

    it('02: Add Project - Job Data', function () {
        const date = dayjs().format('YYYY-MM-DD')
        cy.orgToAddProject(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName);
        //enter project name
        projectDetails.projectNameField().click().clear().type(this.projectData.ProjectNameJobData)
        //enter project version label
        projectDetails.projectVersionLabelField().click().clear().type(this.projectData.ProjectVersionLabel)
        //select upload new radio button
        projectDetails.uploadNewRadioBtn().click()
        //select Job as Source Data
        projectDetails.sourceDataValue().select(2).invoke('val').should('eq', 'Job')
        //input Data Effective Date
        projectDetails.effectiveDateValue().invoke('val', date).trigger('change')
        //select job source data file for upload
        projectDetails.uploadDataValue().selectFile('cypress/fixtures/Project/' + this.projectData.JobFileName + ".csv", { force: true })
        //click on save and then close the popup 
        projectDetails.saveBtn().click().wait(1000)
        projectDetails.closeBtn().click()
    });

    it('02: Verify if project with job data is created', function () {
        //verify project with no data is created
        projectPage.projectGrid().within(() => {
            cy.contains(this.projectData.ProjectNameJobData).should('be.visible')
        })
    });

    it('02: Add Project - Incumbent Data', function () {
        const date = dayjs().format('YYYY-MM-DD')
        cy.orgToAddProject(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName);
        //enter project name
        projectDetails.projectNameField().click().clear().type(this.projectData.ProjectNameIncumbentData)
        //enter project version label
        projectDetails.projectVersionLabelField().click().clear().type(this.projectData.ProjectVersionLabel)
        //select upload new radio button
        projectDetails.uploadNewRadioBtn().click()
        //select Job as Source Data
        projectDetails.sourceDataValue().select(1).invoke('val').should('eq', 'Incumbent')
        //input Data Effective Date
        projectDetails.effectiveDateValue().invoke('val', date).trigger('change')
        //select job source data file for upload
        projectDetails.uploadDataValue().selectFile('cypress/fixtures/Project/' + this.projectData.IncumbentFileName + ".csv", { force: true })
        //click on save and then close the popup 
        projectDetails.saveBtn().click().wait(1000)
        projectDetails.closeBtn().click()
    });

    it('02: Verify if project with incumbent data is created', function () {
        //verify project with no data is created
        projectPage.projectGrid().within(() => {
            cy.contains(this.projectData.ProjectNameIncumbentData).should('be.visible')
        })
    });

    it('02: Add Project - Use Existing Job Data', function () {
        const date = dayjs().format('YYYY-MM-DD')
        cy.orgToAddProject(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName);
        //enter project name
        projectDetails.projectNameField().click().clear().type(this.projectData.ExistingDataProjectName)
        //enter project version label
        projectDetails.projectVersionLabelField().click().clear().type(this.projectData.ProjectVersionLabel)
        //select use existing radio button
        projectDetails.useExistingRadioBtn().click()
        //select Job as Source Data
        projectDetails.sourceDataValue().select(2).invoke('val').should('eq', 'Job')
        //select file with valid status
        projectDetails.existingFileDataEffectiveDate().select(1)
        //click on save and then close the popup 
        projectDetails.saveBtn().click().wait(1000)
        projectDetails.closeBtn().click()
    });

    it('02: Verify if project with using existing data is created', function () {
        //verify project with no data is created
        projectPage.projectGrid().within(() => {
            cy.contains(this.projectData.ExistingDataProjectName).should('be.visible')
        })
    });
})