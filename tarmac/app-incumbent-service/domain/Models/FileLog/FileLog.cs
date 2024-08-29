using System.ComponentModel.DataAnnotations;

namespace CN.Incumbent.Domain;

public class FileLog
{
    [Key]
    public int FileLogKey { get; set; }
    public int FileOrgKey { get; set; }
    public string? SourceDataName { get; set; }
    public DateTime DataEffectiveDate { get; set; }
    public string? ClientFileName { get; set; }
    public string? FileS3Url { get; set; }
    public string? FileS3Name { get; set; }
    public string? UploadedBy { get; set; }
    public DateTime UploadedUtcDatetime { get; set; }
    public int FileStatusKey { get; set; }
    public string? FileStatusName { get; set; }
}