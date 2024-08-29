using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class NameKeySet
    {
        [JsonProperty("filter_name")]    
        public string? FilterName { get; set; }
        [JsonProperty("filter_key_year")]
        public List<FilterKeyYear>? FilterKeyYear { get; set; }
    }
}