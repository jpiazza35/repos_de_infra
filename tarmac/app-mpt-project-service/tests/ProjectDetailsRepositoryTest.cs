using CN.Project.Test.Generic;
using CN.Project.Infrastructure.Repository;
using CN.Project.Domain;
using CN.Project.Domain.Dto;
using CN.Project.Infrastructure;

using Moq;
using NUnit.Framework;
using AutoMapper;
using Microsoft.Extensions.Logging;
using Cn.Incumbent;

namespace CN.Project.Test;

[TestFixture]
public class ProjectDetailsRepositoryTests
{
    private Mock<IDBContext> _context;
    private Mock<ILogger<ProjectDetailsRepository>> _logger;
    private Mock<IFileRepository> _fileRepository;
    private IMapper _mapper;
    private InMemoryDatabase db;
    private Mock<Incumbent.IncumbentClient> _incumbentClient;

    [SetUp]
    public void Setup()
    {
        _context = new Mock<IDBContext>();
        _fileRepository = new Mock<IFileRepository>();
        _mapper = MappingConfig.RegisterMaps().CreateMapper();
        _logger = new Mock<ILogger<ProjectDetailsRepository>>();

        var projects = new List<ProjectDetails>
        {
            new()
            {
                project_id = 1,
                project_name = "Project 1"
            }
        };

        var projectVersions = new List<Project_Version>
        {
            new()
            {
                Project_version_id = 1,
                Project_id = 1,
                Project_version_label = "Version 1",
            }
        };

        db = new InMemoryDatabase();
        db.Insert(projects, "project_list");
        db.Insert(projectVersions, "project_version");
        db.CreateTable<BenchmarkDataType>("project_benchmark_data_type");

        _context.Setup(c => c.GetConnection()).Returns(db.OpenConnection());
        _incumbentClient = new Mock<Incumbent.IncumbentClient>();
    }

    [Test]
    public async Task GetProjetDetailsById_ExistsInRepository()
    {
        // Act
        var projectId = 1;
        var projectVersionId = 1;
        var result = await new ProjectDetailsRepository(_context.Object, _fileRepository.Object, _mapper, _logger.Object, _incumbentClient.Object).GetProjetDetails(projectId, projectVersionId);

        // Assert
        Assert.That(projectId, Is.EqualTo(result.ID));
        Assert.That(result.Name, Is.EqualTo("Project 1"));
        Assert.That(projectVersionId, Is.EqualTo(result.Version));
        Assert.That(result.VersionLabel, Is.EqualTo("Version 1"));
    }

    [Test]
    public async Task GetProjetDetailsById_NotExistsInRepository()
    {
        // Act
        var projectId = 2;
        var projectVersionId = 2;
        var result = await new ProjectDetailsRepository(_context.Object, _fileRepository.Object, _mapper, _logger.Object, _incumbentClient.Object).GetProjetDetails(projectId, projectVersionId);

        // Assert
        Assert.That(result.ID, Is.EqualTo(0));
    }

    [Test]
    public async Task SaveProjectInfo_Test()
    {
        // Act
        var porjectId = 2;
        var projectDetails = new ProjectDetailsDto()
        {
            Name = "Project 2",
            ProjectStatus = 1,
            SourceDataInfo = new SourceDataInfoDto
            {
                EffectiveDate = System.DateTime.UtcNow,
                SourceData = "Incumbent"
            },
            BenchmarkDataTypes = new List<BenchmarkDataTypeInfoDto>() {
                new () {
                    ID = 1,
                    OverrideAgingFactor= 3.5f,
                    OverrideNote = "Note 2"
                }
            }
        };

        var result = await new ProjectDetailsRepository(_context.Object, _fileRepository.Object, _mapper, _logger.Object, _incumbentClient.Object).SaveProjetDetails(projectDetails, "testObjectId");

        // Assert
        Assert.That(result.ID, Is.EqualTo(porjectId));
    }
}