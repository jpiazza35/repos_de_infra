describe("market segment spec", () => {
  const projectVersionId = 1;
  const surveyPublisherKey = 1;
  const surveyYear = 2023;
  const surveyKey = 44;
  const industrySectorKey = null;
  const organizationTypeKey = 61;
  const cutGroupKey = 3;
  const cutSubGroupKey = null;
  const cutNames = ["$1 Billion to $4 Billion", "$1.5 Billion and Under", "$3 Billion to $7 Billion", "$6 Billion and Over"];
  const cutKeysList = [268, 448, 281, 449];

  let marketSegmentId = 0;
  let parentMarketSegmentCutKey = 0;
  let cutsCount = 0;
  let marketSegmentCount = 0;
  let childrenMarketSegmentCutKeys = [];

  before(function () {
    cy.GenerateAPIToken();
  });

  after(function () {
    //cy.logoutClientPortal();
  });

  it("Market Segment Tab::Get Filters", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/market-segment-filters",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        publisher: true,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body[0].keys[0]).to.eq(2);
      expect(response.body[0].name).to.eq("MGMA");
      expect(response.body[1].keys[0]).to.eq(1);
      expect(response.body[1].name).to.eq("SullivanCotter");
    });
  });

  it("Market Segment Tab::Get Survey Details", () => {
    const token = Cypress.env("token");
    const surveyPublisherKeys = [surveyPublisherKey];
    const surveyYears = [surveyYear];
    const surveyKeys = [surveyKey];
    const organizationTypeKeys = [organizationTypeKey];
    const cutGroupKeys = [cutGroupKey];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/market-segment-survey-details",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        surveyPublisherKeys,
        surveyYears,
        surveyKeys,
        organizationTypeKeys,
        cutGroupKeys,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(1);
      expect(response.body[0].surveyPublisherKey).to.eq(surveyPublisherKeys[0]);
      expect(response.body[0].surveyYear).to.eq(surveyYears[0]);
      expect(response.body[0].surveyKey).to.eq(surveyKeys[0]);
      expect(response.body[0].organizationTypeKey).to.eq(organizationTypeKeys[0]);
      expect(response.body[0].cutGroupKey).to.eq(cutGroupKeys[0]);
    });
  });

  it("Market Segment Tab::Get Cuts", () => {
    const token = Cypress.env("token");
    const surveyPublisherKeys = [surveyPublisherKey];
    const surveyYears = [surveyYear];
    const surveyKeys = [surveyKey];
    const organizationTypeKeys = [organizationTypeKey];
    const cutGroupKeys = [cutGroupKey];

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "survey/market-segment-cuts",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        surveyPublisherKeys,
        surveyYears,
        surveyKeys,
        organizationTypeKeys,
        cutGroupKeys,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.length).to.eq(1);
      expect(response.body[0].organizationTypeKeys[0]).to.eq(organizationTypeKeys[0]);
      expect(response.body[0].cutGroupKeys[0]).to.eq(cutGroupKeys[0]);
    });
  });

  it("Market Segment Tab::Get Market Segments", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/versions/${projectVersionId}/market-segments`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
    });
  });

  it("Market Segment Tab::Save Market Segment", () => {
    const token = Cypress.env("token");
    const blendFlag = false;
    const displayOnReport = true;
    const cutDetails = cutKeysList.map(cutKey => {
      return {
        publisherKey: surveyPublisherKey,
        surveyKey: surveyKey,
        industrySectorKey: industrySectorKey,
        organizationTypeKey: organizationTypeKey,
        cutGroupKey: cutGroupKey,
        cutSubGroupKey: cutSubGroupKey,
        cutKey: cutKey,
      };
    });

    let cuts = [];
    cutsCount++;
    cuts.push({
      cutName: cutNames[0],
      blendFlag: blendFlag,
      industrySectorKey: industrySectorKey,
      organizationTypeKey: organizationTypeKey,
      cutGroupKey: cutGroupKey,
      cutSubGroupKey: cutSubGroupKey,
      displayOnReport: displayOnReport,
      reportOrder: cutsCount,
      cutDetails: cutDetails,
    });
    cutsCount++;
    cuts.push({
      cutName: cutNames[1],
      blendFlag: blendFlag,
      industrySectorKey: null,
      organizationTypeKey: null,
      cutGroupKey: null,
      cutSubGroupKey: null,
      displayOnReport: displayOnReport,
      reportOrder: cutsCount,
      cutDetails: [],
    });

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-segments",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        name: `Test Market Segment v${marketSegmentCount}`,
        projectVersionId,
        status: 4,
        cuts: cuts,
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
      expect(response.body.id).to.not.eq(0);

      marketSegmentId = response.body.id;
      parentMarketSegmentCutKey = response.body.cuts[1]?.marketSegmentCutKey;
      childrenMarketSegmentCutKeys.push(parentMarketSegmentCutKey);
    });
  });

  it("Market Segment Tab::Save ERI", () => {
    const token = Cypress.env("token");
    const body = {
      id: marketSegmentId,
      eriAdjustmentFactor: 1.1,
      eriCutName: "Test ERI",
      eriCity: "New York",
    };
    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/market-segments/${marketSegmentId}/eri`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: body,
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
      expect(response.body.eriAdjustmentFactor).to.eq(body.eriAdjustmentFactor);
      expect(response.body.eriCity).to.eq(body.eriCity);
      expect(response.body.eriCutName).to.eq(body.eriCutName);
      expect(response.body.marketSegmentCutKey).to.eq(body.marketSegmentCutKey);
    });
  });

  it("Market Segment Tab::Get Market Segments", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "GET",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/versions/${projectVersionId}/market-segments`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body.id).to.not.eq(0);

      marketSegmentCount = response.body.length;

      expect(response.body[marketSegmentCount - 1].id).to.eq(marketSegmentId);
    });
  });

  it("Market Segment Tab::Save Survey Details Change", () => {
    const token = Cypress.env("token");
    const start = 0;
    const end = cutKeysList.length - 2;
    const selectedCutKeys = cutKeysList.slice(start, end);
    const body = selectedCutKeys.map(cutKey => {
      return {
        publisherKey: null,
        surveyKey: null,
        industrySectorKey: null,
        industrySectorName: null,
        organizationTypeKey: null,
        organizationTypeName: null,
        cutGroupKey: null,
        cutGroupName: null,
        cutSubGroupKey: null,
        cutSubGroupName: null,
        cutKey: cutKey,
      };
    });

    cy.request({
      method: "PUT",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/market-segments/${marketSegmentId}/cut-details`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: body,
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
    });
  });

  it("Market Segment Tab::Edit Market Segment", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "PUT",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + "mpt-project/market-segments",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: {
        id: marketSegmentId,
        name: `Test Market Segment v${marketSegmentCount}`,
        projectVersionId,
        status: 4,
        cuts: [
          {
            marketSegmentCutKey: childrenMarketSegmentCutKeys[0],
            cutName: cutNames[1],
            blendFlag: false,
            industrySectorKey: null,
            organizationTypeKey: null,
            cutGroupKey: null,
            cutSubGroupKey: null,
            displayOnReport: true,
            reportOrder: cutsCount,
            cutDetails: [],
          },
        ],
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("object");
      expect(response.body.id).to.eq(marketSegmentId);
    });
  });

  it("Market Segment Tab::Save Blend", () => {
    cutsCount++;
    const token = Cypress.env("token");
    const blendWeight = 1;
    const blendName = "Test Blend";
    const body = {
      blendName: blendName,
      marketSegmentId,
      displayOnReport: true,
      reportOrder: cutsCount,
      cuts: [
        {
          parentMarketSegmentCutKey,
          childMarketSegmentCutKey: childrenMarketSegmentCutKeys[0],
          blendWeight,
        },
      ],
    };

    cy.request({
      method: "POST",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/market-segments/${marketSegmentId}/blends`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: body,
    }).then(function (response) {
      expect(response.status).to.eq(200);
      expect(response.body).to.be.a("array");
      expect(response.body[0].marketSegmentId).to.eq(marketSegmentId);
      expect(response.body[0].marketSegmentCutKey).to.not.eq(0);
      expect(response.body[0].blendFlag).to.eq(true);
      expect(response.body[0].blendName).to.eq(blendName);
    });
  });

  it("Market Segment Tab::Delete Market Segment", () => {
    const token = Cypress.env("token");

    cy.request({
      method: "DELETE",
      url: Cypress.config("baseUrl") + Cypress.env("api_url_prefix") + `mpt-project/market-segments/${marketSegmentId}`,
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
    }).then(function (response) {
      expect(response.status).to.eq(200);
    });
  });
});
