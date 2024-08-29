using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class MarketPercentileSet
    {
        public int Percentile { get; set; }
        [JsonProperty("market_value")]
        public float? MarketValue { get; set; }
    }
}