using CN.Project.Domain.Constants;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using CN.Project.Infrastructure.Repository;

namespace CN.Project.RestApi.Services
{
    public class JobSummaryTableService : IJobSummaryTableService
    {
        private readonly IJobSummaryTableRepository _jobMatchingRepository;
        private readonly IProjectDetailsRepository _projectDetailsRepository;
        private readonly IMarketSegmentMappingRepository _marketSegmentMappingRepository;
        private readonly IMarketPricingSheetRepository _marketPricingSheetRepository;
        private readonly ICombinedAveragesRepository _combinedAveragesRepository;
        private readonly IMarketSegmentService _marketSegmentService;

        public JobSummaryTableService(IJobSummaryTableRepository jobMatchingRepository,
                                      IProjectDetailsRepository projectDetailsRepository,
                                      IMarketSegmentMappingRepository marketSegmentMappingRepository,
                                      IMarketPricingSheetRepository marketPricingSheetRepository,
                                      ICombinedAveragesRepository combinedAveragesRepository,
                                      IMarketSegmentService marketSegmentService)
        {
            _jobMatchingRepository = jobMatchingRepository;
            _projectDetailsRepository = projectDetailsRepository;
            _marketSegmentMappingRepository = marketSegmentMappingRepository;
            _marketPricingSheetRepository = marketPricingSheetRepository;
            _combinedAveragesRepository = combinedAveragesRepository;
            _marketSegmentService = marketSegmentService;
        }

        public async Task<List<JobSummaryTableDto>> GetJobSummaryTable(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null)
        {
            var result = new List<JobSummaryTableDto>();

            var jobSummaryData = await _jobMatchingRepository.GetJobSummaryTable(projectVersionId, jobSummaryComparisonRequestDto?.Filter);

            if (jobSummaryData is not null)
            {
                // Fetching project version details, main settings and market segments asynchronously
                var projectVersionDetailsTask = _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
                var mainSettingsTask = _marketPricingSheetRepository.GetMainSettings(projectVersionId);
                var marketSegmentsTask = _marketSegmentService.GetMarketSegments(projectVersionId);

                // The tasks run in parallel
                await Task.WhenAll(projectVersionDetailsTask, mainSettingsTask, marketSegmentsTask);

                var projectVersionDetails = await projectVersionDetailsTask;
                var mainSettings = await mainSettingsTask;
                var marketSegments = await marketSegmentsTask;

                if (projectVersionDetails is not null && projectVersionDetails.FileLogKey.HasValue && projectVersionDetails.AggregationMethodologyKey.HasValue)
                {
                    var combinedAveragesList = new List<CombinedAveragesDto>();
                    var jobData = await _marketSegmentMappingRepository.GetSourceData(projectVersionDetails.FileLogKey.Value, (int)projectVersionDetails.AggregationMethodologyKey.Value);
                    var taskList = new List<Task>();

                    foreach (var item in jobSummaryData)
                    {
                        var job = jobData.FirstOrDefault(x =>
                            x.AggregationMethodKey == item.AggregationMethodKey &&
                            x.FileOrgKey == item.CesOrgId &&
                            x.JobCode == item.JobCode &&
                            x.PositionCode == item.PositionCode
                        );

                        if (job is not null)
                        {
                            var marketSegment = marketSegments?.FirstOrDefault(m => m.Id == item.MarketSegmentId);

                            taskList.Add(FillJobSummaryRowInformation(jobSummaryComparisonRequestDto, result, mainSettings?.Benchmarks ?? new List<MainSettingsBenchmarkDto>(),
                                marketSegment, combinedAveragesList, job, item));
                        }
                    }

                    await Task.WhenAll(taskList);
                }
            }
            
            return result.OrderBy(j => j.ClientJobCode).ThenBy(j => j.DataScopeKey).ThenBy(j => j.DataSource).ToList();
        }

        public async Task<List<JobSummaryTableEmployeeLevelDto>> GetJobSummaryTableEmployeeLevel(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null)
        {
            var result = new List<JobSummaryTableEmployeeLevelDto>();

            var jobSummaryData = await _jobMatchingRepository.GetJobSummaryTable(projectVersionId);

            if (jobSummaryData is not null)
            {
                // Fetching project version details, main settings and market segments asynchronously
                var projectVersionDetailsTask = _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
                var mainSettingsTask = _marketPricingSheetRepository.GetMainSettings(projectVersionId);
                var marketSegmentsTask = _marketSegmentService.GetMarketSegments(projectVersionId);

                // The tasks run in parallel
                await Task.WhenAll(projectVersionDetailsTask, mainSettingsTask, marketSegmentsTask);

                var projectVersionDetails = await projectVersionDetailsTask;
                var mainSettings = await mainSettingsTask;
                var marketSegments = await marketSegmentsTask;

                if (projectVersionDetails is not null && projectVersionDetails.FileLogKey.HasValue && projectVersionDetails.AggregationMethodologyKey.HasValue)
                {
                    var combinedAveragesList = new List<CombinedAveragesDto>();
                    var jobData = await _marketSegmentMappingRepository.GetSourceDataEmployeeLevel(projectVersionDetails.FileLogKey.Value);
                    var taskList = new List<Task>();

                    foreach (var item in jobSummaryData)
                    {
                        var employees = jobData.Where(x =>
                            x.FileOrgKey == item.CesOrgId &&
                            x.JobCode == item.JobCode &&
                            x.PositionCode == item.PositionCode
                        ).ToList();

                        if (employees is not null)
                        {
                            var marketSegment = marketSegments?.FirstOrDefault(m => m.Id == item.MarketSegmentId);

                            taskList.Add(FillJobSummaryRowInformationEmployeeLevel(jobSummaryComparisonRequestDto, result, mainSettings?.Benchmarks ?? new List<MainSettingsBenchmarkDto>(),
                                marketSegment, combinedAveragesList, employees, item));
                        }
                    }

                    await Task.WhenAll(taskList);
                }
            }

            return result.OrderBy(j => j.ClientJobCode).ThenBy(j => j.DataScopeKey).ThenBy(j => j.DataSource).ToList();
        }

        private async Task FillJobSummaryRowInformation(JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto, List<JobSummaryTableDto> result, List<MainSettingsBenchmarkDto> mainSettingsBenchmarks,
            MarketSegmentDto? marketSegment, List<CombinedAveragesDto> combinedAveragesList, JobDto job, JobSummaryTable item)
        {
            var combinedAveragesMatchList = await GetCombinedAverages(combinedAveragesList, marketSegment);

            result.Add(new JobSummaryTableDto
            {
                IncumbentCount = job.IncumbentCount,
                FteCount = job.FteCount,
                ClientPositionCodeDescription = job.PositionCodeDescription,
                ClientJobCode = item.JobCode,
                ClientJobTitle = item.JobTitle,
                ClientPositionCode = item.PositionCode,
                MarketPricingSheetId = item.MarketPricingSheetId,
                BenchmarkJobCode = item.MarketPricingJobCode,
                BenchmarkJobTitle = item.MarketPricingJobTitle,
                JobMatchAdjustmentNotes = item.MarketPricingSheetNote,
                MarketSegment = item.MarketSegmentName,
                JobGroup = item.JobGroup,
                DataScopeKey = item.DataScopeKey,
                DataSource = item.DataSource,
                DataScope = GetDataScope(item, marketSegment),
                Benchmarks = await GetBenchmarks(mainSettingsBenchmarks, job.BenchmarkDataTypes, marketSegment, item, combinedAveragesMatchList, jobSummaryComparisonRequestDto)
            });
        }

        private async Task<List<CombinedAveragesDto>> GetCombinedAverages(List<CombinedAveragesDto> combinedAveragesList, MarketSegmentDto? marketSegment)
        {
            if (marketSegment is null)
                return new List<CombinedAveragesDto>();

            //To avoid multiple DB calls, we will manage the combined averages list in the memory
            var existingCombinedAverages = combinedAveragesList.Where(c => c.MarketSegmentId == marketSegment.Id);

            if (existingCombinedAverages.Any())
                return existingCombinedAverages.ToList();
            else
            {
                var combinedAveragesMatchList = await _combinedAveragesRepository.GetCombinedAveragesByMarketSegmentId(marketSegment.Id);

                //If there is nothing for this Market Segment, we add a list with only one element, to avoid another DB call 
                if (!combinedAveragesMatchList.Any())
                    combinedAveragesMatchList = new List<CombinedAveragesDto> { new CombinedAveragesDto { MarketSegmentId = marketSegment.Id } };

                combinedAveragesList.AddRange(combinedAveragesMatchList);

                return combinedAveragesMatchList;
            }
        }

        private string GetDataScope(JobSummaryTable jobSummaryItem, MarketSegmentDto? marketSegment)
        {
            switch (jobSummaryItem.DataSource)
            {
                case "ERI":
                    var adjFactor = (int?)(marketSegment?.EriAdjustmentFactor * 100);
                    var percentile = adjFactor.HasValue ? $"({adjFactor}%)" : string.Empty;

                    return $"ERI Adj. National Average {percentile}:";
                case "COMBINED":
                case "CUT":
                    return $"{jobSummaryItem.DataScope} Average:";
                default:
                    return string.Empty;
            }
        }

        private async Task<List<JobSummaryBenchmarkDto>> GetBenchmarks(List<MainSettingsBenchmarkDto> mainSettingsBenchmarks, Dictionary<string, decimal?> clientBenchmarks, MarketSegmentDto? marketSegment,
            JobSummaryTable jobSummaryItem, List<CombinedAveragesDto> combinedAveragesList, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto)
        {
            var result = new List<JobSummaryBenchmarkDto>();
            var surveyData = new List<SurveyCutDataDto>();
            var benchmarkKeys = mainSettingsBenchmarks.Select(b => b.Id).OfType<int>();

            // Will be only set for ERI cases
            decimal? eriAdjusmentFactor = null;

            switch (jobSummaryItem.DataSource)
            {
                case "ERI":
                    eriAdjusmentFactor = marketSegment?.EriAdjustmentFactor;

                    surveyData = await GetBenchmarkValuesFromMarketSegmentEri(benchmarkKeys, marketSegment, jobSummaryItem);
                    break;
                case "COMBINED":
                    var combinedAverages = combinedAveragesList.FirstOrDefault(c => c.Id == jobSummaryItem.DataScopeKey);

                    surveyData = await GetBenchmarkValuesFromMarketSegmentCombinedAverages(benchmarkKeys, marketSegment, combinedAverages, jobSummaryItem);
                    break;
                case "CUT":
                    var selectedCuts = marketSegment?.Cuts?.Where(c => c.CutName == jobSummaryItem.DataScope) ?? Enumerable.Empty<MarketSegmentCutDto>();

                    surveyData = await GetSurveyData(benchmarkKeys, marketSegment, selectedCuts, jobSummaryItem);
                    break;
                default:
                    break;
            }

            foreach (var benchmark in mainSettingsBenchmarks)
            {
                var percentilesForBenchmark = GetPercentilesForBenchmark(surveyData, benchmark.Percentiles, eriAdjusmentFactor);
                var comparisonRequest = jobSummaryComparisonRequestDto?.Benchmarks.FirstOrDefault(c => c.Id == benchmark.Id);
                var comparisons = GetBenchmarkComparisons(clientBenchmarks, benchmark, percentilesForBenchmark, comparisonRequest);

                result.Add(new JobSummaryBenchmarkDto
                {
                    Id = benchmark.Id,
                    Title = $"Market {benchmark.Title}",
                    Percentiles = percentilesForBenchmark,
                    Comparisons = comparisons
                });
            }

            return result;
        }

        private async Task<List<SurveyCutDataDto>> GetBenchmarkValuesFromMarketSegmentEri(IEnumerable<int> benchmarkKeys, MarketSegmentDto? marketSegment, JobSummaryTable jobSummaryItem)
        {
            var nationalCuts = marketSegment?.Cuts?.Where(c => !string.IsNullOrEmpty(c.CutGroupName) && c.CutGroupName.Equals(Constants.NATIONAL_GROUP_NAME))
                ?? Enumerable.Empty<MarketSegmentCutDto>();

            return await GetSurveyData(benchmarkKeys, marketSegment, nationalCuts, jobSummaryItem);
        }

        private async Task<List<SurveyCutDataDto>> GetBenchmarkValuesFromMarketSegmentCombinedAverages(IEnumerable<int> benchmarkKeys, MarketSegmentDto? marketSegment,
            CombinedAveragesDto? combinedAverages, JobSummaryTable jobSummaryItem)
        {
            var selectedCutsNames = combinedAverages?.Cuts.Select(c => c.Name).OfType<string>() ?? Enumerable.Empty<string>();
            var selectedCuts = marketSegment?.Cuts?.Where(c => selectedCutsNames.Contains(c.CutName)) ?? Enumerable.Empty<MarketSegmentCutDto>();

            return await GetSurveyData(benchmarkKeys, marketSegment, selectedCuts, jobSummaryItem);
        }

        private async Task<List<SurveyCutDataDto>> GetSurveyData(IEnumerable<int> benchmarkKeys, MarketSegmentDto? marketSegment, IEnumerable<MarketSegmentCutDto> selectedCuts, JobSummaryTable jobSummaryItem)
        {
            var surveyKeys = new List<int>();
            var industrySectorKeys = new List<int>();
            var organizationTypeKeys = new List<int>();
            var cutGroupKeys = new List<int>();
            var cutSubGroupKeys = new List<int>();
            var cutKeys = new List<int>();

            foreach (var selectedCut in selectedCuts.Where(c => c.DisplayOnReport))
            {
                IEnumerable<MarketSegmentCutDetailDto> validCutDetails;

                if (selectedCut.BlendFlag)
                {
                    var childrenCuts = marketSegment?.Blends?.SelectMany(b => b.Cuts ?? Enumerable.Empty<MarketSegmentBlendCutDto>()) ?? Enumerable.Empty<MarketSegmentBlendCutDto>();
                    var childrenCutsKeys = childrenCuts.Select(cc => cc.ChildMarketSegmentCutKey).OfType<int>();
                    var validCuts = marketSegment?.Cuts?.Where(c => childrenCutsKeys.Contains(c.MarketSegmentCutKey) && c.DisplayOnReport);

                    validCutDetails = validCuts?.SelectMany(vc => vc.CutDetails ?? Enumerable.Empty<MarketSegmentCutDetailDto>())?.Where(c => c.Selected) ?? Enumerable.Empty<MarketSegmentCutDetailDto>();
                }
                else
                {
                    validCutDetails = selectedCut.CutDetails?.Where(c => c.Selected) ?? Enumerable.Empty<MarketSegmentCutDetailDto>();
                }

                surveyKeys.AddRange(validCutDetails.Select(cd => cd.SurveyKey).OfType<int>() ?? Enumerable.Empty<int>());
                industrySectorKeys.AddRange(validCutDetails.Select(cd => cd.IndustrySectorKey).OfType<int>() ?? Enumerable.Empty<int>());
                organizationTypeKeys.AddRange(validCutDetails.Select(cd => cd.OrganizationTypeKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutGroupKeys.AddRange(validCutDetails.Select(cd => cd.CutGroupKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutSubGroupKeys.AddRange(validCutDetails.Select(cd => cd.CutSubGroupKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutKeys.AddRange(validCutDetails.Select(cd => cd.CutKey).OfType<int>() ?? Enumerable.Empty<int>());
            }

            var surveyData = await _marketPricingSheetRepository.ListSurveyCutsDataWithPercentiles(surveyKeys.Distinct(), industrySectorKeys.Distinct(), organizationTypeKeys.Distinct(),
                cutGroupKeys.Distinct(), cutSubGroupKeys.Distinct(), cutKeys.Distinct(), benchmarkKeys, new List<string> { jobSummaryItem.StandardJobCode });

            return surveyData;
        }

        private List<MarketPercentileDto> GetPercentilesForBenchmark(List<SurveyCutDataDto> surveyData, List<int> mainSettingsPercentiles, decimal? eriAdjusmentFactor)
        {
            var result = new List<MarketPercentileDto>();
            var surveyDataPercentiles = surveyData.SelectMany(data => data.MarketValueByPercentile).Where(p => mainSettingsPercentiles.Contains(p.Percentile)) ?? new List<MarketPercentileDto>();

            foreach (var percentile in mainSettingsPercentiles)
            {
                var percentileValues = surveyDataPercentiles.Where(p => p.Percentile == percentile).Select(p => p.MarketValue);

                result.Add(new MarketPercentileDto { Percentile = percentile, MarketValue = GetPercentileValue(percentileValues, eriAdjusmentFactor) });
            }

            return result;
        }

        private List<BenchmarkComparisonDto> GetBenchmarkComparisons(Dictionary<string, decimal?> clientBenchmarks, MainSettingsBenchmarkDto benchmark, List<MarketPercentileDto> percentilesForBenchmark,
            BenchmarkComparisonRequestDto? comparisonRequest)
        {
            var benchmarkComparisons = new List<BenchmarkComparisonDto>();

            // Getting the Market Benchmark Comparison
            var clientAverage = clientBenchmarks.FirstOrDefault(b => b.Key == benchmark.Id.ToString()).Value ?? 0;

            benchmarkComparisons.Add(new BenchmarkComparisonDto
            {
                Id = benchmark.Id,
                Title = $"Client {benchmark.Title} Comparison",
                Average = clientAverage,
                Ratios = percentilesForBenchmark.ToDictionary(p => p.Percentile, p => CalculateRatio(clientAverage, p.MarketValue))
            });

            if (comparisonRequest is not null)
            {
                // The comparison for the Benchmark itself was already built before
                foreach (var comparison in comparisonRequest.Comparisons.Where(c => c.Id != benchmark.Id))
                {
                    var clientAverageForBenchmarkCompared = clientBenchmarks.FirstOrDefault(b => b.Key == comparison.Id.ToString()).Value ?? 0;

                    benchmarkComparisons.Add(new BenchmarkComparisonDto
                    {
                        Id = comparison.Id,
                        Title = comparison.Title.Contains("Comparison") ? comparison.Title : $"Client {comparison.Title} Comparison",
                        Average = clientAverageForBenchmarkCompared,
                        Ratios = percentilesForBenchmark.ToDictionary(p => p.Percentile, p => CalculateRatio(clientAverageForBenchmarkCompared, p.MarketValue))
                    });
                }
            }

            return benchmarkComparisons;
        }

        private string CalculateRatio(decimal clientAverage, float marketValue)
        {
            return (decimal)marketValue == 0 ? "DIV/0" : (clientAverage / (decimal)marketValue).ToString("F");
        }

        private float GetPercentileValue(IEnumerable<float> percentileValues, decimal? eriAdjusmentFactor)
        {
            var averageValue = percentileValues.Any() ? percentileValues.Average() : 0;

            return eriAdjusmentFactor.HasValue ? averageValue * (float)eriAdjusmentFactor.Value : averageValue;
        }

        #region Employees Level

        private async Task FillJobSummaryRowInformationEmployeeLevel(JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto, List<JobSummaryTableEmployeeLevelDto> result, List<MainSettingsBenchmarkDto> mainSettingsBenchmarks,
            MarketSegmentDto? marketSegment, List<CombinedAveragesDto> combinedAveragesList,List<JobEmployeeDto> employees, JobSummaryTable item)
        {
            var combinedAveragesMatchList = await GetCombinedAverages(combinedAveragesList, marketSegment);

            foreach (var employee in employees)
            {
                result.Add(new JobSummaryTableEmployeeLevelDto
                {
                    IncumbentId = employee.IncumbentId,
                    IncumbentName = employee.IncumbentName,
                    FteValue = employee.FteValue,
                    ClientPositionCodeDescription = employee.PositionCodeDescription,
                    ClientJobCode = item.JobCode,
                    ClientJobTitle = item.JobTitle,
                    ClientPositionCode = item.PositionCode,
                    MarketPricingSheetId = item.MarketPricingSheetId,
                    BenchmarkJobCode = item.MarketPricingJobCode,
                    BenchmarkJobTitle = item.MarketPricingJobTitle,
                    JobMatchAdjustmentNotes = item.MarketPricingSheetNote,
                    MarketSegment = item.MarketSegmentName,
                    JobGroup = item.JobGroup,
                    DataScopeKey = item.DataScopeKey,
                    DataSource = item.DataSource,
                    DataScope = GetDataScope(item, marketSegment),
                    Benchmarks = await GetBenchmarks(mainSettingsBenchmarks, employee.BenchmarkDataTypes, marketSegment, item, combinedAveragesMatchList, jobSummaryComparisonRequestDto)
                });
            }           
        }

        #endregion

    }
}