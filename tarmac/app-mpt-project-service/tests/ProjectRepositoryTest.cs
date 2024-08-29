using AutoMapper;
using CN.Project.Domain;
using CN.Project.Infrastructure;
using CN.Project.Infrastructure.Repository;
using CN.Project.Test.Generic;
using Cn.Organization;
using Grpc.Core;
using Grpc.Core.Testing;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;
using Organization = Cn.Organization.Organization;
using Cn.Incumbent;
using System.Data;
using Google.Protobuf.WellKnownTypes;

namespace CN.Project.Test;

[TestFixture]
public class ProjectRepositoryTests
{
    private Mock<IDBContext> _context;
    private Mock<ILogger<ProjectRepository>> _logger;
    private Mock<Organization.OrganizationClient> _organizationClient;
    private Mock<Incumbent.IncumbentClient> _incumbentClient;
    private OrganizationList _organizationList;
    private FileList _fileList;
    private IMapper _mapper;

    [SetUp]
    public void Setup()
    {
        _logger = new Mock<ILogger<ProjectRepository>>();
        _context = new Mock<IDBContext>();
        _mapper = MappingConfig.RegisterMaps().CreateMapper();

        var MarketPricingProjects = new List<Project_List>
        {
            new Project_List{
                Org_Key=1,
                Project_Id=1,
                Project_Name="Test Project 1",
                Project_Status_Key=1,
            },
            new Project_List{
                Org_Key=2,
                Project_Id=2,
                Project_Name="Test Project 2",
                Project_Status_Key=2,
            },
        };

        var ProjectVersions = new List<Project_Version>
        {
            new Project_Version{

                Project_version_id=1,
                Project_id =1,
                Project_version_label="Test Project V 1",
                Project_version_status_key = 1
            },
            new Project_Version{
                Project_version_id=2,
                Project_id=2,
                Project_version_label="Test Project V 2",
                Project_version_status_key = 1
            },
        };

        var Statuses = new List<Status_List>
        {
            new Status_List{

                Status_Key=1,
                Status_Name="Test"

            },
            new Status_List{

                 Status_Key=2,
                Status_Name="Test 2"
            },
        };

        var db = new InMemoryDatabase();
        db.Insert(MarketPricingProjects);
        db.Insert(ProjectVersions);
        db.Insert(Statuses);
        _context.Setup(c => c.GetConnection()).Returns(db.OpenConnection());

        SetupOrganizationClient();
        SetupIncumbentClient();
    }

    [Test]
    public async Task GetProjectsByOrganizationId()
    {
        // Act
        var result = await new ProjectRepository(_context.Object,
                                                 _mapper,
                                                 _logger.Object,
                                                 _organizationClient.Object,
                                                 _incumbentClient.Object).GetProjectsByOrganizationId(1);

        // Assert
        Assert.That(result[0].Id, Is.EqualTo(1));
        Assert.That(result[0].Name, Is.EqualTo("Test Project 1"));
    }

    [Test]
    public async Task GetProjectVersions()
    {
        // Act
        var result = await new ProjectRepository(_context.Object,
                                                 _mapper,
                                                 _logger.Object,
                                                 _organizationClient.Object,
                                                 _incumbentClient.Object).GetProjectVersions(1);

        // Assert
        Assert.That(result[0].Id, Is.EqualTo(1));
        Assert.That(result[0].VersionLabel, Is.EqualTo("Test Project V 1"));
    }

    [Test]
    public async Task SearchProjectWithConditions()
    {
        var organizationId = 1;
        var projectId = 1;
        var projectVersion = 1;

        // Act
        var result = await new ProjectRepository(_context.Object,
                                                 _mapper,
                                                 _logger.Object,
                                                 _organizationClient.Object, 
                                                 _incumbentClient.Object).SearchProject(organizationId, projectId, projectVersion);

        // Assert
        Assert.NotNull(result);
        Assert.IsNotEmpty(result);
        Assert.That(result[0].OrganizationId, Is.EqualTo(organizationId));
        Assert.That(result[0].Id, Is.EqualTo(projectId));
        Assert.That(result[0].ProjectVersion, Is.EqualTo(projectVersion));
        Assert.That(result[0].Name, Is.EqualTo("Test Project 1"));
    }

    [Test]
    public async Task DeleteProject()
    {
        int projectId = 1;
        int projectVersionId = 1;

        // Act
        var repository = new ProjectRepository(_context.Object, _mapper, _logger.Object, _organizationClient.Object, _incumbentClient.Object);
        await repository.DeleteProjectVersion(projectId, projectVersionId, string.Empty);
    }

    [Test]
    public async Task GetProjectStatus()
    {
        int projectId = 1;
        var repository = new ProjectRepository(_context.Object, _mapper, _logger.Object, _organizationClient.Object, _incumbentClient.Object);
        var result = await repository.GetProjectStatus(projectId);
        Assert.That(result, Is.EqualTo(1));
    }

    // Setup

    private void SetupOrganizationClient()
    {
        _organizationClient = new Mock<Organization.OrganizationClient>();
        _organizationList = new OrganizationList();
        _organizationList.Organizations.AddRange(new Google.Protobuf.Collections.RepeatedField<OrganizationModel>
        {
            new OrganizationModel
            {
                OrgId = 1,
                OrgName = "Organization Test"
            }
        });

        var organizationListResponse = TestCalls.AsyncUnaryCall(Task.FromResult(_organizationList), Task.FromResult(new Metadata()), () => Status.DefaultSuccess, () => new Metadata(), () => { });
        _organizationClient.Setup(o => o.ListOrganizationByIdsOrTermAsync(It.IsAny<OrganizationSearchRequest>(), null, null, CancellationToken.None)).Returns(organizationListResponse);
    }

    private void SetupIncumbentClient()
    {
        _incumbentClient = new Mock<Incumbent.IncumbentClient>();
        _fileList = new FileList();
        _fileList.Files.AddRange(new Google.Protobuf.Collections.RepeatedField<FileModel>
        {
            new FileModel
            {
                FileLogKey = 1,
                FileStatusKey = 2,
                SourceDataName = "Incumbent",
                StatusName = "Uploaded",
                DataEffectiveDate = DateTime.UtcNow.ToTimestamp(),
                FileOrgKey = 1
            }
        });

        var fileListResponse = TestCalls.AsyncUnaryCall(Task.FromResult(_fileList), Task.FromResult(new Metadata()), () => Status.DefaultSuccess, () => new Metadata(), () => { });
        _incumbentClient.Setup(o => o.ListFilesByIdsAsync(It.IsAny<FileIdsRequest>(), null, null, CancellationToken.None)).Returns(fileListResponse);
    }
}