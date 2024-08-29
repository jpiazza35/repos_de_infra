namespace CN.Project.Domain.Models.Dto
{
    public class StandardJobMatchingDto
    {
        public string StandardJobCode { get; set; } = string.Empty;
        public string StandardJobTitle { get; set; } = string.Empty;
        public string StandardJobDescription { get; set; } = string.Empty;
        public string? BlendNote { get; set; } = null;
        public float? BlendPercent { get; set; } = null;
    }
}