/// <reference types="Cypress" />
import patientDetailwRVUHeatMap from '../../../../pageObjects/01_Productivity/PatientDetailwRVUHeatMap';

describe("Productivity - Patient Detail wRVU HeatMap", { testIsolation: false }, function () {
    let patientDetailwRVUHeatMapData;
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
        cy.fixture('UI/01_Productivity/patient_detail_wRVU_heat_map_data').then((data) => {
            patientDetailwRVUHeatMapData = data
        })
    });

    // after(function () {
    //     cy.logoutPS2()
    // });

    //common tests for mock and real data users
            it('07: verify Patient Detail wRVU Heat Map', function () {
            patientDetailwRVUHeatMap.patientDetailwRVUHeatMapTitle().should('contain', patientDetailwRVUHeatMapData.cardTitle)
            patientDetailwRVUHeatMap.heatMapSubTitle().eq(1).should('contain', patientDetailwRVUHeatMapData.cardSubTitle)
            patientDetailwRVUHeatMap.RVUServiceDateDropDown().should('contain', patientDetailwRVUHeatMapData.RVUServiceDate)
            patientDetailwRVUHeatMap.RVUServiceDateDropDown().click()
            patientDetailwRVUHeatMap.patientDetailOption1().should('contain', patientDetailwRVUHeatMapData.RVUsByServiceDate)
            patientDetailwRVUHeatMap.patientDetailOption2().should('contain', patientDetailwRVUHeatMapData.RVUsByChargePostDate)
            patientDetailwRVUHeatMap.patientDetailOption3().should('contain', patientDetailwRVUHeatMapData.averageChargeLag)
            patientDetailwRVUHeatMap.patientDetailOption4().should('contain', patientDetailwRVUHeatMapData.excessiveChargeLag)
            patientDetailwRVUHeatMap.patientDetailOption5().should('contain', patientDetailwRVUHeatMapData.serviceUnits)
            patientDetailwRVUHeatMap.addFilter().should('contain', patientDetailwRVUHeatMapData.addFilter)
            patientDetailwRVUHeatMap.addFilter().click()
            patientDetailwRVUHeatMap.calenderFilterTitle().should('contain', patientDetailwRVUHeatMapData.calenderFilterTitle)
            patientDetailwRVUHeatMap.addFilterOption1().eq(0).should('contain', patientDetailwRVUHeatMapData.serviceGroup)
            patientDetailwRVUHeatMap.addFilterOption2().eq(1).should('contain', patientDetailwRVUHeatMapData.billingOrganization)
            patientDetailwRVUHeatMap.addFilterOption3().eq(2).should('contain', patientDetailwRVUHeatMapData.billingCode)
            patientDetailwRVUHeatMap.addFilterOption4().eq(3).should('contain', patientDetailwRVUHeatMapData.billingCodeDescription)
            patientDetailwRVUHeatMap.addFilterOption5().eq(4).should('contain', patientDetailwRVUHeatMapData.CPTCodes)
            // patientDetailwRVUHeatMap.todayLabel().eq(5).should('contain', patientDetailwRVUHeatMapData.todayLabel)
        });

        it.skip('07: verify Patient Detail wRVU Heat Map - Calender', function () {
            patientDetailwRVUHeatMap.monthMar().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthMar)
            patientDetailwRVUHeatMap.monthApr().eq(1).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthApr)
            patientDetailwRVUHeatMap.monthMay().eq(2).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthMay)
            patientDetailwRVUHeatMap.monthJune().eq(3).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthJune)
            patientDetailwRVUHeatMap.monthJuly().eq(4).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthJuly)
            patientDetailwRVUHeatMap.monthAug().eq(5).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthAug)
        });

        it.skip('07: verify Patient Detail Grid', function () {
            patientDetailwRVUHeatMap.calenderMonthyear().eq(1).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.monthYear)
            patientDetailwRVUHeatMap.calenderDay31().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.calenderDay31)
            patientDetailwRVUHeatMap.calenderDay31().eq(0).click()
            patientDetailwRVUHeatMap.serviceDateLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.patientDetailServiceDateLabel)
            patientDetailwRVUHeatMap.serviceDate().eq(1).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.patientDetailServiceDate)
            patientDetailwRVUHeatMap.chargePostDateLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargePostDateLabel)
            patientDetailwRVUHeatMap.chargePostDate().eq(1).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargePostDate)
            patientDetailwRVUHeatMap.chargeLagLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargeLagLabel)
            patientDetailwRVUHeatMap.chargeLagDays().eq(1).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargeLagDays)
            patientDetailwRVUHeatMap.wRVUsLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.wRVUsLabel)
            patientDetailwRVUHeatMap.wRVUsValue().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.wRVUsValue)
            patientDetailwRVUHeatMap.unitsLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.unitsLabel)
            patientDetailwRVUHeatMap.unitsValue().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.unitsValue)

            patientDetailwRVUHeatMap.patientLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.patientLabel)
            patientDetailwRVUHeatMap.billingOrganizationLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingOrganizationLabel)
            patientDetailwRVUHeatMap.serviceGroupLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.serviceGroupLabel)
            patientDetailwRVUHeatMap.billingCodeLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeLabel)
            patientDetailwRVUHeatMap.billingCodeDescriptionLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeDescriptionLabel)
            patientDetailwRVUHeatMap.CPTCodeLabel().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTCodeLabel)
            patientDetailwRVUHeatMap.CPTMode1Label().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMode1Label)
            patientDetailwRVUHeatMap.CPTMode2Label().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMode2Label)
            patientDetailwRVUHeatMap.CPTMode3Label().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMode3Label)
            patientDetailwRVUHeatMap.CPTMode4Label().eq(0).should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMode4Label)
        });

        it.skip('07: verify Patient Detail Grid-Sort by Filter', function () {
            patientDetailwRVUHeatMap.sortByChargeLag().eq(0).click({ force: true }, { multiple: true })

            patientDetailwRVUHeatMap.chargeLagLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargeLagLowestHighest)
            patientDetailwRVUHeatMap.chargeLagHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargeLagHighestLowest)
            patientDetailwRVUHeatMap.chargePostDateEarliestLatest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargePostDateEarliestLatest)
            patientDetailwRVUHeatMap.chargePostDateLatestEarliest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.chargePostDateLatestEarliest)

            patientDetailwRVUHeatMap.patientNumberLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.patientNumberLowestHighest)
            patientDetailwRVUHeatMap.patientNumberHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.patientNumberHighestLowest)

            patientDetailwRVUHeatMap.CPTMod1fromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod1fromAZ)
            patientDetailwRVUHeatMap.CPTMod1fromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod1fromZA)
            patientDetailwRVUHeatMap.CPTMod2fromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod2fromAZ)
            patientDetailwRVUHeatMap.CPTMod2fromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod2fromZA)
            patientDetailwRVUHeatMap.CPTMod3fromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod3fromAZ)
            patientDetailwRVUHeatMap.CPTMod3fromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod3fromZA)
            patientDetailwRVUHeatMap.CPTMod4fromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod4fromAZ)
            patientDetailwRVUHeatMap.CPTMod4fromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTMod4fromZA)

            patientDetailwRVUHeatMap.billingCodeLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeLowestHighest)
            patientDetailwRVUHeatMap.billingCodeHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeHighestLowest)

            patientDetailwRVUHeatMap.billingCodeDescriptionfromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeDescriptionfromAZ)
            patientDetailwRVUHeatMap.billingCodeDescriptionfromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingCodeDescriptionfromZA)

            patientDetailwRVUHeatMap.serviceGroupfromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.serviceGroupfromAZ)
            patientDetailwRVUHeatMap.serviceGroupfromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.serviceGroupfromZA)

            patientDetailwRVUHeatMap.billingOrgfromAZ().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingOrgfromAZ)
            patientDetailwRVUHeatMap.billingOrgfromZA().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.billingOrgfromZA)

            patientDetailwRVUHeatMap.CPTCodefromLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTCodefromLowestHighest)
            patientDetailwRVUHeatMap.CPTCodefromHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.CPTCodefromHighestLowest)

            patientDetailwRVUHeatMap.wRVUsfromLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.wRVUsfromLowestHighest)
            patientDetailwRVUHeatMap.wRVUsfromHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.wRVUsfromHighestLowest)

            patientDetailwRVUHeatMap.unitsfromLowestHighest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.unitsfromLowestHighest)
            patientDetailwRVUHeatMap.unitsfromHighestLowest().should('contain', patientDetailwRVUHeatMapData.patientDetailwRVUHeatMapLabel.unitsfromHighestLowest)
        });
    
})