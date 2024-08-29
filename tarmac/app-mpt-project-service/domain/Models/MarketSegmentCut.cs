using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models
{
    public class MarketSegmentCut
    {
        [Key]
        public int MarketSegmentCutKey { get; set; }
        public int MarketSegmentId { get; set; }
        public bool IsBlendFlag { get; set; }
        public string? CutName { get; set; }
        public int? IndustrySectorKey { get; set; }
        public int? OrganizationTypeKey { get; set; }
        public int? CutGroupKey { get; set; }
        public int? CutSubGroupKey { get; set; }
        public string? MarketPricingCutName { get; set; }
        public bool DisplayOnReportFlag { get; set; }
        public int ReportOrder { get; set; }
        public string? EmulatedBy { get; set; }
        public string? ModifiedUsername { get; set; }
        public DateTime ModifiedUtcDatetime { get; set; }
    }
}