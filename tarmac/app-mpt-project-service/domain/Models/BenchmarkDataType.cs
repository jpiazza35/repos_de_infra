using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain;

public class BenchmarkDataType
{
    [Key]
    public int Project_benchmark_data_type_id { get; set; }
    public int Project_version_id { get; set; }
    public int Benchmark_data_type_key { get; set; }
    public float? Aging_factor_override { get; set; }
    public string? Override_comment { get; set; }
    public string? Emulated_by { get; set; }
    public string? Modified_username { get; set; }
    public DateTime? Modified_utc_datetime { get; set; }
}
