namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    // This DTO is being used for the thread controller when generating a new PDF
    public class MarketPricingSheetThreadDto
    {
        public int MarketPricingSheetId { get; set; }
        public int? ClientPayDetailTaskId { get; set; }
        public int? ClientPositionDetailTaskId { get; set; }
        public int? JobMatchDetailTaskId { get; set; }
        public int? SurveyDataTaskId { get; set; }
        public int? NotesTaskId { get; set; }
        public int? ExternalDataTaskId { get; set; }
    }
}