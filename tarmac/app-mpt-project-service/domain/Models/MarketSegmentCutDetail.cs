using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models
{
    public class MarketSegmentCutDetail
    {
        [Key]
        public int MarketSegmentCutDetailKey { get; set; }
        public int MarketSegmentCutKey { get; set; } 
        public int? PublisherKey { get; set; }
        public int? SurveyKey { get; set; }
        public int? IndustrySectorKey { get; set; }
        public int? OrganizationTypeKey { get; set; }
        public int? CutGroupKey { get; set; }
        public int? CutSubGroupKey { get; set; }
        public int? CutKey { get; set; }
        public bool Selected { get; set; }
        public string? EmulatedBy { get; set; }
        public string? ModifiedUsername { get; set; }
        public DateTime ModifiedUtcDatetime { get; set; }
    }
}
