export const ProjectStatusOptions = {
  1: { id: 1, value: "Draft" },
  2: { id: 2, value: "Final" },
};

export const ProjectStatusOptionsArray = Object.values(ProjectStatusOptions);

export const MarketSegmentStatusOptions = {
  4: { id: 4, value: "Draft" },
  5: { id: 5, value: "Final" },
};

export const MarketPricingExportColumns = [
  { header: "MPSID", key: "marketPricingSheetID" },
  { header: "Market Segment Name", key: "marketSegmentName" },
  { header: "Client Job Code", key: "jobCode" },
  { header: "Client Job Title", key: "jobTitle" },
  { header: "Client Job Group", key: "jobGroup" },
  { header: "Location Description", key: "locationDescription" },
  { header: "Job Family", key: "jobFamily" },
  { header: "Position Code", key: "positionCode" },
  { header: "Position Code Description", key: "positionCodeDescription" },
  { header: "Job Level", key: "jobLevel" },
  { header: "n Incumbents", key: "incumbentCount" },
  { header: "n FTEs", key: "fteCount" },
  { header: "Pay Type", key: "payType" },
  { header: "Pay Grade", key: "payGrade" },
  { header: "Job Match Title", key: "jobMatchTitle" },
  { header: "Job Match Notes", key: "jobMatchNotes" },
  { header: "Job Match Description", key: "description" },
  { header: "Survey Short Code", key: "surveyCode" },
  { header: "Survey Publisher", key: "surveyPublisherName" },
  { header: "Survey Name", key: "surveyName" },
  { header: "Survey Year", key: "surveyYear" },
  { header: "Survey Job Code", key: "surveySpecialtyCode" },
  { header: "Survey Job Title", key: "surveySpecialtyName" },
  { header: "Adjustment", key: "adjustment" },
  { header: "Adjustment Note", key: "adjustmentNotes" },
  { header: "Industry/Sector", key: "industryName" },
  { header: "Org Type", key: "organizationTypeName" },
  { header: "Cut Group", key: "cutGroupName" },
  { header: "Cut Sub Group", key: "cutSubGroupName" },
  { header: "Cut", key: "cutName" },
  { header: "Market Pricing Cut", key: "marketSegmentCutName" },
  { header: "n=", key: "organizationCount" },
];

export const CHART_COLUMN_COLORS = ["#99DDD8", "#00A89D", "#006B64", "#F9EAC3", "#F3AA41", "#7E4602", "#80BBDF", "#0076BE", "#003B5F", "#F2ABD1"];

export const BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT = [42, 191, 192, 193];

export const BENCHMARK_IDS_WITH_DECIMAL_POSITIONS = [29, 42, 45, 65, 123, 191, 192, 193];
