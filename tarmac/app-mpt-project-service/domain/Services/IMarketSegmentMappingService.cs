using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Services;

public interface IMarketSegmentMappingService
{
    public Task<List<JobDto>?> GetJobs(int projectVersionId, string? filterInput, string? filterColumn);
    public Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId);
    public Task SaveMarketSegmentMapping(int projectVersionId, List<MarketSegmentMappingDto> marketSegmentMappings, string? userObjectId);
    public Task<int> GetProjectVersionStatus(int projectVersionId);
}
