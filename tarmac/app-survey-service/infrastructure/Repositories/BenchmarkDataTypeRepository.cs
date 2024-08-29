using CN.Survey.Domain;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Survey.Infrastructure.Repositories;

public class BenchmarkDataTypeRepository : IBenchmarkDataTypeRepository
{
    private readonly IDBContext _benchmarkDBContext;
    private readonly ILogger<BenchmarkDataTypeRepository> _logger;

    public BenchmarkDataTypeRepository(IDBContext benchmarkDBContext, ILogger<BenchmarkDataTypeRepository> logger)
    {
        _benchmarkDBContext = benchmarkDBContext;
        _logger = logger;
    }

    public async Task<List<BenchmarkDataType>?> GetBenchmarkDataTypes(int sourceGroupKey)
    {
        try
        {
            _logger.LogInformation($"\nObtaining benchmark data types for source group key: {sourceGroupKey} \n");

            using (var connection = _benchmarkDBContext.GetConnection())
            {
                var sql = @"SELECT 
                               c.benchmark_data_type_key        AS ID
                             , TRIM(c.benchmark_data_type_Name) AS Name
                             , a.Aging_Factor_Default           AS AgingFactor
                             , a.Benchmark_Data_Type_Default    AS DefaultDataType
                             , c.Benchmark_Data_Type_Order      AS OrderDataType

                             FROM benchmark_data_type_source_group a
                             INNER JOIN survey_source_group b on a.survey_source_group_key = b.survey_source_group_key
                             INNER JOIN  benchmark_data_type c on c.benchmark_data_type_key = a.benchmark_data_type_key
                             WHERE b.survey_source_group_key = @sourceGroupKey
                             ORDER BY c.benchmark_data_type_Name";

                var benchmarkDataTypes = await connection.QueryAsync<BenchmarkDataType>(sql, new { sourceGroupKey });
                return benchmarkDataTypes?.ToList();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}
