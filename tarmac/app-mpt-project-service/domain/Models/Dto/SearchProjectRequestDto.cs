using System.Collections.Generic;

namespace CN.Project.Domain.Dto;

public class SearchProjectRequestDto
{
    public int take { get; set; }
    public int skip { get; set; }
    public int page { get; set; }

    public int orgId { get; set; }
    public int projectId { get; set; }
    public int projectVersionId { get; set; }


    public List<Sort> sort { get; set; } = null;

}

public class Sort
{
    public string? field { get; set; }
    public string? dir { get; set; }
}
