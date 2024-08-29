using Cn.Survey;
using CN.Project.Domain.Constants;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;

namespace CN.Project.RestApi.Services
{
    public class JobMatchingService : IJobMatchingService
    {
        private readonly IJobMatchingRepository _jobMatchingRepository;
        private readonly IProjectRepository _projectRepository;
        private readonly IMarketSegmentMappingRepository _marketSegmentMappingRepository;
        private readonly IMarketSegmentRepository _marketSegmentRepository;
        private readonly IProjectDetailsRepository _projectDetailsRepository;
        private readonly IBenchmarkDataService _benchmarkDataService;

        private const int TENTH_PERCENTILE = 10;
        private const int FIFTIETH_PERCENTILE = 50;
        private const int NINETIETH_PERCENTILE = 90;

        public JobMatchingService(IJobMatchingRepository jobMatchingRepository,
                                  IProjectRepository projectRepository,
                                  IMarketSegmentMappingRepository marketSegmentMappingRepository,
                                  IMarketSegmentRepository marketSegmentRepository,
                                  IProjectDetailsRepository projectDetailsRepository,
                                  IBenchmarkDataService benchmarkDataService)
        {
            _jobMatchingRepository = jobMatchingRepository;
            _projectRepository = projectRepository;
            _marketSegmentMappingRepository = marketSegmentMappingRepository;
            _marketSegmentRepository = marketSegmentRepository;
            _projectDetailsRepository = projectDetailsRepository;
            _benchmarkDataService = benchmarkDataService;
        }

        public async Task SaveJobMatchingStatus(int projectVersionId, int marketPricingStatusKey, List<JobMatchingStatusUpdateDto> jobMatchingStatusUpdate, string? userObjectId)
        {
            foreach (var mapping in jobMatchingStatusUpdate)
            {
                await _jobMatchingRepository.SaveJobMatchingStatus(projectVersionId, marketPricingStatusKey, mapping, userObjectId);
            }
        }

        public async Task<int> GetProjectVersionStatus(int projectVersionId)
        {
            return await _projectRepository.GetProjectVersionStatus(projectVersionId);
        }

        public async Task<JobMatchingInfo?> GetMarketPricingJobInfo(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs)
        {
            var jobMatchingInfo = await _jobMatchingRepository.GetMarketPricingJobInfo(projectVersionId, selectedJobs);
            if (jobMatchingInfo is not null)
                jobMatchingInfo.StandardJobs = await _jobMatchingRepository.GetStandardMatchedJobs(projectVersionId, selectedJobs);

            return jobMatchingInfo;
        }

        public async Task SaveClientJobsMatching(int projectVersionId, JobMatchingSaveData jobMatchingSaveData, string? userObjectId)
        {
            // Zero or null will be Standard Publisher that is hardcoded in the FE
            jobMatchingSaveData.PublisherKey = jobMatchingSaveData.PublisherKey > 0 ? jobMatchingSaveData.PublisherKey : null;
            await _jobMatchingRepository.SaveClientJobsMatching(projectVersionId, jobMatchingSaveData, userObjectId);
        }

        public async Task<bool> CheckEditionForSelectedJobs(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs)
        {
            if (selectedJobs.Count == 0 || selectedJobs.Count == 1)
                return true;

            //The first list is gonna be the reference for the comparison of the other lists
            var jobMatchingDataReference = await _jobMatchingRepository.GetJobMatchingSavedData(projectVersionId, selectedJobs[0]);
            var referenceStandardJobList = jobMatchingDataReference.StandardJobs.Select(job => job.StandardJobCode).OrderBy(j => j).Distinct().ToList();

            for (int i = 1; i < selectedJobs.Count; i++)
            {
                var currentJobMatchingData = await _jobMatchingRepository.GetJobMatchingSavedData(projectVersionId, selectedJobs[i]);
                var standardJobList = currentJobMatchingData.StandardJobs.Select(job => job.StandardJobCode).OrderBy(j => j).Distinct().ToList();

                if (!referenceStandardJobList.SequenceEqual(standardJobList) || !HeadersAreEqual(jobMatchingDataReference, currentJobMatchingData))
                    return false;
            }

            return true;
        }

        public async Task<AuditCalculationDto> GetAuditCalculations(int projectVersionId, AuditCalculationRequestDto request)
        {
            var result = new AuditCalculationDto();

            var projectVersionDetails = await _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
            if (projectVersionDetails == null)
                return result;

            if (projectVersionDetails.FileLogKey.HasValue && projectVersionDetails.AggregationMethodologyKey.HasValue)
            {
                // Fetching market pricing sheets, and benchmark data type keys asynchronously
                var marketPricingSheetTask = _marketSegmentMappingRepository.GetMarketPricingSheet(projectVersionId, (int)projectVersionDetails.AggregationMethodologyKey.Value);
                var benchmarkDataTypeKeyTask = _projectDetailsRepository.GetBenchmarkDataTypeKeys(projectVersionId);

                // The tasks run in parallel
                await Task.WhenAll(marketPricingSheetTask, benchmarkDataTypeKeyTask);

                var marketPricingSheets = await marketPricingSheetTask;
                var benchmarkDataTypeKeys = await benchmarkDataTypeKeyTask;

                var benchmarkDataTypes = new List<BenchmarkDataTypeDto>();

                //Getting benchmark data types from Survey gRPC server
                if (benchmarkDataTypeKeys is not null && benchmarkDataTypeKeys.Any())
                {
                    var nonFilteredBenchmarkDataTypes = await _benchmarkDataService.GetBenchmarkDataTypes(projectVersionDetails.SurveySourceGroupKey ?? 0);

                    //Taking only the ones that are selected in the project version
                    benchmarkDataTypes = nonFilteredBenchmarkDataTypes.Where(x => benchmarkDataTypeKeys.Contains(x.Id)).ToList();
                }

                var benchmarkDataTypeSearchKeys = new List<int>();
                var anualCalculation = benchmarkDataTypes.FirstOrDefault(b => b.Name.Equals(Constants.ANNUAL_BASE_BENCHMARK));
                var hourCalculation = benchmarkDataTypes.FirstOrDefault(b => b.Name.Equals(Constants.HOURLY_BASE_BENCHMARK));

                if (anualCalculation is not null)
                    benchmarkDataTypeSearchKeys.Add(anualCalculation.Id);

                if (hourCalculation is not null)
                    benchmarkDataTypeSearchKeys.Add(hourCalculation.Id);

                if (benchmarkDataTypeSearchKeys.Any())
                {
                    var basePayList = await _jobMatchingRepository.ListClientBasePay(projectVersionDetails.FileLogKey.Value,
                                                                                     (int)projectVersionDetails.AggregationMethodologyKey.Value,
                                                                                     request.ClientJobCodes,
                                                                                     benchmarkDataTypeSearchKeys);

                    if (basePayList is not null && basePayList.Any())
                    {
                        List<MarketSegmentCutDto> cutList = await GetMarketPricingCuts(marketPricingSheets);
                        IEnumerable<MarketSegmentCutDto> nationalCuts = await GetNationalCutsFromCutsList(cutList);

                        await CalculateAveragePay(request.StandardJobCodes, benchmarkDataTypeSearchKeys, result, anualCalculation, hourCalculation, basePayList, nationalCuts);
                    }
                }
            }

            return result;
        }

        public async Task<List<StandardJobMatchingDto>> ListSurveyCutsDataJobs(List<string> StandardJobCodes)
        {
            return await _jobMatchingRepository.ListSurveyCutsDataJobs(StandardJobCodes);
        }

        public async Task SaveBulkClientJobsMatching(int projectVersionId, List<JobMatchingSaveBulkDataDto> jobMatchingData, List<StandardJobMatchingDto> surveyData, string? userObjectId)
        {
            var statusKey = (int)MarketPricingStatus.AnalystReviewed;
            var projectVersionDetails = await _projectDetailsRepository.GetProjectVersionDetails(projectVersionId);
            var aggregationMethodologyKey = (projectVersionDetails?.AggregationMethodologyKey != null)? (int)projectVersionDetails.AggregationMethodologyKey.Value: 0;

            var dataToSave = from data in jobMatchingData
                             join survey in surveyData on data.StandardJobCode equals survey.StandardJobCode
                             select new JobMatchingSaveData
                             {
                                 MarketPricingJobCode = survey.StandardJobCode,
                                 MarketPricingJobTitle = survey.StandardJobTitle,
                                 MarketPricingJobDescription = survey.StandardJobDescription,
                                 PublisherName = string.Empty,
                                 PublisherKey = null,
                                 JobMatchNote = data.JobMatchNote,
                                 JobMatchStatusKey = statusKey,
                                 SelectedJobs = new List<JobMatchingStatusUpdateDto> 
                                 { 
                                     new JobMatchingStatusUpdateDto
                                     {
                                         AggregationMethodKey = aggregationMethodologyKey,
                                         FileOrgKey = projectVersionDetails?.OrganizationKey ?? 0,
                                         JobCode = data.SelectedJobCode,
                                         PositionCode = data.SelectedPositionCode
                                     } 
                                 },
                                 StandardJobs = new List<StandardJobMatchingDto> { 
                                     new StandardJobMatchingDto
                                     { 
                                         StandardJobCode = survey.StandardJobCode,
                                         StandardJobTitle = survey.StandardJobTitle,
                                         StandardJobDescription = survey.StandardJobDescription,
                                         BlendPercent = 100,
                                         BlendNote = string.Empty
                                     }
                                 }
                             };
            foreach (var data in dataToSave)
            {
                await _jobMatchingRepository.SaveClientJobsMatching(projectVersionId, data, userObjectId);
            }
        }

        private async Task<List<MarketSegmentCutDto>> GetMarketPricingCuts(List<MarketPricingSheet> marketPricingSheets)
        {
            var cutList = new List<MarketSegmentCutDto>();
            var uniqueMarketSegmentIds = marketPricingSheets.Where(sheet => sheet.MarketSegmentId > 0).Select(sheet => sheet.MarketSegmentId).Distinct();

            if (uniqueMarketSegmentIds is not null && uniqueMarketSegmentIds.Any())
                cutList = await _marketSegmentRepository.ListMarketSegmentCuts(uniqueMarketSegmentIds);

            return cutList;
        }

        private async Task<IEnumerable<MarketSegmentCutDto>> GetNationalCutsFromCutsList(List<MarketSegmentCutDto> cutList)
        {
            var cutGroupKeyList = cutList.Select(cut => cut.CutGroupKey).OfType<int>();

            // We need to fill the Cut Group Name coming from the Survey Domain
            var surveyCuts = await _marketSegmentRepository.GetSurveyCut(new SurveyCutRequestDto { CutGroupKeys = cutGroupKeyList.Distinct() });

            Parallel.ForEach(cutList, cut =>
            {
                cut.CutGroupName = surveyCuts.CutGroups?.FirstOrDefault(i => cut.CutGroupKey.HasValue && i.Keys?.Contains(cut.CutGroupKey.Value) == true)?.Name;
            });

            return cutList.Where(c => !string.IsNullOrEmpty(c.CutGroupName) && c.CutGroupName.Equals(Constants.NATIONAL_GROUP_NAME));
        }

        private async Task CalculateAveragePay(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys, AuditCalculationDto result, BenchmarkDataTypeDto? anualCalculation,
            BenchmarkDataTypeDto? hourCalculation, IEnumerable<ClientPayDto> basePayList, IEnumerable<MarketSegmentCutDto> nationalCuts)
        {
            var pTenthPercentiles = new List<MarketPercentileDto>();
            var pFiftiethPercentiles = new List<MarketPercentileDto>();
            var pNinetiethPercentiles = new List<MarketPercentileDto>();

            await GetPercentiles(standardJobCodes, benchmarkDataTypeKeys, nationalCuts, pTenthPercentiles, pFiftiethPercentiles, pNinetiethPercentiles);

            if (anualCalculation is not null)
            {
                var annualBasePayList = basePayList.Where(pay => pay.BenchmarkDataTypeKey == anualCalculation.Id);

                if (annualBasePayList is not null && annualBasePayList.Any())
                {
                    result.Annual = new BasePayDto(annualBasePayList.Select(pay => pay.BenchmarkDataTypeValue),
                                                   pTenthPercentiles.Select(p => p.MarketValue),
                                                   pFiftiethPercentiles.Select(p => p.MarketValue),
                                                   pNinetiethPercentiles.Select(p => p.MarketValue));
                }
            }

            if (hourCalculation is not null)
            {
                var hourBasePayList = basePayList.Where(pay => pay.BenchmarkDataTypeKey == hourCalculation.Id);

                if (hourBasePayList is not null && hourBasePayList.Any())
                {
                    result.Hourly = new BasePayDto(hourBasePayList.Select(pay => pay.BenchmarkDataTypeValue),
                                                   pTenthPercentiles.Select(p => p.MarketValue),
                                                   pFiftiethPercentiles.Select(p => p.MarketValue),
                                                   pNinetiethPercentiles.Select(p => p.MarketValue));
                }
            }
        }

        private async Task GetPercentiles(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys, IEnumerable<MarketSegmentCutDto> nationalCuts,
            List<MarketPercentileDto> pTenthPercentiles, List<MarketPercentileDto> pFiftiethPercentiles, List<MarketPercentileDto> pNinetiethPercentiles)
        {
            // If there are no cuts, get values from all possible National cuts in the Survey Database
            if (!nationalCuts.Any())
            {
                var percentiles = await _jobMatchingRepository.ListAllPercentilesByStandardJobCode(standardJobCodes, benchmarkDataTypeKeys);

                // Add the percentile values to the list for calcuations
                if (percentiles is not null && percentiles.Any())
                {
                    pTenthPercentiles.AddRange(percentiles.Where(p => p.Percentile == TENTH_PERCENTILE));
                    pFiftiethPercentiles.AddRange(percentiles.Where(p => p.Percentile == FIFTIETH_PERCENTILE));
                    pNinetiethPercentiles.AddRange(percentiles.Where(p => p.Percentile == NINETIETH_PERCENTILE));
                }
            }

            // Get percentiles depending on each combination of Industry, Organization, Cut Group and Cut Sub Group
            foreach (var cut in nationalCuts)
            {
                var percentiles = await _jobMatchingRepository.ListPercentiles(
                    standardJobCodes,
                    benchmarkDataTypeKeys,
                    GetKeyListFromCut(cut.IndustrySectorKey),
                    GetKeyListFromCut(cut.OrganizationTypeKey),
                    GetKeyListFromCut(cut.CutGroupKey),
                    GetKeyListFromCut(cut.CutSubGroupKey)
                    );

                // Add the percentile values to the list for calcuations
                if (percentiles is not null && percentiles.Any())
                {
                    pTenthPercentiles.AddRange(percentiles.Where(p => p.Percentile == TENTH_PERCENTILE));
                    pFiftiethPercentiles.AddRange(percentiles.Where(p => p.Percentile == FIFTIETH_PERCENTILE));
                    pNinetiethPercentiles.AddRange(percentiles.Where(p => p.Percentile == NINETIETH_PERCENTILE));
                }
            }
        }

        private List<int> GetKeyListFromCut(int? key)
        {
            return key.HasValue ? new List<int> { key.Value } : new List<int>();
        }

        private bool HeadersAreEqual(JobMatchingSaveData referenceHeader, JobMatchingSaveData header)
        {
            return referenceHeader.MarketPricingJobCode == header.MarketPricingJobCode &&
                   referenceHeader.MarketPricingJobTitle == header.MarketPricingJobTitle &&
                   referenceHeader.MarketPricingJobDescription == header.MarketPricingJobDescription &&
                   referenceHeader.PublisherName == header.PublisherName &&
                   referenceHeader.JobMatchStatusKey == header.JobMatchStatusKey &&
                   referenceHeader.JobMatchNote == header.JobMatchNote;
        }
    }
}