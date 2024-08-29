/// <reference types="Cypress" />
import homePage from '../../../../pageObjects/HomePage';
import projectPage from '../../../../pageObjects/Project/ProjectPage';
import marketSegment from '../../../../pageObjects/MarketSegment/MarketSegment';

describe("MPT - Add Market Segment", { testIsolation: false }, function () {

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

    it('06: verify Add Market Segment and that filters section should be shown after clicking Add button', function () {
        //select org, prj Id and prj version
        projectPage.orgField().type(this.projectData.smokeTestsOrgId)
        marketSegment.orgidFieldAutoCom().first().click()
        projectPage.projectField().contains(this.projectData.ProjectNameIncumbentData).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectField().select(optionValue);
        });
        //add market segment
        cy.intercept('get', '**/api/projects/*/status').as('status')
        cy.intercept('get', '**/api/projects/versions/*/market-segments').as('marketsegments')
        projectPage.projectVersionField().contains(this.projectData.ProjectVersionLabel).then(($option) => {
            const optionValue = $option.val()
            projectPage.projectVersionField().select(optionValue);
        });
        cy.wait('@status').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
            //if project status=Draft it should return 1 for status
            expect(xhr.response.body).to.equal(1);
        })
        cy.wait('@marketsegments').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.marketSegmentField().click().wait(1000).type(this.mktSegmentData.marketSegment).wait(1000)
        marketSegment.addBtn().click().wait(500)

        //only filters section should be expanded after clicking add button and other sections should be collapsed
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'false')
    });

    it('06: Filters Section - verify the labels and fields', function () {
        marketSegment.publisherLabel().should('be.visible').should('contain', 'Publisher')
        marketSegment.searchPublisherField().should('be.visible').should('be.enabled')
        marketSegment.selectedPublisherLabel().should('have.attr', 'placeholder', 'Select Publisher')

        marketSegment.yearLabel().should('be.visible').should('contain', 'Year')
        marketSegment.searchYearField().should('be.visible').should('be.enabled')
        marketSegment.selectedYearLabel().should('have.attr', 'placeholder', 'Select Year')

        marketSegment.surveyLabel().should('be.visible').should('contain', 'Survey')
        marketSegment.searchSurveyField().should('be.visible').should('be.enabled')
        marketSegment.selectedSurveyLabel().should('have.attr', 'placeholder', 'Select Survey')

        marketSegment.industrySectorLabel().should('be.visible').should('contain', 'Industry/Sector')
        marketSegment.searchIndustrySectorField().should('be.visible').should('be.enabled')
        marketSegment.selectedIndustrySectorLabel().should('have.attr', 'placeholder', 'Select Industry/Sector')

        marketSegment.orgTypeLabel().should('be.visible').should('contain', 'Org Type')
        marketSegment.searchOrgTypeField().should('be.visible').should('be.enabled')
        marketSegment.selectedOrgTypeLabel().should('have.attr', 'placeholder', 'Select Org Type')

        marketSegment.cutGroupLabel().should('be.visible').should('contain', 'Cut Group')
        marketSegment.searchCutGroupField().should('be.visible').should('be.enabled')
        marketSegment.selectedCutGroupLabel().should('have.attr', 'placeholder', 'Select Cut Group')

        marketSegment.cutSubGroupLabel().should('be.visible').should('contain', 'Cut Sub Group')
        marketSegment.searchCutSubGroupField().should('be.visible').should('be.enabled')
        marketSegment.selectedCutSubGroupLabel().should('have.attr', 'placeholder', 'Select Cut Sub Group')
    });

    it('06: Filters Section - verify that Year filter shows only the current year and the preceeding 2 years', function () {
        marketSegment.searchYearField().click()
        const cYear = new Date().getFullYear()
        const pYears = [cYear - 1, cYear - 2]
        pYears.concat(cYear).forEach((year) => {
            marketSegment.listOptions().eq(1).should('contain', year)
            marketSegment.listOptions().eq(1).within(() => {
                cy.get('li').then(($ele) => {
                    expect($ele.length).to.equal(3)
                });
            });
        });
    });

    it('06: Filters Section - verify that there are only relevant list options when we search any filter with a search term', function () {
        marketSegment.searchPublisherField().type(this.mktSegmentData.publisherPartialSearch).wait(2000)
        marketSegment.listOptions().eq(0).within(() => {
            cy.get('li').each(($option) => {
                expect($option).to.contain(this.mktSegmentData.publisherPartialSearch);
            });
        });
    });

    it('06: Filters Section - verify that the Cut Group and the Cut Sub-Group are cascading, but if no Cut Group is selected, then all Cut Sub-Groups should be available', function () {
        marketSegment.searchCutSubGroupField().click()
        marketSegment.listOptions().eq(6).within(() => {
            cy.get('li').should('have.length.greaterThan', 1);
        });
        marketSegment.searchCutGroupField().type(this.mktSegmentData.cutGroupSearch).wait(2000)
        marketSegment.listOptions().eq(5).within(() => {
            cy.get('li').click().wait(2000);
        });
        marketSegment.searchCutSubGroupField().click()
        marketSegment.listOptions().eq(6).within(() => {
            cy.get('li').should('have.length', 1);
        });
        marketSegment.clearOptions().click().wait(1000)
    });

    it('06: Filters Section - verify Next and View Details Buttons', function () {
        marketSegment.filtersSectionNextBtn().should('be.visible').should('be.disabled')
        marketSegment.searchPublisherField().type(this.mktSegmentData.publisherSearch).wait(2000)
        marketSegment.listOptions().eq(0).within(() => {
            cy.get('li').click();
        });
        marketSegment.searchCutGroupField().click();
        cy.wrap(this.mktSegmentData.cutGroupAdd).each((option) => {
            marketSegment.listOptions().eq(5).within(() => {
                cy.get('li').contains(option).click();
            })
        })
        marketSegment.filtersSectionNextBtn().should('be.visible').should('be.enabled')
        cy.intercept('post', '**/api/survey/market-segment-survey-details').as('surveydetails')
        marketSegment.viewDetailsBtn().eq(0).click()
        cy.wait('@surveydetails').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
    });

    it('06: Survey Level Details Popup - verify the Grid title, columns and data table', function () {
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.gridHeader().first().within(() => {
            cy.contains('Survey Publisher').should('be.visible')
            cy.contains('Survey Year').should('be.visible')
            cy.contains('Survey Name').should('be.visible')
            cy.contains('Industry/Sector').should('be.visible')
            cy.contains('Org Type').should('be.visible')
            cy.contains('Cut Group').should('be.visible')
            cy.contains('Cut Sub-Group').should('be.visible')
            cy.contains('Cut').should('be.visible')
        });
        marketSegment.gridData().first().should('exist')
        //close the grid and navigate to selected cuts section
        marketSegment.gridCloseBtn().click().wait(1000)
        cy.intercept('post', '**/api/survey/market-segment-cuts').as('segmentcuts')
        marketSegment.filtersSectionNextBtn().click()
        cy.wait('@segmentcuts').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
    });

    it('06: Selected Cuts Section - verify whether filters section is collapsed and the Status & Grid column names of Selected Cuts Section', function () {
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'false')
        //verify project status shown in selected cuts section
        marketSegment.statusField().last().invoke('val').should('eq', 'Draft');
        //verify grid column names
        marketSegment.gridHeader().first().within(() => {
            cy.contains('Action').should('be.visible')
            cy.contains('Industry/Sector').should('be.visible')
            cy.contains('Org Type').should('be.visible')
            cy.contains('Cut Group').should('be.visible')
            cy.contains('Cut Sub-Group').should('be.visible')
            cy.contains('Market Pricing Cut').should('be.visible')
            cy.contains('Display on Report').should('be.visible')
            cy.contains('Report Order').should('be.visible')
        });
    });

    it('06: Selected Cuts Section - verify the grid body, icons and fields in the body', function () {
        marketSegment.gridData().first().should('exist')
        marketSegment.trashIcon().eq(0).should('be.visible').wait(2000)
        marketSegment.hamburgerIcon().eq(0).should('be.visible')
        marketSegment.toTopIcon().eq(0).should('be.visible')
        marketSegment.oneUpIcon().eq(0).should('be.visible')
        marketSegment.oneDownIcon().eq(0).should('be.visible')
        marketSegment.toBottomIcon().eq(0).should('be.visible')
        marketSegment.marketPCField().eq(0).should('be.visible')
    });

    it('06: Selected Cuts Section - verify the buttons and fields', function () {
        marketSegment.gridContentScroll().scrollTo('bottom').wait(1000)
        marketSegment.viewDetailsBtn().should('be.visible').should('be.enabled')
        marketSegment.previousBtn().should('be.visible').should('be.enabled')
        marketSegment.saveBtn().should('be.visible').should('be.enabled')
        marketSegment.selectedCutsSaveNextBtn().should('be.visible').should('be.enabled')
        marketSegment.selectedCutsNextBtn().should('be.visible').should('be.enabled')
    });

    it('06: Selected Cuts Section - Delete a row and verify whether its deleted or not', function () {
        let numRows;
        marketSegment.gridData().find('tbody tr').its('length').then(length => {
            numRows = length;
            marketSegment.trashIcon().eq(0).click().wait(1000);
            marketSegment.ConfirmYesNo().should('exist')
            marketSegment.ConfirmYes().click()
            marketSegment.gridData().find('tbody tr').should('have.length', (numRows - 1));
        });
    });

    it('06: Survely Level Details - Verify Save/Edit Details Functionality', function () {
        marketSegment.marketPCField().eq(0).type(this.mktSegmentData.marketPricingCut)
        cy.intercept('post', '**/api/projects/market-segments').as('marketsegment')
        marketSegment.saveBtn().click();
        cy.wait('@marketsegment').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.editDetailsBtn().click().wait(2000)
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.checkMarkBtnEditDetails().eq(0).uncheck().wait(2000)
        marketSegment.gridCloseBtn().click().wait(1000)
        marketSegment.gridCloseBtn().click().wait(1000)
        marketSegment.ConfirmNo().click().wait(1000)
        cy.intercept('put', '**/api/projects/market-segments/*/cut-details').as('cutdetails')
        marketSegment.gridSaveBtn().eq(0).click()
        cy.wait('@cutdetails').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains('Survey level details saved successfully.')
        marketSegment.gridCloseBtn().click().wait(1000)
    });

    it('06: Selected Cuts Section - Verify Subcut group link and save', function () {
        marketSegment.cutSubGroupLink().contains(this.mktSegmentData.cutSubGroup).first().click({ force: true })
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.checkMarkBtnEditDetails().eq(0).uncheck().wait(2000)
        marketSegment.gridCloseBtn().click().wait(1000)
        marketSegment.ConfirmNo().click().wait(1000)
        cy.intercept('put', '**/api/projects/market-segments/*/cut-details').as('cutdetails')
        marketSegment.gridSaveBtn().eq(0).click();
        cy.wait('@cutdetails', { timeout: 30000, interval: 1000 }).then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        cy.contains('Survey level details saved successfully.')
        marketSegment.gridCloseBtn().click().wait(1000)
    });


    Cypress.Commands.add("selectedCutsGridActions", (clickIndex, intialRow, updatedRow) => {
        let initialReportOrder;
        let updatedReportOrder;

        cy.get(`tbody tr:nth-child(${intialRow}) td:nth-child(8)`).first().invoke('text').then(text => {
            initialReportOrder = text;
            if (clickIndex === 1) {
                marketSegment.oneUpIcon().eq(1).click({ force: true }).wait(1000);
            } else if (clickIndex === 0) {
                marketSegment.oneDownIcon().eq(0).click().wait(1000);
            } else if (clickIndex === 2) {
                marketSegment.toBottomIcon().eq(0).click().wait(1000);
            } else if (clickIndex === 3) {
                marketSegment.toTopIcon().eq(4).click().wait(1000);
            }
            else if (clickIndex === 4) {
                const sourceSelector = marketSegment.hamburgerIcon().eq(0)
                const targetSelector = marketSegment.hamburgerIcon().eq(1)
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

    it('06: Selected Cuts Section - Verify selected cuts grid actions functionality', function () {
        //one up arrow
        cy.selectedCutsGridActions(1, 2, 1);
        // OneDown arrow
        cy.selectedCutsGridActions(0, 1, 2);
        // ToBottom arrow
        cy.selectedCutsGridActions(2, 1, 25); // with current data. If data changes, the row number needs to be updated.
        // ToTop arrow
        cy.selectedCutsGridActions(3, 5, 1);
        //drag and drop 
        cy.selectedCutsGridActions(4, 1, 2);
    });

    it('06: ERI Section - Navigate to ERI section and verify that ERI section is expanded', function () {
        //navigate to ERI section
        marketSegment.selectedCutsNextBtn().click()

        //verify ERI section is expanded
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'true')
    });

    it('06: ERI Section - Verify grid headers and buttons', function () {
        //verify ERI section grid headers
        marketSegment.ERIGrid().first().within(() => {
            cy.contains('ERI Adj Factor').should('be.visible')
            cy.contains('ERI Cut Name').should('be.visible')
            cy.contains('ERI Cut City').should('be.visible')
        });
        //verify ERI section buttons        
        marketSegment.ERISectionPreviousBtn().should('be.visible').should('be.enabled').should('have.text', 'Previous')
        marketSegment.ERISectionSaveBtn().should('be.visible').should('be.disabled').should('have.text', 'Save')
        marketSegment.ERISectionSaveNextBtn().should('be.visible').should('be.disabled').should('have.text', 'Save & Next')
        marketSegment.ERISectionNextBtn().should('be.visible').should('be.enabled').should('have.text', 'Next')

        //verify previous button navigates to selected cuts section
        marketSegment.ERISectionPreviousBtn().click()
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'false')

        //navigate back to ERI section
        marketSegment.selectedCutsNextBtn().click()
    });

    it('06: ERI Section - Verify that ERI cut name is mandatory when ERI adj factor is given', function () {
        //verify that ERI adj factor value can be entered
        marketSegment.ERIAdjFactor().click().clear().type(this.mktSegmentData.EriAdjFactor)

        //verify that any value above 1.00 will be changed to 1.00 for ERI Adj Factor
        marketSegment.ERIAdjFactor().click().clear().type('2')
        marketSegment.ERICutCity().click()
        //  marketSegment.ERIAdjFactor().click()
        marketSegment.ERIAdjFactor().invoke('val').should('eq', '1.00')
        //changing back the value to ERI Adj factor
        marketSegment.ERIAdjFactor().click().clear().type(this.mktSegmentData.EriAdjFactor)

        //verify that ERI cut name is mandatory when ERI adj factor is given
        marketSegment.ERISectionSaveBtn().should('be.visible').should('be.disabled')
        marketSegment.ERISectionSaveNextBtn().should('be.visible').should('be.disabled')
        marketSegment.ERICutName().click().clear().type(this.mktSegmentData.EriCutName)
    });

    it('06: ERI Section - Verify that ERI cut city is optional and save ERI', function () {
        //verify that ERI cut city is optional
        marketSegment.ERICutCity().click()
        marketSegment.ERISectionSaveBtn().should('be.visible').should('be.enabled')
        marketSegment.ERISectionSaveNextBtn().should('be.visible').should('be.enabled')

        //save ERI and move to next section

        cy.intercept('post', '**/api/projects/**/eri').as('eri')
        marketSegment.ERISectionSaveBtn().first().click()
        //wait for eri to save
        cy.wait('@eri').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        marketSegment.ERISectionSaveNextBtn().first().click()

    });

    it('06: Blend Section - Verify only Blend section is expanded', function () {
        marketSegment.BlendSection().click()//.wait(1000) //no api called, only UI wait
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'false')
    });

    it('06: Blend Section - Verify grid headers and buttons', function () {
        marketSegment.blendGrid().within(() => {
            cy.contains('Select').should('be.visible')
            cy.contains('Industry/Sector').should('be.visible')
            cy.contains('Org Type').should('be.visible')
            cy.contains('Cut Group').should('be.visible')
            cy.contains('Cut Sub-Group').should('be.visible')
            cy.contains('Weight').should('be.visible')
        });

        //verify blend section buttons        
        marketSegment.addBlendBtn().should('be.visible').should('be.enabled').should('have.text', 'Add Blend')
        marketSegment.blendPreviousBtn().should('be.visible').should('be.enabled').should('have.text', 'Previous')
        marketSegment.blendNextBtn().should('be.visible').should('be.enabled').should('have.text', 'Next')
        marketSegment.blendSaveBtn().should('be.visible').should('be.disabled').should('have.text', 'Save')
        marketSegment.blendSaveNextBtn().should('be.visible').should('be.disabled').should('have.text', 'Save & Next')
        marketSegment.blendViewDetailsBtn().should('be.visible').should('be.enabled').should('have.text', 'View Details')
    });

    it('06: Blend Section - Verify Fields', function () {
        //verify blend section fields
        marketSegment.blendNameLabel().should('be.visible').should('contain', 'Blend Name')
        marketSegment.blendNameField().should('be.visible').should('be.enabled')
        marketSegment.blendCutGroupLabel().should('be.visible').should('contain', 'Select Cut Group')
        marketSegment.blendCutGroupDropdown().should('be.visible').should('be.enabled')
        marketSegment.blendTotalsLabel().should('be.visible').should('contain', 'Totals')
        //totals weight field should be disabled by default and should show 0.00 when no blends are added
        marketSegment.blendTotalsInputField().should('be.visible').should('be.disabled')
        marketSegment.blendTotalsInputField().invoke('val').should('eq', '0.00')
        //verify no blends message 
        marketSegment.blendsMsg().should('be.visible').should('contain', 'No blends added')
    });

    Cypress.Commands.add("addBlend", (blendName, blendCutGroup, weight1, weight2) => {

        marketSegment.blendNameField().first().click().clear().type(blendName)
        marketSegment.addBlendBtn().click()

        // loop through each option in the dropdown and select a cut group
        marketSegment.blendCutGroupOptions().each(($option) => {
            const optionText = $option.text();
            // Check if the option text matches the desired value
            if (optionText.includes(blendCutGroup)) {
                marketSegment.blendCutGroupDropdown().select(blendCutGroup);
                // exit loop once the option is selected
                return false;
            }
        })

        //select any two cut sub group and give the weights
        marketSegment.blendCutSubGroupCheckBox1().click()
        marketSegment.blendCutSubGroupCheckBox2().click()
        marketSegment.blendWeightField1().click().type(weight1)
        marketSegment.blendWeightField2().click().type(weight2)

        //verify total weight should show 1.00
        marketSegment.blendNameField().first().click() //this is to click outside of the weights fields
        marketSegment.blendTotalsInputField().invoke('val').should('eq', '1.00')
        //save the blend
        cy.intercept('post', '**/api/projects/**/blends').as('blends')
        marketSegment.blendSaveBtn().first().click()
        cy.wait('@blends').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })

    });

    it('06: Blend Section - Add Blends', function () {
        //add blends
        cy.addBlend(this.mktSegmentData.blendName1, this.mktSegmentData.blendCutGroup1, '0.5', '0.5')
        cy.addBlend(this.mktSegmentData.blendName2, this.mktSegmentData.blendCutGroup2, '0.2', '0.8')
    });

    it('06: Blend Section - Verify added blends are shown in selected cuts section', function () {
        //navigate to selected cuts section
        marketSegment.selectedCutsSection().click()
        //loop through grid data and find the row with blend and verify it is shown as link
        //link validations are not added as there are bugs and will be fixed with US -80684
        marketSegment.gridData().find('tbody tr').each(($row, index, $list) => {
            cy.wrap($row).within(() => {
                cy.get('td').eq(6).invoke('text').then((text) => {
                    if (text.includes(this.mktSegmentData.blendName1)) {
                        cy.get('td').eq(6).should('contain', this.mktSegmentData.blendName1).should('have.attr', 'href')
                    }
                    else if (text.includes(this.mktSegmentData.blendName2)) {
                        cy.get('td').eq(6).should('contain', this.mktSegmentData.blendName2).should('have.attr', 'href')
                    }
                    else {
                        cy.log('Blends not found in selected cuts section')
                    }
                })
            })
        })

    });

    it('06: Blend Section - Verify View Details/Survey Level Details', function () {
        marketSegment.BlendSection().click()
        marketSegment.blendViewDetailsBtn().click()
        marketSegment.sldWindow().should('exist')
        marketSegment.sldTitle().contains('Survey Level Details')
        marketSegment.gridHeader().eq(1).within(() => {
            cy.contains('Survey Publisher').should('be.visible')
            cy.contains('Survey Year').should('be.visible')
            cy.contains('Survey Name').should('be.visible')
            cy.contains('Industry/Sector').should('be.visible')
            cy.contains('Org Type').should('be.visible')
            cy.contains('Cut Group').should('be.visible')
            cy.contains('Cut Sub-Group').should('be.visible')
            cy.contains('Cut').should('be.visible')
        });
        // marketSegment.gridData().first().should('exist') //bug and no data is shown
        //close the grid 
        marketSegment.gridCloseBtn().click()
    });

    it('06: Blend Section - Verify Previous and Next button navigations', function () {
        //verify that previous button navigates to selected cuts section
        marketSegment.blendPreviousBtn().first().click()
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'false')

        //navigate to blends section and click on Next btn
        marketSegment.selectedCutsSection().click()
        marketSegment.BlendSection().click().wait(1000) //no api call, only UI wait
        marketSegment.blendNextBtn().first().click()
    });

    it('06: Combined Avg Section - Verify only Combined Avg section is expanded', function () {
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.filtersSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.ERISection().should('have.attr', 'aria-expanded', 'false')
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'false')
    });

    it('06: Combined Avg Section - Verify grid headers and buttons', function () {
        marketSegment.combinedAvgGrid().within(() => {
            cy.contains('Action').should('be.visible')
            cy.contains('Combined Average Name').should('be.visible')
            cy.contains('Selected Cut Names').should('be.visible')
            cy.contains('Combined Average Report Order').should('be.visible')
        });
        //verify blend section buttons        
        marketSegment.addCombinedAvgBtn().should('be.visible').should('be.enabled').should('have.text', 'Add Combined Average')
        marketSegment.combinedAvgPreviousBtn().should('be.visible').should('be.enabled').should('have.text', 'Previous')
        marketSegment.combinedAvgNextBtn().should('be.visible').should('be.enabled').should('have.text', 'Next')
        marketSegment.combinedAvgSaveBtn().should('be.visible').should('be.disabled').should('have.text', 'Save')
        marketSegment.combinedAvgSaveNextBtn().should('be.visible').should('be.disabled').should('have.text', 'Save & Next')
    });

    it('06: Combined Avg Section - Add combined average and verify combined average modal functionality', function () {
        marketSegment.addCombinedAvgBtn().click()
        marketSegment.combinedAvgNameLabel().should('be.visible').should('contain', 'Combined Average Name')
        marketSegment.combinedAvgNameField().type(this.mktSegmentData.combinedAvgName1)
        //verify combined average modal grid
        marketSegment.combinedAvgModalGridHeader().within(() => {
            cy.contains('Select').should('be.visible')
            cy.contains('Cut Name').should('be.visible')
        })

        //verify that you need to select more than on cut name to create combined average
        //loop through grid data and select blends
        marketSegment.combinedAvgModalGridData().find('tbody tr').each((row) => {
            const rowText = Cypress.$(row).text();
            if (rowText.includes(this.mktSegmentData.blendName1)) {
                // find the checkbox within the row and click it
                cy.wrap(row).within(() => {
                    marketSegment.combinedAvgModalGridCheckbox().click();
                    // marketSegment.combinedAvgModalGridHeader().click();
                });
            }
        });
        //if only one cut name is selected save btn should be disabled
        marketSegment.combinedAvgModalSaveBtn().should('be.visible').should('be.disabled')
        //save button should be enabled if another cut is also selected. select the second blend
        marketSegment.combinedAvgModalGridData().find('tbody tr').each((row) => {
            const rowText = Cypress.$(row).text();
            if (rowText.includes(this.mktSegmentData.blendName2)) {
                // find the checkbox within the row and click it
                cy.wrap(row).within(() => {
                    marketSegment.combinedAvgModalGridCheckbox().click();
                    // marketSegment.combinedAvgModalGridHeader().click();
                });
            }
        });
        marketSegment.combinedAvgModalSaveBtn().should('be.visible').should('be.enabled')
        marketSegment.combinedAvgModalCloseBtn().should('be.visible').should('be.enabled')
        //save the combined avg
        cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedAverages')
        marketSegment.combinedAvgModalSaveBtn().eq(2).click()
        cy.wait('@combinedAverages').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
    });

    //custom command to add combined avg
    Cypress.Commands.add("addCombinedAvg", (combinedAvgName) => {
        marketSegment.addCombinedAvgBtn().click()
        marketSegment.combinedAvgNameField().type(combinedAvgName)
        marketSegment.combinedAvgModalChkBx1().click()
        marketSegment.combinedAvgModalChkBx2().click()
        cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedAverages')
        marketSegment.combinedAvgModalSaveBtn().eq(2).click()
        cy.wait('@combinedAverages').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
    });

    it('06: Combined Avg Section - Add combined averages to use in testing for other tabs', function () {
        cy.addCombinedAvg(this.mktSegmentData.combinedAvgName2)
        cy.addCombinedAvg(this.mktSegmentData.combinedAvgName3)
    });

    it('06: Combined Avg Section - Verify buttons functionality', function () {
        //save combined averages
        cy.intercept('get', '**/api/projects/**/combined-averages').as('combinedAverages')
        marketSegment.combinedAvgSaveBtn().click()
        cy.wait('@combinedAverages').then((xhr) => {
            expect(xhr.response.statusCode).to.equal(200)
        })
        //previous button should navigate to Blend section
        marketSegment.combinedAvgPreviousBtn().click()
        marketSegment.BlendSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'false')
        //navigate back to combined avg section
        marketSegment.blendNextBtn().first().click()
        //next button should navigate to combined avg section
        marketSegment.combinedAvgSection().should('have.attr', 'aria-expanded', 'true')
        marketSegment.combinedAvgNextBtn().click()
        marketSegment.selectedCutsSection().should('have.attr', 'aria-expanded', 'true')
        //navigate back to combined avg section
        marketSegment.selectedCutsSection().click()
        marketSegment.combinedAvgSection().click()
    });
});