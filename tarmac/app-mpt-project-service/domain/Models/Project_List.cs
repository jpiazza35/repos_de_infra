using System.ComponentModel.DataAnnotations;
using System;

namespace CN.Project.Domain;

public class Project_List
{
    [Key]
    public int Project_Id { get; set; }
    public string? Project_Name { get; set; }
    public int Project_Status_Key { get; set; }
    public DateTime Project_status_modified_utc_datetime { get; set; }
    public int Org_Key { get; set; }
    public int Survey_Source_Group_Key { get; set; }
    public string? Status_Name { get; set; }
    public int Project_Version_Id { get; set; }
    public string? Project_Version_Label { get; set; }
    public DateTime? Project_Version_Datetime { get; set; }
    public int Project_Version_Status_Key { get; set; }
    public DateTime? Data_Effective_Date { get; set; }
    public string? Source_Data_Name { get; set; }
    public int Aggregation_Methodology_Key { get; set; }
    public string? Project_Version_Status_Notes { get; set; }
    public int? File_Log_Key { get; set; }
}
