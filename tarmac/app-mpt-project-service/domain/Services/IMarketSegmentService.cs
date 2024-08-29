using CN.Project.Domain.Dto;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketSegment;

namespace CN.Project.Domain.Services
{
    public interface IMarketSegmentService
    {
        public Task<MarketSegmentDto> SaveMarketSegment(MarketSegmentDto marketSegment, string? userObjectId);
        public Task<MarketSegmentDto> SaveAsMarketSegment(MarketSegmentDto marketSegment, string? userObjectId);
        public Task<MarketSegmentDto?> EditMarketSegment(MarketSegmentDto marketSegment, string? userObjectId);
        public Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId);
        public Task<NameAmount?> CheckCurrentEriNameOnUSe(int marketSegmentId);
        public Task<MarketSegmentDto> SaveMarketSegmentEri(MarketSegmentDto marketSegment, string? userObjectId);
        public Task<IEnumerable<MarketSegmentBlendDto>?> SaveMarketSegmentBlend(int marketSegmentId, MarketSegmentBlendDto blend, string? userObjectId);
        public Task<MarketSegmentDto?> EditMarketSegmentCutDetails(int marketSegmentId, IEnumerable<MarketSegmentCutDetailDto> cutDetails, string? userObjectId);
        public Task<List<CombinedAveragesDto>> GetCombinedAverages(int marketSegmentId);
        public Task<List<string>> GetCombinedAveragesCutNames(int marketSegmentId);
        public Task InsertCombinedAverage(CombinedAveragesDto combinedAverages, string? userObjectId);

        /// <summary>
        /// This method updates the combined averages and removes from a market segment all combined averages that are not sent as a parameter.
        /// </summary>
        /// <param name="marketSegmentId">id of the market segment.</param>
        /// <param name="combinedAveragesDto">List of combined averages with the data that will use to update.</param>
        /// <returns></returns>
        public Task InsertAndUpdateAndRemoveCombinedAverages(int marketSegmentId, List<CombinedAveragesDto> combinedAveragesDto, string? userObjectId);
        public Task UpdateCombinedAverages(CombinedAveragesDto combinedAveragesDto, string? userObjectId);
        public Task<ResponseDto> DeleteMarketSegment(int marketSegmentId, string? userObjectId);
    }
}
