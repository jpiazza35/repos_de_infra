using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CN.Project.Domain.Models.Dto
{
	public class JobMatchingStatusUpdateDto
	{
		public int AggregationMethodKey { get; set; }
		public int FileOrgKey { get; set; }
		public string PositionCode { get; set; } = string.Empty;
		public string JobCode { get; set; } = string.Empty;
	}
}
