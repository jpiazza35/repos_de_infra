using AutoMapper;
using Cn.Survey;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;
using Survey = Cn.Survey.Survey;

namespace CN.Project.Infrastructure.Repository
{
    public class MarketSegmentRepository : IMarketSegmentRepository
    {
        protected IMapper _mapper;

        private readonly IDBContext _mptProjectDBContext;
        private readonly ILogger<MarketSegmentRepository> _logger;
        private readonly Survey.SurveyClient _surveyClient;

        public MarketSegmentRepository(IDBContext mptProjectDBContext, IMapper mapper, ILogger<MarketSegmentRepository> logger, Survey.SurveyClient surveyClient)
        {
            _mptProjectDBContext = mptProjectDBContext;
            _mapper = mapper;
            _logger = logger;
            _surveyClient = surveyClient;
        }

        public async Task<MarketSegmentDto?> GetMarketSegment(int marketSegmentId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining market segment id: {marketSegmentId} \n");

                var marketSegments = await GetMarketSegmentsWithCuts(0, marketSegmentId);

                return marketSegments.FirstOrDefault();
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<MarketSegmentCutDto>> GetMarketSegmentCut(int marketSegmentId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Market Segment Cuts by id: {marketSegmentId} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = @"SELECT market_segment_cut_key AS MarketSegmentCutKey 
                                     , market_segment_id AS MarketSegmentId 
                                     , is_blend_flag AS IsBlendFlag 
                                     , industry_sector_key AS IndustrySectorKey 
                                     , organization_type_key AS OrganizationTypeKey 
                                     , cut_group_key AS CutGroupKey 
                                     , cut_sub_group_key AS CutSubGroupKey 
                                     , TRIM(market_pricing_cut_name) AS MarketPricingCutName 
                                     , display_on_report_flag AS DisplayOnReportFlag 
                                     , report_order AS ReportOrder 
                                     , TRIM(emulated_by) AS EmulatedBy 
                                     , TRIM(modified_username) AS ModifiedUsername 
                                     , modified_utc_datetime AS ModifiedUtcDatetime                                      
                                  FROM market_segment_cut 
                                 WHERE market_segment_id = @marketSegmentId";

                    var marketSegmentCuts = await connection.QueryAsync<MarketSegmentCut>(sql, new { marketSegmentId });

                    return _mapper.Map<IEnumerable<MarketSegmentCutDto>>(marketSegmentCuts);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketSegmentCutDto>> ListMarketSegmentCuts(IEnumerable<int> marketSegmentIds)
        {
            try
            {
                var idList = string.Join(", ", marketSegmentIds);

                _logger.LogInformation($"\nObtaining Market Segment Cuts by ids: {idList} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT market_segment_cut_key AS MarketSegmentCutKey 
                                      , market_segment_id AS MarketSegmentId 
                                      , is_blend_flag AS IsBlendFlag 
                                      , industry_sector_key AS IndustrySectorKey 
                                      , organization_type_key AS OrganizationTypeKey 
                                      , cut_group_key AS CutGroupKey 
                                      , cut_sub_group_key AS CutSubGroupKey 
                                      , TRIM(market_pricing_cut_name) AS MarketPricingCutName 
                                      , display_on_report_flag AS DisplayOnReportFlag 
                                      , report_order AS ReportOrder 
                                      , TRIM(emulated_by) AS EmulatedBy 
                                      , TRIM(modified_username) AS ModifiedUsername 
                                      , modified_utc_datetime AS ModifiedUtcDatetime                                      
                                   FROM market_segment_cut 
                                  WHERE market_segment_id IN ({idList})";

                    var marketSegmentCuts = await connection.QueryAsync<MarketSegmentCut>(sql);

                    return _mapper.Map<List<MarketSegmentCutDto>>(marketSegmentCuts);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<MarketSegmentCutDetailDto>> GetMarketSegmentCutDetail(List<int> marketSegmentCutKeys)
        {
            try
            {
                var cutKeys = string.Join(", ", marketSegmentCutKeys);
                _logger.LogInformation($"\nObtaining Market Segment Cut Details by cut keys: {cutKeys} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT market_segment_cut_detail_key AS MarketSegmentCutDetailKey 
                                     , market_segment_cut_key AS MarketSegmentCutKey 
                                     , publisher_key AS PublisherKey 
                                     , survey_key AS SurveyKey 
                                     , industry_sector_key AS IndustrySectorKey 
                                     , organization_type_key AS OrganizationTypeKey 
                                     , cut_group_key AS CutGroupKey 
                                     , cut_sub_group_key AS CutSubGroupKey 
                                     , cut_key AS CutKey                                      
                                     , is_selected AS Selected 
                                     , TRIM(emulated_by) AS EmulatedBy 
                                     , TRIM(modified_username) AS ModifiedUsername 
                                     , modified_utc_datetime AS ModifiedUtcDatetime 
                                 FROM market_segment_cut_detail 
                                WHERE market_segment_cut_key IN ({cutKeys})";

                    var marketSegmentCutDetails = await connection.QueryAsync<MarketSegmentCutDetail>(sql);

                    return _mapper.Map<IEnumerable<MarketSegmentCutDetailDto>>(marketSegmentCutDetails);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<IEnumerable<MarketSegmentCutSurveyDetailDto>> ListMarketSegmentCutDetailsByMarketSegmentId(int marketSegmentId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Market Segment Cut Details by market segment id: {marketSegmentId} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = @"SELECT market_segment_cut_detail_key AS MarketSegmentCutDetailKey 
                                     , mscd.market_segment_cut_key AS MarketSegmentCutKey 
                                     , mscd.publisher_key AS PublisherKey 
                                     , mscd.survey_key AS SurveyKey 
                                     , mscd.industry_sector_key AS IndustrySectorKey 
                                     , mscd.organization_type_key AS OrganizationTypeKey 
                                     , mscd.cut_group_key AS CutGroupKey 
                                     , mscd.cut_sub_group_key AS CutSubGroupKey 
                                     , mscd.cut_key AS CutKey 
                                     , mscd.is_selected AS IsSelected
                                     , TRIM(msc.market_pricing_cut_name) AS MarketSegmentCutName
                                 FROM market_segment_cut_detail mscd
                                 JOIN market_segment_cut msc ON msc.market_segment_cut_key = mscd.market_segment_cut_key
                                WHERE msc.market_segment_id = @marketSegmentId";

                    return await connection.QueryAsync<MarketSegmentCutSurveyDetailDto>(sql, new { marketSegmentId });
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining market segments by project version id: {projectVersionId} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var deletedStatus = (int)MarketSegmentStatus.Deleted;
                    var sql = $@"SELECT market_segment_id AS MarketSegmentId
                                      , project_version_id AS ProjectVersionId
                                      , TRIM(market_segment_name) AS MarketSegmentName
                                      , market_segment_status_key AS MarketSegmentStatusKey
                                      , eri_adjustment_factor AS EriAdjustmentFactor 
                                      , TRIM(eri_cut_name) AS EriCutName 
                                      , TRIM(eri_city) AS EriCity 
                                      , TRIM(emulated_by) AS EmulatedBy
                                      , TRIM(modified_username) AS ModifiedUsername
                                      , modified_utc_datetime AS ModifiedUtcDatetime
                                   FROM market_segment_list 
                                  WHERE project_version_id = @projectVersionId 
                                    AND market_segment_status_key != {deletedStatus}";

                    var marketSegments = await connection.QueryAsync<MarketSegmentList>(sql, new { projectVersionId });

                    return _mapper.Map<List<MarketSegmentDto>>(marketSegments);
                }

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<List<MarketSegmentDto>> GetMarketSegmentsWithCuts(int projectVersionId, int? marketSegmentId = null)
        {
            try
            {
                _logger.LogInformation($"\nObtaining market segments with cuts by project version id: {projectVersionId} \n");

                IEnumerable<MarketSegmentList> marketSegments = await GetMarketSegmentsRawData(projectVersionId, marketSegmentId);
                IEnumerable<MarketSegmentCutDto> cuts = GetCutsFromMarketSegment(marketSegments);
                IEnumerable<MarketSegmentBlendDto> blends = GetBlendsFromMarketSegment(marketSegments, cuts);

                var result = marketSegments
                    .GroupBy(m => m.MarketSegmentId)
                    .Select(group =>
                    {
                        var marketSegmentBase = group.FirstOrDefault();

                        return new MarketSegmentDto
                        {
                            Id = group.Key,
                            Name = marketSegmentBase?.MarketSegmentName,
                            ProjectVersionId = marketSegmentBase?.ProjectVersionId ?? 0,
                            EriAdjustmentFactor = marketSegmentBase?.EriAdjustmentFactor,
                            EriCutName = marketSegmentBase?.EriCutName,
                            EriCity = marketSegmentBase?.EriCity,
                            Status = marketSegmentBase is null ? MarketSegmentStatus.Draft : (MarketSegmentStatus)(marketSegmentBase.MarketSegmentStatusKey),
                            Cuts = cuts.Where(c => c.MarketSegmentId == group.Key).ToList(),
                            Blends = blends.Where(b => b.MarketSegmentId == group.Key).ToList()
                        };
                    });

                return result.ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task<int> SaveMarketSegment(MarketSegmentDto marketSegment, string user)
        {
            _logger.LogInformation($"\nSaving Market Segment\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        var marketSegmentId = await InsertMarketSegment(marketSegment, user, connection, transaction);

                        if (marketSegment.Cuts is not null && marketSegment.Cuts.Any())
                            await InsertMarketSegmentCut(marketSegmentId, marketSegment.Cuts.Where(c => !c.BlendFlag), user, connection, transaction);

                        transaction.Commit();

                        return marketSegmentId;
                    }
                    catch
                    {
                        transaction.Rollback();

                        throw;
                    }
                }
            }
        }

        public async Task EditMarketSegment(MarketSegmentDto existingMarketSegment, MarketSegmentDto newMarketSegment, string user)
        {
            _logger.LogInformation($"\nEditing Market Segment {existingMarketSegment.Id}\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        await UpdateMarketSegment(newMarketSegment, user, connection, transaction);

                        //Blends have a separated method for edition
                        var existingBlends = existingMarketSegment.Blends ?? new List<MarketSegmentBlendDto>();
                        var newBlends = newMarketSegment.Blends ?? new List<MarketSegmentBlendDto>();

                        var blendsToUpdate = newBlends.Where(nb => existingBlends.Any(eb => eb.MarketSegmentCutKey == nb.MarketSegmentCutKey));
                        var blendsToDelete = existingBlends.Where(eb => !newBlends.Any(nb => nb.MarketSegmentCutKey == eb.MarketSegmentCutKey));

                        //Update only the order in the Selected Cuts list
                        if (blendsToUpdate is not null && blendsToUpdate.Any())
                        {
                            var blendsAsCuts = blendsToUpdate.Select(b => new MarketSegmentCutDto { MarketSegmentCutKey = b.MarketSegmentCutKey, ReportOrder = b.ReportOrder });
                            await EditMarketSegmentBlendReportOrder(blendsAsCuts, user, connection, transaction);
                        }

                        if (blendsToDelete is not null && blendsToDelete.Any())
                        {
                            await DeleteMarketSegmentBlend(blendsToDelete.SelectMany(b => b.Cuts ?? new List<MarketSegmentBlendCutDto>()), connection, transaction);
                            await DeleteMarketSegmentCut(blendsToDelete.Select(b => new MarketSegmentCutDto { MarketSegmentCutKey = b.MarketSegmentCutKey }), connection, transaction);
                        }

                        var existingMarketSegmentCuts = existingMarketSegment.Cuts?.Where(c => !c.BlendFlag) ?? new List<MarketSegmentCutDto>();
                        var newMarketSegmentCuts = newMarketSegment.Cuts?.Where(c => !c.BlendFlag) ?? new List<MarketSegmentCutDto>();

                        var itemsToUpdate = newMarketSegmentCuts.Where(nc => existingMarketSegmentCuts.Any(ec => ec.MarketSegmentCutKey == nc.MarketSegmentCutKey));
                        var itemsToDelete = existingMarketSegmentCuts.Where(ec => !newMarketSegmentCuts.Any(nc => nc.MarketSegmentCutKey == ec.MarketSegmentCutKey));
                        var itemsToAdd = newMarketSegmentCuts.Where(nc => !existingMarketSegmentCuts.Any(ec => ec.MarketSegmentCutKey == nc.MarketSegmentCutKey));

                        if (itemsToUpdate is not null && itemsToUpdate.Any())
                            await EditMarketSegmentCut(itemsToUpdate, user, connection, transaction);

                        if (itemsToDelete is not null && itemsToDelete.Any())
                            await DeleteMarketSegmentCut(itemsToDelete, connection, transaction);

                        if (itemsToAdd is not null && itemsToAdd.Any())
                            await InsertMarketSegmentCut(existingMarketSegment.Id, itemsToAdd, user, connection, transaction);

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

        public async Task<NameAmount?> CheckCurrentEriNameOnUSe(int marketSegmentId)
        {
            _logger.LogInformation($"\nChecking if the Eri Cut Name for the market segment id [{marketSegmentId}] is in use.\n");
            NameAmount? result = null;
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                var sql = @"
                            SELECT
                                MSL.eri_cut_name,
	                            COUNT(MSCAC.market_pricing_cut_name) AS amount
                            FROM
	                            market_segment_list AS MSL
	                            LEFT JOIN market_segment_combined_averages AS MSCA ON (MSL.market_segment_id = MSCA.market_segment_id)
	                            LEFT JOIN market_segment_combined_averages_cut AS MSCAC ON 
		                            (
			                            MSCA.combined_averages_key = MSCAC.combined_averages_key
			                            AND TRIM(MSL.eri_cut_name) = TRIM(MSCAC.market_pricing_cut_name)
		                            )
                            WHERE
	                            MSL.market_segment_id = @Id
                            GROUP BY
	                            MSL.market_segment_id,
	                            MSL.eri_cut_name";

                var parameters = new Dictionary<string, object> { { "@Id", marketSegmentId } };
                var qryResult = await connection.QueryAsync(sql, parameters);

                if (qryResult != null && qryResult.Any())
                    result = qryResult.Select(x => new NameAmount { Name = x.eri_cut_name, Amount = x.amount }).First();
            }
            return result;
        }

        public async Task EditMarketSegmentEri(MarketSegmentDto marketSegment, string user)
        {
            _logger.LogInformation($"\nEditing Market Segment Eri id {marketSegment.Id}\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                try
                {
                    var modifiedUtcDatetime = DateTime.UtcNow;

                    var sql = @"UPDATE market_segment_list
                                   SET eri_adjustment_factor = @EriAdjustmentFactor
                                     , eri_cut_name = @EriCutName
                                     , eri_city = @EriCity
                                     , modified_username = @user
                                     , modified_utc_datetime = @modifiedUtcDatetime
                                 WHERE market_segment_id = @Id";

                    await connection.QueryAsync(sql,
                        new
                        {
                            marketSegment.EriAdjustmentFactor,
                            marketSegment.EriCutName,
                            marketSegment.EriCity,
                            user,
                            modifiedUtcDatetime,
                            marketSegment.Id
                        });
                }
                catch (Exception ex)
                {
                    _logger.LogError($"\nError {ex.Message}\n");

                    throw;
                }
            }
        }

        public async Task<SurveyCutDto> GetSurveyCut(SurveyCutRequestDto surveyCutRequestDto)
        {
            try
            {
                _logger.LogInformation($"\nCalling Survey gRPC service to list survey cuts\n");

                var request = new SurveyCutsRequest();
                request.PublisherKeys.AddRange(surveyCutRequestDto.PublisherKeys ?? Enumerable.Empty<int>());
                request.SurveyKeys.AddRange(surveyCutRequestDto.SurveyKeys ?? Enumerable.Empty<int>());
                request.IndustrySectorKeys.AddRange(surveyCutRequestDto.IndustrySectorKeys ?? Enumerable.Empty<int>());
                request.OrganizationTypeKeys.AddRange(surveyCutRequestDto.OrganizationTypeKeys ?? Enumerable.Empty<int>());
                request.CutGroupKeys.AddRange(surveyCutRequestDto.CutGroupKeys ?? Enumerable.Empty<int>());
                request.CutSubGroupKeys.AddRange(surveyCutRequestDto.CutSubGroupKeys ?? Enumerable.Empty<int>());

                var surveyResponse = await _surveyClient.ListSurveyCutsAsync(request);

                _logger.LogInformation($"\nSuccessful service response.\n");

                return _mapper.Map<SurveyCutDto>(surveyResponse);

            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task SaveMarketSegmentBlend(int marketSegmentId, MarketSegmentBlendDto blend, string user)
        {
            _logger.LogInformation($"\nSaving Market Segment Blend\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        var modifiedUtcDatetime = DateTime.UtcNow;

                        var sql = @"INSERT INTO market_segment_cut (
                                        market_segment_id, 
                                        is_blend_flag, 
                                        market_pricing_cut_name, 
                                        display_on_report_flag, 
                                        report_order, 
                                        emulated_by, 
                                        modified_username, 
                                        modified_utc_datetime)
                                 VALUES (@marketSegmentId, 
                                        @BlendFlag, 
                                        @BlendName, 
                                        @DisplayOnReport, 
                                        @ReportOrder, 
                                        @user, 
                                        @user, 
                                        @modifiedUtcDatetime)
                              RETURNING market_segment_cut_key";

                        var marketSegmentCutKey = await connection.QueryFirstOrDefaultAsync<int>(sql,
                            new
                            {
                                marketSegmentId,
                                blend.BlendFlag,
                                blend.BlendName,
                                blend.DisplayOnReport,
                                blend.ReportOrder,
                                user,
                                modifiedUtcDatetime
                            }, transaction);

                        if (blend.Cuts is not null && blend.Cuts.Any())
                            await InsertMarketSegmentBlend(marketSegmentCutKey, blend.Cuts, user, connection, transaction);

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

        public async Task EditMarketSegmentBlend(MarketSegmentBlendDto blend, string user, IEnumerable<MarketSegmentBlendCutDto> existingChildren)
        {
            _logger.LogInformation($"\nEditing Market Segment Blend {blend.MarketSegmentCutKey}\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        var modifiedUtcDatetime = DateTime.UtcNow;

                        var sql = @"UPDATE market_segment_cut 
                                       SET market_pricing_cut_name = @BlendName, 
                                           display_on_report_flag = @DisplayOnReport, 
                                           report_order = @ReportOrder, 
                                           modified_username = @user, 
                                           modified_utc_datetime = @modifiedUtcDatetime
                                     WHERE market_segment_cut_key = @MarketSegmentCutKey";

                        await connection.QueryAsync<int>(sql,
                            new
                            {
                                blend.BlendName,
                                blend.DisplayOnReport,
                                blend.ReportOrder,
                                user,
                                modifiedUtcDatetime,
                                blend.MarketSegmentCutKey
                            }, transaction);

                        if (existingChildren is not null && blend.Cuts is not null)
                        {
                            var itemsToUpdate = blend.Cuts.Where(bc => existingChildren.Any(ec => ec.ChildMarketSegmentCutKey == bc.ChildMarketSegmentCutKey));
                            var itemsToDelete = existingChildren.Where(ec => !blend.Cuts.Any(bc => bc.ChildMarketSegmentCutKey == ec.ChildMarketSegmentCutKey));
                            var itemsToAdd = blend.Cuts.Where(type => !existingChildren.Any(t => t.ChildMarketSegmentCutKey == type.ChildMarketSegmentCutKey));

                            if (itemsToUpdate is not null && itemsToUpdate.Any())
                                await UpdateMarketSegmentBlend(itemsToUpdate, user, connection, transaction);
                            if (itemsToDelete is not null && itemsToDelete.Any())
                                await DeleteMarketSegmentBlend(itemsToDelete, connection, transaction);
                            if (itemsToAdd is not null && itemsToAdd.Any())
                                await InsertMarketSegmentBlend(blend.MarketSegmentCutKey, itemsToAdd, user, connection, transaction);
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

        public async Task<IEnumerable<MarketSegmentBlendCutDto>> GetMarketSegmentBlendChildren(IEnumerable<int> blendIdList)
        {
            try
            {
                var idList = string.Join(", ", blendIdList);
                _logger.LogInformation($"\nObtaining Market Segment Blends by ids: {idList} \n");

                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var sql = $@"SELECT market_segment_blend_key AS MarketSegmentBlendKey
                                      , parent_market_segment_cut_key AS ParentMarketSegmentCutKey
                                      , child_market_segment_cut_key AS ChildMarketSegmentCutKey
                                      , blend_weight AS BlendWeight
                                      , TRIM(emulated_by) AS EmulatedBy
                                      , TRIM(modified_username) AS ModifiedUsername
                                      , modified_utc_datetime AS ModifiedUtcDatetime
                                  FROM market_segment_blend 
                                 WHERE parent_market_segment_cut_key IN ({idList})";

                    var marketSegmentCuts = await connection.QueryAsync<MarketSegmentBlend>(sql);

                    return _mapper.Map<IEnumerable<MarketSegmentBlendCutDto>>(marketSegmentCuts);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task EditMarketSegmentCutDetails(IEnumerable<MarketSegmentCutDetailDto> existingCutDetails, IEnumerable<MarketSegmentCutDetailDto> newCutDetails, string user)
        {
            _logger.LogInformation($"\nEditing Market Segment Cut Details for Cut {existingCutDetails.FirstOrDefault()?.MarketSegmentCutKey}\n");

            using (var connection = _mptProjectDBContext.GetConnection())
            {
                connection.Open();
                using (var transaction = connection.BeginTransaction())
                {
                    try
                    {
                        if (existingCutDetails is not null && newCutDetails is not null)
                        {
                            var itemsToUpdate = newCutDetails.Where(ncd => existingCutDetails.Any(ecd => ecd.CutKey == ncd.CutKey));
                            var itemsToDelete = existingCutDetails.Where(ecd => !newCutDetails.Any(ncd => ncd.CutKey == ecd.CutKey));
                            var itemsToAdd = newCutDetails.Where(ncd => !existingCutDetails.Any(ecd => ecd.CutKey == ncd.CutKey));

                            if (itemsToUpdate.Any())
                                await EditMarketSegmentCutDetail(itemsToUpdate, user, connection, transaction);
                            if (itemsToDelete.Any())
                                await DeleteMarketSegmentCutDetail(itemsToDelete, connection, transaction);
                            if (itemsToAdd.Any())
                                await InsertMarketSegmentCutDetail(existingCutDetails.First().MarketSegmentCutKey, itemsToAdd, user, connection, transaction);
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

        public async Task<IEnumerable<string>> ListJobCodesMapped(int marketSegmentId)
        {
            _logger.LogInformation($"\nList job codes mapped for market segment id: {marketSegmentId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object> { { "@marketSegmentId", marketSegmentId } };
                    var sql = $@"SELECT DISTINCT job_code
                                            FROM market_pricing_sheet
                                           WHERE market_segment_id = @marketSegmentId;";

                    return await connection.QueryAsync<string>(sql, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public async Task DeleteMarketSegment(int marketSegmentId, string? userObjectId)
        {
            _logger.LogInformation($"\nDeleting market segment id: {marketSegmentId} \n");

            try
            {
                using (var connection = _mptProjectDBContext.GetConnection())
                {
                    var parameters = new Dictionary<string, object>
                    {
                        { "@deletedStatus", (int)MarketSegmentStatus.Deleted },
                        { "@userObjectId", userObjectId! },
                        { "@modifiedDate", DateTime.UtcNow },
                        { "@marketSegmentId", marketSegmentId }
                    };

                    var sql = $@"UPDATE market_segment_list
                                    SET market_segment_status_key = @deletedStatus, modified_username = @userObjectId, modified_utc_datetime = @modifiedDate
                                  WHERE market_segment_id = @marketSegmentId;";

                    await connection.QueryAsync(sql, parameters);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task<int> InsertMarketSegment(MarketSegmentDto marketSegment, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"INSERT INTO market_segment_list (
                                        project_version_id, 
                                        market_segment_name, 
                                        market_segment_status_key,
                                        eri_adjustment_factor,
                                        eri_cut_name,
                                        eri_city,
                                        emulated_by, 
                                        modified_username, 
                                        modified_utc_datetime)
                                 VALUES (@projectVersionId, 
                                        @name, 
                                        @status,
                                        @EriAdjustmentFactor,
                                        @EriCutName,
                                        @EriCity,
                                        @user, 
                                        @user, 
                                        @modifiedUtcDatetime)
                              RETURNING market_segment_id";

                var marketSegmentId = await connection.QueryFirstOrDefaultAsync<int>(sql,
                    new
                    {
                        marketSegment.ProjectVersionId,
                        marketSegment.Name,
                        marketSegment.Status,
                        marketSegment.EriAdjustmentFactor,
                        marketSegment.EriCutName,
                        marketSegment.EriCity,
                        user,
                        modifiedUtcDatetime
                    }, transaction);

                return marketSegmentId;
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task InsertMarketSegmentCut(int marketSegmentId, IEnumerable<MarketSegmentCutDto> cuts, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"INSERT INTO market_segment_cut (
                                        market_segment_id, 
                                        is_blend_flag, 
                                        industry_sector_key, 
                                        organization_type_key, 
                                        cut_group_key, 
                                        cut_sub_group_key, 
                                        market_pricing_cut_name, 
                                        display_on_report_flag, 
                                        report_order, 
                                        emulated_by, 
                                        modified_username, 
                                        modified_utc_datetime)
                                 VALUES (@marketSegmentId, 
                                        @BlendFlag, 
                                        @IndustrySectorKey, 
                                        @OrganizationTypeKey, 
                                        @CutGroupKey, 
                                        @CutSubGroupKey, 
                                        @CutName, 
                                        @DisplayOnReport, 
                                        @ReportOrder, 
                                        @user, 
                                        @user, 
                                        @modifiedUtcDatetime)
                              RETURNING market_segment_cut_key";

                foreach (var cut in cuts)
                {
                    var marketSegmentCutKey = await connection.QueryFirstOrDefaultAsync<int>(sql,
                        new
                        {
                            marketSegmentId,
                            cut.BlendFlag,
                            cut.IndustrySectorKey,
                            cut.OrganizationTypeKey,
                            cut.CutGroupKey,
                            cut.CutSubGroupKey,
                            cut.CutName,
                            cut.DisplayOnReport,
                            cut.ReportOrder,
                            user,
                            modifiedUtcDatetime
                        }, transaction);

                    if (cut.CutDetails is not null && cut.CutDetails.Any())
                        await InsertMarketSegmentCutDetail(marketSegmentCutKey, cut.CutDetails, user, connection, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task InsertMarketSegmentCutDetail(int marketSegmentCutKey, IEnumerable<MarketSegmentCutDetailDto> cutDetails, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"INSERT INTO market_segment_cut_detail (
                                    market_segment_cut_key, 
                                    publisher_key, 
                                    survey_key, 
                                    industry_sector_key, 
                                    organization_type_key, 
                                    cut_group_key, 
                                    cut_sub_group_key, 
                                    cut_key, 
                                    is_selected, 
                                    emulated_by, 
                                    modified_username, 
                                    modified_utc_datetime)
                             VALUES (@marketSegmentCutKey, 
                                    @PublisherKey, 
                                    @SurveyKey, 
                                    @IndustrySectorKey, 
                                    @OrganizationTypeKey, 
                                    @CutGroupKey, 
                                    @CutSubGroupKey, 
                                    @CutKey, 
                                    @Selected, 
                                    @user, 
                                    @user, 
                                    @modifiedUtcDatetime)
                              RETURNING market_segment_cut_detail_key";

                foreach (var cutDetail in cutDetails)
                {
                    var marketSegmentCutDetailKey = await connection.QueryAsync<int>(sql,
                        new
                        {
                            marketSegmentCutKey,
                            cutDetail.PublisherKey,
                            cutDetail.SurveyKey,
                            cutDetail.IndustrySectorKey,
                            cutDetail.OrganizationTypeKey,
                            cutDetail.CutGroupKey,
                            cutDetail.CutSubGroupKey,
                            cutDetail.CutKey,
                            cutDetail.Selected,
                            user,
                            modifiedUtcDatetime
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task InsertMarketSegmentBlend(int marketSegmentCutKey, IEnumerable<MarketSegmentBlendCutDto> blendCuts, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"INSERT INTO market_segment_blend (
                                        parent_market_segment_cut_key, 
                                        child_market_segment_cut_key, 
                                        blend_weight, 
                                        emulated_by, 
                                        modified_username, 
                                        modified_utc_datetime)
                                 VALUES (@marketSegmentCutKey, 
                                        @ChildMarketSegmentCutKey, 
                                        @BlendWeight, 
                                        @user, 
                                        @user, 
                                        @modifiedUtcDatetime)
                              RETURNING market_segment_blend_key";

                foreach (var blendCut in blendCuts)
                {
                    var marketSegmentBlendKey = await connection.QueryAsync<int>(sql,
                        new
                        {
                            marketSegmentCutKey,
                            blendCut.ChildMarketSegmentCutKey,
                            blendCut.BlendWeight,
                            user,
                            modifiedUtcDatetime
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task UpdateMarketSegmentBlend(IEnumerable<MarketSegmentBlendCutDto> blendCuts, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"UPDATE market_segment_blend 
                               SET blend_weight = @BlendWeight, 
                                   modified_username = @user, 
                                   modified_utc_datetime = @modifiedUtcDatetime
                             WHERE market_segment_blend_key = @MarketSegmentBlendKey";

                foreach (var blendCut in blendCuts)
                {
                    await connection.QueryAsync<int>(sql,
                        new
                        {
                            blendCut.BlendWeight,
                            user,
                            modifiedUtcDatetime,
                            blendCut.MarketSegmentBlendKey
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task DeleteMarketSegmentBlend(IEnumerable<MarketSegmentBlendCutDto> blendCuts, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"DELETE FROM market_segment_blend WHERE market_segment_blend_key = @MarketSegmentBlendKey";

                foreach (var blendCut in blendCuts)
                {
                    await connection.QueryAsync<int>(sql, new { blendCut.MarketSegmentBlendKey }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task DeleteMarketSegmentCutDetail(IEnumerable<MarketSegmentCutDetailDto> cutDetails, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var sql = @"DELETE FROM market_segment_cut_detail WHERE market_segment_cut_detail_key = @MarketSegmentCutDetailKey";

                foreach (var cutDetail in cutDetails)
                {
                    await connection.QueryAsync<int>(sql, new { cutDetail.MarketSegmentCutDetailKey }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task EditMarketSegmentCut(IEnumerable<MarketSegmentCutDto> cuts, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"UPDATE market_segment_cut
                               SET market_pricing_cut_name = @CutName
                                 , display_on_report_flag = @DisplayOnReport
                                 , report_order = @ReportOrder
                                 , modified_username = @user
                                 , modified_utc_datetime = @modifiedUtcDatetime
                             WHERE market_segment_cut_key = @MarketSegmentCutKey";

                foreach (var cut in cuts)
                {
                    await connection.QueryAsync<int>(sql,
                        new
                        {
                            cut.CutName,
                            cut.DisplayOnReport,
                            cut.ReportOrder,
                            user,
                            modifiedUtcDatetime,
                            cut.MarketSegmentCutKey
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task EditMarketSegmentBlendReportOrder(IEnumerable<MarketSegmentCutDto> cuts, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"UPDATE market_segment_cut
                               SET report_order = @ReportOrder
                                 , modified_username = @user
                                 , modified_utc_datetime = @modifiedUtcDatetime
                             WHERE market_segment_cut_key = @MarketSegmentCutKey";

                foreach (var cut in cuts)
                {
                    await connection.QueryAsync<int>(sql,
                        new
                        {
                            cut.ReportOrder,
                            user,
                            modifiedUtcDatetime,
                            cut.MarketSegmentCutKey
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task UpdateMarketSegment(MarketSegmentDto marketSegment, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"UPDATE market_segment_list 
                               SET market_segment_name = @Name
                                 , market_segment_status_key = @Status
                                 , modified_username = @user
                                 , modified_utc_datetime = @modifiedUtcDatetime
                             WHERE market_segment_id = @Id";

                await connection.QueryAsync(sql,
                    new
                    {
                        marketSegment.Name,
                        marketSegment.Status,
                        user,
                        modifiedUtcDatetime,
                        marketSegment.Id
                    }, transaction);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task DeleteMarketSegmentCut(IEnumerable<MarketSegmentCutDto> cuts, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var sqlDeleteDetails = @"DELETE FROM market_segment_cut_detail WHERE market_segment_cut_key = @MarketSegmentCutKey";
                var sqlDelete = @"DELETE FROM market_segment_cut WHERE market_segment_cut_key = @MarketSegmentCutKey";

                foreach (var cut in cuts)
                {
                    await connection.QueryAsync(sqlDeleteDetails, new { cut.MarketSegmentCutKey }, transaction);

                    await connection.QueryAsync(sqlDelete, new { cut.MarketSegmentCutKey }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task EditMarketSegmentCutDetail(IEnumerable<MarketSegmentCutDetailDto> cutDetails, string user, IDbConnection connection, IDbTransaction transaction)
        {
            try
            {
                var modifiedUtcDatetime = DateTime.UtcNow;

                var sql = @"UPDATE market_segment_cut_detail 
                               SET is_selected = @Selected
                                 , modified_username = @user
                                 , modified_utc_datetime = @modifiedUtcDatetime
                                 WHERE market_segment_cut_detail_key = @MarketSegmentCutDetailKey";

                foreach (var cutDetail in cutDetails)
                {
                    await connection.QueryAsync(sql,
                        new
                        {
                            cutDetail.Selected,
                            user,
                            modifiedUtcDatetime,
                            cutDetail.MarketSegmentCutDetailKey
                        }, transaction);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        private async Task<IEnumerable<MarketSegmentList>> GetMarketSegmentsRawData(int projectVersionId, int? marketSegmentId = null)
        {
            using (var connection = _mptProjectDBContext.GetConnection())
            {
                var deletedStatus = (int)MarketSegmentStatus.Deleted;
                var filter = marketSegmentId.HasValue ? $"msl.market_segment_id = {marketSegmentId}" : $"project_version_id = {projectVersionId}";
                var sql = $@"SELECT msl.market_segment_id AS MarketSegmentId
                                      , TRIM(msl.market_segment_name) AS MarketSegmentName
                                      , msl.project_version_id AS ProjectVersionId
                                      , msl.market_segment_status_key AS MarketSegmentStatusKey
                                      , msl.eri_adjustment_factor AS EriAdjustmentFactor
                                      , TRIM(msl.eri_cut_name) AS EriCutName
                                      , TRIM(msl.eri_city) AS EriCity
                                      , msc.market_segment_cut_key AS MarketSegmentCutKey
                                      , msc.is_blend_flag AS IsBlendFlag
                                      , TRIM(msc.market_pricing_cut_name) AS CutName
                                      , msc.display_on_report_flag AS DisplayOnReportFlag
                                      , msc.report_order AS ReportOrder
                                      , mscd.market_segment_cut_detail_key AS MarketSegmentCutDetailKey
                                      , mscd.publisher_key AS PublisherKey
                                      , mscd.survey_key AS SurveyKey
                                      , mscd.industry_sector_key AS IndustrySectorKey
                                      , mscd.organization_type_key AS OrganizationTypeKey
                                      , mscd.cut_group_key AS CutGroupKey
                                      , mscd.cut_sub_group_key AS CutSubGroupKey
                                      , mscd.cut_key AS CutKey
                                      , mscd.is_selected AS Selected
                                      , msb.market_segment_blend_key AS MarketSegmentBlendKey
                                      , msb.parent_market_segment_cut_key AS ParentMarketSegmentCutKey
                                      , msb.child_market_segment_cut_key AS ChildMarketSegmentCutKey
                                      , msb.blend_weight AS BlendWeight
                                   FROM market_segment_list msl
                             INNER JOIN market_segment_cut msc ON msc.market_segment_id = msl.market_segment_id
                              LEFT JOIN market_segment_cut_detail mscd ON mscd.market_segment_cut_key = msc.market_segment_cut_key
                              LEFT JOIN market_segment_blend msb ON msb.parent_market_segment_cut_key = msc.market_segment_cut_key
                                  WHERE {filter}
                                    AND market_segment_status_key != {deletedStatus}";

                var marketSegments = await connection.QueryAsync<MarketSegmentList, MarketSegmentCut, MarketSegmentCutDetail, MarketSegmentBlend, MarketSegmentList>(
                        sql,
                        (marketSegment, marketSegmentCut, marketSegmentCutDetail, marketSegmentBlend) =>
                        {
                            marketSegment.MarketSegmentCutDetail = marketSegmentCutDetail;
                            marketSegment.MarketSegmentCut = marketSegmentCut;
                            marketSegment.MarketSegmentBlend = marketSegmentBlend;

                            return marketSegment;
                        },
                        splitOn: "MarketSegmentCutKey, MarketSegmentCutDetailKey, MarketSegmentBlendKey"
                    );

                return marketSegments;
            }
        }

        private IEnumerable<MarketSegmentCutDto> GetCutsFromMarketSegment(IEnumerable<MarketSegmentList> marketSegments)
        {
            List<MarketSegmentCutDetailDto> cutDetails = marketSegments
                .Where(g => g.MarketSegmentCut is not null && g.MarketSegmentCutDetail is not null)
                .Select(c => new MarketSegmentCutDetailDto
                {
                    MarketSegmentCutKey = c.MarketSegmentCut!.MarketSegmentCutKey,
                    MarketSegmentCutDetailKey = c.MarketSegmentCutDetail!.MarketSegmentCutDetailKey,
                    PublisherKey = c.MarketSegmentCutDetail.PublisherKey,
                    SurveyKey = c.MarketSegmentCutDetail.SurveyKey,
                    IndustrySectorKey = c.MarketSegmentCutDetail.IndustrySectorKey,
                    OrganizationTypeKey = c.MarketSegmentCutDetail.OrganizationTypeKey,
                    CutGroupKey = c.MarketSegmentCutDetail.CutGroupKey,
                    CutSubGroupKey = c.MarketSegmentCutDetail.CutSubGroupKey,
                    CutKey = c.MarketSegmentCutDetail.CutKey,
                    Selected = c.MarketSegmentCutDetail.Selected,
                })
                .DistinctBy(c => c.MarketSegmentCutDetailKey)
                .ToList();

            return marketSegments
                .Where(g => g.MarketSegmentCut is not null)
                .Select(c =>
                {
                    var cutDetailBase = cutDetails.FirstOrDefault(cd => cd.MarketSegmentCutKey == c.MarketSegmentCut!.MarketSegmentCutKey);

                    return new MarketSegmentCutDto
                    {
                        MarketSegmentId = c.MarketSegmentId,
                        MarketSegmentCutKey = c.MarketSegmentCut!.MarketSegmentCutKey,
                        CutName = c.MarketSegmentCut.CutName,
                        BlendFlag = c.MarketSegmentCut.IsBlendFlag,
                        DisplayOnReport = c.MarketSegmentCut.DisplayOnReportFlag,
                        ReportOrder = c.MarketSegmentCut.ReportOrder,
                        IndustrySectorKey = cutDetailBase?.IndustrySectorKey,
                        OrganizationTypeKey = cutDetailBase?.OrganizationTypeKey,
                        CutGroupKey = cutDetailBase?.CutGroupKey,
                        CutSubGroupKey = cutDetailBase?.CutSubGroupKey,
                        CutDetails = cutDetails.Where(cd => cd.MarketSegmentCutKey == c.MarketSegmentCut.MarketSegmentCutKey)
                    };
                })
                .DistinctBy(c => c.MarketSegmentCutKey);
        }

        private IEnumerable<MarketSegmentBlendDto> GetBlendsFromMarketSegment(IEnumerable<MarketSegmentList> marketSegments, IEnumerable<MarketSegmentCutDto> cuts)
        {
            var blendCuts = marketSegments
                .Where(g => g.MarketSegmentBlend is not null)
                .Select(g => g.MarketSegmentBlend)
                .Select(c =>
                {
                    var cut = cuts.FirstOrDefault(cut => cut.MarketSegmentCutKey == c?.ChildMarketSegmentCutKey);

                    return new MarketSegmentBlendCutDto
                    {
                        MarketSegmentBlendKey = c!.MarketSegmentBlendKey,
                        ParentMarketSegmentCutKey = c!.ParentMarketSegmentCutKey,
                        ChildMarketSegmentCutKey = c.ChildMarketSegmentCutKey,
                        BlendWeight = c.BlendWeight,
                        IndustrySectorKey = cut?.IndustrySectorKey,
                        OrganizationTypeKey = cut?.OrganizationTypeKey,
                        CutGroupKey = cut?.CutGroupKey,
                        CutSubGroupKey = cut?.CutSubGroupKey,
                    };
                }).Distinct().ToList();

            var blends = cuts
                .Where(c => c.BlendFlag)
                .Select(c => new MarketSegmentBlendDto
                {
                    MarketSegmentId = c.MarketSegmentId,
                    MarketSegmentCutKey = c.MarketSegmentCutKey,
                    BlendName = c.CutName,
                    DisplayOnReport = c.DisplayOnReport,
                    ReportOrder = c.ReportOrder,
                    Cuts = blendCuts.Where(cut => cut.ParentMarketSegmentCutKey == c.MarketSegmentCutKey)
                });

            return blends;
        }
    }
}