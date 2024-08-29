using CN.Project.Domain.Dto;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.Infrastructure.Repository;

public interface  IProjectDetailsRepository
{
    public Task<ProjectDetailsViewDto> GetProjetDetails(int projectId, int projectVersionId);
    public Task<ProjectDetailsDto> SaveProjetDetails(ProjectDetailsDto projecDetails, string user, bool newProject = true);
    public Task UpdateProjetDetails(int projectId, int projectVersionId, ProjectDetailsDto projecDetails, string? userObjectId);
    public Task<ProjectVersionDto> GetProjectVersionDetails(int projectVersionId);
    public Task<List<int>> GetBenchmarkDataTypeKeys(int projectVersionId);
    public Task InsertMarketPricingSheetRows(int fileLogKey, List<ProjectVersionDto> projectVersions, List<MarketPricingSheetDto> marketPricingSheets, string? userObjectId);
    public Task<List<MarketPricingSheetDto>> ListClientJobs(int projectVersionId, int aggregationMethodologyKey);
    public Task<List<ClientPayDto>> ListClientPayDetail(int fileLogKey, int fileOrgKey, int aggregationMethodKey, string jobCode, string positionCode, IEnumerable<int> benchmarkDataTypeKeys);
    public Task<List<BenchmarkDataTypeInfoDto>> GetProjectBenchmarkDataTypes(int projectVersionId);
}
