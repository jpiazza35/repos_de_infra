//TODOFIX10062023
// let orgSearchStart = null,
//   orgNameID = "",
//   projectData = null,
//   orgID = 0,
//   filters,
//   publisher,
//   year,
//   survey,
//   industry,
//   orgType,
//   cutGroup,
//   cutSubGroup;

// const titleArray = [
//   {
//     title: "Publisher",
//     key: "publisher",
//     autocompleteConfig: {
//       dataTextField: "surveyPublisherName",
//       dataValueField: "surveyPublisherKey",
//     },
//   },
//   {
//     title: "Year",
//     key: "year",
//     autocompleteConfig: {
//       dataTextField: "yearName",
//       dataValueField: "yearKey",
//     },
//     defaultValue: [
//       {
//         yearName: 2023,
//         yearKey: 2,
//       },
//       {
//         yearName: 2022,
//         yearKey: 1,
//       },
//       {
//         yearName: 2021,
//         yearKey: 0,
//       },
//     ],
//   },
//   {
//     title: "Survey",
//     key: "survey",
//     autocompleteConfig: {
//       dataTextField: "surveyName",
//       dataValueField: "surveyKey",
//     },
//   },
//   {
//     title: "Industry/Sector",
//     key: "industrySector",
//     autocompleteConfig: {
//       dataTextField: "industrySectorName",
//       dataValueField: "industrySectorKey",
//     },
//   },
//   {
//     title: "Org Type",
//     key: "organizationType",
//     autocompleteConfig: {
//       dataTextField: "organizationTypeName",
//       dataValueField: "organizationTypeKey",
//     },
//   },
//   {
//     title: "Cut Group",
//     key: "cutGroup",
//     autocompleteConfig: {
//       dataTextField: "cutGroupName",
//       dataValueField: "cutGroupKey",
//     },
//   },
// ];

// describe("market segment Filter Section", () => {
//   before(function () {
//     cy.NavigateToMPTHomeAuthenticate();
//     cy.get("ul.metismenu li:nth-child(4) > a").click({ force: true });
//     cy.wait(1000).then(interception => {
//       cy.get("#sidebar-collapse ul li.active a span")
//         .invoke("text")
//         .should("contain", "Project");
//     });

//     cy.fixture("project").then(function (projectDatas) {
//       projectData = projectDatas;
//       orgSearchStart = projectData.orgName.substring(0, 1);
//       orgID = projectData.orgID;
//       orgNameID = projectData.orgName + "-" + projectData.orgID;

//       cy.wait(1000).then(interception => {
//         cy.scrollTo("0%", "100%");
//         cy.AutoCompleteFirstChild(
//           "input#organization-input",
//           orgSearchStart,
//           orgNameID,
//         );
//         cy.wait(2000).then(() => {
//           cy.get("select[data-cy=projectId]").selectNth(1);
//           cy.get("select[data-cy=projectId]").trigger("change", {
//             force: true,
//           });
//           cy.get("select[data-cy=projectVersion]").selectNth(1);
//           cy.get("select[data-cy=projectVersion]").trigger("change", {
//             force: true,
//           });
//         });
//       });
//     });
//     cy.fixture("filters").then(function (filtersData) {
//       filters = filtersData;
//     });
//   });

//   it("01: check market segment tab exists", () => {
//     cy.get("li[data-cy=marketSegment]").should("be.visible");
//     cy.get("li[data-cy=marketSegment]").click();
//   });

//   it("02: Filters section should be visible - Click collapse/uncollapse", () => {
//     cy.get("li[data-cy=marketSegment]").should("be.visible");
//     cy.get("li[data-cy=marketSegment]").click();

//     cy.get("[data-cy=accordianFiltersBtn]").should("be.visible").click();
//     cy.get("[data-cy=msFilterSectionContainer").should("be.visible");
//     cy.wait(2000).then(() => {
//       cy.get("[data-cy=accordianFiltersBtn]").click();
//     });
//     cy.wait(1000).then(() => {
//       cy.get("[data-cy=msFilterSectionContainer").should("be.hidden");
//     });
//   });
//   it("03: Test if it render all Autocompletes", () => {
//     titleArray.forEach(autoComplete => {
//       cy.get(`[data-cy=${autoComplete.key}-filterMultipleSelect]`).should(
//         "exist",
//       );
//     });
//   });
//   it("06: Select first option on all Autocomplete", () => {
//     cy.get("[data-cy=accordianFiltersBtn]").should("be.visible").click();

//     cy.wait(1000).then(() => {
//       cy.get("[data-cy=msFilterSectionContainer]").should("be.visible");
//       titleArray.forEach(autocomplete => {
//         cy.get(`span.${autocomplete.key}-autocomplete`)
//           .should("be.visible")
//           .click();
//         cy.wait(1000).then(() => {
//           cy.get("div.k-animation-container:visible")
//             .first()
//             .should("be.visible");
//           cy.get("div.k-animation-container:visible li:first").click();

//           cy.get(`span.${autocomplete.key}-autocomplete`).first().click();
//         });
//       });
//     });
//   });

//   it("04: Type text should request filter", () => {
//     cy.get("[data-cy=msFilterSectionContainer]").should("be.visible");

//     cy.get(`span.publisher-autocomplete`).should("be.visible").type("sull");

//     cy.get("div.k-animation-container").first().should("be.visible");
//     cy.get("#multiselect-autocomplete_listbox li:first").click();
//   });

//   it("07: Hit next button should collapse filters", () => {
//     cy.get("[data-cy=msFilterSectionContainer]").should("be.visible");
//     cy.get("[data-cy=nextBtnMSFilters]").should("be.visible").click();
//     cy.get("[data-cy=msFilterSectionContainer]").should("be.hidden");
//   });
// });
