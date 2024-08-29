using NUnit.Framework;
using Moq;
using CN.Survey.Infrastructure;
using CN.Survey.Tests.Generic;
using CN.Survey.Infrastructure.Repositories;
using Microsoft.Extensions.Logging;

namespace CN.Survey.Tests;

[TestFixture]
public class SourceGroupRepositoryTest
{
    private Mock<IDBContext> _context;
    private Mock<ILogger<SourceGroupRepository>> _logger;
    private InMemoryDatabase db;
    private List<Survey_Source_Group> _surveySourceGroup;

    [SetUp]
    public void Setup()
    {
        _context = new Mock<IDBContext>();
        _logger = new Mock<ILogger<SourceGroupRepository>>();

        _surveySourceGroup = GetSurveySourceGroups();
        var statusList = GetStatusList();

        db = new InMemoryDatabase();
        db.Insert(_surveySourceGroup);
        db.Insert(statusList);

        _context.Setup(c => c.GetConnection()).Returns(db.OpenConnection());
    }

    [Test]
    public async Task GetSourceGroups_All_Not_Deleted()
    {
        // Act
        var result = await new SourceGroupRepository(_context.Object, _logger.Object).GetSourceGroups();

        // Assert
        Assert.Multiple(() =>
        {
            Assert.That(result?.Count, Is.EqualTo(2));
            Assert.That(_surveySourceGroup[0].survey_source_group_key, Is.EqualTo(result?[0].ID));
            Assert.That(_surveySourceGroup[0].survey_source_group_name, Is.EqualTo(result?[0].Name));
            Assert.That(_surveySourceGroup[1].survey_source_group_key, Is.EqualTo(result?[1].ID));
            Assert.That(_surveySourceGroup[1].survey_source_group_name, Is.EqualTo(result?[1].Name));
        });
    }

    // Support test classes
    private class Survey_Source_Group
    {
        public int survey_source_group_key { get; set; }
        public string? survey_source_group_name { get; set; }
        public string? survey_source_group_description { get; set; }
        public int status_key { get; set; }
    }
    public class Status_list 
    {
        public int status_key { get; set; }
        public string? status_name { get; set; }
    }

    private List<Survey_Source_Group> GetSurveySourceGroups()
    {           
        return new List<Survey_Source_Group>
        {
            new()
            {
                survey_source_group_key = 1,
                survey_source_group_name = "Physician",
                status_key = 1,
            },
            new()
            {
                survey_source_group_key = 2,
                survey_source_group_name = "On-Call",
                status_key = 2
            },
            new()
            {
                survey_source_group_key = 3,
                survey_source_group_name = "Executive",
                status_key = 3
            }
        };
    }

    private List<Status_list> GetStatusList()
    {
        return new List<Status_list>
        {
            new()
            {
                status_key = 1,
                status_name = "Started",
            },
            new()
            {
                status_key = 2,
                status_name = "Valid",
            },
            new()
            {
                status_key = 3,
                status_name = "Deleted",
            }
        };
    }
}