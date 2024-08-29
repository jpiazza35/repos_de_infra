namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class UploadMarketPricingSheetPdfFileDto
    {
        public bool Success { get; set; } = true;
        public string? Message { get; set; }
        public int ProjectVersionId { get; set; }
        public int MarketPricingSheetId { get; set; }
        public string FileS3Url { get; set; } = string.Empty;
        public string FileS3Name { get; set; } = string.Empty;
        public string? ModifiedUsername { get; set; }
        public DateTime ModifiedUtcDatetime { get; set; }
    }
}