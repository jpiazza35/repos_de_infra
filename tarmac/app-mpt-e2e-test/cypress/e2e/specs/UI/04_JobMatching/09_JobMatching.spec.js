/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment'
import jobMatching from '../../../../pageObjects/JobMatching/JobMatching';

describe("JM - Job Matching Tab", { testIsolation: false }, function () {
    before(function () {
        // cy.visit('/')
        cy.logintoMPT();
        jobMatching.jobMatchingTab().click()
        jobMatching.jobMatchingTab().should('have.attr', 'class', 'active s-crl4Ggy-CQ13')
    });

    beforeEach(function () {
        cy.fixture('JobMatching/job_matching_data').as('jobmatchingdata')
        cy.fixture('Project/project_data').as('projectData')
        cy.fixture('MarketSegment/market_segment_data').as('mktSegmentData')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('10: Verify top level filters', function () {
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

    it('10: Verify the message when org, project ID and project version are not selected', function () {
        let orgerrorMessage;
        projectPage.alertMessage().trimmedText().should('eq', this.jobmatchingdata.orgErrorMessage)
    });

    it('10: Verify the message when only org is selected', function () {
        projectPage.orgField().first().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.alertMessage().trimmedText().should('eq', this.jobmatchingdata.projectIdErrorMessage)
    });

    it('10: Verify the message when only org and project ID are selected', function () {
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const optionValue = $option.val()
            const projectID = $option.val().slice(-3)
            cy.wrap(projectID).as('projectID')
            projectPage.projectField().select(optionValue).wait(500);
        });
        projectPage.alertMessage().trimmedText().should('eq', this.jobmatchingdata.projectVersionErrorMessage)
    });

    it('10: Verify that data is displayed when we select project and version', function () {
        cy.intercept('get', '**/api/projects/market-segment-mapping/*/jobs').as('jobs')
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        cy.wait('@jobs').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        jobMatching.grid().should('exist')
    });

    it('10: Verify the buttons and fields under Job Matching Tab', function () {
        jobMatching.jobMatch().should('be.visible').should('be.enabled')
        jobMatching.statusChange().should('be.visible').should('be.enabled')
        jobMatching.exportBtn().should('be.visible').should('be.enabled')
        jobMatching.settingsIcon().should('be.visible')
        jobMatching.fullScreen().should('be.visible').should('be.enabled')
        jobMatching.methodology().should('contain', 'Aggregation Methodology')
    });

    it('10: Verify full screen functionality', function () {
        jobMatching.fullScreen().click()
        jobMatching.fullScreen().should('contain', 'Exit Full Screen')
        //except for buttons other sections should be hidden in full screen mode
        homePage.logo().should('not.be.visible')
        homePage.sidebarToggle().should('not.be.visible')
        projectPage.pageTitle().should('not.be.visible')
        //exit full screen mode
        jobMatching.fullScreen().click()
        jobMatching.fullScreen().should('contain', 'Full Screen')
        homePage.appWindow().scrollTo('top')
        homePage.logo().should('be.visible')
        projectPage.pageTitle().should('be.visible')
    });

    Cypress.Commands.add('applyFilters', (title, input) => {
        jobMatching.gridTableheader().contains('th', title).within(() => {
            jobMatching.enterfilter().click()
        })
        jobMatching.enterfiltertext().type(input, { force: true })
        jobMatching.filterButton().click({ force: true })
    });

    Cypress.Commands.add('clearFilters', (title) => {
        jobMatching.gridTableheader().contains('th', title).within(() => {
            jobMatching.enterfilter().click()
        })
        jobMatching.clearFilterButton().click({ force: true })
    });

    it('10: Verify Grid Filter Functionality', function () {
        let title = 'Client Job Title'
        cy.applyFilters(title, this.jobmatchingdata.clientJobTitle[0])
        jobMatching.gridTablebody().first().find('tr').should('have.length', 1)
        jobMatching.itemsCount().should('contain', "1 items found")
        cy.clearFilters(title)
        jobMatching.gridTablebody().first().find('tr').should('have.length.greaterThan', 1)
    })

    it('10: Verify Grid Sort Functionality', function () {
        jobMatching.gridTableheader().contains('th', "Client Job Title").click();
        jobMatching.gridTableheader().contains('th', "Client Job Title").parent().find('.k-svg-i-sort-asc-small').should('exist')
        const valuesArrayASC = [];
        jobMatching.gridTablebody().last().find(' tr td:nth-child(2)').each((item) => {
            valuesArrayASC.push(item.text());
        })
        const sortedArrayASC = valuesArrayASC.sort();
        cy.wrap(valuesArrayASC).should('deep.equal', sortedArrayASC)

        jobMatching.gridTableheader().contains('th', "Client Job Title").click();
        jobMatching.gridTableheader().contains('th', "Client Job Title").parent().find('.k-svg-i-sort-desc-small').should('exist')

        const valuesArrayDESC = [];
        jobMatching.gridTablebody().last().find(' tr td:nth-child(2)').each((item) => {
            valuesArrayDESC.push(item.text());
        })
        const sortedArrayDESC = valuesArrayDESC.sort().reverse();
        cy.wrap(valuesArrayDESC).should('deep.equal', sortedArrayDESC)
    })

    it('10: Verify Job Maching export functionality', function () {
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const parts = $option.val().split('- ')
            const projectID = parts[parts.length - 1].trim();
            cy.exportPageLoadEvents();
            jobMatching.exportBtn().first().click()
            cy.wait(1000)
            //Verify the file is downloaded
            cy.verifyDownload(`JobMatchingExport_ProjectID_${projectID}.xlsx`, { timeout: 5000 });
            //data to validate
            cy.parseXlsx(`cypress/downloads/JobMatchingExport_ProjectID_${projectID}.xlsx`).then(jsonData => {
                //Verify Table header matches
                expect(jsonData[0].data[0]).to.eqls(this.jobmatchingdata.jobMachingExport);
                //Verify the excel file has data
                expect(jsonData[0].data.length).to.be.greaterThan(parseInt(this.jobmatchingdata.jobMachingRowCount, 10));
            })
        });
    });

    it('10: Verify Status Change Functionality', function () {
        jobMatching.statusChange().click()
        jobMatching.statusChange().parent().find('ul li').should('have.length', this.jobmatchingdata.statusChangeOptions.length)
        jobMatching.statusChange().parent().find('ul li').first().click()
        cy.contains('Please select at least one job match')
        let title = 'Client Job Title'
        cy.applyFilters(title, this.jobmatchingdata.clientJobTitle[0])
        jobMatching.gridTablebody().first().find('tr td input').first().check()
        jobMatching.statusChange().click()
        jobMatching.statusChange().parent().find('ul li').last().click()
        cy.contains('Status updated successfully')
        jobMatching.gridTablebody().last().find(' tr td:nth-child(8)').should('contain', this.jobmatchingdata.statusChangeOptions[2])
        jobMatching.gridTablebody().first().find('tr td input').first().check()
        jobMatching.statusChange().click()
        jobMatching.statusChange().parent().find('ul li').first().click()
        cy.contains('Status updated successfully')
        jobMatching.gridTablebody().last().find(' tr td:nth-child(8)').should('contain', this.jobmatchingdata.statusChangeOptions[0])
        cy.clearFilters(title)
    })

    it('10: Verify table headers', function () {
        jobMatching.gridTableheader().find('th .k-column-title').each(($element, index) => {
            cy.wrap($element.text()).should('contain', this.jobmatchingdata.jobMachingExport[index])
        })
    })

    it('10: Verify settings options', function () {
        jobMatching.settingsIcon().click()
        jobMatching.settingsOptions().should('be.visible').find('ul li').each(($element, index) => {
            cy.wrap($element.text()).should('contain', this.jobmatchingdata.settingsOptions[index])
        })
        jobMatching.settingsOptions().contains('button', 'Cancel').click()
    })

    it('10: Verify table headers and export functionality when we deselect an option under settings', function () {
        let option = this.jobmatchingdata.settingsOptions[0]
        jobMatching.settingsIcon().click()
        jobMatching.settingsOptions().contains('ul li', option).find('input').uncheck()
        jobMatching.settingsOptions().contains('button', 'Apply').click()
        let newHeaders = this.jobmatchingdata.jobMachingExport.filter(item => item !== option)
        jobMatching.gridTableheader().find('th .k-column-title').filter(':visible').each(($element, index) => {
            cy.wrap($element.text()).should('contain', newHeaders[index])
        })
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const parts = $option.val().split('- ')
            const projectID = parts[parts.length - 1].trim();
            // Verify export after deselecting options
            cy.exportPageLoadEvents();
            jobMatching.exportBtn().first().click()
            cy.wait(1000)
            //Verify the file is downloaded
            cy.verifyDownload(`JobMatchingExport_ProjectID_${projectID}.xlsx`, { timeout: 5000 });
            //data to validate
            cy.parseXlsx(`cypress/downloads/JobMatchingExport_ProjectID_${projectID}.xlsx`).then(jsonData => {
                //Verify Table header matches
                expect(jsonData[0].data[0]).to.eqls(newHeaders);
                //Verify the excel file has data
                expect(jsonData[0].data.length).to.be.greaterThan(parseInt(this.jobmatchingdata.jobMachingRowCount, 10));
            })
        })
        jobMatching.settingsIcon().click()
        jobMatching.settingsOptions().contains('ul li', option).find('input').check()
        jobMatching.settingsOptions().contains('button', 'Apply').click()
    })

    Cypress.Commands.add('includebenchmarkdatatypes', (option, projectname, benchmarktypes) => {
        projectPage.projectTab().click()
        projectPage.gridData().find('tr').should('have.length', 1);
        projectPage.gridData().find('tr').should('contain', projectname)
        cy.intercept('get', '**/api/projects/details/*/benchmark-data-types').as('benchmarkDataTypes')
        projectPage.detailsLink().click()
        cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        projectDetails.projectDetailsCardHeader().should('be.visible')
        // include benchmark data types
        projectDetails.saveBtn().should('be.disabled')
        if (option == 'check') {
            cy.wrap(benchmarktypes).each((option) => {
                projectDetails.benchmarkDataTypeTableBody().contains('tr', option).find('[type="checkbox"]').check()
            })
        } else if (option == 'uncheck') {
            cy.wrap(benchmarktypes).each((option) => {
                projectDetails.benchmarkDataTypeTableBody().contains('tr', option).find('[type="checkbox"]').uncheck()
            })
        }
        projectDetails.saveBtn().should('be.enabled').click()
        cy.contains('Data has been saved successfully')
        projectDetails.popUpClose().click()
    });

    it('10: Validate job matching table headers when we select benchmark data types under Project tab(Project details) ', function () {
        cy.includebenchmarkdatatypes('check', this.projectData.ProjectNameAutomation, this.jobmatchingdata.benchmarkDataTypes)
        jobMatching.jobMatchingTab().click()
        jobMatching.grid().should('exist')
        let newHeaders = this.jobmatchingdata.jobMachingExport.concat(this.jobmatchingdata.benchmarkDataTypes[0], this.jobmatchingdata.benchmarkDataTypes[1])
        jobMatching.gridTableheader().find('th .k-column-title').filter(':visible').each(($element, index) => {
            cy.wrap($element.text()).should('contain', newHeaders[index])
        })
        let newOptions = this.jobmatchingdata.settingsOptions.concat(this.jobmatchingdata.benchmarkDataTypes[0], this.jobmatchingdata.benchmarkDataTypes[1])
        jobMatching.settingsIcon().click()
        jobMatching.settingsOptions().should('be.visible').find('ul li').each(($element, index) => {
            cy.wrap($element.text()).should('contain', newOptions[index])
        })
        jobMatching.settingsOptions().should('be.visible').contains('ul li', this.jobmatchingdata.benchmarkDataTypes[1]).should('exist')
        jobMatching.settingsOptions().contains('button', 'Cancel').click()
        cy.includebenchmarkdatatypes('uncheck', this.projectData.ProjectNameAutomation, this.jobmatchingdata.benchmarkDataTypes)
    })

    it('10: Verify the buttons and fields under Job Match PopUp', function () {
        cy.intercept('get', '**/api/projects/market-segment-mapping/*/jobs').as('jobs')
        jobMatching.jobMatchingTab().click()
        cy.wait('@jobs').its('response.statusCode').should('eq', 200)
        jobMatching.jobMatch().click()
        cy.contains(this.jobmatchingdata.jobMatchError)
        jobMatching.gridTablebody().first().find('tr td input').first().check()
        jobMatching.jobMatch().click()
        jobMatching.jobMatchPopup().should('be.visible')
        //Verify buttons
        jobMatching.saveAndClose().should('be.visible').should('be.disabled')
        jobMatching.reset().should('be.visible').should('be.disabled')
        jobMatching.jobCode().should('be.visible').should('be.enabled')
        jobMatching.jobTitle().should('be.visible').should('be.enabled')
        jobMatching.jobMatchStatus().scrollIntoView().should('be.visible').should('be.enabled')
        jobMatching.jobDescription().should('be.visible').should('be.enabled')
        jobMatching.auditTable().first().should('be.visible')
        jobMatching.auditTable().last().should('be.visible')
        jobMatching.auditTable().eq(1).should('be.visible')
        jobMatching.searchStandard().should('be.enabled')
        jobMatching.jobMatchPopupClose().click()
        // Confirmation 
        cy.get('body').then(($element) => {
            if ($element.find('#dialog').length == 2) {
                jobMatching.confirmation().parent().contains('button','Yes').click()
            }
        })
        jobMatching.gridTablebody().first().find('tr td input').first().uncheck()
    })

    it('10: Validate Reset Functionality', function () {
        // Filter List
        let title = 'Client Job Title'
        cy.applyFilters(title, this.jobmatchingdata.clientJobTitle[2])
        jobMatching.gridTablebody().first().find('tr').should('have.length', 2)
        jobMatching.itemsCount().should('contain', "2 items found")
        // check 1 item
        jobMatching.gridTablebody().contains('tr', this.jobmatchingdata.clientJobTitle[0]).then(($row) => {
            const rowIndex = $row.parent().children('tr').index($row)
            jobMatching.gridTablebody().first().find('tr td input').eq(rowIndex).check()
        })
        jobMatching.jobMatch().click()
        jobMatching.jobMatchPopup().should('be.visible')
        jobMatching.selectedJobs().should('contain', this.jobmatchingdata.clientJobTitle[0])
        jobMatching.standardGrid().should('contain', this.jobmatchingdata.noStandards)
        cy.intercept('POST', '**/api/survey/cuts-data/standard-jobs').as('standardJobs')
        jobMatching.searchStandard().type(this.jobmatchingdata.searchStandards[0])
        cy.wait('@standardJobs').its('response.statusCode').should('eq', 200)
        jobMatching.autocompleteItems().first().click()
        jobMatching.standardGrid().find('tbody tr').its('length').should('eq', 3)
        // Reset 
        jobMatching.reset().should('be.enabled').click()
        jobMatching.resetDialog().should('be.visible').should('contain', this.jobmatchingdata.resetConfirmation)
        jobMatching.resetDialog().parent().contains('button', 'No').click()
        jobMatching.standardGrid().find('tbody tr').its('length').should('eq', 3)
        jobMatching.reset().should('be.enabled').click()
        jobMatching.resetDialog().should('be.visible').should('contain', this.jobmatchingdata.resetConfirmation)
        jobMatching.resetDialog().parent().contains('button', 'Yes').click()
        jobMatching.standardGrid().find('tbody tr').its('length').should('eq', 1)
    });

    it('10: Validate Selected Standards Functionality', function () {
        jobMatching.standardGrid().should('contain', this.jobmatchingdata.noStandards)
        cy.intercept('POST', '**/api/survey/cuts-data/standard-jobs').as('standardJobs')
        jobMatching.searchStandard().type(this.jobmatchingdata.searchStandards[0])
        cy.wait('@standardJobs').its('response.statusCode').should('eq', 200)
        jobMatching.autocompleteItems().contains(this.jobmatchingdata.searchStandards[1]).first().click()
        jobMatching.standardGrid().find('tbody tr').its('length').should('eq', 3)
        jobMatching.searchStandard().type(this.jobmatchingdata.searchStandards[2]).wait(2000)
        cy.wait('@standardJobs').its('response.statusCode').should('eq', 200)
        jobMatching.autocompleteItems().contains('Loading', { timeout: 20000, interval: 1000 }).should('not.exist')
        jobMatching.autocompleteItems().contains(this.jobmatchingdata.searchStandards[3]).first().click()
        jobMatching.standardGrid().find('tbody tr').its('length').should('eq', 4)
        jobMatching.textAlert().contains(this.jobmatchingdata.blendNoteAlert).should('be.visible')
        jobMatching.textAlert().contains(this.jobmatchingdata.blendTotalAlert).should('be.visible')
        jobMatching.textAlert().contains(this.jobmatchingdata.blendEachAlert).should('be.visible')
        // Add Blend Notes
        jobMatching.blendNotes().type(this.jobmatchingdata.blendNotes)
        jobMatching.textAlert().contains(this.jobmatchingdata.blendNoteAlert).should('not.exist')
        // Blend Percent
        jobMatching.blendPercentage().first().clear().type(this.jobmatchingdata.blendPercent[0])
        jobMatching.blendPercentage().last().clear().type(this.jobmatchingdata.blendPercent[1])
        jobMatching.textAlert().contains(this.jobmatchingdata.blendTotalAlert).should('not.exist')
        jobMatching.textAlert().contains(this.jobmatchingdata.blendEachAlert).should('not.exist')
    })

    it('10: Validate Audit Section', function () {
        jobMatching.auditTable().first().should('contain', this.jobmatchingdata.audittable1[0])
        jobMatching.auditTable().first().should('contain', this.jobmatchingdata.audittable1[1])
        jobMatching.auditTable().first().should('contain', this.jobmatchingdata.audittable1[2])
        jobMatching.auditTable().first().should('contain', this.jobmatchingdata.audittable1[3])
        jobMatching.auditTable().last().should('contain', this.jobmatchingdata.audittable3)
        jobMatching.auditTable().eq(1).should('contain', this.jobmatchingdata.audittable2[0])
        jobMatching.auditTable().eq(1).should('contain', this.jobmatchingdata.audittable2[1])
    })

    it('10: Add Job Description, Notes & Status Section and Save', function () {
        jobMatching.jobDescription().type(this.jobmatchingdata.jobDescription)
        jobMatching.jobMatchNotes().type(this.jobmatchingdata.jobMatchNotes)
        jobMatching.jobMatchStatus().select(this.jobmatchingdata.statusChangeOptions[2])
        jobMatching.saveAndClose().should('be.enabled').click()
    })

    Cypress.Commands.add('validateCellData', (header, data, row) => {
        jobMatching.gridTableheader().find('tr').contains('th', header).then(($column) => {
            const rowIndex = $column.parent().children('th').index($column)
            jobMatching.gridTablebody().last().find(`tr:nth-child(${row}) td:nth-child(${rowIndex + 1})`).should('contain', data)
        })
    });

    it('10: Validate data after update and Save', function () {
        const standard_job_code = this.jobmatchingdata.searchStandards[0] + ' | ' + this.jobmatchingdata.searchStandards[2]
        const standard_job_title = this.jobmatchingdata.searchStandards[1] + ' | ' + this.jobmatchingdata.searchStandards[3]
        cy.validateCellData(this.jobmatchingdata.settingsOptions[4], standard_job_code, 1)
        cy.validateCellData(this.jobmatchingdata.settingsOptions[5], standard_job_title, 1)
        cy.validateCellData(this.jobmatchingdata.settingsOptions[6], this.jobmatchingdata.jobDescription, 1)
        cy.validateCellData(this.jobmatchingdata.settingsOptions[7], this.jobmatchingdata.statusChangeOptions[2], 1)
        cy.validateCellData(this.jobmatchingdata.settingsOptions[8], this.jobmatchingdata.jobMatchNotes, 1)
    })
})