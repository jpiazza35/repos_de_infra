using AutoMapper;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Enum;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Incumbent.Infrastructure.Repositories;

public class SourceDataRepository : ISourceDataRepository
{
    private readonly IDBContext _incumbentDBContext;
    private readonly ILogger<SourceDataRepository> _logger;
    protected IMapper _mapper;

    public SourceDataRepository(IDBContext incumbentDBContext, ILogger<SourceDataRepository> logger, IMapper mapper)
    {
        _incumbentDBContext = incumbentDBContext;
        _logger = logger;
        _mapper = mapper;
    }

    public async Task<IList<SourceData>> ListSourceData(int fileLogKey, int aggregationMethodKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file details by file log key: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = $@"SELECT sd.source_data_aggr_key AS SourceDataAgregationKey, 
                                aggregation_method_key AS AggregationMethodKey, 
                                file_log_key AS FileLogKey,
                                file_org_key AS FileOrgKey,
                                ces_org_id AS CesOrgId, 
                                TRIM(job_code) AS JobCode, 
                                TRIM(job_title) AS JobTitle, 
                                incumbent_count AS IncumbentCount, 
                                fte_value AS FteValue, 
                                TRIM(location_description) AS LocationDescription, 
                                TRIM(job_family) AS JobFamily, 
                                TRIM(pay_grade) AS PayGrade, 
                                TRIM(pay_type) AS PayType, 
                                TRIM(position_code) AS PositionCode, 
                                TRIM(position_code_description) AS PositionCodeDescription, 
                                TRIM(job_level) AS JobLevel,
                                TRIM(client_job_group) AS ClientJobGroup,
                                STRING_AGG(det.benchmark_data_type_key || ':' || det.benchmark_data_type_value, ';') AS BenchmarkDataTypeList
                            FROM source_data_aggr sd
                            LEFT JOIN source_data_aggr_detail det ON det.source_data_aggr_key = sd.source_data_aggr_key 
                            WHERE file_log_key = @fileLogKey
                            AND aggregation_method_key = @aggregationMethodKey
                            GROUP BY SourceDataAgregationKey,
                                        aggregation_method_key,
                                        FileLogKey, 
                                        FileOrgKey, 
                                        CesOrgId, 
                                        JobCode, 
                                        JobTitle,
                                        incumbent_count,
                                        FteValue,
                                        LocationDescription,
                                        JobFamily,
                                        PayGrade,
                                        PositionCode,
                                        PositionCodeDescription,
                                        JobLevel";

                var results = await connection.QueryAsync<SourceData>(sql,
                    new
                    {
                        fileLogKey,
                        aggregationMethodKey
                    });

                foreach (var item in results)
                {
                    if (!string.IsNullOrEmpty(item.BenchmarkDataTypeList))
                    {
                        var groupPairs = item.BenchmarkDataTypeList.Split(';')
                                        .Select(pairString => pairString.Split(':'))
                                        .ToDictionary(pairArray => int.Parse(pairArray[0]), pairArray => pairArray[1] != null ? float.Parse(pairArray[1]) : (float?)null);

                        item.BenchmarkDataTypes = groupPairs;
                    }
                }

                return results.ToList();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<SourceDataEmployeeLevel>> ListSourceDataEmployeeLevel(int fileLogKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file details as employee level by file log key: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = GetQrySourceDataEmployeeLevel();

                var parameters = new Dictionary<string, object> { { "@fileLogKey", fileLogKey } };
                var qryResult = await connection.QueryAsync(sql, parameters);

                List<SourceDataEmployeeLevel> result = QryResultToSourceDataEmployeeLevel(qryResult);

                return result;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");
            throw;
        }
    }

    public async Task<IList<SourceData>> ListClientJobs(int fileLogKey, int aggregationMethodKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining file details by file log key: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = $@"SELECT 
                                file_log_key AS FileLogKey,
                                aggregation_method_key AS AggregationMethodKey, 
                                file_org_key AS FileOrgKey,
                                ces_org_id AS CesOrgId,
                                TRIM(job_code) AS JobCode, 
                                TRIM(job_title) AS JobTitle, 
                                TRIM(position_code) AS PositionCode, 
                                TRIM(client_job_group) AS ClientJobGroup
                            FROM source_data_aggr sd
                            WHERE file_log_key = @fileLogKey
                            AND aggregation_method_key = @aggregationMethodKey;";

                var results = await connection.QueryAsync<SourceData>(sql,
                    new
                    {
                        fileLogKey,
                        aggregationMethodKey
                    });

                return results.ToList();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<IEnumerable<SourceData>> ListClientBasePay(int fileLogKey, int aggregationMethodKey, IEnumerable<string> jobCodes, IEnumerable<int> benchmarkDataTypeKeys)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Client Base Pay by file log key: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var jobCodeList = string.Join(",", jobCodes.Select(code => string.Format("'{0}'", code)));
                var benchmarkDataTypeKeyList = string.Join(", ", benchmarkDataTypeKeys);
                var sql = $@"SELECT TRIM(sdg.job_code) AS JobCode,
                                    sdad.benchmark_data_type_key AS BenchmarkDataTypeKey,
                                    sdad.benchmark_data_type_value AS BenchmarkDataTypeValue
                               FROM source_data_aggr sdg
                               JOIN source_data_aggr_detail sdad ON sdg.source_data_aggr_key = sdad.source_data_aggr_key
                              WHERE sdg.aggregation_method_key = @aggregationMethodKey 
                                AND sdg.file_log_key = @fileLogKey
                                AND sdg.job_code IN ({jobCodeList})
                                AND sdad.benchmark_data_type_key IN ({benchmarkDataTypeKeyList})";

                var results = await connection.QueryAsync<SourceData>(sql,
                    new
                    {
                        aggregationMethodKey,
                        fileLogKey
                    });

                return results;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<IEnumerable<SourceData>> ListClientPayDetail(int fileLogKey, int fileOrgKey, int aggregationMethodKey, string jobCode, string positionCode, IEnumerable<int> benchmarkDataTypeKeys)
    {
        try
        {
            _logger.LogInformation($"\nObtaining Client Pay Detail by file log key: {fileLogKey} \n");

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var benchmarkDataTypeKeyList = string.Join(", ", benchmarkDataTypeKeys);
                var filterCondition = (int)AggregationMethodology.Parent == aggregationMethodKey
                    ? " AND sda.file_org_key = @fileOrgKey"
                    : " AND sda.ces_org_id = @fileOrgKey";

                var where = "sda.position_code = @positionCode";

                if (string.IsNullOrEmpty(positionCode))
                {
                    where = "(sda.position_code = @positionCode or sda.position_code is null)";
                }

                var sql = $@"SELECT sdad.benchmark_data_type_key AS BenchmarkDataTypeKey, 
                                   sdad.benchmark_data_type_value AS BenchmarkDataTypeValue
                                FROM source_data_aggr_detail sdad
                                INNER JOIN source_data_aggr sda on sda.source_data_aggr_key = sdad.source_data_aggr_key
                                WHERE sda.file_log_key = @fileLogKey
                                    AND sda.job_code = @jobCode
                                    AND {where}
                                    AND sda.aggregation_method_key = @aggregationMethodKey
                                    AND sdad.benchmark_data_type_key IN ({benchmarkDataTypeKeyList})
                                    {filterCondition};";

                var results = await connection.QueryAsync<SourceData>(sql,
                    new
                    {
                        fileLogKey,
                        fileOrgKey,
                        aggregationMethodKey,
                        jobCode,
                        positionCode
                    });

                return results;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    public async Task<List<SourceData>> ListClientPositionDetail(int fileLogKey, int aggregationMethodKey, string jobCode, string positionCode, int fileOrgKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining client job detail for file id: {fileLogKey} and job code: {jobCode} \n");

            var filterCondition = (int)AggregationMethodology.Parent == aggregationMethodKey
                    ? " AND file_org_key = @fileOrgKey"
                    : " AND ces_org_id = @fileOrgKey";

            using (var connection = _incumbentDBContext.GetIncumbentConnection())
            {
                var sql = $@"SELECT aggregation_method_key AS AggregationMethodKey, 
                                file_log_key AS FileLogKey,
                                file_org_key AS FileOrgKey,
                                ces_org_id AS CesOrgId, 
                                TRIM(job_code) AS JobCode, 
                                TRIM(job_title) AS JobTitle, 
                                incumbent_count AS IncumbentCount, 
                                fte_value AS FteValue, 
                                TRIM(location_description) AS LocationDescription, 
                                TRIM(job_family) AS JobFamily, 
                                TRIM(pay_grade) AS PayGrade, 
                                TRIM(pay_type) AS PayType, 
                                TRIM(position_code) AS PositionCode, 
                                TRIM(position_code_description) AS PositionCodeDescription, 
                                TRIM(job_level) AS JobLevel,
                                TRIM(client_job_group) AS ClientJobGroup
                            FROM source_data_aggr
                            WHERE file_log_key = @fileLogKey
                            AND aggregation_method_key = @aggregationMethodKey
                            AND job_code = @jobCode
                            AND COALESCE(position_code, '') = @positionCode
                            {filterCondition};";

                var result = await connection.QueryAsync<SourceData>(sql,
                    new
                    {
                        fileLogKey,
                        aggregationMethodKey,
                        jobCode,
                        positionCode,
                        fileOrgKey
                    });

                return result.ToList();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }

    #region private methods
    private string GetQrySourceDataEmployeeLevel()
    {
        var sql = $@"
                            SELECT
	                            PARENT.Source_Data_Key,
	                            PARENT.File_Log_Key,
	                            PARENT.Source_Data_Name,
	                            PARENT.File_Org_Key,
	                            PARENT.Ces_Org_Id,
	                            PARENT.Ces_Org_Name,
	                            PARENT.Job_Code,
	                            PARENT.Job_Title,
	                            PARENT.Incumbent_Id,
	                            PARENT.Incumbent_Name,
	                            PARENT.Fte_Value,
	                            PARENT.Client_Job_Group,
	                            PARENT.Position_Code,
	                            PARENT.Position_Code_Description,
	                            PARENT.Job_Level,
                                PARENT.credited_yoe,
                                PARENT.original_hire_date,
	                            CHILD.benchmark_data_type_key,
	                            CHILD.benchmark_data_type_value
                            FROM 
	                            source_data AS PARENT
	                            LEFT JOIN 
		                            (
			                            SELECT
				                            source_data_key,
				                            benchmark_data_type_key,
				                            benchmark_data_type_value
			                            FROM
				                            source_data_detail
			                            WHERE
				                            benchmark_data_type_key IS NOT NULL
				                            AND benchmark_data_type_value IS NOT NULL
		                            ) AS CHILD ON CHILD.source_data_key = PARENT.source_data_key 
                            WHERE 
	                            PARENT.file_log_key = @fileLogKey";

        return sql;
    }

    private List<SourceDataEmployeeLevel> QryResultToSourceDataEmployeeLevel(IEnumerable<dynamic> QryResult)
    {
        List<SourceDataEmployeeLevel> result = (from item in QryResult
                                                group new { item.benchmark_data_type_key, item.benchmark_data_type_value }
                                                by new
                                                {
                                                    item.source_data_key,
                                                    item.file_log_key,
                                                    item.source_data_name,
                                                    item.file_org_key,
                                                    item.ces_org_id,
                                                    item.ces_org_name,
                                                    item.job_code,
                                                    item.job_title,
                                                    item.incumbent_id,
                                                    item.incumbent_name,
                                                    item.fte_value,
                                                    item.client_job_group,
                                                    item.position_code,
                                                    item.position_code_description,
                                                    item.job_level,
                                                    item.credited_yoe,
                                                    item.original_hire_date
                                                } into g
                                                select new SourceDataEmployeeLevel
                                                {
                                                    SourceDataKey = g.Key.source_data_key,
                                                    FileLogKey = g.Key.file_log_key,
                                                    SourceDataName = g.Key.source_data_name,
                                                    FileOrgKey = g.Key.file_org_key,
                                                    CesOrgId = g.Key.ces_org_id,
                                                    CesOrgName = g.Key.ces_org_name,
                                                    JobCode = g.Key.job_code,
                                                    JobTitle = g.Key.job_title,
                                                    IncumbentId = g.Key.incumbent_id,
                                                    IncumbentName = g.Key.incumbent_name,
                                                    FteValue = (float)g.Key.fte_value,
                                                    ClientJobGroup = g.Key.client_job_group,
                                                    PositionCode = g.Key.position_code,
                                                    PositionCodeDescription = g.Key.position_code_description,
                                                    JobLevel = g.Key.job_level,
                                                    CreditedYoe = g.Key.credited_yoe,
                                                    OriginalHireDate = g.Key.original_hire_date,
                                                    BenchmarkDataTypes = g.Select(x => new KeyValuePair<int, float>(x.benchmark_data_type_key, (float)x.benchmark_data_type_value)).ToDictionary(x => x.Key, x => x.Value)
                                                }).ToList();

        return result;
    }
    #endregion
}
