using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Project.RestApi.Controllers;

[Authorize]
[Route("api/projects")]
[ApiController]
public class ProjectController : ControllerBase
{
    private readonly IProjectRepository _projectRepository;
    private readonly IMarketSegmentService _marketSegmentService;
    private readonly IFileRepository _fileRepository;

    public ProjectController(IProjectRepository projectRepository, IMarketSegmentService marketSegmentService, IFileRepository fileRepository)
    {
        _projectRepository = projectRepository;
        _marketSegmentService = marketSegmentService;
        _fileRepository = fileRepository;
    }

    [HttpGet]
    public async Task<IActionResult> GetProjects(int orgId)
    {
        var projects = await _projectRepository.GetProjectsByOrganizationId(orgId);

        return Ok(projects);
    }

    [HttpGet, Route("{projectId}/versions")]
    public async Task<IActionResult> GetProjectVersions(int projectId)
    {
        var versions = await _projectRepository.GetProjectVersions(projectId);

        return Ok(versions);
    }

    [HttpGet, Route("{projectId}/status")]
    public async Task<IActionResult> GetProjectStatus(int projectId)
    {
        var status = await _projectRepository.GetProjectStatus(projectId);
        return Ok(status);
    }

    [HttpGet, Route("versions/{projectVersionId}/market-segments")]
    public async Task<IActionResult> GetMarketSegments(int projectVersionId)
    {
        var marketSegments = await _marketSegmentService.GetMarketSegments(projectVersionId);
        return Ok(marketSegments);
    }

    [HttpPost, Route("search")]
    public async Task<SearchProjectResultDto> SearchProject(SearchProjectRequestDto searchProjectRequestDto)
    {
        SearchProjectResultDto searchProjectResultDto = new SearchProjectResultDto();
        IEnumerable<SearchProjectDto> projectsResult = new List<SearchProjectDto>();
        string columnToSort = string.Empty;
        string sortDir = string.Empty;

        //TODO: This condition should return a bad request.
        //It is a temporary solution until the kendo grid issue is fixed (prevent a call to the API when orgId=0).
        if (searchProjectRequestDto.orgId <= 0)
        {
            searchProjectResultDto.SearchProjects = new List<SearchProjectDto>();
            return searchProjectResultDto;
        }

        if (searchProjectRequestDto.sort.Count > 0)
        {
            columnToSort = searchProjectRequestDto.sort[0].field;
            sortDir = searchProjectRequestDto.sort[0].dir;
        }

        projectsResult = await _projectRepository.SearchProject(searchProjectRequestDto.orgId,
                                                                searchProjectRequestDto.projectId, searchProjectRequestDto.projectVersionId);

        var orgIds = projectsResult.Select(x => x.OrganizationId)?.ToList();

        if (orgIds?.Count > 0)
        {
            var organizations = await _projectRepository.GetOrganizationsByIds(orgIds);

            foreach (var project in projectsResult)
            {
                project.Organization = organizations.FirstOrDefault(o => o.Id == project.OrganizationId)?.Name?.Trim();
            }
        }

        var fileIds = projectsResult.Select(x => x.FileLogKey).OfType<int>().ToList();

        if (fileIds?.Count > 0)
        {
            var files = await _fileRepository.GetFilesByIds(fileIds);

            foreach (var project in projectsResult)
            {
                project.SourceData = files.FirstOrDefault(o => o.FileLogKey == project.FileLogKey)?.SourceDataName;
                project.DataEffectiveDate = files.FirstOrDefault(o => o.FileLogKey == project.FileLogKey)?.EffectiveDate?.ToShortDateString();
                project.FileStatusName = files.FirstOrDefault(o => o.FileLogKey == project.FileLogKey)?.FileStatusName;
            }
        }

        //sorting
        if (!string.IsNullOrEmpty(columnToSort))
        {
            columnToSort = string.Concat(columnToSort[0].ToString().ToUpper(), columnToSort.AsSpan(1));
            var propInfo = projectsResult.FirstOrDefault()?.GetType().GetProperty(columnToSort);

            if (propInfo != null)
            {
                if (propInfo.PropertyType == typeof(int))
                {
                    projectsResult = sortDir == "desc" ? projectsResult.OrderByDescending(p => (int)propInfo.GetValue(p)) :
                                                         projectsResult.OrderBy(p => (int)propInfo.GetValue(p));
                }
                else
                {
                    projectsResult = sortDir == "desc" ? projectsResult.OrderByDescending(p => propInfo.GetValue(p)?.ToString()) :
                                                         projectsResult.OrderBy(p => propInfo.GetValue(p)?.ToString());
                }
            }
        }

        //paging
        searchProjectResultDto.Total = projectsResult.Count();
        searchProjectResultDto.SearchProjects = projectsResult.Skip(searchProjectRequestDto.skip).Take(searchProjectRequestDto.take).ToList();

        return searchProjectResultDto;
    }

    [HttpPost, Route("{projectId}/delete")]
    public async Task<IActionResult> DeleteProjectVersion(DeleteProjectRequestDto request)
    {
        await _projectRepository.DeleteProjectVersion(request.ProjectId, request.ProjectVersionId, request.Notes);

        return Ok($"Project Version {request.ProjectVersionId} has been deleted.");
    }

    [HttpGet, Route("versions/{projectVersionId}/status")]
    public async Task<IActionResult> GetProjectVersionStatus(int projectVersionId)
    {
        var projectVersionStatus = await _projectRepository.GetProjectVersionStatus(projectVersionId);

        return Ok(projectVersionStatus);
    }
}
