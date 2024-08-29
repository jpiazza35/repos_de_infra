namespace CN.Project.Domain.Models.Dto
{
    public class BenchmarkComparisonDto
    {
        public int Id { get; set; }
        public string? Title { get; set; }
        public decimal Average { get; set; }
        public Dictionary<int, string>? Ratios { get; set; }
        public Dictionary<int, string> RatioGrouping
        {
            get
            {
                return Ratios is null ? new Dictionary<int, string>() : Ratios.ToDictionary(r => r.Key, r => GetRatioGrouping(r.Value));
            }
        }

        public string GetRatioGrouping(string ratioValue)
        {
            if (ratioValue == "DIV/0")
                return ratioValue;

            double.TryParse(ratioValue, out double value);

            switch (value)
            {
                case < 0.7:
                    return "Below .70";
                case >= 0.7 and < 0.8:
                    return ".70 - .80";
                case >= 0.8 and < 0.9:
                    return ".80 - .90";
                case >= 0.9 and < 1.0:
                    return ".90 - 1.00";
                case >= 1.0 and < 1.1:
                    return "1.00 - 1.10";
                case >= 1.1 and < 1.2:
                    return "1.10 - 1.20";
                case >= 1.2:
                    return "1.20 and Above";
                default:
                    return string.Empty;
            }
        }
    }
}