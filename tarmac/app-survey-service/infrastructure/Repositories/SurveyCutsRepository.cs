using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Data.Common;
using System.Data.Odbc;

namespace CN.Survey.Infrastructure.Repositories
{
    public class SurveyCutsRepository : ISurveyCutsRepository
    {
        private readonly IConfiguration _configuration;
        private readonly IDBContext _benchmarkDBContext;
        private readonly ILogger<SurveyCutsRepository> _logger;
        private readonly string _catalog;
        private readonly string _mdmCatalog;

        private int NUMBER_OF_YEARS_BACK = 3;
        private int TIMEOUT_LIMIT_SECONDS = 120;

        public SurveyCutsRepository(IConfiguration configuration, IDBContext benchmarkDBContext, ILogger<SurveyCutsRepository> logger)
        {
            _configuration = configuration;
            _benchmarkDBContext = benchmarkDBContext;
            _logger = logger;

            _catalog = _configuration["SurveyDataBricks_Catalog"] ?? throw new ArgumentNullException("SurveyDataBricks_Catalog");
            _mdmCatalog = _configuration["SurveyDataBricks_MdmCatalog"] ?? throw new ArgumentNullException("SurveyDataBricks_MdmCatalog");
        }

        public async Task<SurveyCutFilterOptionsListResponse> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList Survey Cut Filter Options\n");

                var years = GetYears(request.YearsBack);
                var sql = @$"SELECT * 
                             FROM {_catalog}.survey_cuts_filter_options
                             WHERE survey_year IN ({string.Join(", ", years)})";

                var result = new SurveyCutFilterOptionsListResponse();
                await RunDataBricksQuery(
                    sql,
                    (DbDataReader reader) => AddRowToSurveyCutFilterOptionsListResponse(reader, result)
                );

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<SurveyCutFilterFlatOption>> ListSurveyCutFilterFlatOptions(SurveyCutFilterFlatOptionsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList Survey Cut Filter Flat Options\n");

                var filterOptions = new List<SurveyCutFilterFlatOption>();
                var sql = GetQueryForSurveyCutFilterFlatOptions(request);

                if (string.IsNullOrEmpty(sql))
                    return filterOptions;

                await RunDataBricksQuery(
                    sql,
                    (DbDataReader reader) => AddRowToSurveyCutFilterOptionsFlatListResponse(reader, filterOptions)
                );

                return filterOptions.Where(r => !string.IsNullOrEmpty(r.Name));
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCuts(SurveyCutsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList Survey Cuts\n");

                var result = new SurveyCutsDataListResponse();
                var sql = @"
                SELECT DISTINCT survey_key
                              , survey_year
                              , survey_name
                              , survey_publisher_key
                              , survey_publisher_name
                              , industry_sector_key
                              , industry_sector_name
                              , cut_key
                              , cut_name
                              , cut_group_key  
                              , cut_group_name
                              , cut_sub_group_key
                              , cut_sub_group_name
                              , organization_type_key
                              , organization_type_name
                         FROM {0}.survey_cuts_data
                          {1}
                ";
                var conditions = new List<string>();
                var conditionStartingCount = conditions.Count;
                var years = GetYears();

                conditions = GetSurveyCutsDataConditions(request);

                var where = conditions.Count > conditionStartingCount ? $"WHERE {string.Join(" AND ", conditions)}" : string.Empty;

                if (string.IsNullOrEmpty(where))
                    return result;

                await RunDataBricksQuery(
                    string.Format(sql, _catalog, where),
                    (DbDataReader reader) =>
                    {
                        var surveyYear = GetIntValue(reader["survey_year"].ToString());

                        if (surveyYear is not null && years.Contains(surveyYear.Value))
                        {
                            var surveyCutData = new SurveyCutsDataResponse
                            {
                                SurveyKey = GetIntValue(reader["survey_key"].ToString()),
                                SurveyYear = surveyYear.Value,
                                SurveyName = reader["survey_name"].ToString(),
                                SurveyPublisherKey = GetIntValue(reader["survey_publisher_key"].ToString()),
                                SurveyPublisherName = reader["survey_publisher_name"].ToString(),
                                IndustrySectorKey = GetIntValue(reader["industry_sector_key"].ToString()),
                                IndustrySectorName = reader["industry_sector_name"].ToString(),
                                CutKey = GetIntValue(reader["cut_key"].ToString()),
                                CutName = reader["cut_name"].ToString(),
                                CutSubGroupKey = GetIntValue(reader["cut_sub_group_key"].ToString()),
                                CutSubGroupName = reader["cut_sub_group_name"].ToString(),
                                OrganizationTypeKey = GetIntValue(reader["organization_type_key"].ToString()),
                                OrganizationTypeName = reader["organization_type_name"].ToString(),
                                CutGroupKey = GetIntValue(reader["cut_group_key"].ToString()),
                                CutGroupName = reader["cut_group_name"].ToString(),
                            };

                            result.SurveyCutsData.Add(surveyCutData);
                        }
                    }
                );

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCuts()
        {
            try
            {
                _logger.LogInformation($"\nList Survey Cuts\n");

                var result = new SurveyCutsDataListResponse();
                var years = GetYears();
                var sql = $@"
                SELECT DISTINCT survey_key
                              , survey_year
                              , survey_name
                              , survey_publisher_key
                              , survey_publisher_name
                              , industry_sector_key
                              , industry_sector_name
                              , cut_key
                              , cut_name
                              , cut_group_key  
                              , cut_group_name
                              , cut_sub_group_key
                              , cut_sub_group_name
                              , organization_type_key
                              , organization_type_name
                         FROM {_catalog}.survey_cuts_data
                        WHERE survey_year IN ({string.Join(", ", years)})
                ";

                await RunDataBricksQuery(
                    sql,
                    (DbDataReader reader) =>
                    {
                        var surveyCutData = new SurveyCutsDataResponse
                        {
                            SurveyKey = GetIntValue(reader["survey_key"].ToString()),
                            SurveyYear = GetIntValue(reader["survey_year"].ToString()) ?? 0,
                            SurveyName = reader["survey_name"].ToString(),
                            SurveyPublisherKey = GetIntValue(reader["survey_publisher_key"].ToString()),
                            SurveyPublisherName = reader["survey_publisher_name"].ToString(),
                            IndustrySectorKey = GetIntValue(reader["industry_sector_key"].ToString()),
                            IndustrySectorName = reader["industry_sector_name"].ToString(),
                            CutKey = GetIntValue(reader["cut_key"].ToString()),
                            CutName = reader["cut_name"].ToString(),
                            CutSubGroupKey = GetIntValue(reader["cut_sub_group_key"].ToString()),
                            CutSubGroupName = reader["cut_sub_group_name"].ToString(),
                            OrganizationTypeKey = GetIntValue(reader["organization_type_key"].ToString()),
                            OrganizationTypeName = reader["organization_type_name"].ToString(),
                            CutGroupKey = GetIntValue(reader["cut_group_key"].ToString()),
                            CutGroupName = reader["cut_group_name"].ToString(),
                        };

                        result.SurveyCutsData.Add(surveyCutData);
                    }
                );

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request)
        {
            var sql = @"
                SELECT DISTINCT scd.standard_job_code, scd.standard_job_title, scd.standard_job_description
                FROM {0}.survey_cuts_data scd
                JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code
                {2}
            ";
            var conditions = GetListSurveyCutDataFilterConditions(request);
            var where = $"WHERE {string.Join(" AND ", conditions)}";

            var result = new SurveyCutsDataListResponse();
            await RunDataBricksQuery(
               string.Format(sql, _catalog, _mdmCatalog, where),
               (DbDataReader reader) =>
               {
                   var surveyCutData = new StandardJobResponse
                   {
                       StandardJobDescription = reader["standard_job_description"].ToString(),
                       StandardJobCode = reader["standard_job_code"].ToString(),
                       StandardJobTitle = reader["standard_job_title"].ToString(),
                   };

                   result.StandardJobs.Add(surveyCutData);
               }
           );

            return result;
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request)
        {
            var sql = @"
                SELECT DISTINCT survey_publisher_key, survey_publisher_name
                FROM {0}.survey_cuts_data scd
                JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code
                {2}
            ";
            var conditions = GetListSurveyCutDataFilterConditions(request);
            var where = $"WHERE {string.Join(" AND ", conditions)}";

            var result = new SurveyCutsDataListResponse();
            await RunDataBricksQuery(
               string.Format(sql, _catalog, _mdmCatalog, where),
               (DbDataReader reader) =>
               {
                   var key = GetIntValue(reader["survey_publisher_key"].ToString());
                   var name = reader["survey_publisher_name"].ToString();
                   if (key is not null && name is not null)
                   {
                       var publisher = new PublisherResponse
                       {
                           PublisherKey = key.Value,
                           PublisherName = name
                       };
                       result.Publishers.Add(publisher);
                   }
               }
           );

            return result;
        }

        /// <summary>
        /// This call receives a PublisherKey and a list of standardJobCodes as filters. Return a list of survey jobs
        /// </summary>
        /// <param name="request">PublihserKey and StandardJobCodes</param>
        /// <returns>List of survey jobs based on the filters</returns>
        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataJobs(SurveyCutsDataRequest request)
        {
            // The filter MAX(survey_key) it's because for the same survey_specialty_code and survey_year
            // could be more than 1 row with different survey keys
            var sql = @"
                SELECT DISTINCT 
                scd.survey_specialty_code,
                scd.survey_specialty_name,
                scd.survey_description,
                scd.survey_year
                FROM {0}.survey_cuts_data AS s
                JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code
                {2}

                AND (scd.survey_specialty_code, scd.survey_year) IN (
                    SELECT scd2.survey_specialty_code, MAX(scd2.survey_year)
                    FROM {0}.survey_cuts_data scd2
                    JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd2.survey_specialty_code
                        {3}
                        AND scd2.survey_specialty_code = scd.survey_specialty_code
                        GROUP BY scd2.survey_specialty_code
                        HAVING MAX(scd2.survey_year) = scd.survey_year
                        AND MAX(scd2.survey_key) = scd.survey_specialty_code)
            ";
            var conditions = GetListSurveyCutDataFilterConditions(request);
            var where = $"WHERE {string.Join(" AND ", conditions)}";
            var internalWehere = where.Replace("scd.", "scd2.");

            var result = new SurveyCutsDataListResponse();
            await RunDataBricksQuery(
               string.Format(sql, _catalog, where, internalWehere),
               (DbDataReader reader) =>
               {
                   var survey = new SurveyJobResponse
                   {
                       SurveyJobCode = reader["survey_specialty_code"].ToString(),
                       SurveyJobTitle = reader["survey_specialty_name"].ToString(),
                       SurveyJobDescription = reader["survey_description"].ToString(),
                       SurveyYear = reader["survey_year"].ToString()
                   };
                   result.SurveyJobs.Add(survey);
               }
           );

            return result;
        }

        public async Task<IEnumerable<MarketPercentileSet>> ListPercentiles(SurveyCutsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList Percentiles\n");

                var sql = @"SELECT market_value_by_percentile FROM {0}.survey_cuts_data scd JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code {2}";
                var result = new List<MarketPercentileSet>();
                var conditionStartingCount = 0;
                var conditions = GetSurveyCutsDataForPercentileConditions(request);

                var where = conditions.Count > conditionStartingCount ? $"WHERE {string.Join(" AND ", conditions)}" : string.Empty;

                if (string.IsNullOrEmpty(where))
                    return result;

                await RunDataBricksQuery(
                    string.Format(sql, _catalog, _mdmCatalog, where),
                    (DbDataReader reader) =>
                    {
                        var rawValue = reader["market_value_by_percentile"].ToString();

                        if (!string.IsNullOrEmpty(rawValue))
                        {
                            var marketPercentileList = JsonConvert.DeserializeObject<List<MarketPercentileSet>>(rawValue) ?? new List<MarketPercentileSet>();

                            result.AddRange(marketPercentileList);
                        }
                    }
                );

                return result.Where(p => p.MarketValue.HasValue);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<MarketPercentileSet>> ListAllPercentilesByStandardJobCode(SurveyCutsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList All Percentiles by Standard Job Code\n");

                var result = new List<MarketPercentileSet>();

                if (request.StandardJobCodes is null
                    || !request.StandardJobCodes.Any()
                    || request.BenchmarkDataTypeKeys is null
                    || !request.BenchmarkDataTypeKeys.Any())
                {
                    return result;
                }

                var notEmptyValues = request.StandardJobCodes.Where(c => !string.IsNullOrEmpty(c)).ToList();

                if (!notEmptyValues.Any())
                    return result;

                var jobCodeList = string.Join(", ", notEmptyValues.Select(code => "'" + code + "'"));
                var years = GetYears();

                var sql = $@"SELECT market_value_by_percentile 
                               FROM {_catalog}.survey_cuts_data scd
                               JOIN {_mdmCatalog}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code
                              WHERE cut_group_name = 'National'
                                AND sm.standard_specialty_code IN ({string.Join(", ", jobCodeList)})
                                AND benchmark_data_type_key IN ({string.Join(", ", request.BenchmarkDataTypeKeys)})
                                AND scd.survey_year IN ({string.Join(", ", years)})";

                await RunDataBricksQuery(
                    sql,
                    (DbDataReader reader) =>
                    {
                        var rawValue = reader["market_value_by_percentile"].ToString();

                        if (!string.IsNullOrEmpty(rawValue))
                        {
                            var marketPercentileList = JsonConvert.DeserializeObject<List<MarketPercentileSet>>(rawValue) ?? new List<MarketPercentileSet>();

                            result.AddRange(marketPercentileList);
                        }
                    }
                );

                return result.Where(p => p.MarketValue.HasValue);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<SurveyCutsDataListResponse> ListSurveyCutsDataWithPercentiles(SurveyCutsRequest request)
        {
            try
            {
                _logger.LogInformation($"\nList Survey Cuts Data With Percentiles\n");

                var sql = @"SELECT DISTINCT raw_data_key AS RawDataKey 
                                          , survey_key AS SurveyKey
                                          , scd.survey_year AS SurveyYear
                                          , TRIM(survey_name) AS SurveyName
                                          , TRIM(survey_code) AS SurveyCode
                                          , survey_publisher_key AS SurveyPublisherKey
                                          , TRIM(survey_publisher_name) AS SurveyPublisherName
                                          , industry_sector_key AS IndustrySectorKey
                                          , industry_sector_name AS IndustrySectorName
                                          , organization_type_key AS OrganizationTypeKey
                                          , TRIM(organization_type_name) AS OrganizationTypeName
                                          , cut_group_key AS CutGroupKey
                                          , TRIM(cut_group_name) AS CutGroupName
                                          , cut_sub_group_key AS CutSubGroupKey
                                          , TRIM(cut_sub_group_name) AS CutSubGroupName
                                          , cut_key AS CutKey
                                          , TRIM(cut_name) AS CutName
                                          , benchmark_data_type_key AS BenchmarkDataTypeKey
                                          , TRIM(benchmark_data_type_name) AS BenchmarkDataTypeName
                                          , TRIM(standard_job_code) AS StandardJobCode
                                          , TRIM(standard_job_title) AS StandardJobTitle
                                          , TRIM(scd.survey_specialty_code) AS SurveySpecialtyCode
                                          , TRIM(scd.survey_specialty_name) AS SurveySpecialtyName
                                          , provider_count AS ProviderCount
                                          , footer_notes AS FooterNotes
                                          , survey_data_effective_date AS SurveyDataEffectiveDate
                                          , market_value_by_percentile AS MarketValueByPercentile
                                          FROM {0}.survey_cuts_data scd
                                          JOIN {1}.specialty_mapping sm ON sm.survey_specialty_code = scd.survey_specialty_code
                                          {2}";
                var result = new SurveyCutsDataListResponse();
                var conditions = GetSurveyCutsDataWithPercentilesConditions(request);

                var where = $"WHERE {string.Join(" AND ", conditions)}";

                await RunDataBricksQuery(
                    string.Format(sql, _catalog, _mdmCatalog, where),
                    (DbDataReader reader) =>
                    {
                        var data = new SurveyCutsDataResponse
                        {
                            RawDataKey = GetIntValue(reader["RawDataKey"].ToString()),
                            SurveyYear = GetIntValue(reader["SurveyYear"].ToString()) ?? 0,
                            SurveyPublisherKey = GetIntValue(reader["SurveyPublisherKey"].ToString()),
                            SurveyPublisherName = reader["SurveyPublisherName"].ToString(),
                            SurveyKey = GetIntValue(reader["SurveyKey"].ToString()),
                            SurveyName = reader["SurveyName"].ToString(),
                            SurveyCode = reader["SurveyCode"].ToString(),
                            IndustrySectorKey = GetIntValue(reader["IndustrySectorKey"].ToString()),
                            IndustrySectorName = reader["IndustrySectorName"].ToString(),
                            OrganizationTypeKey = GetIntValue(reader["OrganizationTypeKey"].ToString()),
                            OrganizationTypeName = reader["OrganizationTypeName"].ToString(),
                            CutGroupKey = GetIntValue(reader["CutGroupKey"].ToString()),
                            CutGroupName = reader["CutGroupName"].ToString(),
                            CutSubGroupKey = GetIntValue(reader["CutSubGroupKey"].ToString()),
                            CutSubGroupName = reader["CutSubGroupName"].ToString(),
                            CutKey = GetIntValue(reader["CutKey"].ToString()),
                            CutName = reader["CutName"].ToString(),
                            BenchmarkDataTypeKey = GetIntValue(reader["BenchmarkDataTypeKey"].ToString()),
                            BenchmarkDataTypeName = reader["BenchmarkDataTypeName"].ToString(),
                            StandardJobCode = reader["StandardJobCode"].ToString(),
                            StandardJobTitle = reader["StandardJobTitle"].ToString(),
                            SurveySpecialtyCode = reader["SurveySpecialtyCode"].ToString(),
                            SurveySpecialtyName = reader["SurveySpecialtyName"].ToString(),
                            ProviderCount = GetIntValue(reader["SurveySpecialtyName"].ToString()) ?? 0,
                            FooterNotes = reader["FooterNotes"].ToString(),
                            SurveyDataEffectiveDate = GetDateValue(reader["SurveyDataEffectiveDate"].ToString()),
                            MarketValueByPercentile = GetMarketValueByPercentile(reader["MarketValueByPercentile"].ToString()),
                        };

                        result.SurveyCutsData.Add(data);
                    }
                );

                return result;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task RunDataBricksQuery(string sql, Action<DbDataReader> rowHandler)
        {
            // Official documentation to install the ODBC Driver:
            // https://docs.databricks.com/integrations/jdbc-odbc-bi.html

            // This arcticle helped to troubleshoot connection issues:
            //https://stackoverflow.com/questions/75586420/connecting-to-azure-databricks-from-asp-net-using-odbc-driver

            using (var connection = _benchmarkDBContext.GetDataBricksConnection())
            {
                var command = new OdbcCommand(sql, connection);

                command.CommandTimeout = TIMEOUT_LIMIT_SECONDS;
                connection.Open();

                var reader = await command.ExecuteReaderAsync();

                while (reader.Read()) rowHandler(reader);
                reader.Close();
                command.Dispose();
            }
        }

        private void AddRowToSurveyCutFilterOptionsListResponse(DbDataReader reader, SurveyCutFilterOptionsListResponse result)
        {
            var rawData = reader["survey_publisher_name_key_sets"].ToString();
            if (!string.IsNullOrEmpty(rawData))
            {
                var surveyYears = JsonConvert.DeserializeObject<IEnumerable<SurveyYearResponse>>(rawData) ?? new List<SurveyYearResponse>();

                result.SurveyYears.AddRange(surveyYears);
            }
        }

        private string GetQueryForSurveyCutFilterFlatOptions(SurveyCutFilterFlatOptionsRequest request)
        {
            var years = GetYears();
            var selectStatement = string.Empty;
            var whereClause = $"WHERE survey_year IN ({string.Join(", ", years)})";
            var groupByClause = string.Empty;
            var tableName = $"{_catalog}.survey_cuts_distinct_filter_flat";

            switch (request)
            {
                case { Publisher: true }:
                    selectStatement = ConstructSelectStatement("survey_publisher_name", "survey_publisher_key");
                    groupByClause = "GROUP BY TRIM(survey_publisher_name)";
                    break;
                case { Survey: true }:
                    selectStatement = ConstructSelectStatement("survey_name", "survey_key");
                    groupByClause = "GROUP BY TRIM(survey_name)";
                    break;
                case { Industry: true }:
                    selectStatement = ConstructSelectStatement("industry_sector_name", "industry_sector_key");
                    groupByClause = "GROUP BY TRIM(industry_sector_name)";
                    break;
                case { Organization: true }:
                    selectStatement = ConstructSelectStatement("organization_type_name", "organization_type_key");
                    groupByClause = "GROUP BY TRIM(organization_type_name)";
                    break;
                case { CutGroup: true }:
                    selectStatement = ConstructSelectStatement("cut_group_name", "cut_group_key");
                    groupByClause = "GROUP BY TRIM(cut_group_name)";
                    break;
                case { CutSubGroup: true }:
                    if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
                        whereClause += $" AND cut_group_key IN ({string.Join(", ", request.CutGroupKeys)})";

                    selectStatement = ConstructSelectStatement("cut_sub_group_name", "cut_sub_group_key");
                    groupByClause = "GROUP BY TRIM(cut_sub_group_name)";
                    break;
                default:
                    break;
            }

            if (string.IsNullOrEmpty(selectStatement))
                return string.Empty;

            return $"{selectStatement} FROM {tableName} {whereClause} {groupByClause} ORDER BY Name";
        }

        private string ConstructSelectStatement(string columnName, string keyColumnName)
        {
            return $@"SELECT TRIM({columnName}) AS Name, array_join(collect_set({keyColumnName}), ',') AS FilterKeys";
        }

        private void AddRowToSurveyCutFilterOptionsFlatListResponse(DbDataReader reader, List<SurveyCutFilterFlatOption> result)
        {
            var name = reader["Name"].ToString();
            var filterKeys = reader["FilterKeys"].ToString();

            var filterOption = new SurveyCutFilterFlatOption
            {
                Name = name,
                Keys = filterKeys?.Split(',').ToList().Select(fk => int.Parse(fk)).Distinct() ?? Enumerable.Empty<int>()
            };

            result.Add(filterOption);
        }

        private List<int> GetYears(int? yearsBack = null)
        {
            var today = DateTime.UtcNow;
            var years = new List<int>();

            if (yearsBack is null || yearsBack == 0)
                yearsBack = NUMBER_OF_YEARS_BACK;

            for (int i = 0; i < yearsBack; i++)
            {
                years.Add(today.AddYears(-i).Year);
            }

            return years;
        }

        private int? GetIntValue(string? rawValue)
        {
            try
            {
                return string.IsNullOrEmpty(rawValue) ? null : Int32.Parse(rawValue);
            }
            catch
            {
                return null;
            }
        }

        private DateTime GetDateValue(string? rawValue)
        {
            try
            {
                return string.IsNullOrEmpty(rawValue) ? DateTime.MinValue : DateTime.Parse(rawValue);
            }
            catch
            {
                return DateTime.MinValue;
            }
        }

        private List<MarketPercentileSet> GetMarketValueByPercentile(string? rawValue)
        {
            return JsonConvert.DeserializeObject<List<MarketPercentileSet>>(rawValue ?? string.Empty) ?? new List<MarketPercentileSet>();
        }

        private List<string> GetListSurveyCutDataFilterConditions(SurveyCutsDataRequest request)
        {
            var conditions = new List<string>();

            if (request.SurveyYears is not null && request.SurveyYears.Any())
            {
                conditions.Add($"scd.survey_year IN ({string.Join(", ", request.SurveyYears)})");
            }
            else
            {
                var years = GetYears();
                conditions.Add($"scd.survey_year IN ({string.Join(", ", years)})");
            }
            if (request.CutKeys is not null && request.CutKeys.Any())
            {
                conditions.Add($"cut_key IN ({string.Join(", ", request.CutKeys)})");
            }
            if (request.BenchmarkDataTypeNames is not null && request.BenchmarkDataTypeNames.Any())
            {
                conditions.Add($"benchmark_data_type_name IN ({string.Join(", ", request.BenchmarkDataTypeNames)})");
            }
            if (request.BenchmarkDataTypeKeys is not null && request.BenchmarkDataTypeKeys.Any())
            {
                conditions.Add($"benchmark_data_type_key IN ({string.Join(", ", request.BenchmarkDataTypeKeys)})");
            }
            if (request.StandardJobCodes is not null && request.StandardJobCodes.Any())
            {
                var notEmptyValues = request.StandardJobCodes.Where(c => !string.IsNullOrEmpty(c)).ToList();

                if (notEmptyValues.Any())
                {
                    var jobCodeList = string.Join(", ", notEmptyValues.Select(code => "'" + code + "'"));
                    conditions.Add($"sm.standard_specialty_code IN ({string.Join(", ", jobCodeList)})");
                }
            }
            if (!string.IsNullOrEmpty(request.StandardJobDescription))
            {
                conditions.Add($"standard_job_description = '{request.StandardJobDescription}'");
            }
            if (!string.IsNullOrEmpty(request.SurveyJobDescription))
            {
                conditions.Add($"survey_job_description = '{request.SurveyJobDescription}'");
            }
            if (!string.IsNullOrEmpty(request.StandardJobSearch))
            {
                conditions.Add($@"(LOWER(sm.standard_specialty_code) LIKE '%{request.StandardJobSearch.Trim().ToLower()}%' OR 
                                   LOWER(standard_job_title) LIKE '%{request.StandardJobSearch.Trim().ToLower()}%' OR 
                                   LOWER(standard_job_description) LIKE '%{request.StandardJobSearch.Trim().ToLower()}%')");
            }
            if (request.PublisherKey is not null)
            {
                conditions.Add($"survey_publisher_key = {request.PublisherKey.Value}");
            }

            return conditions;
        }

        private List<string> GetSurveyCutsDataConditions(SurveyCutsRequest request)
        {
            var conditions = new List<string>();

            if (request.SurveyYears is not null && request.SurveyYears.Any())
            {
                conditions.Add($"survey_year IN ({string.Join(", ", request.SurveyYears)})");
            }
            if (request.SurveyPublisherKeys is not null && request.SurveyPublisherKeys.Any())
            {
                conditions.Add($"survey_publisher_key IN ({string.Join(", ", request.SurveyPublisherKeys)})");
            }
            if (request.SurveyKeys is not null && request.SurveyKeys.Any())
            {
                conditions.Add($"survey_key IN ({string.Join(", ", request.SurveyKeys)})");
            }
            if (request.IndustrySectorKeys is not null && request.IndustrySectorKeys.Any())
            {
                conditions.Add($"industry_sector_key IN ({string.Join(", ", request.IndustrySectorKeys)})");
            }
            if (request.OrganizationTypeKeys is not null && request.OrganizationTypeKeys.Any())
            {
                conditions.Add($"organization_type_key IN ({string.Join(", ", request.OrganizationTypeKeys)})");
            }
            if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
            {
                conditions.Add($"cut_group_key IN ({string.Join(", ", request.CutGroupKeys)})");
            }
            if (request.CutSubGroupKeys is not null && request.CutSubGroupKeys.Any())
            {
                conditions.Add($"cut_sub_group_key IN ({string.Join(", ", request.CutSubGroupKeys)})");
            }

            return conditions;
        }

        private List<string> GetSurveyCutsDataForPercentileConditions(SurveyCutsRequest request)
        {
            var conditions = new List<string>();

            if (request.IndustrySectorKeys is not null && request.IndustrySectorKeys.Any())
            {
                conditions.Add($"industry_sector_key IN ({string.Join(", ", request.IndustrySectorKeys)})");
            }
            else
            {
                conditions.Add($"industry_sector_key IS NULL");
            }
            if (request.OrganizationTypeKeys is not null && request.OrganizationTypeKeys.Any())
            {
                conditions.Add($"organization_type_key IN ({string.Join(", ", request.OrganizationTypeKeys)})");
            }
            else
            {
                conditions.Add($"organization_type_key IS NULL");
            }
            if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
            {
                conditions.Add($"cut_group_key IN ({string.Join(", ", request.CutGroupKeys)})");
            }
            else
            {
                conditions.Add($"cut_group_key IS NULL");
            }
            if (request.CutSubGroupKeys is not null && request.CutSubGroupKeys.Any())
            {
                conditions.Add($"cut_sub_group_key IN ({string.Join(", ", request.CutSubGroupKeys)})");
            }
            else
            {
                conditions.Add($"cut_sub_group_key IS NULL");
            }
            if (request.StandardJobCodes is not null && request.StandardJobCodes.Any())
            {
                var notEmptyValues = request.StandardJobCodes.Where(c => !string.IsNullOrEmpty(c)).ToList();
                if (notEmptyValues.Any())
                {
                    var jobCodeList = string.Join(", ", notEmptyValues.Select(code => "'" + code + "'"));
                    conditions.Add($"sm.standard_specialty_code IN ({string.Join(", ", jobCodeList)})");
                }
            }
            if (request.BenchmarkDataTypeKeys is not null && request.BenchmarkDataTypeKeys.Any())
            {
                conditions.Add($"benchmark_data_type_key IN ({string.Join(", ", request.BenchmarkDataTypeKeys)})");
            }

            return conditions;
        }

        private List<string> GetSurveyCutsDataWithPercentilesConditions(SurveyCutsRequest request)
        {
            var conditions = new List<string>();

            if (request.SurveyKeys is not null && request.SurveyKeys.Any())
            {
                conditions.Add($"(survey_key IN ({string.Join(", ", request.SurveyKeys)}) OR survey_key IS NULL)");
            }
            if (request.IndustrySectorKeys is not null && request.IndustrySectorKeys.Any())
            {
                conditions.Add($"(industry_sector_key IN ({string.Join(", ", request.IndustrySectorKeys)}) OR industry_sector_key IS NULL)");
            }
            if (request.OrganizationTypeKeys is not null && request.OrganizationTypeKeys.Any())
            {
                conditions.Add($"(organization_type_key IN ({string.Join(", ", request.OrganizationTypeKeys)}) OR organization_type_key IS NULL)");
            }
            if (request.CutGroupKeys is not null && request.CutGroupKeys.Any())
            {
                conditions.Add($"(cut_group_key IN ({string.Join(", ", request.CutGroupKeys)}) OR cut_group_key IS NULL)");
            }
            if (request.CutSubGroupKeys is not null && request.CutSubGroupKeys.Any())
            {
                conditions.Add($"(cut_sub_group_key IN ({string.Join(", ", request.CutSubGroupKeys)}) OR cut_sub_group_key IS NULL)");
            }
            if (request.CutKeys is not null && request.CutKeys.Any())
            {
                conditions.Add($"cut_key IN ({string.Join(", ", request.CutKeys)})");
            }
            if (request.StandardJobCodes is not null && request.StandardJobCodes.Any())
            {
                var notEmptyValues = request.StandardJobCodes.Where(c => !string.IsNullOrEmpty(c)).ToList();
                if (notEmptyValues.Any())
                {
                    var jobCodeList = string.Join(", ", notEmptyValues.Select(code => "'" + code + "'"));
                    conditions.Add($"sm.standard_specialty_code IN ({jobCodeList})");
                }
            }
            if (request.BenchmarkDataTypeKeys is not null && request.BenchmarkDataTypeKeys.Any())
            {
                conditions.Add($"benchmark_data_type_key IN ({string.Join(", ", request.BenchmarkDataTypeKeys)})");
            }

            return conditions;
        }
    }
}