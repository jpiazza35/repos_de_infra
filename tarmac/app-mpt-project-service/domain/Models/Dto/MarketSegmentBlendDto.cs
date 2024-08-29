namespace CN.Project.Domain.Models.Dto
{
    public class MarketSegmentBlendDto
    {
        public int MarketSegmentCutKey { get; set; }
        public string? BlendName { get; set; }
        public int MarketSegmentId { get; set; }
        public bool BlendFlag { get { return true; } }
        public bool DisplayOnReport { get; set; }
        public int ReportOrder { get; set; }
        public IEnumerable<MarketSegmentBlendCutDto>? Cuts { get; set; }
    }
}