namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    // This class is to help on the PDF File Grid Calculations
    public class RealBenchmarkValueDto
    {
        public string? CutGroupName { get; set; }
        public int BenchmarkId { get; set; }
        public int Percentile { get; set; }
        public double? RealValue { get; set; }
        public string? MarketSegmentCutName { get; set; }
        public string? Format { get; set; }
        public int Decimals { get; set; }
    }
}