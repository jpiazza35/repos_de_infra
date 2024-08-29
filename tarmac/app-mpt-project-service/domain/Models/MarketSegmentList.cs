using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models
{
    public class MarketSegmentList
    {
        [Key]
        public int MarketSegmentId { get; set; }
        public int ProjectVersionId { get; set; }
        public string? MarketSegmentName { get; set; }
        public int MarketSegmentStatusKey { get; set; }
        public decimal? EriAdjustmentFactor { get; set; }
        public string? EriCutName { get; set; }
        public string? EriCity { get; set; }
        public string? EmulatedBy { get; set; }
        public string? ModifiedUsername { get; set; }
        public DateTime? ModifiedUtcDatetime { get; set; }
        public MarketSegmentCutDetail? MarketSegmentCutDetail { get; set; }
        public MarketSegmentCut? MarketSegmentCut { get; set; }
        public MarketSegmentBlend? MarketSegmentBlend { get; set; }
    }
}