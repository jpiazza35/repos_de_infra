using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Domain.Models.Dto
{
    public class BenchmarkComparisonRequestDto : MainSettingsBenchmarkDto
    {
        public List<MainSettingsBenchmarkDto> Comparisons { get; set; } = new List<MainSettingsBenchmarkDto>();
    }
}