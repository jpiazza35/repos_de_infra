using System.Collections;
using System.Collections.Generic;

namespace CN.Project.Domain.Dto;

public class SearchProjectResultDto
{
    public int Total { get; set; }
    public List<SearchProjectDto> SearchProjects { get; set; }
}
