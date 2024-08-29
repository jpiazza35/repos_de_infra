namespace CN.Survey.Domain.Response
{
    public class SurveyCutsDataListResponse
    {
        public List<SurveyCutsDataResponse> SurveyCutsData { get; set; } = new List<SurveyCutsDataResponse>();
        public List<StandardJobResponse> StandardJobs { get; set; } = new List<StandardJobResponse>();
        public List<PublisherResponse> Publishers { get; set; } = new List<PublisherResponse>();
        public List<SurveyJobResponse> SurveyJobs { get; set; } = new List<SurveyJobResponse>();
    }
}