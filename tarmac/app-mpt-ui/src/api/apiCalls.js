import axios from "axios";
import { getTokenToApi } from "../auth/authHelper";

export const getBenchmarkDataTypes = async workforceProjectType =>
  await callApi(`projects/details/${workforceProjectType}/benchmark-data-types`, "GET");

export const getSourceGroups = async () => await callApi(`survey/source-groups`, "GET");

export const getProjectListForOrganization = async orgId => await callApi(`projects?orgId=${orgId}`, "GET");

export const getProjectVersionList = async projectId => await callApi(`projects/${projectId}/versions`, "GET");

export const searchOrganizationsByTerm = async term => await callApi(`users/organizations?term=${term}`, "GET");

export const searchOrganizations = async () => await callApi(`users/organizations`, "GET");

export const getProjectDetails = async (projectId, projectVersionId) =>
  await callApi(`projects/details?projectId=${projectId}&projectVersionId=${projectVersionId}`, "GET");

export const getMarketSegmentsList = async projectVersionId =>
  await callApi(`projects/market-segments/${projectVersionId}/get-segments-details-async`, "GET");

export const getMarketSegmentFilters = async formData => await callApi("survey/market-segment-filters", "POST", formData);

export const saveMarketSegment = async formData => await callApi("projects/market-segments", "POST", formData);

export const updateMarketSegment = async formData => await callApi("projects/market-segments", "PUT", formData);

export const saveFiltersSelectedCuts = async formData => await callApi("survey/market-segment-cuts", "POST", formData);

export const saveProjectDetails = async formData => await callApi("projects/details", "POST", formData);

export const updateProjectDetails = async (projectId, formData, projectVersionId) =>
  await callApi(`projects/details?projectId=${projectId}&projectVersionId=${projectVersionId}`, "PUT", formData);

export const getSourceDataEffectiveDate = async (orgId, sourceData) => await callApi(`files?orgId=${orgId}&sourceData=${sourceData}`, "GET");

export const getFileToDownload = async fileKey => await callApi(`files/${fileKey}/link`, "GET");

export const deleteProject = async (projectId, data) => await callApi(`projects/${projectId}/delete`, "POST", data);

export const getUserRoles = async () => await callApi(`users/roles`, "GET");

export const getProjectStatus = async projectId => await callApi(`projects/${projectId}/status`, "GET");
export const getProjectVersionStatus = async projectVersionId => await callApi(`projects/versions/${projectVersionId}/status`, "GET");

export const getMarketSegments = async projectVersionId => await callApi(`projects/versions/${projectVersionId}/market-segments`, "GET");

export const deleteMarketSegment = async marketSegmentId => await callApi(`projects/market-segments/${marketSegmentId}`, "DELETE");

export const getMarketMappingJobs = async projectVersionId => await callApi(`projects/market-segment-mapping/${projectVersionId}/jobs`, "GET");

export const updateMarketSegmentStatus = async (marketSegmentId, status) =>
  await callApi(`projects/market-segments/${marketSegmentId}/update-status-async?status=${status}`, "PATCH");

export const getMarketMappingMarketSegments = async projectVersionId =>
  await callApi(`projects/market-segment-mapping/${projectVersionId}/market-segments`, "GET");

export const saveMarketMappingJobs = async (projectVersionId, formData) =>
  await callApi(`projects/market-segment-mapping/${projectVersionId}`, "POST", formData);

export const saveBlends = async (marketSegmentId, formData) => await callApi(`projects/market-segments/${marketSegmentId}/blends`, "POST", formData);

export const saveFileDetails = async formData => await callApi("files", "POST", formData);

export const updateFileToUploaded = async fileKey => await callApi(`files/${fileKey}/uploaded`, "PUT");

export const saveERI = async (marketSegmentId, formData) => await callApi(`projects/market-segments/${marketSegmentId}/eri`, "POST", formData);

export const getMarketSegmentSurveyData = async formData => await callApi("survey/market-segment-survey-details", "POST", formData);

export const updateMarketSegmentSurveyData = async (marketSegmentId, formData) =>
  await callApi(`projects/market-segments/${marketSegmentId}/cut-details`, "PUT", formData);

export const getFileDetails = async fileKey => await callApi(`files/${fileKey}/details`, "GET");

export const getJobMatchings = async projectVersionId => await callApi(`projects/market-segment-mapping/${projectVersionId}/jobs`, "GET");

export const getSearchStandards = async request => await callApi(`survey/cuts-data/standard-jobs`, "POST", request);

export const updateJobMatchStatus = async (projectVersionId, statusKey, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/status/${statusKey}`, "POST", formData);

export const noBenchmarkMatch = async (projectVersionId, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/matching/client-jobs/no-benchmark-match`, "POST", formData);

export const saveJobMatchDetails = async (projectVersionId, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/matching/client-jobs`, "POST", formData);

export const getMatchedStandardJobs = async (projectVersionId, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/standard-jobs`, "POST", formData);

export const getJobMatchAuditCalculations = async (projectVersionId, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/audit-calculations`, "POST", formData);

export const saveJobMatchBulkEdit = async (projectVersionId, formData) =>
  await callApi(`projects/job-matching/${projectVersionId}/matching/bulk-edit`, "POST", formData);

export const getJobMatchPublishers = async formData => await callApi(`survey/cuts-data/publishers`, "POST", formData);

export const getSurveyJobDetails = async formData => await callApi(`survey/cuts-data/survey-jobs`, "POST", formData);

export const getMarketSegmentCuts = async marketSegmentId => await callApi(`projects/market-segments/${marketSegmentId}/cut-names`, "GET");

export const getMarketSegmentCombinedAverage = async marketSegmentId =>
  await callApi(`projects/market-segments/${marketSegmentId}/combined-averages`, "GET");

export const createMarketSegmentCombinedAverage = async (marketSegmentId, formData) =>
  await callApi(`projects/market-segments/${marketSegmentId}/combined-averages`, "POST", formData);

export const saveMarketSegmentCombinedAverage = async (marketSegmentId, formData) =>
  await callApi(`projects/market-segments/${marketSegmentId}/combined-averages`, "PUT", formData);

export const updateMarketSegmentCombinedAverage = async (marketSegmentId, combinedAverageId, formData) =>
  await callApi(`projects/market-segments/${marketSegmentId}/combined-averages/${combinedAverageId}`, "PUT", formData);

export const getPricingStatusList = async (projectVersionId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/status`, "POST", data);

export const getMarketSegmentNames = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/market-segments-names`, "GET");

export const getJobGroups = async projectVersionId => await callApi(`projects/market-pricing-sheet/${projectVersionId}/job-groups`, "GET");

export const getJobCodeTitles = async (projectVersionId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/job-titles`, "POST", data);

export const updateJobMatchStatusMarketPricing = async (projectVersionId, marketPricingSheetId, jobMatchStatusKey) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/${marketPricingSheetId}/status/${jobMatchStatusKey}`, "PUT");

export const getSheetInfo = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/sheet-info/${marketPricingSheetId}`, "GET");

export const getJobMatchInfo = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/job-match-detail/${marketPricingSheetId}`, "GET");

export const getPositionDetailInfo = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/position-detail/${marketPricingSheetId}`, "GET");

export const getClientPayInfo = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/client-pay-detail/${marketPricingSheetId}`, "GET");

export const checkJobMatchAssignemnt = async (projectVersionId, data) =>
  await callApi(`projects/job-matching/${projectVersionId}/matching/check-edition`, "POST", data);

export const saveJobMatchInfo = async (projectVersionId, marketPricingSheetId, formData) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/job-match-detail/${marketPricingSheetId}`, "PUT", formData);

export const saveMainSettingsInfo = async (projectVersionId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/global-settings`, "POST", data);

export const getMainSettingsInfo = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/global-settings`, "GET");

export const getBenchmarkInfo = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/benchmark-data-types`, "GET");

export const getAdjustmentNoteInfo = async () => await callApi(`projects/market-pricing-sheet/adjustment-notes`, "GET");

export const getGridItemsForMarketPricingSheetInfo = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/grid/${marketPricingSheetId}`, "GET");

export const getGridItemInfo = async projectVersionId => await callApi(`projects/market-pricing-sheet/${projectVersionId}/grid`, "GET");

export const getMarketSegmentReportFilters = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/market-segment/report-filters`, "GET");

export const getMarketPricingNotes = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/notes/${marketPricingSheetId}`, "GET");

export const saveMarketPricingNotes = async (projectVersionId, marketPricingSheetId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/notes/${marketPricingSheetId}`, "PUT", data);

export const getMPSGlobalSettings = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/global-settings`, "GET");

export const saveGridItemsForMarketPricingSheet = async (projectVersionId, marketPricingSheetId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/grid/${marketPricingSheetId}`, "POST", data);

export const getAllMarketPricingSheetPdf = async projectVersionId =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/export-pdf`, "GET");

export const getCurrentMarketPricingSheetPdf = async (projectVersionId, marketPricingSheetId) =>
  await callApi(`projects/market-pricing-sheet/${projectVersionId}/export-pdf?marketPricingSheetId=${marketPricingSheetId}`, "GET");

export const downloadMarketPricingSheetPdfFile = async fileS3Url => await callApi(`files/link?fileS3Name=${fileS3Url}`, "GET");

export const getMarketPricingSheetSortingFields = async () => await callApi(`projects/market-pricing-sheet/sorting-fields`, "GET");

export const getUserServiceBuild = async () => await callApi(`users/build`, "GET");
export const getIncumbentServiceBuild = async () => await callApi(`files/build`, "GET");
export const getProjectServiceBuild = async () => await callApi(`projects/build`, "GET");
export const getSurveyServiceBuild = async () => await callApi(`survey/build`, "GET");

export const getMarketComparisionData = async projectVersionId => await callApi(`projects/graphs/${projectVersionId}/market-comparison`, "GET");

export const getBasePayMarketComparisionData = async (projectVersionId, request) =>
  await callApi("projects/graphs/" + projectVersionId + "/market-comparison", "POST", request);

export async function callApi(url, method = "GET", data) {
  const token = await getTokenToApi();

  let instance = axios.create({
    headers: {
      Authorization: `Bearer ${token}`,
    },
  });

  let urlPrefix = import.meta.env.VITE_API_URL_PREFIX;
  let baseURL = import.meta.env.VITE_API_URL;

  if (baseURL && baseURL.trim().length > 0) {
    url = updatedEndpoint(url);
    instance.defaults.baseURL = baseURL.trim();
  }

  if (urlPrefix.length > 0) {
    url = urlPrefix + url;
  }

  switch (method) {
    case "POST":
      return instance.post(url, data);
    case "PUT":
      return instance.put(url, data);
    case "DELETE":
      return instance.delete(url);
    case "PATCH":
      return instance.patch(url);
    case "GET":
    default:
      return instance.get(url);
  }
}

function updatedEndpoint(url) {
  if (url.startsWith("projects")) {
    url = url.replace("projects", "mpt-project");
  } else if (url.startsWith("users")) {
    url = url.replace("users", "user");
  } else if (url.startsWith("files")) {
    url = url.replace("files", "file");
  }

  return url;
}
