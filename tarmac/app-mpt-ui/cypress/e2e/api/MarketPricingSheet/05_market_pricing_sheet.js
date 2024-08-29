describe("market pricing sheet spec", () => {
  const notes = "Test Notes";

  let projectVersionId = 0;
  let marketSegmentId = 0;
  let marketPricingSheetId = 0;

  before(function () {
    cy.GenerateAPIToken();

    cy.fixture("marketPricing").then(function (data) {
      projectVersionId = data.projectVersionId;
      marketSegmentId = data.marketSegmentId;
      marketPricingSheetId = data.marketPricingSheetId;
    });
  });

  it("Market Pricing Sheet::Get filter status count", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/status",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        marketSegmentList: [
          {
            id: marketSegmentId,
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(5);

      const total = response.body.filter(item => item.jobMatchStatus === "Total")[0];
      expect(total).to.a("object");
      expect(total.count).to.be.greaterThan(0);
    });
  });

  it("Market Pricing Sheet::Get markets segments names", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/market-segments-names",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(2);
      expect(response.body[0].id).to.eq(1);
      expect(response.body[0].name).to.eq("market segment test");
    });
  });

  it("Market Pricing Sheet::Get job groups", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/job-groups",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).to.not.be.empty;
      expect(response.body[0]).to.not.be.null;
      expect(response.body[0]).to.not.be.empty;
    });
  });

  it("Market Pricing Sheet::Get job code titles", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/job-titles",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        marketSegmentList: [
          {
            id: marketSegmentId,
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).to.not.be.empty;
      expect(response.body[0]).to.not.be.null;
      expect(response.body[0].marketPricingSheetId).to.not.be.null;
      expect(response.body[0].jobTitle).to.not.be.null;
    });
  });

  it("Market Pricing Sheet::Get markets pricing sheet info", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/sheet-info/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
      expect(response.body).to.not.be.empty;
      expect(response.body.organization.id).to.eq(90);
      expect(response.body.organization.name).to.eq("Hospital of the University of Pennsylvania");
      expect(response.body.marketPricingSheetId).to.eq(marketPricingSheetId);
      expect(response.body.marketPricingStatus).to.eq("Not Started");
    });
  });

  it("Market Pricing Sheet::Get client position detail", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/position-detail/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).to.not.be.empty;
      expect(response.body[0]).to.not.be.null;
      expect(response.body[0].jobCode).to.not.be.empty;
      expect(response.body[0].jobTitle).to.not.be.empty;
      expect(response.body[0].positionCode).to.not.be.empty;
    });
  });

  it("Market Pricing Sheet::Put Job Match Status", () => {
    const token = Cypress.env("token");
    const jobMatchStatus = 8; //AnalystReviewed
    const marketPricingSheetIdAlternative = 7;

    cy.request({
      method: "PUT",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/" +
        marketPricingSheetIdAlternative +
        "/status/" +
        jobMatchStatus,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Market Pricing Sheet::Get Job Match Detail", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/job-match-detail/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
      expect(response.body).to.not.be.empty;
      expect(response.body.jobTitle).to.eq("Software Developer 1 - standard");
      expect(response.body.jobDescription).to.eq("Information Tecnhology");
      expect(response.body.jobMatchNote).to.not.be.empty;
    });
  });

  it("Market Pricing Sheet::Save Job Match Detail", () => {
    const token = Cypress.env("token");
    const jobMatchNote = "Status Test";

    cy.request({
      method: "PUT",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/job-match-detail/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        value: jobMatchNote,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Market Pricing Sheet::Get Main Grid", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/grid/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).to.not.be.empty;
      expect(response.body[0]).to.not.be.null;
      expect(response.body[0].benchmarks).to.not.be.null;
      expect(response.body[0].benchmarks).to.not.be.empty;
    });
  });

  it("Market Pricing Sheet::Get client pay detail", () => {
    const token = Cypress.env("token");
    const versionId = 3;
    const sheetId = 11;

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + versionId + "/client-pay-detail/" + sheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.body["Annual Pay Range Minimum"]).to.eq("$1");
      expect(response.body["Hourly Base Pay"]).to.eq("$3.80");
    });
  });

  it("Market Pricing Sheet::Get adjustment notes", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/adjustment-notes",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.not.be.empty;
      expect(response.body.length).to.eq(4);
      response.body.forEach(element => {
        expect(element.id).to.not.be.null;
        expect(element.name).to.not.be.empty;
      });
    });
  });

  it("Market Pricing Sheet::Save notes", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "PUT",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/notes/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: { value: notes },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Market Pricing Sheet::Get notes", () => {
    const token = Cypress.env("token");
    const notes = "Test Notes";

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/notes/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.not.be.null;
      expect(response.body.value).to.not.be.null;
      expect(response.body.value).to.eq(notes);
    });
  });

  it("Market Pricing Sheet::Get benchmark data types for project vesion", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/benchmark-data-types",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(4);
      response.body.forEach(element => {
        expect(element.id).to.not.be.null;
        expect(element.name).to.not.be.empty;
        expect(element.agingFactor).to.be.at.least(0);
      });
    });
  });

  it("Market Pricing Sheet::Get market segment report filters", () => {
    const token = Cypress.env("token");
    const versionId = 3;

    cy.request({
      method: "GET",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        versionId +
        "/market-segment/report-filters",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(7);
      response.body.forEach(element => {
        expect(element).to.not.be.empty;
      });
    });
  });

  it("Market Pricing Sheet::Download External Data Template All Sheets", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/grid",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).to.not.be.empty;
      expect(response.body[0]).to.not.be.null;
    });
  });

  it("Market Pricing Sheet::Save Global Settings For Project Version", () => {
    const token = Cypress.env("token");
    const globalSettings = {
      sections: {
        "Organization Name": true,
        "Report Date": false,
        "Client Position Detail": true,
      },
      columns: {
        "Short Code": true,
        Publisher: true,
        Name: false,
        Year: false,
      },
      ageToDate: "2023-06-28T03:00:00.000Z",
      benchmarks: [
        {
          id: 1,
          title: "Hourly Base Pay",
          agingFactor: null,
          percentiles: [25, 50, 75],
        },
        {
          id: 2,
          title: "Hourly TCC",
          agingFactor: 2.1,
          percentiles: [25, 50, 75],
        },
      ],
    };

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/global-settings",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: globalSettings,
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });

  it("Market Pricing Sheet::Get Global Settings For Project Version", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/global-settings",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body.sections).to.not.be.empty;
      expect(response.body.columns).to.not.be.empty;
      expect(response.body.ageToDate).to.not.be.empty;
      expect(response.body.benchmarks).to.be.a("array");
      expect(response.body.benchmarks.length).to.eq(2);
      response.body.benchmarks.forEach(element => {
        expect(element.percentiles).to.be.a("array");
        expect(element.percentiles.length).to.be.at.least(0);
      });
    });
  });

  it("Market Pricing Sheet::Save Adjustment Notes", () => {
    const token = Cypress.env("token");
    const rawDataKey = 104741432;
    const excludeInCalc = false;
    const adjustmentValue = 1;
    const marketSegmentCutDetailKey = 1;
    const adjustmentNotesKey = [1, 2, 3];

    cy.request({
      method: "POST",
      url:
        Cypress.config("baseUrl") +
        Cypress.env("api_url_prefix") +
        "mpt-project/market-pricing-sheet/" +
        projectVersionId +
        "/grid/" +
        marketPricingSheetId,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        marketPricingSheetId,
        marketSegmentCutDetailKey,
        rawDataKey,
        excludeInCalc,
        adjustmentValue,
        adjustmentNotesKey,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);

      cy.request({
        method: "GET",
        url:
          Cypress.config("baseUrl") +
          Cypress.env("api_url_prefix") +
          "mpt-project/market-pricing-sheet/" +
          projectVersionId +
          "/grid/" +
          marketPricingSheetId,
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      }).then(function (response) {
        expect(response.status).to.eq(200);
        expect(response.body).to.be.a("array");
        expect(response.body).to.not.be.empty;

        const item = response.body.find(x => x.rawDataKey === rawDataKey && x.marketSegmentCutDetailKey === marketSegmentCutDetailKey);
        expect(item).to.not.be.null;
        expect(item.excludeInCalc).to.eq(excludeInCalc);
        expect(item.adjustment).to.eq(adjustmentValue);
        expect(item.adjustmentNotes).to.not.be.empty;
        expect(item.adjustmentNotes.length).to.eq(adjustmentNotesKey.length);
      });
    });
  });

  it("Market Pricing Sheet::Save External Data", () => {
    const token = Cypress.env("token");
    const now = new Date();
    const percentiles = [
      {
        percentile: 25,
        value: 30,
      },
      {
        percentile: 50,
        value: 40,
      },
      {
        percentile: 75,
        value: 50,
      },
    ];

    const body = percentiles.map(item => {
      return {
        marketPricingSheetId,
        standardJobCode: "0001",
        standardJobTitle: "Test Job",
        externalPublisherName: "Test Publisher",
        externalSurveyName: "Test Survey",
        externalSurveyYear: now.getFullYear(),
        externalSurveyJobCode: "1001",
        externalSurveyJobTitle: "Test Job",
        externalIndustrySectorName: "Test Industry",
        externalOrganizationTypeName: "Test Organization",
        externalCutGroupName: "Test Cut Group",
        externalCutSubGroupName: "Test Cut Sub Group",
        externalMarketPricingCutName: "Test Cut Name",
        externalSurveyCutName: "Test Survey Cut Name",
        externalSurveyEffectiveDate: now.toISOString(),
        incumbentCount: 10,
        benchmarkDataTypeKey: 29,
        benchmarkDataTypeValue: item.value,
        percentileNumber: item.percentile,
      };
    });

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-pricing-sheet/" + projectVersionId + "/external-data",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: body,
    }).then(function (response) {
      expect(response.status).to.eq(200);

      cy.request({
        method: "GET",
        url:
          Cypress.config("baseUrl") +
          Cypress.env("api_url_prefix") +
          "mpt-project/market-pricing-sheet/" +
          projectVersionId +
          "/grid/" +
          marketPricingSheetId,
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      }).then(function (response) {
        expect(response.status).to.eq(200);

        const externalDataRow = response.body.find(x => !!x.cutExternalKey);
        expect(externalDataRow).to.not.be.null;
      });
    });
  });

  it("Market Pricing Sheet::Search Survey Library", () => {
    const token = Cypress.env("token");
    const publisherName = "sullivancotter";
    const surveyCode = "app";
    const cutName = "national";
    const benchmarkDataTypeKey = 29;

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/cuts-data/survey-search",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        benchmarkDataTypeKeys: [benchmarkDataTypeKey],
        searchSurveyPublisherOrName: publisherName,
        searchSurveyCodeOrTitle: surveyCode,
        searchSurveyCut: cutName,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body).not.to.be.null;
      expect(response.body).not.to.be.empty;

      response.body.forEach(item => {
        expect(item.surveyPublisherName.toLowerCase().includes(publisherName)).to.be.true;
        expect(item.surveyCode.toLowerCase().includes(surveyCode)).to.be.true;
        expect(item.cutName.toLowerCase().includes(cutName)).to.be.true;

        expect(item.benchmarks).to.be.a("array");
        expect(item.benchmarks).not.to.be.null;
        expect(item.benchmarks).not.to.be.empty;

        expect(item.benchmarks.some(b => b.benchmarkDataTypeKey === benchmarkDataTypeKey)).to.be.true;
      });
    });
  });
});
