namespace CN.Project.Domain.Models.Dto
{
    public class JobTitleFilterDto
    {
        public int MarketPricingSheetId { get; set; }
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public int? MarketSegmentId { get; set; }
        public string? MarketSegmentName { get; set; }
    }
}