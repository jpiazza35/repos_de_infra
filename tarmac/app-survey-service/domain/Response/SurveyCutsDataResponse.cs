namespace CN.Survey.Domain.Response
{
    public class SurveyCutsDataResponse
    {
        public int? RawDataKey { get; set; }
        public int? SurveyPublisherKey { get; set; }
        public string? SurveyPublisherName { get; set; }
        public int? SurveyKey { get; set; }
        public int SurveyYear { get; set; }
        public string? SurveyName { get; set; }
        public string? SurveyCode { get; set; }
        public int? IndustrySectorKey { get; set; }
        public string? IndustrySectorName { get; set; }
        public int? OrganizationTypeKey { get; set; }
        public string? OrganizationTypeName { get; set; }
        public int? CutGroupKey { get; set; }
        public string? CutGroupName { get; set; }
        public int? CutSubGroupKey { get; set; }
        public string? CutSubGroupName { get; set; }
        public int? CutKey { get; set; }
        public string? CutName { get; set; }
        public int? BenchmarkDataTypeKey { get; set; }
        public string? BenchmarkDataTypeName { get; set; }
        public string? StandardJobCode { get; set; }
        public string? StandardJobTitle { get; set; }
        public string? SurveySpecialtyCode { get; set; }
        public string? SurveySpecialtyName { get; set; }
        public int ProviderCount { get; set; }
        public string? FooterNotes { get; set; }
        public DateTime SurveyDataEffectiveDate { get; set; }
        public List<MarketPercentileSet>? MarketValueByPercentile { get; set; }
    }
}