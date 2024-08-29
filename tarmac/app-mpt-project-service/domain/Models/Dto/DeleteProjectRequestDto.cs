namespace CN.Project.Domain.Models.Dto;

public class DeleteProjectRequestDto
{
    public int ProjectId { get; set; }
    public int ProjectVersionId { get; set; }
    public string? Notes { get; set; }
}
