namespace CN.Project.Domain.Models.Dto
{
    public class AuditCalculationDto
    {
        public BasePayDto? Annual { get; set; } = null;
        public BasePayDto? Hourly { get; set; } = null;
    }

    public class BasePayDto
    {
        public float TenthPercentile { get; set; }
        public float FiftiethPercentile { get; set; }
        public float NinetiethPercentile { get; set; }
        public float Average { get; set; }
        public string? CompaRatio { get; set; } = null;

        public BasePayDto(IEnumerable<float> basePayList, IEnumerable<float> tenthPercentile, IEnumerable<float> fiftiethPercentile, IEnumerable<float> ninetiethPercentile)
        {
            Average = GetAverage(basePayList);
            TenthPercentile = GetAverage(tenthPercentile);
            FiftiethPercentile = GetAverage(fiftiethPercentile);
            NinetiethPercentile = GetAverage(ninetiethPercentile);

            if (FiftiethPercentile > 0)
            {
                var compaRatioValue = Average / FiftiethPercentile;

                CompaRatio = compaRatioValue.ToString("0.00");
            }
            else
                CompaRatio = "DIV/0";
        }

        private float GetAverage(IEnumerable<float> values)
        {
            return values.Any() ? values.Average() : 0;
        }
    }
}