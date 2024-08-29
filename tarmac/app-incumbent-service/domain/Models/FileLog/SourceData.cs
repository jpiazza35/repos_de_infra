namespace CN.Incumbent.Domain;

public class SourceData
{
    public int SourceDataAgregationKey { get; set; }
    public int AggregationMethodKey { get; set; }
    public int FileLogKey { get; set; }
    public int FileOrgKey { get; set; }
    public int CesOrgId { get; set; }
    public string JobCode { get; set; } = string.Empty;
    public string JobTitle { get; set; } = string.Empty;
    public int IncumbentCount { get; set; }
    public int FteValue { get; set; }
    public string LocationDescription { get; set; } = string.Empty;
    public string JobFamily { get; set; } = string.Empty;
    public string PayGrade { get; set; } = string.Empty;
    public string PayType { get; set; } = string.Empty;
    public string PositionCode { get; set; } = string.Empty;
    public string PositionCodeDescription { get; set; } = string.Empty;
    public string JobLevel { get; set; } = string.Empty;
    public string ClientJobGroup { get; set; } = string.Empty;
    public string MarketSegmentName { get; set; } = string.Empty;
    public Dictionary<int, float?> BenchmarkDataTypes { get; set; } = new Dictionary<int, float?>();

    public string BenchmarkDataTypeList { get; set; } = string.Empty;
    public int BenchmarkDataTypeKey { get; set; }
    public float? BenchmarkDataTypeValue { get; set; } = null;
}