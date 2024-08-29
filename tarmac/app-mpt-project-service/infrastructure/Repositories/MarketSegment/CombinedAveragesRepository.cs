using Amazon.Runtime.Internal.Transform;
using AutoMapper;
using Cn.Survey;
using Cn.User;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Infrastructure.Repository;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;

namespace CN.Project.Infrastructure.Repositories.MarketSegment
{
    public class CombinedAveragesRepository : ICombinedAveragesRepository
    {
        protected IMapper _mapper;

        private readonly ILogger<MarketSegmentMappingRepository> _logger;
        private readonly IDBContext _mptProjectDBContext;
        private readonly Survey.SurveyClient _surveyClient;

        public CombinedAveragesRepository(
            ILogger<MarketSegmentMappingRepository> logger,
            IDBContext mptProjectDBContext,
            Survey.SurveyClient surveyClient,
            IMapper mapper
        )
        {
            _logger = logger;
            _mptProjectDBContext = mptProjectDBContext;
            _surveyClient = surveyClient;
            _mapper = mapper;
        }

        public async Task<List<CombinedAveragesDto>> GetCombinedAveragesByMarketSegmentId(int marketSegmentId)
        {
            _logger.LogInformation($"\nGet Combined Averages for Market Segment id: {marketSegmentId} \n");

            try
            {
                var condition = "PARENT.market_segment_id = @marketSegmentId";
                var parameters = new Dictionary<string, object> { { "@marketSegmentId", marketSegmentId } };

                return await GetCombinedAverages(condition, parameters);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<List<CombinedAveragesDto>> GetCombinedAveragesByProjectVersionId(int projectVersionId)
        {
            _logger.LogInformation($"\nGet Combined Averages for Project Version id: {projectVersionId} \n");

            try
            {
                var condition = "MARKETSEGMENT.project_version_id = @projectVersionId";
                var parameters = new Dictionary<string, object> { { "@projectVersionId", projectVersionId } };

                return await GetCombinedAverages(condition, parameters);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task<List<string>> GetCombinedAveragesCutNames(int marketSegmentId)
        {
            _logger.LogInformation($"\nGet Cut Names for Market Segment id: {marketSegmentId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT TRIM(market_pricing_cut_name) AS market_pricing_cut_name 
                                FROM market_segment_cut 
                                WHERE market_segment_id = @marketSegmentId
                                AND market_pricing_cut_name != ''
                                GROUP BY TRIM(market_pricing_cut_name);";

                    var cutNames = await connection.QueryAsync<string>(sql,
                            new { marketSegmentId });

                    return cutNames.ToList();
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        public async Task InsertAndUpdateAndRemoveCombinedAverages(int marketSegmentId, List<CombinedAveragesDto> combinedAveragesDto, string? userObjectId)
        {
            List<int> keys = new List<int>();
            List<string> names;
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        foreach (CombinedAveragesDto combinedAverage in combinedAveragesDto)
                        {

                            if (combinedAverage.Id == 0)
                            {
                                combinedAverage.Id = await InsertCombinedAverage(combinedAverage, userObjectId, connection);
                                foreach (CombinedAveragesCutDto cut in combinedAverage.Cuts)
                                {
                                    await InsertCombinedAverageCut(combinedAverage.Id, cut, userObjectId, connection);
                                }
                            }
                            else
                            {
                                names = new List<string>();
                                await UpdateCombinedAverage(combinedAverage, userObjectId, connection);
                                foreach (CombinedAveragesCutDto cut in combinedAverage.Cuts)
                                {
                                    await InsertCombinedAverageCut(combinedAverage.Id, cut, userObjectId, connection);
                                    names.Add(cut.Name);
                                }
                                await DeleteCombinedAverageCutByName(combinedAverage.Id, names, connection);
                            }

                            keys.Add(combinedAverage.Id);
                        }

                        #region Delete
                        await DeleteCombinedAverageCutBySegmentAndId(marketSegmentId, keys, connection);
                        await DeleteCombinedAverage(marketSegmentId, keys, connection);
                        #endregion

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

        public async Task InsertCombinedAverage(CombinedAveragesDto combinedAverages, string? userObjectId)
        {
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int key = await InsertCombinedAverage(combinedAverages, userObjectId, connection);

                        foreach (CombinedAveragesCutDto cut in combinedAverages.Cuts)
                        {
                            await InsertCombinedAverageCut(key, cut, userObjectId, connection);
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

        public async Task UpdateCombinedAverages(CombinedAveragesDto combinedAverages, string? userObjectId)
        {
            List<string> names = new List<string>();
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        await UpdateCombinedAverage(combinedAverages, userObjectId, connection);

                        foreach (CombinedAveragesCutDto cut in combinedAverages.Cuts)
                        {
                            await InsertCombinedAverageCut(combinedAverages.Id, cut, userObjectId, connection);
                            names.Add(cut.Name);
                        }

                        await DeleteCombinedAverageCutByName(combinedAverages.Id, names, connection);

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

        public async Task UpdateCombinedAverageCutName(int marketSegmentId, string? oldName, string? newName, string? userObjectId)
        {
            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    _logger.LogInformation($"\nUpdating the combined average cut name that has marketSegmentId: {marketSegmentId} and a name: {oldName} \n");

                    var modifiedDate = DateTime.UtcNow;
                    Dictionary<string, object> parameters = new Dictionary<string, object>();
                    parameters.Add("@marketSegmentId", marketSegmentId);
                    parameters.Add("@oldName", oldName?.Trim() ?? string.Empty);
                    parameters.Add("@newName", newName?.Trim() ?? string.Empty);
                    parameters.Add("@userObjectId", userObjectId ?? string.Empty);
                    parameters.Add("@modifiedDate", modifiedDate);

                    var sql = $@"UPDATE market_segment_combined_averages_cut AS CHILD
                            SET 
                                market_pricing_cut_name = @newName,
                                modified_username = @userObjectId,
                                modified_utc_datetime = @modifiedDate
                            WHERE
                                TRIM(market_pricing_cut_name) = @oldName
                                AND EXISTS
                                    (
                                        SELECT NULL
                                        FROM market_segment_combined_averages AS PARENT
                                        WHERE
                                            PARENT.combined_averages_key = CHILD.combined_averages_key
                                            AND PARENT.market_segment_id = @marketSegmentId
                                    );";

                    await connection.ExecuteAsync(sql, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task<int> InsertCombinedAverage(CombinedAveragesDto combinedAverage, string? userObjectId, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\nInserting a new combined average to the market segment: {combinedAverage.MarketSegmentId} \n");

                var modifiedDate = DateTime.UtcNow;
                var sql = $@"INSERT INTO public.market_segment_combined_averages
                                (
                                    market_segment_id,
                                    combined_averages_name,
                                    combined_averages_order,
                                    modified_username,
                                    modified_utc_datetime
                                )
                            VALUES 
                                (
                                    @marketSegmentId,
                                    @name,
                                    @order,
                                    @userObjectId,
                                    @modifiedDate
                                )
                            RETURNING combined_averages_key;";

                int key = await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        marketSegmentId = combinedAverage.MarketSegmentId,
                        name = combinedAverage.Name.Trim(),
                        order = combinedAverage.Order,
                        userObjectId,
                        modifiedDate
                    });

                return key;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task UpdateCombinedAverage(CombinedAveragesDto combinedAverage, string? userObjectId, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\nUpdating the combined average that has the combined_averages_id: {combinedAverage.Id} \n");

                var modifiedDate = DateTime.UtcNow;
                var sql = $@"UPDATE market_segment_combined_averages
                            SET 
                                combined_averages_name = @combinedAveragesName,
                                combined_averages_order = @combinedAveragesOrder,
                                modified_username = @userObjectId,
                                modified_utc_datetime = @modifiedDate
                            WHERE
                                combined_averages_key = @combinedAverageskey;";

                await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        combinedAverageskey = combinedAverage.Id,
                        combinedAveragesName = combinedAverage.Name.Trim(),
                        combinedAveragesOrder = combinedAverage.Order,
                        userObjectId,
                        modifiedDate
                    });
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        /// <summary>
        /// Deleted all the market_segment_combined_averages from a market_segment_id that are not in the list of combined_averages_id.
        /// </summary>
        /// <param name="marketSegmentId"></param>
        /// <param name="Keys"></param>
        /// <param name="userObjectId"></param>
        /// <param name="connection"></param>
        /// <returns></returns>
        private async Task DeleteCombinedAverage(int marketSegmentId, List<int> Keys, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\nDeleting (soft) the combined average that has the market_segment_id: {marketSegmentId} and the combined_averages_id not be in: ({string.Join(", ", Keys)}) \n");

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                for (int i = 0; i < Keys.Count; i++)
                {
                    parameters.Add($"@Keys_{i}", Keys[i]);
                }
                var idList = string.Join(", ", parameters.Select(x => x.Key).ToList());

                var sql = $@"DELETE FROM market_segment_combined_averages
                            WHERE
                                market_segment_id = @marketSegmentId
                                AND combined_averages_key not in ({idList})";

                parameters.Add("@marketSegmentId", marketSegmentId);
                await connection.ExecuteScalarAsync<int>(sql, parameters);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task InsertCombinedAverageCut(int combinedAveragesKey, CombinedAveragesCutDto combinedAveragesCut, string? userObjectId, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\nInserting the combined average cut that has name: {combinedAveragesCut.Name} to the Combined Averages Key: {combinedAveragesKey} \n");

                var modifiedDate = DateTime.UtcNow;
                var sql = $@"INSERT INTO market_segment_combined_averages_cut
                                (
                                    combined_averages_key,
                                    market_pricing_cut_name,
                                    modified_username,
                                    modified_utc_datetime
                                )
                            SELECT
                                @combinedAverageskey,
                                @marketPricingCutName,
                                @userObjectId,
                                @modifiedDate
                            WHERE
                                NOT EXISTS
                                    (
                                        SELECT NULL
                                        FROM market_segment_combined_averages_cut AS CUT
                                        WHERE
                                            CUT.combined_averages_key = @combinedAverageskey
                                            AND CUT.market_pricing_cut_name = @marketPricingCutName
                                    );";

                await connection.ExecuteScalarAsync<int>(sql,
                    new
                    {
                        combinedAverageskey = combinedAveragesKey,
                        marketPricingCutName = combinedAveragesCut.Name.Trim(),
                        userObjectId,
                        modifiedDate
                    });
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task DeleteCombinedAverageCutByName(int combinedAveragesKey, List<string> cutNames, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\nRemoving the unselected cut to the Combined Averages Key: {combinedAveragesKey} \n");

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                for (int i = 0; i < cutNames.Count; i++)
                {
                    parameters.Add($"@marketPricingCutName_{i}", cutNames[i]);
                }
                var names = string.Join(", ", parameters.Select(x => x.Key).ToList());
                var sql = $@"DELETE FROM market_segment_combined_averages_cut
                            WHERE
                                combined_averages_key = @combinedAverageskey
                                AND market_pricing_cut_name NOT IN ({names});";

                parameters.Add("combinedAverageskey", combinedAveragesKey);
                await connection.ExecuteAsync(sql, parameters);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        /// <summary>
        /// This function will delete the cuts that are for a market segment but when the combined average is not in the list of combined averages for that market segment.
        /// </summary>
        /// <param name="marketSegmentId"></param>
        /// <param name="CombinedAveragesIds"></param>
        /// <param name="userObjectId"></param>
        /// <param name="connection"></param>
        /// <returns></returns>
        private async Task DeleteCombinedAverageCutBySegmentAndId(int marketSegmentId, List<int> CombinedAveragesIds, IDbConnection connection)
        {
            try
            {
                _logger.LogInformation($"\n \n");

                Dictionary<string, object> parameters = new Dictionary<string, object>();
                for (int i = 0; i < CombinedAveragesIds.Count; i++)
                {
                    parameters.Add($"@marketPricingCutName_{i}", CombinedAveragesIds[i]);
                }
                var parametersNames = string.Join(", ", parameters.Select(x => x.Key).ToList());
                var sql = $@"DELETE FROM market_segment_combined_averages_cut AS CHILD
                            WHERE
                                EXISTS
                                    (
                                        SELECT NULL
                                        FROM market_segment_combined_averages AS PARENT
                                        WHERE
                                            PARENT.market_segment_id = @marketSegmentId
                                            AND PARENT.combined_averages_key NOT IN ({parametersNames})
                                            AND PARENT.combined_averages_key = CHILD.combined_averages_key
                                    );";

                parameters.Add("@marketSegmentId", marketSegmentId);
                await connection.ExecuteAsync(sql, parameters);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");
                throw;
            }
        }

        private async Task<List<CombinedAveragesDto>> GetCombinedAverages(string condition, Dictionary<string, object> parameters)
        {
            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var qryParents = $@"SELECT 
                                            PARENT.combined_averages_key, PARENT.combined_averages_name, PARENT.combined_averages_order, PARENT.market_segment_id,
                                            CHILD.combined_averages_cut_key, TRIM(CHILD.market_pricing_cut_name) AS market_pricing_cut_name
                                        FROM 
                                            market_segment_combined_averages AS PARENT
                                            INNER JOIN market_segment_combined_averages_cut AS CHILD ON (PARENT.combined_averages_key = CHILD.combined_averages_key)
                                            INNER JOIN market_segment_list AS MARKETSEGMENT ON (PARENT.market_segment_id = MARKETSEGMENT.market_segment_id)
                                        WHERE
                                            TRIM(CHILD.market_pricing_cut_name) != ''
                                            AND {condition};";

                    var qryResult = await connection.QueryAsync(qryParents, parameters);
                    var result = (from row in qryResult
                                  group new
                                  {
                                      row.combined_averages_cut_key,
                                      row.market_pricing_cut_name
                                  } by new
                                  {
                                      row.combined_averages_key,
                                      row.combined_averages_name,
                                      row.combined_averages_order,
                                      row.market_segment_id
                                  } into grouped
                                  select new CombinedAveragesDto
                                  {
                                      Id = grouped.Key.combined_averages_key,
                                      Name = grouped.Key.combined_averages_name,
                                      Order = grouped.Key.combined_averages_order,
                                      MarketSegmentId = grouped.Key.market_segment_id,
                                      Cuts = grouped.Select(x => new CombinedAveragesCutDto
                                      {
                                          Id = x.combined_averages_cut_key,
                                          CombinedAveragesId = grouped.Key.combined_averages_key,
                                          Name = x.market_pricing_cut_name
                                      }).ToList()
                                  }).ToList();

                    return result;
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