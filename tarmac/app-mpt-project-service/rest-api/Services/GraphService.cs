using CN.Project.Domain.Constants;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;
using SixLabors.ImageSharp;
using System;

namespace CN.Project.RestApi.Services
{
    public class GraphService : IGraphService
    {
        private readonly IJobSummaryTableRepository _jobSummaryTableRepository;
        private readonly IProjectDetailsRepository _projectDetailsRepository;
        private readonly IMarketSegmentMappingRepository _marketSegmentMappingRepository;
        private readonly IMarketPricingSheetRepository _marketPricingSheetRepository;
        private readonly IMarketSegmentService _marketSegmentService;

        public GraphService(IJobSummaryTableRepository jobSummaryTableRepository,
                            IProjectDetailsRepository projectDetailsRepository,
                            IMarketSegmentMappingRepository marketSegmentMappingRepository,
                            IMarketPricingSheetRepository marketPricingSheetRepository,
                            IMarketSegmentService marketSegmentService)
        {
            _jobSummaryTableRepository = jobSummaryTableRepository;
            _projectDetailsRepository = projectDetailsRepository;
            _marketSegmentMappingRepository = marketSegmentMappingRepository;
            _marketPricingSheetRepository = marketPricingSheetRepository;
            _marketSegmentService = marketSegmentService;
        }

        public async Task<List<JobSummaryTableEmployeeLevelDto>> GetBasePayMarketComparisonGraphData(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null)
        {
            var result = new List<JobSummaryTableEmployeeLevelDto>();

            var jobSummaryDataTask = _jobSummaryTableRepository.GetJobSummaryTable(projectVersionId);
            var marketSegmentsTask = _marketSegmentService.GetMarketSegments(projectVersionId);

            await Task.WhenAll(jobSummaryDataTask, marketSegmentsTask);

            var jobSummaryData = await jobSummaryDataTask;
            var marketSegments = await marketSegmentsTask;

            if (jobSummaryData is not null)
            {
                var projectVersionDetailsTask = _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
                var mainSettingsTask = _marketPricingSheetRepository.GetMainSettings(projectVersionId);

                await Task.WhenAll(projectVersionDetailsTask, mainSettingsTask);

                var projectVersionDetails = await projectVersionDetailsTask;
                var mainSettings = await mainSettingsTask;

                if (projectVersionDetails is not null && projectVersionDetails.FileLogKey.HasValue && projectVersionDetails.AggregationMethodologyKey.HasValue)
                {
                    var jobData = await _marketSegmentMappingRepository.GetSourceDataEmployeeLevel(projectVersionDetails.FileLogKey.Value);
                    var taskList = new List<Task>();

                    // Grouping by MPS Id, since it can have many Standard Job Codes
                    var jobSummaryDataListGrouped = jobSummaryData.GroupBy(x => x.MarketPricingSheetId).Select(m => new { Id = m.Key, EmployeeData = m.ToList() });

                    foreach (var employeeData in jobSummaryDataListGrouped)
                    {
                        // Use National Adjusted ERI Average market data if available
                        // If no ERI adjustment has been made, use National Average market data
                        var nationalEmployeeData = employeeData.EmployeeData.Any(data => data.DataSource == "ERI") ? employeeData.EmployeeData.Where(data => data.DataSource == "ERI").ToList()
                                                                                                                   : GetNationalDataForEmployee(employeeData.EmployeeData, marketSegments);

                        // If either the Client Hourly Base Pay or Market Data(National Adjusted ERI Average or National Average) is not available based on the Employee view of the Market Summary table,
                        // the employee's compa-ratios will not be calculated.
                        if (!nationalEmployeeData.Any())
                            continue;

                        var employeeDataSample = nationalEmployeeData.First();

                        var clientEmployees = jobData.Where(x => x.FileOrgKey == employeeDataSample.CesOrgId &&
                                                            x.JobCode == employeeDataSample.JobCode &&
                                                            x.PositionCode == employeeDataSample.PositionCode).ToList();

                        if (clientEmployees is not null)
                        {
                            var marketSegment = marketSegments?.FirstOrDefault(m => m.Id == employeeDataSample.MarketSegmentId);

                            taskList.Add(FillEmployeeInformation(jobSummaryComparisonRequestDto, result, mainSettings?.Benchmarks ?? new List<MainSettingsBenchmarkDto>(),
                                marketSegment, clientEmployees, nationalEmployeeData));
                        }
                    }

                    await Task.WhenAll(taskList);
                }
            }

            return result.OrderBy(j => j.ClientJobCode).ThenBy(j => j.DataScopeKey).ThenBy(j => j.DataSource).ToList();
        }

        private List<JobSummaryTable> GetNationalDataForEmployee(List<JobSummaryTable> jobSummaryData, List<MarketSegmentDto>? marketSegments)
        {
            var selectedMarketSegments = marketSegments?.Where(m => jobSummaryData.Select(job => job.MarketSegmentId).Contains(m.Id)) ?? new List<MarketSegmentDto>();
            var nationalCuts = selectedMarketSegments.SelectMany(s => s.Cuts!).Where(x => x.CutGroupName == Constants.NATIONAL_GROUP_NAME);
            var nationalCutsNameList = nationalCuts.Select(n => n.CutName);

            return jobSummaryData.Where(data => data.DataSource == "CUT" && nationalCutsNameList.Contains(data.DataScope)).ToList();
        }


        private async Task FillEmployeeInformation(JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto, List<JobSummaryTableEmployeeLevelDto> result,
            List<MainSettingsBenchmarkDto> mainSettingsBenchmarks, MarketSegmentDto? marketSegment, List<JobEmployeeDto> clientEmployees, List<JobSummaryTable> employeeData)
        {
            foreach (var clientEmployee in clientEmployees)
            {
                var employeeDataSample = employeeData.First();

                result.Add(new JobSummaryTableEmployeeLevelDto
                {
                    IncumbentId = clientEmployee.IncumbentId,
                    IncumbentName = clientEmployee.IncumbentName,
                    FteValue = clientEmployee.FteValue,
                    ClientPositionCodeDescription = clientEmployee.PositionCodeDescription,
                    CreditedYoe = ParseDecimal(clientEmployee.CreditedYoe),
                    OriginalHireDate = ParseDateTime(clientEmployee.OriginalHireDate),
                    ClientJobCode = employeeDataSample.JobCode,
                    ClientJobTitle = employeeDataSample.JobTitle,
                    ClientPositionCode = employeeDataSample.PositionCode,
                    MarketPricingSheetId = employeeDataSample.MarketPricingSheetId,
                    BenchmarkJobCode = employeeDataSample.MarketPricingJobCode,
                    BenchmarkJobTitle = employeeDataSample.MarketPricingJobTitle,
                    JobMatchAdjustmentNotes = employeeDataSample.MarketPricingSheetNote,
                    MarketSegment = employeeDataSample.MarketSegmentName,
                    JobGroup = employeeDataSample.JobGroup,
                    DataScopeKey = employeeDataSample.DataScopeKey,
                    DataSource = employeeDataSample.DataSource,
                    DataScope = GetDataScope(employeeDataSample, marketSegment),
                    Benchmarks = await GetBenchmarks(mainSettingsBenchmarks, clientEmployee.BenchmarkDataTypes, marketSegment, employeeData.Select(e => e.StandardJobCode), jobSummaryComparisonRequestDto)
                });
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
                case "CUT":
                    return $"{jobSummaryItem.DataScope} Average:";
                default:
                    return string.Empty;
            }
        }

        private async Task<List<JobSummaryBenchmarkDto>> GetBenchmarks(List<MainSettingsBenchmarkDto> mainSettingsBenchmarks, Dictionary<string, decimal?> clientBenchmarks, MarketSegmentDto? marketSegment,
            IEnumerable<string> standardJobCodes, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto)
        {
            var result = new List<JobSummaryBenchmarkDto>();
            var benchmarkKeys = mainSettingsBenchmarks.Select(b => b.Id).OfType<int>();
            var surveyData = await GetNationalSurveyData(benchmarkKeys, marketSegment, standardJobCodes);

            foreach (var benchmark in mainSettingsBenchmarks)
            {
                var percentilesForBenchmark = GetPercentilesForBenchmark(surveyData, benchmark.Percentiles, marketSegment?.EriAdjustmentFactor);
                var comparisonRequest = jobSummaryComparisonRequestDto?.Benchmarks.FirstOrDefault(c => c.Id == benchmark.Id);
                var comparisons = GetBenchmarkComparisons(clientBenchmarks, benchmark, percentilesForBenchmark, comparisonRequest);

                result.Add(new JobSummaryBenchmarkDto
                {
                    Id = benchmark.Id,
                    Title = benchmark.Title,
                    Percentiles = percentilesForBenchmark,
                    Comparisons = comparisons
                });
            }

            return result;
        }

        private async Task<List<SurveyCutDataDto>> GetNationalSurveyData(IEnumerable<int> benchmarkKeys, MarketSegmentDto? marketSegment, IEnumerable<string> standardJobCodes)
        {
            var nationalCuts = marketSegment?.Cuts?.Where(c => !string.IsNullOrEmpty(c.CutGroupName) && c.CutGroupName.Equals(Constants.NATIONAL_GROUP_NAME))
                ?? Enumerable.Empty<MarketSegmentCutDto>();

            var surveyKeys = new List<int>();
            var industrySectorKeys = new List<int>();
            var organizationTypeKeys = new List<int>();
            var cutGroupKeys = new List<int>();
            var cutSubGroupKeys = new List<int>();
            var cutKeys = new List<int>();

            foreach (var selectedCut in nationalCuts.Where(c => c.DisplayOnReport))
            {
                var validCutDetails = selectedCut.CutDetails?.Where(c => c.Selected) ?? Enumerable.Empty<MarketSegmentCutDetailDto>();

                surveyKeys.AddRange(validCutDetails.Select(cd => cd.SurveyKey).OfType<int>() ?? Enumerable.Empty<int>());
                industrySectorKeys.AddRange(validCutDetails.Select(cd => cd.IndustrySectorKey).OfType<int>() ?? Enumerable.Empty<int>());
                organizationTypeKeys.AddRange(validCutDetails.Select(cd => cd.OrganizationTypeKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutGroupKeys.AddRange(validCutDetails.Select(cd => cd.CutGroupKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutSubGroupKeys.AddRange(validCutDetails.Select(cd => cd.CutSubGroupKey).OfType<int>() ?? Enumerable.Empty<int>());
                cutKeys.AddRange(validCutDetails.Select(cd => cd.CutKey).OfType<int>() ?? Enumerable.Empty<int>());
            }

            var surveyData = await _marketPricingSheetRepository.ListSurveyCutsDataWithPercentiles(surveyKeys.Distinct(), industrySectorKeys.Distinct(), organizationTypeKeys.Distinct(),
                cutGroupKeys.Distinct(), cutSubGroupKeys.Distinct(), cutKeys.Distinct(), benchmarkKeys, standardJobCodes);

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

        private float GetPercentileValue(IEnumerable<float> percentileValues, decimal? eriAdjusmentFactor)
        {
            var averageValue = percentileValues.Any() ? percentileValues.Average() : 0;

            return eriAdjusmentFactor.HasValue ? averageValue * (float)eriAdjusmentFactor.Value : averageValue;
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
                Title = benchmark.Title,
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
                        Title = comparison.Title,
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

        private decimal? ParseDecimal(string value)
        {
            if (string.IsNullOrEmpty(value))
                return null;

            return decimal.Parse(value);
        }

        private DateTime? ParseDateTime(string value)
        {
            if (string.IsNullOrEmpty(value))
                return null;

            return DateTime.Parse(value);
        }
    }
}