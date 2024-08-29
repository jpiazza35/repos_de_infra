namespace CN.Project.Domain.Models
{
    public class MarketPricingSheetCutExternalData
    {
        public int CutExternalDataKey { get; set; }
        public int CutExternalKey { get; set; }
        public int BenchmarkDataTypeKey { get; set; }
        public decimal BenchmarkDataTypeValue { get; set; }
        public int PercentileNumber { get; set; }
    }
}