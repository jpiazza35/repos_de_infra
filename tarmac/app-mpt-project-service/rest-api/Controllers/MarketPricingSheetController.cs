using CN.Project.Domain.Enum;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CN.Project.RestApi.Controllers
{
    [Authorize]
    [Route("api/projects/market-pricing-sheet")]
    [ApiController]
    public class MarketPricingSheetController : ControllerBase
    {
        private readonly IMarketPricingSheetService _marketPricingSheetService;

        public MarketPricingSheetController(IMarketPricingSheetService marketPricingSheetService)
        {
            _marketPricingSheetService = marketPricingSheetService;
        }

        [HttpPost, Route("{projectVersionId}/status")]
        public async Task<IActionResult> GetStatus(int projectVersionId, [FromBody] MarketPricingSheetFilterDto filter)
        {
            return Ok(await _marketPricingSheetService.GetStatus(projectVersionId, filter));
        }

        [HttpGet, Route("{projectVersionId}/market-segments-names")]
        public async Task<IActionResult> GetMarketSegmentsNames(int projectVersionId)
        {
            return Ok(await _marketPricingSheetService.GetMarketSegmentsNames(projectVersionId));
        }

        [HttpGet, Route("{projectVersionId}/job-groups")]
        public async Task<IActionResult> GetJobGroups(int projectVersionId)
        {
            return Ok(await _marketPricingSheetService.GetJobGroups(projectVersionId));
        }

        [HttpPost, Route("{projectVersionId}/job-titles")]
        public async Task<IActionResult> GetJobTitles(int projectVersionId, [FromBody] MarketPricingSheetFilterDto filter)
        {
            return Ok(await _marketPricingSheetService.GetJobTitles(projectVersionId, filter));
        }

        [HttpGet, Route("{projectVersionId}/sheet-info/{marketPricingSheetId}")]
        public async Task<IActionResult> GetSheetInfo(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetSheetInfo(projectVersionId, marketPricingSheetId));
        }

        [HttpGet, Route("{projectVersionId}/position-detail/{marketPricingSheetId}")]
        public async Task<IActionResult> GetClientPositionDetail(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetClientPositionDetail(projectVersionId, marketPricingSheetId));
        }

        [HttpPut, Route("{projectVersionId}/{marketPricingSheetId}/status/{marketPricingStatusKey}")]
        public async Task<IActionResult> UpdateJobMatchStatus(int projectVersionId, int marketPricingSheetId, int marketPricingStatusKey)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var status = await _marketPricingSheetService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            if (marketPricingStatusKey != (int)MarketPricingStatus.AnalystReviewed && marketPricingStatusKey != (int)MarketPricingStatus.PeerReviewed && marketPricingStatusKey != (int)MarketPricingStatus.Complete)
                return BadRequest("Invalid market pricing status.");

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _marketPricingSheetService.UpdateMarketPricingStatus(projectVersionId, marketPricingSheetId, marketPricingStatusKey, userObjectId);
            return Ok();
        }

        [HttpGet, Route("{projectVersionId}/job-match-detail/{marketPricingSheetId}")]
        public async Task<IActionResult> GetJobMatchDetail(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetJobMatchDetail(projectVersionId, marketPricingSheetId));
        }

        [HttpPut, Route("{projectVersionId}/job-match-detail/{marketPricingSheetId}")]
        public async Task<IActionResult> SaveJobMatchDetail(int projectVersionId, int marketPricingSheetId, [FromBody] NewStringValueDto jobMatchNote)
        {
            if (projectVersionId == 0 || marketPricingSheetId == 0)
                return BadRequest();

            var status = await _marketPricingSheetService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _marketPricingSheetService.SaveJobMatchDetail(projectVersionId, marketPricingSheetId, jobMatchNote.Value, userObjectId);
            return Ok();
        }

        [HttpGet, Route("{projectVersionId}/client-pay-detail/{marketPricingSheetId}")]
        public async Task<IActionResult> GetClientPayDetail(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetClientPayDetail(projectVersionId, marketPricingSheetId));
        }

        [HttpGet, Route("adjustment-notes")]
        public async Task<IActionResult> GetAdjusmentNoteList()
        {
            return Ok(await _marketPricingSheetService.GetAdjusmentNoteList());
        }

        [HttpGet, Route("{projectVersionId}/grid/{marketPricingSheetId}")]
        public async Task<IActionResult> GetGridItemsForMarketPricingSheet(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetGridItems(projectVersionId, marketPricingSheetId));
        }

        [HttpGet, Route("{projectVersionId}/grid")]
        public async Task<IActionResult> GetGridItems(int projectVersionId)
        {
            return Ok(await _marketPricingSheetService.GetGridItems(projectVersionId));
        }

        [HttpPut, Route("{projectVersionId}/notes/{marketPricingSheetId}")]
        public async Task<IActionResult> SaveNotes(int projectVersionId, int marketPricingSheetId, [FromBody] NewStringValueDto notes)
        {
            if (projectVersionId == 0 || marketPricingSheetId == 0)
                return BadRequest();

            var status = await _marketPricingSheetService.GetProjectVersionStatus(projectVersionId);
            if (status == (int)ProjectVersionStatus.Final || status == (int)ProjectVersionStatus.Deleted)
            {
                return BadRequest("Project status prevents fields from being edited.");
            }

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _marketPricingSheetService.SaveNotes(projectVersionId, marketPricingSheetId, notes, userObjectId);

            return Ok();
        }

        [HttpGet, Route("{projectVersionId}/notes/{marketPricingSheetId}")]
        public async Task<IActionResult> GetNotes(int projectVersionId, int marketPricingSheetId)
        {
            return Ok(await _marketPricingSheetService.GetNotes(projectVersionId, marketPricingSheetId));
        }

        [HttpGet, Route("{projectVersionId}/benchmark-data-types")]
        public async Task<IActionResult> GetBenchmarkDataTypes(int projectVersionId)
        {
            return Ok(await _marketPricingSheetService.GetBenchmarkDataTypes(projectVersionId));
        }

        [HttpGet, Route("{projectVersionId}/market-segment/report-filters")]
        public async Task<IActionResult> GetMarketSegmentReportFilter(int projectVersionId)
        {
            return Ok(await _marketPricingSheetService.GetMarketSegmentReportFilter(projectVersionId));
        }

        [HttpPost, Route("{projectVersionId}/global-settings")]
        public async Task<IActionResult> SaveMainSettings(int projectVersionId, MainSettingsDto mainSettings)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _marketPricingSheetService.SaveMainSettings(projectVersionId, mainSettings, userObjectId);
            return Ok();
        }

        [HttpGet, Route("{projectVersionId}/global-settings")]
        public async Task<IActionResult> GetMainSettings(int projectVersionId)
        {
            var globalSettings = await _marketPricingSheetService.GetMainSettings(projectVersionId);
            return Ok(globalSettings);
        }

        [HttpPost, Route("{projectVersionId}/external-data")]
        public async Task<IActionResult> SaveMarketPricingExternalData(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternalRows)
        {
            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            if (projectVersionId == 0)
                return BadRequest();

            var errors = await ListErrorsForCutExternalRowsInput(projectVersionId, cutExternalRows);
            if (errors.Any())
                return BadRequest(errors);

            var duplicates = GetDuplicatesCutExternalRows(cutExternalRows);
            if (duplicates.Any())
                return BadRequest(duplicates);

            await _marketPricingSheetService.SaveMarketPricingExternalData(projectVersionId, cutExternalRows, userObjectId);
            return Ok();
        }

        [HttpPost, Route("{projectVersionId}/grid/{marketPricingSheetId}")]
        public async Task<IActionResult> SaveGridItemsForMarketPricingSheet(int projectVersionId, int marketPricingSheetId, [FromBody] SaveGridItemDto item)
        {
            if (projectVersionId == 0 || marketPricingSheetId == 0 || item.MarketPricingSheetId != marketPricingSheetId)
                return BadRequest();
            if(
                (item.MarketSegmentCutDetailKey is null || item.MarketSegmentCutDetailKey == 0)
                &&
                (item.CutExternalKey is null || item.CutExternalKey == 0)
            )
                return BadRequest();


            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            await _marketPricingSheetService.SaveGridItemsForMarketPricingSheet(item, userObjectId);

            return Ok();
        }

        [HttpGet, Route("{projectVersionId}/export-pdf")]
        public async Task<IActionResult> ExportPdf(int projectVersionId, int? marketPricingSheetId)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            var result = await _marketPricingSheetService.ExportPdf(projectVersionId, marketPricingSheetId, new List<int>(), userObjectId);

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result);
        }

        [HttpPost, Route("{projectVersionId}/export-pdf")]
        public async Task<IActionResult> ExportPdfSorted(int projectVersionId, int? marketPricingSheetId, [FromBody] List<int> sortByList)
        {
            if (projectVersionId == 0)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId == null)
                return BadRequest("User authentication error.");

            var result = await _marketPricingSheetService.ExportPdf(projectVersionId, marketPricingSheetId, sortByList, userObjectId);

            if (!result.Success)
                return BadRequest(result.Message);

            return Ok(result);
        }

        [HttpGet, Route("sorting-fields")]
        public IActionResult GetSortingFields()
        {
            var result = _marketPricingSheetService.GetSortingFields();

            return Ok(result);
        }

        private string? GetUserObjectId(ClaimsPrincipal user)
        {

            var identity = user?.Identity as ClaimsIdentity;

            if (identity != null && identity.Claims.Any())
                return identity.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == ClaimTypes.Name)?.Value;

            return null;
        }

        private async Task<List<string>> ListErrorsForCutExternalRowsInput(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternalRows)
        {
            var projectDetails = await _marketPricingSheetService.GetProjectVersionDetails(projectVersionId);

            if (projectDetails is null || !projectDetails.AggregationMethodologyKey.HasValue)
                return new List<string> { $"Unable to find project details for version id {projectVersionId}" };

            var errors = new List<string>();

            if (projectDetails.AggregationMethodologyKey == AggregationMethodology.Parent)
            {
                for (int index = 0; index < cutExternalRows.Count; index++)
                {
                    var row = cutExternalRows[index];

                    if (row.OrganizationId.HasValue && row.OrganizationId != projectDetails.OrganizationKey)
                        errors.Add($"Organization ID {row.OrganizationId} is different from the Organization ID {projectDetails.OrganizationKey} registered for the Project, row index number {index}");

                    if (row.OrganizationId.HasValue && row.OrganizationId != row.ProjectOrganizationId)
                        errors.Add($"Organization ID {row.OrganizationId} is different from the Project Organization ID {row.ProjectOrganizationId}, row index number {index}");
                }
            }

            return errors;
        }

        private List<MarketPricingSheetCutExternalDto> GetDuplicatesCutExternalRows(List<MarketPricingSheetCutExternalDto> cutExternalRows)
        {
            return cutExternalRows
                .Select((item, index) => new { Value = item, Index = index })
                .GroupBy(x => x.Value)
                .Where(group => group.Count() > 1)
                .Select(x => new MarketPricingSheetCutExternalDto
                {
                    ProjectOrganizationId = x.Key.ProjectOrganizationId,
                    OrganizationId = x.Key.OrganizationId,
                    StandardJobCode = x.Key.StandardJobCode,
                    StandardJobTitle = x.Key.StandardJobTitle,
                    ExternalPublisherName = x.Key.ExternalPublisherName,
                    ExternalSurveyName = x.Key.ExternalSurveyName,
                    ExternalSurveyYear = x.Key.ExternalSurveyYear,
                    ExternalSurveyJobCode = x.Key.ExternalSurveyJobCode,
                    ExternalSurveyJobTitle = x.Key.ExternalSurveyJobTitle,
                    ExternalIndustrySectorName = x.Key.ExternalIndustrySectorName,
                    ExternalOrganizationTypeName = x.Key.ExternalOrganizationTypeName,
                    ExternalCutGroupName = x.Key.ExternalCutGroupName,
                    ExternalCutSubGroupName = x.Key.ExternalCutSubGroupName,
                    ExternalMarketPricingCutName = x.Key.ExternalMarketPricingCutName,
                    ExternalSurveyCutName = x.Key.ExternalSurveyCutName,
                    ExternalSurveyEffectiveDate = x.Key.ExternalSurveyEffectiveDate,
                    IncumbentCount = x.Key.IncumbentCount,
                    DuplicateIndexes = x.Select(z => z.Index).ToList()
                })
                .ToList();
        }
    }
}