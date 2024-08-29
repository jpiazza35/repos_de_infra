using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Services
{
    public interface IGraphService
    {
        public Task<List<JobSummaryTableEmployeeLevelDto>> GetBasePayMarketComparisonGraphData(int projectVersionId, JobSummaryBenchmarkComparisonRequestDto? jobSummaryComparisonRequestDto = null);
    }
}
