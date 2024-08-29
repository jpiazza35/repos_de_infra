using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models.Dto
{
    public class JobDto : JobBaseDto
    {
        [Key]
        public int SourceDataAgregationKey { get; set; }
        public int AggregationMethodKey { get; set; }
        public int IncumbentCount { get; set; }
        public int FteCount { get; set; }
       
        public Dictionary<string, string?> FormattedBenchmarkDataTypes { get; set; } = new Dictionary<string, string?>();
    }
}
