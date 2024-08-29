using CN.Project.Domain.Enum;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CN.Project.RestApi.Controllers;

[Authorize]
[Route("api/projects/market-segment-mapping")]
[ApiController]
public class MarketSegmentMappingController : ControllerBase
{
    private readonly IMarketSegmentMappingService _marketSegmentMappingService;

    public MarketSegmentMappingController(IMarketSegmentMappingService marketSegmentMappingService)
    {
        _marketSegmentMappingService = marketSegmentMappingService;
    }

    [HttpGet, Route("{projectVersionId}/jobs")]
    public async Task<IActionResult> GetJobs(int projectVersionId, string? filterInput = null, string? filterColumn = null)
    {
        if (projectVersionId == 0)
            return BadRequest();

        var results = await _marketSegmentMappingService.GetJobs(projectVersionId, filterInput, filterColumn);
        return Ok(results);
    }

    [HttpGet, Route("{projectVersionId}/market-segments")]
    public async Task<IActionResult> GetMarketSegments(int projectVersionId)
    {
        var marketSegments = await _marketSegmentMappingService.GetMarketSegments(projectVersionId);
        return Ok(marketSegments);
    }

    [HttpPost, Route("{projectVersionId}")]
    public async Task<IActionResult> SaveMarketSegmentMapping(int projectVersionId, List<MarketSegmentMappingDto> marketSegmentMappings)
    {
        if (projectVersionId == 0)
            return BadRequest();

        var status = await _marketSegmentMappingService.GetProjectVersionStatus(projectVersionId);
        if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
        {
            return BadRequest("Project status prevents fields from being edited.");
        }

        var userObjectId = GetUserObjectId(User);
        await _marketSegmentMappingService.SaveMarketSegmentMapping(projectVersionId, marketSegmentMappings, userObjectId);
        return Ok();
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
