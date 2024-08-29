namespace CN.Incumbent.Domain
{
    public class SourceDataEmployeeLevel
    {
        public int SourceDataKey { get; set; }
        public int FileLogKey { get; set; }
        public string SourceDataName { get; set; } = string.Empty;
        public int FileOrgKey { get; set; }
        public int CesOrgId { get; set; }
        public string CesOrgName { get; set; } = string.Empty;
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string IncumbentId { get; set; } = string.Empty;
        public string IncumbentName { get; set; } = string.Empty;
        public float FteValue { get; set; }
        public string ClientJobGroup { get; set; } = string.Empty;
        public string PositionCode { get; set; } = string.Empty;
        public string PositionCodeDescription { get; set; } = string.Empty;
        public string JobLevel { get; set; } = string.Empty;
        public decimal? CreditedYoe { get; set; }
        public DateTime? OriginalHireDate { get; set; }
        public Dictionary<int, float> BenchmarkDataTypes { get; set; } = new Dictionary<int, float>();
    }
}
