using CN.Project.Domain.Enum;

namespace CN.Project.Domain.Models.Dto
{
    public class MarketPricingSheetFilterDto
    {
        public string? ClientJobCodeTitle { get; set; }
        public List<string> ClientJobGroupList { get; set; } = new List<string>();
        public List<IdNameDto> MarketSegmentList { get; set; } = new List<IdNameDto>();
        public MarketPricingStatus? JobMatchingStatus { get; set; }
        public List<int> SortBy { get; set; } = new List<int>();
    }
}