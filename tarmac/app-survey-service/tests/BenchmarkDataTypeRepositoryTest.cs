using NUnit.Framework;
using Moq;
using CN.Survey.Infrastructure;
using CN.Survey.Tests.Generic;
using CN.Survey.Infrastructure.Repositories;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;

namespace CN.Survey.Tests;

[TestFixture]
public class BenchmarkDataTypeRepositoryTest
{
    private Mock<IDBContext> _context;
    private Mock<ILogger<BenchmarkDataTypeRepository>> _logger;
    InMemoryDatabase db;

    [SetUp]
    public void Setup()
    {
        _context = new Mock<IDBContext>();
        _logger = new Mock<ILogger<BenchmarkDataTypeRepository>>();

        var benchmarkDataTypeSourceGroups = GetBenchmarkDataTypeSourceGroups();
        var sourveySourceGroups = GetSourveySourceGroups();
        var benchmarkDataTypes = GetBenchmarkDataTypes();

        db = new InMemoryDatabase();
        db.Insert(benchmarkDataTypeSourceGroups);
        db.Insert(sourveySourceGroups);
        db.Insert(benchmarkDataTypes);

        _context.Setup(c => c.GetConnection()).Returns(db.OpenConnection());
    }

    [Test]
    public async Task GetBenchmarkDataTypes_SourceGroup_Employee()
    {
        // Act
        var sourceGroupKey = 6;
        var result = await new BenchmarkDataTypeRepository(_context.Object, _logger.Object).GetBenchmarkDataTypes(sourceGroupKey);

        // Assert
        Assert.Multiple(() =>
        {
            Assert.NotNull(result);
            Assert.That(result, Has.Count.EqualTo(2));

            Assert.That(result?[0].ID, Is.EqualTo(1));
            Assert.That(result?[0].Name, Is.EqualTo("Base Pay Hourly Rate"));
            Assert.That(result?[0].AgingFactor, Is.EqualTo(2.4f));

            Assert.That(result?[1].ID, Is.EqualTo(2));
            Assert.That(result?[1].Name, Is.EqualTo("Pay Range Maximum"));
            Assert.That(result?[1].AgingFactor, Is.EqualTo(3f));
        });
    }

    [Test]
    public async Task GetBenchmarkDataTypes_SourceGroup_NotEmployee()
    {
        // Act
        var sourceGroupKey = 3;
        var result = await new BenchmarkDataTypeRepository(_context.Object, _logger.Object).GetBenchmarkDataTypes(sourceGroupKey);

        // Assert
        Assert.Multiple(() =>
        {
            Assert.That(result?.Count, Is.EqualTo(1));
            Assert.That(result?[0].ID, Is.EqualTo(3));
            Assert.That(result?[0].Name, Is.EqualTo("Benchmark Not Employee"));
            Assert.That(result?[0].AgingFactor, Is.EqualTo(1.2f));
        });
    }

    // Support test classes
    private class Benchmark_data_type
    {
        [Key]
        public int Benchmark_data_type_key { get; set; }
        public string? Benchmark_data_type_name { get; set; }
        public int Benchmark_data_type_order { get; set; }
    }

    private class Benchmark_data_type_source_group 
    {
        [Key]
        public int Benchmark_data_type_key { get; set; }
        public int survey_source_group_key { get; set; }
        public float Aging_Factor_Default { get; set; }
        public string? Benchmark_Data_Type_Default { get; set; }
    }

    private class Survey_source_group
    {
        [Key]
        public int survey_source_group_key { get; set; }
        public string? survey_source_group_name { get; set; }
    }

    private List<Benchmark_data_type> GetBenchmarkDataTypes()
    {           
        return new List<Benchmark_data_type>
        {
            new()
            {
                Benchmark_data_type_key = 1,
                Benchmark_data_type_name = "Base Pay Hourly Rate",
                Benchmark_data_type_order = 2,
            },
            new()
            {
                Benchmark_data_type_key = 2,
                Benchmark_data_type_name = "Pay Range Maximum",
                Benchmark_data_type_order = 1,
            },
            new()
            {
                Benchmark_data_type_key = 3,
                Benchmark_data_type_name = "Benchmark Not Employee",
                Benchmark_data_type_order = 5,
            }
        };
    }

    private List<Benchmark_data_type_source_group> GetBenchmarkDataTypeSourceGroups()
    {
        return new List<Benchmark_data_type_source_group>
        {
            new()
            {
                survey_source_group_key = 6,
                Aging_Factor_Default = 2.4f,
                Benchmark_Data_Type_Default = null,
                Benchmark_data_type_key = 1
            },
            new()
            {
                survey_source_group_key = 6,
                Aging_Factor_Default = 3f,
                Benchmark_Data_Type_Default = null,
                Benchmark_data_type_key = 2
            },
            new()
            {
                survey_source_group_key = 3,
                Aging_Factor_Default = 1.2f,
                Benchmark_Data_Type_Default = null,
                Benchmark_data_type_key = 3
            }
        };
    }

    private List<Survey_source_group> GetSourveySourceGroups()
    {
        return new List<Survey_source_group>
        {
            new()
            {
                survey_source_group_key = 6,
                survey_source_group_name = "Employee"
            },
            new()
            {
                survey_source_group_key = 3,
                survey_source_group_name = "NotEmployee"
            }
        };
    }
}