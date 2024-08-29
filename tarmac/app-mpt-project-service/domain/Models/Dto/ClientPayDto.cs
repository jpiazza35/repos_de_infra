namespace CN.Project.Domain.Models.Dto
{
    public class ClientPayDto
    {
        public string JobCode { get; set; } = string.Empty;
        public int BenchmarkDataTypeKey { get; set; }
        public float BenchmarkDataTypeValue { get; set; }
    }
}