using CN.Project.Domain.Enum;

namespace CN.Project.Domain.Models.Dto
{
    public class MarketSegmentDto
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public int ProjectVersionId { get; set; }
        public decimal? EriAdjustmentFactor { get; set; }
        public string? EriCutName { get; set; }
        public string? EriCity { get; set; }
        public MarketSegmentStatus Status { get; set; }
        public IEnumerable<MarketSegmentCutDto>? Cuts { get; set; }
        public IEnumerable<MarketSegmentBlendDto>? Blends { get; set; }
    }
}
