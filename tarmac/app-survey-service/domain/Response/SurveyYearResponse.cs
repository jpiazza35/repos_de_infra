using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class SurveyYearResponse
    {
        [JsonProperty("survey_name_key_sets")]
        public List<SurveyNameKeySet> SurveyNameKeySets { get; set; } = new List<SurveyNameKeySet>();
        [JsonProperty("survey_publisher_name_key_set")]
        public NameKeySet? SurveyPublisherNameKeySet { get; set; }
    }
}