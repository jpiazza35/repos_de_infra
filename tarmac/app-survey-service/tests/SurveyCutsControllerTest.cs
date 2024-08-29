using Moq;
using NUnit.Framework;
using CN.Survey.Domain;
using CN.Survey.RestApi.Controllers;
using Microsoft.AspNetCore.Mvc;
using CN.Survey.Domain.Services;
using CN.Survey.RestApi.Services;
using ServiceStack;
using CN.Survey.Infrastructure.Repositories;
using CN.Survey.Domain.Response;
using CN.Survey.Domain.Request;

namespace CN.Survey.Tests;

[TestFixture]
public class SurveyCutsControllerTest
{
    private ISurveyCutsService _service;
    private SurveyController _controller;
    private Mock<ISurveyCutsRepository> _surveyCutsRepository;
    private SurveyCutsDataListResponse _surveyCutsDataListResponse;
    private SurveyCutFilterOptionsListResponse _surveyCutFilterOptionsListResponse;

    [SetUp]
    public void Setup()
    {
        var now = DateTime.Now;
        _surveyCutsRepository = new Mock<ISurveyCutsRepository>();
        _service = new SurveyCutsService(_surveyCutsRepository.Object);
        _controller = new SurveyController(_service);

        _surveyCutsDataListResponse = new SurveyCutsDataListResponse()
        {
            StandardJobs = new List<StandardJobResponse>()
            {
                new ()
                {
                    StandardJobCode = "JC001",
                    StandardJobTitle = "Radiology",
                    StandardJobDescription = "Radiology Description"
                },
                new ()
                {
                    StandardJobCode = "JC002",
                    StandardJobTitle = "Allergy/Immunology",
                    StandardJobDescription = "Allergy/Immunology Description"
                },
                new ()
                {
                    StandardJobCode = "JC003",
                    StandardJobTitle = "Cardiology - General",
                    StandardJobDescription = ""
                }
            },

            Publishers = new List<PublisherResponse>()
            {
                new ()
                { 
                    PublisherKey = 1,
                    PublisherName = "SullivanCotter",
                },
                new ()
                {
                    PublisherKey = 2,
                    PublisherName = "MGMA",
                }
            },

            SurveyJobs = new List<SurveyJobResponse>()
            {
                new ()
                {
                    SurveyJobCode = "JC001",
                    SurveyJobTitle = "Radiology",
                    SurveyJobDescription = "Radiology Description"
                },
                new ()
                {
                    SurveyJobCode = "JC002",
                    SurveyJobTitle = "Allergy/Immunology",
                    SurveyJobDescription = "Allergy/Immunology Description"
                },
                new ()
                {
                    SurveyJobCode = "JC003",
                    SurveyJobTitle = "Cardiology - General",
                    SurveyJobDescription = ""
                }
            },
        };

        _surveyCutFilterOptionsListResponse = new SurveyCutFilterOptionsListResponse
        {
            SurveyYears = new List<SurveyYearResponse>
            {
                new SurveyYearResponse
                {
                    SurveyPublisherNameKeySet = new NameKeySet{ FilterName = "Test", FilterKeyYear = new List<FilterKeyYear>{ new FilterKeyYear { SurveyYear = now.Year } } }
                }
            }
        };
    }

    [Test]
    public async Task GetEmptyStandardJobList_WhenStandardJobSearch_IsEmpty()
    {
        var request = new SurveyCutsDataRequest();
        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataStandardJobs(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataStandardJobs(request);
        var response = ((OkObjectResult)result).Value;
        var standardJobsResponse = response as List<StandardJobResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(standardJobsResponse);
        Assert.That(standardJobsResponse.Count(), Is.EqualTo(0));

        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataStandardJobs(request), Times.Never);
    }

    [Test]
    public async Task GetStandardJobs_WhenStandardJobSearch_IsNotEmpty()
    {
        var request = new SurveyCutsDataRequest();
        request.StandardJobSearch = "JC00";
        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataStandardJobs(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataStandardJobs(request);
        var response = ((OkObjectResult)result).Value;
        var standardJobsResponse = response as List<StandardJobResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(standardJobsResponse);
        Assert.That(standardJobsResponse.Count(), Is.EqualTo(_surveyCutsDataListResponse.StandardJobs.Count()));
        Assert.That(standardJobsResponse[0].StandardJobCode, Is.EqualTo(_surveyCutsDataListResponse.StandardJobs[0].StandardJobCode));
        Assert.That(standardJobsResponse[0].StandardJobTitle, Is.EqualTo(_surveyCutsDataListResponse.StandardJobs[0].StandardJobTitle));
        Assert.That(standardJobsResponse[0].StandardJobDescription, Is.EqualTo(_surveyCutsDataListResponse.StandardJobs[0].StandardJobDescription));

        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataStandardJobs(request), Times.Once);
    }

    [Test]
    public async Task GetEmptyPublisherList_WhenStandardJobsRequest_IsEmpty()
    {
        var request = new SurveyCutsDataRequest();
        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataPublishers(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataPublishers(request);
        var response = ((OkObjectResult)result).Value;
        var publishersResponse = response as List<PublisherResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(publishersResponse);
        Assert.That(publishersResponse.Count(), Is.EqualTo(0));

        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataPublishers(request), Times.Never);
    }

    [Test]
    public async Task GetPublisherList_WhenStandardJobsRequest_IsNotEmpty()
    {
        var request = new SurveyCutsDataRequest();
        request.StandardJobCodes = new List<string>() { "JC001" };
        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataPublishers(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataPublishers(request);
        var response = ((OkObjectResult)result).Value;
        var publishersResponse = response as List<PublisherResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(publishersResponse);
        Assert.That(publishersResponse.Count(), Is.EqualTo(_surveyCutsDataListResponse.Publishers.Count()));
        Assert.That(publishersResponse[0].PublisherKey, Is.EqualTo(_surveyCutsDataListResponse.Publishers[0].PublisherKey));
        Assert.That(publishersResponse[0].PublisherName, Is.EqualTo(_surveyCutsDataListResponse.Publishers[0].PublisherName));
        Assert.That(publishersResponse[1].PublisherKey, Is.EqualTo(_surveyCutsDataListResponse.Publishers[1].PublisherKey));
        Assert.That(publishersResponse[1].PublisherName, Is.EqualTo(_surveyCutsDataListResponse.Publishers[1].PublisherName));
        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataPublishers(request), Times.Once);
    }

    [Test]
    public async Task GetEmptySurveyJobList_WhenStandardJobsOrPublisherKeyRequest_IsEmpty()
    {
        var request = new SurveyCutsDataRequest();
        request.PublisherKey = null;
        request.StandardJobCodes = null;

        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataJobs(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataJobs(request);
        var response = ((OkObjectResult)result).Value;
        var surveyJobsResponse = response as List<SurveyJobResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(surveyJobsResponse);
        Assert.That(surveyJobsResponse.Count(), Is.EqualTo(0));

        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataJobs(request), Times.Never);
    }

    [Test]
    public async Task GetEmptySurveyJobList_WhenStandardJobsAndPublisherKeyRequest_IsNotEmpty()
    {
        var request = new SurveyCutsDataRequest();
        request.StandardJobCodes = new List<string>() { "JC001" };
        request.PublisherKey = 1;

        _surveyCutsDataListResponse = new SurveyCutsDataListResponse()
        {
            SurveyJobs = new List<SurveyJobResponse>()
            {
                new ()
                {
                    SurveyJobCode = "JC001",
                    SurveyJobTitle = "Radiology",
                    SurveyJobDescription = "Radiology Description"
                }
            },
        };

        _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataJobs(request)).ReturnsAsync(_surveyCutsDataListResponse);

        // Act
        var result = await _controller.ListSurveyCutsDataJobs(request);
        var response = ((OkObjectResult)result).Value;
        var surveyJobsResponse = response as List<SurveyJobResponse>;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(surveyJobsResponse);
        Assert.That(surveyJobsResponse.Count(), Is.EqualTo(_surveyCutsDataListResponse.SurveyJobs.Count()));
        Assert.That(surveyJobsResponse[0].SurveyJobCode, Is.EqualTo(_surveyCutsDataListResponse.SurveyJobs[0].SurveyJobCode));
        Assert.That(surveyJobsResponse[0].SurveyJobTitle, Is.EqualTo(_surveyCutsDataListResponse.SurveyJobs[0].SurveyJobTitle));
        Assert.That(surveyJobsResponse[0].SurveyJobDescription, Is.EqualTo(_surveyCutsDataListResponse.SurveyJobs[0].SurveyJobDescription));
        _surveyCutsRepository.Verify(x => x.ListSurveyCutsDataJobs(request), Times.Once);
    }

    [Test]
    public async Task ListSurveyCutFilterOptions_WhenSurveyCutFilterOptionsRequest_IsNotEmpty()
    {
        var request = new SurveyCutFilterOptionsRequest();
        _surveyCutsRepository.Setup(x => x.ListSurveyCutFilterOptions(request)).ReturnsAsync(_surveyCutFilterOptionsListResponse);

        // Act
        var result = await _controller.ListSurveyCutFilterOptions(request);
        var response = ((OkObjectResult)result).Value;
        var filtersResponse = response as SurveyCutFilterOptionsListResponse;

        // Assert
        Assert.IsInstanceOf<OkObjectResult>(result);
        Assert.NotNull(filtersResponse);
        Assert.IsNotEmpty(filtersResponse.SurveyYears);
        Assert.That(filtersResponse.SurveyYears.Count(), Is.EqualTo(_surveyCutFilterOptionsListResponse.SurveyYears.Count()));
        Assert.That(filtersResponse.SurveyYears[0].SurveyPublisherNameKeySet?.FilterKeyYear?[0].SurveyYear,
                    Is.EqualTo(_surveyCutFilterOptionsListResponse.SurveyYears[0].SurveyPublisherNameKeySet?.FilterKeyYear?[0].SurveyYear));
        _surveyCutsRepository.Verify(x => x.ListSurveyCutFilterOptions(request), Times.Once);
    }
}