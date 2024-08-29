using AutoMapper;
using Cn.Survey;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Data;
using System.Text;
using System.Web;
using Survey = Cn.Survey.Survey;

namespace CN.Project.Infrastructure.Repositories
{
    public class MarketPricingSheetRepository : IMarketPricingSheetRepository
    {
        protected IMapper _mapper;

        private readonly IDBContext _mptProjectDBContext;
        private readonly ILogger<MarketPricingSheetRepository> _logger;
        private readonly Survey.SurveyClient _surveyClient;

        public MarketPricingSheetRepository(IDBContext mptProjectDBContext, ILogger<MarketPricingSheetRepository> logger, Survey.SurveyClient surveyClient, IMapper mapper)
        {
            _mptProjectDBContext = mptProjectDBContext;
            _logger = logger;
            _surveyClient = surveyClient;
            _mapper = mapper;
        }

        public async Task<List<MarketPricingStatusDto>> GetStatus(int projectVersionId, MarketPricingSheetFilterDto filter)
        {
            _logger.LogInformation($"\nGet status for Market Pricing Sheet for Project Version id: {projectVersionId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var conditions = new List<string> { "mps.project_version_id = @projectVersionId" };
                    var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                    FillFilterConditionsAndParameters(filter, conditions, parameters);

                    var select = @"SELECT mps.status_key, TRIM(mps.job_code), TRIM(mps.job_title)";
                    var where = $"WHERE {string.Join(" AND ", conditions)}";
                    var groupBy = @"GROUP BY mps.status_key, TRIM(mps.job_code), TRIM(mps.job_title)";

                    string sql = GenerateQryUsingTheBaseQry(select, string.Empty, where, groupBy);

                    var query = $"SELECT status_key AS JobMatchStatusKey, count(status_key) AS Count FROM ({sql}) AS DATA GROUP BY status_key";

                    var statuses = await connection.QueryAsync<MarketPricingStatusDto>(query, parameters);

                    return statuses.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<IdNameDto>> GetMarketSegmentsNames(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining market segment id and names to the project version: {projectVersionId} \n");

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("@projectVersionId", projectVersionId);
                parameters.Add("@deletedStatus", (int)MarketSegmentStatus.Deleted);

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var internalSelect = @"SELECT NULL";
                    var internalWhere = @" WHERE mps.project_version_id = @projectVersionId AND	mps.market_segment_id = list.market_segment_id";
                    string internalQuery = GenerateQryUsingTheBaseQry(internalSelect, string.Empty, internalWhere, string.Empty);
                    var sql = @"SELECT
                                    market_segment_id AS Id
                                    ,market_segment_name AS Name
                                FROM market_segment_list AS list
                                WHERE
                                    market_segment_status_key <> @deletedStatus
                                    AND EXISTS
                                        ({0})";

                    var marketSegments = await connection.QueryAsync<IdNameDto>(string.Format(sql, internalQuery), parameters);
                    return marketSegments.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<string>> GetJobGroups(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Job Groups from the Market Pricing Sheet for the project version: {projectVersionId} \n");

                var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var select = @"SELECT DISTINCT TRIM(mps.job_group)";
                    var where = @"WHERE mps.project_version_id = @projectVersionId";
                    string sql = GenerateQryUsingTheBaseQry(select, string.Empty, where, string.Empty);

                    var jobGroups = await connection.QueryAsync<string>(sql, parameters);

                    return jobGroups.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<JobTitleFilterDto>> GetJobTitles(int projectVersionId, MarketPricingSheetFilterDto filter)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Job Titles from the Market Pricing Sheet for the project version: {projectVersionId} \n");

                var conditions = new List<string> { "mps.project_version_id = @projectVersionId" };
                var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };


                FillFilterConditionsAndParameters(filter, conditions, parameters, filterByStatus: true);

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var select = @"SELECT mps.market_pricing_sheet_id AS MarketPricingSheetId, 
                                          TRIM(mps.job_code) AS JobCode, 
                                          TRIM(mps.job_title) AS JobTitle,
                                          mps.market_segment_id AS MarketSegmentId,
                                          TRIM(msl.market_segment_name) AS MarketSegmentName";
                    var where = $"WHERE {string.Join(" AND ", conditions)}";
                    var groupBy = @"GROUP BY mps.market_pricing_sheet_id, mps.job_code, mps.job_title, mps.market_segment_id, msl.market_segment_name";
                    string sql = GenerateQryUsingTheBaseQry(select, string.Empty, where, groupBy);

                    var result = await connection.QueryAsync<JobTitleFilterDto>(sql, parameters);
                    return result.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<MarketPricingSheetInfoDto?> GetSheetInfo(int projectVersionId, int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining market segment info to the project version: {projectVersionId} and market pricing sheet id: {marketPricingSheetId} \n");

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                parameters.Add("@projectVersionId", projectVersionId);
                parameters.Add("@marketPricingSheetId", marketPricingSheetId);

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var qry = @"
                            SELECT 
                                MPS.market_pricing_sheet_id,
                                MPS.ces_org_id,
                                SL.status_name,
                                MPS.job_code,
                                MPS.job_title,
                                MPS.position_code,
                                MPS.ces_org_id,
                                MPS.aggregation_method_key
                            FROM 
                                market_pricing_sheet AS MPS
                                left join status_list AS SL on (SL.status_key = MPS.status_key)
                            WHERE
                                MPS.project_version_id = @projectVersionId
                                AND MPS.market_pricing_sheet_id = @marketPricingSheetId";

                    var qryResult = await connection.QueryAsync(qry, parameters);
                    var finalResult = qryResult.Select(r => new MarketPricingSheetInfoDto
                    {
                        MarketPricingSheetId = r.market_pricing_sheet_id,
                        Organization = new IdNameDto { Id = r.ces_org_id },
                        MarketPricingStatus = r.status_name != null ? r.status_name : string.Empty,
                        AggregationMethodKey = r.aggregation_method_key,
                        CesOrgId = r.ces_org_id,
                        JobCode = r.job_code,
                        JobTitle = r.job_title,
                        PositionCode = r.position_code

                    }).FirstOrDefault();

                    return finalResult;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketPricingSheet>> GetMarketPricingSheet(int projectVersionId, int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Market Pricing Sheet for id: {marketPricingSheetId} \n");

                var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId }, { "@marketPricingSheetId", marketPricingSheetId } };
                var conditions = new List<string> { "mps.project_version_id = @projectVersionId", "mps.market_pricing_sheet_id = @marketPricingSheetId" };

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var select = @"SELECT 
                                    mps.market_pricing_sheet_id AS Id,
                                    mps.project_version_id AS ProjectVersionId,
                                    mps.aggregation_method_key AS AggregationMethodKey,
                                    mps.ces_org_id AS CesOrgId,
                                    mps.job_code AS JobCode,                                    
                                    mps.job_title AS JobTitle,
                                    mps.position_code AS PositionCode,
                                    mps.job_group AS JobGroup,
                                    mps.market_segment_id AS MarketSegmentId,
                                    mpsjm.standard_job_code AS StandardJobCode,
                                    mpsjm.standard_job_title AS StandardJobTitle,
                                    mpsjm.standard_job_description AS StandardJobDescription,
                                    mps.job_match_note AS JobMatchNote,
                                    mps.publisher_key AS PublisherKey,
                                    mps.status_change_date AS StatusChangeDate";
                    var where = $"WHERE {string.Join(" AND ", conditions)}";

                    string sql = GenerateQryUsingTheBaseQry(select, string.Empty, where, string.Empty);
                    var marketPricingSheetList = await connection.QueryAsync<MarketPricingSheet>(sql, parameters);

                    return marketPricingSheetList.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketPricingSheet>> ListMarketPricingSheets(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nListing Market Pricing Sheets for Project Version id: {projectVersionId} \n");

                var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var select = @"SELECT 
                                    mps.market_pricing_sheet_id AS Id,
                                    mps.project_version_id AS ProjectVersionId,
                                    mps.aggregation_method_key AS AggregationMethodKey,
                                    mps.ces_org_id AS CesOrgId,
                                    mps.job_code AS JobCode,                                    
                                    mps.job_title AS JobTitle,
                                    mps.position_code AS PositionCode,
                                    mps.job_group AS JobGroup,
                                    mps.market_segment_id AS MarketSegmentId,
                                    mpsjm.standard_job_code AS StandardJobCode,
                                    mpsjm.standard_job_title AS StandardJobTitle,
                                    mpsjm.standard_job_description AS StandardJobDescription,
                                    mps.job_match_note AS JobMatchNote,
                                    mps.publisher_key AS PublisherKey,
                                    mps.status_change_date AS StatusChangeDate";
                    var where = $"WHERE mps.project_version_id = @projectVersionId";

                    string sql = GenerateQryUsingTheBaseQry(select, string.Empty, where, string.Empty);

                    var marketPricingSheetList = await connection.QueryAsync<MarketPricingSheet>(sql, parameters);

                    return marketPricingSheetList.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task UpdateMarketPricingStatus(int projectVersionId, int marketPricingSheetId, int marketPricingStatusKey, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nSaving market pricing status [{marketPricingStatusKey}] for project version id [{projectVersionId}] and market pricing sheet id [{marketPricingSheetId}] \n");
                using (var connection = _mptProjectDBContext.GetConnection())
                {

                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("@projectVersionId", projectVersionId);
                    parameters.Add("@marketPricingSheetId", marketPricingSheetId);
                    parameters.Add("@marketPricingStatusKey", marketPricingStatusKey);
                    parameters.Add("@userObjectId", userObjectId ?? string.Empty);
                    parameters.Add("@modifiedDate", DateTime.UtcNow);

                    var sql = $@"
                            UPDATE market_pricing_sheet 
                            SET 
                                status_key = @marketPricingStatusKey,
                                modified_username = @userObjectId,
                                status_change_date = @modifiedDate
                            WHERE 
                                project_version_id = @projectVersionId
                                AND market_pricing_sheet_id = @marketPricingSheetId;";

                    await connection.ExecuteAsync(sql, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<JobMatchingInfo> GetJobMatchDetail(int projectVersionId, int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining job match detail for project version id [{projectVersionId}] and market pricing sheet id [{marketPricingSheetId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("@projectVersionId", projectVersionId);
                    parameters.Add("@marketPricingSheetId", marketPricingSheetId);

                    string qrySelect = @"SELECT
                                            mps.job_match_note AS JobMatchNote,
                                            mps.market_pricing_job_title AS JobTitle,
                                            mps.market_pricing_job_description AS JobDescription";

                    string qryWhere = @"WHERE 
                                            mps.project_version_id = @projectVersionId
                                            AND mps.market_pricing_sheet_id = @marketPricingSheetId;";

                    string qry = GenerateQryUsingTheBaseQry(qrySelect, string.Empty, qryWhere, string.Empty);

                    var qryResult = await connection.QueryFirstOrDefaultAsync<JobMatchingInfo>(qry, parameters);
                    return qryResult;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task SaveJobMatchDetail(int projectVersionId, int marketPricingSheetId, string jobMatchNote, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nUpdating job match detail for project version id [{projectVersionId}] and market pricing sheet id [{marketPricingSheetId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("@projectVersionId", projectVersionId);
                    parameters.Add("@marketPricingSheetId", marketPricingSheetId);
                    parameters.Add("@jobMatchNote", jobMatchNote);
                    parameters.Add("@userObjectId", userObjectId ?? string.Empty);
                    parameters.Add("@modifiedDate", DateTime.UtcNow);

                    string qry = @"
                                UPDATE market_pricing_sheet
                                SET
                                    job_match_note = @jobMatchNote,
                                    modified_username = @userObjectId,
                                    modified_utc_datetime = @modifiedDate
                                WHERE 
                                    project_version_id = @projectVersionId
                                    AND market_pricing_sheet_id = @marketPricingSheetId;";

                    await connection.ExecuteAsync(qry, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<List<IdNameDto>> GetAdjusmentNoteList()
        {
            try
            {
                _logger.LogInformation($"\nObtaining adjustment note list \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var query = @"SELECT adjustment_note_key AS Id, 
                                         TRIM(adjustment_note_name) AS Name 
                                  FROM adjustment_note_list;";

                    var qryResult = await connection.QueryAsync<IdNameDto>(query);
                    return qryResult.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<List<SurveyCutDataDto>> ListSurveyCutsDataWithPercentiles(IEnumerable<int> surveyKeys, IEnumerable<int> industryKeys, IEnumerable<int> organizationTypeKeys, IEnumerable<int> cutGroupKeys,
            IEnumerable<int> cutSubGroupKeys, IEnumerable<int> cutKeys, IEnumerable<int> benchmarkDataTypeKeys, IEnumerable<string> standardJobCodes)
        {
            try
            {
                _logger.LogInformation($"\nCalling Survey gRPC service to list survey cuts data with percentiles\n");

                var request = new ListPercentilesRequest();
                request.SurveyKeys.AddRange(surveyKeys ?? Enumerable.Empty<int>());
                request.IndustrySectorKeys.AddRange(industryKeys ?? Enumerable.Empty<int>());
                request.OrganizationTypeKeys.AddRange(organizationTypeKeys ?? Enumerable.Empty<int>());
                request.CutGroupKeys.AddRange(cutGroupKeys ?? Enumerable.Empty<int>());
                request.CutSubGroupKeys.AddRange(cutSubGroupKeys ?? Enumerable.Empty<int>());
                request.CutKeys.AddRange(cutKeys ?? Enumerable.Empty<int>());
                request.BenchmarkDataTypeKeys.AddRange(benchmarkDataTypeKeys ?? Enumerable.Empty<int>());
                request.StandardJobCodes.AddRange(standardJobCodes ?? Enumerable.Empty<string>());

                var surveyResponse = await _surveyClient.ListSurveyCutsDataWithPercentilesAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<List<SurveyCutDataDto>>(surveyResponse.SurveyCutsData);

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketPricingSheetAdjustmentNoteDto>> ListAdjustmentNotesByProjectVersionId(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nListing Adjustment Notes for Project Version Id [{projectVersionId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                    var query = $@"SELECT mpss.market_pricing_sheet_survey_key AS MarketPricingSheetSurveyKey
                                        , mpss.market_pricing_sheet_id AS MarketPricingSheetId
                                        , mpss.market_segment_cut_detail_key AS MarketSegmentCutDetailKey                                        
                                        , mpss.raw_data_key AS RawDataKey
                                        , mpss.cut_external_key AS CutExternalKey
                                        , mpss.exclude_in_calc AS ExcludeInCalc 
                                        , mpss.adjustment_value AS AdjustmentValue
                                        , mpss.modified_utc_datetime AS ModifiedUtcDatetime
                                        , TRIM(anl.adjustment_note_name) AS AdjustmentNoteName
                                     FROM market_pricing_sheet_survey mpss
                               INNER JOIN market_pricing_sheet mps ON mps.market_pricing_sheet_id = mpss.market_pricing_sheet_id
                                LEFT JOIN market_pricing_sheet_adjustment_note mpsan ON mpsan.market_pricing_sheet_survey_key = mpss.market_pricing_sheet_survey_key
                                LEFT JOIN adjustment_note_list anl ON anl.adjustment_note_key = mpsan.adjustment_note_key
                                    WHERE mps.project_version_id = @projectVersionId";

                    var qryResult = await connection.QueryAsync<MarketPricingSheetAdjustmentNoteDto>(query, parameters);

                    return qryResult.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task SaveNotes(int projectVersionId, int marketPricingSheetId, string notes, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nUpdating notes for market pricing sheet id [{marketPricingSheetId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("@projectVersionId", projectVersionId);
                    parameters.Add("@marketPricingSheetId", marketPricingSheetId);
                    parameters.Add("@notes", notes);
                    parameters.Add("@userObjectId", userObjectId ?? string.Empty);
                    parameters.Add("@modifiedDate", DateTime.UtcNow);

                    string qry = @"
                                UPDATE market_pricing_sheet
                                SET
                                    market_pricing_sheet_note = @notes,
                                    modified_username = @userObjectId,
                                    modified_utc_datetime = @modifiedDate
                                WHERE 
                                    project_version_id = @projectVersionId
                                    AND market_pricing_sheet_id = @marketPricingSheetId;";

                    await connection.ExecuteAsync(qry, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<NewStringValueDto> GetNotes(int projectVersionId, int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nGetting notes for market pricing sheet id [{marketPricingSheetId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object>
                    {
                        { "@projectVersionId", projectVersionId },
                        { "@marketPricingSheetId", marketPricingSheetId }
                    };

                    string qry = @"SELECT market_pricing_sheet_note AS Value 
                                     FROM market_pricing_sheet 
                                    WHERE project_version_id = @projectVersionId
                                      AND market_pricing_sheet_id = @marketPricingSheetId;";

                    return await connection.QueryFirstOrDefaultAsync<NewStringValueDto>(qry, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<string>> GetMarketSegmentReportFilter(int projectVersionId)
        {
            _logger.LogInformation($"\nGet Cut Names for Market Segment id: {projectVersionId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT DISTINCT Name
                                    FROM (
                                      SELECT eri_cut_name || 
                                          CASE
                                            WHEN eri_adjustment_factor IS NULL THEN ''
                                            ELSE ' (' || ROUND(eri_adjustment_factor * 100, 0) || '%)'
                                          END AS Name
                                      FROM market_segment_list
                                      WHERE project_version_id = @projectVersionId
                                        AND eri_cut_name IS NOT NULL 
                                        AND eri_cut_name != ''
                                      UNION
                                      SELECT msc.market_pricing_cut_name AS Name
                                      FROM market_segment_cut msc
                                      INNER JOIN market_segment_list msl ON msl.market_segment_id = msc.market_segment_id
                                      WHERE msl.project_version_id = @projectVersionId
                                        AND msc.market_pricing_cut_name IS NOT NULL 
                                        AND msc.market_pricing_cut_name != ''
                                      UNION
                                      SELECT msca.combined_averages_name AS Name
                                      FROM market_segment_combined_averages msca
                                      INNER JOIN market_segment_list msl ON msl.market_segment_id = msca.market_segment_id
                                      WHERE msl.project_version_id = @projectVersionId
                                        AND msca.combined_averages_name IS NOT NULL 
                                        AND msca.combined_averages_name != ''
                                    ) AS combined_names
                                    ORDER by Name;";

                    var reportFilters = await connection.QueryAsync<string>(sql,
                            new { projectVersionId });

                    return reportFilters.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task SaveMainSettings(int projectVersionId, MainSettingsDto mainSettings, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nSaving main settings for project version id : {projectVersionId} \n");

                var modifiedDate = DateTime.UtcNow;
                var settingsJson = JsonConvert.SerializeObject(mainSettings);

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = @"UPDATE project_version
                                SET main_settings_json = @settingsJson::json,
                                    modified_username = @userObjectId,
                                    modified_utc_datetime = @modifiedDate
                                WHERE project_version_id = @projectVersionId";

                    await connection.ExecuteAsync(sql, new
                    {
                        projectVersionId,
                        settingsJson,
                        userObjectId,
                        modifiedDate
                    }, commandType: CommandType.Text);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<MainSettingsDto?> GetMainSettings(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nRetrieving main settings for project version id : {projectVersionId} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = @"SELECT main_settings_json
                                 FROM project_version
                                 WHERE project_version_id = @projectVersionId";

                    var serializedJson = await connection.QueryFirstOrDefaultAsync<string>(sql, new { projectVersionId });
                    return !string.IsNullOrEmpty(serializedJson)
                        ? JsonConvert.DeserializeObject<MainSettingsDto>(serializedJson)
                        : null;
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketPricingSheetAdjustmentNoteDto>> ListAdjustmentNotes(int marketPricingSheetId, int? rawDataKey, int? cutExternalKey)
        {
            try
            {
                _logger.LogInformation($"\nListing Adjustment Notes for Market Pricing Sheet Id [{SanitizeInput(marketPricingSheetId)}] and Raw Data Key [{SanitizeInput(rawDataKey)}] and Cut External Key [{SanitizeInput(cutExternalKey)}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var rawDataKeyWhere = string.Empty;
                    var cutExternalKeyWhere = string.Empty;
                    var parameters = new Dictionary<string, object> { { "@marketPricingSheetId", marketPricingSheetId } };

                    var query = @"SELECT mpss.market_pricing_sheet_survey_key AS MarketPricingSheetSurveyKey
                                       , mpss.market_pricing_sheet_id AS MarketPricingSheetId
                                       , mpss.market_segment_cut_detail_key AS MarketSegmentCutDetailKey                                        
                                       , mpss.raw_data_key AS RawDataKey
                                       , mpss.cut_external_key AS CutExternalKey
                                       , mpss.exclude_in_calc AS ExcludeInCalc 
                                       , mpss.adjustment_value AS AdjustmentValue
                                       , anl.adjustment_note_key AS AdjustmentNoteKey
                                       , TRIM(anl.adjustment_note_name) AS AdjustmentNoteName
                                   FROM
                                       market_pricing_sheet_survey mpss
                                       LEFT JOIN market_pricing_sheet_adjustment_note mpsan ON mpsan.market_pricing_sheet_survey_key = mpss.market_pricing_sheet_survey_key
                                       LEFT JOIN adjustment_note_list anl ON anl.adjustment_note_key = mpsan.adjustment_note_key
                                   WHERE 
                                       mpss.market_pricing_sheet_id = @marketPricingSheetId
                                       {0}
                                       {1}";

                    if (rawDataKey is not null)
                    {
                        rawDataKeyWhere = @" AND mpss.raw_data_key = @rawDataKey ";
                        parameters.Add("@rawDataKey", rawDataKey);
                    }
                    else
                    {
                        rawDataKeyWhere = @" AND mpss.raw_data_key IS NULL ";
                    }

                    if (cutExternalKey is not null)
                    {
                        cutExternalKeyWhere = @" AND mpss.cut_external_key = @cutExternalKey ";
                        parameters.Add("@cutExternalKey", cutExternalKey);
                    }
                    else
                    {
                        cutExternalKeyWhere = @" AND mpss.cut_external_key IS NULL ";
                    }

                    var qryResult = await connection.QueryAsync<MarketPricingSheetAdjustmentNoteDto>(string.Format(query, rawDataKeyWhere, cutExternalKeyWhere), parameters);

                    return qryResult.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task InsertAdjustmentNotes(SaveGridItemDto gridItem, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nInserting adjustment notes for raw data key : {gridItem.RawDataKey} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    connection.Open();
                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            var sql = @"INSERT INTO market_pricing_sheet_survey(
                                                    market_pricing_sheet_id, 
                                                    market_segment_cut_detail_key, 
                                                    raw_data_key,
                                                    cut_external_key,
                                                    exclude_in_calc, 
                                                    adjustment_value, 
                                                    emulated_by, 
                                                    modified_username, 
                                                    modified_utc_datetime)
                                             VALUES (
                                                    @MarketPricingSheetId, 
                                                    @MarketSegmentCutDetailKey, 
                                                    @RawDataKey,
                                                    @CutExternalKey,
                                                    @ExcludeInCalc,
                                                    @AdjustmentValue, 
                                                    @username, 
                                                    @username, 
                                                    @modifiedDate)
                                          RETURNING market_pricing_sheet_survey_key;";

                            Dictionary<string, object> parameters = new Dictionary<string, object>
                            {
                                { "@MarketPricingSheetId", gridItem.MarketPricingSheetId },
                                { "@MarketSegmentCutDetailKey", gridItem.MarketSegmentCutDetailKey! },
                                { "@RawDataKey", gridItem.RawDataKey! },
                                { "@CutExternalKey", gridItem.CutExternalKey! },
                                { "@ExcludeInCalc", gridItem.ExcludeInCalc },
                                { "@AdjustmentValue", gridItem.AdjustmentValue! },
                                { "@username", userObjectId ?? string.Empty },
                                { "@modifiedDate", DateTime.UtcNow }
                            };

                            var marketPricingSheetSurveyKey = await connection.QueryFirstOrDefaultAsync<int>(sql, parameters);

                            await InsertAdjustmentNotes(marketPricingSheetSurveyKey, gridItem.AdjustmentNotesKey, userObjectId, connection, transaction);

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

        public async Task UpdateAdjustmentNotes(SaveGridItemDto gridItem, List<MarketPricingSheetAdjustmentNoteDto> existingAdjustmentNotes, string? userObjectId)
        {
            try
            {
                _logger.LogInformation($"\nUpdating adjustment notes for raw data key [{SanitizeInput(gridItem.RawDataKey)}] and cut external key [{SanitizeInput(gridItem.CutExternalKey)}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    connection.Open();
                    using (var transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            var sql = @"UPDATE market_pricing_sheet_survey
                                        SET
                                            exclude_in_calc = @ExcludeInCalc, 
                                            adjustment_value = @AdjustmentValue, 
                                            modified_username = @username, 
                                            modified_utc_datetime = @modifiedDate
                                       WHERE {0} AND {1}
                                     RETURNING market_pricing_sheet_survey_key;";

                            Dictionary<string, object> parameters = new Dictionary<string, object>
                            {
                                { "@ExcludeInCalc", gridItem.ExcludeInCalc },
                                { "@AdjustmentValue", gridItem.AdjustmentValue! },
                                { "@username", userObjectId ?? string.Empty },
                                { "@modifiedDate", DateTime.UtcNow }
                            };
                            
                            var rawDataKeyCondition = @"raw_data_key IS NULL";
                            if (gridItem.RawDataKey is not null)
                            {
                                parameters.Add("@RawDataKey", gridItem.RawDataKey);
                                rawDataKeyCondition = @"raw_data_key = @RawDataKey";
                            }
                           
                            var cutExternalKeyCondition = @"cut_external_key IS NULL";
                            if (gridItem.CutExternalKey is not null)
                            {
                                parameters.Add("@CutExternalKey", gridItem.CutExternalKey);
                                cutExternalKeyCondition = @"cut_external_key = @CutExternalKey";
                            }
                            
                            var finalSql = string.Format(sql, rawDataKeyCondition, cutExternalKeyCondition);
                            var marketPricingSheetSurveyKey = await connection.QueryFirstOrDefaultAsync<int>(finalSql, parameters);

                            var itemsToDelete = existingAdjustmentNotes.Where(ean => ean.AdjustmentNoteKey != 0 && !gridItem.AdjustmentNotesKey.Any(an => an == ean.AdjustmentNoteKey));
                            var itemsToAdd = gridItem.AdjustmentNotesKey.Where(an => an != 0 && !existingAdjustmentNotes.Any(ean => ean.AdjustmentNoteKey == an));

                            if (itemsToDelete.Any())
                                await DeleteAdjustmentNotes(marketPricingSheetSurveyKey, itemsToDelete.Select(i => i.AdjustmentNoteKey).ToList(), userObjectId, connection, transaction);

                            if (itemsToAdd.Any())
                                await InsertAdjustmentNotes(marketPricingSheetSurveyKey, itemsToAdd.ToList(), userObjectId, connection, transaction);

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

        public async Task<UploadMarketPricingSheetPdfFileDto?> GetGeneratedFile(int projectVersionId, int? marketPricingSheetId)
        {
            try
            {
                var marketPricingSheetValue = marketPricingSheetId.HasValue ? marketPricingSheetId.Value : 0;
                _logger.LogInformation($"\nGet PDF generated for Project Version Id [{projectVersionId}] and Market Pricing Sheet Id [{marketPricingSheetValue}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId }, { "@marketPricingSheetId", marketPricingSheetValue } };

                    var query = $@"SELECT project_version_id AS ProjectVersionId
                                        , market_pricing_sheet_id AS MarketPricingSheetId
                                        , TRIM(file_s3_url) AS FileS3Url                                       
                                        , TRIM(file_s3_name) AS FileS3Name
                                        , TRIM(modified_username) AS ModifiedUsername
                                        , modified_utc_datetime AS ModifiedUtcDatetime
                                     FROM market_pricing_sheet_file 
                                    WHERE project_version_id = @projectVersionId AND market_pricing_sheet_id = @marketPricingSheetId";

                    return await connection.QueryFirstOrDefaultAsync<UploadMarketPricingSheetPdfFileDto>(query, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task SaveGeneratedFile(int projectVersionId, int? marketPricingSheetId, UploadMarketPricingSheetPdfFileDto file, string? userObjectId)
        {
            try
            {
                var marketPricingSheetValue = marketPricingSheetId.HasValue ? marketPricingSheetId.Value : 0;
                _logger.LogInformation($"\nSaving PDF generated for Project Version Id [{projectVersionId}] and Market Pricing Sheet Id [{marketPricingSheetValue}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> {
                        { "@projectVersionId", projectVersionId },
                        { "@marketPricingSheetId", marketPricingSheetValue },
                        { "@FileS3Url", file.FileS3Url.Trim() },
                        { "@FileS3Name", file.FileS3Name.Trim() },
                        { "@userObjectId", userObjectId! },
                        { "@modifiedDate", DateTime.UtcNow }
                    };

                    var sql = $@"DELETE FROM market_pricing_sheet_file WHERE project_version_id = @projectVersionId AND market_pricing_sheet_id = @marketPricingSheetId;

                             INSERT INTO market_pricing_sheet_file (
                                    project_version_id, 
                                    market_pricing_sheet_id, 
                                    file_s3_url, 
                                    file_s3_name, 
                                    modified_username,
                                    modified_utc_datetime)
                                VALUES ( 
                                    @projectVersionId, 
                                    @marketPricingSheetId, 
                                    @FileS3Url, 
                                    @FileS3Name, 
                                    @userObjectId,
                                    @modifiedDate);";

                    await connection.ExecuteScalarAsync<int>(sql, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketPricingSheetCutExternal>> ListExternalData(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nList External Data for Project Version Id [{projectVersionId}] \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                    var sql = $@"SELECT mpsce.cut_external_key AS CutExternalKey
                                      , mpsce.project_version_id AS ProjectVersionId
                                      , mpsce.market_pricing_sheet_id AS MarketPricingSheetId
                                      , TRIM(mpsce.standard_job_code) AS StandardJobCode
                                      , TRIM(mpsce.standard_job_title) AS StandardJobTitle
                                      , TRIM(mpsce.external_publisher_name) AS ExternalPublisherName
                                      , TRIM(mpsce.external_survey_name) AS ExternalSurveyName
                                      , mpsce.external_survey_year AS ExternalSurveyYear
                                      , TRIM(mpsce.external_survey_job_code) AS ExternalSurveyJobCode
                                      , TRIM(mpsce.external_survey_job_title) AS ExternalSurveyJobTitle
                                      , TRIM(mpsce.external_industry_sector_name) AS ExternalIndustrySectorName
                                      , TRIM(mpsce.external_organization_type_name) AS ExternalOrganizationTypeName
                                      , TRIM(mpsce.external_cut_group_name) AS ExternalCutGroupName
                                      , TRIM(mpsce.external_cut_sub_group_name) AS ExternalCutSubGroupName
                                      , TRIM(mpsce.external_market_pricing_cut_name) AS ExternalMarketPricingCutName
                                      , TRIM(mpsce.external_survey_cut_name) AS ExternalSurveyCutName
                                      , mpsce.external_survey_effective_date AS ExternalSurveyEffectiveDate
                                      , mpsce.incumbent_count AS IncumbentCount
                                      , mpsced.cut_external_data_key AS CutExternalDataKey
                                      , mpsced.cut_external_key AS CutExternalKey
                                      , mpsced.benchmark_data_type_key AS BenchmarkDataTypeKey
                                      , mpsced.benchmark_data_type_value AS BenchmarkDataTypeValue
                                      , mpsced.percentile_number AS PercentileNumber
                                   FROM market_pricing_sheet_cut_external mpsce
                             INNER JOIN market_pricing_sheet_cut_external_data mpsced ON mpsced.cut_external_key = mpsce.cut_external_key
                                  WHERE mpsce.project_version_id = @projectVersionId;";

                    var queryResult = await connection.QueryAsync<MarketPricingSheetCutExternal, MarketPricingSheetCutExternalData, MarketPricingSheetCutExternal>(sql,
                        (cutExternal, cutExternalData) =>
                        {
                            cutExternal.Benchmarks.Add(cutExternalData);

                            return cutExternal;
                        },
                        parameters,
                        splitOn: "CutExternalDataKey"
                    );

                    return queryResult?
                        .GroupBy(r => r.CutExternalKey)
                        .Select(group =>
                        {
                            var groupedResult = group.First();

                            groupedResult.Benchmarks = group.Select(p => p.Benchmarks.Single()).ToList();

                            return groupedResult;
                        })
                        .ToList() ?? new List<MarketPricingSheetCutExternal>();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private string GenerateQryUsingTheBaseQry(string qrySelect, string qryFrom, string qryWhere, string qryGroupBy)
        {
            string baseFrom = @"FROM market_pricing_sheet mps
                                JOIN market_pricing_sheet_job_match mpsjm ON mpsjm.market_pricing_sheet_id = mps.market_pricing_sheet_id
                           LEFT JOIN market_segment_list msl ON msl.market_segment_id = mps.market_segment_id";

            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine(qrySelect);
            stringBuilder.AppendLine(baseFrom);
            stringBuilder.AppendLine(qryFrom);
            stringBuilder.AppendLine(qryWhere);
            stringBuilder.AppendLine(qryGroupBy);

            return stringBuilder.ToString();
        }

        private void FillFilterConditionsAndParameters(MarketPricingSheetFilterDto filter, List<string> conditions, Dictionary<string, object> parameters, bool filterByStatus = false)
        {
            if (!string.IsNullOrEmpty(filter.ClientJobCodeTitle))
            {
                conditions.Add($"(LOWER(mps.job_title) LIKE '%' || LOWER(@ClientJobCodeTitle) || '%' OR LOWER(mps.job_code) LIKE '%' || LOWER(@ClientJobCodeTitle) || '%')");
                parameters.Add("@ClientJobCodeTitle", filter.ClientJobCodeTitle);
            }

            if (filter.JobMatchingStatus.HasValue && filterByStatus)
            {
                var marketPricingStatusKey = (int)filter.JobMatchingStatus.Value;

                conditions.Add("mps.status_key = @marketPricingStatusKey");
                parameters.Add("@marketPricingStatusKey", marketPricingStatusKey);
            }

            if (filter.MarketSegmentList.Any())
            {
                var marketSegmentKeys = new List<string>();

                for (int i = 0; i < filter.MarketSegmentList.Count; i++)
                {
                    parameters.Add($"@market_segment_id_{i}", filter.MarketSegmentList[i].Id);
                    marketSegmentKeys.Add($"@market_segment_id_{i}");
                }

                conditions.Add($"mps.market_segment_id IN ({string.Join(", ", marketSegmentKeys)})");
            }

            if (filter.ClientJobGroupList.Any())
            {
                var clientJobGroupKeys = new List<string>();

                for (int j = 0; j < filter.ClientJobGroupList.Count; j++)
                {
                    var paramName = $"@job_group_{j}";
                    var paramValue = $"{filter.ClientJobGroupList[j]}";
                    parameters.Add(paramName, paramValue);
                    clientJobGroupKeys.Add($"LOWER(mps.job_group) LIKE '%' || LOWER({paramName}) || '%'");
                }

                conditions.Add($"({string.Join(" OR ", clientJobGroupKeys)})");
            }
        }

        private async Task InsertAdjustmentNotes(int marketPricingSheetSurveyKey, List<int> adjustmentNoteKeys, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var sql = @"INSERT INTO market_pricing_sheet_adjustment_note(
                                        market_pricing_sheet_survey_key, 
                                        adjustment_note_key, 
                                        emulated_by, 
                                        modified_username, 
                                        modified_utc_datetime)
                                 VALUES (
                                        @marketPricingSheetSurveyKey, 
                                        @adjustmentNoteKey, 
                                        @username, 
                                        @username, 
                                        @modifiedDate);";

                foreach (var parameters in from adjustmentNoteKey in adjustmentNoteKeys
                                           let parameters = new Dictionary<string, object>
                                           {
                                               { "@marketPricingSheetSurveyKey", marketPricingSheetSurveyKey },
                                               { "@adjustmentNoteKey", adjustmentNoteKey },
                                               { "@username", userObjectId ?? string.Empty },
                                               { "@modifiedDate", DateTime.UtcNow }
                                           }
                                           select parameters)
                {
                    await connection.ExecuteAsync(sql, parameters, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task DeleteAdjustmentNotes(int marketPricingSheetSurveyKey, List<int> adjustmentNoteKeys, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {

                var sql = @"DELETE FROM market_pricing_sheet_adjustment_note WHERE market_pricing_sheet_survey_key = @marketPricingSheetSurveyKey AND adjustment_note_key = @adjustmentNoteKey";

                foreach (var parameters in from adjustmentNoteKey in adjustmentNoteKeys
                                           let parameters = new Dictionary<string, object>
                                           {
                                               { "@marketPricingSheetSurveyKey", marketPricingSheetSurveyKey },
                                               { "@adjustmentNoteKey", adjustmentNoteKey }
                                           }
                                           select parameters)
                {
                    await connection.ExecuteAsync(sql, parameters, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task SaveMarketPricingExternalData(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternalData, string? userObjectId)
        {
            _logger.LogInformation($"\nInsert cut external rows for project version id: {projectVersionId} \n");

            if (cutExternalData is null || !cutExternalData.Any())
            {
                _logger.LogError($"\nNo existing external data for project id: {projectVersionId}\n");
                return;
            }

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        await InsertCutExternalRowsIntoTemporaryTable(projectVersionId, cutExternalData, connection, transaction);
                        await removeDuplicateExternalDetails(projectVersionId, connection, transaction);
                        await removeDuplicateExternalRows(projectVersionId, connection, transaction);
                        await InsertCutExternalRows(projectVersionId, userObjectId, connection, transaction);
                        await InsertCutExternalDetails(projectVersionId, userObjectId, connection, transaction);
                        // Drop the temporary table
                        await connection.ExecuteAsync("DROP TABLE temp_market_pricing_sheet_cut_external;", transaction);

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

        private async Task removeDuplicateExternalRows(int projectVersionId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                _logger.LogInformation($"\nRemove duplicate external for project version id: {projectVersionId} \n");
                var qry = @"DELETE FROM market_pricing_sheet_cut_external AS MPSCE
                            WHERE
                                EXISTS
                                    (
                                        SELECT NULL
                                        FROM temp_market_pricing_sheet_cut_external AS TMPSCE
                                        WHERE
                                            {0}
                                    );";
                var conditions = getConditionsToValidateDuplicateOnTemp();
                var finalQry = string.Format(qry, conditions);
                await connection.ExecuteAsync(finalQry, transaction);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task removeDuplicateExternalDetails(int projectVersionId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                _logger.LogInformation($"\nRemove duplicate external details for project version id: {projectVersionId} \n");
                var qry = @"DELETE FROM market_pricing_sheet_cut_external_data AS MPSCED
                            WHERE
                                EXISTS
                                    (
                                        SELECT NULL
                                        FROM 
                                            market_pricing_sheet_cut_external AS MPSCE
                                            INNER JOIN temp_market_pricing_sheet_cut_external AS TMPSCE ON
                                                (
                                                    {0}
                                                )
                                        WHERE
                                            MPSCED.cut_external_key = MPSCE.cut_external_key
                                    );";
                var conditions = getConditionsToValidateDuplicateOnTemp();
                var finalQry = string.Format(qry, conditions);
                await connection.ExecuteAsync(finalQry, transaction);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private string getConditionsToValidateDuplicateOnTemp()
        {
            var conditions = @"
                    MPSCE.project_version_id = TMPSCE.project_version_id
                    AND MPSCE.market_pricing_sheet_id = TMPSCE.market_pricing_sheet_id
                    AND MPSCE.standard_job_code = TMPSCE.standard_job_code
                    AND MPSCE.standard_job_title = TMPSCE.standard_job_title
                    AND MPSCE.external_industry_sector_name = TMPSCE.external_industry_sector_name
                    AND MPSCE.external_organization_type_name = TMPSCE.external_organization_type_name
                    AND MPSCE.external_cut_group_name = TMPSCE.external_cut_group_name
                    AND MPSCE.external_cut_sub_group_name = TMPSCE.external_cut_sub_group_name
                    AND MPSCE.external_market_pricing_cut_name = TMPSCE.external_market_pricing_cut_name
                    AND MPSCE.external_survey_effective_date = TMPSCE.external_survey_effective_date
                    AND MPSCE.external_publisher_name = TMPSCE.external_publisher_name
                    AND MPSCE.external_survey_name = TMPSCE.external_survey_name
                    AND MPSCE.external_survey_job_code = TMPSCE.external_survey_job_code
                    AND MPSCE.external_survey_job_title = TMPSCE.external_survey_job_title
                    AND MPSCE.external_survey_cut_name = TMPSCE.external_survey_cut_name
            ";
            return conditions;
        }

        private async Task InsertCutExternalRows(int projectVersionId, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                _logger.LogInformation($"\nInsert or update market pricing sheet rows for project version id: {projectVersionId}\n");
                var modifiedDate = DateTime.UtcNow;


                var sql = $@"INSERT INTO market_pricing_sheet_cut_external (
                                project_version_id,
                                market_pricing_sheet_id,
                                standard_job_code,
                                standard_job_title,
                                external_publisher_name,
                                external_survey_name,
                                external_survey_year,
                                external_survey_job_code,
                                external_survey_job_title,
                                external_industry_sector_name,
                                external_organization_type_name,
                                external_cut_group_name,
                                external_cut_sub_group_name,
                                external_market_pricing_cut_name,
                                external_survey_cut_name,
                                external_survey_effective_date,
                                incumbent_count,
                                modified_username,
                                modified_utc_datetime
                            )
                            SELECT
                                project_version_id,
                                market_pricing_sheet_id,
                                standard_job_code,
                                standard_job_title,
                                external_publisher_name,
                                external_survey_name,
                                external_survey_year,
                                external_survey_job_code,
                                external_survey_job_title,
                                external_industry_sector_name,
                                external_organization_type_name,
                                external_cut_group_name,
                                external_cut_sub_group_name,
                                external_market_pricing_cut_name,
                                external_survey_cut_name,
                                external_survey_effective_date,
                                incumbent_count,
                                @userObjectId,
                                @modifiedDate
                            FROM temp_market_pricing_sheet_cut_external AS tmsce
                            WHERE NOT EXISTS (
                                SELECT 1 
                                FROM market_pricing_sheet_cut_external AS mpce
                                WHERE 
                                    tmsce.project_version_id = mpce.project_version_id AND
                                    tmsce.market_pricing_sheet_id = mpce.market_pricing_sheet_id AND 
                                    tmsce.standard_job_code = mpce.standard_job_code AND
                                    tmsce.standard_job_title = mpce.standard_job_title AND 
                                    tmsce.external_publisher_name = mpce.external_publisher_name AND
                                    tmsce.external_survey_name = mpce.external_survey_name AND                                    
                                    tmsce.external_survey_year = mpce.external_survey_year AND
                                    tmsce.external_survey_job_code = mpce.external_survey_job_code AND
                                    tmsce.external_survey_job_title = mpce.external_survey_job_title AND
                                    tmsce.external_industry_sector_name = mpce.external_industry_sector_name AND
                                    tmsce.external_organization_type_name = mpce.external_organization_type_name AND
                                    tmsce.external_cut_group_name = mpce.external_cut_group_name AND
                                    tmsce.external_cut_sub_group_name = mpce.external_cut_sub_group_name AND
                                    tmsce.external_market_pricing_cut_name = mpce.external_market_pricing_cut_name AND
                                    tmsce.external_survey_cut_name = mpce.external_survey_cut_name AND
                                    tmsce.external_survey_effective_date = mpce.external_survey_effective_date AND
                                    tmsce.incumbent_count = mpce.incumbent_count
                            )
                            GROUP BY
                                tmsce.project_version_id,
                                tmsce.market_pricing_sheet_id,
                                tmsce.standard_job_code,
                                tmsce.standard_job_title,
                                tmsce.external_publisher_name,
                                tmsce.external_survey_name,
                                tmsce.external_survey_year,
                                tmsce.external_survey_job_code,
                                tmsce.external_survey_job_title,
                                tmsce.external_industry_sector_name,
                                tmsce.external_organization_type_name,
                                tmsce.external_cut_group_name,
                                tmsce.external_cut_sub_group_name,
                                tmsce.external_market_pricing_cut_name,
                                tmsce.external_survey_cut_name,
                                tmsce.external_survey_effective_date,
                                tmsce.incumbent_count;";

                await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        userObjectId,
                        modifiedDate,
                    }, transaction);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task InsertCutExternalDetails(int projectVersionId, string? userObjectId, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                _logger.LogInformation($"\nInsert or update market pricing sheet rows for project version id: {projectVersionId}\n");
                var modifiedDate = DateTime.UtcNow;


                var sql = $@"INSERT INTO market_pricing_sheet_cut_external_data (
                                cut_external_key,
                                benchmark_data_type_key,
                                benchmark_data_type_value,
                                percentile_number,
                                modified_username,
                                modified_utc_datetime
                            )
                            SELECT
                                mpce.cut_external_key,
                                tmsce.benchmark_data_type_key,
                                tmsce.benchmark_data_type_value,
                                tmsce.percentile_number,
                                @userObjectId,
                                @modifiedDate
                            FROM temp_market_pricing_sheet_cut_external AS tmsce
                            INNER JOIN market_pricing_sheet_cut_external AS mpce on 
                                    tmsce.project_version_id = mpce.project_version_id AND
                                    ((tmsce.market_pricing_sheet_id IS NULL AND mpce.market_pricing_sheet_id IS NULL) OR
                                    tmsce.market_pricing_sheet_id = mpce.market_pricing_sheet_id) AND
                                    tmsce.standard_job_code = mpce.standard_job_code AND
                                    tmsce.standard_job_title = mpce.standard_job_title AND 
                                    tmsce.external_publisher_name = mpce.external_publisher_name AND
                                    tmsce.external_survey_name = mpce.external_survey_name AND
                                    tmsce.external_survey_year = mpce.external_survey_year AND
                                    tmsce.external_survey_job_code = mpce.external_survey_job_code AND
                                    tmsce.external_survey_job_title = mpce.external_survey_job_title AND
                                    tmsce.external_industry_sector_name = mpce.external_industry_sector_name AND
                                    tmsce.external_organization_type_name = mpce.external_organization_type_name AND
                                    tmsce.external_cut_group_name = mpce.external_cut_group_name AND
                                    tmsce.external_cut_sub_group_name = mpce.external_cut_sub_group_name AND
                                    tmsce.external_market_pricing_cut_name = mpce.external_market_pricing_cut_name AND
                                    tmsce.external_survey_cut_name = mpce.external_survey_cut_name AND
                                    tmsce.external_survey_effective_date = mpce.external_survey_effective_date AND
                                    tmsce.incumbent_count = mpce.incumbent_count;";

                await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        userObjectId,
                        modifiedDate,
                    }, transaction);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task InsertCutExternalRowsIntoTemporaryTable(int projectVersionId, List<MarketPricingSheetCutExternalDto> data, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                _logger.LogInformation($"\nInsert market pricing sheet cut external rows in temporary table for project version id: {projectVersionId}\n");

                // Create a temporary table
                await connection.ExecuteAsync($@"CREATE TEMPORARY TABLE temp_market_pricing_sheet_cut_external (
                                                    project_version_id INT,
                                                    market_pricing_sheet_id INT,
                                                    standard_job_code VARCHAR(100),
                                                    standard_job_title VARCHAR(100),
                                                    external_publisher_name VARCHAR(100),
                                                    external_survey_name VARCHAR(100),
                                                    external_survey_year INT,
                                                    external_survey_job_code VARCHAR(100),
                                                    external_survey_job_title VARCHAR(100),
                                                    external_industry_sector_name VARCHAR(100),
                                                    external_organization_type_name VARCHAR(100),
                                                    external_cut_group_name VARCHAR(100),
                                                    external_cut_sub_group_name VARCHAR(100),
                                                    external_market_pricing_cut_name VARCHAR(100),
                                                    external_survey_cut_name VARCHAR(100),
                                                    external_survey_effective_date TIMESTAMP WITHOUT TIME ZONE,
                                                    incumbent_count INT,
                                                    benchmark_data_type_key INT,
                                                    benchmark_data_type_value DECIMAL(18,6),
                                                    percentile_number INT);", transaction);

                var sql = @"INSERT INTO temp_market_pricing_sheet_cut_external (
                                project_version_id,
                                market_pricing_sheet_id,
                                standard_job_code,
                                standard_job_title,
                                external_publisher_name,
                                external_survey_name,
                                external_survey_year,
                                external_survey_job_code,
                                external_survey_job_title,
                                external_industry_sector_name,
                                external_organization_type_name,
                                external_cut_group_name,
                                external_cut_sub_group_name,
                                external_market_pricing_cut_name,
                                external_survey_cut_name,
                                external_survey_effective_date,
                                incumbent_count,
                                benchmark_data_type_key,
                                benchmark_data_type_value,
                                percentile_number)
                            VALUES
                                {0}";

                var batchSize = 300;
                Dictionary<string, object> parameters;

                for (int i = 0; i < data.Count; i += batchSize)
                {
                    var values = GenerateQueryValues(data, i, batchSize);
                    var finalQuery = string.Format(sql, string.Join(",", values));

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

        private Dictionary<string, object> GetQueryParameters(List<MarketPricingSheetCutExternalDto> data, int projectVersionId, int start, int batchSize)
        {
            var result = new Dictionary<string, object>();

            for (int i = start; i < batchSize + start; i++)
            {
                if (i > data.Count() - 1)
                    break;

                result.Add($"@value_project_version_{i}", projectVersionId);
                result.Add($"@value_market_pricing_sheet_id_{i}", data[i].MarketPricingSheetId!);
                result.Add($"@value_standard_job_code_{i}", data[i].StandardJobCode!);
                result.Add($"@value_standard_job_title_{i}", data[i].StandardJobTitle!);
                result.Add($"@value_external_publisher_name_{i}", data[i].ExternalPublisherName!);
                result.Add($"@value_external_survey_name_{i}", data[i].ExternalSurveyName!);
                result.Add($"@value_external_survey_year_{i}", data[i].ExternalSurveyYear!);
                result.Add($"@value_external_survey_job_code_{i}", data[i].ExternalSurveyJobCode!);
                result.Add($"@value_external_survey_job_title_{i}", data[i].ExternalSurveyJobTitle!);
                result.Add($"@value_external_industry_sector_name_{i}", data[i].ExternalIndustrySectorName!);
                result.Add($"@value_external_organization_type_name_{i}", data[i].ExternalOrganizationTypeName!);
                result.Add($"@value_external_cut_group_name_{i}", data[i].ExternalCutGroupName!);
                result.Add($"@value_external_cut_sub_group_name_{i}", data[i].ExternalCutSubGroupName!);
                result.Add($"@value_external_market_pricing_cut_name_{i}", data[i].ExternalMarketPricingCutName!);
                result.Add($"@value_external_survey_effective_date_{i}", data[i].ExternalSurveyEffectiveDate!);
                result.Add($"@value_external_survey_cut_name_{i}", data[i].ExternalSurveyCutName!);
                result.Add($"@value_incumbent_count_{i}", data[i].IncumbentCount!);
                result.Add($"@value_benchmark_data_type_key_{i}", data[i].BenchmarkDataTypeKey!);
                result.Add($"@value_benchmark_data_type_value_{i}", data[i].BenchmarkDataTypeValue!);
                result.Add($"@value_percentile_number_{i}", data[i].PercentileNumber!);
            }

            return result;
        }

        private List<string> GenerateQueryValues(List<MarketPricingSheetCutExternalDto> data, int start, int batchAmount)
        {
            var result = new List<string>();
            for (int i = start; i < batchAmount + start; i++)
            {
                if (i > data.Count() - 1)
                    break;

                result.Add($@"(@value_project_version_{i},
                               @value_market_pricing_sheet_id_{i},
                               @value_standard_job_code_{i},
                               @value_standard_job_title_{i},
                               @value_external_publisher_name_{i},
                               @value_external_survey_name_{i},
                               @value_external_survey_year_{i},
                               @value_external_survey_job_code_{i},
                               @value_external_survey_job_title_{i},
                               @value_external_industry_sector_name_{i},
                               @value_external_organization_type_name_{i},
                               @value_external_cut_group_name_{i},
                               @value_external_cut_sub_group_name_{i},
                               @value_external_market_pricing_cut_name_{i},
                               @value_external_survey_cut_name_{i},
                               @value_external_survey_effective_date_{i},
                               @value_incumbent_count_{i},
                               @value_benchmark_data_type_key_{i},
                               @value_benchmark_data_type_value_{i},
                               @value_percentile_number_{i})");
            }
            return result;
        }

        private string SanitizeInput(object? imput)
        {
            var result = "";
            if (imput is not null)
                result = HttpUtility.HtmlEncode(imput);
            return result;
        }
    }
}