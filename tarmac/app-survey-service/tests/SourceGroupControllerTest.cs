using Moq;
using NUnit.Framework;
using CN.Survey.Domain;
using CN.Survey.RestApi.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.Tests;

[TestFixture]
public class SourceGroupControllerTest
{
    private Mock<ISourceGroupRepository> _sourceGroupRepository;
    private SourceGroupController _sourceGroupController;
    private List<SourceGroup> _sourceGroups;

    [SetUp]
    public void Setup()
    {
        _sourceGroupRepository = new Mock<ISourceGroupRepository>();
        _sourceGroupController = new SourceGroupController(_sourceGroupRepository.Object);

        _sourceGroups = new List<SourceGroup>()
        {
            new SourceGroup()
            {
                ID = 1,
                Name = "Physician",
                Description = string.Empty,
                Status = string.Empty
            },
            new SourceGroup()
            {
                ID = 2,
                Name = "Employee",
                Description = string.Empty,
                Status = string.Empty
            },
            new SourceGroup()
            {
                ID = 3,
                Name = "Executive",
                Description = string.Empty,
                Status = string.Empty
            }
        };

        _sourceGroupRepository.Setup(x => x.GetSourceGroups()).ReturnsAsync(_sourceGroups);
    }

    [Test]
    public async Task GetSourceGroups()
    {
        var response = await _sourceGroupController.GetSourceGroups() as OkObjectResult;
        var sourceGroups = (List<SourceGroup>?)response?.Value;

        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(sourceGroups);
        Assert.IsTrue(sourceGroups.Count == 3);
        Assert.That(_sourceGroups.First().ID, Is.EqualTo(sourceGroups.First().ID));
        Assert.That(_sourceGroups.First().Name, Is.EqualTo(sourceGroups.First().Name));
    }
}