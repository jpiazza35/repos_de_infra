using AutoMapper;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Incumbent.Infrastructure.Repositories
{
    public class FileLogRepository : IFileLogRepository
    {
        private readonly IDBContext _incumbentStagingDBContext;
        private readonly ILogger<FileLogRepository> _logger;
        protected IMapper _mapper;

        public FileLogRepository(IDBContext incumbentStagingDBContext, ILogger<FileLogRepository> logger, IMapper mapper)
        {
            _incumbentStagingDBContext = incumbentStagingDBContext;
            _logger = logger;
            _mapper = mapper;
        }

        public async Task<IEnumerable<FileLogDetailDto>> GetFileLogDetails(int fileLogKey)
        {
            try
            {
                _logger.LogInformation($"\nGetting log details for file id: {fileLogKey} \n");

                using (var connection = _incumbentStagingDBContext.GetIncumbentStagingConnection())
                {
                    var sql = $@"SELECT file_log_detail_key AS FileLogDetailKey
                                      , file_log_key AS FileLogKey
                                      , TRIM(message_text) AS MessageText
                                      , created_utc_datetime AS CreatedUtcDatetime
                                   FROM file_log_detail
                                  WHERE file_log_key = @fileLogKey
                                  ORDER BY created_utc_datetime ASC";

                    var details = await connection.QueryAsync<FileLogDetail>(sql, new { fileLogKey });

                    return _mapper.Map<IEnumerable<FileLogDetailDto>>(details);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }
    }
}