using CN.Survey.Domain;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace CN.Survey.Infrastructure.MockRepositories;

public class MockSourceGroupRepository : ISourceGroupRepository
{
    private readonly IDBContext _benchmarkDBContext;
    private readonly ILogger<MockSourceGroupRepository> _logger;

    public MockSourceGroupRepository(IDBContext benchmarkDBContext, ILogger<MockSourceGroupRepository> logger)
    {
        _benchmarkDBContext = benchmarkDBContext;
        _logger = logger;
    }

    public async Task<List<SourceGroup>?> GetSourceGroups()
    {
        try
        {
            _logger.LogInformation($"\nObtaining survey source groups\n");

            var jsonData = "[{\"ID\":1,\"Name\":\"Physician\",\"Description\":\"Physician benchmark data like TCC, wRVU and other comp related data that can be averaged together\",\"Status\":\"Active\"},{\"ID\":2,\"Name\":\"On-Call\",\"Description\":\"On-call pay data that cannot be combined in average with Comp\",\"Status\":\"Active\"},{\"ID\":3,\"Name\":\"APP\",\"Description\":\"APC benchmark data\",\"Status\":\"Active\"},{\"ID\":5,\"Name\":\"Executive\",\"Description\":\"Executive compensation benchmark data\",\"Status\":\"Active\"},{\"ID\":6,\"Name\":\"Employee\",\"Description\":\"Employee compensation benchmark data\",\"Status\":\"Active\"},{\"ID\":8,\"Name\":\"WI360\",\"Description\":\"Workforce Metrics Benchmark Data\",\"Status\":\"Active\"}]";
            var list = JsonConvert.DeserializeObject<List<SourceGroup>>(jsonData);
            return await Task.FromResult(list?.ToList());
        }
        catch (Exception ex)
        {
            _logger.LogError($"\nError {ex.Message}\n");

            throw;
        }
    }
}
