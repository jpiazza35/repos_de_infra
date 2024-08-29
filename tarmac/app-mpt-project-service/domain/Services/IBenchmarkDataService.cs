using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Services
{
    public interface IBenchmarkDataService
    {
        public Task<List<BenchmarkDataTypeDto>> GetBenchmarkDataTypes(int sourceGroupKey);
    }
}