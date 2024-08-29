using CN.Incumbent.Domain.Models.Dtos;

namespace CN.Incumbent.Domain;

public interface IFileRepository
{
    public Task<FileLogResponseDto> InsertFileLog(SaveFileDto fileLogDetails, string? userObjectId);
    public Task UpdateFileStatusToUploaded(int fileLogKey);
    public Task<IEnumerable<FileLogDto>> GetFileByFilters(int orgId, string sourceData);
    public Task<IEnumerable<FileLogDto>> GetFilesByIds(List<int> fileIds);
    public Task<string> GetFileLinkAsync(int fileKey);
    public Task<string> GetFileLinkAsync(string fileName);
    public Task<FileLogResponseDto> UploadMarketPricingSheetPdfFile(byte[] file, MarketPricingSheetPdfDto fileInformation);
}