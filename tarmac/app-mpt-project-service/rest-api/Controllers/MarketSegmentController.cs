using CN.Project.Domain.Constants;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CN.Project.RestApi.Controllers
{
    [Authorize]
    [Route("api/projects/market-segments")]
    [ApiController]
    public class MarketSegmentController : ControllerBase
    {
        private readonly IMarketSegmentService _marketSegmentService;

        public MarketSegmentController(IMarketSegmentService marketSegmentService)
        {
            _marketSegmentService = marketSegmentService;
        }

        [HttpPost]
        public async Task<IActionResult> SaveMarketSegment(MarketSegmentDto marketSegment)
        {
            var userObjectId = GetUserObjectId(User);

            if (marketSegment.Id != 0)
                return Ok(await _marketSegmentService.SaveAsMarketSegment(marketSegment, userObjectId));
            else
                return Ok(await _marketSegmentService.SaveMarketSegment(marketSegment, userObjectId));
        }

        [HttpPut]
        public async Task<IActionResult> EditMarketSegment(MarketSegmentDto marketSegment)
        {
            if (marketSegment.Id == 0)
                return NotFound();

            var userObjectId = GetUserObjectId(User);
            var newMarketSegment = await _marketSegmentService.EditMarketSegment(marketSegment, userObjectId);

            if (newMarketSegment is null || newMarketSegment.Id == 0)
                return BadRequest();

            return Ok(newMarketSegment);
        }

        [HttpPost, Route("{marketSegmentId}/eri")]
        public async Task<IActionResult> SaveMarketSegmentEri(int marketSegmentId, [FromBody] MarketSegmentDto marketSegment)
        {
            if (marketSegment.Id == 0 || marketSegment.Id != marketSegmentId)
                return NotFound();

            var EriNameOnUse = await _marketSegmentService.CheckCurrentEriNameOnUSe(marketSegmentId);
            if (EriNameOnUse != null && EriNameOnUse.Amount > 0 && EriNameOnUse.Name != marketSegment.EriCutName)
                return BadRequest("Can't be updated the 'Eri Cut Name' because is already in use on a 'Combined Averages'.");

            var userObjectId = GetUserObjectId(User);
            var marketSegmentEri = await _marketSegmentService.SaveMarketSegmentEri(marketSegment, userObjectId);

            return Ok(marketSegmentEri);
        }

        [HttpPost, Route("{marketSegmentId}/blends")]
        public async Task<IActionResult> SaveMarketSegmentBlend(int marketSegmentId, [FromBody] MarketSegmentBlendDto blend)
        {
            if (marketSegmentId == 0
                || blend is null
                || (blend.Cuts is not null && blend.Cuts.Any(c => !string.IsNullOrEmpty(c.CutGroupName) && c.CutGroupName.Equals(Constants.NATIONAL_GROUP_NAME))))
                return BadRequest();

            var userObjectId = GetUserObjectId(User);

            var existingBlends = await _marketSegmentService.SaveMarketSegmentBlend(marketSegmentId, blend, userObjectId);

            return Ok(existingBlends);
        }

        [HttpPut, Route("{marketSegmentId}/cut-details")]
        public async Task<IActionResult> EditMarketSegmentCutDetails(int marketSegmentId, [FromBody] IEnumerable<MarketSegmentCutDetailDto> cutDetails)
        {
            if (marketSegmentId == 0 || cutDetails is null)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            var newMarketSegment = await _marketSegmentService.EditMarketSegmentCutDetails(marketSegmentId, cutDetails, userObjectId);

            return Ok(newMarketSegment);
        }

        [HttpGet, Route("{marketSegmentId}/cut-names")]
        public async Task<IActionResult> GetCombinedAveragesCutNames(int marketSegmentId)
        {
            if (marketSegmentId <= 0)
                return BadRequest();

            var cutNames = await _marketSegmentService.GetCombinedAveragesCutNames(marketSegmentId);

            return Ok(cutNames);
        }

        [HttpDelete, Route("{marketSegmentId}")]
        public async Task<IActionResult> DeleteMarketSegment(int marketSegmentId)
        {
            if (marketSegmentId == 0)
                return NotFound();

            var userObjectId = GetUserObjectId(User);
            if (userObjectId is null)
                return BadRequest("User authentication error.");

            var result = await _marketSegmentService.DeleteMarketSegment(marketSegmentId, userObjectId);

            if (!result.IsSuccess)
                return BadRequest(result.ErrorMessages);

            return Ok();
        }

        #region Combined Averages
        [HttpGet, Route("{marketSegmentId}/combined-averages")]
        public async Task<IActionResult> GetCombinedAverages(int marketSegmentId)
        {
            if (marketSegmentId <= 0)
                return BadRequest();

            var combinedAverages = await _marketSegmentService.GetCombinedAverages(marketSegmentId);

            return Ok(combinedAverages);
        }

        [HttpPost, Route("{marketSegmentId}/combined-averages")]
        public async Task<IActionResult> InsertCombinedAverage(int marketSegmentId, [FromBody] CombinedAveragesDto combinedAverage)
        {
            if (marketSegmentId <= 0 || marketSegmentId != combinedAverage.MarketSegmentId)
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            await _marketSegmentService.InsertCombinedAverage(combinedAverage, userObjectId);

            return Ok();
        }

        [HttpPut, Route("{marketSegmentId}/combined-averages")]
        public async Task<IActionResult> InsertAndUpdateAndRemoveCombinedAverages(int marketSegmentId, [FromBody] List<CombinedAveragesDto> combinedAverages)
        {
            if (marketSegmentId <= 0
                || combinedAverages.Exists(com =>
                    com.MarketSegmentId != marketSegmentId
                    || com.Cuts.Exists(cut => cut.CombinedAveragesId != com.Id)))
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            await _marketSegmentService.InsertAndUpdateAndRemoveCombinedAverages(marketSegmentId, combinedAverages, userObjectId);

            return Ok();
        }

        [HttpPut, Route("{marketSegmentId}/combined-averages/{combinedAverageId}")]
        public async Task<IActionResult> UpdateCombinedAverages(int marketSegmentId, int combinedAverageId, [FromBody] CombinedAveragesDto combinedAverage)
        {
            if (marketSegmentId <= 0 || combinedAverageId <= 0)
                return BadRequest();


            if (marketSegmentId != combinedAverage.MarketSegmentId
                || combinedAverageId != combinedAverage.Id
                || combinedAverage.Cuts.Exists(c => c.CombinedAveragesId != combinedAverage.Id))
                return BadRequest();

            var userObjectId = GetUserObjectId(User);
            await _marketSegmentService.UpdateCombinedAverages(combinedAverage, userObjectId);

            return Ok();
        }
        #endregion

        private string? GetUserObjectId(ClaimsPrincipal user)
        {
            try
            {
                var identity = user?.Identity as ClaimsIdentity;

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
}
