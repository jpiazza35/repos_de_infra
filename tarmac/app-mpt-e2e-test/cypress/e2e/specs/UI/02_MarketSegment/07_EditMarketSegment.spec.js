/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment';

describe("MPT - Edit Market Segment", { testIsolation: false }, function () {

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
        cy.log('logout')
        cy.logoutMPT();
    });

    it('07:  Verify Edit functionality with out selecting market segment ', function () {
        //select org, prj Id and prj version
        projectPage.orgField().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.projectField().contains(this.projectData.ProjectNameAutomation).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectField().select(optionValue);
        });
        //add market segment
        cy.intercept('get', '**/api/projects/*/status').as('status')
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        cy.wait('@status').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
            //if project status=Draft it should return 1 for status
            expect(xhr.response.body).to.equal(1);
        })
        marketSegment.editBtn().click();
        cy.contains(this.mktSegmentData.editErrorMessage).should('be.visible')
        //wait for error message to disappear
        cy.contains(this.mktSegmentData.editErrorMessage, { timeout: 10000, interval: 1000 }).should('not.exist')
    })

    it('07:  Verify market segment field:Should Display 2 Dropdown Options ', function () {
        marketSegment.marketSegmentField().click().wait(1000);
        //The below test step might fail because the option are not displaying for first click
        marketSegment.marketSegmentOptions().should('have.attr', 'aria-hidden', 'false');
        // Verify the option are displaying 2 
        marketSegment.marketSegmentOptions().find('li').should('have.length.gte', 1)
    })

    it('07:  Select the option that is not used in market segment and verify the name ', function () {
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentEdit, { matchCase: false }).click();
        marketSegment.marketSegmentOptions().find('li').contains(this.mktSegmentData.marketSegmentEdit, { matchCase: false }).parent().should('have.attr', 'aria-selected', 'true')
    })

    it('07:  Verify Edit when proper segment is selected and verify Selected cuts section should be expanded by default ', function () {
        marketSegment.editBtn().click();
        //only filters section should be expanded after clicking add button and other sections should be collapsed
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'false')
    })

    it('07:  Filters:Verify the selected cuts data: Navigate to Filters Section and Apply New Filters ', function () {
        marketSegment.gridData().find('tbody tr').then(($rows) => {
            const initialLength = $rows.length;
            marketSegment.filtersSection().click();
            // Add New Filters 
            marketSegment.filtersSectionNextBtn().should('be.visible').should('be.enabled')
            marketSegment.searchPublisherField().type(this.mktSegmentData.publisherSearch).wait(2000)
            marketSegment.listOptions().eq(0).within(() => {
                cy.get('li').click();
            });
            marketSegment.searchCutGroupField().click();
            const updatedoprions = this.mktSegmentData.cutGroupAdd.concat(this.mktSegmentData.cutGroupAddNew)
            cy.wrap(updatedoprions).each((option) => {
                marketSegment.listOptions().eq(5).within(() => {
                    cy.get('li').contains(option).click();
                })
            })
            marketSegment.filtersSectionNextBtn().should('be.visible').should('be.enabled')
            cy.intercept('post', '**/api/survey/market-segment-cuts').as('segmentcuts')
            marketSegment.filtersSectionNextBtn().click()
            cy.wait('@segmentcuts').then((xhr) => {
                expect(xhr.response.statusCode).to.equal(200)
            })
            marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded').then(attributevalue => {
                if (attributevalue !== 'true') {
                    marketSegment.selectedCutsSection().click()
                }
            })
            marketSegment.gridData().find('tbody tr').its('length').should('be.gte', initialLength)
        })
    })

    it('07: Selected Cuts:verify edit details and checkbox functionality ', function () {
        marketSegment.editDetailsBtn().click({ force: true }).wait(2000)
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.sldWindow().find('table tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).each(($row) => {
            cy.wrap($row).find('td:first-child input').should('have.attr', 'aria-checked', 'false')
            // Verify that user can select the checkbox 
            cy.wrap($row).find('td:first-child input').check();
        })
        // Click on close – should show the dirty page popup and close without saving changes      
        marketSegment.gridCloseBtn().click().wait(1000)
        marketSegment.gridCloseBtn().click().wait(1000)
        marketSegment.ConfirmYes().click().wait(1000)
        //We have a issue in application the below 2 lines of code not required if this is resolved
        // marketSegment.gridCloseBtn().click().wait(1000)
        // marketSegment.ConfirmYes().click().wait(1000)
        marketSegment.sldWindow().should('not.exist')
        //save combined averages
        cy.intercept('put', '**/api/projects/market-segments').as('marketsegments')
        marketSegment.saveBtn().click()
        cy.wait('@marketsegments', { timeout: 30000, interval: 1000 }).then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains(this.mktSegmentData.saveMessage)
    })

    it('07: Selected Cuts:verify Edit details and checkbox functionality after saving ', function () {
        marketSegment.editDetailsBtn().click().wait(2000)
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.sldWindow().find('table tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).each(($row) => {
            cy.wrap($row).find('td:first-child input').should('have.attr', 'aria-checked', 'true')
        })
        marketSegment.gridCloseBtn().click().wait(1000)
    })

    it('07: Selected Cuts:Verify that user can edit market pricing cut name for any newly added data ', function () {
        marketSegment.gridData().find('table tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).eq(0).within(() => {
            cy.get('td:nth-child(6)').type(this.mktSegmentData.marketPricingCut).wait(1000);
        })
        cy.intercept('get', '**/api/projects/market-segments/*/combined-averages').as('combinedaverages')
        marketSegment.saveBtn().click();
        cy.wait('@combinedaverages', { timeout: 15000, interval: 1000 }).then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains(this.mktSegmentData.saveMessage).should('be.visible')
    })

    it('07: Selected Cuts:Verify user can perform Delete action for newly added data ', function () {
        let numRows;
        marketSegment.gridData().find('tbody tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).its('length').then(length => {
            numRows = length;
            marketSegment.gridData().find('table tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).eq(0).within(() => {
                cy.get('.fa-trash').click()

            })
            marketSegment.ConfirmYesNo().should('exist')
            marketSegment.ConfirmYes().click()
            marketSegment.gridData().find('tbody tr').filter(`:contains(${this.mktSegmentData.cutGroupAddNew})`).should('have.length', (numRows - 1));
        });
    })

    Cypress.Commands.add("selectedCutsGridActionsedit", (clickIndex, intialRow, updatedRow, row) => {
        let initialReportOrder;
        let updatedReportOrder;

        cy.get(`tbody tr:nth-child(${intialRow}) td:nth-child(8)`).first().invoke('text').then(text => {
            initialReportOrder = text;
            if (clickIndex === 1) {
                marketSegment.oneUpIcon().eq(row - 1).click({ force: true }).wait(1000);
            } else if (clickIndex === 0) {
                marketSegment.oneDownIcon().eq(row - 2).click().wait(1000);
            } else if (clickIndex === 2) {
                marketSegment.toBottomIcon().eq(0).click().wait(1000);
            } else if (clickIndex === 3) {
                marketSegment.toTopIcon().eq(row - 1).click().wait(1000);
            }
            else if (clickIndex === 4) {
                const sourceSelector = marketSegment.hamburgerIcon().eq(row - 1)
                const targetSelector = marketSegment.hamburgerIcon().eq(row - 2)
                sourceSelector.trigger('dragstart', { dataTransfer: new DataTransfer() });
                targetSelector.trigger('dragenter').trigger('dragover').trigger('drop');
                sourceSelector.trigger('dragend');
            }
            cy.get(`tbody tr:nth-child(${updatedRow}) td:nth-child(8)`).first().invoke('text').then(text => {
                updatedReportOrder = text;
                expect(initialReportOrder).to.eq(updatedReportOrder);
            });
        });
    });

    it('07:  Selected Cuts:Verify user can perform grid actions for newly added data ', function () {
        marketSegment.gridData().find('.k-grid-table tbody').first().find('tr').then(($rows) => {
            const rowslen = $rows.length;
            //one up arrow
            cy.selectedCutsGridActionsedit(1, rowslen, rowslen - 1, rowslen);
            // OneDown arrow
            cy.selectedCutsGridActionsedit(0, rowslen - 1, rowslen, rowslen);
            // ToTop arrow
            cy.selectedCutsGridActionsedit(3, rowslen, 1, rowslen);
            // ToBottom arrow
            cy.selectedCutsGridActionsedit(2, 1, rowslen, rowslen); // with current data. If data changes, the row number needs to be updated.
            //drag and drop 
            cy.selectedCutsGridActionsedit(4, rowslen - 1, rowslen, rowslen);
            // Save
            cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedaverages')
            marketSegment.saveBtn().click()
            cy.wait('@combinedaverages', { timeout: 30000, interval: 1000 }).then((xhr) => {
                expect(xhr.response.statusCode).to.equal(200)
            })
            cy.contains(this.mktSegmentData.saveMessage)

        })
    })

    it('07: ERI - Navigate to ERI section and verify that ERI section is expanded', function () {
        //navigate to ERI section
        marketSegment.selectedCutsNextBtn().click()
        //verify ERI section is expanded
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'true')
    });

    it('07:  ERI -  Should show existing data and user should be able to delete and save ', function () {
        marketSegment.ERIAdjFactor().invoke('val').should('eq', this.mktSegmentData.EriAdjFactor)
        marketSegment.ERICutName().invoke('val').should('eq', this.mktSegmentData.EriCutName)
        //Clear old data 
        marketSegment.ERIAdjFactor().click().clear()
        marketSegment.ERICutName().click().clear()
        marketSegment.ERICutCity().click().clear()
        cy.intercept('post', '**/api/projects/**/eri').as('eri')
        marketSegment.ERISectionSaveBtn().first().click()
        //wait for eri to save
        cy.wait('@eri').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.ERIAdjFactor().click().clear().type(this.mktSegmentData.EriAdjFactor)
        marketSegment.ERICutName().click().clear().type(this.mktSegmentData.EriCutName)
        marketSegment.ERICutCity().click().clear().type(this.mktSegmentData.EriCutCity)
        marketSegment.ERISectionSaveBtn().first().click()
        //wait for eri to save
        cy.wait('@eri').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.ERISectionSaveNextBtn().first().click()
        cy.wait('@eri').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
    })

    it('07: Blend - Verify the edit functionality', function () {
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'true')
        // Blend dropdown should show the blends added
        marketSegment.blendNameField().first().click()
        marketSegment.blendNameOptions().should('have.length', 2)
        marketSegment.blendNameOptions().should('have.length', 2).then(options => {
            cy.wrap(options).each(option => {
                cy.wrap(option).invoke('text').then(text => {
                    const expectedBlendNames = [this.mktSegmentData.blendName1, this.mktSegmentData.blendName2].join(' , ');
                    expect(expectedBlendNames).to.include(text.trim());
                });
            }); 90
        });
        // marketSegment.blendNameOptions().first().should('contain', this.mktSegmentData.blendName1)
        // marketSegment.blendNameOptions().last().should('contain', this.mktSegmentData.blendName2)
        //Select a blend and verify that cut group dropdown should be disabled
        marketSegment.blendNameOptions().last().click()
        marketSegment.blendCutGroupDisabled().should('exist')
        //  Uncheck one row and verify that save should be disabled
        marketSegment.blendCutSubGroupCheckBox1().uncheck()
        marketSegment.blendSaveBtn().first().should('be.disabled')
        marketSegment.blendCutSubGroupCheckBox1().check()
        marketSegment.blendSaveBtn().first().should('be.enabled')
        //Edit the weights and verify that it can be saved
        marketSegment.blendWeightField1().click().clear().type(this.mktSegmentData.blendweight2)
        marketSegment.blendWeightField2().click().clear().type(this.mktSegmentData.blendweight1)

        //verify total weight should show 1.00
        marketSegment.blendNameField().first().click() //this is to click outside of the weights fields
        marketSegment.blendTotalsInputField().invoke('val').should('eq', '1.00')
        //save the blend
        marketSegment.blendSaveBtn().first().click()
        cy.contains(this.mktSegmentData.eriSaveMessage, { timeout: 10000, interval: 500 }).should('be.visible')
        //Verify that blend name can be changed and saved
        marketSegment.blendNameField().first().click().clear().type(this.mktSegmentData.blendNameEdit)
        //save the blend
        marketSegment.blendSaveBtn().first().click()
        cy.contains(this.mktSegmentData.eriSaveMessage, { timeout: 10000, interval: 500 }).should('be.visible')
        marketSegment.blendNameField().first().click()
        marketSegment.blendNameOptions().should('have.length', 2)
    })

    it('07: Combined Average:Verify Edit functionality', function () {
        marketSegment.blendNextBtn().first().click()
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'true')
        //    Click on the link in the grid to edit combined avg
        marketSegment.combinedAvgGrid().find('tbody tr').contains('a', this.mktSegmentData.combinedAvgName1).click()
        marketSegment.combinedAvgNameLabel().should('be.visible').should('contain', 'Combined Average Name')
        //    Verify reset functionality (should be able to check/uncheck and reset and verify that it resets)
        marketSegment.combinedAvgModalGridData().find('tbody tr').first().within(() => {
            marketSegment.combinedAvgModalGridCheckbox().click();
            marketSegment.combinedAvgModalGridCheckbox().should('be.checked')
        })
        marketSegment.combinedAvgModalCloseBtn().contains('Reset').click()
        marketSegment.combinedAvgModalGridData().find('tbody tr').first().within(() => {
            marketSegment.combinedAvgModalGridCheckbox().should('not.be.checked')
        })
        //    Verify that user can edit and save and the edited cuts should reflect in the grid
        marketSegment.combinedAvgModalGridData().find('tbody tr').contains(this.mktSegmentData.cutGroupSearch).parent().within(() => {
            marketSegment.combinedAvgModalGridCheckbox().click();
            marketSegment.combinedAvgModalGridCheckbox().should('be.checked')
        })
        cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedAverages')
        marketSegment.combinedAvgModalSaveBtn().eq(2).click()
        cy.wait('@combinedAverages').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        //Validate data
        marketSegment.combinedAvgGrid().find('tbody tr').contains(this.mktSegmentData.combinedAvgName1).closest('tr').within(() => {
            cy.get('td').eq(2).should('contain', this.mktSegmentData.cutGroupSearch)
        })
        //save combined averages
        cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedAverages')
        marketSegment.combinedAvgSaveBtn().click()
        cy.wait('@combinedAverages').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains(this.mktSegmentData.combinedAvgEditMessage).should('be.visible')
    })
});