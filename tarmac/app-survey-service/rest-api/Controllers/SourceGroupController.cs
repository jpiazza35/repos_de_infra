using CN.Survey.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.RestApi.Controllers;

[Authorize]
[Route("api/survey")]
[ApiController]
public class SourceGroupController : ControllerBase
{
    private readonly ISourceGroupRepository _sourceGroupRepository;
    public SourceGroupController(ISourceGroupRepository sourceGroupRepository)
    {
        _sourceGroupRepository = sourceGroupRepository;
    }

    [HttpGet("source-groups")]
    public async Task<IActionResult> GetSourceGroups()
    {
        var sourceGroups = await _sourceGroupRepository.GetSourceGroups();
        return Ok(sourceGroups);
    }
}