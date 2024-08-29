using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models.Dto
{
    public class JobEmployeeDto : JobBaseDto
    {
        [Key]
        public int SourceDataKey { get; set; }
        public int CesOrgId { get; set; }
        public string CesOrgName { get; set; } = string.Empty;
        public string IncumbentId { get; set; } = string.Empty;
        public string IncumbentName { get; set; } = string.Empty;
        public float FteValue { get; set; }
        public string ClientJobGroup { get; set; } = string.Empty;
        public string CreditedYoe { get; set; } = string.Empty;
        public string OriginalHireDate { get; set; } = string.Empty;
    }
}
