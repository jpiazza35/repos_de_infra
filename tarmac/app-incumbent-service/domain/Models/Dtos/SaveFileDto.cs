using Microsoft.AspNetCore.Http;

namespace CN.Incumbent.Domain.Models.Dtos
{
    public class SaveFileDto
    {
        public int FileLogKey { get; set; }
        public int OrganizationId { get; set; }
        public string? SourceDataName { get; set; }
        public DateTime? EffectiveDate { get; set; }
        public string? ClientFileName { get; set; }
        public int ProjectVersion { get; set; }
        public IFormFile? File { get; set; }
    }
}
