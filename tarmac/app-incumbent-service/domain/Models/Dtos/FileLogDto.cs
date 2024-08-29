namespace CN.Incumbent.Domain.Models.Dtos
{
    public class FileLogDto
    {
        public int FileLogKey { get; set; }
        public int OrganizationId { get; set; }
        public string? SourceDataName { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string? ClientFileName { get; set; }
        public string? FileS3Name { get; set; }
        public string? FileS3Url { get; set; }
        public string? UploadedBy { get; set; }
        public DateTime? UploadedUtcDatetime { get; set; }
        public int FileStatusKey { get; set; }
        public string? FileStatusName { get; set; }
        public IEnumerable<FileLogDetailDto>? Details { get; set; }
    }
}
