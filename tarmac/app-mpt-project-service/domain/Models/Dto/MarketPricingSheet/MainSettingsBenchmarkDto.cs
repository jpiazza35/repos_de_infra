namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class MainSettingsBenchmarkDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public float? AgingFactor { get; set; }
        public int? Order { get; set; }
        public List<int> Percentiles { get; set; } = new List<int>();
    }
}
