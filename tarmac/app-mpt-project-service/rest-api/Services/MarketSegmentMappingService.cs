using CN.Project.Domain;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using CN.Project.Domain.Utils;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;
using System.Reflection;

namespace CN.Project.RestApi.Services;

public class MarketSegmentMappingService : IMarketSegmentMappingService
{
    private const string BENCHMARK_DATA_TYPES_PROPERTY_NAME = "benchmarkDataTypes";

    private readonly IMarketSegmentMappingRepository _marketSegmentMappingRepository;
    private readonly IProjectRepository _projectRepository;
    private readonly IProjectDetailsRepository _projectDetailsRepository;
    private readonly IMarketSegmentRepository _marketSegmentRepository;
    private readonly IBenchmarkDataService _benchmarkDataService;

    public MarketSegmentMappingService(IMarketSegmentMappingRepository marketSegmentMappingRepository,
                                       IProjectDetailsRepository projectDetailsRepository,
                                       IProjectRepository projectRepository,
                                       IMarketSegmentRepository marketSegmentRepository,
                                       IBenchmarkDataService benchmarkDataService)
    {
        _marketSegmentMappingRepository = marketSegmentMappingRepository;
        _projectDetailsRepository = projectDetailsRepository;
        _projectRepository = projectRepository;
        _marketSegmentRepository = marketSegmentRepository;
        _benchmarkDataService = benchmarkDataService;
    }

    public async Task<List<JobDto>?> GetJobs(int projectVersionId, string? filterInput, string? filterColumn)
    {
        var projectVersionDetails = await _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
        if (projectVersionDetails == null || projectVersionDetails.FileLogKey == null || projectVersionDetails.AggregationMethodologyKey == null)
            return new List<JobDto>();

        var aggregationMethodologyKey = (int)projectVersionDetails.AggregationMethodologyKey.Value;
        var benchmarkDataTypeKeys = await _projectDetailsRepository.GetBenchmarkDataTypeKeys(projectVersionId);
        var marketPricingSheets = await _marketSegmentMappingRepository.GetMarketPricingSheet(projectVersionId, aggregationMethodologyKey);

        //Getting source data aggregation from Incumbent gRPC server
        var jobs = await _marketSegmentMappingRepository.GetSourceData(projectVersionDetails.FileLogKey.Value, aggregationMethodologyKey);
        var orgIds = jobs.Select(x => x.FileOrgKey)?.Distinct().ToList();

        //Getting organization data from Organization gRPC server
        var organizations = orgIds?.Count > 0 ? await _projectRepository.GetOrganizationsByIds(orgIds) : new List<OrganizationDto>();

        //Getting benchmark data types from Survey gRPC server
        var benchmarkDataTypes = benchmarkDataTypeKeys?.Count > 0 ? await _benchmarkDataService.GetBenchmarkDataTypes(projectVersionDetails.SurveySourceGroupKey ?? 0) : new List<BenchmarkDataTypeDto>();

        //Taking only the ones that are selected in the project version
        benchmarkDataTypes = benchmarkDataTypes.Where(x => benchmarkDataTypeKeys.Contains(x.Id)).ToList();

        Parallel.ForEach(jobs, clientJob =>
        {
            clientJob.OrganizationName = organizations.FirstOrDefault(o => o.Id == clientJob.FileOrgKey)?.Name?.Trim();

            var matchedSheet = marketPricingSheets.FirstOrDefault(ms => ms.AggregationMethodKey == clientJob.AggregationMethodKey &&
                                                                 ms.CesOrgId == clientJob.FileOrgKey &&
                                                                 ms.JobCode == clientJob.JobCode &&
                                                                 ms.PositionCode == clientJob.PositionCode);

            clientJob.JobGroup = !string.IsNullOrWhiteSpace(matchedSheet?.JobGroup) ? matchedSheet.JobGroup : clientJob.JobGroup;
            clientJob.MarketSegmentId = matchedSheet?.MarketSegmentId;
            clientJob.MarketSegmentName = matchedSheet?.MarketSegmentName ?? string.Empty;
            clientJob.StandardJobCode = matchedSheet?.StandardJobCode ?? string.Empty;
            clientJob.StandardJobTitle = matchedSheet?.StandardJobTitle ?? string.Empty;
            clientJob.StandardJobDescription = matchedSheet?.StandardJobDescription ?? string.Empty;
            clientJob.JobMatchStatusName = matchedSheet?.JobMatchStatusName ?? string.Empty;
            clientJob.JobMatchStatusKey = matchedSheet?.JobMatchStatusKey;
            clientJob.JobMatchNote = matchedSheet?.JobMatchNote ?? string.Empty;

            var benchmarkList = new Dictionary<string, decimal?>();
            var formattedBenchmarkList = new Dictionary<string, string?>();

            foreach (var benchmark in benchmarkDataTypes)
            {
                if (clientJob.BenchmarkDataTypes.TryGetValue(benchmark.Id.ToString(), out var value))
                {
                    benchmarkList.Add(benchmark.LongAlias, value);

                    var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue((double?)value, benchmark.Format, benchmark.Decimals);
                    formattedBenchmarkList.Add(benchmark.LongAlias, formattedValue);
                }
                else
                {
                    //If the benchmark data type doesn't exist in the file we add null, we still need to show the column in the UI
                    benchmarkList.Add(benchmark.LongAlias, null);
                    formattedBenchmarkList.Add(benchmark.LongAlias, null);
                }
            }

            clientJob.BenchmarkDataTypes = benchmarkList;
            clientJob.FormattedBenchmarkDataTypes = formattedBenchmarkList;
        });

        if (!string.IsNullOrEmpty(filterInput) && !string.IsNullOrEmpty(filterColumn))
        {
            var filteredJobs = new List<JobDto>();

            Parallel.ForEach(jobs, job =>
            {
                var propertyValue = GetPropertyValue(job, filterColumn);

                if (propertyValue is not null && propertyValue.ToUpper().Contains(filterInput.Trim().ToUpper()))
                    filteredJobs.Add(job);
            });

            jobs = filteredJobs;
        }

        return jobs;
    }

    public async Task<List<MarketSegmentDto>> GetMarketSegments(int projectVersionId)
    {
        var marketSegments = await _marketSegmentRepository.GetMarketSegments(projectVersionId);
        return marketSegments ?? new List<MarketSegmentDto>();
    }

    public async Task SaveMarketSegmentMapping(int projectVersionId, List<MarketSegmentMappingDto> marketSegmentMappings, string? userObjectId)
    {
        foreach (var mapping in marketSegmentMappings)
        {
            await _marketSegmentMappingRepository.SaveMarketSegmentMapping(projectVersionId, mapping, userObjectId);
        }
    }

    public async Task<int> GetProjectVersionStatus(int projectVersionId)
    {
        return await _projectRepository.GetProjectVersionStatus(projectVersionId);
    }

    private string? GetPropertyValue(object src, string propName)
    {
        //To make the property search case insensitive
        var property = src.GetType().GetProperty(propName, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);

        if (property is null)
        {
            //Information will be inside the Benchmark Data Types
            var benchmarkDataTypes = (Dictionary<string, decimal?>?)src.GetType()?
                .GetProperty(BENCHMARK_DATA_TYPES_PROPERTY_NAME, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance)?
                .GetValue(src, null);

            return benchmarkDataTypes is not null && benchmarkDataTypes.TryGetValue(propName, out var value) ? value?.ToString() : null;
        }

        return (string?)property.GetValue(src, null);
    }
}
