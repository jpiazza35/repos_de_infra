using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CN.Project.Domain.Models.Dto.MarketSegment
{
    /// <summary>
    /// Table: market_segment_combined_averages_cut
    /// </summary>
    public class CombinedAveragesDto
    {
        /// <summary>
        /// column: combined_averages_key
        /// </summary>
        [Key]
        public int Id { get; set; }
        
        /// <summary>
        /// column: market_segment_id
        /// </summary>
        public int MarketSegmentId { get; set; }

        /// <summary>
        /// column: combined_averages_name
        /// </summary>
        public string Name { get; set; } = string.Empty;

        /// <summary>
        /// column: combined_averages_order
        /// </summary>
        public int Order { get; set; }

        /// <summary>
        /// Table: market_segment_combined_averages_cut
        /// </summary>
        public List<CombinedAveragesCutDto> Cuts { get; set; } = new List<CombinedAveragesCutDto>();
    }
}
