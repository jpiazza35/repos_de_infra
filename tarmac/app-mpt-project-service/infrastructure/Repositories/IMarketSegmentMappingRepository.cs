using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.Infrastructure.Repositories;

public interface IMarketSegmentMappingRepository
{
    public Task<List<JobDto>> GetSourceData(int fileLogKey, int aggregationMethodologyKey);
    public Task<List<JobEmployeeDto>> GetSourceDataEmployeeLevel(int fileLogKey);
    public Task<List<MarketPricingSheet>> GetMarketPricingSheet(int projectVersionId, int aggregationMethodKey);
    public Task SaveMarketSegmentMapping(int projectVersionId, MarketSegmentMappingDto marketSegmentMapping, string? userObjectId);
    public Task<List<JobDto>> ListClientPositionDetail(int fileLogKey, int aggregationMethodKey, string jobCode, string positionCode, int fileOrgKey);
}
