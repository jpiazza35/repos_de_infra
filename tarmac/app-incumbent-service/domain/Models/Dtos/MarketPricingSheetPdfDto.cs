namespace CN.Incumbent.Domain.Models.Dtos
{
    public class MarketPricingSheetPdfDto
    {
        public int OrganizationId { get; set; }
        public string OrganizationName { get; set; } = string.Empty;
        public int ProjectVersionId { get; set; }
        public DateTime ReportDate { get; set; }
        public int MarketPricingSheetId { get; set; }
    }
}
