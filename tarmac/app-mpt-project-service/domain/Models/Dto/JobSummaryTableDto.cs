namespace CN.Project.Domain.Models.Dto
{
    public class JobSummaryTableDto : JobSummaryTableBaseDto
    {
        public int IncumbentCount { get; set; }
        public int FteCount { get; set; }
    }
}