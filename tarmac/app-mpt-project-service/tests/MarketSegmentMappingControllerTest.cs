using CN.Project.Domain.Dto;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Controllers;
using CN.Project.RestApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;
using System.Security.Claims;

namespace CN.Project.Test
{
    [TestFixture]
    public class MarketSegmentMappingControllerTest
    {
        private Mock<IMarketSegmentMappingRepository> _marketSegmentMappingRepository;
        private Mock<IProjectDetailsRepository> _projectDetailsRepository;
        private Mock<IProjectRepository> _projectRepository;
        private Mock<IMarketSegmentRepository> _marketSegmentRepository;
        private Mock<IBenchmarkDataService> _benchmarkDataService;
        private MarketSegmentMappingService _marketSegmentMappingService;
        private MarketSegmentMappingController _marketSegmentMappingController;

        private List<Claim> _claims;

        [SetUp]
        public void Setup()
        {
            _claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Role, "WRITE"),
                new Claim(ClaimTypes.Name, "TestUser")
            };

            _marketSegmentMappingRepository = new Mock<IMarketSegmentMappingRepository>();
            _marketSegmentRepository = new Mock<IMarketSegmentRepository>();
            _projectDetailsRepository = new Mock<IProjectDetailsRepository>();
            _projectRepository = new Mock<IProjectRepository>();
            _benchmarkDataService = new Mock<IBenchmarkDataService>();

            _marketSegmentMappingService = new MarketSegmentMappingService(_marketSegmentMappingRepository.Object,
                                                                           _projectDetailsRepository.Object,
                                                                           _projectRepository.Object,
                                                                           _marketSegmentRepository.Object,
                                                                           _benchmarkDataService.Object);

            _marketSegmentMappingController = new MarketSegmentMappingController(_marketSegmentMappingService);
            _marketSegmentMappingController.ControllerContext = GetControllerContext();
        }

        private ControllerContext GetControllerContext()
        {
            var identity = new ClaimsIdentity(_claims, "TestAuthType");
            var user = new ClaimsPrincipal(identity);

            return new ControllerContext
            {
                HttpContext = new DefaultHttpContext
                {
                    User = user
                }
            };
        }

        [Test]
        public async Task GetMarketSegments_Success()
        {
            var marketSegments = new List<MarketSegmentDto>()
            {
                new MarketSegmentDto { Id = 1, Name = "Market segment name" }
            };

            _marketSegmentRepository.Setup(x => x.GetMarketSegments(It.IsAny<int>())).ReturnsAsync(marketSegments);
            var projectVersionId = 1;
            var response = await _marketSegmentMappingController.GetMarketSegments(projectVersionId) as OkObjectResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            _marketSegmentRepository.Verify(x => x.GetMarketSegments(It.IsAny<int>()), Times.Once());
        }

        [Test]
        public async Task SaveMarketSegmentMapping_Success()
        {
            var marketSegmentMapping = new List<MarketSegmentMappingDto>()
            {
                new () 
                { 
                    AggregationMethodKey = 1, 
                    FileOrgKey = 90,
                    JobCode = "JC001",
                    JobGroup = "Group 1",
                    MarketSegmentId = 1,
                },
                new ()
                {
                    AggregationMethodKey = 2,
                    FileOrgKey = 10423,
                    JobCode = "JC002",
                    JobGroup = "Group 2",
                    MarketSegmentId = 2,
                }

            };

            var status_draft = 1;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_draft);
            _marketSegmentMappingRepository.Setup(x => x.SaveMarketSegmentMapping(It.IsAny<int>(), It.IsAny<MarketSegmentMappingDto>(), It.IsAny<string>()));

            var projectVersionId = 1;
            var response = await _marketSegmentMappingController.SaveMarketSegmentMapping(projectVersionId, marketSegmentMapping) as OkObjectResult;

            //Assert
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.SaveMarketSegmentMapping(It.IsAny<int>(), It.IsAny<MarketSegmentMappingDto>(), It.IsAny<string>()), Times.Exactly(2));
        }

        [Test]
        public async Task SaveMarketSegmentMapping_Status_Not_Editable()
        {
            var marketSegmentMapping = new List<MarketSegmentMappingDto>()
            {
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "JC001",
                    JobGroup = "Group 1",
                    MarketSegmentId = 1,
                }
            };

            var status_final = 2;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_final);
            _marketSegmentMappingRepository.Setup(x => x.SaveMarketSegmentMapping(It.IsAny<int>(), It.IsAny<MarketSegmentMappingDto>(), It.IsAny<string>()));

            var projectVersionId = 1;
            var response = await _marketSegmentMappingController.SaveMarketSegmentMapping(projectVersionId, marketSegmentMapping) as BadRequestObjectResult;
            var errorMessage = response?.Value as string;

            //Assert
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            Assert.IsNotNull(response);
            Assert.IsNotNull(errorMessage);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(errorMessage, Is.EqualTo("Project status prevents fields from being edited."));

        }

        [Test]
        public async Task GetClientJobs_Success()
        {
            SetupClientJobsMock();

            var projectVersionId = 1;
            var response = await _marketSegmentMappingController.GetJobs(projectVersionId) as OkObjectResult;
            var jobsResult = response?.Value as List<JobDto>;

            //Asserts
            Assert.That(response, Is.Not.Null);
            Assert.That(response.StatusCode == 200, Is.True);
            Assert.That(jobsResult, Is.Not.Null);
            Assert.That(jobsResult.Count, Is.EqualTo(3));
            Assert.That(jobsResult.All(x => x.FileOrgKey == 1), Is.True);
            Assert.That(jobsResult[0].AggregationMethodKey, Is.EqualTo((int)Domain.Enum.AggregationMethodology.Child));
            Assert.That(jobsResult[0].JobCode, Is.EqualTo("JC01"));
            Assert.That(jobsResult[0].JobTitle, Is.EqualTo("Product Owner"));
            Assert.That(jobsResult[0].MarketSegmentId, Is.EqualTo(1));
            Assert.That(jobsResult[0].JobGroup, Is.EqualTo("Group1"));
            Assert.That(jobsResult[0].PositionCode, Is.EqualTo("01"));
            Assert.That(jobsResult[0].MarketSegmentName, Is.EqualTo("Market Segment One"));
            Assert.That(jobsResult[0].BenchmarkDataTypes.ContainsKey("Base Pay Hourly Rate"), Is.True);
            Assert.That(jobsResult[0].BenchmarkDataTypes.ContainsKey("Annual Rate"), Is.True);
            Assert.That(jobsResult[0].BenchmarkDataTypes["Base Pay Hourly Rate"], Is.EqualTo(3.45m));
            Assert.That(jobsResult[0].BenchmarkDataTypes["Annual Rate"], Is.EqualTo(2.31m));

            Assert.That(jobsResult[1].AggregationMethodKey, Is.EqualTo((int)Domain.Enum.AggregationMethodology.Child));
            Assert.That(jobsResult[1].JobCode, Is.EqualTo("JC02"));
            Assert.That(jobsResult[1].JobTitle, Is.EqualTo("Frontend developer"));
            Assert.That(jobsResult[1].MarketSegmentId, Is.EqualTo(1));
            Assert.That(jobsResult[1].JobGroup, Is.EqualTo("Group2"));
            Assert.That(jobsResult[1].PositionCode, Is.EqualTo("02"));
            Assert.That(jobsResult[1].MarketSegmentName, Is.EqualTo("Market Segment One"));
            Assert.That(jobsResult[1].BenchmarkDataTypes.ContainsKey("Base Pay Hourly Rate"), Is.True);
            Assert.That(jobsResult[1].BenchmarkDataTypes.ContainsKey("Annual Rate"), Is.True);
            Assert.That(jobsResult[1].BenchmarkDataTypes["Base Pay Hourly Rate"], Is.EqualTo(2.3m));
            Assert.That(jobsResult[1].BenchmarkDataTypes["Annual Rate"], Is.Null);


            //The third one doesn't have any match on the market pricing sheet that's why the jobGroup and marketSegmentId are null
            Assert.That(jobsResult[2].AggregationMethodKey, Is.EqualTo((int)Domain.Enum.AggregationMethodology.Child));
            Assert.That(jobsResult[2].JobCode, Is.EqualTo("JC03"));
            Assert.That(jobsResult[2].MarketSegmentId, Is.Null);
            Assert.That(jobsResult[2].JobGroup, Is.EqualTo("File Group 3"));
            Assert.That(jobsResult[2].PositionCode, Is.EqualTo("03"));
            Assert.That(jobsResult[2].BenchmarkDataTypes.ContainsKey("Base Pay Hourly Rate"), Is.True);
            Assert.That(jobsResult[2].BenchmarkDataTypes.ContainsKey("Annual Rate"), Is.True);
            Assert.That(jobsResult[2].BenchmarkDataTypes["Base Pay Hourly Rate"], Is.Null);
            Assert.That(jobsResult[2].BenchmarkDataTypes["Annual Rate"], Is.Null);


            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetBenchmarkDataTypeKeys(It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.GetSourceData(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _projectRepository.Verify(x => x.GetOrganizationsByIds(It.IsAny<List<int>>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
        }

        [Test]
        public async Task GetFilteredClientJobs_Success()
        {
            SetupClientJobsMock();

            var projectVersionId = 1;
            var filterInput = "Product Owner";
            var filterColumn = "JobTitle";
            var response = await _marketSegmentMappingController.GetJobs(projectVersionId, filterInput, filterColumn) as OkObjectResult;
            var filteredJobsResult = response?.Value as List<JobDto>;

            //Asserts
            Assert.IsNotNull(response);
            Assert.That(response.StatusCode == 200, Is.True);
            Assert.IsNotNull(filteredJobsResult);
            Assert.IsNotEmpty(filteredJobsResult);
            Assert.That(filteredJobsResult.Count, Is.EqualTo(1));
            Assert.That(filteredJobsResult.All(x => x.FileOrgKey == 1), Is.True);
            Assert.That(filteredJobsResult[0].AggregationMethodKey, Is.EqualTo((int)Domain.Enum.AggregationMethodology.Child));
            Assert.That(filteredJobsResult[0].JobCode, Is.EqualTo("JC01"));
            Assert.That(filteredJobsResult[0].JobTitle, Is.EqualTo("Product Owner"));
            Assert.That(filteredJobsResult[0].MarketSegmentId, Is.EqualTo(1));
            Assert.That(filteredJobsResult[0].JobGroup, Is.EqualTo("Group1"));
            Assert.That(filteredJobsResult[0].PositionCode, Is.EqualTo("01"));
            Assert.That(filteredJobsResult[0].MarketSegmentName, Is.EqualTo("Market Segment One"));
            Assert.That(filteredJobsResult[0].BenchmarkDataTypes.ContainsKey("Base Pay Hourly Rate"), Is.True);
            Assert.That(filteredJobsResult[0].BenchmarkDataTypes.ContainsKey("Annual Rate"), Is.True);
            Assert.That(filteredJobsResult[0].BenchmarkDataTypes["Base Pay Hourly Rate"], Is.EqualTo(3.45m));
            Assert.That(filteredJobsResult[0].BenchmarkDataTypes["Annual Rate"], Is.EqualTo(2.31m));

            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetBenchmarkDataTypeKeys(It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.GetSourceData(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _projectRepository.Verify(x => x.GetOrganizationsByIds(It.IsAny<List<int>>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
        }

        private void SetupClientJobsMock()
        {
            var marketSegments = new ProjectVersionDto()
            {
                AggregationMethodologyKey = Domain.Enum.AggregationMethodology.Child,
                FileLogKey = 1,
                SurveySourceGroupKey = 6, //Employee
            };

            var benchmarkDataTypeKeys = new List<int>() { 2, 3 };

            var marketPricingSheet = new List<MarketPricingSheet>() {
                new () {
                    AggregationMethodKey = (int)Domain.Enum.AggregationMethodology.Child,
                    CesOrgId = 1,
                    JobCode = "JC01",
                    PositionCode = "01",
                    MarketSegmentId = 1,
                    MarketSegmentName = "Market Segment One",
                    JobGroup = "Group1"
                },
                new () {
                    AggregationMethodKey = (int)Domain.Enum.AggregationMethodology.Child,
                    CesOrgId = 1,
                    JobCode = "JC02",
                    PositionCode = "02",
                    MarketSegmentId = 1,
                    MarketSegmentName = "Market Segment One",
                    JobGroup = "Group2"
                }
            };

            var clientJobs = new List<JobDto>() {
                new () {
                    AggregationMethodKey = (int)Domain.Enum.AggregationMethodology.Child,
                    FileOrgKey = 1,
                    JobCode = "JC01",
                    PositionCode = "01",
                    JobTitle = "Product Owner",
                    JobGroup = "File Group 1",
                    BenchmarkDataTypes = new Dictionary<string, decimal?>() {
                        { "2", 3.45m },
                        { "3", 2.31m }
                    }
                },
                new () {
                    AggregationMethodKey = (int)Domain.Enum.AggregationMethodology.Child,
                    FileOrgKey = 1,
                    JobCode = "JC02",
                    MarketSegmentId = 1,
                    PositionCode = "02",
                    JobTitle = "Frontend developer",
                    BenchmarkDataTypes = new Dictionary<string, decimal?>() {
                        { "2", 2.3m },
                        { "3", null }
                    }
                },
                new () {
                    AggregationMethodKey = (int)Domain.Enum.AggregationMethodology.Child,
                    FileOrgKey = 1,
                    JobCode = "JC03",
                    JobGroup = "File Group 3",
                    MarketSegmentId = 1,
                    PositionCode = "03",
                    JobTitle = "Backend developer",
                    BenchmarkDataTypes = new Dictionary<string, decimal?>() {
                        { "2", null },
                        { "3", null }
                    }
                }
            };

            var organizations = new List<OrganizationDto>() {
                new () {
                    Id = 1,
                    Name = "Organization One",
                }
            };

            var benchmarks = new List<BenchmarkDataTypeDto>() {
                new () {
                    Id = 2,
                    Name = "Base Pay Hourly Rate",
                    LongAlias = "Base Pay Hourly Rate"
                },
                new () {
                    Id = 3,
                    Name = "Annual Rate",
                    LongAlias = "Annual Rate"
                }
            };

            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(marketSegments);
            _projectDetailsRepository.Setup(x => x.GetBenchmarkDataTypeKeys(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypeKeys);
            _marketSegmentMappingRepository.Setup(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(marketPricingSheet);
            _marketSegmentMappingRepository.Setup(x => x.GetSourceData(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(clientJobs);
            _projectRepository.Setup(x => x.GetOrganizationsByIds(It.IsAny<List<int>>())).ReturnsAsync(organizations);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarks);
        }
    }
}
