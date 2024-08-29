using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Utils;
using Microsoft.Extensions.Logging;
using System.Text;

namespace CN.Project.Infrastructure.Repositories
{
    public class MarketPricingSheetFileRepository : IMarketPricingSheetFileRepository
    {
        private readonly ILogger<MarketPricingSheetFileRepository> _logger;

        public MarketPricingSheetFileRepository(ILogger<MarketPricingSheetFileRepository> logger)
        {
            _logger = logger;
        }

        public string GetHeaderHtmlTemplate(bool displayOrgName, bool displayReportDate, string? organizationName, int marketPricingSheetId)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Header HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var organizationTemplate = new StringBuilder();
                var reportDateTemplate = new StringBuilder();

                if (displayOrgName)
                    organizationTemplate.AppendFormat(System.IO.File.ReadAllText("Templates/Organization.html"), organizationName);

                if (displayReportDate)
                    reportDateTemplate.AppendFormat(System.IO.File.ReadAllText("Templates/ReportDate.html"), DateTime.Now.ToString("MM/dd/yyyy"));

                return string.Format(System.IO.File.ReadAllText("Templates/Header.html"), organizationTemplate, marketPricingSheetId, reportDateTemplate);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetClientPayDetailHtmlTemplate(int marketPricingSheetId, Dictionary<string, string> payDetail)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Client Pay Detail HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var payDetailItemTemplate = System.IO.File.ReadAllText("Templates/PayDetailItem.html");
                var payDetailHtmlList = payDetail.Select(p => string.Format(payDetailItemTemplate, p.Key, p.Value)).ToList();
                return string.Format(System.IO.File.ReadAllText("Templates/ClientPayDetail.html"), string.Join("", payDetailHtmlList));
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetClientPositionDetailHtmlTemplate(int marketPricingSheetId, IEnumerable<SourceDataDto> positionDetailList)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Client Position Detail HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var positionDetailItemTemplate = System.IO.File.ReadAllText("Templates/PositionDetailItem.html");
                var positionDetailHtmlItems = new List<string>();

                foreach (var positionDetail in positionDetailList)
                {
                    if (!string.IsNullOrEmpty(positionDetail.JobCode))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Client Job Code:", positionDetail.JobCode));
                    if (!string.IsNullOrEmpty(positionDetail.JobTitle))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Client Job Title:", positionDetail.JobTitle));
                    if (!string.IsNullOrEmpty(positionDetail.JobGroup))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Client Job Group:", positionDetail.JobGroup));
                    if (!string.IsNullOrEmpty(positionDetail.LocationDescription))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Location:", positionDetail.LocationDescription));
                    if (!string.IsNullOrEmpty(positionDetail.JobFamily))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Job Family:", positionDetail.JobFamily));
                    if (!string.IsNullOrEmpty(positionDetail.PositionCode))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Position Code:", positionDetail.PositionCode));
                    if (!string.IsNullOrEmpty(positionDetail.PositionCodeDescription))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Position Code Description:", positionDetail.PositionCodeDescription));
                    if (!string.IsNullOrEmpty(positionDetail.JobLevel))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Job Level:", positionDetail.JobLevel));

                    positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "n Incumbents:", positionDetail.IncumbentCount));
                    positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "n FTEs:", positionDetail.FteCount));

                    if (!string.IsNullOrEmpty(positionDetail.PayType))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Pay Type:", positionDetail.PayType));
                    if (!string.IsNullOrEmpty(positionDetail.PayGrade))
                        positionDetailHtmlItems.Add(string.Format(positionDetailItemTemplate, "Pay Grade:", positionDetail.PayGrade));
                }

                return string.Format(System.IO.File.ReadAllText("Templates/ClientPositionDetail.html"), string.Join("", positionDetailHtmlItems));
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetJobMatchDetailHtmlTemplate(int marketPricingSheetId, JobMatchingInfo jobMatchDetail)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Job Match Detail HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var jobMatchTemplate = System.IO.File.ReadAllText("Templates/JobMatchDetail.html");

                return string.Format(jobMatchTemplate, jobMatchDetail.JobTitle, jobMatchDetail.JobMatchNote, jobMatchDetail.JobDescription);
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetMarketDataDetailHtmlTemplate(int marketPricingSheetId, Dictionary<string, bool> columns, MarketSegmentDto? marketSegment,
            List<MarketPricingSheetGridItemDto> gridItems, IEnumerable<MainSettingsBenchmarkDto> mainSettingsBenchmarks, DateTime ageToDate,
            IEnumerable<CombinedAveragesDto> combinedAverages, bool displayMarketSegmentName)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Market Data Detail HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var marketDataDetailTemplate = System.IO.File.ReadAllText("Templates/MarketDataDetail.html");
                var marketSegmentTemplate = displayMarketSegmentName ? string.Format(System.IO.File.ReadAllText("Templates/MarketSegmentName.html"), marketSegment?.Name) : string.Empty;
                var tableHeader = new StringBuilder();
                var surveyDetailsHeaderColumnSize = 3; //Columns for Job and Market Segment Cut Name are mandatory
                var benchmarksHeaderHtmlList = new StringBuilder();
                var percentilesHeaderHtmlList = new StringBuilder();
                var rowsHtmlTemplate = new StringBuilder();
                var averageRowsHtmlTemplate = new StringBuilder();

                if (gridItems.Any())
                {
                    #region Survey Details Header

                    columns.TryGetValue("surveyCode", out var displaySurveyCode);
                    columns.TryGetValue("surveyName", out var displaySurveyName);
                    columns.TryGetValue("surveyYear", out var displaySurveyYear);
                    columns.TryGetValue("surveySpecialtyCode", out var displaySurveySpecialtyCode);
                    columns.TryGetValue("surveySpecialtyName", out var displaySurveySpecialtyName);
                    columns.TryGetValue("surveyPublisherName", out var displayPublisherName);
                    columns.TryGetValue("adjustment", out var displayAdjustment);
                    columns.TryGetValue("adjustmentNotes", out var displayAdjustmentNotes);
                    columns.TryGetValue("industryName", out var displayIndustryName);
                    columns.TryGetValue("organizationTypeName", out var displayOrganizationTypeName);
                    columns.TryGetValue("cutGroupName", out var displayCutGroupName);
                    columns.TryGetValue("cutSubGroupName", out var displayCutSubGroupName);
                    columns.TryGetValue("cutName", out var displayCutName);
                    columns.TryGetValue("providerCount", out var displayProviderCount);

                    if (displaySurveyCode)
                    {
                        tableHeader.Append("<td>Survey Short Code</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayPublisherName)
                    {
                        tableHeader.Append("<td>Survey Publisher</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displaySurveyName)
                    {
                        tableHeader.Append("<td>Survey Name</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displaySurveyYear)
                    {
                        tableHeader.Append("<td>Survey Year</td>");
                        surveyDetailsHeaderColumnSize++;
                    }

                    tableHeader.Append("<td>Survey Job Code</td><td>Survey Job Title</td>");

                    if (displayAdjustment)
                    {
                        tableHeader.Append("<td>Premium/Discount</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayAdjustmentNotes)
                    {
                        tableHeader.Append("<td>Premium/Discount Note</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayIndustryName)
                    {
                        tableHeader.Append("<td>Industry/Sector</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayOrganizationTypeName)
                    {
                        tableHeader.Append("<td>Org Type</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayCutGroupName)
                    {
                        tableHeader.Append("<td>Cut Group</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayCutSubGroupName)
                    {
                        tableHeader.Append("<td>Cut Sub Group</td>");
                        surveyDetailsHeaderColumnSize++;
                    }
                    if (displayCutName)
                    {
                        tableHeader.Append("<td>Cut</td>");
                        surveyDetailsHeaderColumnSize++;
                    }

                    tableHeader.Append("<td>Market Pricing Cut</td>");

                    if (displayProviderCount)
                    {
                        tableHeader.Append("<td>n=</td>");
                        surveyDetailsHeaderColumnSize++;
                    }

                    #endregion

                    #region Benchmarks Header

                    foreach (var benchmark in mainSettingsBenchmarks)
                    {
                        benchmarksHeaderHtmlList.Append($"<th colspan=\"{benchmark.Percentiles?.Count}\">{benchmark.Title}</th>");

                        // Percentiles

                        foreach (var percentile in benchmark.Percentiles!)
                        {
                            percentilesHeaderHtmlList.Append($"<td>{percentile}th</td>");
                        }
                    }

                    #endregion

                    #region Rows

                    var realValuesForBenchmarks = new List<RealBenchmarkValueDto>();
                    var mainSettingsBenchmarkKeys = mainSettingsBenchmarks.Select(b => b.Id);

                    foreach (var item in gridItems)
                    {
                        rowsHtmlTemplate.Append("<tr>");

                        if (displaySurveyCode)
                            rowsHtmlTemplate.Append($"<td>{item.SurveyCode}</td>");
                        if (displayPublisherName)
                            rowsHtmlTemplate.Append($"<td>{item.SurveyPublisherName}</td>");
                        if (displaySurveyName)
                            rowsHtmlTemplate.Append($"<td>{item.SurveyName}</td>");
                        if (displaySurveyYear)
                            rowsHtmlTemplate.Append($"<td>{item.SurveyYear}</td>");

                        rowsHtmlTemplate.Append($"<td>{item.SurveySpecialtyCode}</td><td>{item.SurveySpecialtyName}</td>");

                        if (displayAdjustment)
                        {
                            var adjustmentSymbol = item.Adjustment < 0 ? "-" : string.Empty;
                            rowsHtmlTemplate.Append($"<td>{adjustmentSymbol}{((item.Adjustment ?? 0) * 100).ToString("0.00")} %</td>");
                        }
                        if (displayAdjustmentNotes)
                            rowsHtmlTemplate.Append($"<td>{string.Join(", ", item.AdjustmentNotes)}</td>");
                        if (displayIndustryName)
                            rowsHtmlTemplate.Append($"<td>{item.IndustryName}</td>");
                        if (displayOrganizationTypeName)
                            rowsHtmlTemplate.Append($"<td>{item.OrganizationTypeName}</td>");
                        if (displayCutGroupName)
                            rowsHtmlTemplate.Append($"<td>{item.CutGroupName}</td>");
                        if (displayCutSubGroupName)
                            rowsHtmlTemplate.Append($"<td>{item.CutSubGroupName}</td>");
                        if (displayCutName)
                            rowsHtmlTemplate.Append($"<td>{item.CutName}</td>");

                        rowsHtmlTemplate.Append($"<td>{item.MarketSegmentCutName}</td>");

                        if (displayProviderCount)
                            rowsHtmlTemplate.Append($"<td>{item.ProviderCount}</td>");

                        foreach (var benchmark in item.Benchmarks.Where(b => mainSettingsBenchmarkKeys.Contains(b.Id)))
                        {
                            var mainSettingsPercentiles = mainSettingsBenchmarks.FirstOrDefault(b => b.Id == benchmark.Id)?.Percentiles ?? new List<int>();
                            var format = benchmark.Format;
                            var decimals = benchmark.Decimals;

                            // Implementation replicated from the UI
                            var agingFactor = benchmark.AgingFactor ?? 0;
                            var x = agingFactor + 1;
                            var a = item.SurveyDataEffectiveDate < ageToDate ? 1 : -1;
                            var b = YearFrac(item.SurveyDataEffectiveDate, ageToDate);
                            var y = a * b;
                            var agedValue = Math.Pow(x, y);

                            foreach (var percentile in mainSettingsPercentiles)
                            {
                                var selectedPercentile = benchmark.Percentiles?.FirstOrDefault(p => p.Percentile == percentile);
                                var adjustment = item.Adjustment.HasValue ? item.Adjustment.Value : 0;
                                var agedMarketValue = agedValue * selectedPercentile?.MarketValue;
                                var realValue = (1 + adjustment) * agedMarketValue;

                                var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue(realValue, format, decimals);

                                rowsHtmlTemplate.Append($"<td>{formattedValue}</td>");

                                realValuesForBenchmarks.Add(new RealBenchmarkValueDto
                                {
                                    MarketSegmentCutName = item.MarketSegmentCutName,
                                    CutGroupName = item.CutGroupName,
                                    BenchmarkId = benchmark.Id,
                                    Percentile = percentile,
                                    RealValue = realValue,
                                    Format = format,
                                    Decimals = decimals
                                });
                            }
                        }

                        rowsHtmlTemplate.Append("</tr>");
                    }

                    #endregion

                    #region Averages

                    var groups = gridItems.GroupBy(i => i.MarketSegmentCutName);
                    var realValuesForBenchmarksByAverage = new List<RealBenchmarkValueDto>();

                    foreach (var group in groups)
                    {
                        averageRowsHtmlTemplate.Append("<tr>");

                        var marketSegmentCutName = group.Key;

                        averageRowsHtmlTemplate.AppendFormat($"<td colspan=\"{surveyDetailsHeaderColumnSize - 1}\">{marketSegmentCutName} Average:</td><td></td>");

                        var realValuesList = realValuesForBenchmarks.Where(r => r.MarketSegmentCutName == marketSegmentCutName);

                        foreach (var benchmark in mainSettingsBenchmarks)
                        {
                            var realValuesByBenchmark = realValuesList.Where(r => r.BenchmarkId == benchmark.Id);

                            foreach (var percentile in benchmark.Percentiles)
                            {
                                var percentileList = realValuesByBenchmark.Where(r => r.Percentile == percentile);
                                var format = percentileList.FirstOrDefault()?.Format;
                                var decimals = percentileList.FirstOrDefault()?.Decimals ?? 0;
                                var average = percentileList.Select(p => p.RealValue).Average() ?? 0;

                                var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue(average, format, decimals);

                                averageRowsHtmlTemplate.AppendFormat($"<td>{formattedValue}</td>");

                                realValuesForBenchmarksByAverage.Add(new RealBenchmarkValueDto
                                {
                                    MarketSegmentCutName = marketSegmentCutName,
                                    BenchmarkId = benchmark.Id,
                                    Percentile = percentile,
                                    RealValue = average,
                                    Format = format,
                                    Decimals = decimals
                                });
                            }
                        }

                        averageRowsHtmlTemplate.Append("</tr>");
                    }

                    var nationalGroups = gridItems.Where(i => i.MarketSegmentCutName == Domain.Constants.Constants.NATIONAL_GROUP_NAME);
                    var eriAverage = nationalGroups.Any() && marketSegment is not null && marketSegment.EriAdjustmentFactor.HasValue;

                    if (eriAverage)
                    {
                        var averageEriRowHtmlTemplate = new StringBuilder();
                        var eriAdjusmentFactor = marketSegment is not null && marketSegment.EriAdjustmentFactor.HasValue ? marketSegment.EriAdjustmentFactor.Value : 0;

                        averageEriRowHtmlTemplate.AppendFormat($"<td colspan=\"{surveyDetailsHeaderColumnSize - 1}\">" +
                            $"{marketSegment?.EriCutName} ({eriAdjusmentFactor}):" +
                            $"</td><td></td>");

                        var realValuesList = realValuesForBenchmarks.Where(r => r.MarketSegmentCutName == Domain.Constants.Constants.NATIONAL_GROUP_NAME);

                        foreach (var benchmark in mainSettingsBenchmarks)
                        {
                            var realValuesByBenchmark = realValuesList.Where(r => r.BenchmarkId == benchmark.Id);

                            foreach (var percentile in benchmark.Percentiles)
                            {
                                var percentileList = realValuesByBenchmark.Where(r => r.Percentile == percentile);
                                var format = percentileList.FirstOrDefault()?.Format;
                                var decimals = percentileList.FirstOrDefault()?.Decimals ?? 0;
                                var average = percentileList.Select(r => r.RealValue).Average() ?? 0;
                                var eriAverageValue = eriAdjusmentFactor < 0 ? (average - (average * (double)eriAdjusmentFactor)) : (average + (average * (double)eriAdjusmentFactor));

                                var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue(eriAverageValue, format, decimals);

                                averageEriRowHtmlTemplate.AppendFormat($"<td>{formattedValue}</td>");
                            }
                        }

                        averageRowsHtmlTemplate.AppendFormat("<tr>{0}</tr>", averageEriRowHtmlTemplate);
                    }

                    foreach (var combined in combinedAverages.OrderBy(c => c.Order))
                    {
                        // If the Cuts registered in the Combined Averages exists in the Items for the Grid, it will show up
                        if (combined.Cuts.Any(cut => gridItems.Any(item => item.MarketSegmentCutName == cut.Name)))
                        {
                            averageRowsHtmlTemplate.Append("<tr>");
                            averageRowsHtmlTemplate.AppendFormat($"<td colspan=\"{surveyDetailsHeaderColumnSize - 1}\">{combined.Name} Average:</td><td></td>");

                            var combinedAveragesCutNames = combined.Cuts.Select(c => c.Name);
                            var realValuesListForCombinedAverages = realValuesForBenchmarksByAverage.Where(r => combinedAveragesCutNames.Contains(r.MarketSegmentCutName));

                            foreach (var benchmark in mainSettingsBenchmarks)
                            {
                                var realValuesByBenchmark = realValuesListForCombinedAverages.Where(r => r.BenchmarkId == benchmark.Id);

                                foreach (var percentile in benchmark.Percentiles)
                                {
                                    var percentileList = realValuesByBenchmark.Where(r => r.Percentile == percentile);
                                    var format = percentileList.FirstOrDefault()?.Format;
                                    var decimals = percentileList.FirstOrDefault()?.Decimals ?? 0;
                                    var average = percentileList.Select(r => r.RealValue).Average() ?? 0;

                                    var formattedValue = MarketPricingSheetUtil.GetFormattedBenchmarkValue(average, format, decimals);

                                    averageRowsHtmlTemplate.AppendFormat($"<td>{formattedValue}</td>");
                                }
                            }

                            averageRowsHtmlTemplate.Append("</tr>");
                        }
                    }

                    #endregion

                    return string.Format(marketDataDetailTemplate, marketSegmentTemplate, surveyDetailsHeaderColumnSize, benchmarksHeaderHtmlList, tableHeader, percentilesHeaderHtmlList,
                        rowsHtmlTemplate, averageRowsHtmlTemplate);
                }
                else
                    return System.IO.File.ReadAllText("Templates/NoMarketData.html");
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetNotesHtmlTemplate(int marketPricingSheetId, DateTime ageToDate, NewStringValueDto notes, IEnumerable<BenchmarkDataTypeDto> benchmarks,
            IEnumerable<string> footerNotesList)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Notes HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var agingFactorList = benchmarks.Select(b => $"<b>{(b.AgingFactor * 100)}%</b> for {b.Name}");
                var agingFactor = $"Data above was aged to <b>{ageToDate.ToString("MM/dd/yyyy")}</b> at an annualized rate of {string.Join(", ", agingFactorList)}. This is consistent with average health care industry annual increase practices.";

                var notesTemplate = System.IO.File.ReadAllText("Templates/Notes.html");

                return string.Format(notesTemplate, agingFactor, notes.Value, string.Join("; ", footerNotesList));
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        public string GetFinalHtmlTemplate(int marketPricingSheetId, string headerTemplate, string clientPayDetailTemplate, string clientPositionDetailTemplate,
            string jobMatchTemplate, string marketDataDetailTemplate, string notesTemplate)
        {
            try
            {
                _logger.LogInformation($"\nObtaining Final HTML Template for Market Pricing Sheet: {marketPricingSheetId} \n");

                var htmlTemplate = new StringBuilder(System.IO.File.ReadAllText("Templates/Style.html"));

                htmlTemplate.AppendFormat(System.IO.File.ReadAllText("Templates/MarketPricingSheet.html"), headerTemplate, clientPositionDetailTemplate, clientPayDetailTemplate, jobMatchTemplate,
                marketDataDetailTemplate, notesTemplate);

                return htmlTemplate.ToString();
            }
            catch (Exception ex)
            {
                _logger.LogError($"\nError {ex.Message}\n");

                throw;
            }
        }

        // This method is being replicated in the UI
        private double YearFrac(DateTime startDate, DateTime endDate, int? basis = null)
        {
            // Credits: David A. Wheeler [http://www.dwheeler.com/]

            basis = !basis.HasValue ? 0 : basis;

            // Return error if basis is neither 0, 1, 2, 3, or 4
            if (!new List<int> { 0, 1, 2, 3, 4 }.Contains(basis.Value))
                return 0;

            // Return zero if start date and end date are the same
            if (startDate == endDate)
                return 0;

            // Swap dates if start date is later than end date
            if (startDate > endDate)
                (startDate, endDate) = (endDate, startDate);

            // Lookup years, months, and days
            var startYear = startDate.Year;
            var startMonth = startDate.Month;
            var startDay = startDate.Day;
            var endYear = endDate.Year;
            var endMonth = endDate.Month;
            var endDay = endDate.Day;

            switch (basis)
            {
                case 0:
                    // US (NASD) 30/360
                    // Note: if start day == 31, it stays 31 if start day < 30
                    if (startDay == 31 && endYear == 31)
                    {
                        startDay = 30;
                        endDay = 30;
                    }
                    else if (startDay == 31)
                    {
                        startDay = 30;
                    }
                    else if (startDay == 30 && endDay == 31)
                    {
                        endDay = 30;
                    }
                    else if (startMonth == 1 && endMonth == 1 && DateTime.DaysInMonth(startYear, startMonth) == startDay && DateTime.DaysInMonth(endYear, endMonth) == endDay)
                    {
                        startDay = 30;
                        endDay = 30;
                    }
                    else if (startMonth == 1 && DateTime.DaysInMonth(startYear, startMonth) == startDay)
                    {
                        startDay = 30;
                    }

                    return ((double)endDay + (double)endMonth * 30 + (double)endYear * 360 - ((double)startDay + (double)startMonth * 30 + (double)startYear * 360)) / 360;

                case 1:
                    // Actual/actual
                    double yearLength = 365;
                    if (startYear == endYear || (startYear + 1 == endYear && (startMonth > endMonth || (startMonth == endMonth && startDay >= endDay))))
                    {
                        if (startYear == endYear && DateTime.IsLeapYear(startYear))
                        {
                            yearLength = 366;
                        }
                        else if (IsFebruaryTwentyNineBetweenTwoDates(startDate, endDate) || (endMonth == 1 && endDay == 29))
                        {
                            yearLength = 366;
                        }

                        return (endDate - startDate).TotalDays / yearLength;
                    }
                    else
                    {
                        var years = (double)(endYear - startYear + 1);
                        var days = (new DateTime(endYear + 1, 1, 1) - new DateTime(startYear, 1, 1)).TotalDays;
                        var average = days / years;

                        return (endDate - startDate).TotalDays / average;
                    }

                case 2:
                    // Actual/360
                    return (endDate - startDate).TotalDays / 360;

                case 3:
                    // Actual/365
                    return (endDate - startDate).TotalDays / 365;

                case 4:
                    // European 30/360
                    if (startDay == 31) startDay = 30;
                    if (endDay == 31) endDay = 30;
                    // Remarkably, do NOT change February 28 or February 29 at ALL
                    return ((double)endDay + (double)endMonth * 30 + (double)endYear * 360 - ((double)startDay + (double)startMonth * 30 + (double)startYear * 360)) / 360;
            }

            return 0;
        }

        private bool IsFebruaryTwentyNineBetweenTwoDates(DateTime startDate, DateTime endDate)
        {
            // Requires end year == (start year + 1) or end year == start year
            // Returns TRUE if February 29 is between the two dates (start date may be February 29), with two possibilities:
            // start year is a leap year and start date <= Februay 29 of start year
            // end year is a leap year and end year > Februay 29 of end year

            var marchFirstStartDate = new DateTime(startDate.Year, 3, 1);
            if (DateTime.IsLeapYear(startDate.Year) && startDate < marchFirstStartDate && endDate >= marchFirstStartDate)
            {
                return true;
            }

            var marchFirstEndDate = new DateTime(endDate.Year, 3, 1);
            if (DateTime.IsLeapYear(endDate.Year) && endDate >= marchFirstEndDate && startDate < marchFirstEndDate)
            {
                return true;
            }

            return false;
        }
    }
}
