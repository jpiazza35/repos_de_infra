namespace CN.Project.Domain.Models.Dto
{
    public class JobMatchingSaveBulkDataDto
    {
        public string SelectedJobCode { get; set; } = string.Empty;
        public string SelectedPositionCode { get; set; } = string.Empty;
        public string StandardJobCode { get; set; } = string.Empty;
        public string JobMatchNote { get; set; } = string.Empty;
    }
}
