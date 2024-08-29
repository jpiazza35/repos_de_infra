using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Services;

namespace CN.Survey.RestApi.Services
{
    public class MarketSegmentService : IMarketSegmentService
    {
        private readonly ISurveyCutsRepository _surveyCutsRepository;

        public MarketSegmentService(ISurveyCutsRepository surveyCutsRepository)
        {
            _surveyCutsRepository = surveyCutsRepository;
        }

        public async Task<IEnumerable<SurveyCut>> GetMarketSegmentSelectedCuts(SurveyCutsRequest request)
        {
            var surveyDetails = await _surveyCutsRepository.ListSurveyCuts(request);

            if (surveyDetails is null || !surveyDetails.SurveyCutsData.Any())
                return new List<SurveyCut>();

            var cuts = surveyDetails.SurveyCutsData
                .GroupBy(sd => new
                {
                    sd.IndustrySectorName,
                    sd.OrganizationTypeName,
                    sd.CutGroupName,
                    sd.CutSubGroupName
                })
                .Select(sd => new SurveyCut
                {
                    SurveyDetails = sd,
                    IndustrySectorName = sd.Key.IndustrySectorName,
                    OrganizationTypeName = sd.Key.OrganizationTypeName,
                    CutGroupName = sd.Key.CutGroupName,
                    CutSubGroupName = sd.Key.CutSubGroupName,
                    IndustrySectorKeys = sd.Select(sd => sd.IndustrySectorKey).Distinct(),
                    OrganizationTypeKeys = sd.Select(sd => sd.OrganizationTypeKey).Distinct(),
                    CutGroupKeys = sd.Select(sd => sd.CutGroupKey).Distinct(),
                    CutSubGroupKeys = sd.Select(sd => sd.CutSubGroupKey).Distinct()
                });

            return cuts;
        }
    }
}
