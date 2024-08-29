namespace CN.Project.Domain.Models.Dto
{
    public class JobSummaryTableEmployeeLevelDto : JobSummaryTableBaseDto
    {
        public string IncumbentId { get; set; } = string.Empty;
        public string IncumbentName { get; set; } = string.Empty;
        public float FteValue { get; set; }
        public decimal? CreditedYoe { get; set; }
        public DateTime? OriginalHireDate { get; set; }
        public string? CreditedYoeGrouping
        {
            get
            {
                return GetCreditedYoeGrouping();
            }
        }
        public string? TenureGrouping
        {
            get
            {
                return GetTenureGrouping();
            }
        }

        private string? GetCreditedYoeGrouping()
        {
            if (!CreditedYoe.HasValue)
                return null;

            switch (CreditedYoe)
            {
                case < 1:
                    return "Less than 1 year";
                case >= 1 and < 4:
                    return "1-4";
                case >= 4 and < 8:
                    return "4-8";
                case >= 8 and < 15:
                    return "8-15";
                case >= 15 and < 22:
                    return "15-22";
                case >= 22:
                    return "22 and more";
                default: 
                    return string.Empty;
            }
        }

        private string? GetTenureGrouping()
        {
            if (!OriginalHireDate.HasValue)
                return null;

            var zeroTime = new DateTime(1, 1, 1);
            var dateDifference = DateTime.Now - OriginalHireDate.Value;
            // Because we start at year 1 for the Gregorian calendar, we must subtract a year here.
            var yearsDifference = (zeroTime + dateDifference).Year - 1;

            switch (yearsDifference)
            {
                case < 1:
                    return "Less than 1 year";
                case >= 1 and < 4:
                    return "1-4";
                case >= 4 and < 8:
                    return "4-8";
                case >= 8 and < 15:
                    return "8-15";
                case >= 15 and < 22:
                    return "15-22";
                case >= 22:
                    return "22 and more";
            }
        }
    }
}
