namespace CN.Survey.Domain;

public interface IBenchmarkDataTypeRepository
{
    Task<List<BenchmarkDataType>?> GetBenchmarkDataTypes(int sourceGroupKey);
}