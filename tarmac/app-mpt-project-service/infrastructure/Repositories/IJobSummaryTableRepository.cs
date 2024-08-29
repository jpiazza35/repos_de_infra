using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.Infrastructure.Repositories
{
    public interface IJobSummaryTableRepository
    {
        public Task<List<JobSummaryTable>> GetJobSummaryTable(int projectVersionId, MarketPricingSheetFilterDto? filter = null);
    }
}
