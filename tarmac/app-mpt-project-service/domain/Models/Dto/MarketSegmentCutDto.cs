namespace CN.Project.Domain.Models.Dto
{
    public class MarketSegmentCutDto
    {
        public int MarketSegmentCutKey { get; set; }
        public string? CutName { get; set; }
        public int MarketSegmentId { get; set; }
        public bool BlendFlag { get; set; }
        public int? IndustrySectorKey { get; set; }
        public string? IndustrySectorName { get; set; }
        public int? OrganizationTypeKey { get; set; }
        public string? OrganizationTypeName { get; set; }
        public int? CutGroupKey { get; set; }
        public string? CutGroupName { get; set; }
        public int? CutSubGroupKey { get; set; }
        public string? CutSubGroupName { get; set; }
        public bool DisplayOnReport { get; set; }
        public int ReportOrder { get; set; }
        public IEnumerable<MarketSegmentCutDetailDto>? CutDetails { get; set; }
    }
}