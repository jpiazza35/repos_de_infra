namespace CN.Survey.Domain.Request
{
    public class SurveyCutFilterFlatOptionsRequest
    {
        public bool Publisher { get; set; }
        public bool Survey { get; set; }
        public bool Industry { get; set; }
        public bool Organization { get; set; }
        public bool CutGroup { get; set; }
        public bool CutSubGroup { get; set; }
        public IEnumerable<int>? CutGroupKeys { get; set; }
    }
}
