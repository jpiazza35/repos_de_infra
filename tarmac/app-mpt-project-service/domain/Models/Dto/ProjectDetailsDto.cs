using CN.Project.Domain.Enum;

namespace CN.Project.Domain.Dto;

public class ProjectDetailsDto
{
    public int ID { get; set; }
    public string? Name { get; set; }
    public int OrganizationID { get; set; }
    public int Version { get; set; }
    public string? VersionLabel { get; set; }
    public DateTime VersionDate { get; set; }
    public AggregationMethodology AggregationMethodologyKey { get; set; }
    public string AggregationMethodologyName { get { return AggregationMethodologyKey.ToString(); } }
    public int WorkforceProjectType { get; set; }
    public int ProjectStatus { get; set; }
    public string? VersionStatusNotes { get; set; }
    public int? FileLogKey { get; set; }
    public SourceDataInfoDto? SourceDataInfo { get; set; }
    public List<BenchmarkDataTypeInfoDto>? BenchmarkDataTypes { get; set; }
    public int? ExistingFileLogKey { get; set; }
    public string? FileStatusName { get; set; }
    public int? FileStatusKey { get; set; }
}

public class BenchmarkDataTypeInfoDto
{
    public int ID { get; set; }
    public int BenchmarkDataTypeKey { get; set; }
    public float AgingFactor { get; set; }
    public float? OverrideAgingFactor { get; set; }
    public string? OverrideNote { get; set; }
}

public class SourceDataInfoDto
{
    public int Id { get; set; }
    public DateTime? EffectiveDate { get; set; }
    public int SourceDataType { get; set; }
    public string? SourceData { get; set; }
    public int? FileLogKey { get; set; }
}

public class ProjectDetailsViewDto : ProjectDetailsDto
{
    public string? OrganizationName { get; set; }
}

