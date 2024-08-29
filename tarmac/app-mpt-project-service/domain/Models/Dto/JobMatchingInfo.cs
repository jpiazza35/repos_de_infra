namespace CN.Project.Domain.Models.Dto
{
    public class JobMatchingInfo
    {
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string JobDescription { get; set; } = string.Empty;
        public string PublisherName { get; set; } = string.Empty;
        public int? PublisherKey { get; set; }
        public string JobMatchNote { get; set; } = string.Empty;
        public string JobMatchStatusName { get; set; } = string.Empty;
        public int? JobMatchStatusKey { get; set; }
        public List<StandardJobMatchingDto> StandardJobs { get; set; } = new List<StandardJobMatchingDto>();
    }
}
