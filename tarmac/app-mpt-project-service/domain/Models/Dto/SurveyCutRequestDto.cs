namespace CN.Project.Domain.Models.Dto
{
    public class SurveyCutRequestDto
    {
        public IEnumerable<int>? PublisherKeys { get; set; }
        public IEnumerable<int>? SurveyKeys { get; set; }
        public IEnumerable<int>? IndustrySectorKeys { get; set; }
        public IEnumerable<int>? OrganizationTypeKeys { get; set; }
        public IEnumerable<int>? CutGroupKeys { get; set; }
        public IEnumerable<int>? CutSubGroupKeys { get; set; }
    }
}