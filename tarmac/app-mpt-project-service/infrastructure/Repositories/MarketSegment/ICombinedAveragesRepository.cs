using CN.Project.Domain.Models.Dto.MarketSegment;

namespace CN.Project.Infrastructure.Repositories.MarketSegment
{
    public interface ICombinedAveragesRepository
    {
        public Task<List<string>> GetCombinedAveragesCutNames(int marketSegmentId);
        public Task<List<CombinedAveragesDto>> GetCombinedAveragesByMarketSegmentId(int marketSegmentId);
        public Task<List<CombinedAveragesDto>> GetCombinedAveragesByProjectVersionId(int projectVersionId);
        public Task InsertCombinedAverage(CombinedAveragesDto combinedAverage, string? userObjectId);
        public Task InsertAndUpdateAndRemoveCombinedAverages(int marketSegmentId, List<CombinedAveragesDto> combinedAveragesDto, string? userObjectId);
        public Task UpdateCombinedAverages(CombinedAveragesDto combinedAverages, string? userObjectId);
        public Task UpdateCombinedAverageCutName(int marketSegmentId, string? oldName, string? newName, string? userObjectId);
    }
}
