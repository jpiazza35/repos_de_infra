using CN.Project.Domain.Enum;

namespace CN.Project.Domain.Dto;

public class SearchProjectDto
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public string? Organization { get; set; }
    public int OrganizationId { get; set; }
    public int ProjectVersion { get; set; }
    public string? ProjectVersionLabel { get; set; }
    public DateTime? ProjectVersionDate { get; set; }
    public string? SourceData { get; set; }
    public string? Status { get; set; }
    public string? DataEffectiveDate { get; set; }
    public string? FileStatusName { get; set; }
    public AggregationMethodology AggregationMethodologyKey { get; set; }
    public string AggregationMethodologyName { get { return AggregationMethodologyKey.ToString(); } }
    public int WorkForceProjectType { get; set; }
    public int? FileLogKey { get; set; }
}