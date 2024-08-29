using CN.Project.Domain.Enum;
using CN.Project.Domain;
using CN.Project.Domain.Dto;
using Cn.Organization;
using AutoMapper;
using Dapper;
using Microsoft.Extensions.Logging;
using Organization = Cn.Organization.Organization;
using System.Text;
using Cn.Incumbent;

namespace CN.Project.Infrastructure.Repository;

public class ProjectRepository : IProjectRepository
{
    protected IMapper _mapper;

    private readonly IDBContext _projectDBContext;
    private readonly ILogger<ProjectRepository> _logger;
    private readonly Organization.OrganizationClient _organizationClient;
    private readonly Incumbent.IncumbentClient _incumbentClient;

    public ProjectRepository(IDBContext projectDBContext,
                             IMapper mapper,
                             ILogger<ProjectRepository> logger,
                             Organization.OrganizationClient organizationClient,
                             Incumbent.IncumbentClient incumbentClient)
    {
        _projectDBContext = projectDBContext;
        _mapper = mapper;
        _logger = logger;
        _organizationClient = organizationClient;
        _incumbentClient = incumbentClient;
    }

    public async Task<List<ProjectDto>> GetProjectsByOrganizationId(int orgId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Projects by organization id: {orgId} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var projectStatus = ProjectVersionStatus.Deleted;
                var sql = @"SELECT project_id, org_key, TRIM(project_name) AS project_name
	                          FROM project_list
	                         WHERE org_key = @orgId
                               AND project_status_key != @projectStatus";

                var orgs = await connection.QueryAsync<Project_List>(sql, new { orgId, projectStatus });
                return _mapper.Map<List<ProjectDto>>(orgs);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<SearchProjectDto>> SearchProject(int orgId, int projectId, int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Projects by organization id: {orgId}, project id: {projectId}, projectVersionId: {projectVersionId} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var projectStatus = (int)ProjectVersionStatus.Deleted;
                var sql = $@"	
	                    SELECT p.project_id,
                               org_key, 
                               TRIM(project_name) AS project_name, 
                               survey_source_group_key, 
                               TRIM(s.status_name) AS status_name,
                               pv.project_version_id,
                               pv.project_version_label,
                               pv.project_version_datetime,
                               pv.aggregation_methodology_key,
                               pv.file_log_key
                        FROM project_list p
                        LEFT JOIN project_version pv ON pv.project_id = p.project_id
                        LEFT JOIN status_list s ON pv.project_version_status_key = s.status_key
                        WHERE p.project_status_key != {projectStatus} AND pv.project_version_status_key != {projectStatus}";

                StringBuilder sqlWhereQuery = new StringBuilder();

                if (orgId > 0)
                {
                    sqlWhereQuery.AppendLine(@" org_key =" + orgId);
                }

                if (projectId > 0)
                {
                    if (!string.IsNullOrEmpty(sqlWhereQuery.ToString()))
                        sqlWhereQuery.AppendLine(@" AND p.project_id =" + projectId);
                    else
                        sqlWhereQuery.AppendLine(@" p.project_id =" + projectId);
                }

                if (projectVersionId > 0)
                {
                    if (!string.IsNullOrEmpty(sqlWhereQuery.ToString()))
                        sqlWhereQuery.AppendLine(@" AND pv.project_version_id =" + projectVersionId);
                    else
                        sqlWhereQuery.AppendLine(@" pv.project_version_id =" + projectVersionId);
                }

                if (!string.IsNullOrEmpty(sqlWhereQuery.ToString()))
                {

                    sql += " AND " + sqlWhereQuery.ToString();
                }

                var orgs = await connection.QueryAsync<Project_List>(sql);
                return _mapper.Map<List<SearchProjectDto>>(orgs);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<ProjectVersionDto>> GetProjectVersions(int projectId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Project versions by project id: {projectId} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var projectStatus = (int)ProjectVersionStatus.Deleted;
                var sql = @"SELECT project_version_id, 
                                   project_version_label, 
                                   aggregation_methodology_key
	                          FROM project_version
	                         WHERE project_id = @projectId AND project_version_status_key != @projectStatus";

                var projectVersions = await connection.QueryAsync<Project_Version>(sql, new { projectId, projectStatus });

                return _mapper.Map<List<ProjectVersionDto>>(projectVersions);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<ProjectVersionDto>> GetProjectVersionsByFileLogKey(int fileLogKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Project versions by file log key: {fileLogKey} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var projectStatus = (int)ProjectVersionStatus.Deleted;
                var sql = @"SELECT project_version_id, 
                                   project_version_label, 
                                   aggregation_methodology_key
	                          FROM project_version
	                         WHERE file_log_key = @fileLogKey 
                             AND project_version_status_key != @projectStatus";

                var projectVersions = await connection.QueryAsync<Project_Version>(sql, new { fileLogKey, projectStatus });

                return _mapper.Map<List<ProjectVersionDto>>(projectVersions);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<OrganizationDto>> GetOrganizationsByIds(List<int> orgIds)
    {
        try
        {
            _logger.LogInformation($"\nCalling Organization gRPC service to organizations by ids: {string.Join(", ", orgIds)}\n");

            var request = new OrganizationSearchRequest();
            request.OrganizationIds.AddRange(orgIds);
            var organizationResponse = await _organizationClient.ListOrganizationByIdsOrTermAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<OrganizationDto>>(organizationResponse.Organizations?.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task DeleteProjectVersion(int projectId, int projectVersionId, string? notes)
    {
        try
        {
            _logger.LogInformation($"\nDelete Project version id: {projectVersionId}\n");

            var projectVersionList = await GetProjectVersions(projectId);
            var projectStatus = ProjectVersionStatus.Deleted;
            var modifiedUtcDatetime = DateTime.UtcNow;

            if (projectVersionList.Count > 1)
            {
                using (var connection = _projectDBContext.GetConnection())
                {
                    var sql = @"UPDATE project_version SET project_version_status_key = @projectStatus, modified_utc_datetime = @modifiedUtcDatetime, project_version_status_notes = @notes 
                                     WHERE project_id = @projectId AND project_version_id = @projectVersionId";

                    await connection.QueryAsync(sql, new { projectStatus, modifiedUtcDatetime, notes, projectId, projectVersionId });
                }
            }
            else
            {
                using (var connection = _projectDBContext.GetConnection())
                {
                    var sql = @"UPDATE project_list SET project_status_key = @projectStatus, project_status_modified_utc_datetime = @modifiedUtcDatetime 
                                     WHERE project_id = @projectId;

                                UPDATE project_version SET project_version_status_key = @projectStatus, modified_utc_datetime = @modifiedUtcDatetime, project_version_status_notes = @notes 
                                 WHERE project_id = @projectId AND project_version_id = @projectVersionId";

                    await connection.QueryAsync(sql, new { projectStatus, modifiedUtcDatetime, notes, projectId, projectVersionId });
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<int> GetProjectStatus(int projectId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining project status by project id : {projectId} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var sql = @"SELECT project_status_key FROM project_list WHERE project_id = @projectId";

                return await connection.QueryFirstOrDefaultAsync<int>(sql, new { projectId });
            }

        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<int> GetProjectVersionStatus(int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining project status by project version id : {projectVersionId} \n");

            using (var connection = _projectDBContext.GetConnection())
            {
                var sql = @"SELECT project_version_status_key 
                            FROM project_version
                            WHERE project_version_id = @projectVersionId";

                return await connection.QueryFirstOrDefaultAsync<int>(sql, new { projectVersionId });
            }

        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}