namespace CN.Incumbent.Domain.Models.Dtos
{
    public class S3ResponseDto
    {
        public int StatusCode { get; set; }
        public string? Message { get; set; }
        public bool Success { get; set; } = true;
    }
}
