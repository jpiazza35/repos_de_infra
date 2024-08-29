using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Project.RestApi.Controllers
{
    [Authorize]
    [Route("api/projects/graphs")]
    [ApiController]
    public class GraphController : ControllerBase
    {
        private readonly IGraphService _graphService;

        public GraphController(IGraphService graphService)
        {
            _graphService = graphService;
        }

        [HttpGet, Route("{projectVersionId}/market-comparison")]
        public async Task<IActionResult> GetBasePayMarketComparisonGraphData(int projectVersionId)
        {
            return Ok(await _graphService.GetBasePayMarketComparisonGraphData(projectVersionId));
        }

        [HttpPost, Route("{projectVersionId}/market-comparison")]
        public async Task<IActionResult> GetBasePayMarketComparisonGraphDataWithBenchmarkComparison(int projectVersionId, [FromBody] JobSummaryBenchmarkComparisonRequestDto jobSummaryComparisonRequestDto)
        {
            return Ok(await _graphService.GetBasePayMarketComparisonGraphData(projectVersionId, jobSummaryComparisonRequestDto));
        }
    }
}
