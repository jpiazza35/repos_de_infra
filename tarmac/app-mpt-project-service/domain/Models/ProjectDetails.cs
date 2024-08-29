using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain;

public class ProjectDetails
{
    [Key]
    public int project_id { get; set; }
    public int org_key { get; set; }
    public string? project_name { get; set; }
    public int? survey_source_group_key { get; set; }
    public int project_status_key { get; set; }
    public DateTime project_status_modified_utc_datetime { get; set; }
    public DateTime project_created_utc_datetime { get; set; }
    public string? emulated_by { get; set; }
    public string? modified_username { get; set; }
    public DateTime? modified_utc_datetime { get; set; }
}
