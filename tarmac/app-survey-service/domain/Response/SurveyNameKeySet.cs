using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class SurveyNameKeySet
    {
        [JsonProperty("survey_name_key_set")]
        public NameKeySet? NameKeySet { get; set; } = null;
        [JsonProperty("industry_sector_name_key_sets")]
        public List<NameKeySet> IndustrySectorNameKeySets { get; set; } = new List<NameKeySet>();
        [JsonProperty("organization_type_name_key_sets")]
        public List<NameKeySet> OrganizationTypeNameKeySets { get; set; } = new List<NameKeySet>();
        [JsonProperty("cut_group_name_key_sets")]
        public List<CutGroupNameKeySet> CutGroupNameKeySets { get; set; } = new List<CutGroupNameKeySet>();
    }
}