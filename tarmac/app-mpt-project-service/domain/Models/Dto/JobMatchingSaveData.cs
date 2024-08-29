namespace CN.Project.Domain.Models.Dto
{
    public class JobMatchingSaveData
    {
        public string MarketPricingJobCode { get; set; } = string.Empty;
        public string MarketPricingJobTitle { get; set; } = string.Empty;
        public string MarketPricingJobDescription { get; set; } = string.Empty;
        public string PublisherName { get; set; } = string.Empty;
        public int? PublisherKey { get; set; }
        public string JobMatchNote { get; set; } = string.Empty;
        public int? JobMatchStatusKey { get; set; }
        public List<JobMatchingStatusUpdateDto> SelectedJobs { get; set; } = new List<JobMatchingStatusUpdateDto>();
        public List<StandardJobMatchingDto> StandardJobs { get; set; } = new List<StandardJobMatchingDto>();
    }
}
