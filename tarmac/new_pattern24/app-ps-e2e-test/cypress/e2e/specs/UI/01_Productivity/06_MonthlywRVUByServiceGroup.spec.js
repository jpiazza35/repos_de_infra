/// <reference types="Cypress" />
import monthlywRVUServiceGroup from '../../../../pageObjects/01_Productivity/MonthlywRVUServiceGroup';

describe("Productivity - Monthly wRVU By Service Group", { testIsolation: false }, function () {
    let monthlywRVUServiceGroupData;
    before(function () {
        let username;
        let password;
        let url;
        const enableRealData = Cypress.env("enableRealData");
        const reportingPeriod = Cypress.env("reportingPeriod");
        cy.getUserDetails(enableRealData, reportingPeriod).then(userDetails => {
            username = userDetails.username;
            password = userDetails.password;
            url = userDetails.url;
            cy.logintoPS2(username, password, url)
            cy.visit(url)
        });       
    });

    beforeEach(function () {
        cy.fixture('UI/01_Productivity/monthly_wRVU_service_group_data').then((data) => {
            monthlywRVUServiceGroupData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //common test for real and mock data users
   
        it('06: verify Monthly wRVU By Service Group', function () {
            monthlywRVUServiceGroup.monthlywRVUServiceGroupTitle().scrollIntoView().should('contain', monthlywRVUServiceGroupData.cardTitle)
            monthlywRVUServiceGroup.chargePostDateSubTitle().should('contain', monthlywRVUServiceGroupData.cardSubTitle)

            monthlywRVUServiceGroup.serviceGroups().eq(1).should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[0])
            monthlywRVUServiceGroup.serviceGroups().eq(1).click()
            monthlywRVUServiceGroup.hospital().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[1])
            monthlywRVUServiceGroup.imaging().eq(0).should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[2])
            monthlywRVUServiceGroup.officeEstablished().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[3])
            monthlywRVUServiceGroup.officeNew().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[4])
            monthlywRVUServiceGroup.other().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[5])
            monthlywRVUServiceGroup.preventative().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[6])
            monthlywRVUServiceGroup.SNF().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[7])
            monthlywRVUServiceGroup.surgical().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[8])
            monthlywRVUServiceGroup.serviceGroups().eq(1).click()

            monthlywRVUServiceGroup.legendHospital().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[1])
            monthlywRVUServiceGroup.legendImaging().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[2])
            monthlywRVUServiceGroup.legendOfficeEstablished().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[3])
            monthlywRVUServiceGroup.legendOfficeNew().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[4])
            monthlywRVUServiceGroup.legendOther().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[5])
            monthlywRVUServiceGroup.legendPreventative().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[6])
            monthlywRVUServiceGroup.legendSNF().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[7])
            monthlywRVUServiceGroup.legendSurgical().should('contain', monthlywRVUServiceGroupData.mockData.serviceGroups[8])

            monthlywRVUServiceGroup.kebabMenu().eq(3).click()
            monthlywRVUServiceGroup.exportDataPDF().eq(0).should('contain', monthlywRVUServiceGroupData.exportDataPDF)
        })
    })