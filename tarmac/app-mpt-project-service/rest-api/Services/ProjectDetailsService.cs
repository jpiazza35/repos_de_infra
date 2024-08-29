using CN.Project.Domain.Constants;
using CN.Project.Domain.Services;
using CN.Project.Domain.Dto;
using CN.Project.Infrastructure.Repository;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.RestApi.Services;

public class ProjectDetailsService : IProjectDetailsService
{
    private readonly ILogger<ProjectDetailsService> _logger;
    private readonly IProjectRepository _projectRepository;
    private readonly IProjectDetailsRepository _projectDetailsRepository;

    public ProjectDetailsService(IProjectRepository projectRepository, IProjectDetailsRepository projectDetailsRepository, ILogger<ProjectDetailsService> logger)
    {
        _projectRepository = projectRepository;
        _projectDetailsRepository = projectDetailsRepository;
        _logger = logger;
    }

    public async Task<ProjectDetailsViewDto> GetProjetDetails(int projectId, int projectVersionId)
    {
        try
        {
            var projectDetails = await _projectDetailsRepository.GetProjetDetails(projectId, projectVersionId);

            if (projectDetails.OrganizationID > 0)
            {
                var organizations = await _projectRepository.GetOrganizationsByIds(new List<int> { projectDetails.OrganizationID });
                projectDetails.OrganizationName = organizations.FirstOrDefault()?.Name + "-" + projectDetails.OrganizationID;
            }

            return projectDetails;
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<ProjectDetailsDto> SaveProjetDetails(ProjectDetailsDto projecDetails, string? userObjectId)
    {
        try
        {
            var user = string.IsNullOrEmpty(userObjectId) ? Constants.SYSTEM_USER : userObjectId;
            var newProject = true;

            if (projecDetails.ID > 0 && projecDetails.Version > 0)
            {
                var currentProject = await _projectDetailsRepository.GetProjetDetails(projecDetails.ID, projecDetails.Version); 

                newProject = currentProject != null 
                    && (
                        currentProject.OrganizationID != projecDetails.OrganizationID
                        || currentProject.Name != projecDetails.Name
                        || currentProject.WorkforceProjectType != projecDetails.WorkforceProjectType
                    );

                if (currentProject != null && currentProject.ID > 0) 
                    projecDetails.BenchmarkDataTypes = currentProject.BenchmarkDataTypes;
            }

            var project = await _projectDetailsRepository.SaveProjetDetails(projecDetails, user, newProject);

            return project;
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task InsertMarketPricingSheetRows(int fileLogKey, string? userObjectId)
    {
        List<MarketPricingSheetDto> clientJobs = new List<MarketPricingSheetDto>();

        var projectVersions = await _projectRepository.GetProjectVersionsByFileLogKey(fileLogKey);

        foreach (var methodologyKey in projectVersions.GroupBy(pro => pro.AggregationMethodologyKey).Select(x => x.Key))
        {
            if (methodologyKey != null) clientJobs.AddRange(await _projectDetailsRepository.ListClientJobs(fileLogKey, (int)methodologyKey));
        }
        
        await _projectDetailsRepository.InsertMarketPricingSheetRows(fileLogKey, projectVersions, clientJobs, userObjectId);
    }
}