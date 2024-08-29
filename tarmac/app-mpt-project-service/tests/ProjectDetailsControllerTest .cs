using CN.Project.RestApi.Controllers;
using CN.Project.Domain.Dto;
using CN.Project.Domain.Enum;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repositories;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Services;
using FluentAssertions;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;
using System.Security.Claims;

namespace CN.Project.Test;

[TestFixture]
public class ProjectDetailsControllerTest
{
    private Mock<IProjectDetailsRepository> _projectDetailsRepository;
    private Mock<IProjectRepository> _projectRepository;
    private Mock<IFileRepository> _fileRepository;
    private Mock<IBenchmarkDataRepository> _benchmarkDataRepository;
    private ProjectDetailsController _projectDetailsController;
    private ProjectDetailsDto _projectDetails;
    private ProjectDetailsViewDto _projectDetailsView;
    private ProjectDetailsService _projectDetailsService;
    private BenchmarkDataService _benchmarkDataService;
    private List<BenchmarkDataTypeDto> _benchmarks;
    private Mock<ILogger<ProjectDetailsService>> _logger;

    private List<Claim> _claims;

    [SetUp]
    public void Setup()
    {
        _claims = new List<Claim>()
        {
            new Claim(ClaimTypes.Role, "WRITE"),
            new Claim(ClaimTypes.Name, "TestUser")
        };

        _logger = new Mock<ILogger<ProjectDetailsService>>();
        _projectDetailsRepository = new Mock<IProjectDetailsRepository>();
        _projectRepository = new Mock<IProjectRepository>();
        _fileRepository = new Mock<IFileRepository>();
        _benchmarkDataRepository = new Mock<IBenchmarkDataRepository>();
        _projectDetailsService = new ProjectDetailsService(_projectRepository.Object, _projectDetailsRepository.Object, _logger.Object);
        _benchmarkDataService = new BenchmarkDataService(_benchmarkDataRepository.Object);
        _projectDetailsController = new ProjectDetailsController(_projectDetailsRepository.Object, _fileRepository.Object, _projectDetailsService, _benchmarkDataService);
        _projectDetailsController.ControllerContext = GetControllerContext();

        _projectDetails = new()
        {
            ID = 1,
            OrganizationID = 2,
            Name = "Project 1",
            Version = 1,
            VersionLabel = "Version 1",
            ProjectStatus = 1,
            SourceDataInfo = new SourceDataInfoDto
            {
                EffectiveDate = System.DateTime.UtcNow,
                SourceData = "Incumbent"
            }
        };

        _projectDetailsView = new()
        {
            ID = 1,
            OrganizationID = 2,
            Name = "Project 1",
            Version = 1,
            VersionLabel = "Version 1",
            ProjectStatus = 1,
            SourceDataInfo = new SourceDataInfoDto
            {
                EffectiveDate = System.DateTime.UtcNow,
                SourceData = "Incumbent"
            }
        };

        _benchmarks = new List<BenchmarkDataTypeDto>()
        {
            new ()
            {
                    Id = 29,
                    Name =  "Base Pay Hourly Rate",
                    AgingFactor = 3,
                    DefaultDataType = false,
                    LongAlias = "Hourly Base Pay",
                    ShortAlias = "Base",
                    OrderDataType = 1,
                    Format = "$",
                    Decimals = 2
            },
            new ()
            {
                Id = 1,
                Name =  "Annualized Base Salary",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Base Pay",
                ShortAlias = "Base",
                OrderDataType = 2,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 45,
                Name =  "Pay Range Minimum",
                AgingFactor = 2,
                DefaultDataType = false,
                LongAlias = "Hourly Pay Range Minimum",
                ShortAlias = "Min",
                OrderDataType = 3,
                Format = "$",
                Decimals = 2
            },
            new ()
            {
                Id = 78,
                Name =  "Hourly Pay Range Midpoint",
                AgingFactor = 2,
                DefaultDataType = false,
                LongAlias = "Hourly Pay Range Midpoint",
                ShortAlias = "Mid",
                OrderDataType = 4,
                Format = "$",
                Decimals = 2
            },
            new ()
            {
                Id = 44,
                Name =  "Pay Range Maximum",
                AgingFactor = 1.2345F,
                DefaultDataType = true,
                LongAlias = "Hourly Pay Range Maximum",
                ShortAlias = "Max",
                OrderDataType = 5,
                Format = "$",
                Decimals = 2
            },
            new ()
            {
                Id = 79,
                Name =  "Annual Pay Range Minimum",
                AgingFactor = 2,
                DefaultDataType = true,
                LongAlias = "Annual Pay Range Minimum",
                ShortAlias = "Min",
                OrderDataType = 6,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 80,
                Name =  "Annual Pay Range Midpoint",
                AgingFactor = 2,
                DefaultDataType = false,
                LongAlias = "Annual Pay Range Midpoint",
                ShortAlias = "Mid",
                OrderDataType = 7,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 81,
                Name =  "Annual Pay Range Maximum",
                AgingFactor = 2,
                DefaultDataType = false,
                LongAlias = "Annual Pay Range Maximum",
                ShortAlias = "Max",
                OrderDataType = 8,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 82,
                Name =  "Actual Annual Incentive",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Incentive Pay ($)",
                ShortAlias = "Incentive ($)",
                OrderDataType = 9,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 84,
                Name =  "Target Annual Incentive",
                AgingFactor = 0,
                DefaultDataType = true,
                LongAlias = "Annual Incentive Pay Target ($)",
                ShortAlias = "Target IP ($)",
                OrderDataType = 11,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 42,
                Name =  "Target Incentive Percentage",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Incentive Pay Target (%)",
                ShortAlias = "Target IP (%)",
                OrderDataType = 12,
                Format = "%",
                Decimals = 2
            },
            new ()
            {
                Id = 85,
                Name =  "Annual Incentive Threshold Opportunity",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Incentive Pay Threshold ($)",
                ShortAlias = "Threshold IP ($)",
                OrderDataType = 13,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 87,
                Name =  "Annual Incentive Maximum Opportunity",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Incentive Pay Maximum ($)",
                ShortAlias = "Maximum IP ($)",
                OrderDataType = 15,
                Format = "$",
                Decimals = 0
            },
            new ()
            {
                Id = 65,
                Name =  "TCC - Hourly",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Hourly Total Cash Compensation",
                ShortAlias = "TCC",
                OrderDataType = 17,
                Format = "$",
                Decimals = 2
            },
            new ()
            {
                Id = 2,
                Name =  "TCC",
                AgingFactor = 0,
                DefaultDataType = false,
                LongAlias = "Annual Total Cash Compensation",
                ShortAlias = "TCC",
                OrderDataType = 18,
                Format = "$",
                Decimals = 0
            }
        };

        _projectDetailsRepository.Setup(x => x.GetProjetDetails(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(_projectDetailsView);
        _projectRepository.Setup(x => x.GetOrganizationsByIds(It.IsAny<List<int>>())).ReturnsAsync(new List<OrganizationDto>());
        _benchmarkDataRepository.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(_benchmarks);
        _benchmarkDataRepository.Setup(x => x.ListBenchmarksFromReferenceTable()).ReturnsAsync(_benchmarks);
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
    public async Task GetProjectDetailsByProjectId_ProjectExists()
    {
        var projectId = 1;
        var projectVersionId = 1;

        var response = await _projectDetailsController.GetProjectDetails(projectId, projectVersionId) as OkObjectResult;
        var projectResponse = response?.Value as ProjectDetailsViewDto;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(projectResponse);

        projectResponse.Should().BeEquivalentTo(_projectDetailsView);
    }

    [Test]
    public async Task SaveProjectDetails_Success()
    {
        var projectId = 1;
        var projectVersionId = 1;
        _projectDetailsRepository.Setup(x => x.SaveProjetDetails(It.IsAny<ProjectDetailsDto>(), It.IsAny<string>(), It.IsAny<bool>()))
            .ReturnsAsync(new ProjectDetailsDto { ID = projectId, Version = projectVersionId, SourceDataInfo = new SourceDataInfoDto() });

        var response = await _projectDetailsController.SaveProjectDetails(_projectDetails) as OkObjectResult;
        var projectResponse = response?.Value as ProjectDetailsViewDto;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        projectResponse.Should().BeEquivalentTo(_projectDetailsView);
    }

    [Test]
    public async Task SaveProjectDetails_NoSuccess_InvalidOverrideAgingFactor()
    {
        var projectId = 1;
        var projectDetails = new ProjectDetailsDto()
        {
            ID = projectId,
            OrganizationID = 2,
            Name = "Project 1",
            VersionLabel = "Version 1",
            Version = 1,
            ProjectStatus = 1,
            SourceDataInfo = new SourceDataInfoDto
            {
                EffectiveDate = System.DateTime.UtcNow,
                SourceData = "Incumbent"
            },
            BenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto>() {
                new () {
                    ID = 1,
                    OverrideAgingFactor= 100,
                    OverrideNote = "Note 2"
                }
            }
        };

        _projectDetailsRepository.Setup(x => x.SaveProjetDetails(It.IsAny<ProjectDetailsDto>(), It.IsAny<string>(), It.IsAny<bool>())).ReturnsAsync(projectDetails);

        var response = await _projectDetailsController.SaveProjectDetails(projectDetails) as BadRequestObjectResult;
        var errorMessage = response?.Value as string;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsNotNull(errorMessage);
        Assert.IsTrue(response.StatusCode == 400);
        Assert.That(errorMessage, Is.EqualTo("Please verify the Benchmark data types values: The override aging factor must be between 0 and 99.99."));
    }

    [Test]
    public async Task SaveProjectDetails_NoSuccess_RequiredOverrideNote()
    {
        var projectId = 1;
        var projectDetails = new ProjectDetailsDto()
        {
            ID = projectId,
            OrganizationID = 2,
            Name = "Project 1",
            VersionLabel = "Version 1",
            Version = 1,
            ProjectStatus = 1,
            SourceDataInfo = new SourceDataInfoDto
            {
                EffectiveDate = DateTime.UtcNow,
                SourceData = "Incumbent"
            },
            BenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto>() {
                new () {
                    ID = 1,
                    OverrideAgingFactor= 99.99f,
                }
            }
        };

        _projectDetailsRepository.Setup(x => x.SaveProjetDetails(It.IsAny<ProjectDetailsDto>(), It.IsAny<string>(), It.IsAny<bool>())).ReturnsAsync(projectDetails);

        var response = await _projectDetailsController.SaveProjectDetails(projectDetails) as BadRequestObjectResult;
        var errorMessage = response?.Value as string;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsNotNull(errorMessage);
        Assert.IsTrue(response.StatusCode == 400);
        Assert.That(errorMessage, Is.EqualTo("Please verify the Benchmark data types values: An override note is required when the override aging factor is updated."));
    }

    [Test]
    public async Task UpdateProjectDetails_Success()
    {
        _projectDetails.VersionLabel = "Updated Label";

        var response = await _projectDetailsController.UpdateProjectDetails(_projectDetails.ID, _projectDetails.Version, _projectDetails) as OkObjectResult;
        var projectResponse = response?.Value as ProjectDetailsViewDto;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        projectResponse.Should().BeEquivalentTo(_projectDetailsView);
    }

    [Test]
    public async Task InsertMarketPricingSheetRows_Success()
    {
        var projectVersionDetails = new List<ProjectVersionDto>()
        {
            new ()
            {
                AggregationMethodologyKey = AggregationMethodology.Child,
                FileLogKey = 1,
                Id = 1,
            }
        };

        var clientJobs = new List<MarketPricingSheetDto>()
        {
            new ()
            {
                AggregationMethodKey = 2,
                FileOrgKey = 90,
                JobCode = "2.01",
                JobTitle = "Product Owner",
                JobGroup = "Group 1",
                PositionCode = ""
            },
            new ()
            {
                AggregationMethodKey = 2,
                FileOrgKey = 90,
                JobCode = "3.01",
                JobTitle = "Software Developer",
                JobGroup = "Group 1",
                PositionCode = "001"
            }
        };

        _projectRepository.Setup(x => x.GetProjectVersionsByFileLogKey(It.IsAny<int>())).ReturnsAsync(projectVersionDetails);
        _projectDetailsRepository.Setup(x => x.ListClientJobs(It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(clientJobs);
        _projectDetailsRepository.Setup(x => x.InsertMarketPricingSheetRows(It.IsAny<int>(), It.IsAny<List<ProjectVersionDto>>(), It.IsAny<List<MarketPricingSheetDto>>(), It.IsAny<string?>()));

        var fileLogKey = 1;
        var response = await _projectDetailsController.InsertMarketPricingSheetRows(fileLogKey) as OkObjectResult;

        //Assert
        _projectRepository.Verify(x => x.GetProjectVersionsByFileLogKey(It.IsAny<int>()), Times.Once());
        _projectDetailsRepository.Verify(x => x.ListClientJobs(It.IsAny<int>(), It.IsAny<int>()), Times.Once());
        _projectDetailsRepository.Verify(x => x.InsertMarketPricingSheetRows(It.IsAny<int>(), It.IsAny<List<ProjectVersionDto>>(), It.IsAny<List<MarketPricingSheetDto>>(), It.IsAny<string?>()));
    }

    [Test]
    public async Task GetBenchmarkDataTypes_Success()
    {
        var response = await _projectDetailsController.GetBenchmarkDataTypes(6) as OkObjectResult;
        var benchmarkListResponse = response?.Value as List<BenchmarkDataTypeDto>;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        benchmarkListResponse.Should().BeEquivalentTo(_benchmarks);
    }
}