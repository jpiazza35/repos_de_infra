using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;

namespace CN.Project.Infrastructure.Repository;

public interface IFileRepository
{
    public Task<List<FileLogDto>> GetFilesByIds(List<int> fileIds);
    public Task<byte[]?> ConvertHtmlListToUniquePdfFile(List<string> htmlStringList);
    public Task<UploadMarketPricingSheetPdfFileDto> UploadMarketPricingSheetPdfFile(byte[] file, int projectVersionId, int? marketPricingSheetId, int organizationId, string organizationName);
}
