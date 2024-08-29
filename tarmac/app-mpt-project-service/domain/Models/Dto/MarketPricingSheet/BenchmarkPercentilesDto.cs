namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class BenchmarkPercentilesDto
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public string? ShortAlias { get; set; }
        public float? AgingFactor { get; set; }
        public string? Format { get; set; } 
        public int Decimals { get; set; }
        public List<MarketPercentileDto>? Percentiles { get; set; }
    }
}
