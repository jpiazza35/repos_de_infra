/// <reference types="Cypress" />
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import projectDetails from '../../../../pageObjects/Project/ProjectDetails.js'
import dayjs from 'dayjs'

describe("MPT - Project Details", { testIsolation: false }, function () {
    before(function () {
        cy.intercept('get', '**/api/users/organizations').as('waitForIt')
        cy.intercept('get', '**/api/projects/details/*/benchmark-data-types').as('benchmarkDataTypes')
        // cy.visit('/projects')
        cy.logintoMPT();
        cy.wait('@waitForIt').its('response.statusCode').should('eq', 200)
        Cypress.Commands.add('getElementsInTBody', (elementSelector) => {
            let elements = []
            cy.get('tbody').eq(1).within(() => {
                cy.get('tr').each(($tr) => {
                    cy.wrap($tr).within(() => {
                        cy.get(elementSelector).then(($element) => {
                            cy.wrap($element).then((text) => {
                                elements.push(text);
                            })
                        })
                    })
                })  
            })
            .then(() => {
                return elements;
            })
        })
    });

    beforeEach(function () {
        cy.fixture('Project/project_data').as('data')
        cy.visit('/projects')
        cy.intercept('get', '**/api/projects/details/*/benchmark-data-types').as('benchmarkDataTypes')
    });

    after(function () {
        cy.logoutMPT();
    });

    it('04.01: validate fields and labels in add project popup', function () {
        const today = dayjs().format('MM/DD/YYYY')
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        // cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        projectDetails.modalTitle().should('be.visible').should('contain', 'Project Details')
        projectDetails.benchmarkDataTypeInfoCardHeader().should('be.visible').should('contain', 'Benchmark Data Type Info').should('be.enabled').click() //avoid scrolling in the popup
        projectDetails.projInfoCardHeader().should('be.visible').should('contain', 'Project Info')
        projectDetails.orgLabel().should('be.visible').should('contain', 'Organization (Name or ID)')
        projectDetails.orgField().should('be.visible').should('have.attr','placeholder', "Select an Organization").should('be.enabled')
        projectDetails.versionDateLabel().should('be.visible').should('contain', 'Project Version Date')
        projectDetails.versionDateField().should('be.visible').should('be.disabled').should('have.value', today)
        projectDetails.projectStatusLabel().should('be.visible').should('contain', 'Project Status')
        projectDetails.projectStatusDropdown().should('be.visible').should('be.enabled').children().first().should('have.text', 'Draft ').should('be.selected')
        projectDetails.projectNameLabel().should('be.visible').should('contain', 'Project Name')
        projectDetails.projectNameField().should('be.visible').should('have.attr','placeholder', 'Enter Project Name').should('have.attr', 'maxlength', 100).should('be.enabled')
        projectDetails.projectVersionLabel().should('be.visible').should('contain', 'Project Version Label')
        projectDetails.projectVersionLabelField().should('be.visible').should('have.value', '1')
        //workforce project type currently defaults to Employee only
        projectDetails.workforceProjectTypeLabel().should('be.visible').should('contain', 'Workforce Project Type')
        projectDetails.workforceProjectTypeField().should('be.visible').should('have.value', '6').should('contain', 'Employee')
        projectDetails.aggMethodologyLabel().should('contain', 'Aggregation Methodology').and('be.visible')
        projectDetails.aggMethodologyField().should('be.visible').should('be.enabled').children().first().should('have.text', 'Parent ').should('be.selected')
        projectDetails.sourceDataInfoCardHeader().should('be.visible').should('contain', 'Source Data Info')
        projectDetails.noDataLabel().should('be.visible').should('have.html', 'No Data')
        projectDetails.noDataRadioBtn().should('be.visible').should('be.checked')
        projectDetails.useExistingLabel().should('be.visible').should('have.html', 'Use Existing')
        projectDetails.useExistingRadioBtn().should('be.visible').should('not.be.checked')
        projectDetails.uploadNewLabel().should('be.visible').should('have.html', 'Upload New')
        projectDetails.uploadNewRadioBtn().should('not.be.checked')
        projectDetails.benchmarkDataTypeInfoCardHeader().click() //expand the card)
        projectDetails.benchmarkDataTypeTable().should('be.visible')
        const agingfactor = this.data.DefaultAgingFactors
        const datatype = this.data.BenchmarkDataTypes
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            cy.wrap(elements).each((element, i )=> {
                cy.get(element).should('exist').should('be.enabled')
                cy.wrap(element).parent().parent().within(() => {
                    cy.get('td').eq(1).should('exist').should('contain', datatype[i])
                    cy.get('td').eq(2).should('exist').should('have.text', agingfactor[i])
                    if (element.is(':checked')){
                        projectDetails.agingFactorOverrideInput().should('be.enabled')
                        projectDetails.overrideNoteInput().should('be.enabled')
                    }else{
                        projectDetails.agingFactorOverrideInput().should('be.disabled')
                        projectDetails.overrideNoteInput().should('be.disabled')
                    }
                    projectDetails.agingFactorOverrideInput().should('exist')
                    .should('have.attr', 'type', "number")
                    .should('have.attr', 'min', "0")
                    .should('have.attr', 'max', "99.99")
                    .should('have.attr', 'step', "0.1")
                    projectDetails.overrideNoteInput().should('exist')
                .should('have.attr', 'type', 'text')
                .should('have.attr', 'title')
                })
            })
        })
        projectDetails.saveBtn().should('contain', 'Save').and('be.visible').and('be.disabled')
        projectDetails.clearBtn().should('contain', 'Reset').and('be.visible').and('be.disabled')
        projectDetails.closeBtn().should('contain', 'Close').and('be.visible').and('be.enabled')
        projectDetails.popUpClose().should('be.visible').and('be.enabled')
    });

    it('04.02: verify dropdowns in project info section', function () {
        projectPage.addBtn().click()
        projectDetails.aggMethodologyField().select(0)
        projectDetails.aggMethodologyField().children().first().should('have.text', 'Parent ').should('be.selected')
        projectDetails.aggMethodologyField().select(1)
        projectDetails.aggMethodologyField().children().next().should('have.text', 'Child ').should('be.selected')
        projectDetails.projectStatusDropdown().select(0)
        projectDetails.projectStatusDropdown().children().first().should('have.text', "Draft ").should('be.selected')
        projectDetails.projectStatusDropdown().select(1)
        projectDetails.projectStatusDropdown().children().next().should('have.text', "Final ").should('be.selected')
    });
    it('04.03: verify dropdowns in source info section', function () {
        projectPage.addBtn().click()
        projectDetails.useExistingRadioBtn().click().should('be.checked')
        projectDetails.sourceDataLabel().should('have.html', 'Source Data').and('be.visible')
        projectDetails.sourceDataValue().children().first().should("have.text", 'Select Source Data').should('be.selected')
        projectDetails.sourceDataValue().select(1)
        projectDetails.sourceDataValue().children().eq(1).should("have.text", this.data.DownloadTemplateOptions[0]).should('be.selected')
        projectDetails.sourceDataValue().select(2)
        projectDetails.sourceDataValue().children().eq(2).should("have.text", this.data.DownloadTemplateOptions[1]).should('be.selected')
    })
    it('04.04: verify a datepicker display box for the user to select an effective date', function () {
        projectPage.addBtn().click()
        projectDetails.uploadNewRadioBtn().click()
        //display data effective data label
        projectDetails.effectiveDateLabel().should('have.html', 'Data Effective Date').and('be.visible')
        // datepicker display box
        projectDetails.effectiveDateValue().should('have.attr', 'type', 'date').and('be.visible')
        projectDetails.effectiveDateValue().should('have.value', '')
        //once selected, the effective date will appear in the datepicker display box - this is a required selection 
        const date = dayjs().format('YYYY-MM-DD')
        //select date
        projectDetails.effectiveDateValue().type(date)
        //date appears in datepicker display box
        projectDetails.effectiveDateValue().should('have.value', date)
    })
    it('04.05: verify a file upload box for the user to select a file', function () {
        projectPage.addBtn().click()
        projectDetails.uploadNewRadioBtn().click()
        //display text label
        projectDetails.uploadDataLabel().should('have.html', 'Upload your data here (CSV only)').and('be.visible')
        //file must be a .csv
        projectDetails.uploadDataValue().should('have.attr', 'accept', '.csv')
        projectDetails.uploadDataValue().should('have.attr', 'type', 'file')
        //provide ability for user to click select files button
        projectDetails.uploadDataValue().should('be.visible').and('be.enabled')
        projectDetails.uploadDataValue().selectFile('cypress/fixtures/Project/14767_Invalid_Upload.xlsx')
        //not a csv - display an error message
        projectDetails.errorNotification().should('be.visible')
        //validation will occur when a csv is selected
        projectDetails.uploadDataValue().selectFile('cypress/fixtures/Project/14767_Job_Upload.csv')
        //file name of the selected file will appear in the display box 
        projectDetails.uploadDataValue().invoke('val').should('contain', '14767_Job_Upload.csv')
    })
    it('04.06: verify no file upload validation is needed when using existing data', function () {
        projectPage.addBtn().click()
        projectDetails.useExistingRadioBtn().click().should('be.checked')
        projectDetails.uploadDataValue().should('not.exist')
        projectDetails.noDataRadioBtn().click().should('be.checked')
        projectDetails.uploadDataValue().should('not.exist')
    })
    it('04.07: verify Aging Factor sorts (min-max)', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        // cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        const agingfactor = this.data.DefaultAgingFactors
        let sort = agingfactor.sort()
        projectDetails.agingFactorColumn().click();
        cy.getElementsInTBody(':nth-child(3)').then((elements, i) => {
            cy.wrap(elements).each((element, i ) => {
                cy.wrap(element).should('exist').should('contain',sort[i])
            })
        })
    })
    it('04.08 verify Included sorts (unchecked-checked)', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        // cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200);
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            const sort = [...elements].sort()
            cy.log(elements, sort)
            projectDetails.includeColumn().click().then(() => {
                expect([...elements]).to.deep.equal(sort)
            });
        });
    })
    it('04.09: verify Aging Factor Override sorts (min-max)', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            const sort = [...elements].sort()
            let override = 1
            cy.get(elements).each((element) => {
                cy.wrap(element).parent().parent().within(() => {    
                if (element.is(':checked')){
                    projectDetails.agingFactorOverrideInput().type(override)
                }else{
                    projectDetails.agingFactorOverrideInput().should('be.disabled')
                }
                });
            });
            projectDetails.agingFactorOverrideColumn().click().then(() => {
                expect([...elements]).to.deep.equal(sort)
            });
        });
    });
    it('04.10: verify Override Note sorts (min-max)', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            const sort = [...elements].sort()
            let override = 1
            cy.get(elements).each((element) => {
                cy.wrap(element).parent().parent().within(() => {    
                if (element.is(':checked')){
                    
                    projectDetails.overrideNoteInput().type('test' + override++)
                }else{
                    
                    projectDetails.overrideNoteInput().should('be.disabled')
                }
                });
            });
            projectDetails.overrideNoteColumn().click().then(() => {
                expect([...elements]).to.deep.equal(sort)
            });
        });
    })

    it('04.11: verify aging factor override requires override note', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            let override = 1
            cy.get(elements).each((element) => {
                cy.wrap(element).parent().parent().within(() => {    
                if (element.is(':checked')){
                    projectDetails.agingFactorOverrideInput().type(override)
                }else{
                    projectDetails.agingFactorOverrideInput().should('be.disabled')
                }
                })
            })
            projectDetails.saveBtn().click()
            cy.get(elements).each((element) => {
                cy.wrap(element).parent().parent().within(() => {    
                if (element.is(':checked')){
                    projectDetails.overrideNoteInput().should('have.class', "form-control is-invalid")
                }else{
                    projectDetails.overrideNoteInput().should('be.disabled')
                }
            })
        });
    })
})
    it('04.12: verify user is able to uncheck and recheck rows', function () {
        projectPage.addBtn().click()
        projectDetails.closeBtn().click()
        projectPage.addBtn().click()
        // cy.wait('@benchmarkDataTypes').its('response.statusCode').should('eq', 200)
        cy.getElementsInTBody('input[type="checkbox"]').then((elements) => {
            cy.get(elements).each((element) => {
                cy.wrap(element).within(() => {    
                    cy.wrap(element).click().then(() => {
                        const isChecked = element.is(':checked');
                        cy.wrap(element).click().should(isChecked ? 'not.be.checked' : 'be.checked');
                        cy.wrap(element).click().should(isChecked ? 'be.checked' : 'not.be.checked');
                    });
                });
            });
        });
    });
    it('04.13: do not allow final projects to be deleted', function () {
        cy.selectOrg(this.data.OrgId, this.data.OrgName)
        cy.get('td').contains('Final').parent().within(() => {
            projectPage.projectDeleteBtn().eq(0).should('contain', 'Delete').should('be.disabled')
        })
    });
    it('04.14: verify clear button clear selections to default', function () {
        projectPage.addBtn().click()
         cy.selectOrg(this.data.OrgId, this.data.OrgName)
        projectDetails.projectNameField().type('test project',{scrollBehavior: false})
        projectDetails.projectStatusDropdown().select(1)
        projectDetails.projectVersionLabelField().type('test')
        projectDetails.aggMethodologyField().select(1)
        projectDetails.useExistingRadioBtn().click()
        projectDetails.clearBtn().should('be.enabled').click({ force: true })
        projectDetails.confirmationPopUp().should('be.visible')
        projectDetails.confirmationPopUpNoBtn().should('be.visible')
        projectDetails.confirmationPopUpYesBtn().should('be.visible').click()
        cy.get('div[class="s-z2VOlS585TFB window"]').within(() => {
            projectDetails.projectNameField().invoke('val').should('eq', '')
            projectDetails.projectStatusDropdown().children().first().should('be.selected')
            projectDetails.projectVersionLabelField().invoke('val').should('eq', '1')
            projectDetails.aggMethodologyField().children().first().should('be.selected')
            projectDetails.noDataRadioBtn().should('be.checked')

        })
    });
    it('04.15: verify close button closes the popup', function () {
        projectPage.addBtn().click()
        projectDetails.projectNameField().clear({scrollBehavior: false}).type('test project',{scrollBehavior: false})
        projectDetails.closeBtn().should('be.enabled').click()
        projectDetails.confirmationPopUp().last().should('be.visible')
        projectDetails.confirmationPopUpNoBtn().last().should('be.visible')
        projectDetails.confirmationPopUpYesBtn().last().should('be.visible').click()
        cy.get('div[class="s-z2VOlS585TFB window"]').should('not.exist')
    })
});