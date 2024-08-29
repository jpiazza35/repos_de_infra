using Newtonsoft.Json;

namespace CN.Survey.Domain.Response
{
    public class CutGroupNameKeySet
    {
        [JsonProperty("cut_group_name_key_set")]
        public NameKeySet? NameKeySet { get; set; } = null;
        [JsonProperty("cut_sub_group_name_key_sets")]
        public List<NameKeySet> CutSubGroupNameKeySets { get; set; } = new List<NameKeySet>();
    }
}