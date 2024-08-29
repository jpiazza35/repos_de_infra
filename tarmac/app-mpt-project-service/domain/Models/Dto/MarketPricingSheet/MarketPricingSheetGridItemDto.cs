namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class MarketPricingSheetGridItemDto
    {
        public int? ProjectOrgId { get; set; }
        public int? OrgId { get; set; }
        public int? MarketSegmentCutDetailKey { get; set; }
        public int? RawDataKey { get; set; }
        public int? CutExternalKey { get; set; }
        public string? SurveyCode { get; set; }
        public int? SurveyKey { get; set; }
        public int? SurveyYear { get; set; }
        public string? SurveyName { get; set; }
        public string? SurveySpecialtyCode { get; set; }
        public string? SurveySpecialtyName { get; set; }
        public string? StandardJobCode { get; set; }
        public string? StandardJobTitle { get; set; }
        public int? SurveyPublisherKey { get; set; }
        public string? SurveyPublisherName { get; set; }
        public int? IndustryKey { get; set; }
        public string? IndustryName { get; set; }
        public int? OrganizationTypeKey { get; set; }
        public string? OrganizationTypeName { get; set; }
        public int? CutGroupKey { get; set; }
        public string? CutGroupName { get; set; }
        public int? CutSubGroupKey { get; set; }
        public string? CutSubGroupName { get; set; }
        public int? CutKey { get; set; }
        public string? CutName { get; set; }
        public int? MarketSegmentCutKey { get; set; }
        public string? MarketSegmentCutName { get; set; }
        public int? MarketPricingSheetSurveyKey { get; set; }
        public bool ExcludeInCalc { get; set; }
        public float? Adjustment { get; set; }
        public List<string> AdjustmentNotes { get; set; } = new List<string>();
        public int ProviderCount { get; set; }
        public string FooterNotes { get; set; } = string.Empty;
        public DateTime SurveyDataEffectiveDate { get; set; }
        public DateTime? DataEffectiveDate { get; set; }
        public List<BenchmarkPercentilesDto> Benchmarks { get; set; } = new List<BenchmarkPercentilesDto>();
    }
}