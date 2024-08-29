using CN.Survey.Domain.Request;
using CN.Survey.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.RestApi.Controllers
{
    [Authorize]
    [Route("api/survey")]
    [ApiController]
    public class SurveyController : ControllerBase
    {
        private readonly ISurveyCutsService _surveyCutsService;

        public SurveyController(ISurveyCutsService surveyCutsService)
        {
            _surveyCutsService = surveyCutsService;
        }

        [HttpPost("cut-filter-options")]
        public async Task<IActionResult> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request) {
            var surveyCutFilterOptions = await _surveyCutsService.ListSurveyCutFilterOptions(request);
            return Ok(surveyCutFilterOptions);
        }

        [HttpPost("cuts-data/standard-jobs")]
        public async Task<IActionResult> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request)
        {
            var surveyCutsData = await _surveyCutsService.ListSurveyCutsDataStandardJobs(request);
            return Ok(surveyCutsData?.StandardJobs);
        }

        [HttpPost("cuts-data/publishers")]
        public async Task<IActionResult> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request)
        {
            var surveyCutsData = await _surveyCutsService.ListSurveyCutsDataPublishers(request);
            return Ok(surveyCutsData?.Publishers);
        }

        [HttpPost("cuts-data/survey-jobs")]
        public async Task<IActionResult> ListSurveyCutsDataJobs(SurveyCutsDataRequest request)
        {
            var surveyCutsData = await _surveyCutsService.ListSurveyCutsDataJobs(request);
            return Ok(surveyCutsData?.SurveyJobs);
        }
    }
}
