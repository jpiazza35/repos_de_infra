using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Services
{
    public interface IJobMatchingService
    {
        public Task SaveJobMatchingStatus(int projectVersionId, int marketPricingStatusKey, List<JobMatchingStatusUpdateDto> jobMatchingStatusUpdate, string? userObjectId);
        public Task<int> GetProjectVersionStatus(int projectVersionId);
        public Task<JobMatchingInfo?> GetMarketPricingJobInfo(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs);
        public Task SaveClientJobsMatching(int projectVersionId, JobMatchingSaveData jobMatchingSaveData, string? userObjectId);
        public Task<AuditCalculationDto> GetAuditCalculations(int projectVersionId, AuditCalculationRequestDto request);
        public Task<bool> CheckEditionForSelectedJobs(int projectVersionId, List<JobMatchingStatusUpdateDto> selectedJobs);
        public Task<List<StandardJobMatchingDto>> ListSurveyCutsDataJobs(List<string> StandardJobCodes);
        public Task SaveBulkClientJobsMatching(int projectVersionId, List<JobMatchingSaveBulkDataDto> jobMatchingData, List<StandardJobMatchingDto> surveryData, string? userObjectId);
    }
}
