using AutoMapper;
using Cn.Survey;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Project.Infrastructure.Repositories
{
    public class BenchmarkDataRepository : IBenchmarkDataRepository
    {
        protected IMapper _mapper;
        private readonly ILogger<BenchmarkDataRepository> _logger;
        private readonly IDBContext _mptProjectDBContext;
        private readonly Survey.SurveyClient _surveyClient;

        public BenchmarkDataRepository(ILogger<BenchmarkDataRepository> logger,
                                       IDBContext mptProjectDBContext,
                                       IMapper mapper,
                                       Survey.SurveyClient surveyClient)
        {
            _logger = logger;
            _mptProjectDBContext = mptProjectDBContext;
            _mapper = mapper;
            _surveyClient = surveyClient;
        }

        public async Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int sourceGroupKey)
        {
            try
            {
                _logger.LogInformation($"\nCalling Survey gRPC service to get benchmkar data types for source group bey: {sourceGroupKey}\n");

                var request = new ListBenchmarkDataTypeRequest();
                request.SurveySourceGroupKey = sourceGroupKey;

                var benchmarkResponse = await _surveyClient.ListBenchmarkDataTypeAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<List<BenchmarkDataTypeDto>>(benchmarkResponse.BenchmarkDataTypes.ToList());
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<BenchmarkDataTypeDto>> ListBenchmarksFromReferenceTable()
        {
            try
            {
                _logger.LogInformation($"\nListing Benchmarks from MPT Project reference table\n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT benchmark_data_type_key AS Id,
                                        TRIM(benchmark_data_type_name) AS Name,
                                        TRIM(benchmark_data_type_long_alias) AS LongAlias,
                                        TRIM(benchmark_data_type_short_alias) AS ShortAlias,
                                        benchmark_data_type_order_override AS OrderDataType,
                                        TRIM(benchmark_data_type_format) AS Format,
                                        benchmark_data_type_format_decimal AS Decimals
                                   FROM benchmark_data_type_setup;";

                    var benchmarks = await connection.QueryAsync<BenchmarkDataTypeDto>(sql);

                    return benchmarks.ToList();
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
