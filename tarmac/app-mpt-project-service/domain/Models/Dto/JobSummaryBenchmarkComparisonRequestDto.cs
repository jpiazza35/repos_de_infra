namespace CN.Project.Domain.Models.Dto
{
    public class JobSummaryBenchmarkComparisonRequestDto
    {
        public List<BenchmarkComparisonRequestDto> Benchmarks { get; set; } = new List<BenchmarkComparisonRequestDto>();
        public MarketPricingSheetFilterDto? Filter { get; set; }
    }
}