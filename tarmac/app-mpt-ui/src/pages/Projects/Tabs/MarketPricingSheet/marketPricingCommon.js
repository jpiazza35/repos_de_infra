import { UpdateSettingFilter } from "./section/settingsAndFilterStore.js";
import { saveMainSettingsInfo } from "../../../../api/apiCalls";

export const ExpandCollaspePanel = (/** @type {MouseEvent & { currentTarget: EventTarget & HTMLElement; }} */ event, /** @type {string} */ ctrl) => {
  const card = jQuery(event.target).closest(".card");
  const cardBody = card.find(".card-body");
  let isVisible = cardBody.is(":visible");

  if (isVisible) {
    cardBody.hide(200);
    jQuery(event.target).removeClass("fa-angle-up").addClass("fa-angle-down");
  } else {
    cardBody.show(200);
    jQuery(event.target).removeClass("fa-angle-down").addClass("fa-angle-up");
  }

  saveExpandCollaspState(ctrl, !isVisible);
};

const saveExpandCollaspState = (/** @type {string} */ ctrl, /** @type {boolean} */ hidden) => {
  UpdateSettingFilter(
    (/** @type {{ LeftMainSettingsMenu: any; LeftFilterMenu: any; LeftPercentileMenu: any; LeftSortByMenu: any; }} */ SettingFilterState) => {
      if (ctrl === "LeftMainSettingsMenu") SettingFilterState.LeftMainSettingsMenu = hidden;
      if (ctrl === "LeftFilterMenu") SettingFilterState.LeftFilterMenu = hidden;
      if (ctrl === "LeftPercentileMenu") SettingFilterState.LeftPercentileMenu = hidden;
      if (ctrl === "LeftSortByMenu") SettingFilterState.LeftSortByMenu = hidden;
      return SettingFilterState;
    },
  );
};

export function castGlobalSettings(data) {
  const initialState = {
    OrgName: data.sections.OrgName,
    ReportDate: data.sections.ReportDate,
    ClientPosDetail: data.sections.ClientPosDetail,
    ClientPayDetail: data.sections.ClientPayDetail,
    MarketSegmentName: data.sections.MarketSegmentName,
    JobMatchDetail: data.sections.JobMatchDetail,
    SurveyCutColumns: [],
    AgeToDate: data.ageToDate,
    Benchmarks: [],
  };

  if (data.columns.adjustment) initialState.SurveyCutColumns.push("adjustment");
  if (data.columns.adjustmentNotes) initialState.SurveyCutColumns.push("adjustmentNotes");
  if (data.columns.cutName) initialState.SurveyCutColumns.push("cutName");
  if (data.columns.cutGroupName) initialState.SurveyCutColumns.push("cutGroupName");
  if (data.columns.cutSubGroupName) initialState.SurveyCutColumns.push("cutSubGroupName");
  if (data.columns.industryName) initialState.SurveyCutColumns.push("industryName");
  if (data.columns.organizationTypeName) initialState.SurveyCutColumns.push("organizationTypeName");
  if (data.columns.surveySpecialtyCode) initialState.SurveyCutColumns.push("surveySpecialtyCode");
  if (data.columns.surveySpecialtyName) initialState.SurveyCutColumns.push("surveySpecialtyName");
  if (data.columns.surveyName) initialState.SurveyCutColumns.push("surveyName");
  if (data.columns.surveyPublisherName) initialState.SurveyCutColumns.push("surveyPublisherName");
  if (data.columns.surveyCode) initialState.SurveyCutColumns.push("surveyCode");
  if (data.columns.surveyYear) initialState.SurveyCutColumns.push("surveyYear");
  if (data.columns.organizationCount) initialState.SurveyCutColumns.push("organizationCount");

  initialState.Benchmarks = data.benchmarks;
  return initialState;
}

export const getPricingFilterGlobalSettingsFromSession = () => {
  let projectVersionId = window.sessionStorage.getItem("projectVersionId");

  let pricingSheet = window.sessionStorage.getItem("pricingSheet-settings-" + projectVersionId);
  let pricingSheetSettings = {};
  pricingSheetSettings = pricingSheet ? JSON.parse(pricingSheet) : null;

  return pricingSheetSettings;
};

export const savePricingFilterGlobalSettingsToSession = (pricingSheetSettings, projectVersionId) => {
  window.sessionStorage.setItem("pricingSheet-settings-" + projectVersionId, JSON.stringify(pricingSheetSettings));
};

export const savePricingFilterGlobalSettings = pricingSheetSettings => {
  let projectVersionId = window.sessionStorage.getItem("projectVersionId");

  savePricingFilterGlobalSettingsToSession(pricingSheetSettings, projectVersionId);

  let data = {};
  data.AgeToDate = pricingSheetSettings.AgeToDate;
  data.Sections = {
    ClientPayDetail: pricingSheetSettings.ClientPayDetail,
    ClientPosDetail: pricingSheetSettings.ClientPosDetail,
    JobMatchDetail: pricingSheetSettings.JobMatchDetail,
    MarketSegmentName: pricingSheetSettings.MarketSegmentName,
    OrgName: pricingSheetSettings.OrgName,
    ReportDate: pricingSheetSettings.ReportDate,
  };

  if (pricingSheetSettings.SurveyCutColumns == null) pricingSheetSettings.SurveyCutColumns = [];
  else {
    data.Columns = {
      surveyCode: pricingSheetSettings.SurveyCutColumns.includes("surveyCode"),
      surveyPublisherName: pricingSheetSettings.SurveyCutColumns.includes("surveyPublisherName"),
      surveyName: pricingSheetSettings.SurveyCutColumns.includes("surveyName"),
      surveyYear: pricingSheetSettings.SurveyCutColumns.includes("surveyYear"),
      surveySpecialtyCode: pricingSheetSettings.SurveyCutColumns.includes("surveySpecialtyCode"),
      surveySpecialtyName: pricingSheetSettings.SurveyCutColumns.includes("surveySpecialtyName"),
      adjustment: pricingSheetSettings.SurveyCutColumns.includes("adjustment"),
      adjustmentNotes: pricingSheetSettings.SurveyCutColumns.includes("adjustmentNotes"),
      industryName: pricingSheetSettings.SurveyCutColumns.includes("industryName"),
      organizationTypeName: pricingSheetSettings.SurveyCutColumns.includes("organizationTypeName"),
      cutGroupName: pricingSheetSettings.SurveyCutColumns.includes("cutGroupName"),
      cutSubGroupName: pricingSheetSettings.SurveyCutColumns.includes("cutSubGroupName"),
      cutName: pricingSheetSettings.SurveyCutColumns.includes("cutName"),
      organizationCount: pricingSheetSettings.SurveyCutColumns.includes("organizationCount"),
    };
  }
  data.Benchmarks = pricingSheetSettings.Benchmarks;
  saveMainSettingsInfo(projectVersionId, data);
};

export const getInitialStateOfPricingGlobalSettings = () => {
  var today = new Date();
  var dd = String(today.getDate()).padStart(2, "0");
  var mm = String(today.getMonth() + 1).padStart(2, "0");
  var yyyy = today.getFullYear();

  const initialState = {
    OrgName: true,
    ReportDate: true,
    ClientPosDetail: true,
    ClientPayDetail: true,
    MarketSegmentName: true,
    JobMatchDetail: true,
    SurveyCutColumns: [-1],
    AgeToDate: new Date(yyyy + "-" + mm + "-" + dd),
    Benchmarks: [],
  };

  return initialState;
};

export const showErrorMessage = text => {
  let notificationWidget = null;

  if (jQuery("#notification").data("kendoNotification")) {
    notificationWidget = jQuery("#notification").data("kendoNotification");
  } else {
    // @ts-ignore
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  }

  notificationWidget.show(text, "error");
};

export const getDefaultBenchmarks = benchmarks => {
  let fiftyPercentile = [
    "pay range minimum",
    "pay range midpoint",
    "pay range maximum",
    "annualized pay range minimum",
    "annualized pay range midpoint",
    "annualized pay range maximum",
  ];

  benchmarks?.forEach(function (item) {
    //If not selected then set default values
    if (!item["Percentile"] || item["Percentile"].length == 0) {
      if (fiftyPercentile.includes(item.Text.toLowerCase())) {
        item["Selected"] = true;
        item["Percentile"] = [50];
      } else {
        item["Selected"] = true;
        item["Percentile"] = [25, 50, 75, 90];
      }
    }
  });

  return benchmarks;
};

export const showSuccessMessage = text => {
  let notificationWidget = null;

  if (jQuery("#notification").data("kendoNotification")) {
    notificationWidget = jQuery("#notification").data("kendoNotification");
  } else {
    // @ts-ignore
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  }

  notificationWidget.show(text, "success");
};
