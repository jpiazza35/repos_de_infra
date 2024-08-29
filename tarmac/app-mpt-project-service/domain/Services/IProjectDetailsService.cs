using CN.Project.Domain.Dto;

namespace CN.Project.Domain.Services;

public interface IProjectDetailsService
{
    public Task<ProjectDetailsViewDto> GetProjetDetails(int projectId, int projectVersionId);
    public Task<ProjectDetailsDto> SaveProjetDetails(ProjectDetailsDto projecDetails, string? userObjectId);
    public Task InsertMarketPricingSheetRows(int fileLogKey, string? userObjectId);
}
