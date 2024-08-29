namespace CN.Incumbent.Domain;

public interface ISourceDataRepository
{
    public Task<IList<SourceData>> ListSourceData(int fileLogKey, int aggregationMethodKey);
    public Task<List<SourceDataEmployeeLevel>> ListSourceDataEmployeeLevel(int fileLogKey);
    public Task<IEnumerable<SourceData>> ListClientBasePay(int fileLogKey, int aggregationMethodKey, IEnumerable<string> jobCodes, IEnumerable<int> benchmarkDataTypeKeys);
    public Task<IList<SourceData>> ListClientJobs(int fileLogKey, int aggregationMethodKey);
    public Task<IEnumerable<SourceData>> ListClientPayDetail(int fileLogKey, int fileOrgKey, int aggregationMethodKey, string jobCode, string positionCode, IEnumerable<int> benchmarkDataTypeKeys);
    public Task<List<SourceData>> ListClientPositionDetail(int fileLogKey, int aggregationMethodKey, string jobCode, string positionCode, int fileOrgKey);
}