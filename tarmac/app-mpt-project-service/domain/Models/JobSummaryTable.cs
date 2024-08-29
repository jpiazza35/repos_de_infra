namespace CN.Project.Domain.Models
{
    public class JobSummaryTable
    {
        public int AggregationMethodKey { get; set; }
        public int CesOrgId { get; set; }
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string PositionCode { get; set; } = string.Empty;
        public int MarketPricingSheetId { get; set; }
        public string MarketPricingJobCode { get; set; } = string.Empty;
        public string MarketPricingJobTitle { get; set; } = string.Empty;
        public string MarketPricingSheetNote { get; set; } = string.Empty;
        public int MarketSegmentId { get; set; }
        public string MarketSegmentName { get; set; } = string.Empty;
        public string JobGroup { get; set; } = string.Empty;
        public int DataScopeKey { get; set; }
        public string DataScope { get; set; } = string.Empty;
        public string DataSource { get; set; } = string.Empty;
        public string StandardJobCode { get; set; } = string.Empty;
    }
}