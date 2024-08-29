using AutoMapper;
using Cn.Survey;
using CN.Survey.Domain;
using CN.Survey.Domain.Request;
using CN.Survey.Domain.Response;
using CN.Survey.GrpcServer;
using CN.Survey.GrpcServer.Services;
using Grpc.Core;
using Grpc.Core.Testing;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;

namespace CN.Survey.Tests
{
    [TestFixture]
    public class SurveyGrpcServiceTest
    {
        ServerCallContext _context;
        Mock<ILogger<SurveyGrpcService>> _mockLogger;
        IMapper _mapper;
        Mock<IBenchmarkDataTypeRepository> _benchmarkDataTypeRepository;
        Mock<ISurveyCutsRepository> _surveyCutsRepository;

        private SurveyGrpcService _grpcService;
        private List<BenchmarkDataType> _benchmarkDataTypes;
        private List<Domain.Response.MarketPercentileSet> _percentiles;
        private Domain.Response.SurveyCutsDataListResponse _surveyCutsDataListResponse;

        [SetUp]
        public void Setup()
        {
            _mockLogger = new Mock<ILogger<SurveyGrpcService>>();
            _benchmarkDataTypeRepository = new Mock<IBenchmarkDataTypeRepository>();
            _surveyCutsRepository = new Mock<ISurveyCutsRepository>();
            _mapper = MappingConfig.RegisterMaps().CreateMapper();

            _grpcService = new SurveyGrpcService(_mockLogger.Object, _mapper, _benchmarkDataTypeRepository.Object, _surveyCutsRepository.Object);
            _context = TestServerCallContext.Create(
                                            method: nameof(SurveyGrpcService.ListSurveyCuts)
                                           , host: "localhost"
                                           , deadline: DateTime.Now.AddMinutes(5)
                                           , requestHeaders: new Metadata()
                                           , cancellationToken: CancellationToken.None
                                           , peer: "10.0.0.25:5001"
                                           , authContext: null
                                           , contextPropagationToken: null
                                           , writeHeadersFunc: (metadata) => Task.CompletedTask
                                           , writeOptionsGetter: () => new WriteOptions()
                                           , writeOptionsSetter: (writeOptions) => { }
            );

            _surveyCutsDataListResponse = new Domain.Response.SurveyCutsDataListResponse
            {
                SurveyCutsData = new List<SurveyCutsDataResponse>
                {
                    new SurveyCutsDataResponse
                    {
                        SurveyYear = DateTime.Now.Year,
                        SurveyPublisherName = "Publisher Test",
                        SurveyPublisherKey = 1,
                        SurveyName = "Survey Test",
                        SurveyKey = 2,
                        IndustrySectorName = "Industry Test",
                        IndustrySectorKey = 3,
                        OrganizationTypeName = "Organization Test",
                        OrganizationTypeKey = 4,
                        CutGroupName = "CutGroup Test",
                        CutGroupKey = 5,
                        CutSubGroupName = "CutSubGroup Test",
                        CutSubGroupKey = 6,
                        CutName = "Cut Test",
                        CutKey = 7,
                        SurveyCode = "Test",
                        StandardJobCode = "3030",
                        StandardJobTitle = "Certified Registered Nurse Anesthetist",
                        SurveySpecialtyCode = "3030",
                        SurveySpecialtyName = "Certified Registered Nurse Anesthetis",
                        BenchmarkDataTypeKey = 29,
                        BenchmarkDataTypeName = "Base Pay Hourly Rate",
                        FooterNotes = $"Sullivan, Cotter and Associates, Incorporated (SullivanCotter): {DateTime.Now.Year} Physician Compensation and Productivity Survey Report"
                    }
                }
            };

            _benchmarkDataTypes = new List<BenchmarkDataType> { new BenchmarkDataType { ID = 1, Name = "Benchmark Test" } };

            _percentiles = new List<Domain.Response.MarketPercentileSet> { new Domain.Response.MarketPercentileSet { Percentile = 10, MarketValue = 50 } };

            _surveyCutsRepository.Setup(x => x.ListSurveyCuts()).ReturnsAsync(_surveyCutsDataListResponse);
            _benchmarkDataTypeRepository.Setup(x => x.GetBenchmarkDataTypes(It.IsAny<int>())).ReturnsAsync(_benchmarkDataTypes);
            _surveyCutsRepository.Setup(x => x.ListPercentiles(It.IsAny<Domain.Request.SurveyCutsRequest>())).ReturnsAsync(_percentiles);
            _surveyCutsRepository.Setup(x => x.ListAllPercentilesByStandardJobCode(It.IsAny<Domain.Request.SurveyCutsRequest>())).ReturnsAsync(_percentiles);
            _surveyCutsRepository.Setup(x => x.ListSurveyCutsDataWithPercentiles(It.IsAny<Domain.Request.SurveyCutsRequest>())).ReturnsAsync(_surveyCutsDataListResponse);
        }

        [Test]
        public async Task ListSurveyCuts()
        {
            // Act
            var response = await _grpcService.ListSurveyCuts(new Cn.Survey.SurveyCutsRequest { }, _context);

            // Assert
            Assert.That(response.SurveyYears.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.SurveyPublisherNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.SurveyNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.IndustrySectorNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.OrganizationTypeNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.CutGroupNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.CutSubGroupNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
            Assert.That(response.CutNameKeysets.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
        }

        [Test]
        public async Task ListBenchmarkDataTypeName()
        {
            // Act
            var response = await _grpcService.ListBenchmarkDataType(new Cn.Survey.ListBenchmarkDataTypeRequest { }, _context);

            // Assert
            Assert.NotNull(response);
            Assert.NotNull(response.BenchmarkDataTypes);
            Assert.IsNotEmpty(response.BenchmarkDataTypes);
            Assert.That(response.BenchmarkDataTypes.Count, Is.EqualTo(_benchmarkDataTypes.Count));
        }

        [Test]
        public async Task ListPercentiles()
        {
            // Act
            var response = await _grpcService.ListPercentiles(new Cn.Survey.ListPercentilesRequest { }, _context);

            // Assert
            Assert.NotNull(response);
            Assert.NotNull(response.MarketValueByPercentile);
            Assert.IsNotEmpty(response.MarketValueByPercentile);
            Assert.That(response.MarketValueByPercentile.Count, Is.EqualTo(_percentiles.Count));
        }

        [Test]
        public async Task ListAllPercentilesByStandardJobCode()
        {
            // Act
            var response = await _grpcService.ListAllPercentilesByStandardJobCode(new Cn.Survey.ListPercentilesRequest { }, _context);

            // Assert
            Assert.NotNull(response);
            Assert.NotNull(response.MarketValueByPercentile);
            Assert.IsNotEmpty(response.MarketValueByPercentile);
            Assert.That(response.MarketValueByPercentile.Count, Is.EqualTo(_percentiles.Count));
        }

        [Test]
        public async Task ListSurveyCutsDataWithPercentiles()
        {
            // Act
            var response = await _grpcService.ListSurveyCutsDataWithPercentiles(new Cn.Survey.ListPercentilesRequest { }, _context);

            // Assert
            Assert.NotNull(response);
            Assert.NotNull(response.SurveyCutsData);
            Assert.IsNotEmpty(response.SurveyCutsData);
            Assert.That(response.SurveyCutsData.Count, Is.EqualTo(_surveyCutsDataListResponse.SurveyCutsData.Count));
        }
    }
}
