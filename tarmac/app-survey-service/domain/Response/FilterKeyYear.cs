using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class FilterKeyYear
    {
        [JsonProperty("survey_year")]
        public int SurveyYear { get; set; }
        [JsonProperty("filter_key")]
        public int? FilterKey { get; set; }
    }
}