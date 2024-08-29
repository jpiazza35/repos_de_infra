namespace CN.Incumbent.Domain.Models.Dtos
{
    public class FileLogResponseDto
    {
        public string? FileS3Url { get; set; }
        public string? FileS3Name { get; set; }
        public string? BucketName { get; set; }
        public int FileLogKey { get; set; }
        public bool Success { get; set; }
        public string? Message { get; set; }
    }
}
