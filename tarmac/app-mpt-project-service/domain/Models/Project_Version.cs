using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain;

public class Project_Version
{
    [Key]
    public int Project_version_id { get; set; }
    public int Project_id { get; set; }
    public string? Project_version_label { get; set; }
    public DateTime Project_version_datetime { get; set; }
    public int Project_version_status_key { get; set; }
    public string? Project_version_status_notes { get; set; }
    public int? File_log_key { get; set; }
    public int Aggregation_methodology_key { get; set; }
    public string? Emulated_by { get; set; }
    public string? Modified_username { get; set; }
    public DateTime? Modified_utc_datetime { get; set; }
}
