using CN.Project.Domain.Enum;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CN.Project.RestApi.Controllers
{
    [Authorize]
    [Route("api/projects/job-matching")]
    [ApiController]
    public class JobMatchingController : ControllerBase
    {
        private readonly IJobMatchingService _jobMatchingService;

        public JobMatchingController(IJobMatchingService jobMatchingService)
        {
            _jobMatchingService = jobMatchingService;
        }

        [HttpPost, Route("{projectVersionId}/status/{marketPricingStatusKey}")]
        public async Task<IActionResult> SaveJobMatchingStatus(int projectVersionId, int marketPricingStatusKey, List<JobMatchingStatusUpdateDto> jobMatchingStatusUpdate)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var status = await _jobMatchingService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _jobMatchingService.SaveJobMatchingStatus(projectVersionId, marketPricingStatusKey, jobMatchingStatusUpdate, userObjectId);
            return Ok();
        }

        [HttpPost, Route("{projectVersionId}/standard-jobs")]
        public async Task<IActionResult> GetMarketPricingJobInfo(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var results = await _jobMatchingService.GetMarketPricingJobInfo(projectVersionId, selectedJobs);
            return Ok(results);
        }

        [HttpPost, Route("{projectVersionId}/matching/client-jobs")]
        public async Task<IActionResult> SaveClientJobsMatching(int projectVersionId, [FromBody] JobMatchingSaveData jobMatchingData)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var status = await _jobMatchingService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _jobMatchingService.SaveClientJobsMatching(projectVersionId, jobMatchingData, userObjectId);

            return Ok();
        }

        [HttpPost, Route("{projectVersionId}/matching/bulk-edit")]
        public async Task<IActionResult> SaveBulkClientJobsMatching(int projectVersionId, [FromBody] List<JobMatchingSaveBulkDataDto> jobMatchingData)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var status = await _jobMatchingService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            var jobCodes = jobMatchingData.Select(x => x.StandardJobCode).ToList();
            var surveyData = await _jobMatchingService.ListSurveyCutsDataJobs(jobCodes);

            jobCodes = jobCodes.Where(x => !surveyData.Any(y => y.StandardJobCode == x)).ToList();
            if (jobCodes != null && jobCodes.Any())
                return BadRequest($"The following job codes are invalid: {string.Join(", ", jobCodes)}.");

            await _jobMatchingService.SaveBulkClientJobsMatching(projectVersionId, jobMatchingData, surveyData, userObjectId);

            return Ok();
        }

        [HttpPost, Route("{projectVersionId}/audit-calculations")]
        public async Task<IActionResult> GetAuditCalculations(int projectVersionId, [FromBody] AuditCalculationRequestDto request)
        {
            if (projectVersionId == 0 || !request.ClientJobCodes.Any() || !request.StandardJobCodes.Any())
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            var auditCauculations = await _jobMatchingService.GetAuditCalculations(projectVersionId, request);

            return Ok(auditCauculations);
        }

        [HttpPost, Route("{projectVersionId}/matching/check-edition")]
        public async Task<IActionResult> CheckEditionForSelectedJobs(int projectVersionId, [FromBody] JobMatchingSaveData jobMatchingData)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            var valid = await _jobMatchingService.CheckEditionForSelectedJobs(projectVersionId, jobMatchingData.SelectedJobs);

            return Ok(new { valid });
        }

        private string? GetUserObjectId(ClaimsPrincipal user)
        {

            var identity = user?.Identity as ClaimsIdentity;

            if (identity != null && identity.Claims.Any())
                return identity.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == ClaimTypes.Name)?.Value;

            return null;
        }
    }
}
