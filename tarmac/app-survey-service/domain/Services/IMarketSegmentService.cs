using CN.Survey.Domain.Request;

namespace CN.Survey.Domain.Services
{
    public interface IMarketSegmentService
    {
        public Task<IEnumerable<SurveyCut>> GetMarketSegmentSelectedCuts(SurveyCutsRequest request);
    }
}
