using AutoMapper;
using Cn.Incumbent;
using Cn.Survey;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;

namespace CN.Project.Infrastructure.Repositories
{
    public class JobMatchingRepository : IJobMatchingRepository
    {
        protected IMapper _mapper;

        private readonly ILogger<MarketSegmentMappingRepository> _logger;
        private readonly IDBContext _mptProjectDBContext;
        private readonly Survey.SurveyClient _surveyClient;
        private readonly Incumbent.IncumbentClient _incumbentClient;

        public JobMatchingRepository(ILogger<MarketSegmentMappingRepository> logger,
                                     IDBContext mptProjectDBContext,
                                     Survey.SurveyClient surveyClient,
                                     Incumbent.IncumbentClient incumbentClient,
                                     IMapper mapper)
        {
            _logger = logger;
            _mptProjectDBContext = mptProjectDBContext;
            _surveyClient = surveyClient;
            _incumbentClient = incumbentClient;
            _mapper = mapper;
        }

        public async Task SaveJobMatchingStatus(int projectVersionId, int marketPricingStatusKey, JobMatchingStatusUpdateDto jobMatchingStatusUpdate, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nSaving job matching status for project version id: {projectVersionId} and job code {jobMatchingStatusUpdate.JobCode} \n");
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var modifiedDate = DateTime.UtcNow;
                    var sql = $@"UPDATE market_pricing_sheet 
                             SET 
                                modified_username = @userObjectId,
                                status_key = CASE WHEN status_key <> @marketPricingStatusKey THEN @marketPricingStatusKey ELSE status_key END,
                                status_change_date = CASE WHEN status_key <> @marketPricingStatusKey THEN @modifiedDate ELSE status_change_date END
                             WHERE 
                                project_version_id = @ProjectVersionId AND
                                aggregation_method_key = @AggregationMethodKey AND 
                                ces_org_id = @FileOrgKey AND
                                job_code = @JobCode AND 
                                position_code = @PositionCode;

                             INSERT INTO market_pricing_sheet (
                                    project_version_id, 
                                    aggregation_method_key, 
                                    ces_org_id, 
                                    job_code, 
                                    position_code,
                                    status_key,
                                    status_change_date,
                                    modified_username)
                                SELECT 
                                    @ProjectVersionId, 
                                    @AggregationMethodKey, 
                                    @FileOrgKey, 
                                    @JobCode, 
                                    @PositionCode,
                                    @marketPricingStatusKey,
                                    @modifiedDate,      
                                    @userObjectId
                                WHERE NOT EXISTS (
                                    SELECT null
                                    FROM market_pricing_sheet 
                                    WHERE 
                                        project_version_id = @ProjectVersionId AND
                                        aggregation_method_key = @AggregationMethodKey AND 
                                        ces_org_id = @FileOrgKey AND
                                        job_code = @JobCode AND 
                                        position_code = @PositionCode);";

                    await connection.ExecuteScalarAsync<int>(sql,
                        new
                        {
                            projectVersionId,
                            jobMatchingStatusUpdate.AggregationMethodKey,
                            jobMatchingStatusUpdate.FileOrgKey,
                            jobMatchingStatusUpdate.JobCode,
                            jobMatchingStatusUpdate.PositionCode,
                            marketPricingStatusKey,
                            userObjectId,
                            modifiedDate
                        });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<List<StandardJobMatchingDto>> GetStandardMatchedJobs(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs)
        {
            _logger.LogInformation($"\nGet standard matched jobs for project version id: {projectVersionId} \n");

            try
            {
                if (selectedJobs == null || selectedJobs.Count == 0)
                    return new List<StandardJobMatchingDto>();

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    foreach (var selectedJob in selectedJobs)
                    {
                        var sql = $@"SELECT TRIM(jm.standard_job_code) AS StandardJobCode,
                                        jm.standard_job_title AS StandardJobTitle,
                                        jm.standard_job_description AS StandardJobDescription,
                                        jm.blend_note AS BlendNote,
                                        jm.blend_percent AS BlendPercent 
                                    FROM market_pricing_sheet AS mps
                                    INNER JOIN market_pricing_sheet_job_match jm on jm.market_pricing_sheet_id = mps.market_pricing_sheet_id
                                    WHERE 
                                        mps.project_version_id = @ProjectVersionId AND
                                        mps.aggregation_method_key = @AggregationMethodKey AND 
                                        mps.ces_org_id = @FileOrgKey AND 
                                        LOWER(mps.job_code) = LOWER(@JobCode) AND 
                                        LOWER(mps.position_code) = LOWER(@PositionCode);";

                        var matchedJobs = await connection.QueryAsync<StandardJobMatchingDto>(sql,
                                new
                                {
                                    projectVersionId,
                                    selectedJob.AggregationMethodKey,
                                    selectedJob.FileOrgKey,
                                    selectedJob.JobCode,
                                    selectedJob.PositionCode,
                                });

                        if (matchedJobs is not null && matchedJobs.Any())
                            return matchedJobs.ToList();
                    }
                }

                return new List<StandardJobMatchingDto>();
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<JobMatchingSaveData> GetJobMatchingSavedData(int projectVersionId, JobMatchingStatusUpdateDto selectedJob)
        {
            _logger.LogInformation($"\nGet standard matched jobs for project version id: {projectVersionId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT TRIM(mps.market_pricing_job_code) AS MarketPricingJobCode,
                                        TRIM(mps.market_pricing_job_title) AS MarketPricingJobTitle,
                                        TRIM(mps.market_pricing_job_description) AS MarketPricingJobDescription,
                                        TRIM(mps.publisher_name) AS PublisherName,
                                        mps.publisher_key AS PublisherKey,
                                        mps.status_key AS JobMatchStatusKey,
                                        TRIM(mps.job_match_note) AS JobMatchNote,
                                        TRIM(jm.standard_job_code) AS StandardJobCode,
                                        jm.standard_job_title AS StandardJobTitle,
                                        jm.standard_job_description AS StandardJobDescription,
                                        jm.blend_note AS BlendNote,
                                        jm.blend_percent AS BlendPercent
                                    FROM market_pricing_sheet AS mps
                                    INNER JOIN market_pricing_sheet_job_match jm on jm.market_pricing_sheet_id = mps.market_pricing_sheet_id
                                    WHERE 
                                        mps.project_version_id = @ProjectVersionId AND
                                        mps.aggregation_method_key = @AggregationMethodKey AND 
                                        mps.ces_org_id = @FileOrgKey AND 
                                        LOWER(mps.job_code) = LOWER(@JobCode) AND 
                                        LOWER(mps.position_code) = LOWER(@PositionCode);";

                    var matchedJobs = await connection.QueryAsync<JobMatchingSaveData, StandardJobMatchingDto, JobMatchingSaveData>(sql,
                        (jobMatching, standardJob) =>
                        {
                            jobMatching.StandardJobs = new List<StandardJobMatchingDto> { standardJob };

                            return jobMatching;
                        },
                        new
                        {
                            projectVersionId,
                            selectedJob.AggregationMethodKey,
                            selectedJob.FileOrgKey,
                            selectedJob.JobCode,
                            selectedJob.PositionCode,
                        },
                        splitOn: "StandardJobCode");

                    var result = matchedJobs
                        .GroupBy(job => new
                        {
                            job.MarketPricingJobCode,
                            job.MarketPricingJobTitle,
                            job.MarketPricingJobDescription,
                            job.PublisherName,
                            job.JobMatchNote,
                            job.JobMatchStatusKey
                        }).Select(group => new JobMatchingSaveData
                        {
                            MarketPricingJobCode = group.Key.MarketPricingJobCode,
                            MarketPricingJobTitle = group.Key.MarketPricingJobTitle,
                            MarketPricingJobDescription = group.Key.MarketPricingJobDescription,
                            PublisherName = group.Key.PublisherName,
                            JobMatchNote = group.Key.JobMatchNote,
                            JobMatchStatusKey = group.Key.JobMatchStatusKey,
                            StandardJobs = group.SelectMany(g => g.StandardJobs).ToList()
                        })
                        .ToList();

                    return result is not null && result.Any() ? result.First() : new JobMatchingSaveData();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task SaveClientJobsMatching(int projectVersionId, JobMatchingSaveData jobMatchingSaveData, string? userObjectId)
        {
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        _logger.LogInformation($"\nSaving matching jobs for project version id: {projectVersionId} \n");
                        foreach (var job in jobMatchingSaveData.SelectedJobs)
                        {
                            var modifiedDate = DateTime.UtcNow;
                            var sql = $@"UPDATE market_pricing_sheet 
                                         SET 
                                            status_key = CASE WHEN status_key <> @JobMatchStatusKey THEN @JobMatchStatusKey ELSE status_key END,
                                            status_change_date = CASE WHEN status_key <> @JobMatchStatusKey THEN @modifiedDate ELSE status_change_date END,
                                            market_pricing_job_code = @MarketPricingJobCode,
                                            market_pricing_job_title = @MarketPricingJobTitle,
                                            market_pricing_job_description = @MarketPricingJobDescription,
                                            publisher_name = @PublisherName,
                                            publisher_key = @PublisherKey,
                                            job_match_note = @JobMatchNote,
                                            modified_username = @userObjectId,
                                            modified_utc_datetime = @modifiedDate
                                         WHERE 
                                            project_version_id = @ProjectVersionId AND
                                            aggregation_method_key = @AggregationMethodKey AND 
                                            ces_org_id = @FileOrgKey AND
                                            LOWER(job_code) = LOWER(@JobCode) AND 
                                            LOWER(position_code) = LOWER(@PositionCode);

                                        INSERT INTO market_pricing_sheet (
                                            project_version_id, 
                                            aggregation_method_key, 
                                            ces_org_id, 
                                            job_code, 
                                            position_code,
                                            status_key,
                                            status_change_date,
                                            market_pricing_job_code,
                                            market_pricing_job_title,
                                            market_pricing_job_description,
                                            publisher_name,
                                            publisher_key,
                                            job_match_note,
                                            modified_username,
                                            modified_utc_datetime)
                                        SELECT 
                                            @ProjectVersionId, 
                                            @AggregationMethodKey, 
                                            @FileOrgKey, 
                                            @JobCode, 
                                            @PositionCode,
                                            @JobMatchStatusKey,
                                            @modifiedDate,
                                            @MarketPricingJobCode,
                                            @MarketPricingJobTitle,
                                            @MarketPricingJobDescription,
                                            @PublisherName,
                                            @PublisherKey,
                                            @JobMatchNote,
                                            @userObjectId,
                                            @modifiedDate
                                        WHERE NOT EXISTS (
                                            SELECT 1 
                                            FROM market_pricing_sheet 
                                            WHERE 
                                                project_version_id = @ProjectVersionId AND
                                                aggregation_method_key = @AggregationMethodKey AND 
                                                ces_org_id = @FileOrgKey AND
                                                LOWER(job_code) = LOWER(@JobCode) AND 
                                                LOWER(position_code) = LOWER(@PositionCode));
                                    
                                        SELECT market_pricing_sheet_id 
                                        FROM market_pricing_sheet
                                        WHERE 
                                                project_version_id = @ProjectVersionId AND
                                                aggregation_method_key = @AggregationMethodKey AND 
                                                ces_org_id = @FileOrgKey AND
                                                LOWER(job_code) = LOWER(@JobCode) AND 
                                                LOWER(position_code) = LOWER(@PositionCode)";

                            var marketPricingSheetId = await connection.ExecuteScalarAsync<int>(sql,
                                new
                                {
                                    projectVersionId,
                                    job.AggregationMethodKey,
                                    job.FileOrgKey,
                                    job.JobCode,
                                    job.PositionCode,
                                    jobMatchingSaveData.JobMatchStatusKey,
                                    jobMatchingSaveData.MarketPricingJobCode,
                                    jobMatchingSaveData.MarketPricingJobTitle,
                                    jobMatchingSaveData.MarketPricingJobDescription,
                                    jobMatchingSaveData.PublisherName,
                                    jobMatchingSaveData.PublisherKey,
                                    jobMatchingSaveData.JobMatchNote,
                                    userObjectId,
                                    modifiedDate
                                });

                            var existingStandardJobs = await GetStandardMatchedJobs(marketPricingSheetId);

                            var itemsToUpdate = existingStandardJobs.Where(job => jobMatchingSaveData.StandardJobs.Any(t =>
                                string.Equals(t.StandardJobCode, job.StandardJobCode, StringComparison.OrdinalIgnoreCase) &&
                                string.Equals(t.StandardJobTitle, job.StandardJobTitle, StringComparison.OrdinalIgnoreCase)));

                            var itemsToDelete = existingStandardJobs.Where(job => !jobMatchingSaveData.StandardJobs.Any(t =>
                                string.Equals(t.StandardJobCode, job.StandardJobCode, StringComparison.OrdinalIgnoreCase) &&
                                string.Equals(t.StandardJobTitle, job.StandardJobTitle, StringComparison.OrdinalIgnoreCase)));

                            var itemsToAdd = jobMatchingSaveData.StandardJobs.Where(job => !existingStandardJobs.Any(t =>
                                string.Equals(t.StandardJobCode, job.StandardJobCode, StringComparison.OrdinalIgnoreCase) &&
                                string.Equals(t.StandardJobTitle, job.StandardJobTitle, StringComparison.OrdinalIgnoreCase)));

                            await AddStandardMatchedJobs(itemsToAdd, marketPricingSheetId, userObjectId, connection, transaction);
                            await DeleteStandardMatchedJobs(itemsToDelete, marketPricingSheetId, connection, transaction);
                            await UpdateStandardMatchedJobs(itemsToUpdate, jobMatchingSaveData.StandardJobs, marketPricingSheetId, userObjectId, connection, transaction);
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

        public async Task<IEnumerable<MarketPercentileDto>> ListPercentiles(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys, IEnumerable<int> industryKeys,
            IEnumerable<int> organizationKeys, IEnumerable<int> cutGroupKeys, IEnumerable<int> cutSubGroupKeys)
        {
            try
            {
                _logger.LogInformation($"\nCalling Survey gRPC service to list percentiles\n");

                var request = new ListPercentilesRequest();
                request.StandardJobCodes.AddRange(standardJobCodes);
                request.IndustrySectorKeys.AddRange(industryKeys);
                request.OrganizationTypeKeys.AddRange(organizationKeys);
                request.CutGroupKeys.AddRange(cutGroupKeys);
                request.CutSubGroupKeys.AddRange(cutSubGroupKeys);
                request.BenchmarkDataTypeKeys.AddRange(benchmarkDataTypeKeys);

                var surveyResponse = await _surveyClient.ListPercentilesAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<IEnumerable<MarketPercentileDto>>(surveyResponse.MarketValueByPercentile);

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<MarketPercentileDto>> ListAllPercentilesByStandardJobCode(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys)
        {
            try
            {
                _logger.LogInformation($"\nCalling Survey gRPC service to list all percentiles by job code\n");

                var request = new ListPercentilesRequest();
                request.StandardJobCodes.AddRange(standardJobCodes);
                request.BenchmarkDataTypeKeys.AddRange(benchmarkDataTypeKeys);

                var surveyResponse = await _surveyClient.ListAllPercentilesByStandardJobCodeAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<IEnumerable<MarketPercentileDto>>(surveyResponse.MarketValueByPercentile);

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<ClientPayDto>> ListClientBasePay(int fileLogKey, int aggregationMethodKey, IEnumerable<string> jobCodes, IEnumerable<int> benchmarkDataTypeKeys)
        {
            try
            {
                _logger.LogInformation($"\nCalling Incumbent gRPC service to list client base pay\n");

                var request = new ClientBasePayRequest
                {
                    FileLogKey = fileLogKey,
                    AggregationMethodKey = aggregationMethodKey,
                    JobCodes = { jobCodes },
                    BenchmarkDataTypeKeys = { benchmarkDataTypeKeys }
                };

                var incumbentResponse = await _incumbentClient.ListClientBasePayAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<IEnumerable<ClientPayDto>>(incumbentResponse.ClientBasePayList);

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<JobMatchingInfo> GetMarketPricingJobInfo(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs)
        {
            _logger.LogInformation($"\nGet standard matched jobs for project version id: {projectVersionId} \n");

            try
            {
                if (selectedJobs == null || selectedJobs.Count == 0)
                    return new JobMatchingInfo();

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    foreach (var selectedJob in selectedJobs)
                    {
                        var sql = $@"SELECT mps.market_pricing_job_code AS JobCode,
                                        mps.market_pricing_job_title AS JobTitle,
                                        mps.market_pricing_job_description AS JobDescription,
                                        mps.publisher_name AS PublisherName,
                                        mps.publisher_key AS PublisherKey,
                                        mps.job_match_note AS JobMatchNote,
                                        sl.status_name AS JobMatchStatusName,
                                        sl.status_key AS JobMatchStatusKey
                                    FROM market_pricing_sheet AS mps
                                    LEFT JOIN status_list sl on sl.status_key = mps.status_key
                                    WHERE 
                                        mps.project_version_id = @ProjectVersionId AND
                                        mps.aggregation_method_key = @AggregationMethodKey AND 
                                        mps.ces_org_id = @FileOrgKey AND 
                                        LOWER(mps.job_code) = LOWER(@JobCode) AND 
                                        LOWER(mps.position_code) = LOWER(@PositionCode);";

                        var jobMatchingInfo = await connection.QueryFirstOrDefaultAsync<JobMatchingInfo>(sql,
                                new
                                {
                                    projectVersionId,
                                    selectedJob.AggregationMethodKey,
                                    selectedJob.FileOrgKey,
                                    selectedJob.JobCode,
                                    selectedJob.PositionCode,
                                });

                        if (jobMatchingInfo is not null)
                            return jobMatchingInfo;
                    }
                }

                return new JobMatchingInfo();
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<StandardJobMatchingDto>> ListSurveyCutsDataJobs(List<string> StandardJobCodes)
        {
            _logger.LogInformation($"\nCalling Survey gRPC service to ListSurveyCutsData\n");

            var request = new SurveyCutsDataRequest
            {
                StandardJobCodes = { StandardJobCodes },
            };
            var surveyData = await _surveyClient.ListSurveyCutsDataAsync(request);

            var resutl = from data in surveyData.SurveyCutsData
                         select new StandardJobMatchingDto
                         {
                                StandardJobCode = data.StandardJobCode,
                                StandardJobTitle = data.StandardJobTitle,
                                StandardJobDescription = data.StandardJobDescription
                        };

            return resutl.ToList();
        }

        private async Task AddStandardMatchedJobs(IEnumerable<StandardJobMatchingDto> itemsToAdd, int marketPricingSheetId, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
        {
            if (itemsToAdd.Any())
            {
                _logger.LogInformation($"\nInserting new standard matched jobs for the market pricing sheet id: {marketPricingSheetId} \n");

                var modifiedDate = DateTime.UtcNow;
                foreach (var standardJob in itemsToAdd.ToList())
                {
                    var sql = $@"INSERT INTO market_pricing_sheet_job_match (
                                        market_pricing_sheet_id, 
                                        standard_job_code, 
                                        standard_job_title, 
                                        standard_job_description, 
                                        blend_percent,
                                        blend_note,
                                        modified_username,
                                        modified_utc_datetime)
                                    SELECT 
                                        @marketPricingSheetId, 
                                        @StandardJobCode, 
                                        @StandardJobTitle, 
                                        @StandardJobDescription,
                                        @BlendPercent,
                                        @BlendNote,
                                        @userObjectId,
                                        @modifiedDate;";

                    await connection.ExecuteAsync(sql,
                        new
                        {
                            marketPricingSheetId,
                            standardJob.StandardJobCode,
                            standardJob.StandardJobTitle,
                            standardJob.StandardJobDescription,
                            standardJob.BlendPercent,
                            standardJob.BlendNote,
                            userObjectId,
                            modifiedDate
                        }, transaction);
                }
            }
        }

        private async Task UpdateStandardMatchedJobs(
            IEnumerable<StandardJobMatchingDto> itemsToUpdate,
            List<StandardJobMatchingDto> standardJobs,
            int marketPricingSheetId,
            string? userObjectId,
            IDbConnection connection,
            IDbTransaction transaction)
        {
            if (itemsToUpdate.Any())
            {
                _logger.LogInformation($"\nUpdating standard matched jobs for the market pricing sheet id: {marketPricingSheetId} \n");

                var modifiedDate = DateTime.UtcNow;
                foreach (var item in itemsToUpdate.ToList())
                {
                    var standardToUpdate = standardJobs.SingleOrDefault(t => t.StandardJobCode == item.StandardJobCode && t.StandardJobTitle == item.StandardJobTitle);
                    if (standardToUpdate != null && (item.BlendNote != standardToUpdate.BlendNote ||
                        item.BlendPercent != standardToUpdate.BlendPercent ||
                        item.StandardJobDescription != standardToUpdate.StandardJobDescription))
                    {

                        var sql = $@"UPDATE market_pricing_sheet_job_match 
                                         SET 
                                            standard_job_description = @StandardJobDescription,
                                            blend_percent = @BlendPercent,
                                            blend_note = @BlendNote
                                         WHERE 
                                            market_pricing_sheet_id = @marketPricingSheetId
                                            AND LOWER(standard_job_code) = LOWER(@StandardJobCode)
                                            AND LOWER(standard_job_title) = LOWER(@StandardJobTitle);";

                        await connection.ExecuteScalarAsync(sql,
                            new
                            {
                                marketPricingSheetId,
                                item.StandardJobCode,
                                item.StandardJobTitle,
                                standardToUpdate.StandardJobDescription,
                                standardToUpdate.BlendPercent,
                                standardToUpdate.BlendNote,
                                userObjectId,
                                modifiedDate
                            }, transaction);
                    }
                }
            }
        }

        private async Task DeleteStandardMatchedJobs(IEnumerable<StandardJobMatchingDto> itemsToDelete, int marketPricingSheetId, IDbConnection connection, IDbTransaction transaction)
        {
            if (itemsToDelete.Any())
            {
                _logger.LogInformation($"\nDeleting standard matched jobs for the market pricing sheet id: {marketPricingSheetId} \n");

                foreach (var standardJob in itemsToDelete.ToList())
                {
                    var sql = $@"DELETE FROM market_pricing_sheet_job_match 
                                         WHERE market_pricing_sheet_id = @marketPricingSheetId
                                         AND LOWER(standard_job_code) = LOWER(@StandardJobCode)
                                         AND LOWER(standard_job_title) = LOWER(@StandardJobTitle);";

                    await connection.ExecuteAsync(sql,
                        new
                        {
                            marketPricingSheetId,
                            standardJob.StandardJobCode,
                            standardJob.StandardJobTitle
                        }, transaction);
                }
            }
        }

        private async Task<List<StandardJobMatchingDto>> GetStandardMatchedJobs(int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nGetting standard matched jobs for the market pricing sheet id: {marketPricingSheetId} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT standard_job_code AS StandardJobCode,
                                        standard_job_title AS StandardJobTitle,
                                        standard_job_description AS StandardJobDescription,
                                        blend_note AS BlendNote,
                                        blend_percent AS BlendPercent
                                    FROM market_pricing_sheet_job_match
                                    WHERE 
                                    market_pricing_sheet_id = @marketPricingSheetId;";

                    var matchedJobs = await connection.QueryAsync<StandardJobMatchingDto>(sql,
                            new
                            {
                                marketPricingSheetId
                            });

                    return matchedJobs.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }
    }
}
