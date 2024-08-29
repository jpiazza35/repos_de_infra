namespace CN.Project.Domain.Models.Dto
{
    public class MarketPricingStatusDto
    {
        public int? JobMatchStatusKey { get; set; }
        public string JobMatchStatus { get; set; } = string.Empty;
        public int Count { get; set; }
    }
}