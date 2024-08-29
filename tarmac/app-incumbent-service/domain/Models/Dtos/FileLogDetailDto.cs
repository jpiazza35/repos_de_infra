namespace CN.Incumbent.Domain.Models.Dtos
{
    public class FileLogDetailDto
    {
        public int FileLogDetailKey { get; set; }
        public int FileLogKey { get; set; }
        public string? MessageText { get; set; }
        public DateTime CreatedUtcDatetime { get; set; }
    }
}
