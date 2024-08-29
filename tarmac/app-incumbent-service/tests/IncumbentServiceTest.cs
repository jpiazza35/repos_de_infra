using AutoMapper;
using Cn.Incumbent.V1;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using CN.Incumbent.GrpcServer;
using CN.Organization.GrpcServer;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core;
using Grpc.Core.Testing;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;

namespace CN.Incumbent.Test
{
    [TestFixture]
    public class IncumbentServiceTest
    {
        ServerCallContext _context;
        private Mock<ILogger<IncumbentService>> _logger;
        private Mock<IFileRepository> _fileRepository;
        private Mock<ISourceDataRepository> _sourceDataRepository;
        private IncumbentService _service;
        private List<FileLogDto> _files;
        private List<SourceData> _sourceDatas;
        private List<SourceDataEmployeeLevel> _employees;
        private IMapper _mapper;

        [SetUp]
        public void Setup()
        {
            _logger = new Mock<ILogger<IncumbentService>>();
            _fileRepository = new Mock<IFileRepository>();
            _sourceDataRepository = new Mock<ISourceDataRepository>();
            _mapper = MappingConfig.RegisterMaps().CreateMapper();

            _service = new IncumbentService(_fileRepository.Object, _sourceDataRepository.Object, _mapper, _logger.Object);
            _context = TestServerCallContext.Create(
                                                    method: nameof(IncumbentService.ListFilesByIds)
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

            _files = new List<FileLogDto>
            {
                new ()
                {
                    FileLogKey = 1,
                    OrganizationId = 90,
                    ClientFileName = "Test_file_1.csv",
                    FileS3Name = "c95acf47-1980-4817-8194-d72e8d997afe.csv",
                    FileStatusKey = 2,
                    SourceDataName = "Job",
                    EffectiveDate =  new DateTime(2023, 03, 28),
                    FileStatusName = "Upload"
                },
                new ()
                {
                    FileLogKey = 2,
                    OrganizationId = 90,
                    ClientFileName = "Test_file_2.csv",
                    FileS3Name = "2d56083b-2f11-475b-beef-37127de52ae0.csv",
                    FileStatusKey = 1,
                    SourceDataName = "Incumbent",
                    EffectiveDate =  new DateTime(2022, 03, 28),
                    FileStatusName = "Started"
                }
            };
            _sourceDatas = new List<SourceData>
            {
                new SourceData
                {
                    AggregationMethodKey = 1,
                    FileLogKey = 1,
                    FileOrgKey = 90,
                    JobCode =  "2.52",
                    JobTitle = "Cardiology",
                    ClientJobGroup = "Group 1",
                    BenchmarkDataTypeKey = 1,
                },
                new SourceData
                {
                    AggregationMethodKey = 1,
                    FileLogKey = 1,
                    FileOrgKey = 90,
                    JobCode =  "3.51",
                    JobTitle = "Pediatry",
                    ClientJobGroup = "Group 2",
                    BenchmarkDataTypeKey = 29,
                    BenchmarkDataTypeValue = 3.8F
                }
            };

            _employees = new List<SourceDataEmployeeLevel>
            {
                new SourceDataEmployeeLevel
                {
                    SourceDataKey = 1,
                    FileLogKey = 2,
                    SourceDataName = "Test Source Name",
                    FileOrgKey = 3,
                    CesOrgId = 4,
                    CesOrgName = "Test Org Name",
                    JobCode = "Job Code 5",
                    JobTitle = "Test Job Title",
                    IncumbentId = "Test Incumbent Id",
                    IncumbentName = "Test Incumbent Name",
                    FteValue = 5,
                    ClientJobGroup = "Test Client Job Group",
                    PositionCode = "Test Position Code",
                    PositionCodeDescription = "Test Position Code Description",
                    JobLevel = "Test Job Level",
                    BenchmarkDataTypes = new Dictionary<int, float>
                    {
                        { 1, 1.1F },
                        { 2, 2.1F }
                    }
                },
                new SourceDataEmployeeLevel
                {
                    SourceDataKey = 2,
                    FileLogKey = 2,
                    SourceDataName = "Test Source Name",
                    FileOrgKey = 3,
                    CesOrgId = 4,
                    CesOrgName = "Test Org Name",
                    JobCode = "Test Job Code 2",
                    JobTitle = "Test Job Title 2",
                    IncumbentId = "Test Incumbent Id 2",
                    IncumbentName = "Test Incumbent Name 2",
                    FteValue = 5,
                    ClientJobGroup = "Test Client Job Group",
                    PositionCode = "Test Position Code 2",
                    PositionCodeDescription = "Test Position Code Description 2",
                    JobLevel = "Test Job Level 2",
                    BenchmarkDataTypes = new Dictionary<int, float>
                    {
                        { 1, 1.2F },
                        { 2, 2.2F }
                    }
                },
            };

            _fileRepository.Setup(x => x.GetFilesByIds(It.IsAny<List<int>>())).ReturnsAsync(_files);
            _sourceDataRepository.Setup(x => x.ListClientBasePay(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<IEnumerable<string>>(), It.IsAny<IEnumerable<int>>()))
                .ReturnsAsync(_sourceDatas);
            _sourceDataRepository.Setup(x => x.ListClientJobs(It.IsAny<int>(), It.IsAny<int>()))
               .ReturnsAsync(_sourceDatas);
            _sourceDataRepository.Setup(x => x.ListSourceDataEmployeeLevel(It.IsAny<int>())).ReturnsAsync(_employees);
        }

        [Test]
        public async Task ListFilesByIds()
        {
            // Arrange
            var fileSearchRequest = new FileIdsRequest { };
            fileSearchRequest.FileIds.AddRange(new List<int>(new int[] { 1, 2 }));

            var expectedFile_1 = _files.Find(x => x.FileLogKey == 1);
            var expectedFile_2 = _files.Find(x => x.FileLogKey == 2);

            // Act
            var response = await _service.ListFilesByIds(fileSearchRequest, _context);

            // Assert
            Assert.Multiple(() =>
            {
                Assert.That(response.Files.Count, Is.EqualTo(2));
                Assert.That(response.Files[0].FileLogKey, Is.EqualTo(expectedFile_1?.FileLogKey));
                Assert.That(response.Files[0].FileOrgKey, Is.EqualTo(expectedFile_1?.OrganizationId));
                Assert.That(response.Files[0].DataEffectiveDate, Is.EqualTo(Timestamp.FromDateTime(expectedFile_1?.EffectiveDate.ToUniversalTime() ?? DateTime.Now.ToUniversalTime())));
                Assert.That(response.Files[0].FileStatusKey, Is.EqualTo(expectedFile_1?.FileStatusKey));
                Assert.That(response.Files[0].SourceDataName, Is.EqualTo(expectedFile_1?.SourceDataName));

                Assert.That(response.Files[1].FileLogKey, Is.EqualTo(expectedFile_2?.FileLogKey));
                Assert.That(response.Files[1].FileOrgKey, Is.EqualTo(expectedFile_2?.OrganizationId));
                Assert.That(response.Files[1].DataEffectiveDate, Is.EqualTo(Timestamp.FromDateTime(expectedFile_2?.EffectiveDate.ToUniversalTime() ?? DateTime.Now.ToUniversalTime())));
                Assert.That(response.Files[1].FileStatusKey, Is.EqualTo(expectedFile_2?.FileStatusKey));
                Assert.That(response.Files[1].SourceDataName, Is.EqualTo(expectedFile_2?.SourceDataName));
            });
        }

        [Test]
        public async Task ListClientBasePay()
        {
            // Arrange
            var jobCode = _sourceDatas.Select(b => b.JobCode).First();
            var benchMarkDataTypes = _sourceDatas.Select(b => b.BenchmarkDataTypeKey);
            var clientBasePayRequest = new ClientBasePayRequest
            {
                FileLogKey = 1,
                AggregationMethodKey = 1,
                JobCodes = { jobCode },
                BenchmarkDataTypeKeys = { benchMarkDataTypes }
            };

            // Act
            var response = await _service.ListClientBasePay(clientBasePayRequest, _context);

            // Assert
            Assert.Multiple(() =>
            {
                Assert.IsNotNull(response);
                Assert.IsNotNull(response.ClientBasePayLists);
                Assert.IsNotEmpty(response.ClientBasePayLists);
                Assert.That(response.ClientBasePayLists.Count, Is.EqualTo(_sourceDatas.Count));
                Assert.That(response.ClientBasePayLists[0].JobCode, Is.EqualTo(_sourceDatas[0].JobCode));
                Assert.That(response.ClientBasePayLists[0].BenchmarkDataTypeKey, Is.EqualTo(_sourceDatas[0].BenchmarkDataTypeKey));

                Assert.That(response.ClientBasePayLists[1].JobCode, Is.EqualTo(_sourceDatas[1].JobCode));
                Assert.That(response.ClientBasePayLists[1].BenchmarkDataTypeKey, Is.EqualTo(_sourceDatas[1].BenchmarkDataTypeKey));
                Assert.That(response.ClientBasePayLists[1].BenchmarkDataTypeValue, Is.EqualTo(_sourceDatas[1].BenchmarkDataTypeValue));
            });
        }

        [Test]
        public async Task ListClientJobs()
        {
            // Arrange
            var jobCode = _sourceDatas.Select(b => b.JobCode).First();
            var benchMarkDataTypes = _sourceDatas.Select(b => b.BenchmarkDataTypeKey);
            var sourceDataSearch = new SourceDataSearchRequest
            {
                FileLogKey = 1,
                AggregationMethodKey = 1,
            };

            // Act
            var sourceDataList = await _service.ListClientJobs(sourceDataSearch, _context);

            // Assert
            Assert.Multiple(() =>
            {
                Assert.IsNotNull(sourceDataList);

                Assert.IsNotEmpty(sourceDataList.ClientJobs);
                Assert.That(sourceDataList.ClientJobs.Count, Is.EqualTo(_sourceDatas.Count));
                Assert.That(sourceDataList.ClientJobs[0].JobCode, Is.EqualTo(_sourceDatas[0].JobCode));
                Assert.That(sourceDataList.ClientJobs[0].JobTitle, Is.EqualTo(_sourceDatas[0].JobTitle));
                Assert.That(sourceDataList.ClientJobs[0].ClientJobGroup, Is.EqualTo(_sourceDatas[0].ClientJobGroup));
                Assert.That(sourceDataList.ClientJobs[1].JobCode, Is.EqualTo(_sourceDatas[1].JobCode));
                Assert.That(sourceDataList.ClientJobs[1].JobTitle, Is.EqualTo(_sourceDatas[1].JobTitle));
                Assert.That(sourceDataList.ClientJobs[1].ClientJobGroup, Is.EqualTo(_sourceDatas[1].ClientJobGroup));
            });
        }

        [Test]
        public async Task ListClientPayDetail()
        {
            // Arrange
            var sourceData = new List<SourceData>
            {
                new SourceData
                {
                    AggregationMethodKey = 1,
                    FileLogKey = 1,
                    FileOrgKey = 90,
                    JobCode =  "3.51",
                    JobTitle = "Pediatry",
                    ClientJobGroup = "Group 2",
                    BenchmarkDataTypeKey = 29,
                    BenchmarkDataTypeValue = 3.8F
                }
            };
            var benchMarkDataTypes = sourceData.Select(b => b.BenchmarkDataTypeKey);

            var clientPayDetailRequest = new ClientJobRequest
            {
                FileLogKey = 1,
                AggregationMethodKey = 1,
                FileOrgKey = 90,
                JobCode = "2.51",
                PositionCode = "",
                BenchmarkDataTypeKeys = { benchMarkDataTypes }
            };

            _sourceDataRepository.Setup(x => x.ListClientPayDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<IEnumerable<int>>()))
                .ReturnsAsync(sourceData);

            // Act
            var clientPayDetails = await _service.ListClientPayDetail(clientPayDetailRequest, _context);

            // Assert
            Assert.Multiple(() =>
            {
                Assert.IsNotNull(clientPayDetails);

                Assert.IsNotEmpty(clientPayDetails.ClientPayDetails);
                Assert.That(clientPayDetails.ClientPayDetails.Count, Is.EqualTo(sourceData.Count));
                Assert.That(clientPayDetails.ClientPayDetails[0].BenchmarkDataTypeKey, Is.EqualTo(sourceData[0].BenchmarkDataTypeKey));
                Assert.That(clientPayDetails.ClientPayDetails[0].BenchmarkDataTypeValue, Is.EqualTo(sourceData[0].BenchmarkDataTypeValue));
            });
        }

        [Test]
        public async Task UploadMarketPricingSheetPdfFile()
        {
            // Arrange
            var fileByteArray = new byte[0];
            var fileLogResponseDto = new FileLogResponseDto
            {
                FileS3Name = "File Test",
                Success = true,
            };

            var uploadMarketPricingSheetPdfFileRequest = new UploadMarketPricingSheetPdfFileRequest
            {
                File = Google.Protobuf.ByteString.CopyFrom(fileByteArray),
                OrganizationId = 90,
                OrganizationName = "Organization Test",
                ProjectVersionId = 3,
                ReportDate = Timestamp.FromDateTime(DateTime.Now.ToUniversalTime()),
            };

            _fileRepository.Setup(x => x.UploadMarketPricingSheetPdfFile(It.IsAny<byte[]>(), It.IsAny<MarketPricingSheetPdfDto>())).ReturnsAsync(fileLogResponseDto);

            // Act
            var result = await _service.UploadMarketPricingSheetPdfFile(uploadMarketPricingSheetPdfFileRequest, _context);

            // Assert
            Assert.IsNotNull(result);
            Assert.That(fileLogResponseDto.Success, Is.EqualTo(result.Success));
            Assert.That(fileLogResponseDto.FileS3Name, Is.EqualTo(result.FileS3Name));
        }

        [Test]
        public async Task ListClientPositionDetail()
        {
            // Arrange
            var clientJobs = new List<SourceData>
            {
                new SourceData
                {
                    AggregationMethodKey = 1,
                    FileLogKey = 1,
                    FileOrgKey = 90,
                    JobCode =  "2.52",
                    JobTitle = "Cardiology",
                    PositionCode = "3.001",
                    ClientJobGroup = "Group 1",
                    FteValue = 3,
                    IncumbentCount = 10,
                    JobFamily = "Physicians"
                }
            };

            var clientJobRequest = new ClientJobRequest
            {
                FileLogKey = 1,
                AggregationMethodKey = 1,
                FileOrgKey = 90,
                JobCode = "2.52",
                PositionCode = "3.001"
            };

            _sourceDataRepository.Setup(x => x.ListClientPositionDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()))
                .ReturnsAsync(clientJobs);

            // Act
            var clientPositionDetail = await _service.ListClientPositionDetail(clientJobRequest, _context);

            // Assert
            Assert.Multiple(() =>
            {
                Assert.IsNotNull(clientPositionDetail);
                Assert.IsNotEmpty(clientPositionDetail.ClientJobs);
                Assert.That(clientPositionDetail.ClientJobs.Count, Is.EqualTo(clientJobs.Count));
                Assert.That(clientPositionDetail.ClientJobs[0].JobCode, Is.EqualTo(clientJobs[0].JobCode));
                Assert.That(clientPositionDetail.ClientJobs[0].JobTitle, Is.EqualTo(clientJobs[0].JobTitle));
                Assert.That(clientPositionDetail.ClientJobs[0].PositionCode, Is.EqualTo(clientJobs[0].PositionCode));
                Assert.That(clientPositionDetail.ClientJobs[0].ClientJobGroup, Is.EqualTo(clientJobs[0].ClientJobGroup));
                Assert.That(clientPositionDetail.ClientJobs[0].FteValue, Is.EqualTo(clientJobs[0].FteValue));
                Assert.That(clientPositionDetail.ClientJobs[0].IncumbentCount, Is.EqualTo(clientJobs[0].IncumbentCount));
                Assert.That(clientPositionDetail.ClientJobs[0].JobFamily, Is.EqualTo(clientJobs[0].JobFamily));
                _sourceDataRepository.Verify(x => x.ListClientPositionDetail(It.IsAny<int>(), It.IsAny<int>(), It.IsAny<string>(), It.IsAny<string>(), It.IsAny<int>()), Times.Once());
            });
        }

        [Test]
        public async Task ListSourceDataEmployeeLevel_Succes()
        {
            #region arrange
            var sourceDataSearch = new SourceDataSearchRequest
            {
                FileLogKey = 1,
            };
            #endregion

            #region act
            var result = await _service.ListSourceDataEmployeeLevel(sourceDataSearch, _context);
            #endregion

            #region assert
            Assert.IsTrue(result.Employees.Any());
            Assert.IsTrue(result.Employees.Count == 2);

            Assert.IsTrue(result.Employees[0].SourceDataKey == _employees[0].SourceDataKey);
            Assert.IsTrue(result.Employees[0].SourceDataName == _employees[0].SourceDataName);
            Assert.IsTrue(result.Employees[0].FileLogKey == _employees[0].FileLogKey);
            Assert.IsTrue(result.Employees[0].FileOrgKey == _employees[0].FileOrgKey);
            Assert.IsTrue(result.Employees[0].CesOrgId == _employees[0].CesOrgId);
            Assert.IsTrue(result.Employees[0].CesOrgName == _employees[0].CesOrgName);
            Assert.IsTrue(result.Employees[0].JobCode == _employees[0].JobCode);
            Assert.IsTrue(result.Employees[0].JobTitle == _employees[0].JobTitle);
            Assert.IsTrue(result.Employees[0].IncumbentId == _employees[0].IncumbentId);
            Assert.IsTrue(result.Employees[0].IncumbentName == _employees[0].IncumbentName);
            Assert.IsTrue(result.Employees[0].FteValue == _employees[0].FteValue);
            Assert.IsTrue(result.Employees[0].ClientJobGroup == _employees[0].ClientJobGroup);
            Assert.IsTrue(result.Employees[0].PositionCode == _employees[0].PositionCode);
            Assert.IsTrue(result.Employees[0].PositionCodeDescription == _employees[0].PositionCodeDescription);
            Assert.IsTrue(result.Employees[0].JobLevel == _employees[0].JobLevel);
            Assert.IsTrue(result.Employees[0].BenchmarkDataTypes.Count == _employees[0].BenchmarkDataTypes.Count);
            Assert.IsTrue(result.Employees[0].BenchmarkDataTypes[1] == _employees[0].BenchmarkDataTypes[1]);
            #endregion
        }
    }
}
