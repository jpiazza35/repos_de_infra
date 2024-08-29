using CN.Survey.Domain.Response;

namespace CN.Survey.Domain
{
    public class SurveyCut
    {
        public IEnumerable<int?>? IndustrySectorKeys { get; set; }
        public string? IndustrySectorName { get; set; }
        public IEnumerable<int?>? OrganizationTypeKeys { get; set; }
        public string? OrganizationTypeName { get; set; }
        public IEnumerable<int?>? CutGroupKeys { get; set; }
        public string? CutGroupName { get; set; }
        public IEnumerable<int?>? CutSubGroupKeys { get; set; }
        public string? CutSubGroupName { get; set; }
        public IEnumerable<SurveyCutsDataResponse>? SurveyDetails { get; set; }
    }
}
