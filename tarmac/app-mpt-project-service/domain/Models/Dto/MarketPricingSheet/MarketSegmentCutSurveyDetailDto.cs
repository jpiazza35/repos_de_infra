namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class MarketSegmentCutSurveyDetailDto
    {
        public int MarketSegmentCutDetailKey { get; set; }
        public int MarketSegmentCutKey { get; set; }
        public string MarketSegmentCutName { get; set; } = string.Empty;
        public int PublisherKey { get; set; }
        public string PublisherName { get; set; } = string.Empty;
        public int SurveyKey { get; set; }
        public string SurveyName { get; set; } = string.Empty;
        public int IndustrySectorKey { get; set; }
        public string IndustrySectorName { get; set; } = string.Empty;
        public int OrganizationTypeKey { get; set; }
        public string OrganizationTypeName { get; set; } = string.Empty;
        public int CutGroupKey { get; set; }
        public string CutGroupName { get; set; } = string.Empty;
        public int CutSubGroupKey { get; set; }
        public string CutSubGroupName { get; set; } = string.Empty;
        public int CutKey { get; set; }    
        public string CutName { get; set; } = string.Empty;
        public bool IsSelected { get; set; } = true;
    }
}