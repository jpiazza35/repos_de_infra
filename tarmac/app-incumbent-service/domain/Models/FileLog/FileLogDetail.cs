using System.ComponentModel.DataAnnotations;

namespace CN.Incumbent.Domain
{
    public class FileLogDetail
    {
        [Key]
        public int FileLogDetailKey { get; set; }
        public int FileLogKey { get; set; }
        public string? MessageText { get; set; }
        public DateTime CreatedUtcDatetime { get; set; }
    }
}