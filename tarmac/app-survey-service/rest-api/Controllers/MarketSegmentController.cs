using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.RestApi.Controllers
{
    [Authorize]
    [Route("api/survey")]
    [ApiController]
    public class MarketSegmentController : ControllerBase
    {
        private readonly ISurveyCutsRepository _surveyCutsRepository;
        private readonly IMarketSegmentService _marketSegmentService;
        private readonly ISurveyCutsService _surveyCutsService;

        public MarketSegmentController(IMarketSegmentService marketSegmentService, ISurveyCutsRepository surveyCutsRepository, ISurveyCutsService surveyCutsService)
        {
            _marketSegmentService = marketSegmentService;
            _surveyCutsRepository = surveyCutsRepository;
            _surveyCutsService = surveyCutsService;
        }

        [HttpPost("market-segment-filters")]
        public async Task<IActionResult> ListSurveyCutFilterFlatOptions(SurveyCutFilterFlatOptionsRequest request)
        {
            var filterOptions = await _surveyCutsRepository.ListSurveyCutFilterFlatOptions(request);
            return Ok(filterOptions);
        }

        [HttpPost("market-segment-survey-details")]
        public async Task<IActionResult> GetMarketSegmentSurveyDetails(SurveyCutsRequest request)
        {
            var surveyCuts = await _surveyCutsService.ListSurveyCuts(request);
            return Ok(surveyCuts.SurveyCutsData);
        }

        [HttpPost("market-segment-cuts")]
        public async Task<IActionResult> GetMarketSegmentSelectedCuts(SurveyCutsRequest request)
        {
            var marketSegmentCuts = await _marketSegmentService.GetMarketSegmentSelectedCuts(request);
            return Ok(marketSegmentCuts);
        }
    }
}
