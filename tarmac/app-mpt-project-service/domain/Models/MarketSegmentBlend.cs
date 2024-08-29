using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models
{
    public class MarketSegmentBlend
    {
        [Key]
        public int MarketSegmentBlendKey { get; set; }
        public int ParentMarketSegmentCutKey { get; set; }
        public int ChildMarketSegmentCutKey { get; set; }
        public decimal BlendWeight { get; set; }
        public string? EmulatedBy { get; set; }
        public string? ModifiedUsername { get; set; }
        public DateTime? ModifiedUtcDatetime { get; set; }
    }
}