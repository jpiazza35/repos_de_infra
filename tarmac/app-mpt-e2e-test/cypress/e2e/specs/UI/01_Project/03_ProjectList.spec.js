/// <reference types="Cypress" />
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails';
import dayjs from 'dayjs';

describe("MPT - Project List", { testIsolation: false }, function () {

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

    const today = dayjs().format('MM/DD/YYYY')

    it('03: verify the project grid column headers', function () {
        cy.selectOrg(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName)
        cy.wait(1000)
        projectPage.projectGridHeader().within(() => {
            cy.contains('Action').should('be.visible')
            cy.contains('Organization').should('be.visible')
            cy.contains('Project Id').should('be.visible')
            cy.contains('Project Name').should('be.visible')
            cy.contains('Project Version').should('be.visible')
            cy.contains('Project Version Label').should('be.visible')
            cy.contains('Version Date').should('be.visible')
        })
        projectPage.gridScrollbar().scrollTo('right')
        projectPage.projectGridHeader().within(() => {
            cy.contains('Project Status').should('be.visible')
            cy.contains('Source Data').should('be.visible')
            cy.contains('Data Effective Date').should('be.visible')
            cy.contains('File Status').should('be.visible')
            cy.contains('Aggregation Methodology').should('be.visible')
            cy.contains('Workforce Project Type').should('be.visible')
        })
    });

    it('03: verify project grid data', function () {
        //verify the number of rows in grid      
        projectPage.gridData().find('tr').should('have.length', this.projectData.ProjectRowCount);
        projectPage.gridData().then(($tbody) => {
            // get all rows in the grid
            const rows = $tbody.find('tr');
            // Iterate over each row
            cy.wrap(rows).each(($row, index) => {
                // Verify the data in each cell of the first row ( test can be expanded to verify for all rows)
                cy.wrap($row)
                    .find('td')
                    .then(($cells) => {
                        if (index === 0) {
                            expect($cells.eq(1)).to.contain(this.projectData.smokeTestsOrgName);
                            expect($cells.eq(3)).to.contain(this.projectData.ExistingDataProjectName);
                            expect($cells.eq(5)).to.contain(this.projectData.ProjectVersionLabel);
                            expect($cells.eq(6)).to.contain(today);
                            expect($cells.eq(7)).to.contain('Draft');
                            expect($cells.eq(8)).to.contain('Job');
                            //expect($cells.eq(9)).to.contain(today);
                            expect($cells.eq(10)).to.contain('Valid');
                            expect($cells.eq(11)).to.contain('Parent');
                            expect($cells.eq(12)).to.contain('Employee');

                        } else if (index === 1) {
                            //can add regression tests to verify all rows data
                        }
                    });
            });
        });
    });

    it('03: verify file upload data', function () { //column header validation fails - Bug - 80282
        projectPage.gridData().then(($tbody) => {
            // get all rows in the grid
            const rows = $tbody.find('tr');
            // Iterate over each row
            cy.wrap(rows).each(($row, index) => {
                cy.wrap($row)
                    .find('td')
                    .then(($cells) => {
                        if (index === 0) {
                            cy.get($cells.eq(8)).invoke('text').then((text) => {
                                if (text.includes('Job')) {
                                    cy.exportPageLoadEvents();
                                    projectPage.gridSourceData().eq(0).click();
                                    cy.wait(2000);
                                    cy.validateCsvFile(this.projectData.JobFileName, parseInt(this.projectData.JobFileRowCount, 10), this.projectData.JobTemplateData);
                                }
                                else {
                                    cy.log("File upload data is not correct")
                                }
                            });

                        } else if (index === 1) {
                            cy.get($cells.eq(8)).invoke('text').then((text) => {
                                if (text.includes('Incumbent')) {
                                    cy.exportPageLoadEvents();
                                    projectPage.gridSourceData().eq(1).click();
                                    cy.wait(2000);
                                    cy.validateCsvFile(this.projectData.IncumbentFileName, parseInt(this.projectData.IncumbentFileRowCount, 10), this.projectData.IncumbentTemplateData);
                                }
                                else {
                                    cy.log("File upload data is not correct")
                                }
                            });
                        }
                    });
            });
        });
    });

    it('03: verify file upload logs', function () {
        //verify that file upload logs link downloads the log file
        projectPage.gridData().then(($tbody) => {
            // get all rows in the grid
            const rows = $tbody.find('tr');
            // Iterate over each row
            cy.wrap(rows).each(($row, index) => {
                cy.wrap($row)
                    .find('td')
                    .then(($cells) => {
                        if (index === 0) {
                            cy.get($cells.eq(10)).invoke('text').then((text) => {
                                if (text.includes('Valid')) {
                                    cy.exportPageLoadEvents();
                                    projectPage.fileStatusLink().eq(0).click();
                                    cy.wait(2000);
                                    const logsFileName = this.projectData.JobFileName + "_" + this.projectData.ProjectVersionLabel + "_Logs.csv"
                                    const expectedFirstRow = this.projectData.FileUploadLogsFirstRow
                                    const expectedLastRow = this.projectData.FileUploadLogsLastRow
                                    cy.verifyCsvData(logsFileName, expectedFirstRow, expectedLastRow);
                                }
                                else {
                                    cy.log("File status is not correct")
                                }
                            });

                        } else if (index === 1) {
                            //can expand tests for downloading logs of all projects for which data is loaded
                        }
                    });
            });
        });
    });

    it('03: verify project grid export', function () {
        cy.exportPageLoadEvents();
        projectPage.exportBtn().first().click()
        cy.wait(1000)
        //verify the file is downloaded
        cy.verifyDownload('ProjectExport.xlsx', { timeout: 2000 });
        //data to validate
        cy.parseXlsx("cypress/downloads/ProjectExport.xlsx").then(
            jsonData => {
                //Verify Table header matches
                expect(jsonData[0].data[0]).to.eqls(this.projectData.ProjectExportData);
                //verify the excel file has data
                expect(jsonData[0].data.length).to.be.eql(parseInt(this.projectData.ProjectRowCount, 10) + 1);
            })
    });

    it('03: Verify Details link', function () {
        //verify project details popup opens
        //regression tests are covered in project details spec
        projectPage.detailsLink().first().click()
        projectDetails.modalTitle().should('contain', 'Project Details').and('be.visible')
        projectDetails.popUpClose().click()
    });

    it('03: Verify Save As functionality', function () {
        projectPage.saveAsLink().first().click()
        projectDetails.modalTitle().should('contain', 'Save As').and('be.visible')
        projectDetails.projectDetailsCardHeader().contains('Project ID -')
        projectDetails.orgLabel().should('contain', 'Organization (Name or ID)').and('be.visible')
        projectDetails.orgField().invoke('val').should('contain', this.projectData.smokeTestsOrgName)
        projectDetails.projectNameLabel().should('contain', 'Project Name').and('be.visible')
        projectDetails.projectNameField().click().clear().type('TestSaveAs')
        projectDetails.projectVersionLabel().should('contain', 'Project Version Label').and('be.visible')
        projectDetails.projectVersionLabelField().should('be.visible').invoke('val').should('eq', '1')
        projectDetails.versionDateLabel().should('contain', 'Project Version Date')
        projectDetails.versionDateField().should('be.disabled').and('be.visible').invoke('val').should('eq', today)
        projectDetails.projectStatusLabel().should('contain', 'Project Status')
        projectDetails.projectStatusDropdown().children().first().should("contain", "Draft").and('have.value', '1')
        projectDetails.aggMethodologyLabel().should('contain', 'Aggregation Methodology')
        projectDetails.aggMethodologyField().children().first().should('contain', 'Parent').and('have.value', '1')
        projectDetails.workforceProjectTypeLabel().should('contain', 'Workforce Project Type')
        projectDetails.workforceProjectTypeField().children().eq(4).should('contain', 'Employee').and('have.value', '6')
        projectDetails.saveBtn().should('contain', 'Save').and('be.visible').and('be.enabled')
        projectDetails.closeBtn().should('contain', 'Cancel').and('be.visible').and('be.enabled')
        projectDetails.popUpClose().should('be.visible').and('be.enabled')

        //verify the project is saved
        projectDetails.saveBtn().click()
        projectDetails.confirmationNotification().should('contain', 'saved successfully')
        //verify the project is reflected in the grid - check row count
        projectPage.gridData().find('tr').should('have.length', parseInt(this.projectData.ProjectRowCount, 10) + 1);


    });

    it('03: Verify Delete functionality', function () {
        projectPage.deleteLink().first().click();
        projectDetails.deleteProjectModal().within(() => {
            cy.contains('Confirmation Required').should('be.visible')
            projectPage.deleteProjectNote().click().type('test')
            cy.contains('button', 'No').should('be.visible')
            cy.contains('button', 'Yes').click({ force: true })
        })
        cy.reload()
        cy.selectOrg(this.projectData.smokeTestsOrgId, this.projectData.smokeTestsOrgName)
        cy.wait(1000)
        //check row count to verify project is deleted
        projectPage.gridData().find('tr').should('have.length', this.projectData.ProjectRowCount);
    });

})