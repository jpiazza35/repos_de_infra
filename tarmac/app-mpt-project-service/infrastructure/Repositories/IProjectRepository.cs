using CN.Project.Domain.Dto;

namespace CN.Project.Infrastructure.Repository;

public interface IProjectRepository
{
    public Task<List<ProjectDto>> GetProjectsByOrganizationId(int orgId);

    public Task<List<ProjectVersionDto>> GetProjectVersions(int projectId);

    public Task<List<SearchProjectDto>> SearchProject(int orgId,int projectId,int projectVersionId);

    public Task<List<OrganizationDto>> GetOrganizationsByIds(List<int> orgIds);

    public Task DeleteProjectVersion(int projectId, int projectVersionId, string? notes);

    public Task<int> GetProjectStatus(int projectId);

    public Task<int> GetProjectVersionStatus(int projectVersionId);
    
    public Task<List<ProjectVersionDto>> GetProjectVersionsByFileLogKey(int fileLogKey);
}
