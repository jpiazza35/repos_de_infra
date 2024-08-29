using CN.Project.Domain.Dto;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketPricingSheet;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Domain.Services;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Controllers;
using CN.Project.RestApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;
using System.Globalization;
using System.Security.Claims;

namespace CN.Project.Test
{
    [TestFixture]
    public class MarketPricingSheetControllerTest
    {
        private MarketPricingSheetController _marketPricingSheetController;
        private MarketPricingSheetService _marketPricingSheetService;

        private Mock<IMarketPricingSheetRepository> _marketPricingSheetRepository;
        private Mock<IProjectRepository> _projectRepository;
        private Mock<IMarketSegmentMappingRepository> _marketSegmentMappingRepository;
        private Mock<IProjectDetailsRepository> _projectDetailsRepository;
        private Mock<IMarketSegmentRepository> _marketSegmentRepository;
        private Mock<IFileRepository> _fileRepository;
        private Mock<IMarketPricingSheetFileRepository> _marketPricingSheetFileRepository;
        private Mock<ICombinedAveragesRepository> _combinedAveragesRepository;
        private Mock<IBenchmarkDataService> _benchmarkDataService;

        private List<Claim> _claims;
        private MainSettingsDto _mainSettings;

        [SetUp]
        public void Setup()
        {
            // Adding the culture for the tests
            Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");

            _claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Role, "WRITE"),
                new Claim(ClaimTypes.Name, "TestUser")
            };

            _marketPricingSheetRepository = new Mock<IMarketPricingSheetRepository>();
            _projectRepository = new Mock<IProjectRepository>();
            _marketSegmentMappingRepository = new Mock<IMarketSegmentMappingRepository>();
            _projectDetailsRepository = new Mock<IProjectDetailsRepository>();
            _marketSegmentRepository = new Mock<IMarketSegmentRepository>();
            _fileRepository = new Mock<IFileRepository>();
            _marketPricingSheetFileRepository = new Mock<IMarketPricingSheetFileRepository>();
            _combinedAveragesRepository = new Mock<ICombinedAveragesRepository>();
            _benchmarkDataService = new Mock<IBenchmarkDataService>();

            _marketPricingSheetService = new MarketPricingSheetService(_marketPricingSheetRepository.Object,
                                                                       _projectRepository.Object,
                                                                       _marketSegmentMappingRepository.Object,
                                                                       _projectDetailsRepository.Object,
                                                                       _marketSegmentRepository.Object,
                                                                       _fileRepository.Object,
                                                                       _marketPricingSheetFileRepository.Object,
                                                                       _combinedAveragesRepository.Object,
                                                                       _benchmarkDataService.Object);

            _marketPricingSheetController = new MarketPricingSheetController(_marketPricingSheetService);
            _marketPricingSheetController.ControllerContext = GetControllerContext();

            _mainSettings = new MainSettingsDto()
            {
                Sections = new Dictionary<string, bool>() {
                    { "Section1", true },
                    { "Section2", false },
                    { "Section3", false }
                },
                Columns = new Dictionary<string, bool>() {
                    { "Column1", true },
                    { "Column2", false },
                    { "Column3", true },
                    { "Column4", true }
                },
                AgeToDate = DateTime.Now,
                Benchmarks = new List<MainSettingsBenchmarkDto>() {
                    new () {
                        Id = 1,
                        Title = "Benchmar data type 1",
                        Percentiles = new List<int>() { 25, 50 }
                    },
                    new () {
                        Id = 2,
                        Title = "Benchmar data type 2",
                        Percentiles = new List<int>() { 50, 75 }
                    }
                }
            };
        }

        #region Tests

        [Test]
        public async Task GetStatus_Success()
        {
            var projectVersionId = 1;
            var filter = new MarketPricingSheetFilterDto { };
            var status = new List<MarketPricingStatusDto> { new MarketPricingStatusDto { JobMatchStatusKey = 7, Count = 2 }, new MarketPricingStatusDto { JobMatchStatusKey = 8, Count = 3 } };
            var total = status.Select(s => s.Count).Sum();

            _marketPricingSheetRepository.Setup(x => x.GetStatus(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto>())).ReturnsAsync(status);

            var response = await _marketPricingSheetController.GetStatus(projectVersionId, filter) as OkObjectResult;
            var statusResponse = response?.Value as List<MarketPricingStatusDto>;

            //Assert
            Assert.NotNull(response);
            Assert.NotNull(statusResponse);
            Assert.IsNotEmpty(statusResponse);
            Assert.That(statusResponse.Count, Is.EqualTo(5));
            Assert.That(statusResponse.FirstOrDefault(s => s.JobMatchStatus.Equals("Total"))?.Count, Is.EqualTo(total));

            _marketPricingSheetRepository.Verify(x => x.GetStatus(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto>()), Times.Once());
        }

        [Test]
        public async Task GetMarketSegmentsNames_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            IdNameDto dto = new IdNameDto { Id = 1, Name = "Test" };
            List<IdNameDto> listDto = new List<IdNameDto> { dto };
            _marketPricingSheetRepository.Setup(x => x.GetMarketSegmentsNames(It.IsAny<int>())).ReturnsAsync(listDto);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetMarketSegmentsNames(projectVersionId) as OkObjectResult;
            var dataResponse = response?.Value as List<IdNameDto>;
            #endregion

            #region Assert 
            Assert.NotNull(response);
            Assert.NotNull(dataResponse);
            Assert.IsInstanceOf<List<IdNameDto>>(response.Value);
            Assert.That(dataResponse.Count, Is.EqualTo(listDto.Count));
            Assert.That(dataResponse[0].Id, Is.EqualTo(dto.Id));
            Assert.That(dataResponse[0].Name, Is.EqualTo(dto.Name));
            Assert.That(_marketPricingSheetRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Method.Name, Is.EqualTo("GetMarketSegmentsNames"));
            #endregion

        }

        [Test]
        public async Task GetJobGroups_Success()
        {
            var projectVersionId = 1;
            var jobGoups = new List<string> { "Test Group 1", "Test Group 2" };

            _marketPricingSheetRepository.Setup(x => x.GetJobGroups(It.IsAny<int>())).ReturnsAsync(jobGoups);

            var response = await _marketPricingSheetController.GetJobGroups(projectVersionId) as OkObjectResult;
            var jobGroupsResponse = response?.Value as List<string>;

            //Assert
            Assert.NotNull(response);
            Assert.NotNull(jobGroupsResponse);
            Assert.IsNotEmpty(jobGroupsResponse);
            Assert.That(jobGroupsResponse.Count, Is.EqualTo(jobGoups.Count));

            _marketPricingSheetRepository.Verify(x => x.GetJobGroups(It.IsAny<int>()), Times.Once());
        }

        [Test]
        public async Task GetJobTitles_Success()
        {
            var projectVersionId = 1;
            var filter = new MarketPricingSheetFilterDto();
            var jobTitles = new List<JobTitleFilterDto>
            {
                new JobTitleFilterDto { MarketPricingSheetId = 1, JobCode = "2.52", JobTitle = "Software Developer 2" },
                new JobTitleFilterDto { MarketPricingSheetId = 2, JobCode = "3", JobTitle = "Software Developer 1" }
            };

            _marketPricingSheetRepository.Setup(x => x.GetJobTitles(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto>())).ReturnsAsync(jobTitles);

            var response = await _marketPricingSheetController.GetJobTitles(projectVersionId, filter) as OkObjectResult;
            var jobTitlesResponse = response?.Value as IEnumerable<JobTitleFilterDto>;

            //Assert
            Assert.NotNull(response);
            Assert.NotNull(jobTitlesResponse);
            Assert.IsNotEmpty(jobTitlesResponse);
            Assert.That(jobTitlesResponse.Count, Is.EqualTo(jobTitles.Count));

            _marketPricingSheetRepository.Verify(x => x.GetJobTitles(It.IsAny<int>(), It.IsAny<MarketPricingSheetFilterDto>()), Times.Once());
        }

        [Test]
        public async Task GetSheetInfo_Success()
        {
            #region Arrange
            int projectVersionId = 1;
            int marketPricingSheetId = 2;
            DateTime reportDate = DateTime.Now;
            MarketPricingSheetInfoDto dataDto = new MarketPricingSheetInfoDto
            {
                MarketPricingSheetId = marketPricingSheetId,
                MarketPricingStatus = "Test Status Name",
                ReportDate = reportDate,
                Organization = new IdNameDto { Id = 1, Name = "" },
            };

            OrganizationDto organizationDto = new OrganizationDto { Id = 1, Name = "Test Organization Name" };
            _marketPricingSheetRepository.Setup(x => x.GetSheetInfo(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(dataDto);
            _projectRepository.Setup(x => x.GetOrganizationsByIds(It.IsAny<List<int>>())).ReturnsAsync(new List<OrganizationDto> { organizationDto });
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetSheetInfo(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var dataResponse = response?.Value as MarketPricingSheetInfoDto;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_marketPricingSheetRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[1], Is.EqualTo(marketPricingSheetId));

            Assert.That(_projectRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_projectRepository.Invocations[0].Arguments[0], Is.EqualTo(new List<int> { dataDto.Organization.Id }));

            Assert.NotNull(dataResponse);
            Assert.IsInstanceOf<MarketPricingSheetInfoDto>(response.Value);
            Assert.That(dataResponse.MarketPricingSheetId, Is.EqualTo(dataDto.MarketPricingSheetId));
            Assert.That(dataResponse.MarketPricingStatus, Is.EqualTo(dataDto.MarketPricingStatus));
            Assert.That(dataResponse.ReportDate, Is.EqualTo(dataDto.ReportDate));
            Assert.That(dataResponse.Organization.Id, Is.EqualTo(dataDto.Organization.Id));
            Assert.That(dataResponse.Organization.Name, Is.EqualTo(organizationDto.Name));
            #endregion
        }

        [Test]
        public async Task GetClientPositionDetail_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var jobCode = "Job Code Test";
            var jobTitle = "Job Title Test";
            var positionCode = "Position Code Test";
            var projectVersionDetails = new ProjectVersionDto { Id = projectVersionId, FileLogKey = 1, AggregationMethodologyKey = Domain.Enum.AggregationMethodology.Parent };
            var sourceData = new List<JobDto>()
            {
                new ()
                {
                    JobCode = jobCode,
                    JobTitle = jobTitle,
                    PositionCode = positionCode,
                }
            };

            var marketPricingSheetList = new List<MarketPricingSheet>() { new MarketPricingSheet { Id = marketPricingSheetId, JobCode = jobCode, JobTitle = jobTitle, PositionCode = positionCode } };

            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _marketSegmentMappingRepository.Setup(x => x.ListClientPositionDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>())).ReturnsAsync(sourceData);
            _marketPricingSheetRepository.Setup(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(marketPricingSheetList);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetClientPositionDetail(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var clientDetailResponse = response?.Value as IEnumerable<SourceDataDto>;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(clientDetailResponse);
            Assert.IsNotEmpty(clientDetailResponse);
            Assert.That(clientDetailResponse.First().JobCode, Is.EqualTo(jobCode));
            Assert.That(clientDetailResponse.First().JobTitle, Is.EqualTo(jobTitle));
            Assert.That(clientDetailResponse.First().PositionCode, Is.EqualTo(positionCode));

            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.ListClientPositionDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task UpdateJobMatchStatus_Success()
        {
            #region arrange
            int projectVersionId = 1;
            int marketPricingSheetId = 2;
            int jobMatchStatusId = (int)MarketPricingStatus.AnalystReviewed;
            int status = (int)ProjectVersionStatus.Draft;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status);
            #endregion

            #region act
            var response = await _marketPricingSheetController.UpdateJobMatchStatus(projectVersionId, marketPricingSheetId, jobMatchStatusId) as OkResult;
            #endregion

            #region assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_projectRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_projectRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_projectRepository.Invocations[0].Method.Name, Is.EqualTo("GetProjectVersionStatus"));

            Assert.That(_marketPricingSheetRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[1], Is.EqualTo(marketPricingSheetId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[2], Is.EqualTo(jobMatchStatusId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[3], Is.EqualTo(_claims[1].Value));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Method.Name, Is.EqualTo("UpdateMarketPricingStatus"));
            #endregion

        }

        [Test]
        public async Task UpdateJobMatchStatus_Fail()
        {
            #region arrange
            int projectVersionId_0 = 0;
            int projectVersionId_1 = 1;
            int marketPricingSheetId = 2;
            int jobMatchStatusId = 4;
            int status = (int)ProjectVersionStatus.Final;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status);
            #endregion

            #region act
            var response_1 = await _marketPricingSheetController.UpdateJobMatchStatus(projectVersionId_0, marketPricingSheetId, jobMatchStatusId) as BadRequestResult;
            var response_2 = await _marketPricingSheetController.UpdateJobMatchStatus(projectVersionId_1, marketPricingSheetId, jobMatchStatusId) as BadRequestObjectResult;
            #endregion

            #region assert
            Assert.NotNull(response_1);
            Assert.IsTrue(response_1.StatusCode == 400);

            Assert.NotNull(response_2);
            Assert.IsTrue(response_2.StatusCode == 400);
            Assert.That(response_2.Value, Is.EqualTo("Project status prevents fields from being edited."));
            #endregion

        }

        [Test]
        public async Task GetJobMatchDetail_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            JobMatchingInfo dto = new JobMatchingInfo
            {
                JobTitle = "Software Developer 1 - standard",
                JobDescription = "Information Tecnhology",
                JobMatchNote = "Reviewed by Analyst",
            };
            _marketPricingSheetRepository.Setup(x => x.GetJobMatchDetail(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(dto);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetJobMatchDetail(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var jobMatchDetailResponse = response?.Value as JobMatchingInfo;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(jobMatchDetailResponse);
            Assert.That(jobMatchDetailResponse.JobTitle, Is.EqualTo(dto.JobTitle));
            Assert.That(jobMatchDetailResponse.JobDescription, Is.EqualTo(dto.JobDescription));
            Assert.That(jobMatchDetailResponse.JobMatchNote, Is.EqualTo(dto.JobMatchNote));
            Assert.That(_marketPricingSheetRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[1], Is.EqualTo(marketPricingSheetId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Method.Name, Is.EqualTo("GetJobMatchDetail"));
            #endregion
        }

        [Test]
        public async Task SaveJobMatchDetail_Success()
        {
            #region Arrange
            int projectVersionId = 1;
            int marketPricingSheetId = 1;
            NewStringValueDto jobMatchNote = new NewStringValueDto() { Value = "Reviewed by Analyst TEST" };
            int status = (int)ProjectVersionStatus.Draft;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.SaveJobMatchDetail(projectVersionId, marketPricingSheetId, jobMatchNote) as OkResult;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_projectRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_projectRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_projectRepository.Invocations[0].Method.Name, Is.EqualTo("GetProjectVersionStatus"));

            Assert.That(_marketPricingSheetRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[0], Is.EqualTo(projectVersionId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[1], Is.EqualTo(marketPricingSheetId));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[2], Is.EqualTo(jobMatchNote.Value));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Arguments[3], Is.EqualTo(_claims[1].Value));
            Assert.That(_marketPricingSheetRepository.Invocations[0].Method.Name, Is.EqualTo("SaveJobMatchDetail"));
            #endregion
        }

        [Test]
        public async Task SaveJobMatchDetail_Fail()
        {
            #region arrange
            int projectVersionId_0 = 0;
            int projectVersionId_1 = 1;
            int marketPricingSheetId_0 = 0;
            int marketPricingSheetId_1 = 1;
            NewStringValueDto jobMatchNote = new NewStringValueDto() { Value = "Reviewed by Analyst TEST" };
            int status = (int)ProjectVersionStatus.Final;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status);
            #endregion

            #region act
            var response_1 = await _marketPricingSheetController.SaveJobMatchDetail(projectVersionId_0, marketPricingSheetId_0, jobMatchNote) as BadRequestResult;
            var response_2 = await _marketPricingSheetController.SaveJobMatchDetail(projectVersionId_1, marketPricingSheetId_0, jobMatchNote) as BadRequestResult;
            var response_3 = await _marketPricingSheetController.SaveJobMatchDetail(projectVersionId_1, marketPricingSheetId_1, jobMatchNote) as BadRequestObjectResult;
            #endregion

            #region assert
            Assert.NotNull(response_1);
            Assert.IsTrue(response_1.StatusCode == 400);

            Assert.NotNull(response_2);
            Assert.IsTrue(response_2.StatusCode == 400);

            Assert.NotNull(response_3);
            Assert.IsTrue(response_3.StatusCode == 400);
            Assert.That(response_3.Value, Is.EqualTo("Project status prevents fields from being edited."));
            #endregion

        }

        [Test]
        public async Task GetClientPayDetail_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var jobCode = "Job Code Test";
            var jobTitle = "Job Title Test";
            var positionCode = "Position Code Test";
            var projectVersionDetails = new ProjectVersionDto { Id = projectVersionId, FileLogKey = 1, AggregationMethodologyKey = Domain.Enum.AggregationMethodology.Parent };
            var sourceData = new List<JobDto> {
                new JobDto
                {
                    JobCode = jobCode,
                    JobTitle = jobTitle,
                    PositionCode= positionCode,
                }
            };

            var marketPricingSheet = new MarketPricingSheetInfoDto
            {
                MarketPricingSheetId = marketPricingSheetId,
                JobCode = jobCode,
                JobTitle = jobTitle,
                PositionCode = positionCode,
                AggregationMethodKey = 1,
                CesOrgId = 90
            };

            var projectBenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto> { new() { BenchmarkDataTypeKey = 1 }, new() { BenchmarkDataTypeKey = 2 } };
            var clientPayDetail = new List<ClientPayDto>() {
                new ClientPayDto()
                {
                    BenchmarkDataTypeKey = 1,
                    BenchmarkDataTypeValue = 3.5f
                },
                new ClientPayDto()
                {
                    BenchmarkDataTypeKey = 2,
                    BenchmarkDataTypeValue = 2.1f
                }
            };

            var benchmarkDataTypes = new List<BenchmarkDataTypeDto>() {
                new ()
                {
                    Id = 1,
                    Name = "Benchmark data type 1",
                    LongAlias = "Benchmark data type 1",
                    Format = "$",
                    Decimals = 2
                },
                new ()
                {
                    Id = 2,
                    Name = "Benchmark data type 2",
                    LongAlias = "Benchmark data type 2",
                    Format = "$",
                    Decimals = 2
                }
            };

            _projectDetailsRepository.SetupSequence(x => x.GetProjectVersionDetails(It.IsAny<int>()))
                .ReturnsAsync(projectVersionDetails)
                .ReturnsAsync(projectVersionDetails);
            _projectDetailsRepository.Setup(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(projectBenchmarkDataTypes);
            _projectDetailsRepository.Setup(x => x.ListClientPayDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<IEnumerable<int>>())).ReturnsAsync(clientPayDetail);
            _marketPricingSheetRepository.Setup(x => x.GetSheetInfo(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(marketPricingSheet);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes);

            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetClientPayDetail(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var clientDetailResponse = response?.Value as Dictionary<string, string>;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(clientDetailResponse);
            Assert.IsNotEmpty(clientDetailResponse);
            Assert.That(clientDetailResponse.ContainsKey("Benchmark data type 1"), Is.True);
            Assert.That(clientDetailResponse.ContainsKey("Benchmark data type 2"), Is.True);
            Assert.That(clientDetailResponse["Benchmark data type 1"], Is.EqualTo("$3.50"));
            Assert.That(clientDetailResponse["Benchmark data type 2"], Is.EqualTo("$2.10"));

            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Exactly(2));
            _projectDetailsRepository.Verify(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.ListClientPayDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<IEnumerable<int>>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.GetSheetInfo(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task GetAdjusmentNoteList_Success()
        {
            #region Arrange
            var adjustmentNotes = new List<IdNameDto>() {
                new()
                {
                    Id = 1,
                    Name = "Level"
                },
                new()
                {
                    Id = 2,
                    Name = "Scope"
                }
            };

            _marketPricingSheetRepository.Setup(x => x.GetAdjusmentNoteList()).ReturnsAsync(adjustmentNotes);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetAdjusmentNoteList() as OkObjectResult;
            var dataResponse = response?.Value as List<IdNameDto>;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(dataResponse);
            Assert.That(dataResponse[0].Id, Is.EqualTo(adjustmentNotes[0].Id));
            Assert.That(dataResponse[0].Name, Is.EqualTo(adjustmentNotes[0].Name));
            Assert.That(dataResponse[1].Id, Is.EqualTo(adjustmentNotes[1].Id));
            Assert.That(dataResponse[1].Name, Is.EqualTo(adjustmentNotes[1].Name));
            _marketPricingSheetRepository.Verify(x => x.GetAdjusmentNoteList(), Times.Once());
            #endregion
        }

        [Test]
        public async Task GetGridItemsForMarketPricingSheet_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var surveyKey = 1;
            var publisherKey = 2;
            var industrySectorKey = 3;
            var organizationTypeKey = 4;
            var cutGroupKey = 5;
            var cutSubGroupKey = 6;
            var cutKey = 7;
            var benchmarkDataTypeKey = 29;
            var benchmarkDataTypeName = "Base Pay Hourly Rate";
            var marketPricingSheetList = new List<MarketPricingSheet>() { new MarketPricingSheet { Id = marketPricingSheetId, MarketSegmentId = 10, StandardJobCode = "3030" } };
            var projectVersionDetails = new ProjectVersionDto { Id = projectVersionId, SurveySourceGroupKey = 6 };
            var marketSegmentCutDetails = new List<MarketSegmentCutSurveyDetailDto>
            {
                new MarketSegmentCutSurveyDetailDto
                {
                    SurveyKey = surveyKey,
                    PublisherKey = publisherKey,
                    IndustrySectorKey = industrySectorKey,
                    OrganizationTypeKey = organizationTypeKey,
                    CutGroupKey = cutGroupKey,
                    CutSubGroupKey = cutSubGroupKey,
                    CutKey = cutKey,
                }
            };
            var benchmarkDataTypes = new List<BenchmarkDataTypeDto> { new() { Id = benchmarkDataTypeKey, Name = benchmarkDataTypeName } };
            var projectBenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto> { new() { BenchmarkDataTypeKey = benchmarkDataTypeKey } };
            var adjustmentNotes = new List<MarketPricingSheetAdjustmentNoteDto> { };
            var surveyData = new List<SurveyCutDataDto>
            {
                new SurveyCutDataDto
                {
                    SurveyKey = surveyKey,
                    SurveyPublisherKey = publisherKey,
                    IndustrySectorKey = industrySectorKey,
                    OrganizationTypeKey = organizationTypeKey,
                    CutGroupKey = cutGroupKey,
                    CutSubGroupKey = cutSubGroupKey,
                    CutKey = cutKey,
                    BenchmarkDataTypeKey = benchmarkDataTypeKey,
                    BenchmarkDataTypeName = benchmarkDataTypeName,
                    MarketValueByPercentile = new List<MarketPercentileDto>{ new MarketPercentileDto { Percentile = 50, MarketValue = 10F } },
                    StandardJobCode = "3030"
                }
            };

            _marketPricingSheetRepository.Setup(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(marketPricingSheetList);
            _marketPricingSheetRepository.Setup(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>())).ReturnsAsync(adjustmentNotes);
            _marketPricingSheetRepository.Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                                         It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                                         .ReturnsAsync(surveyData);
            _marketPricingSheetRepository.Setup(x => x.ListExternalData(It.IsAny<int>())).ReturnsAsync(new List<MarketPricingSheetCutExternal>());
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _projectDetailsRepository.Setup(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(projectBenchmarkDataTypes);
            _marketSegmentRepository.Setup(x => x.ListMarketSegmentCutDetailsByMarketSegmentId(It.IsAny<int>())).ReturnsAsync(marketSegmentCutDetails);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes);

            #endregion

            #region Act

            var response = await _marketPricingSheetController.GetGridItemsForMarketPricingSheet(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var gridItemsResponse = response?.Value as List<MarketPricingSheetGridItemDto>;

            #endregion

            #region Assert

            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(gridItemsResponse);
            Assert.IsNotEmpty(gridItemsResponse);
            Assert.That(gridItemsResponse[0].SurveyKey, Is.EqualTo(surveyKey));
            Assert.That(gridItemsResponse[0].SurveyPublisherKey, Is.EqualTo(publisherKey));
            Assert.That(gridItemsResponse[0].IndustryKey, Is.EqualTo(industrySectorKey));
            Assert.That(gridItemsResponse[0].OrganizationTypeKey, Is.EqualTo(organizationTypeKey));
            Assert.That(gridItemsResponse[0].CutGroupKey, Is.EqualTo(cutGroupKey));
            Assert.That(gridItemsResponse[0].CutSubGroupKey, Is.EqualTo(cutSubGroupKey));
            Assert.That(gridItemsResponse[0].CutKey, Is.EqualTo(cutKey));
            Assert.IsNotEmpty(gridItemsResponse[0].Benchmarks);
            Assert.That(gridItemsResponse[0].Benchmarks.Count, Is.EqualTo(benchmarkDataTypes.Count));

            _marketPricingSheetRepository.Verify(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                                          It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()),
                                                      Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListExternalData(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.ListMarketSegmentCutDetailsByMarketSegmentId(It.IsAny<int>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());

            #endregion
        }

        [Test]
        public async Task GetGridItems_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var surveyKey = 1;
            var publisherKey = 2;
            var industrySectorKey = 3;
            var organizationTypeKey = 4;
            var cutGroupKey = 5;
            var cutSubGroupKey = 6;
            var cutKey = 7;
            var benchmarkDataTypeKey = 29;
            var benchmarkDataTypeName = "Base Pay Hourly Rate";
            var marketPricingSheet = new MarketPricingSheet { Id = marketPricingSheetId, MarketSegmentId = 10, StandardJobCode = "3030" };
            var projectVersionDetails = new ProjectVersionDto { Id = projectVersionId, SurveySourceGroupKey = 6 };
            var marketSegmentCutDetails = new List<MarketSegmentCutSurveyDetailDto>
            {
                new MarketSegmentCutSurveyDetailDto
                {
                    SurveyKey = surveyKey,
                    PublisherKey = publisherKey,
                    IndustrySectorKey = industrySectorKey,
                    OrganizationTypeKey = organizationTypeKey,
                    CutGroupKey = cutGroupKey,
                    CutSubGroupKey = cutSubGroupKey,
                    CutKey = cutKey,
                }
            };
            var benchmarkDataTypes = new List<BenchmarkDataTypeDto> { new() { Id = benchmarkDataTypeKey, Name = benchmarkDataTypeName } };
            var projectBenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto> { new() { BenchmarkDataTypeKey = benchmarkDataTypeKey } };
            var surveyData = new List<SurveyCutDataDto>
            {
                new SurveyCutDataDto
                {
                    SurveyKey = surveyKey,
                    SurveyPublisherKey = publisherKey,
                    IndustrySectorKey = industrySectorKey,
                    OrganizationTypeKey = organizationTypeKey,
                    CutGroupKey = cutGroupKey,
                    CutSubGroupKey = cutSubGroupKey,
                    CutKey = cutKey,
                    BenchmarkDataTypeKey = benchmarkDataTypeKey,
                    BenchmarkDataTypeName = benchmarkDataTypeName,
                    MarketValueByPercentile = new List<MarketPercentileDto>{ new MarketPercentileDto { Percentile = 50, MarketValue = 10F } },
                    StandardJobCode = "3030"
                }
            };

            _marketPricingSheetRepository.Setup(x => x.ListMarketPricingSheets(It.IsAny<int>())).ReturnsAsync(new List<MarketPricingSheet> { marketPricingSheet });
            _marketPricingSheetRepository.Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                                         It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                                         .ReturnsAsync(surveyData);
            _marketPricingSheetRepository.Setup(x => x.ListExternalData(It.IsAny<int>())).ReturnsAsync(new List<MarketPricingSheetCutExternal>());
            _marketPricingSheetRepository.Setup(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>())).ReturnsAsync(new List<MarketPricingSheetAdjustmentNoteDto>());
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _projectDetailsRepository.Setup(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(projectBenchmarkDataTypes);
            _marketSegmentRepository.Setup(x => x.ListMarketSegmentCutDetailsByMarketSegmentId(It.IsAny<int>())).ReturnsAsync(marketSegmentCutDetails);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes);

            #endregion

            #region Act

            var response = await _marketPricingSheetController.GetGridItems(projectVersionId) as OkObjectResult;
            var gridItemsResponse = response?.Value as List<MarketPricingSheetGridItemDto>;

            #endregion

            #region Assert

            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(gridItemsResponse);
            Assert.IsNotEmpty(gridItemsResponse);
            Assert.That(gridItemsResponse[0].SurveyKey, Is.EqualTo(surveyKey));
            Assert.That(gridItemsResponse[0].SurveyPublisherKey, Is.EqualTo(publisherKey));
            Assert.That(gridItemsResponse[0].IndustryKey, Is.EqualTo(industrySectorKey));
            Assert.That(gridItemsResponse[0].OrganizationTypeKey, Is.EqualTo(organizationTypeKey));
            Assert.That(gridItemsResponse[0].CutGroupKey, Is.EqualTo(cutGroupKey));
            Assert.That(gridItemsResponse[0].CutSubGroupKey, Is.EqualTo(cutSubGroupKey));
            Assert.That(gridItemsResponse[0].CutKey, Is.EqualTo(cutKey));
            Assert.IsNotEmpty(gridItemsResponse[0].Benchmarks);
            Assert.That(gridItemsResponse[0].Benchmarks.Count, Is.EqualTo(benchmarkDataTypes.Count));

            _marketPricingSheetRepository.Verify(x => x.ListMarketPricingSheets(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                                          It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()),
                                                      Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListExternalData(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.ListMarketSegmentCutDetailsByMarketSegmentId(It.IsAny<int>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());

            #endregion
        }

        [Test]
        public async Task GetBenchmarkDataTypes_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            var projectVersionDetails = new ProjectVersionDto { Id = projectVersionId, FileLogKey = 1, AggregationMethodologyKey = AggregationMethodology.Parent };

            var projectBenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto>() {
                new () {
                    BenchmarkDataTypeKey = 1,
                    OverrideAgingFactor =3.5f
                },
                new () {
                    BenchmarkDataTypeKey = 2,
                    OverrideAgingFactor = null
                }
            };
            var benchmarkDataTypes = new List<BenchmarkDataTypeDto>() {
                new ()
                {
                    Id = 1,
                    Name = "Benchmark data type 1",
                    AgingFactor = 1.2f
                },
                new ()
                {
                    Id = 2,
                    Name = "Benchmark data type 2",
                    AgingFactor = 3.1f
                }
            };

            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
            _projectDetailsRepository.Setup(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(projectBenchmarkDataTypes);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetBenchmarkDataTypes(projectVersionId) as OkObjectResult;
            var dataResponse = response?.Value as List<BenchmarkDataTypeDto>;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(dataResponse);
            Assert.That(dataResponse.Count, Is.EqualTo(benchmarkDataTypes.Count));
            Assert.That(dataResponse[0].Id, Is.EqualTo(benchmarkDataTypes[0].Id));
            Assert.That(dataResponse[0].Name, Is.EqualTo(benchmarkDataTypes[0].Name));
            Assert.That(dataResponse[0].AgingFactor, Is.EqualTo(projectBenchmarkDataTypes[0].OverrideAgingFactor));
            Assert.That(dataResponse[1].Id, Is.EqualTo(benchmarkDataTypes[1].Id));
            Assert.That(dataResponse[1].Name, Is.EqualTo(benchmarkDataTypes[1].Name));
            Assert.That(dataResponse[1].AgingFactor, Is.EqualTo(benchmarkDataTypes[1].AgingFactor));
            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task SaveNotes_Fail()
        {
            #region Arrange

            var projectVersionId = 0;
            var marketPricingSheetId = 0;

            #endregion

            #region Act

            var response = await _marketPricingSheetController.SaveNotes(projectVersionId, marketPricingSheetId, new NewStringValueDto()) as BadRequestResult;

            #endregion

            #region Assert

            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 400);

            #endregion
        }

        [Test]
        public async Task SaveNotes_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketPricingSheetId = 1;

            #endregion

            #region Act

            var response = await _marketPricingSheetController.SaveNotes(projectVersionId, marketPricingSheetId, new NewStringValueDto { Value = "Notes Test" }) as OkResult;

            #endregion

            #region Assert

            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            #endregion
        }

        [Test]
        public async Task GetNotes_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var notes = new NewStringValueDto { Value = "Test" };

            _marketPricingSheetRepository.Setup(x => x.GetNotes(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(notes);

            #endregion

            #region Act

            var response = await _marketPricingSheetController.GetNotes(projectVersionId, marketPricingSheetId) as OkObjectResult;
            var notesResponse = response?.Value as NewStringValueDto;

            #endregion

            #region Assert

            Assert.NotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.NotNull(notesResponse);
            Assert.That(notesResponse.Value, Is.EqualTo(notes.Value));

            #endregion
        }

        [Test]
        public async Task GetMarketSegmentReportFilter_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            var reportFilters = new List<string> { "Combined average one", "Cut One", "ERI cut name one" };

            _marketPricingSheetRepository.Setup(x => x.GetMarketSegmentReportFilter(It.IsAny<int>())).ReturnsAsync(reportFilters);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetMarketSegmentReportFilter(projectVersionId) as OkObjectResult;
            var reportFiltersResponse = response?.Value as List<string>;
            #endregion

            #region Assert
            Assert.NotNull(response);
            Assert.NotNull(reportFiltersResponse);
            Assert.IsNotEmpty(reportFiltersResponse);
            Assert.That(reportFiltersResponse.Count, Is.EqualTo(reportFilters.Count));
            _marketPricingSheetRepository.Verify(x => x.GetMarketSegmentReportFilter(It.IsAny<int>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task GetMainSettings_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            _marketPricingSheetRepository.Setup(x => x.GetMainSettings(It.IsAny<int>())).ReturnsAsync(_mainSettings);
            #endregion

            #region Act
            var response = await _marketPricingSheetController.GetMainSettings(projectVersionId) as OkObjectResult;
            var mainSettingsResponse = response?.Value as MainSettingsDto;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(mainSettingsResponse);
            Assert.That(mainSettingsResponse.Columns.Count, Is.EqualTo(_mainSettings.Columns.Count));
            Assert.That(mainSettingsResponse.Sections.Count, Is.EqualTo(_mainSettings.Sections.Count));
            Assert.That(mainSettingsResponse.Benchmarks.Count, Is.EqualTo(_mainSettings.Benchmarks.Count));
            Assert.That(mainSettingsResponse.Benchmarks[0].Title, Is.EqualTo(_mainSettings.Benchmarks[0].Title));
            Assert.That(mainSettingsResponse.Benchmarks[0].Percentiles.Count, Is.EqualTo(_mainSettings.Benchmarks[0].Percentiles.Count));
            Assert.That(mainSettingsResponse.Benchmarks[1].Title, Is.EqualTo(_mainSettings.Benchmarks[1].Title));
            Assert.That(mainSettingsResponse.Benchmarks[1].Percentiles.Count, Is.EqualTo(_mainSettings.Benchmarks[1].Percentiles.Count));
            _marketPricingSheetRepository.Verify(x => x.GetMainSettings(It.IsAny<int>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task SaveMainSettings_Success()
        {
            #region Arrange
            var projectVersionId = 1;
            _marketPricingSheetRepository.Setup(x => x.SaveMainSettings(It.IsAny<int>(), It.IsAny<MainSettingsDto>(), It.IsAny<string?>()));
            #endregion

            #region Act
            var response = await _marketPricingSheetController.SaveMainSettings(projectVersionId, _mainSettings) as OkResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            _marketPricingSheetRepository.Verify(x => x.SaveMainSettings(It.IsAny<int>(), It.IsAny<MainSettingsDto>(), It.IsAny<string?>()), Times.Once());
            #endregion
        }

        [Test]
        public async Task SaveGridItemsForMarketPricingSheet_Fail()
        {
            #region Arrange

            var projectVersionId = 0;
            var marketPricingSheetId = 0;
            var newItem = new SaveGridItemDto { };

            #endregion

            #region Act

            var response = await _marketPricingSheetController.SaveGridItemsForMarketPricingSheet(projectVersionId, marketPricingSheetId, newItem) as BadRequestResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);

            #endregion
        }

        [Test]
        public async Task SaveGridItemsForMarketPricingSheet_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketPricingSheetId = 1;
            var newItem = new SaveGridItemDto { MarketPricingSheetId = marketPricingSheetId, MarketSegmentCutDetailKey = 1 };

            _marketPricingSheetRepository.Setup(x => x.ListAdjustmentNotes(It.IsAny<int>(), It.IsAny<int?>(), It.IsAny<int?>())).ReturnsAsync(new List<MarketPricingSheetAdjustmentNoteDto>());
            _marketPricingSheetRepository.Setup(x => x.InsertAdjustmentNotes(It.IsAny<SaveGridItemDto>(), It.IsAny<string?>()));

            #endregion

            #region Act

            var response = await _marketPricingSheetController.SaveGridItemsForMarketPricingSheet(projectVersionId, marketPricingSheetId, newItem) as OkResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            _marketPricingSheetRepository.Verify(x => x.ListAdjustmentNotes(It.IsAny<int>(), It.IsAny<int?>(), It.IsAny<int?>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.InsertAdjustmentNotes(It.IsAny<SaveGridItemDto>(), It.IsAny<string?>()), Times.Once());

            #endregion
        }

        [Test]
        public async Task ExportPdf_Fail()
        {
            #region Arrange

            var projectVersionId = 0;

            #endregion

            #region Act

            var response = await _marketPricingSheetController.ExportPdf(projectVersionId, null) as BadRequestResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);

            #endregion
        }

        [Test]
        public async Task ExportPdf_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var marketSegmentId = 1;
            var file = new byte[0];
            var organizationKey = 90;
            var fileUploadResponse = new UploadMarketPricingSheetPdfFileDto { Success = true, Message = "Uploaded", FileS3Name = "FileName.pdf" };
            var projectDetails = new ProjectVersionDto { OrganizationKey = organizationKey };
            var marketPricingSheets = new List<MarketPricingSheet> { new MarketPricingSheet { ProjectVersionId = projectVersionId, MarketSegmentId = marketSegmentId, StandardJobCode = "0"} };
            var organizations = new List<OrganizationDto> { new OrganizationDto { Id = organizationKey, Name = "Organization Test" } };
            var marketSegments = new List<MarketSegmentDto> { new MarketSegmentDto { Id = marketSegmentId } };
            var surveyData = new List<SurveyCutDataDto>
            {
                new SurveyCutDataDto
                {
                    StandardJobCode = "0",
                    MarketValueByPercentile = new List<MarketPercentileDto>{ new MarketPercentileDto { Percentile = 50, MarketValue = 10F } }
                }
            };
            var adjustmentNotes = new List<MarketPricingSheetAdjustmentNoteDto>();
            var files = new List<FileLogDto>();
            var combinedAverages = new List<CombinedAveragesDto>();

            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectDetails);
            _marketPricingSheetRepository.Setup(x => x.GetMainSettings(It.IsAny<int>())).ReturnsAsync(_mainSettings);
            _marketPricingSheetRepository.Setup(x => x.GetGeneratedFile(It.IsAny<int>(), It.IsAny<int?>())).ReturnsAsync(null as UploadMarketPricingSheetPdfFileDto);
            _marketPricingSheetRepository.Setup(x => x.ListMarketPricingSheets(It.IsAny<int>())).ReturnsAsync(marketPricingSheets);
            _marketPricingSheetRepository.Setup(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>())).ReturnsAsync(adjustmentNotes);
            _marketPricingSheetRepository
                .Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(surveyData);
            _marketPricingSheetRepository.Setup(x => x.ListExternalData(It.IsAny<int>())).ReturnsAsync(new List<MarketPricingSheetCutExternal>());
            _projectRepository.Setup(x => x.GetOrganizationsByIds(It.IsAny<List<int>>())).ReturnsAsync(organizations);
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentsWithCuts(It.IsAny<int>(), It.IsAny<int?>())).ReturnsAsync(marketSegments);
            _fileRepository.Setup(x => x.GetFilesByIds(It.IsAny<List<int>>())).ReturnsAsync(files);
            _fileRepository.Setup(x => x.ConvertHtmlListToUniquePdfFile(It.IsAny<List<string>>())).ReturnsAsync(file);
            _fileRepository.Setup(x => x.UploadMarketPricingSheetPdfFile(It.IsAny<byte[]>(), It.IsAny<int>(), It.IsAny<int?>(), It.IsAny<int>(), It.IsAny<string>())).ReturnsAsync(fileUploadResponse);
            _combinedAveragesRepository.Setup(x => x.GetCombinedAveragesByProjectVersionId(It.IsAny<int>())).ReturnsAsync(combinedAverages);

            #endregion

            #region Act

            var response = await _marketPricingSheetController.ExportPdf(projectVersionId, null) as OkObjectResult;
            var exportPdfResponse = response?.Value as UploadMarketPricingSheetPdfFileDto;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(exportPdfResponse);
            Assert.That(exportPdfResponse.Success, Is.EqualTo(fileUploadResponse.Success));
            Assert.That(exportPdfResponse.Message, Is.EqualTo(fileUploadResponse.Message));
            Assert.That(exportPdfResponse.FileS3Name, Is.EqualTo(fileUploadResponse.FileS3Name));

            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.GetMainSettings(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.GetGeneratedFile(It.IsAny<int>(), It.IsAny<int?>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListMarketPricingSheets(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository.Verify(x => x.ListAdjustmentNotesByProjectVersionId(It.IsAny<int>()), Times.Once());
            _marketPricingSheetRepository
                .Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<int>>(), It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync(surveyData);
            _marketPricingSheetRepository.Verify(x => x.ListExternalData(It.IsAny<int>()), Times.Once());
            _projectRepository.Verify(x => x.GetOrganizationsByIds(It.IsAny<List<int>>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.GetMarketSegmentsWithCuts(It.IsAny<int>(), It.IsAny<int?>()), Times.Once());
            _fileRepository.Verify(x => x.GetFilesByIds(It.IsAny<List<int>>()), Times.Once());
            _fileRepository.Verify(x => x.ConvertHtmlListToUniquePdfFile(It.IsAny<List<string>>()), Times.Once());
            _fileRepository.Verify(x => x.UploadMarketPricingSheetPdfFile(It.IsAny<byte[]>(), It.IsAny<int>(), It.IsAny<int?>(), It.IsAny<int>(), It.IsAny<string>()), Times.Once());
            _combinedAveragesRepository.Verify(x => x.GetCombinedAveragesByProjectVersionId(It.IsAny<int>()), Times.Once());

            #endregion
        }

        [Test]
        public async Task SaveMarketPricingExternalData_Success()
        {
            #region Arrange

            var projectVersionId = 1;
            var cutExternalData = new List<MarketPricingSheetCutExternalDto>()
            {
                new ()
                {
                    MarketPricingSheetId = 1,
                    StandardJobCode = "2.52",
                    StandardJobTitle = "Job Title test",
                    ExternalPublisherName = "SullivanCotter",
                    ExternalSurveyName = "Survey name",
                    ExternalIndustrySectorName = "Industry 1",
                    ExternalOrganizationTypeName = "Organization Type name",
                    ExternalCutGroupName = "Group 1",
                    ExternalCutSubGroupName = "Sub Group 1",
                    ExternalMarketPricingCutName = "Cut name 1",
                    ExternalSurveyCutName = "Survey cut name 1",
                    IncumbentCount = 12,
                    BenchmarkDataTypeKey = 29,
                    BenchmarkDataTypeValue = 2.4f,
                    PercentileNumber = 30
                },
                new ()
                {
                    MarketPricingSheetId = 2,
                    StandardJobCode = "4.5",
                    StandardJobTitle = "Job Title test 2",
                    ExternalPublisherName = "SullivanCotter",
                    ExternalSurveyName = "Survey name 2",
                    ExternalIndustrySectorName = "Industry 2",
                    ExternalOrganizationTypeName = "Organization Type name 2",
                    ExternalCutGroupName = "Group 2",
                    ExternalCutSubGroupName = "Sub Group 2",
                    ExternalMarketPricingCutName = "Cut name 2",
                    ExternalSurveyCutName = "Survey cut name 2",
                    IncumbentCount = 45,
                    BenchmarkDataTypeKey = 44,
                    BenchmarkDataTypeValue = 3.1f,
                    PercentileNumber = 55
                }
            };

            _marketPricingSheetRepository.Setup(x => x.SaveMarketPricingExternalData(It.IsAny<int>(), It.IsAny<List<MarketPricingSheetCutExternalDto>>(), It.IsAny<string?>()));
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(new ProjectVersionDto { AggregationMethodologyKey = AggregationMethodology.Child });

            #endregion

            #region Act

            var response = await _marketPricingSheetController.SaveMarketPricingExternalData(projectVersionId, cutExternalData) as OkResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            _marketPricingSheetRepository.Verify(x => x.SaveMarketPricingExternalData(It.IsAny<int>(), It.IsAny<List<MarketPricingSheetCutExternalDto>>(), It.IsAny<string?>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());

            #endregion
        }

        #endregion

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
    }
}
