namespace CN.Project.Domain.Models.Dto
{
    public class MarketSegmentBlendCutDto : MarketSegmentCutDto
    {
        public int MarketSegmentBlendKey { get; set; }
        public int ParentMarketSegmentCutKey { get; set; }
        public int ChildMarketSegmentCutKey { get; set; }
        public decimal BlendWeight { get; set; }
    }
}
