using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Domain.Models.Dto;

public class MainSettingsDto
{
    public Dictionary<string, bool> Sections { get; set; } = new Dictionary<string, bool>();
    public Dictionary<string, bool> Columns { get; set; } = new Dictionary<string, bool>();
    public DateTime? AgeToDate { get; set; }
    public List<MainSettingsBenchmarkDto> Benchmarks { get; set; } = new List<MainSettingsBenchmarkDto>();
}
