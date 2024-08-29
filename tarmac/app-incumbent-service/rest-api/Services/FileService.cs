using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using CN.Incumbent.Domain.Services;

namespace CN.Incumbent.RestApi.Services
{
    public class FileService : IFileService
    {
        private readonly IFileRepository _fileRepository;
        private readonly IFileLogRepository _fileLogRepository;

        public FileService(IFileRepository fileRepository, IFileLogRepository fileLogRepository)
        {
            _fileRepository = fileRepository;
            _fileLogRepository = fileLogRepository;
        }

        public async Task<FileLogDto?> GetFileLogDetails(int fileKey)
        {
            var fileList = await _fileRepository.GetFilesByIds(new List<int> { fileKey });

            if (fileList is null || !fileList.Any())
                return null;

            var file = fileList.First();

            file.Details = await _fileLogRepository.GetFileLogDetails(fileKey);

            return file;
        }
    }
}
