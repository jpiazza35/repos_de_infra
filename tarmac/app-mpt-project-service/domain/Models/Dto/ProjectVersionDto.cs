using CN.Project.Domain.Enum;

namespace CN.Project.Domain.Dto;

public class ProjectVersionDto
{
    public int Id { get; set; }
    public string? VersionLabel { get; set; }
    public int? FileLogKey { get; set; }
    public AggregationMethodology? AggregationMethodologyKey { get; set; }
    public int? SurveySourceGroupKey { get; set; }
    public int OrganizationKey { get; set; }
    public DateTime ModifiedUtcDatetime { get; set; }
}
