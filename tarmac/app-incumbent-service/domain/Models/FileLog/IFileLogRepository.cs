using CN.Incumbent.Domain.Models.Dtos;

namespace CN.Incumbent.Domain
{
    public interface IFileLogRepository
    {
        public Task<IEnumerable<FileLogDetailDto>> GetFileLogDetails(int fileLogKey);
    }
}