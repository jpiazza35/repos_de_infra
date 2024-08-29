namespace CN.Project.Domain.Models
{
    public class MarketPricingSheetCutExternal
    {
        public int CutExternalKey { get; set; }
        public int ProjectVersionId { get; set; }
        public int? MarketPricingSheetId { get; set; }
        public string? StandardJobCode { get; set; }
        public string? StandardJobTitle { get; set; }
        public string? ExternalPublisherName { get; set; }
        public string? ExternalSurveyName { get; set; }
        public int? ExternalSurveyYear { get; set; }
        public string? ExternalSurveyJobCode { get; set; }
        public string? ExternalSurveyJobTitle { get; set; }
        public string? ExternalIndustrySectorName { get; set; }
        public string? ExternalOrganizationTypeName { get; set; }
        public string? ExternalCutGroupName { get; set; }
        public string? ExternalCutSubGroupName { get; set; }
        public string? ExternalMarketPricingCutName { get; set; }
        public string? ExternalSurveyCutName { get; set; }
        public DateTime? ExternalSurveyEffectiveDate { get; set; }
        public int IncumbentCount { get; set; }
        public List<MarketPricingSheetCutExternalData> Benchmarks { get; set; } = new List<MarketPricingSheetCutExternalData>();
    }
}