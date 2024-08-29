namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class MarketPricingSheetAdjustmentNoteDto
    {
        public int MarketPricingSheetSurveyKey { get; set; }
        public int MarketPricingSheetId { get; set; }
        public int MarketSegmentCutDetailKey { get; set; }
        public int RawDataKey { get; set; }
        public int CutExternalKey { get; set; }
        public bool ExcludeInCalc { get; set; }
        public DateTime ModifiedUtcDatetime { get; set; }
        public float? AdjustmentValue { get; set; }
        public int AdjustmentNoteKey { get; set; }
        public string AdjustmentNoteName { get; set; } = string.Empty;
    }
}