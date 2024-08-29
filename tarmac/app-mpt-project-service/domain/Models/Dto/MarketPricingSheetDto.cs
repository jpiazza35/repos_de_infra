using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CN.Project.Domain.Models.Dto
{
    public class MarketPricingSheetDto
    {
        [Key]
        public int AggregationMethodKey { get; set; }
        public int FileOrgKey { get; set; }
        public string PositionCode { get; set; } = string.Empty;
        public string JobCode { get; set; } = string.Empty;
        public string JobGroup { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
    }
}
