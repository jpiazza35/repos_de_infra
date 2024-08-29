using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Infrastructure.Repository
{
    public interface IMarketSegmentRepository
    {
        public Task<MarketSegmentDto?> GetMarketSegment(int marketSegmentId);
        public Task<IEnumerable<MarketSegmentCutDto>> GetMarketSegmentCut(int marketSegmentId);
        public Task<IEnumerable<MarketSegmentCutDetailDto>> GetMarketSegmentCutDetail(List<int> marketSegmentCutKeys);
        public Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId);
        public Task<List<MarketSegmentDto>> GetMarketSegmentsWithCuts(int projectVersionId, int? marketSegmentId = null);
        public Task<int> SaveMarketSegment(MarketSegmentDto marketSegment, string user);
        public Task<SurveyCutDto> GetSurveyCut(SurveyCutRequestDto surveyCutRequestDto);
        public Task EditMarketSegment(MarketSegmentDto existingMarketSegment, MarketSegmentDto newMarketSegment, string user);
        public Task<NameAmount?> CheckCurrentEriNameOnUSe(int marketSegmentId);
        public Task EditMarketSegmentEri(MarketSegmentDto marketSegment, string user);
        public Task SaveMarketSegmentBlend(int marketSegmentId, MarketSegmentBlendDto blend, string user);
        public Task EditMarketSegmentBlend(MarketSegmentBlendDto blend, string user, IEnumerable<MarketSegmentBlendCutDto> existingChildren);
        public Task<IEnumerable<MarketSegmentBlendCutDto>> GetMarketSegmentBlendChildren(IEnumerable<int> blendIdList);
        public Task EditMarketSegmentCutDetails(IEnumerable<MarketSegmentCutDetailDto> existingCutDetails, IEnumerable<MarketSegmentCutDetailDto> newCutDetails, string user);
        public Task<List<MarketSegmentCutDto>> ListMarketSegmentCuts(IEnumerable<int> marketSegmentIds);
        public Task<IEnumerable<MarketSegmentCutSurveyDetailDto>> ListMarketSegmentCutDetailsByMarketSegmentId(int marketSegmentId);
        public Task<IEnumerable<string>> ListJobCodesMapped(int marketSegmentId);
        public Task DeleteMarketSegment(int marketSegmentId, string? userObjectId);
    }
}