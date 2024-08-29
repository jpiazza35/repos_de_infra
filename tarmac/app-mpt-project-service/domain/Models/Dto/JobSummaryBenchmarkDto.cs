using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Domain.Models.Dto
{
    public class JobSummaryBenchmarkDto : BenchmarkPercentilesDto
    {
        public List<BenchmarkComparisonDto>? Comparisons { get; set; }
    }
}