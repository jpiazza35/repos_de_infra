namespace CN.Project.Domain.Models.Dto
{
    public class BenchmarkDataTypeDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public float? AgingFactor { get; set; }
        public bool DefaultDataType { get; set; }
        public string LongAlias { get; set; } = string.Empty;
        public string ShortAlias { get; set; } = string.Empty;
        public int? OrderDataType { get; set; }
        public string Format { get; set; } = string.Empty;
        public int Decimals { get; set; }
    }
}
