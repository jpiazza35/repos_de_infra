using CN.Survey.Domain.Request;
using CN.Survey.Domain;
using CN.Survey.RestApi.Controllers;
using CN.Survey.RestApi.Services;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;

namespace CN.Survey.Tests
{
    [TestFixture]
    public class MarketSegmentControllerTest
    {
        private MarketSegmentController _controller;
        private MarketSegmentService _service;
        private SurveyCutsService _surveyCutsService;
        private Mock<ISurveyCutsRepository> _surveyCutsRepository;

        [SetUp]
        public void Setup()
        {
            _surveyCutsRepository = new Mock<ISurveyCutsRepository>();
            _service = new MarketSegmentService(_surveyCutsRepository.Object);
            _surveyCutsService = new SurveyCutsService(_surveyCutsRepository.Object);
            _controller = new MarketSegmentController(_service, _surveyCutsRepository.Object, _surveyCutsService);
        }

        [Test]
        public async Task GetMarketSegmentFilters_ReturnsOkObjectResult_WhenRepositoryReturnsMarketSegment()
        {
            // Arrange
            var marketSegmentFiltersRequest = new SurveyCutFilterFlatOptionsRequest();
            var marketSegmentFilters = new List<SurveyCutFilterFlatOption> { new SurveyCutFilterFlatOption() };
            _surveyCutsRepository.Setup(x => x.ListSurveyCutFilterFlatOptions(marketSegmentFiltersRequest)).ReturnsAsync(marketSegmentFilters);

            // Act
            var result = await _controller.ListSurveyCutFilterFlatOptions(marketSegmentFiltersRequest);
            var response = ((OkObjectResult)result).Value;
            var marketSegmentFiltersResponse = response as List<SurveyCutFilterFlatOption>;

            // Assert
            Assert.IsInstanceOf<OkObjectResult>(result);
            Assert.That(response, Is.EqualTo(marketSegmentFilters));
            Assert.NotNull(marketSegmentFiltersResponse);
            Assert.That(marketSegmentFiltersResponse.Count(), Is.EqualTo(marketSegmentFilters.Count()));

            _surveyCutsRepository.Verify(x => x.ListSurveyCutFilterFlatOptions(marketSegmentFiltersRequest), Times.Once);
        }

        [Test]
        public async Task GetMarketSegmentSurveyDetails_ReturnsOkObjectResult_WhenRepositoryReturnsMarketSegmentSurveyDetails()
        {
            // Arrange
            var request = new SurveyCutsRequest();
            var surveyCutsData = new List<Domain.Response.SurveyCutsDataResponse> { new Domain.Response.SurveyCutsDataResponse() };
            _surveyCutsRepository.Setup(x => x.ListSurveyCuts(request)).ReturnsAsync(new Domain.Response.SurveyCutsDataListResponse { SurveyCutsData = surveyCutsData });

            // Act
            var result = await _controller.GetMarketSegmentSurveyDetails(request);
            var response = ((OkObjectResult)result).Value;
            var surveyDetailsResponse = response as List<Domain.Response.SurveyCutsDataResponse>;

            // Assert
            Assert.IsInstanceOf<OkObjectResult>(result);
            Assert.That(response, Is.EqualTo(surveyCutsData));
            Assert.NotNull(surveyDetailsResponse);
            Assert.That(surveyDetailsResponse.Count(), Is.EqualTo(surveyCutsData.Count()));

            _surveyCutsRepository.Verify(x => x.ListSurveyCuts(request), Times.Once);
        }

        [Test]
        public async Task GetMarketSegmentSelectedCuts_ReturnsOkObjectResult_WhenRepositoryReturnsMarketSegmentCuts()
        {
            // Arrange
            var request = new SurveyCutsRequest();
            var surveyCutsData = new List<Domain.Response.SurveyCutsDataResponse> 
            {
                new Domain.Response.SurveyCutsDataResponse
                {
                    IndustrySectorKey = 1,
                    IndustrySectorName = "Industry One",
                    OrganizationTypeKey = 2,
                    OrganizationTypeName = "Organization One",
                    CutGroupKey = 3,
                    CutGroupName= "Cut Group One",
                    CutSubGroupKey = 4,
                    CutSubGroupName= "Cut Sub Group One"
                },
                new Domain.Response.SurveyCutsDataResponse
                {
                    IndustrySectorKey = 5,
                    IndustrySectorName = "Industry One",
                    OrganizationTypeKey = 6,
                    OrganizationTypeName = "Organization One",
                    CutGroupKey = 7,
                    CutGroupName= "Cut Group One",
                    CutSubGroupKey = 8,
                    CutSubGroupName= "Cut Sub Group One"
                }
            };

            _surveyCutsRepository.Setup(x => x.ListSurveyCuts(request)).ReturnsAsync(new Domain.Response.SurveyCutsDataListResponse { SurveyCutsData = surveyCutsData });

            // Act
            var result = await _controller.GetMarketSegmentSelectedCuts(request);
            var response = ((OkObjectResult)result).Value;
            var marketSegmentResponse = response as IEnumerable<SurveyCut>;

            // Assert
            Assert.IsInstanceOf<OkObjectResult>(result);
            Assert.NotNull(marketSegmentResponse);
            Assert.That(marketSegmentResponse.Count(), Is.EqualTo(1));
            Assert.That(marketSegmentResponse.First().SurveyDetails, Is.EqualTo(surveyCutsData));
            Assert.That(marketSegmentResponse.First().SurveyDetails.Count, Is.EqualTo(surveyCutsData.Count));

            _surveyCutsRepository.Verify(x => x.ListSurveyCuts(request), Times.Once);
        }
    }
}
