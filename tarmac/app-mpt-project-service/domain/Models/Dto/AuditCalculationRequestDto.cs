namespace CN.Project.Domain.Models.Dto
{
    public class AuditCalculationRequestDto
    {
        public List<string> ClientJobCodes { get; set; } = new List<string>();
        public List<string> StandardJobCodes { get; set; } = new List<string>();
    }
}
