using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;

namespace CN.Project.Infrastructure.Repositories
{
    public interface IMarketPricingSheetFileRepository
    {
        public string GetHeaderHtmlTemplate(bool displayOrgName, bool displayReportDate, string? organizationName, int marketPricingSheetId);
        public string GetClientPayDetailHtmlTemplate(int marketPricingSheetId, Dictionary<string, string> payDetail);
        public string GetClientPositionDetailHtmlTemplate(int marketPricingSheetId, IEnumerable<SourceDataDto> positionDetailList);
        public string GetJobMatchDetailHtmlTemplate(int marketPricingSheetId, JobMatchingInfo jobMatchDetail);
        public string GetMarketDataDetailHtmlTemplate(int marketPricingSheetId, Dictionary<string, bool> columns, MarketSegmentDto? marketSegment,
            List<MarketPricingSheetGridItemDto> gridItems, IEnumerable<MainSettingsBenchmarkDto> benchmarks, DateTime ageToDate, IEnumerable<CombinedAveragesDto> combinedAverages,
            bool displayMarketSegmentName);
        public string GetNotesHtmlTemplate(int marketPricingSheetId, DateTime ageToDate, NewStringValueDto notes, IEnumerable<BenchmarkDataTypeDto> benchmarks,
            IEnumerable<string> footerNotesList);
        public string GetFinalHtmlTemplate(int marketPricingSheetId, string headerTemplate, string clientPayDetailTemplate, string clientPositionDetailTemplate, string jobMatchTemplate, 
            string marketDataDetailTemplate, string notesTemplate);
    }
}
