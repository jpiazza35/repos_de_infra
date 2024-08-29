namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class SaveGridItemDto
    {
        public int MarketPricingSheetId { get; set; }
        public int? MarketSegmentCutDetailKey { get; set; }
        public int? RawDataKey { get; set; }
        public int? CutExternalKey { get; set; }
        public bool ExcludeInCalc { get; set; }
        public float? AdjustmentValue { get; set; }
        public List<int> AdjustmentNotesKey { get; set; } = new List<int>();
    }
}