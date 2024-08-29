using CN.Project.RestApi.Controllers;
using CN.Project.RestApi.Services;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Dto;
using CN.Project.Infrastructure.Repository;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace CN.Project.Test;

[TestFixture]
public class ProjectControllerTest
{
    private Mock<IProjectRepository> _projectRepository;
    private Mock<IMarketSegmentRepository> _marketSegmentRepository;
    private Mock<ICombinedAveragesRepository> _combinedAveragesRepository;
    private Mock<IFileRepository> _fileRepository;
    private ProjectController _projectController;
    private List<ProjectDto> _projects;
    private List<ProjectVersionDto> _projectVersions;
    private MarketSegmentService _marketSegmentService;

    private List<Claim> _claims;

    [SetUp]
    public void Setup()
    {
        _claims = new List<Claim>()
        {
            new Claim(ClaimTypes.Role, "WRITE"),
            new Claim(ClaimTypes.Name, "TestUser")
        };

        _projectRepository = new Mock<IProjectRepository>();
        _marketSegmentRepository = new Mock<IMarketSegmentRepository>();
        _combinedAveragesRepository = new Mock<ICombinedAveragesRepository>();
        _marketSegmentService = new MarketSegmentService(_marketSegmentRepository.Object, _combinedAveragesRepository.Object);
        _fileRepository = new Mock<IFileRepository>();
        _projectController = new ProjectController(_projectRepository.Object, _marketSegmentService, _fileRepository.Object);
        _projectController.ControllerContext = GetControllerContext();

        _projects = new List<ProjectDto>
        {
            new ProjectDto { Id=1, Name="Project 1"}
        };

        _projectVersions = new List<ProjectVersionDto> { new ProjectVersionDto { Id = 1, VersionLabel = "Test Version" } };

        _projectRepository.Setup(x => x.GetProjectsByOrganizationId(It.IsAny<int>())).ReturnsAsync(_projects);
        _projectRepository.Setup(x => x.GetProjectVersions(It.IsAny<int>())).ReturnsAsync(_projectVersions);
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
    public async Task GetProjectsByOrganizationId_Success()
    {
        int orgId = 4;
        var response = await _projectController.GetProjects(orgId) as OkObjectResult;
        var projectResponse = response?.Value as List<ProjectDto>;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(projectResponse);
        Assert.IsTrue(projectResponse.Any());
    }

    [Test]
    public async Task GetProjectVersions_Success()
    {
        int projectId = 1;
        var response = await _projectController.GetProjectVersions(projectId) as OkObjectResult;
        var projectVersionResponse = response?.Value as List<ProjectVersionDto>;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(projectVersionResponse);
        Assert.IsTrue(projectVersionResponse.Any());
    }

    [Test]
    public async Task DeleteProjectVersion_Success()
    {
        _projectRepository.Setup(x => x.DeleteProjectVersion(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()));

        var response = await _projectController.DeleteProjectVersion(new DeleteProjectRequestDto { ProjectId = 1, ProjectVersionId = 1, Notes = string.Empty }) as OkObjectResult;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        _projectRepository.Verify(x => x.DeleteProjectVersion(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>()), Times.Once());
    }

    [Test]
    public async Task SearchProject_Success()
    {
        var projects = new List<SearchProjectDto>
        {
            new SearchProjectDto { Name = "Project 1", OrganizationId = 1, FileLogKey = 2 },
            new SearchProjectDto { Name = "Project 2", OrganizationId = 1 },
            new SearchProjectDto { Name = "Project 3", OrganizationId = 1 }
        };

        var organizations = new List<OrganizationDto>
        {
            new OrganizationDto { Id = 1, Name = "Organization One" }
        };

        var files = new List<FileLogDto>
        {
            new FileLogDto { FileLogKey = 2, FileStatusName = "Uploaded", OrganizationId = 1 }
        };

        _projectRepository.Setup(x => x.SearchProject(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>())).ReturnsAsync(projects);
        _projectRepository.Setup(x => x.GetOrganizationsByIds(It.IsAny<List<int>>())).ReturnsAsync(organizations);
        _fileRepository.Setup(x => x.GetFilesByIds(It.IsAny<List<int>>())).ReturnsAsync(files);

        var request = new SearchProjectRequestDto
        {
            take = projects.Count,
            sort = new List<Sort>
            {
                new Sort
                {
                    field = "name", 
                    dir = "desc"
                }
            },
            orgId = 1
        };
        var response = await _projectController.SearchProject(request) as SearchProjectResultDto;

        ////Assert
        Assert.IsNotNull(response);
        Assert.That(response.SearchProjects, Is.Not.Null);
        Assert.That(response.SearchProjects.Any(), Is.True);
        Assert.That(projects.Count, Is.EqualTo(response.SearchProjects.Count));
        Assert.That(response.Total, Is.EqualTo(projects.Count));
        
        //Validating file log details
        Assert.That(response.SearchProjects[2].FileLogKey, Is.EqualTo(files.First().FileLogKey));
        Assert.That(response.SearchProjects[2].FileStatusName, Is.EqualTo(files.First().FileStatusName));

        _projectRepository.Verify(x => x.SearchProject(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>()), Times.Once());
        _projectRepository.Verify(x => x.GetOrganizationsByIds(It.IsAny<List<int>>()), Times.Once());
        _fileRepository.Verify(x => x.GetFilesByIds(It.IsAny<List<int>>()), Times.Once());
    }

    [Test]
    public async Task GetProjectStatus_Success()
    {
        _projectRepository.Setup(x => x.GetProjectStatus(It.IsAny<int>())).ReturnsAsync(1);
        var projectId = 1;
        var response = await _projectController.GetProjectStatus(projectId);

        ////Assert
        Assert.IsNotNull(response);
        _projectRepository.Verify(x => x.GetProjectStatus(It.IsAny<int>()), Times.Once());
    }

    [Test]
    public async Task GetMarketSegments_Success()
    {
        var marketSegments = new List<MarketSegmentDto>()
        {
            new MarketSegmentDto { Id = 1, Name = "test" }
        };

        _marketSegmentRepository.Setup(x => x.GetMarketSegmentsWithCuts(It.IsAny<int>(), It.IsAny<int?>())).ReturnsAsync(marketSegments);
        var projectVersionId = 1;
        var response = await _projectController.GetMarketSegments(projectVersionId);

        ////Assert
        Assert.IsNotNull(response);
        _marketSegmentRepository.Verify(x => x.GetMarketSegmentsWithCuts(It.IsAny<int>(), It.IsAny<int?>()), Times.Once());
    }
}