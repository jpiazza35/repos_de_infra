using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Services
{
    public interface IJobSummaryTableService
    {
        public Task<List<JobSummaryTableDto>> GetJobSummaryTable(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null);
        public Task<List<JobSummaryTableEmployeeLevelDto>> GetJobSummaryTableEmployeeLevel(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null);
    }
}