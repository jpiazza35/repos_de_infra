namespace CN.Project.Domain.Models.Dto
{
    public abstract class JobSummaryTableBaseDto
    {
        public string ClientJobCode { get; set; } = string.Empty;
        public string ClientJobTitle { get; set; } = string.Empty;
        public string ClientPositionCode { get; set; } = string.Empty;
        public string ClientPositionCodeDescription { get; set; } = string.Empty;
        public int MarketPricingSheetId { get; set; }
        public string BenchmarkJobCode { get; set; } = string.Empty;
        public string BenchmarkJobTitle { get; set; } = string.Empty;
        public string JobMatchAdjustmentNotes { get; set; } = string.Empty;
        public string MarketSegment { get; set; } = string.Empty;
        public string JobGroup { get; set; } = string.Empty;
        public int DataScopeKey { get; set; }
        public string DataSource { get; set; } = string.Empty;
        public string DataScope { get; set; } = string.Empty;
        public List<JobSummaryBenchmarkDto>? Benchmarks { get; set; }
    }
}
