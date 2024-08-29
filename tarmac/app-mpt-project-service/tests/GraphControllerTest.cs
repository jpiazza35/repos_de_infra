using CN.Project.Domain.Constants;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Controllers;
using CN.Project.RestApi.Services;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;

namespace CN.Project.Test
{
    [TestFixture]
    public class GraphControllerTest
    {
        private GraphController _controller;
        private GraphService _service;

        private Mock<IJobSummaryTableRepository> _jobSummaryTableRepository;
        private Mock<IProjectDetailsRepository> _projectDetailsRepository;
        private Mock<IMarketSegmentMappingRepository> _marketSegmentMappingRepository;
        private Mock<IMarketPricingSheetRepository> _marketPricingSheetRepository;
        private Mock<IMarketSegmentService> _marketSegmentService;

        [SetUp]
        public void Setup()
        {
            _jobSummaryTableRepository = new Mock<IJobSummaryTableRepository>();
            _projectDetailsRepository = new Mock<IProjectDetailsRepository>();
            _marketSegmentMappingRepository = new Mock<IMarketSegmentMappingRepository>();
            _marketPricingSheetRepository = new Mock<IMarketPricingSheetRepository>();
            _marketSegmentService = new Mock<IMarketSegmentService>();

            _service = new GraphService(_jobSummaryTableRepository.Object,
                                        _projectDetailsRepository.Object,
                                        _marketSegmentMappingRepository.Object,
                                        _marketPricingSheetRepository.Object,
                                        _marketSegmentService.Object);
            _controller = new GraphController(_service);
        }

        #region Test

        [Test]
        public async Task GetBasePayMarketComparisonGraphData_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var aggregationMethodologyKey = Domain.Enum.AggregationMethodology.Parent;
            var fileOrgKey = 2;
            var jobCode = "job codetest";
            var jobPosition = "position code test";
            var marketSegmentId = 1;
            var marketSegmentCutKey = 1;
            var benchmarkDataTypeKey = 29;
            var jobSummaryTable = new List<JobSummaryTable> {
                new JobSummaryTable{
                    CesOrgId = fileOrgKey,
                    AggregationMethodKey = (int)aggregationMethodologyKey,
                    JobCode = jobCode,
                    JobTitle = "job title test",
                    PositionCode = jobPosition,
                    MarketSegmentId = marketSegmentId,
                    MarketPricingSheetId = 3,
                    MarketPricingJobCode = "market pricing job code test",
                    MarketPricingJobTitle = "market pricing job title test",
                    MarketPricingSheetNote = "market pricing sheet note test",
                    MarketSegmentName = "market segment name test",
                    JobGroup = "job group test",
                    DataScope = "data scope test",
                    DataScopeKey = marketSegmentCutKey,
                    DataSource = "CUT"
                } };
            var projectVersionDetails = new Domain.Dto.ProjectVersionDto
            {
                AggregationMethodologyKey = aggregationMethodologyKey,
                FileLogKey = 4,
                Id = projectVersionId
            };
            var incumbentData = new List<JobEmployeeDto>
            {
                new JobEmployeeDto
                {
                    IncumbentName = "Test User",
                    IncumbentId = "Test IncumbentId",
                    FteValue = 2002,
                    FileOrgKey = fileOrgKey,
                    JobCode = jobCode,
                    PositionCode = jobPosition,
                    PositionCodeDescription = "position code description test",
                    MarketSegmentId = marketSegmentId,
                    BenchmarkDataTypes = new Dictionary<string, decimal?>{ { benchmarkDataTypeKey.ToString(), 20 } }
                }
            };
            var mainSettings = new MainSettingsDto
            {
                Benchmarks = new List<MainSettingsBenchmarkDto>
                {
                    new MainSettingsBenchmarkDto
                    {
                        Id = benchmarkDataTypeKey,
                        Title = "Base Pay Hourly Rate",
                        Percentiles = new List<int> { 50 }
                    }
                }
            };
            var marketSegments = new List<MarketSegmentDto>
            {
                new MarketSegmentDto
                {
                    Id = marketSegmentId,
                    Cuts = new List<MarketSegmentCutDto>
                    {
                        new MarketSegmentCutDto
                        {
                            MarketSegmentCutKey = marketSegmentCutKey,
                            CutName = "data scope test",
                            CutGroupName = Constants.NATIONAL_GROUP_NAME
                        }
                    }
                }
            };
            var surveyData = new List<SurveyCutDataDto>
            {
                new SurveyCutDataDto
                {
                    MarketValueByPercentile = new List<MarketPercentileDto>{ new MarketPercentileDto { Percentile = 50, MarketValue = 10F } }
                }
            };

            _jobSummaryTableRepository.Setup(x => x.GetJobSummaryTable(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto?>())).ReturnsAsync(jobSummaryTable);
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _marketPricingSheetRepository.Setup(x => x.GetMainSettings(It.IsAny<int>())).ReturnsAsync(mainSettings);
            _marketSegmentService.Setup(x => x.GetMarketSegments(It.IsAny<int>())).ReturnsAsync(marketSegments);
            _marketSegmentMappingRepository.Setup(x => x.GetSourceDataEmployeeLevel(It.IsAny<int>())).ReturnsAsync(incumbentData);
            _marketPricingSheetRepository
                .Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(surveyData);

            #endregion

            #region Act

            var response = await _controller.GetBasePayMarketComparisonGraphData(projectVersionId) as OkObjectResult;
            var dataResponse = response?.Value as List<JobSummaryTableEmployeeLevelDto>;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.IsNotNull(dataResponse);
            Assert.IsTrue(dataResponse.Count == 1);
            Assert.IsTrue(dataResponse[0].ClientJobCode == jobCode);
            Assert.IsTrue(dataResponse[0].ClientJobTitle == jobSummaryTable[0].JobTitle);
            Assert.IsTrue(dataResponse[0].ClientPositionCode == jobPosition);
            Assert.IsTrue(dataResponse[0].MarketPricingSheetId == jobSummaryTable[0].MarketPricingSheetId);
            Assert.IsTrue(dataResponse[0].BenchmarkJobCode == jobSummaryTable[0].MarketPricingJobCode);
            Assert.IsTrue(dataResponse[0].BenchmarkJobTitle == jobSummaryTable[0].MarketPricingJobTitle);
            Assert.IsTrue(dataResponse[0].JobMatchAdjustmentNotes == jobSummaryTable[0].MarketPricingSheetNote);
            Assert.IsTrue(dataResponse[0].MarketSegment == jobSummaryTable[0].MarketSegmentName);
            Assert.IsTrue(dataResponse[0].JobGroup == jobSummaryTable[0].JobGroup);
            Assert.IsTrue(dataResponse[0].IncumbentId == incumbentData[0].IncumbentId);
            Assert.IsTrue(dataResponse[0].IncumbentName == incumbentData[0].IncumbentName);
            Assert.IsTrue(dataResponse[0].FteValue == incumbentData[0].FteValue);
            Assert.IsTrue(dataResponse[0].ClientPositionCodeDescription == incumbentData[0].PositionCodeDescription);
            Assert.IsTrue(dataResponse[0].DataScope == jobSummaryTable[0].DataScope + " Average:");
            Assert.IsNotNull(dataResponse[0].Benchmarks);
            Assert.IsTrue(dataResponse[0].Benchmarks.Any());
            Assert.IsTrue(dataResponse[0].Benchmarks.Count == mainSettings.Benchmarks.Count);

            Assert.IsTrue(_jobSummaryTableRepository.Invocations.Count == 1);
            Assert.IsTrue(_jobSummaryTableRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_projectDetailsRepository.Invocations.Count == 1);
            Assert.IsTrue(_projectDetailsRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketPricingSheetRepository.Invocations.Count == 2);
            Assert.IsTrue(_marketPricingSheetRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketSegmentService.Invocations.Count == 1);
            Assert.IsTrue(_marketSegmentService.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketSegmentMappingRepository.Invocations.Count == 1);
            Assert.IsTrue(_marketSegmentMappingRepository.Invocations[0].Arguments[0].ToString() == projectVersionDetails.FileLogKey.ToString());

            _marketPricingSheetRepository
                .Verify(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                 It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()),
                                                                 Times.Once());

            #endregion
        }

        [Test]
        public async Task GetBasePayMarketComparisonGraphDataWithBenchmarkComparison_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var aggregationMethodologyKey = Domain.Enum.AggregationMethodology.Parent;
            var fileOrgKey = 2;
            var jobCode = "job codetest";
            var jobPosition = "position code test";
            var marketSegmentId = 1;
            var marketSegmentCutKey = 1;
            var benchmarkDataTypeKey = 29;
            var comparisonBenchmarkDataTypeKey = 84;
            var jobSummaryTable = new List<JobSummaryTable> {
                new JobSummaryTable{
                    CesOrgId = fileOrgKey,
                    AggregationMethodKey = (int)aggregationMethodologyKey,
                    JobCode = jobCode,
                    JobTitle = "job title test",
                    PositionCode = jobPosition,
                    MarketSegmentId = marketSegmentId,
                    MarketPricingSheetId = 3,
                    MarketPricingJobCode = "market pricing job code test",
                    MarketPricingJobTitle = "market pricing job title test",
                    MarketPricingSheetNote = "market pricing sheet note test",
                    MarketSegmentName = "market segment name test",
                    JobGroup = "job group test",
                    DataScope = "data scope test",
                    DataScopeKey = marketSegmentCutKey,
                    DataSource = "CUT"
                } };
            var projectVersionDetails = new Domain.Dto.ProjectVersionDto
            {
                AggregationMethodologyKey = aggregationMethodologyKey,
                FileLogKey = 4,
                Id = projectVersionId
            };
            var incumbentData = new List<JobEmployeeDto>
            {
                new JobEmployeeDto
                {
                    IncumbentName = "Test User",
                    IncumbentId = "Test IncumbentId",
                    FteValue = 2002,
                    FileOrgKey = fileOrgKey,
                    JobCode = jobCode,
                    PositionCode = jobPosition,
                    PositionCodeDescription = "position code description test",
                    MarketSegmentId = marketSegmentId,
                    BenchmarkDataTypes = new Dictionary<string, decimal?>{ { benchmarkDataTypeKey.ToString(), 20 } }
                }
            };
            var mainSettings = new MainSettingsDto
            {
                Benchmarks = new List<MainSettingsBenchmarkDto>
                {
                    new MainSettingsBenchmarkDto
                    {
                        Id = benchmarkDataTypeKey,
                        Title = "Base Pay Hourly Rate",
                        Percentiles = new List<int> { 50 }
                    }
                }
            };
            var marketSegments = new List<MarketSegmentDto>
            {
                new MarketSegmentDto
                {
                    Id = marketSegmentId,
                    Cuts = new List<MarketSegmentCutDto>
                    {
                        new MarketSegmentCutDto
                        {
                            MarketSegmentCutKey = marketSegmentCutKey,
                            CutName = "data scope test",
                            CutGroupName = Constants.NATIONAL_GROUP_NAME
                        }
                    }
                }
            };
            var surveyData = new List<SurveyCutDataDto>
            {
                new SurveyCutDataDto
                {
                    MarketValueByPercentile = new List<MarketPercentileDto>{ new MarketPercentileDto { Percentile = 50, MarketValue = 10F } }
                }
            };
            var jobSummaryBenchmarkComparisonRequest = new JobSummaryBenchmarkComparisonRequestDto
            {
                Benchmarks = new List<BenchmarkComparisonRequestDto>
                {
                    new BenchmarkComparisonRequestDto
                    {
                        Id = benchmarkDataTypeKey,
                        Title = "Base Pay Hourly Rate",
                        Comparisons = new List<MainSettingsBenchmarkDto>
                        {
                            new MainSettingsBenchmarkDto { Id = comparisonBenchmarkDataTypeKey, Title = "Target Annual Incentive" }
                        }
                    }
                }
            };

            _jobSummaryTableRepository.Setup(x => x.GetJobSummaryTable(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto?>())).ReturnsAsync(jobSummaryTable);
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _marketPricingSheetRepository.Setup(x => x.GetMainSettings(It.IsAny<int>())).ReturnsAsync(mainSettings);
            _marketSegmentService.Setup(x => x.GetMarketSegments(It.IsAny<int>())).ReturnsAsync(marketSegments);
            _marketSegmentMappingRepository.Setup(x => x.GetSourceDataEmployeeLevel(It.IsAny<int>())).ReturnsAsync(incumbentData);
            _marketPricingSheetRepository
                .Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(surveyData);

            #endregion

            #region Act

            var response = await _controller.GetBasePayMarketComparisonGraphDataWithBenchmarkComparison(projectVersionId, jobSummaryBenchmarkComparisonRequest) as OkObjectResult;
            var dataResponse = response?.Value as List<JobSummaryTableEmployeeLevelDto>;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.IsNotNull(dataResponse);
            Assert.IsTrue(dataResponse.Count == 1);
            Assert.IsTrue(dataResponse[0].ClientJobCode == jobCode);
            Assert.IsTrue(dataResponse[0].ClientJobTitle == jobSummaryTable[0].JobTitle);
            Assert.IsTrue(dataResponse[0].ClientPositionCode == jobPosition);
            Assert.IsTrue(dataResponse[0].MarketPricingSheetId == jobSummaryTable[0].MarketPricingSheetId);
            Assert.IsTrue(dataResponse[0].BenchmarkJobCode == jobSummaryTable[0].MarketPricingJobCode);
            Assert.IsTrue(dataResponse[0].BenchmarkJobTitle == jobSummaryTable[0].MarketPricingJobTitle);
            Assert.IsTrue(dataResponse[0].JobMatchAdjustmentNotes == jobSummaryTable[0].MarketPricingSheetNote);
            Assert.IsTrue(dataResponse[0].MarketSegment == jobSummaryTable[0].MarketSegmentName);
            Assert.IsTrue(dataResponse[0].JobGroup == jobSummaryTable[0].JobGroup);
            Assert.IsTrue(dataResponse[0].IncumbentId == incumbentData[0].IncumbentId);
            Assert.IsTrue(dataResponse[0].IncumbentName == incumbentData[0].IncumbentName);
            Assert.IsTrue(dataResponse[0].FteValue == incumbentData[0].FteValue);
            Assert.IsTrue(dataResponse[0].ClientPositionCodeDescription == incumbentData[0].PositionCodeDescription);
            Assert.IsTrue(dataResponse[0].DataScope == jobSummaryTable[0].DataScope + " Average:");
            Assert.IsNotNull(dataResponse[0].Benchmarks);
            Assert.IsTrue(dataResponse[0].Benchmarks.Any());
            Assert.IsTrue(dataResponse[0].Benchmarks.Count == mainSettings.Benchmarks.Count);
            Assert.IsNotNull(dataResponse[0].Benchmarks[0].Comparisons);
            Assert.IsTrue(dataResponse[0].Benchmarks[0].Comparisons.Any());
            Assert.IsTrue(dataResponse[0].Benchmarks[0].Comparisons.Count == jobSummaryBenchmarkComparisonRequest.Benchmarks[0].Comparisons.Count + 1);

            Assert.IsTrue(_jobSummaryTableRepository.Invocations.Count == 1);
            Assert.IsTrue(_jobSummaryTableRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_projectDetailsRepository.Invocations.Count == 1);
            Assert.IsTrue(_projectDetailsRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketPricingSheetRepository.Invocations.Count == 2);
            Assert.IsTrue(_marketPricingSheetRepository.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketSegmentService.Invocations.Count == 1);
            Assert.IsTrue(_marketSegmentService.Invocations[0].Arguments[0].ToString() == projectVersionId.ToString());
            Assert.IsTrue(_marketSegmentMappingRepository.Invocations.Count == 1);
            Assert.IsTrue(_marketSegmentMappingRepository.Invocations[0].Arguments[0].ToString() == projectVersionDetails.FileLogKey.ToString());

            _marketPricingSheetRepository
                .Verify(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                 It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()),
                                                                 Times.Once());

            #endregion
        }

        #endregion
    }
}