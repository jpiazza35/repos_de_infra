namespace CN.Project.Domain.Models.Dto
{
    public class SourceDataDto
    {
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string JobFamily { get; set; } = string.Empty;
        public string JobGroup { get; set; } = string.Empty;
        public string PositionCode { get; set; } = string.Empty;
        public string PositionCodeDescription { get; set; } = string.Empty;
        public string LocationDescription { get; set; } = string.Empty;
        public string JobLevel { get; set; } = string.Empty;
        public int IncumbentCount { get; set; }
        public int FteCount { get; set; }
        public string PayType { get; set; } = string.Empty;
        public string PayGrade { get; set; } = string.Empty;
    }
}