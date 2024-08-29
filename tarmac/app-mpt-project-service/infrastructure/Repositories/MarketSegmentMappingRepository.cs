using AutoMapper;
using Cn.Incumbent;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Project.Infrastructure.Repositories;

public class MarketSegmentMappingRepository: IMarketSegmentMappingRepository
{

    protected IMapper _mapper;
    private readonly ILogger<MarketSegmentMappingRepository> _logger;
    private readonly IDBContext _mptProjectDBContext;
    private readonly Incumbent.IncumbentClient _incumbentClient;

    public MarketSegmentMappingRepository(ILogger<MarketSegmentMappingRepository> logger, 
                                          IMapper mapper,
                                          IDBContext mptProjectDBContext,
                                          Incumbent.IncumbentClient incumbentClient) 
    {
        _logger = logger;
        _mapper = mapper;
        _mptProjectDBContext = mptProjectDBContext;
        _incumbentClient = incumbentClient;
    }

    public async Task<List<MarketPricingSheet>> GetMarketPricingSheet(int projectVersionId, int aggregationMethodKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining market segments sheet for project version id: {projectVersionId} \n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                var sql = $@"SELECT ps.market_pricing_sheet_id AS Id,
                                    ps.project_version_id AS ProjectVersionId,
                                    ps.aggregation_method_key AS AggregationMethodKey,
                                    ps.ces_org_id AS CesOrgId,
                                    ps.job_code AS JobCode,
                                    ps.position_code AS PositionCode,
                                    ps.job_group AS JobGroup,
                                    ps.market_segment_id AS MarketSegmentId,
                                    ms.market_segment_name AS MarketSegmentName,
                                    ps.market_pricing_job_code AS StandardJobCode,
                                    ps.market_pricing_job_title AS StandardJobTitle,
                                    ps.market_pricing_job_description AS StandardJobDescription,
                                    ps.job_match_note AS JobMatchNote,
                                    sl.status_name AS JobMatchStatusName,
                                    sl.status_key AS JobMatchStatusKey
                            FROM market_pricing_sheet ps
                            LEFT JOIN market_segment_list ms on ms.market_segment_id = ps.market_segment_id
                            LEFT JOIN status_list sl on sl.status_key = ps.status_key
                            WHERE ps.project_version_id = @projectVersionId
                            AND aggregation_method_key = @aggregationMethodKey;";

                var marketSegmentSheet = await connection.QueryAsync<MarketPricingSheet>(sql, new { projectVersionId, aggregationMethodKey });
                return marketSegmentSheet.ToList();
            }

        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task SaveMarketSegmentMapping(int projectVersionId, MarketSegmentMappingDto marketSegmentMapping, string? userObjectId)
    {
        try
        {
            _logger.LogInformation($"\nSaving market segment mappings for project version id: {projectVersionId} and job code {marketSegmentMapping.JobCode} \n");
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                var modifiedDate = DateTime.UtcNow;
                var sql = $@"UPDATE market_pricing_sheet 
                             SET 
                                job_group = @JobGroup, 
                                market_segment_id = @MarketSegmentId,
                                modified_username = @userObjectId,
                                modified_utc_datetime = @modifiedDate
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
                                    job_group, 
                                    position_code,
                                    market_segment_id,
                                    modified_username,
                                    modified_utc_datetime)
                                SELECT 
                                    @ProjectVersionId, 
                                    @AggregationMethodKey, 
                                    @FileOrgKey, 
                                    @JobCode, 
                                    @JobGroup, 
                                    @PositionCode,
                                    @MarketSegmentId,
                                    @userObjectId,
                                    @modifiedDate
                                WHERE NOT EXISTS (
                                    SELECT 1 
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
                        marketSegmentMapping.AggregationMethodKey,
                        marketSegmentMapping.FileOrgKey,
                        marketSegmentMapping.JobCode,
                        marketSegmentMapping.JobGroup,
                        marketSegmentMapping.PositionCode,
                        marketSegmentMapping.MarketSegmentId,
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

    #region gRPC calls
    public async Task<List<JobDto>> GetSourceData(int fileLogKey, int aggregationMethodologyKey)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get source data details for file log key: {fileLogKey}\n");

            var request = new SourceDataSearchRequest() { 
                FileLogKey = fileLogKey, 
                AggregationMethodKey = aggregationMethodologyKey 
            };

            var incumbentResponse = await _incumbentClient.ListSourceDataAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<JobDto>>(incumbentResponse.ClientJobs.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
    
    public async Task<List<JobEmployeeDto>> GetSourceDataEmployeeLevel(int fileLogKey)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get source data employee level details for file log key: {fileLogKey}\n");

            var request = new SourceDataSearchRequest()
            {
                FileLogKey = fileLogKey
            };

            var incumbentResponse = await _incumbentClient.ListSourceDataEmployeeLevelAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<JobEmployeeDto>>(incumbentResponse.Employees.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }
    
    public async Task<List<JobDto>> ListClientPositionDetail(int fileLogKey, int aggregationMethodKey, string jobCode, string positionCode, int fileOrgKey)
    {
        try
        {
            _logger.LogInformation($"\nCalling Incumbent gRPC service to get source data details for file log key: {fileLogKey}\n");

            var request = new ClientJobRequest()
            {
                FileLogKey = fileLogKey,
                AggregationMethodKey = aggregationMethodKey,
                JobCode = jobCode,
                PositionCode = positionCode,
                FileOrgKey= fileOrgKey
            };

            var incumbentResponse = await _incumbentClient.ListClientPositionDetailAsync(request);

            _logger.LogInformation($"\nSuccessful service response.\n");

            return _mapper.Map<List<JobDto>>(incumbentResponse.ClientJobs.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    #endregion
}
