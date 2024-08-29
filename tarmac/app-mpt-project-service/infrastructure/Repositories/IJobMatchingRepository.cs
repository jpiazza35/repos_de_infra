using Cn.Survey;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.Infrastructure.Repositories
{
    public interface IJobMatchingRepository
    {
        public Task SaveJobMatchingStatus(int projectVersionId, int marketPricingStatusKey, JobMatchingStatusUpdateDto jobMatchingStatusUpdate, string? userObjectId);
        public Task<List<StandardJobMatchingDto>> GetStandardMatchedJobs(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs);
        public Task<JobMatchingSaveData> GetJobMatchingSavedData(int projectVersionId, JobMatchingStatusUpdateDto selectedJob);
        public Task<JobMatchingInfo> GetMarketPricingJobInfo(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs);
        public Task SaveClientJobsMatching(int projectVersionId, JobMatchingSaveData jobMatchingSaveData, string? userObjectId);
        public Task<IEnumerable<MarketPercentileDto>> ListPercentiles(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys, IEnumerable<int> industryKeys,
            IEnumerable<int> organizationKeys, IEnumerable<int> cutGroupKeys, IEnumerable<int> cutSubGroupKeys);
        public Task<IEnumerable<MarketPercentileDto>> ListAllPercentilesByStandardJobCode(IEnumerable<string> standardJobCodes, IEnumerable<int> benchmarkDataTypeKeys);
        public Task<IEnumerable<ClientPayDto>> ListClientBasePay(int fileLogKey, int aggregationMethodKey, IEnumerable<string> jobCodes, IEnumerable<int> benchmarkDataTypeKeys);
        public Task<List<StandardJobMatchingDto>> ListSurveyCutsDataJobs(List<string> StandardJobCodes);
    }
}
