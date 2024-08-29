namespace CN.Project.Domain.Models;

public class MarketPricingSheet
{
    public int Id { get; set; }
    public int ProjectVersionId { get; set; }
    public int AggregationMethodKey { get; set; }
    public int CesOrgId { get; set; }
    public string JobCode { get; set; } = string.Empty;
    public string JobTitle { get; set; } = string.Empty;
    public string JobGroup { get; set; } = string.Empty;
    public string PositionCode { get; set; } = string.Empty;
    public int MarketSegmentId { get; set; }
    public string MarketSegmentName { get; set; } = string.Empty;
    public string StandardJobCode { get; set; } = string.Empty;
    public string StandardJobTitle { get; set; } = string.Empty;
    public string StandardJobDescription { get; set; } = string.Empty;
    public string JobMatchStatusName { get; set; } = string.Empty;
    public int JobMatchStatusKey { get; set; }
    public string JobMatchNote { get; set; } = string.Empty;
    public int? PublisherKey { get; set; }
    public DateTime StatusChangeDate { get; set; }
}