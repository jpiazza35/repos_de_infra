using CN.Incumbent.Domain.Models.Dtos;

namespace CN.Incumbent.Domain.Services
{
    public interface IFileService
    {
        public Task<FileLogDto?> GetFileLogDetails(int fileKey);
    }
}
