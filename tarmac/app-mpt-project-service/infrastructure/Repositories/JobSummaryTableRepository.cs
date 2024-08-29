using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Text;

namespace CN.Project.Infrastructure.Repositories
{
    public class JobSummaryTableRepository : IJobSummaryTableRepository
    {
        private readonly IDBContext _projectDBContext;
        private readonly ILogger<ProjectRepository> _logger;

        public JobSummaryTableRepository(IDBContext projectDBContext, ILogger<ProjectRepository> logger)
        {
            _projectDBContext = projectDBContext;
            _logger = logger;
        }

        public async Task<List<JobSummaryTable>> GetJobSummaryTable(int projectVersionId, MarketPricingSheetFilterDto? filter = null)
        {
            try
            {
                _logger.LogInformation($"\nObtaining the data to the Job Summary Table where the project version Id is: {projectVersionId} \n");

                using (var connection = _projectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };
                    var filterConditions = new StringBuilder();

                    #region Build filter conditions
                    
                    if (filter is not null)
                    {
                        if (filter.MarketSegmentList.Any())
                        {
                            var marketSegmentKeys = new List<string>();

                            for (int i = 0; i < filter.MarketSegmentList.Count; i++)
                            {
                                parameters.Add($"@market_segment_id_{i}", filter.MarketSegmentList[i].Id);
                                marketSegmentKeys.Add($"@market_segment_id_{i}");
                            }

                            filterConditions.Append($" AND MPS.market_segment_id IN ({string.Join(", ", marketSegmentKeys)})");
                        }

                        if (filter.ClientJobGroupList.Any())
                        {
                            var clientJobGroupKeys = new List<string>();

                            for (int j = 0; j < filter.ClientJobGroupList.Count; j++)
                            {
                                var paramName = $"@job_group_{j}";
                                var paramValue = $"{filter.ClientJobGroupList[j]}";
                                parameters.Add(paramName, paramValue);
                                clientJobGroupKeys.Add($"LOWER(MPS.job_group) LIKE '%' || LOWER({paramName}) || '%'");
                            }

                            filterConditions.Append($" AND ({string.Join(" OR ", clientJobGroupKeys)})");
                        }
                    }
                    
                    #endregion

                    var sql = @"
                            SELECT
                                MPS.aggregation_method_key AS AggregationMethodKey,
                                MPS.ces_org_id AS CesOrgId,
                                TRIM(MPS.job_code) AS JobCode,
                                TRIM(MPS.job_title) AS JobTitle,
                                TRIM(MPS.position_code) AS PositionCode,
                                MPS.market_pricing_sheet_id AS MarketPricingSheetId,
                                TRIM(MPS.market_pricing_job_code) AS MarketPricingJobCode,
                                TRIM(MPS.market_pricing_job_title) AS MarketPricingJobTitle,
                                TRIM(MPS.market_pricing_sheet_note) AS MarketPricingSheetNote,
                                MSL.market_segment_id AS MarketSegmentId,
                                TRIM(MSL.market_segment_name) AS MarketSegmentName,
                                TRIM(MPS.job_group) AS JobGroup,
                                DataScope.data_key AS DataScopeKey,
                                TRIM(DataScope.data_scope) AS DataScope,
                                DataScope.data_source AS DataSource,
                                MPSJM.standard_job_code AS StandardJobCode
                            FROM
                                market_pricing_sheet AS MPS
                                INNER JOIN market_pricing_sheet_job_match AS MPSJM ON MPSJM.market_pricing_sheet_id = MPS.market_pricing_sheet_id
                                INNER JOIN market_segment_list AS MSL ON (MPS.market_segment_id = MSL.market_segment_id)
                                INNER JOIN
                                    (
                                            SELECT 
                                                market_segment_id,
                                                eri_cut_name AS data_scope,
                                                market_segment_id AS data_key,
                                                'ERI' AS data_source
                                            FROM market_segment_list
                                        UNION
                                            SELECT 
                                                market_segment_id,
                                                msc.market_pricing_cut_name AS data_scope,
                                                NULL AS data_key,
                                                'CUT' AS data_source
                                            FROM market_segment_cut msc
                                           WHERE display_on_report_flag IS TRUE
                                        GROUP BY market_segment_id,
                                                 msc.market_pricing_cut_name
                                        UNION
                                            SELECT
                                                market_segment_id,
                                                msca.combined_averages_name AS data_scope,
                                                msca.combined_averages_key AS data_key,
                                                'COMBINED' AS data_source
                                            FROM market_segment_combined_averages msca
                                    ) AS DataScope ON (MSL.market_segment_id = DataScope.market_segment_id)
                            WHERE
                                DataScope.data_scope IS NOT NULL
                                AND DataScope.data_scope != ''
                                AND MPS.project_version_id = @projectVersionId
                                {0}";

                    var result = await connection.QueryAsync<JobSummaryTable>(string.Format(sql, filterConditions), parameters);

                    return result.ToList();
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
