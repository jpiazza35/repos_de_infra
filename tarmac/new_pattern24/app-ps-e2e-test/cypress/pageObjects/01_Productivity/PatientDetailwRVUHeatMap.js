/// <reference types="Cypress" />

class PatientDetailwRVUHeatMap {
    patientDetailwRVUHeatMapTitle() {
        return cy.get('[data-cy="patientDetailTitle"]')
    }
    heatMapSubTitle() {
        return cy.get('[data-cy="patientDetailCard"] div div div')
    }
    RVUServiceDateDropDown() {
        return cy.get('[data-cy="patientDetailDropdown"]')
    }
    patientDetailOption1() {
        return cy.get('[data-cy="patientDetailDropdown"]')
    }
    patientDetailOption2() {
        return cy.get('[data-cy="patientDetailOption-1"]')
    }
    patientDetailOption3() {
        return cy.get('[data-cy="patientDetailOption-2"]')
    }
    patientDetailOption4() {
        return cy.get('[data-cy="patientDetailOption-3"]')
    }
    patientDetailOption5() {
        return cy.get('[data-cy="patientDetailOption-4"]')
    }
    addFilter() {
        return cy.get('[data-cy="calendarFiltersAddButton"]')
    }
    calenderFilterTitle() {
        return cy.get('[data-cy="patientDetailCard"] div div div div div div h4')
    }
    addFilterOption1() {
        return cy.get('[data-cy="calendarFiltersList"]')
    }
    addFilterOption2() {
        return cy.get('[data-cy="calendarFiltersList"]')
    }
    addFilterOption3() {
        return cy.get('[data-cy="calendarFiltersList"]')
    }
    addFilterOption4() {
        return cy.get('[data-cy="calendarFiltersList"]')
    }
    addFilterOption5() {
        return cy.get('[data-cy="calendarFiltersList"]')
    }
    todayLabel() {
        return cy.get('[data-cy="patientDetailCard"] div div div div')
    }
    monthMar() {
        return cy.get('[data-cy="calendar"]')
    }
    monthApr() {
        return cy.get('[data-cy="calendar"]')
    }
    monthMay() {
        return cy.get('[data-cy="calendar"]')
    }
    monthJune() {
        return cy.get('[data-cy="calendar"]')
    }
    monthJuly() {
        return cy.get('[data-cy="calendar"]')
    }
    monthAug() {
        return cy.get('[data-cy="calendar"]')
    }
    lastSixMonthsLabel() {
        return cy.get('[data-cy="patientDetailCard"] div div div div div')
    }
    serviceDate() {
        return cy.get('[data-cy="patientDetailServiceDate"] span')
    }
    serviceDateLabel() {
        return cy.get('[data-cy="patientDetailServiceDate"]')
    }
    calenderMonthyear() {
        return cy.get('[data-cy="calendarMonthLabel"]')
    }
    calenderDay31() {
        return cy.get('[data-cy="calendarDay-31"]')
    }
    chargePostDateLabel() {
        return cy.get('[data-cy="patientDetailServicePost"]')
    }
    chargePostDate() {
        return cy.get('[data-cy="patientDetailServicePost"] span')
    }
    chargeLagLabel() {
        return cy.get('[data-cy="patientDetailChargeLag"]')
    }
    chargeLagDays() {
        return cy.get('[data-cy="patientDetailChargeLag"] span')
    }
    wRVUsLabel() {
        return cy.get('[data-cy="patientDetailwRVUs"]')
    }
    wRVUsValue() {
        return cy.get('[data-cy="patientDetailwRVUs"]')
    }
    unitsLabel() {
        return cy.get('[data-cy="patientDetailUnits"]')
    }
    unitsValue() {
        return cy.get('[data-cy="patientDetailUnits"]')
    }
    patientLabel() {
        return cy.get('[data-cy="patientDetailPatient"]')
    }
    billingOrganizationLabel() {
        return cy.get('[data-cy="patientDetailBillingOrg"]')
    }
    serviceGroupLabel() {
        return cy.get('[data-cy="patientDetailServiceGroup"]')
    }
    billingCodeLabel() {
        return cy.get('[data-cy="patientDetailBillingCode"]')
    }
    billingCodeDescriptionLabel() {
        return cy.get('[data-cy="patientDetailBillingCodeDesc"]')
    }
    CPTCodeLabel() {
        return cy.get('[data-cy="patientDetailCPTCode"]')
    }
    CPTMode1Label() {
        return cy.get('[data-cy="patientDetailCPTMod1"]')
    }
    CPTMode2Label() {
        return cy.get('[data-cy="patientDetailCPTMod2"]')
    }
    CPTMode3Label() {
        return cy.get('[data-cy="patientDetailCPTMod3"]')
    }
    CPTMode4Label() {
        return cy.get('[data-cy="patientDetailCPTMod4"]')
    }
    buttonToggle() {
        return cy.get('[data-cy="buttonToggleSection"]')
    }
    sortByChargeLag() {
        return cy.get('[data-cy="patientDetailsFilters"] svg')
        //return cy.get('[data-cy="patientDetails"] div button div')
       
    }
    chargeLagLowestHighest() {
        return cy.get('[data-cy="option-ChargeLag-lowest-highest"]')
    }
    chargeLagHighestLowest() {
        return cy.get('[data-cy="option-ChargeLag-highest-lowest"]')
    }
    chargePostDateEarliestLatest() {
        return cy.get('[data-cy="option-ChargePostDate-earliest-latest"]')
    }
    chargePostDateLatestEarliest() {
        return cy.get('[data-cy="option-ChargePostDate-latest-earliest"]')
    }
    patientNumberLowestHighest() {
        return cy.get('[data-cy="option-PatientNumber-lowest-highest"]')
    }
    patientNumberHighestLowest() {
        return cy.get('[data-cy="option-PatientNumber-highest-lowest"]')
    }
    CPTMod1fromAZ() {
        return cy.get('[data-cy="option-CPTMod1-A-Z"]')
    }
    CPTMod1fromZA() {
        return cy.get('[data-cy="option-CPTMod1-Z-A"]')
    }
    CPTMod2fromAZ() {
        return cy.get('[data-cy="option-CPTMod2-A-Z"]')
    }
    CPTMod2fromZA() {
        return cy.get('[data-cy="option-CPTMod2-Z-A"]')
    }
    CPTMod3fromAZ() {
        return cy.get('[data-cy="option-CPTMod3-A-Z"]')
    }
    CPTMod3fromZA() {
        return cy.get('[data-cy="option-CPTMod3-Z-A"]')
    }
    CPTMod4fromAZ() {
        return cy.get('[data-cy="option-CPTMod4-A-Z"]')
    }
    CPTMod4fromZA() {
        return cy.get('[data-cy="option-CPTMod4-Z-A"]')
    }
    billingCodeLowestHighest() {
        return cy.get('[data-cy="option-BillingCode-lowest-highest"]')
    }
    billingCodeHighestLowest() {
        return cy.get('[data-cy="option-BillingCode-highest-lowest"]')
    }
    billingCodeDescriptionfromAZ() {
        return cy.get('[data-cy="option-BillingCodeDescription-A-Z"]')
    }
    billingCodeDescriptionfromZA() {
        return cy.get('[data-cy="option-BillingCodeDescription-Z-A"]')
    }
    serviceGroupfromAZ() {
        return cy.get('[data-cy="option-ServiceGroup-A-Z"]')
    }
    serviceGroupfromZA() {
        return cy.get('[data-cy="option-ServiceGroup-Z-A"]')
    }
    billingOrgfromAZ() {
        return cy.get('[data-cy="option-BillingOrg-A-Z"]')
    }
    billingOrgfromZA() {
        return cy.get('[data-cy="option-BillingOrg-Z-A"]')
    }
    CPTCodefromLowestHighest() {
        return cy.get('[data-cy="option-CPTCode-lowest-highest"]')
    }
    CPTCodefromHighestLowest() {
        return cy.get('[data-cy="option-CPTCode-highest-lowest"]')
    }
    wRVUsfromLowestHighest() {
        return cy.get('[data-cy="option-wRVUs-lowest-highest"]')
    }
    wRVUsfromHighestLowest() {
        return cy.get('[data-cy="option-wRVUs-highest-lowest"]')
    }
    unitsfromLowestHighest() {
        return cy.get('[data-cy="option-Units-lowest-highest"]')
    }
    unitsfromHighestLowest() {
        return cy.get('[data-cy="option-Units-highest-lowest"]')
    }
}
const patientDetailwRVUHeatMap = new PatientDetailwRVUHeatMap();
export default patientDetailwRVUHeatMap;
