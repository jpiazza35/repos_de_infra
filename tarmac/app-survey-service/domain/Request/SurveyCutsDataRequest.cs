namespace CN.Survey.Domain.Request
{
    public class SurveyCutsDataRequest
    {
        public IEnumerable<int>? SurveyYears { get; set; }
        public IEnumerable<int>? CutKeys { get; set; }
        public IEnumerable<string>? BenchmarkDataTypeNames { get; set; }
        public IEnumerable<int>? BenchmarkDataTypeKeys { get; set; }
        public IEnumerable<string>? StandardJobCodes { get; set; }
        public string? StandardJobDescription { get; set; }
        public string? SurveyJobDescription { get; set; }
        public string? StandardJobSearch { get; set; }
        public int? PublisherKey { get; set; }
    }
}
