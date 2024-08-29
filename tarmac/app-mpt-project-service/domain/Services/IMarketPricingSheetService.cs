using CN.Project.Domain.Dto;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Domain.Services
{
    public interface IMarketPricingSheetService
    {
        public Task<List<MarketPricingStatusDto>> GetStatus(int projectVersionId, MarketPricingSheetFilterDto filter);
        public Task<List<IdNameDto>> GetMarketSegmentsNames(int projectVersionId);
        public Task<List<string>> GetJobGroups(int projectVersionId);
        public Task<List<JobTitleFilterDto>> GetJobTitles(int projectVersionId, MarketPricingSheetFilterDto filter);
        public Task<MarketPricingSheetInfoDto?> GetSheetInfo(int projectVersionId, int marketPricingSheetId);
        public Task<IEnumerable<SourceDataDto>> GetClientPositionDetail(int projectVersionId, int marketPricingSheetId, ProjectVersionDto? projectVersionDetails = null);
        public Task UpdateMarketPricingStatus(int projectVersionId, int marketPricingSheetId, int jobMatchStatusKey, string? userObjectId);
        public Task<int> GetProjectVersionStatus(int projectVersionId);
        public Task<JobMatchingInfo> GetJobMatchDetail(int projectVersionId, int marketPricingSheetId);
        public Task SaveJobMatchDetail(int projectVersionId, int marketPricingSheetId, string jobMatchNote, string? userObjectId);
        public Task<Dictionary<string, string>> GetClientPayDetail(int projectVersionId, int marketPricingSheetId);
        public Task<List<IdNameDto>> GetAdjusmentNoteList();
        public Task<List<MarketPricingSheetGridItemDto>> GetGridItems(int projectVersionId, int? marketPricingSheetId = null);
        public Task SaveNotes(int projectVersionId, int marketPricingSheetId, NewStringValueDto notes, string? userObjectId);
        public Task<NewStringValueDto> GetNotes(int projectVersionId, int marketPricingSheetId);
        public Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int projectVersionId);
        public Task<List<string>> GetMarketSegmentReportFilter(int projectVersionId);
        public Task SaveMainSettings(int projectVersionId, MainSettingsDto mainSettings, string? userObjectId);
        public Task<MainSettingsDto?> GetMainSettings(int projectVersionId);
        public Task SaveGridItemsForMarketPricingSheet(SaveGridItemDto item, string? userObjectId);
        public Task SaveMarketPricingExternalData(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternalRows, string? userObjectId);
        public Task<ProjectVersionDto> GetProjectVersionDetails(int projectVersionId);
        public Task<UploadMarketPricingSheetPdfFileDto> ExportPdf(int projectVersionId, int? marketPricingSheetId, List<int> sortByList, string? userObjectId);
        public List<IdNameDto> GetSortingFields();
    }
}