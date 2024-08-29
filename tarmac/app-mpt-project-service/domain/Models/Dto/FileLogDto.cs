namespace CN.Project.Domain.Models.Dto
{
    public class FileLogDto
    {
        public int FileLogKey { get; set; }
        public int OrganizationId { get; set; }
        public string? SourceDataName { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string? ClientFileName { get; set; }
        public string? FileS3Url { get; set; }
        public string? UploadedBy { get; set; }
        public DateTime UploadedUtcDatetime { get; set; }
        public int FileStatusKey { get; set; }
        public string? FileStatusName { get; set; }
        public int? SourceDataType { get; set; }
    }
}
