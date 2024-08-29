using CN.Project.Domain;
using CN.Project.Domain.Dto;
using AutoMapper;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;
using CN.Project.Domain.Models.Dto;
using Cn.Incumbent;
using static Cn.Incumbent.Incumbent;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;

namespace CN.Project.Infrastructure.Repository;

public class ProjectDetailsRepository : IProjectDetailsRepository
{
    protected IMapper _mapper;
    private readonly IDBContext _databaseContext;
    private readonly ILogger<ProjectDetailsRepository> _logger;
    private readonly IFileRepository _fileRepository;
    private readonly Incumbent.IncumbentClient _incumbentClient;

    public ProjectDetailsRepository(IDBContext databaseContext,
                                    IFileRepository fileRepository,
                                    IMapper mapper,
                                    ILogger<ProjectDetailsRepository> logger,
                                    IncumbentClient incumbentClient)
    {
        _databaseContext = databaseContext;
        _fileRepository = fileRepository;
        _mapper = mapper;
        _logger = logger;
        _incumbentClient = incumbentClient;
    }

    public async Task<ProjectDetailsDto> SaveProjetDetails(ProjectDetailsDto projectDetails, string user, bool newProject = true)
    {
        try
        {
            _logger.LogInformation($"\nSaving Project: {projectDetails.Name} \n");

            using (var connection = _databaseContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        /*
                            projecDetails.SourceDataInfo.FileLogKey (the new fileFogKey comes from the UI)
                            projecDetails.existingFileLogKey (when already exists a file with the same OrgId, SourceDate and effectiveDate)
                        */
                        var projectID = projectDetails.ID > 0 && !newProject ? projectDetails.ID : await SaveProjectInfo(projectDetails, connection, transaction);
                        var projectVersionId = await SaveProjectVersion(projectDetails, projectID, user, connection, transaction);

                        if (projectDetails.BenchmarkDataTypes?.Count > 0)
                            await SaveProjectBenchmarkDataTypes(projectDetails.BenchmarkDataTypes, projectVersionId, user, connection, transaction);

                        transaction.Commit();

                        projectDetails.ID = projectID;
                        projectDetails.Version = projectVersionId;

                        return projectDetails;
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task UpdateProjetDetails(int projectId, int versionId, ProjectDetailsDto projectDetails, string? userObjectId)
    {
        try
        {
            _logger.LogInformation($"\nUpdating Project: {projectDetails.Name} \n");
            using (var connection = _databaseContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        var projectVersionDetails = await GetProjectVersionDetails(versionId);
                        await UpdateProjectInfo(projectId, projectDetails, userObjectId, connection, transaction);
                        var projectVersionId = await UpdateProjectVersion(projectId, versionId, projectDetails, userObjectId, connection, transaction);
                        await UpdateProjectBenchmarkDataTypes(projectDetails.BenchmarkDataTypes ?? new List<BenchmarkDataTypeInfoDto>(), projectVersionId, userObjectId, connection, transaction);

                        var selectedFileLogKey = projectDetails.SourceDataInfo?.FileLogKey;
                        // Insert/Update the market pricing sheet rows:
                        // When the aggregationMethodologyKey is different from the current one in the project version details
                        // OR when the file is changed to a different Data Effective Date
                        // OR when the project doesn't have a file but is updated with a new one (uploaded or selected from the Data Effective Date list)
                        if (selectedFileLogKey is not null && ((projectVersionDetails.AggregationMethodologyKey != projectDetails.AggregationMethodologyKey) ||
                            selectedFileLogKey != projectVersionDetails.FileLogKey))
                        {
                            var clientJobs = await ListClientJobs(selectedFileLogKey.Value, (int)projectDetails.AggregationMethodologyKey);
                            await InsertOrUpdateClientJobsIntoMarketPricingSheetRows(projectVersionId, selectedFileLogKey.Value, clientJobs, userObjectId, connection, transaction);
                        }

                        transaction.Commit();
                    }
                    catch
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }

    public async Task<ProjectDetailsViewDto> GetProjetDetails(int projectId, int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Project Details by id: {projectId} and version: {projectVersionId} \n");

            var projectDetails = new ProjectDetailsViewDto();
            using (var connection = _databaseContext.GetConnection())
            {
                var sql = @"SELECT pl.project_id,
                                    TRIM(pl.project_name) as project_name,
                                    pl.project_status_key,
                                    pl.survey_source_group_key, 
                                    pl.org_key, 
                                    pv.project_version_id,
                                    TRIM(pv.project_version_label) as project_version_label,
                                    pv.project_version_datetime,
                                    pv.aggregation_methodology_key,
                                    pv.project_version_status_key,
                                    TRIM(pv.project_version_status_notes) as project_version_status_notes,
                                    pv.file_log_key as File_Log_Key
                                FROM project_list pl
                                INNER JOIN project_version pv on pv.project_id = pl.project_id
                                WHERE pl.project_id = @projectId and pv.project_version_id = @projectVersionId";

                var project = await connection.QuerySingleOrDefaultAsync<Project_List>(sql, new { projectId, projectVersionId });
                if (project != null)
                {
                    projectDetails = _mapper.Map<ProjectDetailsViewDto>(project);

                    projectDetails.BenchmarkDataTypes = await GetProjectBenchmarkDataTypes(project.Project_Version_Id, connection);
                    if (project.File_Log_Key > 0)
                    {
                        projectDetails.SourceDataInfo = await GetProjectSourceDataInfoDetails(project.File_Log_Key.Value, connection);
                        var file = (await _fileRepository.GetFilesByIds(new List<int>() { project.File_Log_Key.Value })).FirstOrDefault();
                        projectDetails.FileStatusName = file?.FileStatusName;
                        projectDetails.FileStatusKey = file?.FileStatusKey;
                    }
                }
            }

            return projectDetails;
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<ProjectVersionDto> GetProjectVersionDetails(int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file log key by project version id: {projectVersionId}\n");

            using (var connection = _databaseContext.GetConnection())
            {
                var sql = @"SELECT pl.org_key AS OrganizationKey,
                                   pv.file_log_key AS FileLogKey, 
                                   pv.aggregation_methodology_key AS AggregationMethodologyKey,
                                   pl.survey_source_group_key AS SurveySourceGroupKey,
                                   pv.modified_utc_datetime AS ModifiedUtcDatetime
                            FROM project_version pv
                            INNER JOIN project_list pl on pl.project_id = pv.project_id
                            WHERE project_version_id = @projectVersionId";

                return await connection.QuerySingleOrDefaultAsync<ProjectVersionDto>(sql, new { projectVersionId });
            }

        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<int>> GetBenchmarkDataTypeKeys(int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining benchmark data type keys by project version id: {projectVersionId}\n");

            using (var connection = _databaseContext.GetConnection())
            {
                var sql = @"SELECT DISTINCT(benchmark_data_type_key)
                            FROM project_benchmark_data_type
                            WHERE project_version_id = @projectVersionId";

                var keys = await connection.QueryAsync<int>(sql, new { projectVersionId });
                return keys.ToList();
            }

        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task InsertMarketPricingSheetRows(int fileLogKey, List<ProjectVersionDto> projectVersions, List<MarketPricingSheetDto> clientJobs, string? userObjectId)
    {
        if (projectVersions is null || projectVersions.Count == 0)
        {
            _logger.LogError($"\nNo existing project versions for file log key: {fileLogKey}\n");
            return;
        }

        using (var connection = _databaseContext.GetConnection())
        {
            connection.Open();
            using (var transaction = connection.BeginTransaction())
            {
                try
                {
                    // In most cases is going to be only 1 project version.
                    // It will cover the scenario when the user Save As a project that will create another project version with the same file.
                    foreach (var version in projectVersions)
                    {
                        await InsertOrUpdateClientJobsIntoMarketPricingSheetRows(version.Id, fileLogKey, clientJobs, userObjectId, connection, transaction);
                    }
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    _logger.LogError($"\nError {ex.Message}\n");
                    throw;
                }
            }
        }
    }

    public async Task<List<MarketPricingSheetDto>> ListClientJobs(int fileLogKey, int aggregationMethodologyKey)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get list of client jobs for file log key: {fileLogKey}\n");

            var request = new SourceDataSearchRequest()
            {
                FileLogKey = fileLogKey,
                AggregationMethodKey = aggregationMethodologyKey
            };

            var incumbentResponse = await _incumbentClient.ListClientJobsAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<MarketPricingSheetDto>>(incumbentResponse.ClientJobs.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<ClientPayDto>> ListClientPayDetail(int fileLogKey, int fileOrgKey, int aggregationMethodKey, string jobCode, string positionCode, IEnumerable<int> benchmarkDataTypeKeys)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get list of client pay details for file log key: {fileLogKey}\n");

            var request = new ClientJobRequest()
            {
                FileLogKey = fileLogKey,
                FileOrgKey = fileOrgKey,
                AggregationMethodKey = aggregationMethodKey,
                JobCode = jobCode,
                PositionCode = positionCode,
                BenchmarkDataTypeKeys = { benchmarkDataTypeKeys }
            };

            var incumbentResponse = await _incumbentClient.ListClientPayDetailAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<ClientPayDto>>(incumbentResponse.ClientPayDetails.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    #region private methods

    private async Task<int> SaveProjectInfo(ProjectDetailsDto projecDetails, IDbConnection connection, IDbTransaction transaction)
    {
        var project_status_modified_utc_datetime = DateTime.UtcNow;
        var project_created_utc_datetime = DateTime.UtcNow;

        var sql = $@"INSERT INTO project_list (
                            project_name, 
                            survey_source_group_key, 
                            org_key, 
                            project_status_key, 
                            project_status_modified_utc_datetime, 
                            project_created_utc_datetime) 
                         VALUES(
                            @Name, 
                            @WorkforceProjectType, 
                            @OrganizationID, 
                            @ProjectStatus, 
                            @project_status_modified_utc_datetime, 
                            @project_created_utc_datetime) 
                      RETURNING project_id";

        return await connection.ExecuteScalarAsync<int>(sql,
            new
            {
                projecDetails.Name,
                projecDetails.WorkforceProjectType,
                projecDetails.OrganizationID,
                projecDetails.ProjectStatus,
                project_status_modified_utc_datetime,
                project_created_utc_datetime
            }, transaction);
    }

    private async Task<int> SaveProjectVersion(ProjectDetailsDto projectDetails, int projectID, string user, IDbConnection connection, IDbTransaction transaction)
    {
        var projectVersionDate = DateTime.UtcNow;
        var modifiedDate = DateTime.UtcNow;

        var fileLogKey = projectDetails.SourceDataInfo?.FileLogKey == 0 ? null : projectDetails.SourceDataInfo?.FileLogKey; //This is a FK, we can't have a 0 value

        var sql = $@"INSERT INTO project_version (
                            project_id
                            ,project_version_label
                            ,project_version_datetime
                            ,project_version_status_key
                            ,project_version_status_notes
                            ,file_log_key
                            ,aggregation_methodology_key
                            ,modified_username
                            ,modified_utc_datetime)
                        VALUES (
                             @projectID
                            ,@VersionLabel
                            ,@projectVersionDate
                            ,@ProjectStatus
                            ,@VersionStatusNotes
                            ,@fileLogKey
                            ,@AggregationMethodologyKey
                            ,@user
                            ,@modifiedDate)

                        RETURNING project_version_id";

        var projectVersionId = await connection.ExecuteScalarAsync<int>(sql,
            new
            {
                projectID,
                projectDetails.VersionLabel,
                projectVersionDate,
                projectDetails.ProjectStatus,
                projectDetails.VersionStatusNotes,
                fileLogKey,
                projectDetails.AggregationMethodologyKey,
                user,
                modifiedDate,
            }, transaction);

        if (fileLogKey is not null)
        {
            var clientJobs = await ListClientJobs(fileLogKey.Value, (int)projectDetails.AggregationMethodologyKey);
            // 1) The clientJobs is empty when a new file is uploaded and the Glue job is processing it.
            //    In this scenario the Glue job is responsible for inserting the market pricing sheet rows calling to the proper endpoint.
            // 2) The clientJobs is NOT empty when a new project is created and a valid file is selected from the Data Effective Date list.
            await InsertOrUpdateClientJobsIntoMarketPricingSheetRows(projectVersionId, fileLogKey.Value, clientJobs, user, connection, transaction);
        }

        return projectVersionId;
    }

    private async Task SaveProjectBenchmarkDataTypes(List<BenchmarkDataTypeInfoDto> benchmarkDataTypes, int projectVersionID, string? user, IDbConnection connection, IDbTransaction transaction)
    {
        var modifiedDate = DateTime.UtcNow;

        foreach (var item in benchmarkDataTypes)
        {
            var sql = $@"INSERT INTO project_benchmark_data_type ( 
                                                     project_version_id
                                                    ,benchmark_data_type_key
                                                    ,aging_factor_override
                                                    ,override_comment
                                                    ,modified_username
                                                    ,modified_utc_datetime
                                                    )
                                            VALUES ( @projectVersionID
                                                    ,@ID
                                                    ,@overrideAgingFactor
                                                    ,@overrideNote
                                                    ,@user
                                                    ,@modifiedDate
                                                    )";
            await connection.ExecuteAsync(sql,
                new
                {
                    projectVersionID,
                    item.ID,
                    item.OverrideAgingFactor,
                    item.OverrideNote,
                    user,
                    modifiedDate
                }, transaction);
        }
    }

    private async Task<SourceDataInfoDto?> GetProjectSourceDataInfoDetails(int fileLogKey, IDbConnection connection)
    {
        var file = await _fileRepository.GetFilesByIds(new List<int>() { fileLogKey });
        return _mapper.Map<IEnumerable<SourceDataInfoDto>>(file).FirstOrDefault();
    }

    private async Task<List<BenchmarkDataTypeInfoDto>> GetProjectBenchmarkDataTypes(int projectVersionID, IDbConnection connection)
    {
        var sql = @"SELECT 
                        project_benchmark_data_type_id,
                        project_version_id,
                        benchmark_data_type_key,
                        aging_factor_override,
                        override_comment
                    FROM project_benchmark_data_type
                    WHERE project_version_id = @projectVersionID";

        var benchmarkDataTypes = await connection.QueryAsync<BenchmarkDataType>(sql, new { projectVersionID });
        return _mapper.Map<List<BenchmarkDataTypeInfoDto>>(benchmarkDataTypes.ToList());
    }

    public async Task<List<BenchmarkDataTypeInfoDto>> GetProjectBenchmarkDataTypes(int projectVersionId)
    {
        try
        {
            _logger.LogInformation($"\nObtaining benchmark data types for project version id: {projectVersionId} \n");
            using (var connection = _databaseContext.GetConnection())
            {
                return await GetProjectBenchmarkDataTypes(projectVersionId, connection);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    private async Task UpdateProjectInfo(int projectId, ProjectDetailsDto projecDetails, string? user, IDbConnection connection, IDbTransaction transaction)
    {
        try
        {
            var utc_datetime = DateTime.UtcNow;

            var sql = $@"UPDATE project_list SET
                             project_status_key = @ProjectStatus,
                             project_status_modified_utc_datetime = @utc_datetime,
                             modified_username = @user,
                             modified_utc_datetime = @utc_datetime
                        WHERE project_id = @projectId";

            await connection.ExecuteScalarAsync(sql,
                new
                {
                    projecDetails.ProjectStatus,
                    utc_datetime,
                    user,
                    projectId
                }, transaction);
        }
        catch
        {
            throw;
        }
    }

    private async Task<int> UpdateProjectVersion(int projectId, int versionId, ProjectDetailsDto projectDetails, string? user, IDbConnection connection, IDbTransaction transaction)
    {
        try
        {
            var modifiedDate = DateTime.UtcNow;
            var fileLogKey = projectDetails.SourceDataInfo?.FileLogKey;

            var sql = $@"UPDATE project_version SET 
                                project_version_label = @VersionLabel, 
                                project_version_status_key = @ProjectStatus,
                                aggregation_methodology_key = @AggregationMethodologyKey,
                                modified_username = @user,
                                modified_utc_datetime = @modifiedDate,
                                file_log_key = @fileLogKey
                            WHERE project_id = @projectId And project_version_id = @versionId
                            RETURNING project_version_id";

            var projectVersionId = await connection.ExecuteScalarAsync<int>(sql,
                new
                {
                    projectDetails.VersionLabel,
                    projectDetails.ProjectStatus,
                    projectDetails.AggregationMethodologyKey,
                    user,
                    modifiedDate,
                    projectId,
                    versionId,
                    fileLogKey
                }, transaction);

            return projectVersionId;
        }
        catch
        {
            throw;
        }
    }

    private async Task UpdateProjectBenchmarkDataTypes(List<BenchmarkDataTypeInfoDto> benchmarkDataTypes, int projectVersionId, string? user, IDbConnection connection, IDbTransaction transaction)
    {
        var existingBenchmarkTypes = await GetProjectBenchmarkDataTypes(projectVersionId, connection);
        var itemsToUpdate = existingBenchmarkTypes.Where(etype => benchmarkDataTypes.Any(t => t.ID == etype.ID));
        var itemsToDelete = existingBenchmarkTypes.Where(etype => !benchmarkDataTypes.Any(t => t.ID == etype.ID));
        var itemsToAdd = benchmarkDataTypes.Where(type => !existingBenchmarkTypes.Any(t => t.ID == type.ID));

        if (itemsToAdd.Any())
        {
            await SaveProjectBenchmarkDataTypes(itemsToAdd.ToList(), projectVersionId, user, connection, transaction);
        }

        if (itemsToDelete.Any())
        {
            await DeleteProjectBenchmarkDataTypes(itemsToDelete.ToList(), projectVersionId, connection, transaction);
        }

        if (itemsToUpdate.Any())
        {
            var modifiedDate = DateTime.UtcNow;

            var sql = $@"UPDATE project_benchmark_data_type SET 
                                aging_factor_override = @OverrideAgingFactor,
                                override_comment = @OverrideNote,
                                modified_username = @user,
                                modified_utc_datetime = @modifiedDate
                            WHERE project_benchmark_data_type_id = @ID AND 
                                project_version_id = @projectVersionID AND 
                                benchmark_data_type_key = @BenchmarkDataTypeKey";

            foreach (var item in itemsToUpdate)
            {
                var type = benchmarkDataTypes.SingleOrDefault(t => t.BenchmarkDataTypeKey == item.BenchmarkDataTypeKey);
                if (type != null && (item.OverrideAgingFactor != type.OverrideAgingFactor || item.OverrideNote != type.OverrideNote))
                {
                    await connection.ExecuteScalarAsync(sql,
                        new
                        {
                            type.OverrideAgingFactor,
                            type.OverrideNote,
                            item.ID,
                            item.BenchmarkDataTypeKey,
                            projectVersionId,
                            user,
                            modifiedDate
                        });
                }
            }
        }
    }

    private async Task DeleteProjectBenchmarkDataTypes(List<BenchmarkDataTypeInfoDto> types, int projectVersionId, IDbConnection connection, IDbTransaction transaction)
    {
        var ids = types.Select(item => item.ID);
        var delete_sql = $@"DELETE FROM project_benchmark_data_type WHERE project_version_id = @projectVersionId And project_benchmark_data_type_id in (" + String.Join(",", ids) + ")";
        await connection.ExecuteAsync(delete_sql, new { projectVersionId });
    }

    private async Task InsertOrUpdateClientJobsIntoMarketPricingSheetRows(int projectVersionId, int fileLogKey, List<MarketPricingSheetDto> clientJobs, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
    {
        _logger.LogInformation($"\nInsert or Update market pricing sheet rows for project version id: {projectVersionId} and file log key: {fileLogKey} \n");

        if (clientJobs is null || clientJobs.Count == 0)
        {
            _logger.LogError($"\nNo existing client jobs for file log key: {fileLogKey}\n");
            return;
        }

        await InsertMarketPricingSheetRowsInTemporaryTable(projectVersionId, clientJobs, connection, transaction);
        await InsertOrUpdateMarketPricingSheetRows(projectVersionId, userObjectId, connection, transaction);
        await DeleteOrphanMarketPricingSheetRows(projectVersionId, connection, transaction);
    }

    private async Task InsertOrUpdateMarketPricingSheetRows(int projectVersionId, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
    {
        try
        {
            _logger.LogInformation($"\nInsert or update market pricing sheet rows for project version id: {projectVersionId}\n");
            var modifiedDate = DateTime.UtcNow;
            var marketPricingStatusKey = (int)MarketPricingStatus.NotStarted;
            // The job group must be updated only when the value is null in the market_pricing_sheet table.
            var sql = $@"UPDATE market_pricing_sheet
                        SET job_title = temp.job_title,
                            job_group = CASE
                                            WHEN market_pricing_sheet.job_group IS NULL OR market_pricing_sheet.job_group = '' 
                                                THEN temp.job_group
                                            ELSE market_pricing_sheet.job_group
                                        END
                        FROM temp_market_pricing_sheet AS temp
                        WHERE market_pricing_sheet.project_version_id = temp.project_version_id
                        AND market_pricing_sheet.aggregation_method_key = temp.aggregation_method_key
                        AND market_pricing_sheet.ces_org_id = temp.ces_org_id
                        AND market_pricing_sheet.job_code = temp.job_code
                        AND market_pricing_sheet.position_code = temp.position_code;

                        INSERT INTO market_pricing_sheet (
                            project_version_id, 
                            aggregation_method_key, 
                            ces_org_id, 
                            job_code,
                            job_title,
                            job_group, 
                            position_code,
                            status_key,
                            status_change_date,
                            modified_username,
                            modified_utc_datetime)
                        SELECT 
                            temp_market_pricing_sheet.project_version_id, 
                            temp_market_pricing_sheet.aggregation_method_key, 
                            temp_market_pricing_sheet.ces_org_id, 
                            temp_market_pricing_sheet.job_code, 
                            temp_market_pricing_sheet.job_title,
                            temp_market_pricing_sheet.job_group, 
                            temp_market_pricing_sheet.position_code,
                            @marketPricingStatusKey,
                            @modifiedDate,
                            @userObjectId,
                            @modifiedDate
                        FROM temp_market_pricing_sheet
                        WHERE NOT EXISTS (
                            SELECT 1 
                            FROM market_pricing_sheet AS mps
                            WHERE 
                                temp_market_pricing_sheet.project_version_id = mps.project_version_id AND
                                temp_market_pricing_sheet.aggregation_method_key = mps.aggregation_method_key AND 
                                temp_market_pricing_sheet.ces_org_id = mps.ces_org_id AND
                                temp_market_pricing_sheet.job_code = mps.job_code AND 
                                temp_market_pricing_sheet.position_code = mps.position_code);";

            await connection.ExecuteScalarAsync<int>(sql,
                new
                {
                    userObjectId,
                    modifiedDate,
                    marketPricingStatusKey
                }, transaction);
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    private async Task DeleteOrphanMarketPricingSheetRows(int projectVersionId, IDbConnection connection, IDbTransaction transaction)
    {
        try
        {
            _logger.LogInformation($"\nDelete orphan market pricing sheet rows for project version id: {projectVersionId}\n");

            var sql = $@"DELETE FROM market_pricing_sheet_job_match AS MPSJM
                     WHERE EXISTS (
                        SELECT NULL
                        FROM market_pricing_sheet AS MPS
                        WHERE
                            MPS.project_version_id = @projectVersionId
                            AND MPS.market_pricing_sheet_id = MPSJM.market_pricing_sheet_id
                            AND NOT EXISTS
                            (
                                SELECT NULL
                                FROM temp_market_pricing_sheet AS TMPS
                                WHERE
                                    MPS.project_version_id = TMPS.project_version_id
                                    AND MPS.aggregation_method_key = TMPS.aggregation_method_key
                                    AND MPS.ces_org_id = TMPS.ces_org_id
                                    AND MPS.job_code = TMPS.job_code
                                    AND MPS.position_code = TMPS.position_code
                            )
                     );
        
                    DELETE FROM market_pricing_sheet AS MPS
                    WHERE
                        MPS.project_version_id = @projectVersionId
                        AND NOT EXISTS
                        (
                            SELECT NULL
                            FROM temp_market_pricing_sheet AS TMPS
                            WHERE
                                MPS.project_version_id = TMPS.project_version_id
                                AND MPS.aggregation_method_key = TMPS.aggregation_method_key
                                AND MPS.ces_org_id = TMPS.ces_org_id
                                AND MPS.job_code = TMPS.job_code
                                AND MPS.position_code = TMPS.position_code
                        );";

            await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        projectVersionId = @projectVersionId
                    },
                transaction);

            // Drop the temporary table
            await connection.ExecuteAsync("DROP TABLE temp_market_pricing_sheet;", transaction);
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }

    private async Task InsertMarketPricingSheetRowsInTemporaryTable(int projectVersionId, List<MarketPricingSheetDto> data, IDbConnection connection, IDbTransaction transaction)
    {
        try
        {
            _logger.LogInformation($"\nInsert market pricing sheet rows in temporary table for project version id: {projectVersionId}\n");
            // Create a temporary table
            await connection.ExecuteAsync($@"CREATE TEMPORARY TABLE temp_market_pricing_sheet (
                                            project_version_id INT,
                                            aggregation_method_key INT,
                                            ces_org_id INT,
                                            job_code VARCHAR,
                                            job_title VARCHAR,
                                            job_group VARCHAR,
                                            position_code VARCHAR);", transaction);

            // Insert values into the temporary table
            var qry = @"INSERT INTO temp_market_pricing_sheet (project_version_id, 
                            aggregation_method_key, 
                            ces_org_id, 
                            job_code, 
                            job_title, 
                            job_group, 
                            position_code)
                        VALUES
                        {0}";

            var batchSize = 300;
            Dictionary<string, object> parameters;

            for (int i = 0; i < data.Count; i += batchSize)
            {
                var values = GenerateQueryValues(data, i, batchSize);
                var finalQuery = string.Format(qry, string.Join(",", values));

                parameters = GetQueryParameters(data, projectVersionId, i, batchSize);

                await connection.ExecuteAsync(finalQuery, parameters, transaction);
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }

    private Dictionary<string, object> GetQueryParameters(List<MarketPricingSheetDto> data, int projectVersionId, int start, int batchSize)
    {
        var result = new Dictionary<string, object>();
        for (int i = start; i < batchSize + start; i++)
        {
            if (i > data.Count() - 1)
                break;

            result.Add($"@value_project_version_{i}", projectVersionId);
            result.Add($"@value_aggr_method_{i}", data[i].AggregationMethodKey);
            result.Add($"@value_org_{i}", data[i].FileOrgKey);
            result.Add($"@value_job_code_{i}", data[i].JobCode);
            result.Add($"@value_job_title_{i}", data[i].JobTitle);
            result.Add($"@value_job_group_{i}", data[i].JobGroup);
            result.Add($"@value_position_code_{i}", data[i].PositionCode);
        }

        return result;
    }


    private List<string> GenerateQueryValues(List<MarketPricingSheetDto> data, int start, int batchAmount)
    {
        var result = new List<string>();
        for (int i = start; i < batchAmount + start; i++)
        {
            if (i > data.Count() - 1)
                break;

            result.Add($@"(@value_project_version_{i}, 
                           @value_aggr_method_{i},
                           @value_org_{i},
                           @value_job_code_{i},
                           @value_job_title_{i},
                           @value_job_group_{i},
                           @value_position_code_{i})");
        }
        return result;
    }

    #endregion
}
