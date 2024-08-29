using System.ComponentModel.DataAnnotations;

namespace CN.Survey.Domain;

public class BenchmarkDataType
{
    [Key]
    public int ID { get; set; }

    public string? Name { get; set; }

    public float AgingFactor { get; set; }

    public bool? DefaultDataType { get; set; }

    public int OrderDataType { get; set; }

    public int? SurveySourceGroupKey { get; set; }
}