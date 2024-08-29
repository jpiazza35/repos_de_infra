using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CN.Project.Domain.Models.Dto;

namespace CN.Project.Domain.Models.Dto.MarketPricingSheet
{
    public class MarketPricingSheetInfoDto
    {
        public IdNameDto Organization { get; set; } = new IdNameDto();
        public int MarketPricingSheetId { get; set; }
        public string MarketPricingStatus { get; set; } = string.Empty;
        public DateTime? ReportDate { get; set; } = DateTime.Now;
        public string JobCode { get; set; } = string.Empty;
        public string JobTitle { get; set; } = string.Empty;
        public string PositionCode { get; set; } = string.Empty;
        public int CesOrgId { get; set; }
        public int AggregationMethodKey { get; set; }
    }
}
