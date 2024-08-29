using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;

namespace CN.Survey.Domain
{
    public interface ISurveyCutsRepository
    {   
        public Task<SurveyCutFilterOptionsListResponse> ListSurveyCutFilterOptions(SurveyCutFilterOptionsRequest request);
        public Task<IEnumerable<SurveyCutFilterFlatOption>> ListSurveyCutFilterFlatOptions(SurveyCutFilterFlatOptionsRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCuts(SurveyCutsRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCuts();
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataStandardJobs(SurveyCutsDataRequest request);
        public Task<IEnumerable<MarketPercentileSet>> ListPercentiles(SurveyCutsRequest request);
        public Task<IEnumerable<MarketPercentileSet>> ListAllPercentilesByStandardJobCode(SurveyCutsRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataPublishers(SurveyCutsDataRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataJobs(SurveyCutsDataRequest request);
        public Task<SurveyCutsDataListResponse> ListSurveyCutsDataWithPercentiles(SurveyCutsRequest request);
    }
}
