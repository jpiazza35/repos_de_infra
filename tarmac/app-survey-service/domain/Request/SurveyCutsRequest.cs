namespace CN.Survey.Domain.Request
{
    public class SurveyCutsRequest
    {
        public List<int>? SurveyPublisherKeys { get; set; }
        public List<int>? SurveyYears { get; set; }
        public List<int>? SurveyKeys { get; set; }
        public List<int>? IndustrySectorKeys { get; set; }
        public List<int>? OrganizationTypeKeys { get; set; }
        public List<int>? CutGroupKeys { get; set; }
        public List<int>? CutSubGroupKeys { get; set; }
        public List<int>? CutKeys { get; set; }
        public List<int>? BenchmarkDataTypeKeys { get; set; }
        public List<string>? StandardJobCodes { get; set; }
    }
}
