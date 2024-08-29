using CN.Project.Domain.Constants;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Extensions;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using CN.Project.Domain.Utils;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using CN.Project.Infrastructure.Repository;

namespace CN.Project.RestApi.Services
{
    public class MarketPricingSheetService : IMarketPricingSheetService
    {
        private readonly IMarketPricingSheetRepository _marketPricingSheetRepository;
        private readonly IProjectRepository _projectRepository;
        private readonly IMarketSegmentMappingRepository _marketSegmentMappingRepository;
        private readonly IProjectDetailsRepository _projectDetailsRepository;
        private readonly IMarketSegmentRepository _marketSegmentRepository;
        private readonly IFileRepository _fileRepository;
        private readonly IMarketPricingSheetFileRepository _marketPricingSheetFileRepository;
        private readonly ICombinedAveragesRepository _combinedAveragesRepository;
        private readonly IBenchmarkDataService _benchmarkDataService;

        public MarketPricingSheetService(IMarketPricingSheetRepository marketPricingSheetRepository,
                                         IProjectRepository projectRepository,
                                         IMarketSegmentMappingRepository marketSegmentMappingRepository,
                                         IProjectDetailsRepository projectDetailsRepository,
                                         IMarketSegmentRepository marketSegmentRepository,
                                         IFileRepository fileRepository,
                                         IMarketPricingSheetFileRepository marketPricingSheetFileRepository,
                                         ICombinedAveragesRepository combinedAveragesRepository,
                                         IBenchmarkDataService benchmarkDataService)
        {
            _marketPricingSheetRepository = marketPricingSheetRepository;
            _projectRepository = projectRepository;
            _marketSegmentMappingRepository = marketSegmentMappingRepository;
            _projectDetailsRepository = projectDetailsRepository;
            _marketSegmentRepository = marketSegmentRepository;
            _fileRepository = fileRepository;
            _marketPricingSheetFileRepository = marketPricingSheetFileRepository;
            _combinedAveragesRepository = combinedAveragesRepository;
            _benchmarkDataService = benchmarkDataService;
        }

        public async Task<List<MarketPricingStatusDto>> GetStatus(int projectVersionId, MarketPricingSheetFilterDto filter)
        {
            var statusSaved = await _marketPricingSheetRepository.GetStatus(projectVersionId, filter);
            var statusKeyList = Enum.GetValues(typeof(MarketPricingStatus)).OfType<MarketPricingStatus>();

            var result = statusKeyList.Select(statusKey =>
            {
                var existingValue = statusSaved.FirstOrDefault(s => s.JobMatchStatusKey == (int)statusKey);
                return new MarketPricingStatusDto
                {
                    JobMatchStatusKey = existingValue?.JobMatchStatusKey ?? (int)statusKey,
                    JobMatchStatus = GetStringValueFromEnum(existingValue is not null && existingValue.JobMatchStatusKey.HasValue ? (MarketPricingStatus)existingValue.JobMatchStatusKey : statusKey),
                    Count = existingValue?.Count ?? 0
                };
            }).ToList();

            result.Add(new MarketPricingStatusDto
            {
                JobMatchStatus = "Total",
                Count = statusSaved.Sum(s => s.Count)
            });

            return result;
        }

        public async Task<List<IdNameDto>> GetMarketSegmentsNames(int projectVersionId)
        {
            return await _marketPricingSheetRepository.GetMarketSegmentsNames(projectVersionId);
        }

        public async Task<List<string>> GetJobGroups(int projectVersionId)
        {
            return await _marketPricingSheetRepository.GetJobGroups(projectVersionId);
        }

        public async Task<List<JobTitleFilterDto>> GetJobTitles(int projectVersionId, MarketPricingSheetFilterDto filter)
        {
            var sortBy = GenerateSortCriteria(filter.SortBy, MarketPricingSheetSortType.JobTitle);
            var result = await _marketPricingSheetRepository.GetJobTitles(projectVersionId, filter);
            return result.SortBy(sortBy);
        }

        public async Task<MarketPricingSheetInfoDto?> GetSheetInfo(int projectVersionId, int marketPricingSheetId)
        {
            var data = await _marketPricingSheetRepository.GetSheetInfo(projectVersionId, marketPricingSheetId);

            if (data != null && data.Organization != null && data.Organization.Id > 0)
            {
                List<OrganizationDto> organizations = await ListOrganizations(new List<int> { data.Organization.Id });
                data.Organization.Name = organizations.FirstOrDefault()?.Name ?? string.Empty;
            }

            return data;
        }

        public async Task<IEnumerable<SourceDataDto>> GetClientPositionDetail(int projectVersionId, int marketPricingSheetId, ProjectVersionDto? projectVersionDetails = null)
        {
            if (projectVersionDetails is null)
                projectVersionDetails = await GetProjectVersionDetails(projectVersionId);

            if (projectVersionDetails is null || !projectVersionDetails.FileLogKey.HasValue || !projectVersionDetails.AggregationMethodologyKey.HasValue)
                return Enumerable.Empty<SourceDataDto>();

            var marketPricingSheet = (await _marketPricingSheetRepository.GetMarketPricingSheet(projectVersionId, marketPricingSheetId)).FirstOrDefault();

            if (marketPricingSheet is null)
                return Enumerable.Empty<SourceDataDto>();

            var sourceDataList = await _marketSegmentMappingRepository.ListClientPositionDetail(projectVersionDetails.FileLogKey.Value,
                                                                                         (int)projectVersionDetails.AggregationMethodologyKey.Value,
                                                                                         marketPricingSheet.JobCode,
                                                                                         marketPricingSheet.PositionCode,
                                                                                         marketPricingSheet.CesOrgId);

            var clientJob = sourceDataList.FirstOrDefault();
            var result = new List<SourceDataDto>()
            {
                new ()
                {
                    JobCode = marketPricingSheet.JobCode,
                    JobTitle = marketPricingSheet.JobTitle,
                    JobGroup = marketPricingSheet.JobGroup,
                    PositionCode = marketPricingSheet.PositionCode,
                    JobFamily = clientJob?.JobFamily ?? string.Empty,
                    PositionCodeDescription = clientJob?.PositionCodeDescription ?? string.Empty,
                    LocationDescription = clientJob?.LocationDescription ?? string.Empty,
                    JobLevel = clientJob?.JobLevel?? string.Empty,
                    IncumbentCount = clientJob?.IncumbentCount ?? 0,
                    FteCount = clientJob?.FteCount ?? 0,
                    PayType = clientJob?.PayType ?? string.Empty,
                    PayGrade = clientJob?.PayGrade ?? string.Empty
                }
            };

            return result;
        }

        public async Task UpdateMarketPricingStatus(int projectVersionId, int marketPricingSheetId, int marketPricingStatusKey, string? userObjectId)
        {
            await _marketPricingSheetRepository.UpdateMarketPricingStatus(projectVersionId, marketPricingSheetId, marketPricingStatusKey, userObjectId);
        }

        public async Task<int> GetProjectVersionStatus(int projectVersionId)
        {
            return await _projectRepository.GetProjectVersionStatus(projectVersionId);
        }

        public async Task<JobMatchingInfo> GetJobMatchDetail(int projectVersionId, int marketPricingSheetId)
        {
            return await _marketPricingSheetRepository.GetJobMatchDetail(projectVersionId, marketPricingSheetId);
        }

        public async Task SaveJobMatchDetail(int projectVersionId, int marketPricingSheetId, string jobMatchNote, string? userObjectId)
        {
            await _marketPricingSheetRepository.SaveJobMatchDetail(projectVersionId, marketPricingSheetId, jobMatchNote, userObjectId);
        }

        public async Task<Dictionary<string, string>> GetClientPayDetail(int projectVersionId, int marketPricingSheetId)
        {
            var benchmarkList = new Dictionary<string, string>();
            var projectVersionDetails = await GetProjectVersionDetails(projectVersionId);
            var benchmarkDataTypes = await GetBenchmarkDataTypes(projectVersionId);
            var marketPricingSheetInfo = await _marketPricingSheetRepository.GetSheetInfo(projectVersionId, marketPricingSheetId);

            if (projectVersionDetails is null || projectVersionDetails.FileLogKey is null || marketPricingSheetInfo is null)
                return benchmarkList;

            var clientPayDetail = await _projectDetailsRepository.ListClientPayDetail(projectVersionDetails.FileLogKey.Value,
                marketPricingSheetInfo.CesOrgId,
                marketPricingSheetInfo.AggregationMethodKey,
                marketPricingSheetInfo.JobCode,
                marketPricingSheetInfo.PositionCode,
                benchmarkDataTypes.Select(b => b.Id));

            foreach (var benchmark in benchmarkDataTypes)
            {
                var benchmarkDataType = clientPayDetail?.FirstOrDefault(key => key.BenchmarkDataTypeKey == benchmark.Id);
                if (benchmarkDataType is not null)
                {
                    var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue(benchmarkDataType.BenchmarkDataTypeValue, benchmark.Format, benchmark.Decimals);

                    benchmarkList.Add(benchmark.LongAlias, formattedValue);
                }
            }

            return benchmarkList;
        }

        public async Task<List<IdNameDto>> GetAdjusmentNoteList()
        {
            return await _marketPricingSheetRepository.GetAdjusmentNoteList();
        }

        public async Task<List<MarketPricingSheetGridItemDto>> GetGridItems(int projectVersionId, int? marketPricingSheetId = null)
        {
            var gridItemList = new List<MarketPricingSheetGridItemDto>();

            var projectVersionDetails = await GetProjectVersionDetails(projectVersionId);

            if (projectVersionDetails is null)
                return gridItemList;

            var benchmarkDataTypesTask = GetBenchmarkDataTypes(projectVersionId, projectVersionDetails.SurveySourceGroupKey ?? 0);
            var rawExternalDataTask = _marketPricingSheetRepository.ListExternalData(projectVersionId);
            var adjustmentNotesTask = _marketPricingSheetRepository.ListAdjustmentNotesByProjectVersionId(projectVersionId);

            await Task.WhenAll(benchmarkDataTypesTask, rawExternalDataTask, adjustmentNotesTask);

            var benchmarkDataTypes = await benchmarkDataTypesTask;
            var rawExternalData = await rawExternalDataTask;
            var adjustmentNotes = await adjustmentNotesTask;
            var percentiles = GetPercentiles();
            var fileList = projectVersionDetails.FileLogKey.HasValue ? await _fileRepository.GetFilesByIds(new List<int> { projectVersionDetails.FileLogKey.Value }) : new List<FileLogDto>();
            var getPercentilesValue = marketPricingSheetId.HasValue;
            var marketPricingSheets = new List<MarketPricingSheet>();

            if (marketPricingSheetId.HasValue)
            {
                var marketPricingSheet = await _marketPricingSheetRepository.GetMarketPricingSheet(projectVersionId, marketPricingSheetId.Value);

                if (marketPricingSheet is null || !marketPricingSheet.Any() || !marketPricingSheet.Where(m => m.MarketSegmentId != 0).Any())
                    return gridItemList;

                marketPricingSheets = marketPricingSheet;
            }
            else
                marketPricingSheets = await _marketPricingSheetRepository.ListMarketPricingSheets(projectVersionId);

            var marketPricingSheetListGrouped = marketPricingSheets.GroupBy(m => new { m.Id, m.CesOrgId, m.MarketSegmentId }).Select(m => new
            {
                Id = m.Key.Id,
                CesOrgId = m.Key.CesOrgId,
                MarketSegmentId = m.Key.MarketSegmentId,
                MarketPricingSheetList = m.ToList()
            });
            foreach (var marketPricingSheet in marketPricingSheetListGrouped)
            {
                if (marketPricingSheet.MarketSegmentId == 0)
                    continue;

                var marketSegmentSurveyDetails = await _marketSegmentRepository.ListMarketSegmentCutDetailsByMarketSegmentId(marketPricingSheet.MarketSegmentId);

                if (marketSegmentSurveyDetails is null || !marketSegmentSurveyDetails.Any())
                    continue;

                await GetMarketPricingSheetGridItems(gridItemList, projectVersionDetails, marketPricingSheet.MarketPricingSheetList, marketSegmentSurveyDetails.Where(c => c.IsSelected), benchmarkDataTypes,
                    percentiles, adjustmentNotes.Where(a => a.MarketPricingSheetId == marketPricingSheet.Id).ToList(), fileList,
                    rawExternalData.Where(d => !d.MarketPricingSheetId.HasValue || d.MarketPricingSheetId == marketPricingSheet.Id).ToList(), getPercentilesValue);
            }

            return gridItemList.Distinct().ToList();
        }

        public async Task SaveNotes(int projectVersionId, int marketPricingSheetId, NewStringValueDto notes, string? userObjectId)
        {
            await _marketPricingSheetRepository.SaveNotes(projectVersionId, marketPricingSheetId, notes.Value, userObjectId);
        }

        public async Task<NewStringValueDto> GetNotes(int projectVersionId, int marketPricingSheetId)
        {
            return await _marketPricingSheetRepository.GetNotes(projectVersionId, marketPricingSheetId);
        }

        public async Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int projectVersionId)
        {
            var projectVersionDetails = await GetProjectVersionDetails(projectVersionId);
            return await GetBenchmarkDataTypes(projectVersionId, projectVersionDetails.SurveySourceGroupKey ?? 0);
        }

        public async Task<List<string>> GetMarketSegmentReportFilter(int projectVersionId)
        {
            return await _marketPricingSheetRepository.GetMarketSegmentReportFilter(projectVersionId);
        }

        public async Task SaveMainSettings(int projectVersionId, MainSettingsDto gloablSettings, string? userObjectId)
        {
            await _marketPricingSheetRepository.SaveMainSettings(projectVersionId, gloablSettings, userObjectId);
        }

        public async Task<MainSettingsDto?> GetMainSettings(int projectVersionId)
        {
            return await _marketPricingSheetRepository.GetMainSettings(projectVersionId);
        }

        public async Task SaveGridItemsForMarketPricingSheet(SaveGridItemDto item, string? userObjectId)
        {
            var existingAdjustmentNotes = await _marketPricingSheetRepository.ListAdjustmentNotes(item.MarketPricingSheetId, item.RawDataKey, item.CutExternalKey);

            if (existingAdjustmentNotes is not null && existingAdjustmentNotes.Any())
                await _marketPricingSheetRepository.UpdateAdjustmentNotes(item, existingAdjustmentNotes, userObjectId);
            else
                await _marketPricingSheetRepository.InsertAdjustmentNotes(item, userObjectId);
        }

        public async Task SaveMarketPricingExternalData(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternalRows, string? userObjectId)
        {
            await _marketPricingSheetRepository.SaveMarketPricingExternalData(projectVersionId, cutExternalRows, userObjectId);
        }

        public async Task<ProjectVersionDto> GetProjectVersionDetails(int projectVersionId)
        {
            return await _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
        }

        public async Task<UploadMarketPricingSheetPdfFileDto> ExportPdf(int projectVersionId, int? marketPricingSheetId, List<int> sortByList, string? userObjectId)
        {
            var projectVersionDetails = await GetProjectVersionDetails(projectVersionId);

            if (projectVersionDetails is null)
                return new UploadMarketPricingSheetPdfFileDto { Success = false, Message = "No Project Version found." };

            var mainSettings = await GetMainSettings(projectVersionId);

            if (mainSettings is null)
                return new UploadMarketPricingSheetPdfFileDto { Success = false, Message = "No Main Settings configuration found." };

            var generatedFile = await _marketPricingSheetRepository.GetGeneratedFile(projectVersionId, marketPricingSheetId);
            var marketPricingSheetList = new List<MarketPricingSheet>();

            if (marketPricingSheetId.HasValue)
            {
                marketPricingSheetList = await _marketPricingSheetRepository.GetMarketPricingSheet(projectVersionId, marketPricingSheetId.Value);
            }
            else
                marketPricingSheetList = await _marketPricingSheetRepository.ListMarketPricingSheets(projectVersionId);

            if (!marketPricingSheetList.Any())
                return new UploadMarketPricingSheetPdfFileDto { Success = false, Message = "No Market Pricing Sheet found." };

            var adjustmentNotes = await _marketPricingSheetRepository.ListAdjustmentNotesByProjectVersionId(projectVersionId);
            var marketPricingSheetIds = marketPricingSheetList.Select(m => m.Id);

            if (generatedFile is not null && ValidGeneratedFileDate(generatedFile.ModifiedUtcDatetime,
                                                                    projectVersionDetails.ModifiedUtcDatetime,
                                                                    marketPricingSheetList,
                                                                    adjustmentNotes.Where(a => marketPricingSheetIds.Contains(a.MarketPricingSheetId))))
                return generatedFile;

            var organizationList = marketPricingSheetList.Select(m => m.CesOrgId).Distinct().ToList();
            organizationList.Add(projectVersionDetails.OrganizationKey);

            // Fetching market segments, benchmark data types, organizations, files, combined averages and external data asynchronously
            var marketSegmentsTask = _marketSegmentRepository.GetMarketSegmentsWithCuts(projectVersionId);
            var benchmarksTask = GetBenchmarkDataTypes(projectVersionId, projectVersionDetails.SurveySourceGroupKey ?? 0);
            var organizationsTask = ListOrganizations(organizationList);
            var fileListTask = _fileRepository.GetFilesByIds(new List<int> { projectVersionDetails.FileLogKey ?? 0 });
            var combinedAveragesTask = _combinedAveragesRepository.GetCombinedAveragesByProjectVersionId(projectVersionId);
            var externalDataTask = _marketPricingSheetRepository.ListExternalData(projectVersionId);

            // The tasks run in parallel
            await Task.WhenAll(marketSegmentsTask, benchmarksTask, organizationsTask, fileListTask, externalDataTask);

            var marketSegments = await marketSegmentsTask;
            var benchmarks = await benchmarksTask;
            var organizations = await organizationsTask;
            var fileList = await fileListTask;
            var combinedAverages = await combinedAveragesTask;
            var externalData = await externalDataTask;

            var percentiles = GetPercentiles();
            var benchmarksSelectedFromMainSettings = GetOrderedBenchmarksFromMainSettings(mainSettings.Benchmarks, benchmarks);
            var templateList = new List<string>();
            var headerTemplate = string.Empty;
            var clientPayDetailTemplate = string.Empty;
            var clientPositionDetailTemplate = string.Empty;
            var jobMatchTemplate = string.Empty;

            mainSettings.Sections.TryGetValue("ClientPayDetail", out var displayClientPayDetail);
            mainSettings.Sections.TryGetValue("ClientPosDetail", out var displayClientPositionDetail);
            mainSettings.Sections.TryGetValue("JobMatchDetail", out var displayJobMatchDetail);
            mainSettings.Sections.TryGetValue("OrgName", out var displayOrgName);
            mainSettings.Sections.TryGetValue("ReportDate", out var displayReportDate);
            mainSettings.Sections.TryGetValue("MarketSegmentName", out var displayMarketSegmentName);

            GettingDataForMarketPricingSheetList(projectVersionId, projectVersionDetails, marketPricingSheetList, marketSegments, benchmarks, displayClientPayDetail, displayClientPositionDetail,
                displayJobMatchDetail, out List<Task> taskList, out List<MarketPricingSheetThreadDto> taskControllerList);

            await Task.WhenAll(taskList);

            var sortBy = GenerateSortCriteria(sortByList, MarketPricingSheetSortType.Pdf);
            marketPricingSheetList = marketPricingSheetList.SortBy(sortBy);

            var marketPricingSheetListGrouped = marketPricingSheetList.GroupBy(m => new { m.Id, m.CesOrgId, m.MarketSegmentId }).Select(m => new
            {
                Id = m.Key.Id,
                CesOrgId = m.Key.CesOrgId,
                MarketSegmentId = m.Key.MarketSegmentId,
                MarketPricingSheetList = m.ToList()
            });

            foreach (var marketPricingSheet in marketPricingSheetListGrouped)
            {
                var tasks = taskControllerList.Where(t => t.MarketPricingSheetId == marketPricingSheet.Id);
                var marketPricingSheetOrganization = organizations.FirstOrDefault(o => o.Id == marketPricingSheet.CesOrgId);

                headerTemplate = _marketPricingSheetFileRepository.GetHeaderHtmlTemplate(displayOrgName, displayReportDate, marketPricingSheetOrganization?.Name, marketPricingSheet.Id);

                if (displayClientPayDetail)
                {
                    var payDetailTaskId = tasks.FirstOrDefault(t => t.ClientPayDetailTaskId.HasValue)?.ClientPayDetailTaskId ?? 0;
                    var payDetailTask = taskList.FirstOrDefault(t => t.Id == payDetailTaskId) as Task<Dictionary<string, string>>;

                    var payDetail = await payDetailTask!;

                    clientPayDetailTemplate = _marketPricingSheetFileRepository.GetClientPayDetailHtmlTemplate(marketPricingSheet.Id, payDetail);
                }

                if (displayClientPositionDetail)
                {
                    var positionDetailListTaskId = tasks.FirstOrDefault(t => t.ClientPositionDetailTaskId.HasValue)?.ClientPositionDetailTaskId ?? 0;
                    var positionDetailListTask = taskList.FirstOrDefault(t => t.Id == positionDetailListTaskId) as Task<IEnumerable<SourceDataDto>>;

                    var positionDetailList = await positionDetailListTask!;

                    clientPositionDetailTemplate = _marketPricingSheetFileRepository.GetClientPositionDetailHtmlTemplate(marketPricingSheet.Id, positionDetailList);
                }

                if (displayJobMatchDetail)
                {
                    var jobMatchDetailTaskId = tasks.FirstOrDefault(t => t.JobMatchDetailTaskId.HasValue)?.JobMatchDetailTaskId ?? 0;
                    var jobMatchDetailTask = taskList.FirstOrDefault(t => t.Id == jobMatchDetailTaskId) as Task<JobMatchingInfo>;

                    var jobMatchDetail = await jobMatchDetailTask!;

                    jobMatchTemplate = _marketPricingSheetFileRepository.GetJobMatchDetailHtmlTemplate(marketPricingSheet.Id, jobMatchDetail);
                }

                var gridItems = new List<MarketPricingSheetGridItemDto>();
                var marketDataDetailTemplate = await GetMarketDataDetailTemplate(projectVersionDetails, mainSettings, adjustmentNotes, benchmarks, fileList, combinedAverages,
                    percentiles, benchmarksSelectedFromMainSettings, taskList, marketPricingSheet.MarketPricingSheetList, tasks, gridItems, marketSegments.FirstOrDefault(ms => ms.Id == marketPricingSheet.MarketSegmentId),
                    externalData.Where(d => !d.MarketPricingSheetId.HasValue || d.MarketPricingSheetId == marketPricingSheet.Id).ToList(), displayMarketSegmentName);

                var notesTemplate = await GetNotesTemplate(mainSettings, benchmarks, taskList, marketPricingSheet.Id, tasks, gridItems);

                var finalTemplate = _marketPricingSheetFileRepository.GetFinalHtmlTemplate(marketPricingSheet.Id, headerTemplate, clientPayDetailTemplate, clientPositionDetailTemplate,
                    jobMatchTemplate, marketDataDetailTemplate, notesTemplate);

                templateList.Add(finalTemplate);
            }

            var file = await _fileRepository.ConvertHtmlListToUniquePdfFile(templateList);

            // Use this variable for manual tests
            //var base64File = Convert.ToBase64String(file);

            if (file is null)
                return new UploadMarketPricingSheetPdfFileDto { Success = false, Message = "Error generating the PDF file." };

            var fileNameOrganization = marketPricingSheetList.Count > 1 ? organizations.FirstOrDefault(o => o.Id == projectVersionDetails.OrganizationKey) : organizations.FirstOrDefault();
            var organizationId = fileNameOrganization?.Id ?? 0;
            var organizationName = fileNameOrganization?.Name ?? string.Empty;

            var uploadResponse = await _fileRepository.UploadMarketPricingSheetPdfFile(file, projectVersionId, marketPricingSheetId, organizationId, organizationName);

            if (uploadResponse.Success)
                await _marketPricingSheetRepository.SaveGeneratedFile(projectVersionId, marketPricingSheetId, uploadResponse, userObjectId);

            return uploadResponse;
        }

        public List<IdNameDto> GetSortingFields()
        {
            return Constants.MPS_SORTABLE_COLUMNS.Select(item => (IdNameDto)item).ToList();
        }

        #region Private Methods
        private string GetStringValueFromEnum(MarketPricingStatus status)
        {
            return status switch
            {
                MarketPricingStatus.NotStarted => "Not Started",
                MarketPricingStatus.AnalystReviewed => "Analyst Reviewed",
                MarketPricingStatus.PeerReviewed => "Peer Reviewed",
                MarketPricingStatus.Complete => "Complete",
                _ => string.Empty
            };
        }

        private async Task<List<OrganizationDto>> ListOrganizations(List<int> organizationIds)
        {
            return await _projectRepository.GetOrganizationsByIds(organizationIds);
        }

        private async Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int projectVersionId, int surveySourceGroupKey)
        {
            var projectBenchmarks = await _projectDetailsRepository.GetProjectBenchmarkDataTypes(projectVersionId);
            var benchmarkDataTypes = new List<BenchmarkDataTypeDto>();

            if (projectBenchmarks is not null && projectBenchmarks.Any())
            {
                var nonFilteredBenchmarkDataTypes = await _benchmarkDataService.GetBenchmarkDataTypes(surveySourceGroupKey);

                foreach (var projectBenchmark in projectBenchmarks)
                {
                    var filteredBenchmark = nonFilteredBenchmarkDataTypes.FirstOrDefault(x => x.Id == projectBenchmark.BenchmarkDataTypeKey);

                    if (filteredBenchmark is not null)
                    {
                        benchmarkDataTypes.Add(new BenchmarkDataTypeDto
                        {
                            Id = projectBenchmark.BenchmarkDataTypeKey,
                            AgingFactor = projectBenchmark.OverrideAgingFactor is not null ? projectBenchmark.OverrideAgingFactor : filteredBenchmark.AgingFactor,
                            Name = filteredBenchmark.Name,
                            LongAlias = filteredBenchmark.LongAlias,
                            ShortAlias = filteredBenchmark.ShortAlias,
                            OrderDataType = filteredBenchmark.OrderDataType,
                            Format = filteredBenchmark.Format,
                            Decimals = filteredBenchmark.Decimals,
                        });
                    }
                }
            }

            return benchmarkDataTypes.OrderBy(b => b.OrderDataType).ToList();
        }

        private List<int> GetPercentiles()
        {
            var percentiles = new List<int>();

            for (int i = 10; i < 95; i += 5)
            {
                percentiles.Add(i);
            }

            return percentiles;
        }

        private List<MainSettingsBenchmarkDto> GetOrderedBenchmarksFromMainSettings(List<MainSettingsBenchmarkDto> mainSettingsBenchmarks, List<BenchmarkDataTypeDto> benchmarks)
        {
            var result = new List<MainSettingsBenchmarkDto>();

            foreach (var mainSettingsBenchmark in mainSettingsBenchmarks.Where(b => benchmarks.Select(benchmark => benchmark.Id).Contains(b.Id)))
            {
                var benchmarkMatch = benchmarks.FirstOrDefault(b => b.Id == mainSettingsBenchmark.Id);

                result.Add(new MainSettingsBenchmarkDto
                {
                    Id = mainSettingsBenchmark.Id,
                    Title = mainSettingsBenchmark.Title,
                    AgingFactor = mainSettingsBenchmark.AgingFactor,
                    Percentiles = mainSettingsBenchmark.Percentiles,
                    Order = benchmarkMatch?.OrderDataType
                });
            }

            return result.OrderBy(i => i.Order).ToList();
        }

        private async Task GetMarketPricingSheetGridItems(List<MarketPricingSheetGridItemDto> gridItemList, ProjectVersionDto projectVersionDetails, List<MarketPricingSheet> marketPricingSheetList,
            IEnumerable<MarketSegmentCutSurveyDetailDto> marketSegmentSurveyDetails, List<BenchmarkDataTypeDto> benchmarkDataTypes, List<int> percentiles,
            List<MarketPricingSheetAdjustmentNoteDto> rawAdjustmentNotes, List<FileLogDto> fileList, List<MarketPricingSheetCutExternal> rawExternalData, bool getPercentilesValue,
            List<SurveyCutDataDto>? rawSurveyData = null)
        {
            if (rawSurveyData is null)
                rawSurveyData = await GetSurveyData(marketSegmentSurveyDetails, benchmarkDataTypes.Select(b => b.Id), marketPricingSheetList.Select(m => m.StandardJobCode).Distinct().ToList());

            //Rows with no percentile data should be removed from the grid
            foreach (var surveyData in rawSurveyData.Where(d => !d.MarketValueByPercentile.All(p => (decimal)p.MarketValue == 0)))
            {
                var adjustmentNotes = rawAdjustmentNotes.Where(a => a.RawDataKey == surveyData.RawDataKey);
                var match = marketSegmentSurveyDetails.FirstOrDefault(d => d.SurveyKey == surveyData.SurveyKey &&
                                                                           d.PublisherKey == surveyData.SurveyPublisherKey &&
                                                                           d.IndustrySectorKey == surveyData.IndustrySectorKey &&
                                                                           d.OrganizationTypeKey == surveyData.OrganizationTypeKey &&
                                                                           d.CutGroupKey == surveyData.CutGroupKey &&
                                                                           d.CutSubGroupKey == surveyData.CutSubGroupKey &&
                                                                           d.CutKey == surveyData.CutKey);
                var marketPricingSheet = marketPricingSheetList.FirstOrDefault(m => m.StandardJobCode == surveyData.StandardJobCode);

                if (marketPricingSheet is not null)
                    FillSurveyDataRow(gridItemList, projectVersionDetails, marketPricingSheet, benchmarkDataTypes, percentiles, fileList, getPercentilesValue, surveyData, adjustmentNotes, match);
            }

            foreach (var externalData in rawExternalData.Where(ed => !ed.Benchmarks.All(p => p.BenchmarkDataTypeValue == 0)))
            {
                var adjustmentNotes = rawAdjustmentNotes.Where(a => a.CutExternalKey == externalData.CutExternalKey);

                FillExternalDataRow(gridItemList, projectVersionDetails, marketPricingSheetList.First().CesOrgId, benchmarkDataTypes, percentiles, fileList, getPercentilesValue, externalData, adjustmentNotes);
            }
        }

        private async Task<List<SurveyCutDataDto>> GetSurveyData(IEnumerable<MarketSegmentCutSurveyDetailDto> marketSegmentSurveyDetails, IEnumerable<int> benchmarkDataTypeKeys, List<string> standardJobCodes)
        {
            var surveyKeys = marketSegmentSurveyDetails.Select(d => d.SurveyKey).OfType<int>().Distinct();
            var industryKeys = marketSegmentSurveyDetails.Select(d => d.IndustrySectorKey).OfType<int>().Distinct();
            var organizationTypeKeys = marketSegmentSurveyDetails.Select(d => d.OrganizationTypeKey).OfType<int>().Distinct();
            var cutGroupKeys = marketSegmentSurveyDetails.Select(d => d.CutGroupKey).OfType<int>().Distinct();
            var cutSubGroupKeys = marketSegmentSurveyDetails.Select(d => d.CutSubGroupKey).OfType<int>().Distinct();
            var cutKeys = marketSegmentSurveyDetails.Select(d => d.CutKey).OfType<int>().Distinct();

            return await _marketPricingSheetRepository.ListSurveyCutsDataWithPercentiles(surveyKeys, industryKeys, organizationTypeKeys, cutGroupKeys, cutSubGroupKeys, cutKeys,
                benchmarkDataTypeKeys, standardJobCodes);
        }

        private void FillSurveyDataRow(List<MarketPricingSheetGridItemDto> gridItemList, ProjectVersionDto projectVersionDetails, MarketPricingSheet marketPricingSheet, List<BenchmarkDataTypeDto> benchmarkDataTypes,
            List<int> percentiles, List<FileLogDto> fileList, bool getPercentilesValue, SurveyCutDataDto surveyData, IEnumerable<MarketPricingSheetAdjustmentNoteDto> adjustmentNotes,
            MarketSegmentCutSurveyDetailDto? match)
        {
            var item = new MarketPricingSheetGridItemDto
            {
                ProjectOrgId = projectVersionDetails.OrganizationKey,
                OrgId = marketPricingSheet.CesOrgId,
                StandardJobCode = marketPricingSheet.StandardJobCode,
                StandardJobTitle = marketPricingSheet.StandardJobTitle,
                MarketSegmentCutDetailKey = match?.MarketSegmentCutDetailKey,
                MarketSegmentCutKey = match?.MarketSegmentCutKey,
                MarketSegmentCutName = match?.MarketSegmentCutName,
                SurveyKey = surveyData.SurveyKey,
                SurveyYear = surveyData.SurveyYear,
                SurveyName = surveyData.SurveyName,
                SurveyCode = surveyData.SurveyCode,
                SurveySpecialtyCode = surveyData.SurveySpecialtyCode,
                SurveySpecialtyName = surveyData.SurveySpecialtyName,
                SurveyPublisherKey = surveyData.SurveyPublisherKey,
                SurveyPublisherName = surveyData.SurveyPublisherName,
                IndustryKey = surveyData.IndustrySectorKey,
                IndustryName = surveyData.IndustrySectorName,
                OrganizationTypeKey = surveyData.OrganizationTypeKey,
                OrganizationTypeName = surveyData.OrganizationTypeName,
                CutGroupKey = surveyData.CutGroupKey,
                CutGroupName = surveyData.CutGroupName,
                CutSubGroupKey = surveyData.CutSubGroupKey,
                CutSubGroupName = surveyData.CutSubGroupName,
                CutKey = surveyData.CutKey,
                CutName = surveyData.CutName,
                ProviderCount = surveyData.ProviderCount,
                RawDataKey = surveyData.RawDataKey,
                FooterNotes = surveyData.FooterNotes,
                SurveyDataEffectiveDate = surveyData.SurveyDataEffectiveDate,
                DataEffectiveDate = fileList.FirstOrDefault()?.EffectiveDate,
                MarketPricingSheetSurveyKey = adjustmentNotes.FirstOrDefault()?.MarketPricingSheetSurveyKey,
                Adjustment = adjustmentNotes.FirstOrDefault()?.AdjustmentValue,
                ExcludeInCalc = adjustmentNotes.FirstOrDefault()?.ExcludeInCalc ?? false,
                AdjustmentNotes = adjustmentNotes.Where(a => !string.IsNullOrEmpty(a.AdjustmentNoteName)).Select(a => a.AdjustmentNoteName).ToList(),
                Benchmarks = GetBenchmarks(surveyData, benchmarkDataTypes, percentiles, getPercentilesValue)
            };

            gridItemList.Add(item);
        }

        private List<BenchmarkPercentilesDto> GetBenchmarks(SurveyCutDataDto? surveyData, List<BenchmarkDataTypeDto> benchmarkDataTypes, List<int> percentiles, bool getPercentilesValue)
        {
            var result = new List<BenchmarkPercentilesDto>();

            foreach (var benchmark in benchmarkDataTypes)
            {
                var newBenchmark = new BenchmarkPercentilesDto
                {
                    Id = benchmark.Id,
                    Title = benchmark.LongAlias,
                    ShortAlias = benchmark.ShortAlias,
                    Format = benchmark.Format,
                    Decimals = benchmark.Decimals,
                    AgingFactor = benchmark.AgingFactor,
                    Percentiles = surveyData?
                                    .MarketValueByPercentile?
                                    .Where(p => percentiles.Contains(p.Percentile)).ToList()
                                    .Select(p => { return getPercentilesValue && surveyData?.BenchmarkDataTypeKey == benchmark.Id ? p : new MarketPercentileDto { Percentile = p.Percentile }; })
                                    .ToList()
                };

                result.Add(newBenchmark);
            }

            return result;
        }

        private void FillExternalDataRow(List<MarketPricingSheetGridItemDto> gridItemList, ProjectVersionDto projectVersionDetails, int cesOrgId,
            List<BenchmarkDataTypeDto> benchmarkDataTypes, List<int> percentiles, List<FileLogDto> fileList, bool getPercentilesValue, MarketPricingSheetCutExternal externalData,
            IEnumerable<MarketPricingSheetAdjustmentNoteDto> adjustmentNotes)
        {
            var externalItem = new MarketPricingSheetGridItemDto
            {
                ProjectOrgId = projectVersionDetails.OrganizationKey,
                OrgId = cesOrgId,
                CutExternalKey = externalData.CutExternalKey,
                SurveySpecialtyCode = externalData.ExternalSurveyJobCode,
                SurveySpecialtyName = externalData.ExternalSurveyJobTitle,
                StandardJobCode = externalData.StandardJobCode,
                StandardJobTitle = externalData.StandardJobTitle,
                MarketSegmentCutName = externalData.ExternalMarketPricingCutName,
                SurveyYear = externalData.ExternalSurveyYear,
                SurveyName = externalData.ExternalSurveyName,
                SurveyPublisherName = externalData.ExternalPublisherName,
                IndustryName = externalData.ExternalIndustrySectorName,
                OrganizationTypeName = externalData.ExternalOrganizationTypeName,
                CutGroupName = externalData.ExternalCutGroupName,
                CutSubGroupName = externalData.ExternalCutSubGroupName,
                CutName = externalData.ExternalSurveyCutName,
                ProviderCount = externalData.IncumbentCount,
                SurveyDataEffectiveDate = externalData.ExternalSurveyEffectiveDate ?? DateTime.UtcNow,
                DataEffectiveDate = fileList.FirstOrDefault()?.EffectiveDate,
                MarketPricingSheetSurveyKey = adjustmentNotes.FirstOrDefault()?.MarketPricingSheetSurveyKey,
                Adjustment = adjustmentNotes.FirstOrDefault()?.AdjustmentValue,
                ExcludeInCalc = adjustmentNotes.FirstOrDefault()?.ExcludeInCalc ?? false,
                AdjustmentNotes = adjustmentNotes.Where(a => !string.IsNullOrEmpty(a.AdjustmentNoteName)).Select(a => a.AdjustmentNoteName).ToList(),
                Benchmarks = GetBenchmarks(externalData, benchmarkDataTypes, percentiles, getPercentilesValue)
            };

            gridItemList.Add(externalItem);
        }

        private List<BenchmarkPercentilesDto> GetBenchmarks(MarketPricingSheetCutExternal externalData, List<BenchmarkDataTypeDto> benchmarkDataTypes, List<int> percentiles, bool getPercentilesValue)
        {
            var result = new List<BenchmarkPercentilesDto>();

            foreach (var benchmark in benchmarkDataTypes)
            {
                var selectedBenchmark = externalData.Benchmarks.Where(b => b.BenchmarkDataTypeKey == benchmark.Id).ToList();
                float defaultZeroValue = 0F;

                var newBenchmark = new BenchmarkPercentilesDto
                {
                    Id = benchmark.Id,
                    Title = benchmark.LongAlias,
                    ShortAlias = benchmark.ShortAlias,
                    AgingFactor = benchmark.AgingFactor,
                    Percentiles = percentiles
                                    .Select(p => new MarketPercentileDto
                                    {
                                        Percentile = p,
                                        MarketValue = getPercentilesValue ? (float?)(selectedBenchmark.FirstOrDefault(b => b.PercentileNumber == p)?.BenchmarkDataTypeValue) ?? defaultZeroValue
                                                                          : defaultZeroValue
                                    })
                                    .ToList()
                };

                result.Add(newBenchmark);
            }

            return result;
        }

        private bool ValidGeneratedFileDate(DateTime fileGeneratedDate, DateTime projectVersionDetailsModifiedDate, List<MarketPricingSheet> marketPricingSheetList,
            IEnumerable<MarketPricingSheetAdjustmentNoteDto> adjustmentNotes)
        {
            var mostRecentDate = projectVersionDetailsModifiedDate;

            var latestModifiedStatusDateMarketPricingSheetList = marketPricingSheetList.Max(a => a.StatusChangeDate);
            if (latestModifiedStatusDateMarketPricingSheetList > mostRecentDate)
                mostRecentDate = latestModifiedStatusDateMarketPricingSheetList;

            if (adjustmentNotes.Any())
            {
                var latestModifiedDateMarketPricingSheetList = adjustmentNotes.Max(a => a.ModifiedUtcDatetime);

                if (latestModifiedDateMarketPricingSheetList > mostRecentDate)
                    mostRecentDate = latestModifiedDateMarketPricingSheetList;
            }

            return fileGeneratedDate > mostRecentDate;
        }

        private void GettingDataForMarketPricingSheetList(int projectVersionId, ProjectVersionDto? projectVersionDetails, List<MarketPricingSheet> marketPricingSheetList, List<MarketSegmentDto> marketSegments,
            List<BenchmarkDataTypeDto> benchmarks, bool displayClientPayDetail, bool displayClientPositionDetail, bool displayJobMatchDetail, out List<Task> taskList,
            out List<MarketPricingSheetThreadDto> taskControllerList)
        {
            taskList = new List<Task>();
            taskControllerList = new List<MarketPricingSheetThreadDto>();

            var marketPricingSheetListGrouped = marketPricingSheetList.GroupBy(m => new { m.Id, m.CesOrgId, m.MarketSegmentId }).Select(m => new
            {
                Id = m.Key.Id,
                CesOrgId = m.Key.CesOrgId,
                MarketSegmentId = m.Key.MarketSegmentId,
                MarketPricingSheetList = m.ToList()
            });

            foreach (var marketPricingSheet in marketPricingSheetListGrouped)
            {
                if (displayClientPayDetail)
                {
                    var task = GetClientPayDetail(projectVersionId, marketPricingSheet.Id);

                    taskControllerList.Add(new MarketPricingSheetThreadDto { MarketPricingSheetId = marketPricingSheet.Id, ClientPayDetailTaskId = task.Id });

                    taskList.Add(task);
                }

                if (displayClientPositionDetail)
                {
                    var task = GetClientPositionDetail(projectVersionId, marketPricingSheet.Id, projectVersionDetails);

                    taskControllerList.Add(new MarketPricingSheetThreadDto { MarketPricingSheetId = marketPricingSheet.Id, ClientPositionDetailTaskId = task.Id });

                    taskList.Add(task);
                }

                if (displayJobMatchDetail)
                {
                    var task = GetJobMatchDetail(projectVersionId, marketPricingSheet.Id);

                    taskControllerList.Add(new MarketPricingSheetThreadDto { MarketPricingSheetId = marketPricingSheet.Id, JobMatchDetailTaskId = task.Id });

                    taskList.Add(task);
                }

                var marketSegment = marketSegments.FirstOrDefault(ms => ms.Id == marketPricingSheet.MarketSegmentId);

                if (marketSegment is not null)
                {
                    var marketSegmentSurveyDetails = marketSegment?.Cuts?
                        .SelectMany(cuts => cuts.CutDetails!)?
                        .Where(cutDetail => cutDetail.Selected)
                        .Select(i => new MarketSegmentCutSurveyDetailDto
                        {
                            MarketSegmentCutDetailKey = i.MarketSegmentCutDetailKey,
                            MarketSegmentCutKey = i.MarketSegmentCutKey,
                            MarketSegmentCutName = marketSegment.Cuts?.FirstOrDefault(cut => cut.MarketSegmentCutKey == i.MarketSegmentCutKey)?.CutName ?? string.Empty,
                            PublisherKey = i.PublisherKey ?? 0,
                            SurveyKey = i.SurveyKey ?? 0,
                            IndustrySectorKey = i.IndustrySectorKey ?? 0,
                            OrganizationTypeKey = i.OrganizationTypeKey ?? 0,
                            CutGroupKey = i.CutGroupKey ?? 0,
                            CutSubGroupKey = i.CutSubGroupKey ?? 0,
                            CutKey = i.CutKey ?? 0
                        }) ?? Enumerable.Empty<MarketSegmentCutSurveyDetailDto>();

                    var surveyDataTask = GetSurveyData(marketSegmentSurveyDetails, benchmarks.Select(b => b.Id), marketPricingSheet.MarketPricingSheetList.Select(m => m.StandardJobCode).Distinct().ToList());
                    taskControllerList.Add(new MarketPricingSheetThreadDto { MarketPricingSheetId = marketPricingSheet.Id, SurveyDataTaskId = surveyDataTask.Id });

                    taskList.Add(surveyDataTask);
                }

                var notesTask = GetNotes(projectVersionId, marketPricingSheet.Id);

                taskControllerList.Add(new MarketPricingSheetThreadDto { MarketPricingSheetId = marketPricingSheet.Id, NotesTaskId = notesTask.Id });
                taskList.Add(notesTask);
            }
        }

        private async Task<string> GetMarketDataDetailTemplate(ProjectVersionDto projectVersionDetails, MainSettingsDto mainSettings, List<MarketPricingSheetAdjustmentNoteDto> adjustmentNotes,
            List<BenchmarkDataTypeDto> benchmarks, List<FileLogDto> fileList, List<CombinedAveragesDto> combinedAverages, List<int> percentiles,
            IEnumerable<MainSettingsBenchmarkDto> benchmarksSelectedFromMainSettings, List<Task> taskList, List<MarketPricingSheet> marketPricingSheetList,
            IEnumerable<MarketPricingSheetThreadDto> tasks, List<MarketPricingSheetGridItemDto> gridItems, MarketSegmentDto? marketSegment, List<MarketPricingSheetCutExternal> externalData,
            bool displayMarketSegmentName)
        {
            var marketSegmentSurveyDetails = marketSegment?.Cuts?
                .SelectMany(cuts => cuts.CutDetails!)?
                .Where(cutDetail => cutDetail.Selected)
                .Select(i => new MarketSegmentCutSurveyDetailDto
                {
                    MarketSegmentCutDetailKey = i.MarketSegmentCutDetailKey,
                    MarketSegmentCutKey = i.MarketSegmentCutKey,
                    MarketSegmentCutName = marketSegment.Cuts?.FirstOrDefault(cut => cut.MarketSegmentCutKey == i.MarketSegmentCutKey)?.CutName ?? string.Empty,
                    PublisherKey = i.PublisherKey ?? 0,
                    SurveyKey = i.SurveyKey ?? 0,
                    IndustrySectorKey = i.IndustrySectorKey ?? 0,
                    OrganizationTypeKey = i.OrganizationTypeKey ?? 0,
                    CutGroupKey = i.CutGroupKey ?? 0,
                    CutSubGroupKey = i.CutSubGroupKey ?? 0,
                    CutKey = i.CutKey ?? 0
                }) ?? Enumerable.Empty<MarketSegmentCutSurveyDetailDto>();

            var surveyDataTaskId = tasks.FirstOrDefault(t => t.SurveyDataTaskId.HasValue)?.SurveyDataTaskId ?? 0;
            var surveyDataTask = taskList.FirstOrDefault(t => t.Id == surveyDataTaskId) as Task<List<SurveyCutDataDto>>;

            var surveyData = surveyDataTask is null ? new List<SurveyCutDataDto>() : await surveyDataTask!;

            var marketPricingSheetId = marketPricingSheetList.First().Id;

            await GetMarketPricingSheetGridItems(gridItems, projectVersionDetails, marketPricingSheetList, marketSegmentSurveyDetails, benchmarks, percentiles,
                adjustmentNotes.Where(a => a.MarketPricingSheetId == marketPricingSheetId).ToList(),
                fileList, externalData, true, surveyData);

            return _marketPricingSheetFileRepository.GetMarketDataDetailHtmlTemplate(marketPricingSheetId, mainSettings.Columns, marketSegment,
                gridItems.Distinct().Where(i => !i.ExcludeInCalc).ToList(), benchmarksSelectedFromMainSettings, mainSettings.AgeToDate ?? DateTime.UtcNow,
                combinedAverages.Where(c => c.MarketSegmentId == marketSegment?.Id), displayMarketSegmentName);
        }

        private async Task<string> GetNotesTemplate(MainSettingsDto? mainSettings, List<BenchmarkDataTypeDto> benchmarks, List<Task> taskList, int marketPricingSheetId,
            IEnumerable<MarketPricingSheetThreadDto> tasks, List<MarketPricingSheetGridItemDto> gridItems)
        {
            var notesTaskId = tasks.FirstOrDefault(t => t.NotesTaskId.HasValue)?.NotesTaskId ?? 0;
            var notesTask = taskList.FirstOrDefault(t => t.Id == notesTaskId) as Task<NewStringValueDto>;

            var notes = await notesTask!;
            var footerNotesList = gridItems.Where(i => !i.ExcludeInCalc && !string.IsNullOrEmpty(i.FooterNotes)).Select(i => i.FooterNotes);

            return _marketPricingSheetFileRepository.GetNotesHtmlTemplate(marketPricingSheetId, mainSettings?.AgeToDate ?? DateTime.UtcNow, notes, benchmarks, footerNotesList);
        }

        private List<string> GenerateSortCriteria(List<int> order, MarketPricingSheetSortType sortType)
        {
            var sortCriteria = new List<string>();
            if (order is not null)
            {
                foreach (int id in order)
                {
                    var columnMap = Constants.MPS_SORTABLE_COLUMNS.FirstOrDefault(c => c.Id == id);
                    if (columnMap is null) throw new Exception($"Invalid Column Id, the missing id is: {id}");
                    switch (sortType)
                    {
                        case MarketPricingSheetSortType.JobTitle:
                            sortCriteria.Add(columnMap.JobTitleName);
                            break;
                        case MarketPricingSheetSortType.Pdf:
                            sortCriteria.Add(columnMap.PdfName);
                            break;
                        default:
                            throw new Exception($"Invalid Sort Type, the missing sort type is {sortType}");
                    }
                }
            }
            return sortCriteria;
        }

        #endregion
    }
}