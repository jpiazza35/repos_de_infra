namespace CN.Project.Domain.Models.Dto
{
    public class SurveyCutDto
    {
        public IEnumerable<SurveyYearDto>? SurveyYears { get; set; }
        public IEnumerable<NameKeyDto>? Publishers { get; set; }
        public IEnumerable<NameKeyDto>? Surveys { get; set; }
        public IEnumerable<NameKeyDto>? Industries { get; set; }
        public IEnumerable<NameKeyDto>? Organizations { get; set; }
        public IEnumerable<NameKeyDto>? CutGroups { get; set; }
        public IEnumerable<NameKeyDto>? CutSubGroups { get; set; }
        public IEnumerable<NameKeyDto>? Cuts { get; set; }
    }

    public class NameKeyDto
    {
        public IEnumerable<int>? Keys { get; set; }
        public string? Name { get; set; }
    }

    public class SurveyYearDto
    {
        public int SurveyKey { get; set; }
        public int SurveyYear { get; set; }
    }
}
