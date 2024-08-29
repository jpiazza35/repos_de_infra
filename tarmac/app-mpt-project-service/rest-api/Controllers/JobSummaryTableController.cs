using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Project.RestApi.Controllers
{
    [Authorize]
    [Route("api/projects/job-summary-table")]
    [ApiController]
    public class JobSummaryTableController : ControllerBase
    {
        private readonly IJobSummaryTableService _jobSummaryTableService;

        public JobSummaryTableController(IJobSummaryTableService jobSummaryTableService)
        {
            _jobSummaryTableService = jobSummaryTableService;
        }

        [HttpGet, Route("{projectVersionId}")]
        public async Task<IActionResult> GetJobSummaryTable(int projectVersionId)
        {
            return Ok(await _jobSummaryTableService.GetJobSummaryTable(projectVersionId));
        }

        [HttpPost, Route("{projectVersionId}")]
        public async Task<IActionResult> GetJobSummaryTableWithBenchmarkComparison(int projectVersionId, [FromBody] JobSummaryBenchmarkComparisonRequestDto jobSummaryComparisonRequestDto)
        {
            return Ok(await _jobSummaryTableService.GetJobSummaryTable(projectVersionId, jobSummaryComparisonRequestDto));
        }

        [HttpGet, Route("{projectVersionId}/employeeLevel")]
        public async Task<IActionResult> GetJobSummaryEmployeeLevelTable(int projectVersionId)
        {
            return Ok(await _jobSummaryTableService.GetJobSummaryTableEmployeeLevel(projectVersionId));
        }

        [HttpPost, Route("{projectVersionId}/employeeLevel")]
        public async Task<IActionResult> GetJobSummaryemployeeLevelTableWithBenchmarkComparison(int projectVersionId, [FromBody] JobSummaryBenchmarkComparisonRequestDto jobSummaryComparisonRequestDto)
        {
            return Ok(await _jobSummaryTableService.GetJobSummaryTableEmployeeLevel(projectVersionId, jobSummaryComparisonRequestDto));
        }
    }
}