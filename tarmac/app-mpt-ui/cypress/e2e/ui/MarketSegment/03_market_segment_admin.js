/* eslint-disable-next-line no-unsafe-optional-chaining */
import MarketSegment, { SectionArray } from "../../../support/pageObjects/marketSegment/marketSegment";

let marketSegment;
const orgName = "Hospital of the University of Pennsylvania";
const eriCutName = "Cut name to be added on combined";

const visitMarketSegmentTab = (orgName, projectId = 3, projectVersion = 1) => {
  cy.visit("/#");

  cy.wait(2000).then(() => {
    marketSegment = new MarketSegment();
    marketSegment.getMarketSegmentTab().click();
  });

  cy.wait(1000).then(() => {
    marketSegment.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });

    // cy.wait(2000).then(() => {
    //   cy.get("select[data-cy=projectId]").selectNth(1);
    //   cy.get("select[data-cy=projectId]").trigger("change", { force: true });
    // });
    cy.wait(2000).then(() => {
      cy.get("select[data-cy=projectId]").selectNth(projectId);
      cy.get("select[data-cy=projectId]").trigger("change", {
        force: true,
      });
      cy.get("select[data-cy=projectVersion]").selectNth(projectVersion);
      cy.get("select[data-cy=projectVersion]").trigger("change", {
        force: true,
      });
    });
  });
};

before(() => {
  cy.fixture("marketSummaryTab").then(marketSegment => {
    visitMarketSegmentTab(marketSegment.topLevelFilters.orgName);
  });
});

describe("market segment spec", () => {
  it("01: check market segment tab exists", () => {
    cy.get("li[data-cy=marketSegment]").should("be.visible");
    cy.get("li[data-cy=marketSegment]").click();
  });

  it("02 - click on market segment tab without selecting an organization", () => {
    marketSegment.getMarketSegmentTab().click();
    cy.get('button[data-cy="clear"]').click({ force: true });
    marketSegment.getOrganizationInput().click({ force: true }).clear({ force: true });
    cy.get('[data-cy="filterSelectCy"]').should("have.class", "alert alert-primary").and("contain", "To visualize Market Segment, please select");
  });

  it("03 - click on market segment tab without selecting a project ID", () => {
    marketSegment.getMarketSegmentTab().click();

    cy.wait(500).then(() => {
      marketSegment.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
      cy.get('[data-cy="filterSelectCy"]').should("have.class", "alert alert-primary").and("contain", "To visualize Market Segment, please select");
    });
  });

  it("04 - click on market segment tab without selecting a project version", () => {
    marketSegment.getMarketSegmentTab().click();
    cy.wait(2000).then(() => {
      cy.get("select[data-cy=projectId]").selectNth(1);
      cy.get("select[data-cy=projectId]").trigger("change", { force: true });
    });

    marketSegment.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
    cy.get('[data-cy="filterSelectCy"]').should("have.class", "alert alert-primary").and("contain", "To visualize Market Segment, please select");
  });

  it("05 - Add new market segment click should render sections", () => {
    visitMarketSegmentTab(orgName);

    const inputText = `Market-${Math.random(4).toFixed(5)}`;
    marketSegment.getAddMarketSegmentBtn().should("be.visible");
    marketSegment.getMarketSegmentInput().click({ force: true });
    cy.wait(2000).then(() => {
      marketSegment.getMarketSegmentInput().type(inputText, { force: true });

      cy.wait(2000).then(() => {
        marketSegment.getAddMarketSegmentBtn().click({ force: true });
        SectionArray.forEach(section => {
          marketSegment.getSection(section).should("be.visible");
        });
      });
    });
  });

  it("06: Filter by Sullivan cotter and move to select cut", () => {
    cy.get(".publisher-autocomplete").as("publisherAutoComplete");
    cy.get("@publisherAutoComplete").first().as("FirstFilter");

    cy.get("@FirstFilter").click();
    cy.wait(4000).then(() => {
      cy.get("[data-cy=publisher-filterMultipleSelect]").should("be.visible");
      cy.get("[data-cy=publisher-filterMultipleSelect]").get("#multiselect-autocomplete-list").first("li").click({ force: true });
      cy.wait(1000).then(() => {
        cy.get('button[data-cy="nextBtnMSFilters"]').click({ force: true });
        cy.wait(5000).then(() => {
          cy.get('button[data-cy="msSelectionCutSection-saveBtn"]').click({ force: true });
        });
      });
    });
  });

  it("07: check actions exists in selected cuts section", () => {
    cy.wait(2000).then(() => {
      cy.get("div[data-cy=selectedCutsSection]").as("selectCutsSection");
      cy.wait(1000).then(() => {
        cy.get("button[data-cy=msSelectionCutSection-previousBtn]").should("exist");
        cy.get("button[data-cy=msSelectionCutSection-nextBtn]").should("exist");
        cy.get("button[data-cy=msSelectionCutSection-saveBtn]").should("exist");
        cy.get("button[data-cy=msSelectionCutSection-saveNextBtn]").should("exist");
        cy.get("button[data-cy=msSelectionCutSection-viewDetailsBtn]").should("exist");
      });
    });
  });

  it("08: check action buttons exists in ERI section", () => {
    cy.wait(1000).then(() => {
      cy.get("button[data-cy=accordionERIBtn]").click();
      cy.wait(1000).then(() => {
        cy.get("button[data-cy=msEriSection-previousBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-nextBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-saveBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-saveNextBtn]").should("exist");
      });
    });
  });

  it("09: check action buttons exists in blend section", () => {
    cy.wait(1000).then(() => {
      cy.get("button[data-cy=accordionBlendBtn]").click();
      cy.wait(1000).then(() => {
        cy.get("button[data-cy=msBlendSection-previousBtn]").should("exist");
        cy.get("button[data-cy=msBlendSection-nextBtn]").should("exist");
        cy.get("button[data-cy=msBlendSection-saveBtn]").should("exist");
        cy.get("button[data-cy=msBlendSection-saveNextBtn]").should("exist");
        cy.get("button[data-cy=msBlendSection-viewDetailBtn]").should("exist");
      });
    });
  });

  it("10: Fill ERI", () => {
    cy.wait(1000).then(() => {
      cy.get("button[data-cy=accordionERIBtn]").click({ force: true });
      cy.wait(1000).then(() => {
        cy.get("table[data-cy=tableERISection]").should("be.visible");
        cy.get('input[data-cy="eriAdjustmentFactorInput"]').should("be.visible").type("2.00");
        cy.get('input[data-cy="eriCutNameInput"]').should("be.visible").type(eriCutName);
        cy.get('input[data-cy="eriCityInput"]').should("be.visible").type("city Name");
        cy.get('button[data-cy="msEriSection-saveBtn"]').click();
      });
    });
  });

  it("11: Add ERI Cut to combined average and move to ERI Section", () => {
    cy.wait(1200).then(() => {
      cy.get('button[data-cy="accordionCombinedAveragedBtn"]').click();
      cy.wait(1000).then(() => {
        cy.get('button[data-cy="addCombinedAverageBtn"]').click();
        cy.wait(1000).then(() => {
          cy.get("input[data-cy='combinedAverageNameInput']").as("inputCombined");
          cy.get("div[data-cy='combined-average-modal-grid']").as("ModalGridCombined");

          cy.get("h5[data-cy='modalTitle']").should("exist");
          cy.get("label[data-cy='combinedAverageNameLabel']").should("exist");
          cy.get("@inputCombined").should("exist");
          cy.get("@inputCombined").type("This is a combined average");
          cy.get("@ModalGridCombined").should("exist");
          cy.wait(1000).then(() => {
            cy.get('input[data-cy="inputCheckboxAcademic"]').should("be.visible").check();
            cy.get(`input[data-cy="inputCheckbox${eriCutName}"]`).last().check({ force: true });
            cy.wait(1000).then(() => {
              cy.get('button[data-cy="saveBtnCombinedModal"]').click({ force: true });
              cy.wait(2500).then(() => {
                cy.get("button[data-cy=accordionERIBtn]").click({ force: true });
                cy.get('input[data-cy="eriCutNameInput"]').should("be.visible");
                cy.get('input[data-cy="eriCutNameInput"]').should("be.disabled");
                cy.get('input[data-cy="eriCityInput"]').should("not.be.disabled");
                cy.get('span[data-cy="combinedAverageWarningSpan"]')
                  .should("be.visible")
                  .and(
                    "contain",
                    "The ERI Name participates in a combined average. Please delete the combined average first, before removing or changing the ERI Name.",
                  );
              });
            });
          });
        });
      });
    });
  });

  it("12: Blend section should exist fully - check ", () => {
    cy.get("button[data-cy=accordionBlendBtn]").click({ force: true });
    cy.wait(1200).then(() => {
      cy.get('label[data-cy="blendNameLabel"]').as("blendLabel");
      cy.get('input[data-cy="typeaheadInputCy"]').as("blendInput");

      cy.get('button[data-cy="addBlendBtn"]').should("be.visible");
      cy.get('label[data-cy="cutGroupLabel"]').should("be.visible");
      cy.get('select[data-cy="selectCutGroupCy"]').should("be.visible");
      cy.get('label[data-cy="totalsLabel"]').should("be.visible");
      cy.get('input[data-cy="totalsControlCy"]').should("be.visible");

      cy.get('th[data-cy="checkedBlendCollumn"]').should("be.visible");
      cy.get('th[data-cy="industrySectorNameBlendCollumn"] ').should("be.visible");
      cy.get('th[data-cy="organizationTypeNameBlendCollumn"]').should("be.visible");
      cy.get('th[data-cy="cutGroupNameBlendCollumn"]').should("be.visible");
      cy.get('th[data-cy="cutSubGroupNameBlendCollumn"]').should("be.visible");
      cy.get('th[data-cy="weightBlendCollumn"]').should("be.visible");
      cy.get('td[data-cy="emptyBlendTableCy"]').should("be.visible").and("contain", "No blends added");
      cy.get("@blendLabel").should("be.visible");
      cy.get("@blendInput").should("be.visible");
    });
  });

  const blendName = `Custom Blend - ${Math.floor(Math.random() * 100) + 1}`;
  it("13: Add Blend", () => {
    cy.wait(1200).then(() => {
      cy.get(".typeahead").type(blendName);

      cy.get("[data-cy=addBlendBtn]").click();

      cy.get("[data-cy=blendDataCheckbox]").eq(0).check();
      cy.get("[data-cy=blendDataCheckbox]").eq(1).check();

      cy.get("[data-cy=blendWeightInput]").eq(0).as("blendWeightInputOne");
      cy.get("[data-cy=blendWeightInput]").eq(1).as("blendWeightInputTwo");

      cy.get("@blendWeightInputOne").clear();
      cy.get("@blendWeightInputOne").type("0.5");
      cy.get("@blendWeightInputTwo").clear();
      cy.get("@blendWeightInputTwo").type("0.5");

      cy.get("button[data-cy=msBlendSection-saveBtn]").click();
    });
  });

  it("14: Select Cuts - Blend cut should open SurveyLevelDetails Modal", () => {
    cy.get("[data-cy=accordionSelectedCutsBtn]").as("selectCutsSection");
    cy.get("@selectCutsSection").click({ force: true });
    cy.wait(1200).then(() => {
      cy.get("[data-cy='BlendCutGroupLink']").eq(1).as("BlendCutGroup");
      cy.get("@BlendCutGroup").scrollIntoView();
      cy.get("@BlendCutGroup").click({ force: true });
      cy.wait(1200).then(() => {
        cy.get("button[data-cy=closeBtn]").click();
      });
    });
  });

  it("15: Select Cuts - Blend cut should navigate to blend section", () => {
    cy.get("[data-cy=accordionSelectedCutsBtn]").as("selectCutsSection");
    cy.get("@selectCutsSection").click();
    cy.get(`[data-cy='BlendPricingInputCell-${blendName}']`).as("BlendNamePricingCut");
    cy.get("@BlendNamePricingCut").scrollIntoView();
    cy.get("@BlendNamePricingCut").should("contain", blendName);
    cy.get("@BlendNamePricingCut").click();
  });
});
