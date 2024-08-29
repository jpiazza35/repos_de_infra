using System.ComponentModel.DataAnnotations;

namespace CN.Project.Domain.Models.Dto.MarketSegment
{
    /// <summary>
    /// Table: market_segment_combined_averages_cut
    /// </summary>
    public class CombinedAveragesCutDto
    {
        /// <summary>
        /// column: combined_averages_cut_key
        /// </summary>
        [Key]
        public int Id { get; set; }

        /// <summary>
        /// column: combined_averages_key
        /// </summary>
        public int CombinedAveragesId { get; set; }

        /// <summary>
        /// column: market_pricing_cut_name
        /// </summary>
	    public string Name { get; set; } = string.Empty;
    }
}
