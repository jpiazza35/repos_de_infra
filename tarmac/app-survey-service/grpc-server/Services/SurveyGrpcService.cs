using AutoMapper;
using Cn.Survey;
using CN.Survey.Domain;
using Grpc.Core;
using static Cn.Survey.BenchmarkDataTypeListResponse.Types;

namespace CN.Survey.GrpcServer.Services
{
    public class SurveyGrpcService : Cn.Survey.Survey.SurveyBase
    {
        private readonly ILogger<SurveyGrpcService> _logger;
        protected IMapper _mapper;
        private readonly IBenchmarkDataTypeRepository _benchmarkDataTypeRepository;
        private readonly ISurveyCutsRepository _surveyCutsRepository;

        public SurveyGrpcService(ILogger<SurveyGrpcService> logger,
                                 IMapper mapper,
                                 IBenchmarkDataTypeRepository benchmarkDataTypeRepository,
                                 ISurveyCutsRepository surveyCutsRepository)
        {
            _logger = logger;
            _mapper = mapper;
            _benchmarkDataTypeRepository = benchmarkDataTypeRepository;
            _surveyCutsRepository = surveyCutsRepository;
        }

        public override async Task<SurveyCutListResponse> ListSurveyCuts(SurveyCutsRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nSurvey gRPC service method ListSurveyCuts called with request: {request} \n");

            var surveyDetails = await _surveyCutsRepository.ListSurveyCuts();

            if (surveyDetails is null || !surveyDetails.SurveyCutsData.Any())
                return new SurveyCutListResponse();

            var data = surveyDetails.SurveyCutsData;
            var surveyYears = data.Select(sc => sc.SurveyYear.ToString()).Distinct();
            var publishers = data
                .Where(sd => !string.IsNullOrEmpty(sd.SurveyPublisherName))
                .GroupBy(sd => sd.SurveyPublisherName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.SurveyPublisherKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.SurveyPublisherKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();
            var surveys = data
                .Where(sd => !string.IsNullOrEmpty(sd.SurveyName))
                .GroupBy(sd => sd.SurveyName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.SurveyKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.SurveyKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();
            var industries = data
                .Where(sd => !string.IsNullOrEmpty(sd.IndustrySectorName))
                .GroupBy(sd => sd.IndustrySectorName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.IndustrySectorKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.IndustrySectorKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();
            var organizations = data
                .Where(sd => !string.IsNullOrEmpty(sd.OrganizationTypeName))
                .GroupBy(sd => sd.OrganizationTypeName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.OrganizationTypeKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.OrganizationTypeKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();
            var cutGroups = data
                .Where(sd => !string.IsNullOrEmpty(sd.CutGroupName))
                .GroupBy(sd => sd.CutGroupName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.CutGroupKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.CutGroupKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();
            var cutSubGroups = data
                .Where(sd => !string.IsNullOrEmpty(sd.CutSubGroupName))
                .GroupBy(sd => sd.CutSubGroupName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.CutSubGroupKey.HasValue)
                             .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.CutSubGroupKey ?? 0 })
                             .Distinct()
                    }
                })
                .Distinct();

            var cuts = data
                .Where(sd => !string.IsNullOrEmpty(sd.CutName))
                .GroupBy(sd => sd.CutName)
                .Select(group => new NameKeySet
                {
                    FilterName = group.Key,
                    FilterKeyYear =
                    {
                        group.Where(x => x.CutKey.HasValue)
                                .Select(fky => new FilterKeyYear { SurveyYear = fky.SurveyYear, FilterKey = fky.CutKey ?? 0 })
                                .Distinct()
                    }
                })
                .Distinct();

            return new SurveyCutListResponse
            {
                SurveyYears = { surveyYears },
                SurveyPublisherNameKeysets = { publishers },
                SurveyNameKeysets = { surveys },
                IndustrySectorNameKeysets = { industries },
                OrganizationTypeNameKeysets = { organizations },
                CutGroupNameKeysets = { cutGroups },
                CutSubGroupNameKeysets = { cutSubGroups },
                CutNameKeysets = { cuts }
            };
        }

        public override async Task<BenchmarkDataTypeListResponse> ListBenchmarkDataType(ListBenchmarkDataTypeRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nSurvey gRPC service method ListBenchmarkDataTypes called with request: {request} \n");

            var benchmarks = await _benchmarkDataTypeRepository.GetBenchmarkDataTypes(request.SurveySourceGroupKey);

            if (benchmarks is null || !benchmarks.Any())
                return new BenchmarkDataTypeListResponse();

            var benchmarkResponse = _mapper.Map<List<BenchmarkDataTypeResponse>>(benchmarks);
            return new BenchmarkDataTypeListResponse
            {
                BenchmarkDataTypes = { benchmarkResponse },
            };
        }

        public override async Task<ListPercentilesResponse> ListPercentiles(ListPercentilesRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nSurvey gRPC service method ListPercentiles called with request: {request} \n");

            var listPercentilesRequest = new Domain.Request.SurveyCutsRequest
            {
                StandardJobCodes = request.StandardJobCodes.ToList(),
                IndustrySectorKeys = request.IndustrySectorKeys.ToList(),
                OrganizationTypeKeys = request.OrganizationTypeKeys.ToList(),
                CutGroupKeys = request.CutGroupKeys.ToList(),
                CutSubGroupKeys = request.CutSubGroupKeys.ToList(),
                BenchmarkDataTypeKeys = request.BenchmarkDataTypeKeys.ToList(),
            };

            var percentileList = await _surveyCutsRepository.ListPercentiles(listPercentilesRequest);

            if (percentileList is null || !percentileList.Any())
                return new ListPercentilesResponse();

            var percentileListResponse = _mapper.Map<List<MarketPercentileSet>>(percentileList);

            return new ListPercentilesResponse
            {
                MarketValueByPercentile = { percentileListResponse },
            };
        }

        public override async Task<ListPercentilesResponse> ListAllPercentilesByStandardJobCode(ListPercentilesRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nSurvey gRPC service method ListAllPercentilesByStandardJobCode called with request: {request} \n");

            var listPercentilesRequest = new Domain.Request.SurveyCutsRequest
            {
                StandardJobCodes = request.StandardJobCodes.ToList(),
                BenchmarkDataTypeKeys = request.BenchmarkDataTypeKeys.ToList(),
            };

            var percentileList = await _surveyCutsRepository.ListAllPercentilesByStandardJobCode(listPercentilesRequest);

            if (percentileList is null || !percentileList.Any())
                return new ListPercentilesResponse();

            var percentileListResponse = _mapper.Map<List<MarketPercentileSet>>(percentileList);

            return new ListPercentilesResponse
            {
                MarketValueByPercentile = { percentileListResponse },
            };
        }

        public override async Task<SurveyCutsDataListResponse> ListSurveyCutsDataWithPercentiles(ListPercentilesRequest request, ServerCallContext context)
        {
            _logger.LogInformation($"\nSurvey gRPC service method ListSurveyCutsDataWithPercentiles called with request: {request} \n");

            var surveyDataRequest = new Domain.Request.SurveyCutsRequest
            {
                SurveyKeys = request.SurveyKeys.ToList(),
                IndustrySectorKeys = request.IndustrySectorKeys.ToList(),
                OrganizationTypeKeys = request.OrganizationTypeKeys.ToList(),
                CutGroupKeys = request.CutGroupKeys.ToList(),
                CutSubGroupKeys = request.CutSubGroupKeys.ToList(),
                CutKeys = request.CutKeys.ToList(),
                BenchmarkDataTypeKeys = request.BenchmarkDataTypeKeys.ToList(),
                StandardJobCodes = request.StandardJobCodes.ToList(),
            };

            var surveyData = await _surveyCutsRepository.ListSurveyCutsDataWithPercentiles(surveyDataRequest);

            if (surveyData is null || surveyData.SurveyCutsData is null || !surveyData.SurveyCutsData.Any())
                return new SurveyCutsDataListResponse();

            var surveyDataResponse = _mapper.Map<List<SurveyCutsDataListResponse.Types.SurveyCutsDataResponse>>(surveyData.SurveyCutsData);

            return new SurveyCutsDataListResponse
            {
                SurveyCutsData = { surveyDataResponse },
            };
        }
    }
}