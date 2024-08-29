using CN.Project.Domain.Models.Dto;

namespace CN.Project.Infrastructure.Repositories
{
    public interface IBenchmarkDataRepository
    {
        public Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int sourceGroupKey);
        public Task<List<BenchmarkDataTypeDto>> ListBenchmarksFromReferenceTable();
    }
}
