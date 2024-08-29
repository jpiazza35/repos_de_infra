namespace CN.Project.Domain.Models.Dto
{
    public class MarketSegmentCutDetailDto
    {
        public int MarketSegmentCutDetailKey { get; set; }
        public int MarketSegmentCutKey { get; set; }
        public int? PublisherKey { get; set; }
        public string? PublisherName { get; set; }
        public int? SurveyKey { get; set; }
        public string? SurveyName { get; set; }
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
        public int? Year { get; set; }
        public bool Selected { get; set; } = true;
    }
}