using Moq;
using NUnit.Framework;
using CN.Survey.Domain;
using CN.Survey.RestApi.Controllers;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.Tests;

[TestFixture]
public class ProjectDetailsControllerTest
{
    private Mock<IBenchmarkDataTypeRepository> _benchmarkDataTypeRepository;        
    private BenchmarkDataTypeController _benchmarkDataTypeController;
    private List<BenchmarkDataType> _benchmarkDataTypes;

    [SetUp]
    public void Setup()
    {
        _benchmarkDataTypeRepository = new Mock<IBenchmarkDataTypeRepository>();
        _benchmarkDataTypeController = new BenchmarkDataTypeController(_benchmarkDataTypeRepository.Object);

        _benchmarkDataTypes = new List<BenchmarkDataType>()
        {
            new BenchmarkDataType()
            {
                ID = 29,
                Name = "Base Pay Hourly Rate",
                DefaultDataType = null,
                AgingFactor = 3.2f,
                OrderDataType = 42
            },
            new BenchmarkDataType()
            {
                ID = 44,
                Name = "Pay Range Maximum",
                AgingFactor = 2f,
                DefaultDataType = null,
                OrderDataType = 44
            },
            new BenchmarkDataType()
            {
                ID = 45,
                Name = "Pay Range Minimum",
                DefaultDataType = null,
                AgingFactor = 1f,
                OrderDataType = 45
            }
        };

        _benchmarkDataTypeRepository.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(_benchmarkDataTypes);
    }

    [Test]
    public async Task GetBenchmarkDataTypes_Employee()
    {
        var sourceGroupKey = 1; //Employee
        var response = await _benchmarkDataTypeController.GetBenchmarkDataTypes(sourceGroupKey) as OkObjectResult;
        var benchmarkDataTypes = response?.Value as List<BenchmarkDataType>;

        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(benchmarkDataTypes);
        Assert.IsTrue(benchmarkDataTypes.Count == 3);
        Assert.That(_benchmarkDataTypes.First().ID, Is.EqualTo(benchmarkDataTypes.First().ID));
        Assert.That(_benchmarkDataTypes.First().Name, Is.EqualTo(benchmarkDataTypes.First().Name));
        Assert.That(_benchmarkDataTypes.First().AgingFactor, Is.EqualTo(benchmarkDataTypes.First().AgingFactor));
        Assert.That(_benchmarkDataTypes.First().OrderDataType, Is.EqualTo(benchmarkDataTypes.First().OrderDataType));
    }

    [Test]
    public async Task GetBenchmarkDataTypes_EmptyList()
    {
        _benchmarkDataTypeRepository.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(new List<BenchmarkDataType>());

        var sourceGroupKey = 3; //Not Employee
        var response = await _benchmarkDataTypeController.GetBenchmarkDataTypes(sourceGroupKey) as OkObjectResult;
        var benchmarkDataTypes = response?.Value as List<BenchmarkDataType>;

        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(benchmarkDataTypes);
        Assert.IsTrue(benchmarkDataTypes.Count == 0);
    }
}