using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;

namespace CN.Survey.Domain.Services
{
    public interface ISurveyCutsService
    {
        public Task<SurveyCutFilterOptionsListResponse> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCuts(SurveyCutsRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataJobs(SurveyCutsDataRequest request);
    }
}
