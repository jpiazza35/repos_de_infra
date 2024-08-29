using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Infrastructure.Repositories
{
    public interface IMarketPricingSheetRepository
    {
        public Task<List<MarketPricingStatusDto>> GetStatus(int projectVersionId, MarketPricingSheetFilterDto filter);
        public Task<List<IdNameDto>> GetMarketSegmentsNames(int projectVersionId);
        public Task<List<string>> GetJobGroups(int projectVersionId);
        public Task<List<JobTitleFilterDto>> GetJobTitles(int projectVersionId, MarketPricingSheetFilterDto filter);
        public Task<MarketPricingSheetInfoDto?> GetSheetInfo(int projectVersionId, int marketPricingSheetId);
        public Task<List<MarketPricingSheet>> GetMarketPricingSheet(int projectVersionId, int marketPricingSheetId);
        public Task<List<MarketPricingSheet>> ListMarketPricingSheets(int projectVersionId);
        public Task UpdateMarketPricingStatus(int projectVersionId, int marketPricingSheetId, int jobMatchStatusKey, string? userObjectId);
        public Task<JobMatchingInfo> GetJobMatchDetail(int projectVersionId, int marketPricingSheetId);
        public Task SaveJobMatchDetail(int projectVersionId, int marketPricingSheetId, string jobMatchNote, string? userObjectId);
        public Task<List<IdNameDto>> GetAdjusmentNoteList();
        public Task<List<SurveyCutDataDto>> ListSurveyCutsDataWithPercentiles(IEnumerable<int> surveyKeys, IEnumerable<int> industryKeys, IEnumerable<int> organizationTypeKeys, IEnumerable<int> cutGroupKeys,
            IEnumerable<int> cutSubGroupKeys, IEnumerable<int> cutKeys, IEnumerable<int> benchmarkDataTypeKeys, IEnumerable<string> standardJobCodes);
        public Task<List<MarketPricingSheetAdjustmentNoteDto>> ListAdjustmentNotesByProjectVersionId(int projectVersionId);
        public Task SaveNotes(int projectVersionId, int marketPricingSheetId, string notes, string? userObjectId);
        public Task<NewStringValueDto> GetNotes(int projectVersionId, int marketPricingSheetId);
        public Task<List<string>> GetMarketSegmentReportFilter(int projectVersionId);
        public Task SaveMainSettings(int projectVersionId, MainSettingsDto mainSettings, string? userObjectId);
        public Task<MainSettingsDto?> GetMainSettings(int projectVersionId);
        public Task<List<MarketPricingSheetAdjustmentNoteDto>> ListAdjustmentNotes(int marketPricingSheetId, int? rawDataKey, int? cutExternalKey);
        public Task InsertAdjustmentNotes(SaveGridItemDto gridItem, string? userObjectId);
        public Task UpdateAdjustmentNotes(SaveGridItemDto gridItem, List<MarketPricingSheetAdjustmentNoteDto> existingAdjustmentNotes, string? userObjectId);
        public Task SaveMarketPricingExternalData(int projectVersionId, List<MarketPricingSheetCutExternalDto> cutExternal, string? userObjectId);
        public Task<UploadMarketPricingSheetPdfFileDto?> GetGeneratedFile(int projectVersionId, int? marketPricingSheetId);
        public Task SaveGeneratedFile(int projectVersionId, int? marketPricingSheetId, UploadMarketPricingSheetPdfFileDto file, string? userObjectId);
        public Task<List<MarketPricingSheetCutExternal>> ListExternalData(int marketPricingSheetId);
    }
}