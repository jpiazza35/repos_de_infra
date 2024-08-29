namespace CN.Survey.Domain
{
    public class SurveyCutFilterFlatOption
    {
        public string? Name { get; set; }
        public IEnumerable<int>? Keys { get; set; }
    }
}