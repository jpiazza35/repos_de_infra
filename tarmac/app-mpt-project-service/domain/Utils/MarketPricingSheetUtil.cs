using System.Globalization;

namespace CN.Project.Domain.Utils
{
    public static class MarketPricingSheetUtil
    {
        public static string GetFormattedBenchmarkValue(double? realValue, string? format, int decimals)
        {
            var value = realValue ?? 0;

            if (format == "$")
                return decimals == 2 ? value.ToString("C") : string.Format("{0:C0}", value);
            else
                return value.ToString("F", CultureInfo.InvariantCulture) + format;
        }
    }
}