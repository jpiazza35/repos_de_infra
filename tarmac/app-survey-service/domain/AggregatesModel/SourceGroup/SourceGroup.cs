using System.ComponentModel.DataAnnotations;

namespace CN.Survey.Domain;

public class SourceGroup
{
    [Key]
    public int ID { get; set; }
    public string? Name { get; set; }
    public string? Description { get; set; }
    public string? Status { get; set; }
}
