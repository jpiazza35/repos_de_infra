using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;
using CN.Survey.Domain.Services;

namespace CN.Survey.RestApi.Services
{
    public class SurveyCutsService : ISurveyCutsService
    {
        private readonly ISurveyCutsRepository _surveyCutsRepository;

        public SurveyCutsService(ISurveyCutsRepository surveyCutsRepository)
        {
            _surveyCutsRepository = surveyCutsRepository;
        }

        public Task<SurveyCutFilterOptionsListResponse> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request)
            => _surveyCutsRepository.ListSurveyCutFilterOptions(request);

        public Task<SurveyCutsDataListResponse> ListSurveyCuts(SurveyCutsRequest request)
            => _surveyCutsRepository.ListSurveyCuts(request);

        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request)
        {
            return string.IsNullOrEmpty(request.StandardJobSearch)
                ? Task.FromResult(new SurveyCutsDataListResponse())
                : _surveyCutsRepository.ListSurveyCutsDataStandardJobs(request);
        }

        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request)
        {
            return request.StandardJobCodes == null || !request.StandardJobCodes.Any() 
                ? Task.FromResult(new SurveyCutsDataListResponse()) 
                : _surveyCutsRepository.ListSurveyCutsDataPublishers(request);
        }

        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataJobs(SurveyCutsDataRequest request)
        {
            return request.StandardJobCodes == null || !request.StandardJobCodes.Any() || request.PublisherKey == null
                ? Task.FromResult(new SurveyCutsDataListResponse())
                : _surveyCutsRepository.ListSurveyCutsDataJobs(request);
        }
    }
}
