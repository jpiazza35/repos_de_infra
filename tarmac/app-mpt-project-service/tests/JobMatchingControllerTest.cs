using CN.Project.Domain.Dto;
using CN.Project.Domain.Enum;
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
    public class JobMatchingControllerTest
    {
        private JobMatchingController _jobMatchingController;
        private JobMatchingService _jobMatchingService;

        private Mock<IJobMatchingRepository> _jobMatchingRepository;
        private Mock<IProjectRepository> _projectRepository;
        private Mock<IMarketSegmentMappingRepository> _marketSegmentMappingRepository;
        private Mock<IMarketSegmentRepository> _marketSegmentRepository;
        private Mock<IProjectDetailsRepository> _projectDetailsRepository;
        private Mock<IBenchmarkDataService> _benchmarkDataService;

        private List<Claim> _claims;

        [SetUp]
        public void Setup()
        {
            _claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Role, "WRITE"),
                new Claim(ClaimTypes.Name, "TestUser")
            };

            _jobMatchingRepository = new Mock<IJobMatchingRepository>();
            _projectRepository = new Mock<IProjectRepository>();
            _marketSegmentMappingRepository = new Mock<IMarketSegmentMappingRepository>();
            _marketSegmentRepository = new Mock<IMarketSegmentRepository>();
            _projectDetailsRepository = new Mock<IProjectDetailsRepository>();
            _benchmarkDataService = new Mock<IBenchmarkDataService>();

            _jobMatchingService = new JobMatchingService(_jobMatchingRepository.Object,
                                                         _projectRepository.Object,
                                                         _marketSegmentMappingRepository.Object,
                                                         _marketSegmentRepository.Object,
                                                         _projectDetailsRepository.Object,
                                                         _benchmarkDataService.Object);

            _jobMatchingController = new JobMatchingController(_jobMatchingService);
            _jobMatchingController.ControllerContext = GetControllerContext();
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
        public async Task SaveMarketSegmentMapping_Success()
        {
            var jobMatchingStatusUpdate = new List<JobMatchingStatusUpdateDto>()
            {
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 01"
                },
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 02"
                }
            };

            var status_draft = 1;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_draft);
            _jobMatchingRepository.Setup(x => x.SaveJobMatchingStatus(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<JobMatchingStatusUpdateDto>(), It.IsAny<string>()));

            var projectVersionId = 1;
            var jobMatchStatusKey = 1;
            var response = await _jobMatchingController.SaveJobMatchingStatus(projectVersionId, jobMatchStatusKey, jobMatchingStatusUpdate) as OkObjectResult;

            //Assert
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.SaveJobMatchingStatus(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<JobMatchingStatusUpdateDto>(), It.IsAny<string>()), Times.Exactly(2));
        }

        [Test]
        public async Task SaveMarketSegmentMapping_Status_Not_Editable()
        {
            var jobMatchingStatusUpdate = new List<JobMatchingStatusUpdateDto>()
            {
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 01"
                }
            };

            var status_final = 2;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_final);
            _jobMatchingRepository.Setup(x => x.SaveJobMatchingStatus(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<JobMatchingStatusUpdateDto>(), It.IsAny<string>()));

            var projectVersionId = 1;
            var jobMatchStatusKey = 1;
            var response = await _jobMatchingController.SaveJobMatchingStatus(projectVersionId, jobMatchStatusKey, jobMatchingStatusUpdate) as BadRequestObjectResult;
            var errorMessage = response?.Value as string;

            //Assert
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            Assert.IsNotNull(response);
            Assert.IsNotNull(errorMessage);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(errorMessage, Is.EqualTo("Project status prevents fields from being edited."));
        }

        [Test]
        public async Task GetJobInfoAndStandardMatchedJobs_For_Selected_Jobs()
        {
            var selectedJobs = new List<JobMatchingStatusUpdateDto>()
            {
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 01"
                },
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 02"
                }
            };

            var standardJobsMatching = new List<StandardJobMatchingDto>()
            {
                new ()
                {
                    StandardJobCode = "Job 01",
                    BlendNote = "Blend Note",
                    BlendPercent = 3.5f,
                    StandardJobTitle = "Job 01 Title",
                    StandardJobDescription = "Job 01 Description"
                },
                new ()
                {
                    StandardJobCode = "Job 02",
                    BlendNote = "Blend Note",
                    BlendPercent = 3.5f,
                    StandardJobTitle = "Job 02 Title",
                    StandardJobDescription = "Job 02 Description"
                }
            };

            var jobMatchingInfo = new JobMatchingInfo()
            {
                JobCode = "Market pricing job code 01",
                JobTitle = "Market pricing job title",
                JobDescription = "Market pricing job description",
                JobMatchNote = "Note one",
                JobMatchStatusKey = 2,
                JobMatchStatusName = "Analyst Reviewed",
                PublisherName = "Standard",
                PublisherKey = 1
            };

            var projectVersionId = 1;
            _jobMatchingRepository.Setup(x => x.GetStandardMatchedJobs(It.IsAny<int>(), It.IsAny<List<JobMatchingStatusUpdateDto>>())).ReturnsAsync(standardJobsMatching);
            _jobMatchingRepository.Setup(x => x.GetMarketPricingJobInfo(It.IsAny<int>(), It.IsAny<List<JobMatchingStatusUpdateDto>>())).ReturnsAsync(jobMatchingInfo);

            var response = await _jobMatchingController.GetMarketPricingJobInfo(projectVersionId, selectedJobs) as OkObjectResult;
            var jobInfo = response?.Value as JobMatchingInfo;
            var standardJobsResult = jobInfo?.StandardJobs;

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(jobInfo);
            Assert.IsNotNull(standardJobsResult);
            Assert.That(jobInfo.JobCode, Is.EqualTo(jobMatchingInfo.JobCode));
            Assert.That(jobInfo.JobTitle, Is.EqualTo(jobMatchingInfo.JobTitle));
            Assert.That(jobInfo.JobDescription, Is.EqualTo(jobMatchingInfo.JobDescription));
            Assert.That(jobInfo.JobMatchNote, Is.EqualTo(jobMatchingInfo.JobMatchNote));
            Assert.That(jobInfo.JobMatchStatusKey, Is.EqualTo(jobMatchingInfo.JobMatchStatusKey));
            Assert.That(jobInfo.JobMatchStatusName, Is.EqualTo(jobMatchingInfo.JobMatchStatusName));
            Assert.That(jobInfo.PublisherName, Is.EqualTo(jobMatchingInfo.PublisherName));
            Assert.That(jobInfo.PublisherKey, Is.EqualTo(jobMatchingInfo.PublisherKey));
            Assert.That(standardJobsResult.Count, Is.EqualTo(2));
            Assert.That(standardJobsResult[0].StandardJobCode, Is.EqualTo(standardJobsMatching[0].StandardJobCode));
            Assert.That(standardJobsResult[0].StandardJobTitle, Is.EqualTo(standardJobsMatching[0].StandardJobTitle));
            Assert.That(standardJobsResult[0].BlendNote, Is.EqualTo(standardJobsMatching[0].BlendNote));
            Assert.That(standardJobsResult[0].BlendPercent, Is.EqualTo(standardJobsMatching[0].BlendPercent));
            Assert.That(standardJobsResult[1].StandardJobCode, Is.EqualTo(standardJobsMatching[1].StandardJobCode));
            Assert.That(standardJobsResult[1].StandardJobTitle, Is.EqualTo(standardJobsMatching[1].StandardJobTitle));
            Assert.That(standardJobsResult[1].BlendNote, Is.EqualTo(standardJobsMatching[1].BlendNote));
            Assert.That(standardJobsResult[1].BlendPercent, Is.EqualTo(standardJobsMatching[1].BlendPercent));
            _jobMatchingRepository.Verify(x => x.GetStandardMatchedJobs(It.IsAny<int>(), It.IsAny<List<JobMatchingStatusUpdateDto>>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.GetMarketPricingJobInfo(It.IsAny<int>(), It.IsAny<List<JobMatchingStatusUpdateDto>>()), Times.Once());
        }

        [Test]
        public async Task SaveClientJobsMatching_Success()
        {
            //Arrange
            var selectedJobs = new List<JobMatchingStatusUpdateDto>()
            {
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 01"
                },
                new ()
                {
                    AggregationMethodKey = 1,
                    FileOrgKey = 90,
                    JobCode = "Job 01",
                    PositionCode = "Position 02"
                }
            };

            var standardJobsMatching = new List<StandardJobMatchingDto>()
            {
                new ()
                {
                    StandardJobCode = "Job 01",
                    BlendNote = "Blend Note",
                    BlendPercent = 3.5f,
                    StandardJobTitle = "Job 01 Title",
                    StandardJobDescription = "Job 01 Description"
                },
                new ()
                {
                    StandardJobCode = "Job 02",
                    BlendNote = "Blend Note",
                    BlendPercent = 3.5f,
                    StandardJobTitle = "Job 02 Title",
                    StandardJobDescription = "Job 02 Description"
                }
            };

            var jobMatchingData = new JobMatchingSaveData();
            jobMatchingData.MarketPricingJobCode = "MP blend code";
            jobMatchingData.MarketPricingJobTitle = "MP blend title";
            jobMatchingData.MarketPricingJobDescription = "MP blend description";
            jobMatchingData.JobMatchStatusKey = 8;
            jobMatchingData.JobMatchNote = "MP note";
            jobMatchingData.PublisherName = "SullivanCotter";
            jobMatchingData.PublisherKey = 1;

            jobMatchingData.SelectedJobs = selectedJobs;
            jobMatchingData.StandardJobs = standardJobsMatching;

            var status_draft = 1;
            var projectVersionId = 1;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_draft);
            _jobMatchingRepository.Setup(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()));

            var response = await _jobMatchingController.SaveClientJobsMatching(projectVersionId, jobMatchingData) as OkObjectResult;

            //Assert
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()), Times.Once);
        }

        [Test]
        public async Task SaveClientJobsMatching_Status_Not_Editable()
        {
            //Arrange
            var jobMatchingData = new JobMatchingSaveData();
            jobMatchingData.SelectedJobs = new List<JobMatchingStatusUpdateDto>();
            jobMatchingData.StandardJobs = new List<StandardJobMatchingDto>();

            var status_final = 2;
            var projectVersionId = 1;
            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_final);
            _jobMatchingRepository.Setup(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()));

            var response = await _jobMatchingController.SaveClientJobsMatching(projectVersionId, jobMatchingData) as BadRequestObjectResult;
            var errorMessage = response?.Value as string;

            //Assert
            Assert.That(response, Is.Not.Null);
            Assert.That(response.StatusCode, Is.EqualTo(400));
            Assert.That(errorMessage, Is.Not.Null);
            Assert.That(errorMessage, Is.EqualTo("Project status prevents fields from being edited."));
            _projectRepository.Verify(x => x.GetProjectVersionStatus(It.IsAny<int>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()), Times.Never);
        }

        [Test]
        public async Task GetAuditCalculations_Fail()
        {
            var projectVersionId = 0;
            var request = new AuditCalculationRequestDto();

            var response = await _jobMatchingController.GetAuditCalculations(projectVersionId, request) as BadRequestResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
        }

        [Test]
        public async Task GetAuditCalculations_Success()
        {
            var projectVersionDetail = new ProjectVersionDto { FileLogKey = 1, AggregationMethodologyKey = AggregationMethodology.Parent };
            var marketPricingSheetList = new List<MarketPricingSheet> { new MarketPricingSheet { MarketSegmentId = 1 } };
            var benchmarkDataTypes = new List<BenchmarkDataTypeDto>
            {
                new () { Id = 1, Name = "Annualized Base Salary" },
                new () { Id = 29, Name = "Base Pay Hourly Rate" }
            };
            var clientBasePayList = new List<ClientPayDto>
            {
                //Annual
                new ClientPayDto
                {
                    BenchmarkDataTypeKey = 1,
                    BenchmarkDataTypeValue = 60000
                },
                new ClientPayDto
                {
                    BenchmarkDataTypeKey = 1,
                    BenchmarkDataTypeValue = 80000
                },
                //Hour
                new ClientPayDto
                {
                    BenchmarkDataTypeKey = 29,
                    BenchmarkDataTypeValue = 50
                },
                new ClientPayDto
                {
                    BenchmarkDataTypeKey = 29,
                    BenchmarkDataTypeValue = 30
                }
            };
            var cutGroupKey = new NameKeyDto { Keys = new List<int> { 3 }, Name = Domain.Constants.Constants.NATIONAL_GROUP_NAME };
            var marketSegmentCuts = new List<MarketSegmentCutDto> { new MarketSegmentCutDto { CutGroupKey = cutGroupKey.Keys.First() } };
            var surveyCut = new SurveyCutDto { CutGroups = new List<NameKeyDto> { cutGroupKey } };
            var percentileList = new List<MarketPercentileDto>
            {
                new MarketPercentileDto { Percentile = 10, MarketValue = 32F },
                new MarketPercentileDto { Percentile = 50, MarketValue = 42F },
                new MarketPercentileDto { Percentile = 90, MarketValue = 49F },
            };

            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersionDetail);
            _projectDetailsRepository.Setup(x => x.GetBenchmarkDataTypeKeys(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes.Select(b => b.Id).ToList());
            _marketSegmentMappingRepository.Setup(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(marketPricingSheetList);
            _benchmarkDataService.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(benchmarkDataTypes);
            _jobMatchingRepository.Setup(x => x.ListClientBasePay(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<int>>()))
                .ReturnsAsync(clientBasePayList);
            _jobMatchingRepository.Setup(x => x.ListPercentiles(It.IsAny<IEnumerable<string>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>()))
                .ReturnsAsync(percentileList);
            _marketSegmentRepository.Setup(x => x.ListMarketSegmentCuts(It.IsAny<IEnumerable<int>>())).ReturnsAsync(marketSegmentCuts);
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(surveyCut);

            var projectVersionId = 1;
            var request = new AuditCalculationRequestDto { StandardJobCodes = new List<string> { "3030" }, ClientJobCodes = new List<string> { "2.52" } };
            var response = await _jobMatchingController.GetAuditCalculations(projectVersionId, request) as OkObjectResult;
            var auditCalculationResponse = response?.Value as AuditCalculationDto;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsNotNull(auditCalculationResponse);
            Assert.IsNotNull(auditCalculationResponse.Annual);
            Assert.IsNotNull(auditCalculationResponse.Hourly);

            _projectDetailsRepository.Verify(x => x.GetProjectVersionDetails(It.IsAny<int>()), Times.Once());
            _projectDetailsRepository.Verify(x => x.GetBenchmarkDataTypeKeys(It.IsAny<int>()), Times.Once());
            _marketSegmentMappingRepository.Verify(x => x.GetMarketPricingSheet(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
            _benchmarkDataService.Verify(x => x.GetBenchmarkDataTypes(It.IsAny<int>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.ListClientBasePay(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<int>>()), Times.Once());
            _jobMatchingRepository.Verify(x => x.ListPercentiles(It.IsAny<IEnumerable<string>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>(),
                                                                It.IsAny<IEnumerable<int>>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.ListMarketSegmentCuts(It.IsAny<IEnumerable<int>>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>()), Times.Once());
        }

        [Test]
        public async Task CheckEditionForSelectedJobs_Fail()
        {
            var projectVersionId = 0;

            var response = await _jobMatchingController.CheckEditionForSelectedJobs(projectVersionId, new JobMatchingSaveData()) as BadRequestResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
        }

        [Test]
        public async Task CheckEditionForSelectedJobs_Success()
        {
            var projectVersionId = 1;
            var jobMacthing = new JobMatchingSaveData
            {
                SelectedJobs = new List<JobMatchingStatusUpdateDto>
                {
                    new JobMatchingStatusUpdateDto (),
                    new JobMatchingStatusUpdateDto (),
                    new JobMatchingStatusUpdateDto (),
                }
            };
            var standardMatchedJobs = new List<StandardJobMatchingDto>
            {
                new StandardJobMatchingDto{ StandardJobCode = "3030" },
                new StandardJobMatchingDto{ StandardJobCode = "JC02" },
            };
            var savedData = new JobMatchingSaveData { StandardJobs = standardMatchedJobs };

            _jobMatchingRepository.SetupSequence(x => x.GetJobMatchingSavedData(It.IsAny<int>(), It.IsAny<JobMatchingStatusUpdateDto>()))
                .ReturnsAsync(savedData)
                .ReturnsAsync(savedData)
                .ReturnsAsync(savedData);

            var response = await _jobMatchingController.CheckEditionForSelectedJobs(projectVersionId, jobMacthing) as OkObjectResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            _jobMatchingRepository.Verify(x => x.GetJobMatchingSavedData(It.IsAny<int>(), It.IsAny<JobMatchingStatusUpdateDto>()), Times.Exactly(3));
        }

        [Test]
        public async Task SaveBulkClientJobsMatching_Success()
        {
            #region Arrange
            var status_draft = 1;
            var projectVersionId = 1;
            var data = new List<JobMatchingSaveBulkDataDto>
            {
                new JobMatchingSaveBulkDataDto
                {
                    SelectedJobCode = "Job 01",
                    SelectedPositionCode = "Position 01",
                    StandardJobCode = "Job 01",
                    JobMatchNote = "Note 01"
                },
                new JobMatchingSaveBulkDataDto
                {
                    SelectedJobCode = "Job 02",
                    SelectedPositionCode = "Position 02",
                    StandardJobCode = "Job 02",
                    JobMatchNote = "Note 02"
                }
            };

            var survey = new List<StandardJobMatchingDto>
            {
                new StandardJobMatchingDto
                {
                    StandardJobCode = "Job 01",
                    StandardJobTitle = "Title 01",
                    StandardJobDescription = "Description 01"
                },
                new StandardJobMatchingDto
                {
                    StandardJobCode = "Job 02",
                    StandardJobTitle = "Title 02",
                    StandardJobDescription = "Description 02"
                }
            };

            var projectVersion = new ProjectVersionDto
            {
                AggregationMethodologyKey = AggregationMethodology.Parent,
                OrganizationKey = 1,
            };

            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_draft);
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersion);
            _jobMatchingRepository.Setup(x => x.ListSurveyCutsDataJobs(It.IsAny<List<string>>())).ReturnsAsync(survey);
            _jobMatchingRepository.Setup(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()));
            #endregion

            #region Act
            var response = await _jobMatchingController.SaveBulkClientJobsMatching(projectVersionId, data) as OkResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.That(_projectRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_projectDetailsRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_jobMatchingRepository.Invocations.Count, Is.EqualTo(3));
            #endregion
        }

        [Test]
        public async Task SaveBulkClientJobsMatching_Fail()
        {
            #region Arrange
            var status_draft = 1;
            var projectVersionId = 1;
            var data = new List<JobMatchingSaveBulkDataDto>
            {
                new JobMatchingSaveBulkDataDto
                {
                    SelectedJobCode = "Job 01",
                    SelectedPositionCode = "Position 01",
                    StandardJobCode = "Job 01",
                    JobMatchNote = "Note 01"
                },
                new JobMatchingSaveBulkDataDto
                {
                    SelectedJobCode = "Job 02",
                    SelectedPositionCode = "Position 02",
                    StandardJobCode = "Job 02",
                    JobMatchNote = "Note 02"
                }
            };

            var survey = new List<StandardJobMatchingDto>
            {
                new StandardJobMatchingDto
                {
                    StandardJobCode = "Job 03",
                    StandardJobTitle = "Title 01",
                    StandardJobDescription = "Description 01"
                },
                new StandardJobMatchingDto
                {
                    StandardJobCode = "Job 04",
                    StandardJobTitle = "Title 02",
                    StandardJobDescription = "Description 02"
                }
            };

            var projectVersion = new ProjectVersionDto
            {
                AggregationMethodologyKey = AggregationMethodology.Parent,
                OrganizationKey = 1,
            };

            _projectRepository.Setup(x => x.GetProjectVersionStatus(It.IsAny<int>())).ReturnsAsync(status_draft);
            _projectDetailsRepository.Setup(x => x.GetProjectVersionDetails(It.IsAny<int>())).ReturnsAsync(projectVersion);
            _jobMatchingRepository.Setup(x => x.ListSurveyCutsDataJobs(It.IsAny<List<string>>())).ReturnsAsync(survey);
            _jobMatchingRepository.Setup(x => x.SaveClientJobsMatching(It.IsAny<int>(), It.IsAny<JobMatchingSaveData>(), It.IsAny<string>()));
            #endregion

            #region Act
            var response = await _jobMatchingController.SaveBulkClientJobsMatching(projectVersionId, data) as BadRequestObjectResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(response.Value, Is.EqualTo("The following job codes are invalid: Job 01, Job 02."));
            #endregion
        }
    }
}
