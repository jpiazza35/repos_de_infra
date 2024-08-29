const BenchmarkDataType = {
  basePayHourlyRate: { type: "number", required: false },
  annualizedBaseSalary: { type: "number", required: false },
  payRangeMinimum: { type: "number", required: false },
  payRangeMidpoint: { type: "number", required: false },
  payRangeMaximum: { type: "number", required: false },
  annualizedPayRangeMinimum: { type: "number", required: false },
  annualizedPayRangeMidpoint: { type: "number", required: false },
  annualizedPayRangeMaximum: { type: "number", required: false },
  actualAnnualIncentive: { type: "number", required: false },
  annualIncentiveReceiving: { type: "boolean", required: false },
  targetAnnualIncentive: { type: "number", required: false },
  targetIncentivePercent: { type: "number", required: false },
  annualIncentiveThresholdOpportunity: { type: "number", required: false },
  thresholdIncentivePercent: { type: "number", required: false },
  annualIncentiveMaximumOpportunity: { type: "number", required: false },
  maximumIncentivePercentage: { type: "number", required: false },
  TCCHourly: { type: "number", required: false },
  TCC: { type: "number", required: false },
};

export const marketSegmentMappingModel = {
  model: {
    id: "MarketSegmentMapping",
    fields: {
      organizationName: { type: "string" },
      jobCode: { type: "string" },
      jobTitle: { type: "string" },
      jobGroup: { type: "string" },
      marketSegmentName: { type: "string" },
      incumbentCount: { type: "number" },
      fteCount: { type: "number" },
      locationDescription: { type: "string" },
      jobFamily: { type: "string" },
      jobLevel: { type: "string" },
      payGrade: { type: "number" },
      payType: { type: "string" },
      positionCode: { type: "string" },
      positionCodeDescription: { type: "string" },

      // benchMarkDataTypes: { type: BenchmarkDataType },

      // sourceDataAgregationKey: { type: "number" },
      // marketPricingSheetId: { type: "number" },

      // fileLogKey: { type: "number" },
      // fileOrgKey: { type: "number" },
    },
  },
};
export const marketSegmentMappingColumns = [
  { field: "organizationName", title: "Organization" },
  { field: "jobCode", title: "Client Job Code" },
  { field: "jobTitle", title: "Client Job Title" },
  { field: "jobGroup", title: "Client Job Group" },
  { field: "marketSegmentName", title: "Market Segment" },
  { field: "incumbentCount", title: "n Incumbents" },
  { field: "fteCount", title: "n FTEs" },
  { field: "locationDescription", title: "Location Description" },
  { field: "jobFamily", title: "Job Family" },
  { field: "payGrade", title: "Pay Grade" },
  { field: "payType", title: "Pay Type" },
  { field: "positionCode", title: "Position Code" },
  { field: "positionCodeDescription", title: "Position Code Description" },
  { field: "jobLevel", title: "Job Level" },

  { field: "basePayHourlyRate", title: "Base Pay Hourly Rate", format: "{0:c}" },
  { field: "annualizedBaseSalary", title: "Annualized Base Salary", format: "{0:c}" },
  { field: "payRangeMinimum", title: "Pay Range Minimum", format: "{0:c}" },
  { field: "payRangeMidpoint", title: "Pay Range Midpoint", format: "{0:c}" },
  { field: "payRangeMaximum", title: "Pay Range Maximum", format: "{0:c}" },
  { field: "annualizedPayRangeMinimum", title: "Annualized Pay Range Minimum", format: "{0:c}" },
  { field: "annualizedPayRangeMidpoint", title: "Annualized Pay Range Midpoint", format: "{0:c}" },
  { field: "annualizedPayRangeMaximum", title: "Annualized Pay Range Maximum", format: "{0:c}" },
  { field: "actualAnnualIncentive", title: "Actual Annual Incentive", format: "{0:c}" },
  { field: "annualIncentiveReceiving", title: "Annual Incentive Receiving", format: "{0:c}" },
  { field: "targetAnnualIncentive", title: "Target Annual Incentive", format: "{0:c}" },
  { field: "targetIncentivePercent", title: "Target Incentive Percent", format: "{0:c}" },
  { field: "annualIncentiveThresholdOpportunity", title: "Annual Incentive Threshold Opportunity", format: "{0:c}" },
  { field: "thresholdIncentivePercent", title: "Threshold Incentive Percent", format: "{0:c}" },
  { field: "annualIncentiveMaximumOpportunity", title: "Annual Incentive Maximum Opportunity", format: "{0:c}" },
  { field: "maximumIncentivePercentage", title: "Maximum Incentive Percentage", format: "{0:c}" },
  { field: "TCCHourly", title: "TCC Hourly", format: "{0:c}" },
  { field: "TCC", title: "TCC", format: "{0:c}" },
];

export const marketSegmentMappingCells = [
  { value: "Organization Name" },
  { value: "Job Code" },
  { value: "Job Title" },
  { value: "Job Group" },
  { value: "Market Segment Name" },
  { value: "Incumbent Count" },
  { value: "FTE Count" },
  { value: "Location Description" },
  { value: "Job Family" },
  { value: "Job Level" },
  { value: "Pay Grade" },
  { value: "Pay Type" },
  { value: "Position Code" },
  { value: "Position Code Description" },

  { value: "Base Pay Hourly Rate" },
  { value: "Annualized Base Salary" },
  { value: "Pay Range Minimum" },
  { value: "Pay Range Midpoint" },
  { value: "Pay Range Maximum" },
  { value: "Annualized Pay Range Minimum" },
  { value: "Annualized Pay Range Midpoint" },
  { value: "Annualized Pay Range Maximum" },
  { value: "Actual Annual Incentive" },
  { value: "Annual Incentive Receiving" },
  { value: "Target Annual Incentive" },
  { value: "Target Incentive Percent" },
  { value: "Annual Incentive Threshold Opportunity" },
  { value: "Threshold Incentive Percent" },
  { value: "Annual Incentive Maximum Opportunity" },
  { value: "Maximum Incentive Percentage" },
  { value: "TCC Hourly" },
  { value: "TCC" },
];