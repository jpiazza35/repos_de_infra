using CN.Project.Domain.Dto;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using System.Text;

namespace CN.Project.RestApi.Controllers;

[Authorize]
[Route("api/projects/details")]
[ApiController]
public class ProjectDetailsController : ControllerBase
{
    private readonly IProjectDetailsRepository _projectDetailsRepository;
    private readonly IFileRepository _fileRepository;
    private readonly IProjectDetailsService _projectDetailsService;
    private readonly IBenchmarkDataService _benchmarkDataService;

    public ProjectDetailsController(IProjectDetailsRepository projectDetailsRepository, IFileRepository fileRepository, IProjectDetailsService projectDetailsService, IBenchmarkDataService benchmarkDataService)
    {
        _projectDetailsRepository = projectDetailsRepository;
        _fileRepository = fileRepository;
        _projectDetailsService = projectDetailsService;
        _benchmarkDataService = benchmarkDataService;
    }

    [HttpGet]
    public async Task<IActionResult> GetProjectDetails(int projectId, int projectVersionId)
    {
        var response = await _projectDetailsService.GetProjetDetails(projectId, projectVersionId);

        if (response.ID == 0)
        {
            return NotFound();
        }

        return Ok(response);
    }

    [HttpPost]
    public async Task<IActionResult> SaveProjectDetails(ProjectDetailsDto details)
    {
        var errorList = ValidateBenchmarkDataTypes(details.BenchmarkDataTypes);

        if (!string.IsNullOrEmpty(errorList))
        {
            return BadRequest($"Please verify the Benchmark data types values: {errorList}");
        }

        var userObjectId = GetUserObjectId(User);
        var project = await _projectDetailsService.SaveProjetDetails(details, userObjectId);
        var projectDetails = await _projectDetailsService.GetProjetDetails(project.ID, project.Version);

        return Ok(projectDetails);
    }

    [HttpPut]
    public async Task<IActionResult> UpdateProjectDetails(int projectId, int projectVersionId, ProjectDetailsDto details)
    {
        var errorList = ValidateBenchmarkDataTypes(details.BenchmarkDataTypes);
        if (!string.IsNullOrEmpty(errorList))
        {
            return BadRequest($"Please verify the Benchmark data types values: {errorList}");
        }

        var userObjectId = GetUserObjectId(User);
        await _projectDetailsRepository.UpdateProjetDetails(projectId, projectVersionId, details, userObjectId);
        var projectDetails = await _projectDetailsService.GetProjetDetails(projectId, projectVersionId);

        return Ok(projectDetails);
    }

    /// <summary>
    /// Endpoint triggered by the Glue job to insert the market pricing sheet rows after the file is processed.
    /// </summary>
    /// <param name="fileLogKey">File log key</param>
    /// <returns></returns>
    [HttpPost, Route("file/{fileLogKey}")]
    public async Task<IActionResult> InsertMarketPricingSheetRows(int fileLogKey)
    {
        if (fileLogKey == 0)
            return BadRequest();

        var userObjectId = GetUserObjectId(User);
        await _projectDetailsService.InsertMarketPricingSheetRows(fileLogKey, userObjectId);
        return Ok();
    }

    [HttpGet("{sourceGroupKey}/benchmark-data-types")]
    public async Task<IActionResult> GetBenchmarkDataTypes(int sourceGroupKey)
    {
        return Ok(await _benchmarkDataService.GetBenchmarkDataTypes(sourceGroupKey));
    }

    private string? ValidateBenchmarkDataTypes(List<BenchmarkDataTypeInfoDto>? benchmarkDataTypes)
    {
        if (benchmarkDataTypes == null || benchmarkDataTypes.Count == 0) return null;

        var errorlist = new StringBuilder();
        foreach (var item in benchmarkDataTypes)
        {
            if (item.OverrideAgingFactor != null)
            {
                if (string.IsNullOrWhiteSpace(item.OverrideNote))
                    errorlist.Append("An override note is required when the override aging factor is updated.");

                if (item.OverrideAgingFactor < 0 || item.OverrideAgingFactor > 99.99)
                    errorlist.Append("The override aging factor must be between 0 and 99.99.");
            }
        }
        return errorlist.ToString();
    }

    private string? GetUserObjectId(ClaimsPrincipal user)
    {
        try
        {
            var identity = user.Identity as ClaimsIdentity;

            if (identity != null && identity.Claims.Any())
                return identity.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == ClaimTypes.Name)?.Value;

            return null;
        }
        catch
        {
            return null;
        }
    }
}
