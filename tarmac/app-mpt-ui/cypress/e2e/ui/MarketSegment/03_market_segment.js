/* eslint-disable-next-line no-unsafe-optional-chaining */
import MarketSegment, { SectionArray } from "../../../support/pageObjects/marketSegment/marketSegment";

let marketSegment;
let selectCutsGridLength = 44;
const orgName = "Hospital of the University of Pennsylvania";
const eriCutName = "Cut name to be added on combined";
const invalidEriCutName = "<iframe src=javascript:alert(document.domain)>";

let inputText;
const addMarketSegment = () => {
  inputText = `Market-${Math.random(4).toFixed(5)}`;

  marketSegment.getAddMarketSegmentBtn().should("be.visible");
  marketSegment.getMarketSegmentInput().click({ force: true });
  cy.wait(2000).then(() => {
    marketSegment.getMarketSegmentInput().clear();
    marketSegment.getMarketSegmentInput().type(inputText, { force: true });

    cy.wait(2000).then(() => {
      marketSegment.getAddMarketSegmentBtn().click({ force: true });
    });
  });
};
const blendName = `Custom Blend - ${Math.floor(Math.random() * 100) + 1}`;

const escape = string => {
  const tagsToReplace = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
  };

  return string.replace(/[&<>]/g, tag => tagsToReplace[tag] || tag);
};

const visitMarketSegmentTab = (orgName, projectId = 3, projectVersion = 1) => {
  cy.visit("/#");

  cy.wait(2000).then(() => {
    marketSegment = new MarketSegment();
    marketSegment.getMarketSegmentTab().click();
  });

  cy.wait(1000).then(() => {
    marketSegment.getOrganizationInput().click({ force: true }).clear({ force: true }).type(orgName, { force: true });
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

const keys = [
  { key: "publisher", placeholder: "Select Publisher" },
  { key: "year", placeholder: "Select Year" },
  { key: "survey", placeholder: "Select Survey" },
  { key: "industrySector", placeholder: "Select Industry/Sector" },
  { key: "organizationType", placeholder: "Select Org Type" },
  { key: "cutGroup", placeholder: "Select Cut Group" },
  { key: "cutSubGroup", placeholder: "Select Cut Sub Group" },
];

before(() => {
  cy.fixture("marketSummaryTab").then(marketSegment => {
    visitMarketSegmentTab(marketSegment.topLevelFilters.orgName);
  });
});

describe("market segment spec", () => {
  it("01 - check market segment tab exists", () => {
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
    marketSegment.getAddMarketSegmentBtn().should("be.visible");

    addMarketSegment();

    cy.wait(3000).then(() => {
      SectionArray.forEach(section => {
        marketSegment.getSection(section).should("be.visible");
      });
    });
  });

  it("06 - Should have defined accordion Filters Btn", () => {
    cy.get("[data-cy=accordionFiltersBtn]").should("be.visible");
  });

  it("07 - Should have the 7 Multiselect labels ", () => {
    keys.forEach(key => {
      cy.get(`label[data-cy=multiselect-label-${key.key}`).as("labelMultiSelect");
      cy.get("@labelMultiSelect").should("be.visible");
    });
  });

  it("08 - Should have the 7 Multiselect ", () => {
    keys.forEach(key => {
      const { key: K, placeholder } = key;
      cy.get(`select[data-cy=${K}-multiselect-autocomplete`).as("multiSelectInput");
      cy.get("@multiSelectInput").should("exist");
      cy.get("@multiSelectInput").should("have.attr", "placeholder", placeholder);
    });
  });

  it("09 - Check buttons from market segment", () => {
    cy.get("[data-cy=export]").click();
    cy.get("[data-cy=export]").should("contain", "Exit Full Screen");
    cy.get("[data-cy=export]").click();
    cy.get("[data-cy=export]").should("contain", "Full Screen");
  });

  it("10 - Filter by Sullivan cotter and move to select cut", () => {
    cy.get(".publisher-autocomplete").as("publisherAutoComplete");
    cy.get("@publisherAutoComplete").first().as("FirstFilter");

    cy.get("@FirstFilter").click();
    cy.wait(2500).then(() => {
      cy.get("li.k-list-item span.k-list-item-text").contains("SullivanCotter").click();
      cy.get("[data-cy=publisher-filterMultipleSelect]").should("be.visible");
      cy.wait(1000).then(() => {
        cy.get('button[data-cy="nextBtnMSFilters"]').click({ force: true });
        cy.wait(3000).then(() => {
          cy.get(`[data-cy=marketPricingInputCell-4]`).as("pricingInput");
          cy.get("@pricingInput").should("be.visible");
          cy.get("@pricingInput").invoke("val").should("not.be.empty").and("contain", "National");

          cy.get("@pricingInput").clear({ force: true });
          cy.get("@pricingInput").type("mkt pricing cut");
          cy.get("@pricingInput").invoke("val").should("not.be.empty").and("contain", "mkt pricing cut");
          cy.get('button[data-cy="msSelectionCutSection-saveBtn"]').click({ force: true });
        });
      });
    });
  });

  it("11 - Check actions exists in selected cuts section", () => {
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

  it("12 - Should test drag and drop functionality in Select Cuts section", () => {
    const draggableElement = 'div[data-cy="selectCutsGrid"] tbody tr:eq(4)';

    const dropZone = 'div[data-cy="selectCutsGrid"] tbody tr:eq(7)';

    cy.get(draggableElement).should("be.visible").and("contain", "5").trigger("mousedown", { which: 1 });
    cy.get(dropZone).trigger("mousemove");

    cy.get(dropZone).trigger("mouseup", { force: true });

    cy.get(draggableElement).first().as("draggedRow");
    cy.get(dropZone).as("targetRow");

    cy.get("@draggedRow").and("contain", "5");
    cy.get("@targetRow").and("contain", "8");

    cy.get("@draggedRow").dragAndDropTableRow("@targetRow");

    cy.get("@draggedRow").should("be.visible").and("contain", "6");
    cy.get("@targetRow").should("be.visible").and("contain", "5");
  });

  it("13 - Should grab the length of the select cut grid", () => {
    cy.wait(2000).then(() => {
      cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");
      const expectedLength = selectCutsGridLength;
      cy.window().then(win => {
        const kendoGrid = win.jQuery("#new-grid").data("kendoGrid");
        const dataSource = kendoGrid.dataSource.view();
        cy.wrap(dataSource).should("have.length", expectedLength);
      });
    });
  });

  it("14 - Should Delete a row and check it length", () => {
    cy.wait(2000).then(() => {
      cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");
      cy.get('i[data-cy="deleteActionIcon"').first().as("firstDeleteActionIcon");
      cy.get("@firstDeleteActionIcon").should("exist");
      cy.get("@firstDeleteActionIcon").click({ force: true });
      cy.wait(2000).then(() => {
        cy.get('div[data-cy="deleteDialogMSSelectedCuts"]').should("be.visible");
        cy.get("#dialog-selected-cuts").as("contentDialog");
        cy.get("@contentDialog").should("be.visible");
        cy.get("@contentDialog").next().first().children().first().as("yesButton");
        cy.get("@yesButton").should("exist");
        cy.get("@yesButton").should("be.visible");
        cy.get("@yesButton").click({ force: true });
        cy.wait(2000).then(() => {
          cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");
          const expectedLength = selectCutsGridLength;
          cy.window().then(win => {
            const kendoGrid = win.jQuery("#new-grid").data("kendoGrid");
            const dataSource = kendoGrid.dataSource.view();
            cy.wrap(dataSource).should("have.length", expectedLength - 1);
          });
        });
      });
    });
  });

  it("15 - Should Move a Row Down and Check its report order", () => {
    cy.wait(2000).then(() => {
      cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");

      cy.window().then(win => {
        const kendoGrid = win.jQuery("#new-grid").data("kendoGrid");

        expect(kendoGrid.dataSource.total()).to.be.greaterThan(0);

        const initialDataItem = kendoGrid.dataItem(kendoGrid.tbody.find("tr").first());

        const initialReportOrder = initialDataItem.reportOrder;
        const initiaMarketSegmentCutKey = initialDataItem.marketSegmentCutKey;
        cy.get('i[data-cy="faAngleDoubleDown"]').first().click();

        const updatedDataItem = kendoGrid.dataItem(kendoGrid.tbody.find("tr").eq(1));
        const updatedReportOrder = updatedDataItem.reportOrder;
        const updatedMarketSegmentCutKey = updatedDataItem.marketSegmentCutKey;

        expect(initialReportOrder).to.not.equal(updatedReportOrder);
        expect(initiaMarketSegmentCutKey).to.not.equal(updatedMarketSegmentCutKey);
      });
    });
  });

  it("16 - Should Uncheck a Select cut and Check its display on report property", () => {
    cy.wait(2000).then(() => {
      cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");

      cy.window().then(win => {
        const kendoGrid = win.jQuery("#new-grid").data("kendoGrid");

        expect(kendoGrid.dataSource.total()).to.be.greaterThan(0);
        const initialDataItem = kendoGrid.dataItem(kendoGrid.tbody.find("tr").eq(1));

        cy.get(`[data-cy=${initialDataItem.marketSegmentCutKey}-checkboxSelectCut]`).as("displayOnReportCheck");
        cy.get("@displayOnReportCheck").should("be.checked");

        cy.get("@displayOnReportCheck").uncheck({ force: true });
        cy.get("@displayOnReportCheck").should("not.be.checked");
      });
    });
  });

  it("17 - Should change market pricing cut field", () => {
    cy.wait(2000).then(() => {
      cy.get('div[data-cy="selectCutsGrid"]').should("be.visible");

      cy.window().then(win => {
        const kendoGrid = win.jQuery("#new-grid").data("kendoGrid");

        expect(kendoGrid.dataSource.total()).to.be.greaterThan(0);
        cy.get(`[data-cy=marketPricingInputCell-1]`).as("pricingInput");
        cy.get("@pricingInput").should("be.visible");
        cy.get("@pricingInput").invoke("val").should("not.be.empty").and("not.contain", "mkt pricing cut");
        cy.get("@pricingInput").clear({ force: true });
        cy.get("@pricingInput").type("mkt pricing cut");
        cy.get("@pricingInput").invoke("val").should("not.be.empty").and("contain", "mkt pricing cut");
      });
    });
  });

  it("18 - check action buttons exists in ERI section", () => {
    cy.wait(1000).then(() => {
      cy.get("button[data-cy=accordionERIBtn]").click();
      cy.wait(1000).then(() => {
        cy.get("button[data-cy=msEriSection-previousBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-nextBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-saveBtn]").should("exist");
        cy.get("button[data-cy=msEriSection-saveNextBtn]").should("exist");
        cy.get('[data-cy="tableERISection"]').should("be.visible");
        cy.get('[data-cy="eriAdjustmentFactorInput"]').should("be.visible");
        cy.get('[data-cy="eriCutNameInput"]').should("be.visible");
        cy.get('[data-cy="eriCityInput"]').should("be.visible");
      });
    });
  });

  it("19 - Should show a confirmation dialog for unsaved changes when navigating away", () => {
    cy.get('[data-cy="eriAdjustmentFactorInput"]').type("0.75");
    cy.get('[data-cy="eriCutNameInput"]').type("Valid ERI Name");
    cy.get('[data-cy="msEriSection-previousBtn"]').click();
    cy.wait(3000).then(() => {
      cy.contains("Confirmation Required").should("exist");
      cy.contains("Yes").should("exist");
      cy.contains("No").should("exist");
      cy.contains("You have unsaved changes. Are you sure you want to leave without saving?").should("exist");

      cy.get('[data-cy="noConfirmation"]').click();
    });
  });

  it("20 - Should fill and save ERI, check it success confirmations", () => {
    cy.wait(2000).then(() => {
      cy.get('[data-cy="eriAdjustmentFactorInput"]').clear();
      cy.get('[data-cy="eriAdjustmentFactorInput"]').type("1");
      cy.get('[data-cy="eriCutNameInput"]').focus();
      cy.get('[data-cy="eriCutNameInput"]').clear();
      cy.get('[data-cy="eriCutNameInput"]').type(eriCutName);
      cy.get('[data-cy="eriCityInput"]').focus();
      cy.get('[data-cy="eriCityInput"]').clear();
      cy.get('[data-cy="eriCityInput"]').type("City input");
      cy.get("button[data-cy=msEriSection-saveBtn]").as("saveBtnEri");
      cy.get("@saveBtnEri").click({ force: true });
      cy.wait(2000).then(() => {
        cy.contains("The ERI records have been saved").should("exist");
        cy.wait(2000);
      });
    });
  });

  it("21 - check action buttons exists in blend section", () => {
    cy.get("button[data-cy=accordionBlendBtn]").click();
    cy.wait(1000).then(() => {
      cy.get("button[data-cy=msBlendSection-previousBtn]").should("exist");
      cy.get("button[data-cy=msBlendSection-nextBtn]").should("exist");
      cy.get("button[data-cy=msBlendSection-saveBtn]").should("exist");
      cy.get("button[data-cy=msBlendSection-saveNextBtn]").should("exist");
      cy.get("button[data-cy=msBlendSection-viewDetailBtn]").should("exist");
    });
  });

  it("22 - Add ERI Cut to combined average and move to ERI Section", () => {
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

  it("23 - Blend section should exist fully - check ", () => {
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

  it("24 - Add Blend", () => {
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

      cy.wait(2000).then(() => {
        cy.contains("The Blend has been saved").should("exist");
      });
    });
  });

  it("25 - Select Cuts - Blend cut should open SurveyLevelDetails Modal", () => {
    cy.wait(1200).then(() => {
      cy.get("[data-cy='BlendCutGroupLink']").eq(1).as("BlendCutGroup");
      cy.get("@BlendCutGroup").scrollIntoView();
      cy.get("@BlendCutGroup").click({ force: true });
      cy.wait(1200).then(() => {
        cy.get("button[data-cy=closeBtn]").click();
      });
    });
  });

  it("26 - Select Cuts - Blend cut should navigate to blend section", () => {
    cy.get("[data-cy=accordionSelectedCutsBtn]").as("selectCutsSection");
    cy.get("@selectCutsSection").click();
    cy.get(`[data-cy='BlendPricingInputCell-${blendName}']`).as("BlendNamePricingCut");
    cy.get("@BlendNamePricingCut").scrollIntoView();
    cy.get("@BlendNamePricingCut").should("contain", blendName);
    cy.get("@BlendNamePricingCut").click();
  });

  it("27 - should check labels in Market Segment Accordion", () => {
    cy.get("[data-cy=accordionFiltersBtn]").click();
    cy.get("label[data-cy=multiselect-label-publisher").should("be.visible").and("contain", "Publisher");
    cy.get("label[data-cy=multiselect-label-year").should("be.visible").and("contain", "Year");
    cy.get("label[data-cy=multiselect-label-survey").should("be.visible").and("contain", "Survey");
  });

  it("28 - Should check fields in empty ERI Accordion", () => {
    cy.get("[data-cy=accordionERIBtn]").click();

    cy.get("th[data-cy=eriAdjFactorTh").should("be.visible").and("contain", "ERI Adj Factor");
    cy.get("th[data-cy=eriCutNameTh").should("be.visible").and("contain", "ERI Cut Name");
    cy.get("th[data-cy=eriCutCityTh").should("be.visible").and("contain", "ERI Cut City");
  });

  it("29 - Add new market segment and fill invalid ERI data", () => {
    visitMarketSegmentTab(orgName);

    marketSegment.getEditMarketSegmentBtn().should("be.visible");

    addMarketSegment();

    cy.get(".publisher-autocomplete").as("publisherAutoComplete");
    cy.get("@publisherAutoComplete").first().as("FirstFilter");

    cy.get("@FirstFilter").click({ force: true });

    cy.wait(2500).then(() => {
      cy.get("li.k-list-item span.k-list-item-text").contains("SullivanCotter").click({ force: true });
      cy.get("[data-cy=publisher-filterMultipleSelect]").should("be.visible");
      cy.wait(1000).then(() => {
        cy.get('button[data-cy="nextBtnMSFilters"]').click({ force: true });
        cy.wait(3000).then(() => {
          cy.get(`[data-cy=marketPricingInputCell-4]`).as("pricingInput");
          cy.get("@pricingInput").should("be.visible");
          cy.get("@pricingInput").invoke("val").should("not.be.empty").and("contain", "National");

          cy.get("@pricingInput").clear({ force: true });
          cy.get("@pricingInput").type("mkt pricing cut");
          cy.get("@pricingInput").invoke("val").should("not.be.empty").and("contain", "mkt pricing cut");
          cy.get('button[data-cy="msSelectionCutSection-saveBtn"]').click({ force: true });
        });
      });
    });
    cy.wait(1500).then(() => {
      cy.get("button[data-cy=msSelectionCutSection-saveBtn]").should("exist");
    });

    cy.wait(3000).then(() => {
      cy.get("[data-cy=accordionERIBtn]").click();

      cy.get('[data-cy="eriAdjustmentFactorInput"]').clear();
      cy.get('[data-cy="eriAdjustmentFactorInput"]').type("1");
      cy.get('[data-cy="eriCutNameInput"]').clear();
      cy.get('[data-cy="eriCutNameInput"]').type(invalidEriCutName);
      cy.wait(1000).then(() => {
        cy.get('[data-cy="eriCityInput"]').focus();
        cy.get('[data-cy="eriCityInput"]').clear();
        cy.get('[data-cy="eriCityInput"]').type("City input");
        cy.get("button[data-cy=msEriSection-saveBtn]").as("saveBtnEri");
        cy.get("@saveBtnEri").click({ force: true });
      });

      cy.wait(1000).then(() => {
        cy.contains("The ERI records have been saved").should("exist");
      });

      cy.wait(2000);
      cy.get('button[data-cy="accordionCombinedAveragedBtn"]').click({ force: true });
      cy.get('button[data-cy="addCombinedAverageBtn"]').click({ force: true });

      cy.wait(2000);

      cy.get("input[data-cy='combinedAverageNameInput']").as("inputCombined");
      cy.get("div[data-cy='combined-average-modal-grid']").as("ModalGridCombined");

      cy.get("h5[data-cy='modalTitle']").should("exist");

      cy.get("label[data-cy='combinedAverageNameLabel']").should("exist");
      cy.get("@inputCombined").should("exist");
      cy.wait(500);

      cy.get("@inputCombined").type("This is a combined average");
      cy.get("@ModalGridCombined").should("exist");
      cy.wait(500);

      cy.get('input[data-cy="inputCheckboxAcademic"]').should("be.visible").check();
      cy.get(`input[data-cy="inputCheckbox${escape(invalidEriCutName)}"]`)
        .last()
        .check({ force: true });
      cy.wait(500);
      cy.get('button[data-cy="saveBtnCombinedModal"]').click({ force: true });
    });
  });

  it("30 - Edit market segment blend and save should work ", () => {
    visitMarketSegmentTab(orgName);

    marketSegment.getEditMarketSegmentBtn().should("be.visible");
    marketSegment.getMarketSegmentInput().click({ force: true });
    marketSegment.getMarketSegmentInput().clear({ force: true });
    marketSegment.getMarketSegmentInput().type("add");
    cy.wait(1500).then(() => {
      cy.get("#marketSegmentNameControl_listbox .k-list-item").eq(0).click({ force: true });
    });

    marketSegment.getEditMarketSegmentBtn().click({ force: true });

    cy.wait(3000).then(() => {
      cy.get('[data-cy="BlendPricingInputCell-BLEND TEST"]').click({ force: true });

      cy.wait(1200).then(() => {
        cy.get("[data-cy=blendWeightInput]").eq(0).as("blendWeightInputOne");
        cy.get("[data-cy=blendWeightInput]").eq(1).as("blendWeightInputTwo");
        cy.get("@blendWeightInputOne").clear();
        cy.get("@blendWeightInputOne").type("0.3");
        cy.get("@blendWeightInputTwo").clear();
        cy.get("@blendWeightInputTwo").type("0.7");
        cy.get("button[data-cy=msBlendSection-saveBtn]")
          .click()
          .then(() => {
            cy.get(".k-notification-content").should("exist");
          });
      });
    });
  });

  Cypress.Commands.add("dragAndDropTableRow", { prevSubject: "element" }, (subject, targetSelector) => {
    cy.wrap(subject).trigger("dragstart");
    cy.get(targetSelector).trigger("dragover").trigger("drop");
    cy.wrap(subject).trigger("dragend");
  });
});
