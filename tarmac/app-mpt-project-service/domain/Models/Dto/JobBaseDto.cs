using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models.Dto
{
    public abstract class JobBaseDto
    {
        public int FileLogKey { get; set; }
        public int FileOrgKey { get; set; }
        public string OrganizationName { get; set; } = string.Empty;
        public string JobCode { get; set; } = string.Empty;
        public string PositionCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string JobGroup { get; set; } = string.Empty;
        public int? MarketSegmentId { get; set; }
        public string LocationDescription { get; set; } = string.Empty;
        public string JobFamily { get; set; } = string.Empty;
        public string PayGrade { get; set; } = string.Empty;
        public string PayType { get; set; } = string.Empty;
        public string PositionCodeDescription { get; set; } = string.Empty;
        public string JobLevel { get; set; } = string.Empty;

        public Dictionary<string, decimal?> BenchmarkDataTypes { get; set; } = new Dictionary<string, decimal?>();

        //Job Matching
        public string MarketSegmentName { get; set; } = string.Empty;
        public string StandardJobCode { get; set; } = string.Empty;
        public string StandardJobTitle { get; set; } = string.Empty;
        public string StandardJobDescription { get; set; } = string.Empty;
        public string JobMatchStatusName { get; set; } = string.Empty;
        public int? JobMatchStatusKey { get; set; }
        public string JobMatchNote { get; set; } = string.Empty;
    }
}
