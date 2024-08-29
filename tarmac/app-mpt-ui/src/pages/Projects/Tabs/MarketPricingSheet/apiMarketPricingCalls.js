import moment from "moment";
import {
  getPricingStatusList,
  getJobGroups,
  getJobCodeTitles,
  getSheetInfo,
  getJobMatchInfo,
  getPositionDetailInfo,
  getClientPayInfo,
  saveJobMatchInfo,
  updateJobMatchStatusMarketPricing,
  getAdjustmentNoteInfo,
  getGridItemsForMarketPricingSheetInfo,
  getGridItemInfo,
  getMarketPricingNotes,
  saveMarketPricingNotes,
  saveGridItemsForMarketPricingSheet,
  callApi,
  getMarketSegmentCombinedAverage,
  getMarketSegments,
  getMarketPricingSheetSortingFields,
} from "../../../../api/apiCalls";
import { promiseWrap } from "../../../../utils/functions";
import { marketPricingSheetStore } from "store/marketPricingSheet";

export const getGridHeaderInfo = () => {
  let gridHeader = [];

  gridHeader.push({ Title: "Survey ID", Field: "Survey_ID", IsLocked: true, IsVisible: false });
  gridHeader.push({ Title: "Survey Short Code", Field: "Survey_Short_Code", IsLocked: true, Width: 150 });
  gridHeader.push({ Title: "Survey Publisher", Field: "Survey_Publisher", IsLocked: true, Width: 150 });
  gridHeader.push({ Title: "Survey Name", Field: "Survey_Name", IsLocked: true, Width: 150 });
  gridHeader.push({ Title: "Survey Year", Field: "Survey_Year", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Survey Job Code", Field: "Survey_Job_Code", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Survey Job Title", Field: "Survey_Job_Title", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Adjustment", Field: "Adjustment", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Adjustment Note", Field: "Adjustment_Note", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Industry Sector", Field: "Industry_Sector", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Org Type", Field: "Org_Type", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Cut Group", Field: "Cut_Group", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Cut Sub Group", Field: "Cut_Sub_Group", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Cut", Field: "Cut", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "Market Pricing Cut", Field: "Cut_Name", IsLocked: false, Width: 150 });
  gridHeader.push({ Title: "nTh", Field: "nTh", IsLocked: false, Width: 150 });

  gridHeader.push({ Title: "25", Field: "Field_1_25", IsLocked: false, GroupHeader: "Hourly Base Pay", Width: 75 });
  gridHeader.push({ Title: "50", Field: "Field_1_50", IsLocked: false, GroupHeader: "Hourly Base Pay", Width: 75 });
  gridHeader.push({ Title: "75", Field: "Field_1_75", IsLocked: false, GroupHeader: "Hourly Base Pay", Width: 75 });
  gridHeader.push({ Title: "90", Field: "Field_1_90", IsLocked: false, GroupHeader: "Hourly Base Pay", Width: 75 });

  gridHeader.push({ Title: "25", Field: "Field_2_25", IsLocked: false, GroupHeader: "Hourly TCC", Width: 75 });
  gridHeader.push({ Title: "50", Field: "Field_2_50", IsLocked: false, GroupHeader: "Hourly TCC", Width: 75 });
  gridHeader.push({ Title: "75", Field: "Field_2_75", IsLocked: false, GroupHeader: "Hourly TCC", Width: 75 });
  gridHeader.push({ Title: "90", Field: "Field_2_90", IsLocked: false, GroupHeader: "Hourly TCC", Width: 75 });

  return gridHeader;
};

// eslint-disable-next-line
export const getStatusAndCount = async (filters, projectVersion) => {
  let data = {};
  data.ClientJobCodeTitle = filters.JobCodeTitle;
  data.MarketSegmentList = [];
  if (filters.JobGroup) {
    if (!(filters.JobGroup.length == 1 && filters.JobGroup[0] == -1)) data.ClientJobGroupList = filters.JobGroup;
  }

  if (filters.MarketSegmentName) {
    if (!(filters.MarketSegmentName.length == 1 && filters.MarketSegmentName[0] == -1)) {
      filters.MarketSegmentName.forEach(function (item) {
        data.MarketSegmentList.push({ id: item });
      });
    }
  }
  //data.MarketSegmentList = filters.MarketSegmentName;

  const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getPricingStatusList(projectVersion, data));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let status = [];

  searchStandardsData.forEach(function (item) {
    status.push({ StatusName: item.jobMatchStatus, StatusKey: item.jobMatchStatusKey, Count: item.count });
  });

  status.reverse();
  return status;
};

export const getJobCode = async (filters, projectVersion, sortBy = []) => {
  let data = {
    ClientJobCodeTitle: filters.JobCodeTitle,
    JobMatchingStatus: parseInt(filters.FilterStatus),
    ClientJobGroupList: [],
    MarketSegmentList: [],
    sortBy: sortBy,
  };

  if (filters.JobGroup) {
    filters.JobGroup.forEach(function (item) {
      data.ClientJobGroupList.push(item);
    });
  }

  if (filters.MarketSegmentName) {
    filters.MarketSegmentName.forEach(function (item) {
      data.MarketSegmentList.push({ id: item });
    });
  }

  const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getJobCodeTitles(projectVersion, data));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let jobCode = [];

  marketPricingSheetStore.update(state => {
    return {
      ...state,
      jobCodeTitles: searchStandardsData,
    };
  });

  searchStandardsData.forEach(function (item) {
    jobCode.push({ Text: item.jobCode + "-" + item.jobTitle, Value: item.marketPricingSheetId, SheetName: item.marketSegmentName });
  });

  return jobCode;
};

// eslint-disable-next-line
export const getHeaderInfo = async (filter, projectVersion) => {
  const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getSheetInfo(projectVersion, filter.MarketPricingSheetID));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let headerInfo = {};
  let reportDate = new Date(searchStandardsData.reportDate);

  headerInfo.Org_ID = searchStandardsData.cesOrgId;
  headerInfo.Org_Name =
    searchStandardsData.organization != undefined && searchStandardsData.organization != null ? searchStandardsData.organization.name : "";
  headerInfo.SheetID = searchStandardsData.marketPricingSheetId;
  headerInfo.Status = searchStandardsData.marketPricingStatus;
  let month = reportDate.getMonth() + 1;

  headerInfo.ReportDate = month + "/" + reportDate.getDate() + "/" + reportDate.getFullYear();

  return headerInfo;
};

export const getClientPosition = async (filters, projectVersion) => {
  const [searchFullData, searchStandardsDataError] = await promiseWrap(getPositionDetailInfo(projectVersion, filters.MarketPricingSheetID));

  marketPricingSheetStore.update(state => {
    return {
      ...state,
      clientPositionDetail: searchFullData,
    };
  });

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let clientPosition = [];

  if (searchFullData && searchFullData.length > 0) {
    let searchStandardsData = searchFullData[0];

    if (searchStandardsData.jobCode != null && searchStandardsData.jobCode.trim().length > 0)
      clientPosition.push({ Text: "Job Code", Value: searchStandardsData.jobCode });

    if (searchStandardsData.jobTitle != null && searchStandardsData.jobTitle.trim().length > 0)
      clientPosition.push({ Text: "Job Title", Value: searchStandardsData.jobTitle });

    if (searchStandardsData.jobFamily != null && searchStandardsData.jobFamily.trim().length > 0)
      clientPosition.push({ Text: "Job Family", Value: searchStandardsData.jobFamily });

    if (searchStandardsData.jobGroup != null && searchStandardsData.jobGroup.trim().length > 0)
      clientPosition.push({ Text: "Job Group", Value: searchStandardsData.jobGroup });

    if (searchStandardsData.positionCode != null && searchStandardsData.positionCode.trim().length > 0)
      clientPosition.push({ Text: "Position Code", Value: searchStandardsData.positionCode });

    if (searchStandardsData.positionCodeDescription != null && searchStandardsData.positionCodeDescription.trim().length > 0)
      clientPosition.push({ Text: "Position Code Description", Value: searchStandardsData.positionCodeDescription });

    if (searchStandardsData.locationDescription != null && searchStandardsData.locationDescription.trim().length > 0)
      clientPosition.push({ Text: "Location Description", Value: searchStandardsData.locationDescription });

    if (searchStandardsData.jobLevel != null && searchStandardsData.jobLevel.trim().length > 0)
      clientPosition.push({ Text: "Job Level", Value: searchStandardsData.jobLevel });

    if (searchStandardsData.incumbentCount != null) clientPosition.push({ Text: "Incumbent Count", Value: searchStandardsData.incumbentCount });

    if (searchStandardsData.fteCount != null) clientPosition.push({ Text: "FTE Count", Value: searchStandardsData.fteCount });

    if (searchStandardsData.payType != null && searchStandardsData.payType.trim().length > 0)
      clientPosition.push({ Text: "Pay Type", Value: searchStandardsData.payType });

    if (searchStandardsData.payGrade != null && searchStandardsData.payGrade.trim().length > 0)
      clientPosition.push({ Text: "Pay Grade", Value: searchStandardsData.payGrade });
  }

  return clientPosition;
};

// eslint-disable-next-line
export const getClientPayDetails = async (filters, projectVersion) => {
  const [searchFullData, searchStandardsDataError] = await promiseWrap(getClientPayInfo(projectVersion, filters.MarketPricingSheetID));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let clientPayDetails = [];

  Object.keys(searchFullData).reduce(function (obj, key) {
    clientPayDetails.push({ Text: key, Value: searchFullData[key] });
    return obj;
  }, {});
  return clientPayDetails;
};

export const updateJobMatchStatusInfo = async (data, projectVersion) => {
  const res = await promiseWrap(updateJobMatchStatusMarketPricing(projectVersion, data.MarketPricingSheetID, data.StatusKey));

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }
};

export const saveJobMatchDetail = async (projectVersion, marketPricingSheetID, jobMatch) => {
  const res = await promiseWrap(saveJobMatchInfo(projectVersion, marketPricingSheetID, jobMatch));

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
  }
};

export const getJobMatchDetail = async (filter, projectVersion) => {
  const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getJobMatchInfo(projectVersion, filter.MarketPricingSheetID));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let jobMatchDetail = {};

  jobMatchDetail.JobTitle = searchStandardsData.jobTitle;
  jobMatchDetail.JobMatchNotes = searchStandardsData.jobMatchNote;
  jobMatchDetail.Description = searchStandardsData.jobDescription;
  jobMatchDetail.MarketPricingSheetID = filter.MarketPricingSheetID;

  return jobMatchDetail;
};

export const saveNotes = async (marketPricingSheetID, projectVersion, notes) => {
  const res = await promiseWrap(saveMarketPricingNotes(projectVersion, marketPricingSheetID, notes));

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
  }
};

// eslint-disable-next-line
export const getMarketSheetNotes = async (ageToDate2, benchmarks, marketPricingSheetID, projectVersion) => {
  const [searchStandardsData] = await promiseWrap(getMarketPricingNotes(projectVersion, marketPricingSheetID));
  let ageToDate = moment.utc(ageToDate2);

  let year = ageToDate.year();
  let month = (ageToDate.month() + 1).toString().padStart(2, "0");
  let day = ageToDate.date().toString().padStart(2, "0");

  const benchmarkText = benchmarks
    .map((benchmark, index) => {
      const isLastRecord = index === benchmarks.length - 1;
      return `${(benchmark.AgingFactor * 100).toFixed(2)}% for ${benchmark.Text}${!isLastRecord ? ", " : "and "}`;
    })
    .join("");
  const agingFactorText = `Data above was aged to ${month}/${day}/${year} at an annualized rate of ${benchmarkText}. This is consistent with average health care industry annual increase practices.`;

  return {
    AgingFactor: agingFactorText,
    Notes: searchStandardsData.value,
    ExternalSurveyUserRestrictions: "",
  };
};

export const getPercentileValues = selectedValues => {
  let percentile = [];

  for (let i = 10; i <= 90; i = i + 5) {
    let selected = false;

    if (selectedValues != null && selectedValues.length > 0) {
      selectedValues.forEach(element => {
        if (element == i) {
          selected = true;
        }
      });
    }

    let p = { Text: i, Selected: selected };
    percentile.push(p);
  }

  return percentile;
};

export const getFooterTypes = () => {
  let gridFooterTypes = [];

  gridFooterTypes.push({ Title: "Region Average:" });
  gridFooterTypes.push({ Title: "State Average:" });
  gridFooterTypes.push({ Title: "Local Average:" });
  gridFooterTypes.push({ Title: "ERI Adj. National Average for Birmingham (-3%):" });
  gridFooterTypes.push({ Title: "State / Local Average:" });
  gridFooterTypes.push({ Title: "Region / State / Local Average:" });

  return gridFooterTypes;
};

// eslint-disable-next-line
export const getJobGroup = async (filters, projectVersion) => {
  const [searchStandardsData, searchStandardsDataError] = await promiseWrap(getJobGroups(projectVersion));

  if (searchStandardsDataError) {
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  let jobGroup = [];

  searchStandardsData.forEach(function (item) {
    jobGroup.push({ Title: item, ID: item });
  });

  return jobGroup;
};

export const getMandatoryColumns = () => {
  let mandatoryColumns = ["marketSegmentCutName"];

  return mandatoryColumns;
};

export const getExternalDataForPricingSheet = async (projectVerionId, pricingSheetId) =>
  pricingSheetId > 0
    ? await callApi(`projects/market-pricing-sheet/${projectVerionId}/grid/${pricingSheetId}`, "GET")
    : await callApi(`projects/market-pricing-sheet/${projectVerionId}/grid`, "GET");

export const saveExternalDataForPricingSheet = async (projectVerionId, data) =>
  await callApi(`projects/market-pricing-sheet/${projectVerionId}/external-data`, "POST", data);

export const getSurveyGridColumns = () => {
  let gridColumns = [];

  gridColumns = [
    {
      field: "surveyCode",
      title: "Short Code",
      width: 150,
      // locked: true,
      // lockable: false
    },
    {
      field: "surveyPublisherName",
      title: "Publisher",
      width: 150,
    },
    {
      field: "surveyName",
      title: "Name",
      width: 150,
    },
    {
      field: "surveyYear",
      title: "Year",
      width: 100,
    },
    {
      field: "surveySpecialtyCode",
      title: "Survey Job Code",
      width: 150,
    },
    {
      field: "surveySpecialtyName",
      title: "Survey Job Title",
      width: 120,
    },
    {
      field: "adjustment",
      title: "Adjustment",
      format: "{0:p2}",
      width: 120,
    },
    {
      field: "adjustmentNotes",
      title: "Adjustment Note",
      width: 160,
    },
    {
      field: "industryName",
      title: "Industry Sector",
      width: 120,
    },
    {
      field: "organizationTypeName",
      title: "Org Type",
      width: 120,
    },
    {
      field: "cutGroupName",
      title: "Cut Group",
      width: 120,
    },
    {
      field: "cutSubGroupName",
      title: "Cut Sub Group",
      width: 120,
    },
    {
      field: "cutName",
      title: "Cut",
      width: 120,
    },
    {
      field: "marketSegmentCutName",
      title: "Market Pricing Cut",
      width: 140,
    },
    {
      field: "organizationCount",
      title: "n=",
      width: 75,
    },
  ];

  return gridColumns;
};

export const getSurveyCutColumns = () => {
  let gridColumns = [];
  let columns = getSurveyGridColumns();

  for (let i = 0; i < columns.length; i++) {
    gridColumns.push({ title: columns[i].title, field: columns[i].field, selected: false });
  }

  return gridColumns;
};

export const getAdjustmentNoteLookUp = async () => {
  return await promiseWrap(getAdjustmentNoteInfo());
};

export const getGridItemsForSheet = async (projectVersion, marketPricingSheetId) => {
  return await promiseWrap(getGridItemsForMarketPricingSheetInfo(projectVersion, marketPricingSheetId));
};

export const getGridItems = async projectVersion => {
  return await promiseWrap(getGridItemInfo(projectVersion));
};

export const getSortingFields = async () => {
  const [sortingFields] = await promiseWrap(getMarketPricingSheetSortingFields());
  return sortingFields;
};

export const saveGridItems = async payload => {
  let res = await promiseWrap(saveGridItemsForMarketPricingSheet(payload.projectVersion, payload.marketPricingSheetID, payload.data));

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }
};

export const getMarketSegmentCombinedAverageInfo = async marketSegmentId => {
  let res = await promiseWrap(getMarketSegmentCombinedAverage(marketSegmentId));

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  return res[0];
};

export const getMarketSegmentsInfo = async projectVersion => {
  let res = await promiseWrap(getMarketSegments(projectVersion));

  marketPricingSheetStore.update(state => {
    return {
      ...state,
      marketSegments: res[0],
    };
  });

  if (res[1]) {
    if (res[1].response.status != 200) {
      throw res[1];
    }
    //todo: show error message
    //notificationWidget.show("Error while fetching search standards data", "error");
    //return;
  }

  return res[0];
};
