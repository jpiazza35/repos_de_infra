using CN.Survey.Domain;
using Dapper;
using Microsoft.Extensions.Logging;

namespace CN.Survey.Infrastructure.Repositories;

public class SourceGroupRepository : ISourceGroupRepository
{
    private readonly IDBContext _benchmarkDBContext;
    private readonly ILogger<SourceGroupRepository> _logger;

    public SourceGroupRepository(IDBContext benchmarkDBContext, ILogger<SourceGroupRepository> logger)
    {
        _benchmarkDBContext = benchmarkDBContext;
        _logger = logger;
    }

    public async Task<List<SourceGroup>?> GetSourceGroups()
    {
        try
        {
            _logger.LogInformation($"\nObtaining survey source groups\n");

            using (var connection = _benchmarkDBContext.GetConnection())
            {
                var sql = @"SELECT a.survey_source_group_key          AS ID,	
                                        a.survey_source_group_name         AS Name, 
	                                    a.survey_source_group_description  AS Description, 
	                                    b.status_name                      AS Status
                                 FROM  Survey_Source_Group a
                                 INNER JOIN status_list b on a.status_key=b.status_key
                                 WHERE b.status_name <> 'Deleted'";

                var sourceGroups = await connection.QueryAsync<SourceGroup>(sql);
                return sourceGroups?.ToList();
            }
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}
