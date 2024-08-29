using CN.Project.Domain.Models;
using CN.Project.Domain.Models.Dto;
using CN.Project.Domain.Models.Dto.MarketSegment;
using CN.Project.Infrastructure.Repositories.MarketSegment;
using CN.Project.Infrastructure.Repository;
using CN.Project.RestApi.Controllers;
using CN.Project.RestApi.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Moq;
using NUnit.Framework;
using System.Security.Claims;
using System.Security.Cryptography;

namespace CN.Project.Test
{
    [TestFixture]
    public class MarketSegmentControllerTest
    {
        private Mock<IMarketSegmentRepository> _marketSegmentRepository;
        private Mock<ICombinedAveragesRepository> _combinedAveragesRepository;
        private MarketSegmentService _marketSegmentService;
        private MarketSegmentController _marketSegmentController;

        private List<Claim> _claims;

        [SetUp]
        public void Setup()
        {
            _claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Role, "WRITE"),
                new Claim(ClaimTypes.Name, "TestUser")
            };

            _marketSegmentRepository = new Mock<IMarketSegmentRepository>();
            _combinedAveragesRepository = new Mock<ICombinedAveragesRepository>();
            _marketSegmentService = new MarketSegmentService(_marketSegmentRepository.Object, _combinedAveragesRepository.Object);
            _marketSegmentController = new MarketSegmentController(_marketSegmentService);
            _marketSegmentController.ControllerContext = GetControllerContext();
        }

        private ControllerContext GetControllerContext()
        {
            var identity = new ClaimsIdentity(_claims, "TestAuthType");
            var user = new ClaimsPrincipal(identity);

            return new ControllerContext
            {
                HttpContext = new DefaultHttpContext
                {
                    User = user
                }
            };
        }

        [Test]
        public async Task SaveMarketSegment_Success_ValidResult()
        {
            //Act
            var marketSegmentId = 1;
            var marketSegmentCutKey = 1;
            var marketSegmentDto = new MarketSegmentDto
            {
                Id = marketSegmentId,
                Cuts = new List<MarketSegmentCutDto>
                {
                    new MarketSegmentCutDto
                    {
                        MarketSegmentId = marketSegmentId,
                        MarketSegmentCutKey = marketSegmentCutKey,
                        CutDetails = new List<MarketSegmentCutDetailDto>
                        {
                            new MarketSegmentCutDetailDto { MarketSegmentCutKey = marketSegmentCutKey }
                        }
                    }
                }
            };

            _marketSegmentRepository.Setup(x => x.SaveMarketSegment(It.IsAny<MarketSegmentDto>(), It.IsAny<string>())).ReturnsAsync(marketSegmentDto.Id);
            _marketSegmentRepository.Setup(x => x.GetMarketSegment(It.IsAny<int>())).ReturnsAsync(marketSegmentDto);
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(new SurveyCutDto());

            var response = await _marketSegmentController.SaveMarketSegment(new MarketSegmentDto()) as OkObjectResult;
            var dataResponse = response?.Value as MarketSegmentDto;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.IsNotNull(dataResponse.Cuts);
            Assert.IsNotEmpty(dataResponse.Cuts);
            Assert.IsTrue(dataResponse.Cuts.All(c => c.MarketSegmentId == dataResponse.Id));
            Assert.IsTrue(dataResponse.Cuts.All(c => c.CutDetails != null && c.CutDetails.Any() && c.CutDetails.All(cd => cd.MarketSegmentCutKey == c.MarketSegmentCutKey)));
        }

        [Test]
        public async Task EditMarketSegment_Fail_NotFoundResult()
        {
            //Act
            var marketSegmentDto = new MarketSegmentDto { Id = 0 };

            var response = await _marketSegmentController.EditMarketSegment(marketSegmentDto) as NotFoundResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 404);
        }

        [Test]
        public async Task EditMarketSegment_Fail_InvalidResult()
        {
            //Act
            var marketSegmentDto = new MarketSegmentDto { Id = 1 };
            _marketSegmentRepository.Setup(x => x.GetMarketSegment(It.IsAny<int>())).ReturnsAsync(null as MarketSegmentDto);

            var response = await _marketSegmentController.EditMarketSegment(marketSegmentDto) as BadRequestResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
        }

        [Test]
        public async Task EditMarketSegment_Success_ValidResult()
        {
            //Act
            var marketSegmentId = 1;
            var existingMarketSegmentCutKey = 1;
            var newMarketSegmentCutKey = 2;
            var existingCut = new MarketSegmentCutDto { MarketSegmentId = marketSegmentId, CutName = "CutOne", MarketSegmentCutKey = existingMarketSegmentCutKey };
            var existingMarketSegmentDto = new MarketSegmentDto
            {
                Id = marketSegmentId,
                Cuts = new List<MarketSegmentCutDto> { existingCut }
            };
            var newCut = new MarketSegmentCutDto { MarketSegmentId = marketSegmentId, CutName = "CutTwo", MarketSegmentCutKey = newMarketSegmentCutKey };
            var newMarketSegmentDto = new MarketSegmentDto
            {
                Id = marketSegmentId,
                Cuts = new List<MarketSegmentCutDto> { existingCut, newCut }
            };

            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegment(It.IsAny<int>()))
                .ReturnsAsync(existingMarketSegmentDto)
                .ReturnsAsync(newMarketSegmentDto);
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCut(It.IsAny<int>()))
                .ReturnsAsync(new List<MarketSegmentCutDto> { existingCut })
                .ReturnsAsync(new List<MarketSegmentCutDto> { existingCut, newCut });
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCutDetail(It.IsAny<List<int>>()))
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { new MarketSegmentCutDetailDto { MarketSegmentCutKey = existingMarketSegmentCutKey } })
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { new MarketSegmentCutDetailDto { MarketSegmentCutKey = existingMarketSegmentCutKey } })
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { new MarketSegmentCutDetailDto { MarketSegmentCutKey = newMarketSegmentCutKey } });
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(new SurveyCutDto());

            var response = await _marketSegmentController.EditMarketSegment(newMarketSegmentDto) as OkObjectResult;
            var dataResponse = response?.Value as MarketSegmentDto;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.IsNotNull(dataResponse.Cuts);
            Assert.IsNotEmpty(dataResponse.Cuts);
            Assert.IsTrue(dataResponse.Cuts.All(c => c.MarketSegmentId == dataResponse.Id));
        }

        [Test]
        public async Task SaveMarketSegmentEri_Success_ValidResult()
        {
            //Act
            var cutGroupKey = 1;
            var marketSegmentDto = new MarketSegmentDto { Id = 1, EriAdjustmentFactor = 1, EriCutName = "ERI NAME", EriCity = "New York" };
            var marketSegmentCutDto = new MarketSegmentCutDto { MarketSegmentId = marketSegmentDto.Id, MarketSegmentCutKey = 1, CutGroupKey = cutGroupKey };
            var marketSegmentCutDetailDto = new MarketSegmentCutDetailDto { MarketSegmentCutKey = marketSegmentCutDto.MarketSegmentCutKey, CutGroupKey = cutGroupKey };

            marketSegmentCutDto.CutDetails = new List<MarketSegmentCutDetailDto> { marketSegmentCutDetailDto };
            marketSegmentDto.Cuts = new List<MarketSegmentCutDto> { marketSegmentCutDto };

            _marketSegmentRepository.Setup(x => x.GetMarketSegment(It.IsAny<int>())).ReturnsAsync(marketSegmentDto);
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCut(It.IsAny<int>()))
                .ReturnsAsync(new List<MarketSegmentCutDto> { marketSegmentCutDto })
                .ReturnsAsync(new List<MarketSegmentCutDto> { marketSegmentCutDto });
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCutDetail(It.IsAny<List<int>>()))
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { marketSegmentCutDetailDto })
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { marketSegmentCutDetailDto });
            _marketSegmentRepository.SetupSequence(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>()))
                .ReturnsAsync(
                    new SurveyCutDto
                    {
                        CutGroups = new List<NameKeyDto> { new NameKeyDto { Keys = new List<int> { cutGroupKey }, Name = Domain.Constants.Constants.NATIONAL_GROUP_NAME } }
                    })
                .ReturnsAsync(
                    new SurveyCutDto
                    {
                        CutGroups = new List<NameKeyDto> { new NameKeyDto { Keys = new List<int> { cutGroupKey }, Name = Domain.Constants.Constants.NATIONAL_GROUP_NAME } }
                    });

            var response = await _marketSegmentController.SaveMarketSegmentEri(marketSegmentDto.Id, marketSegmentDto) as OkObjectResult;
            var dataResponse = response?.Value as MarketSegmentDto;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse, Is.EqualTo(marketSegmentDto));
        }

        [Test]
        public async Task SaveMarketSegmentEri_Fail_EriNameOnUse()
        {
            #region Arrange
            var marketSegmentDto = new MarketSegmentDto { Id = 1, EriAdjustmentFactor = 1, EriCutName = "ERI NAME", EriCity = "New York" };
            var mockResponse = new NameAmount { Name = "Test", Amount = 1 };
            _marketSegmentRepository.Setup(x => x.CheckCurrentEriNameOnUSe(It.IsAny<int>())).ReturnsAsync(mockResponse);
            #endregion

            #region Act
            var response = await _marketSegmentController.SaveMarketSegmentEri(marketSegmentDto.Id, marketSegmentDto) as BadRequestObjectResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(response.Value, Is.EqualTo("Can't be updated the 'Eri Cut Name' because is already in use on a 'Combined Averages'."));
            #endregion
        }

        [Test]
        public async Task SaveMarketSegmentBlend_Fail_InvalidResult()
        {
            //Act
            var marketSegmentId = 0;

            var response = await _marketSegmentController.SaveMarketSegmentBlend(marketSegmentId, new MarketSegmentBlendDto()) as BadRequestResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
        }

        [Test]
        public async Task SaveMarketSegmentBlend_Success_ValidResult()
        {
            //Act
            var marketSegmentId = 1;
            var cutKey = 1;
            var blendCuts = new List<MarketSegmentBlendCutDto> { new MarketSegmentBlendCutDto { ParentMarketSegmentCutKey = cutKey } };
            var blend = new MarketSegmentBlendDto { MarketSegmentCutKey = cutKey, Cuts = blendCuts };

            _marketSegmentRepository.Setup(x => x.GetMarketSegment(It.IsAny<int>())).ReturnsAsync(new MarketSegmentDto { Id = marketSegmentId, Blends = new List<MarketSegmentBlendDto> { blend } });
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentCut(It.IsAny<int>()))
                .ReturnsAsync(new List<MarketSegmentCutDto> { new MarketSegmentCutDto { MarketSegmentCutKey = cutKey, BlendFlag = true } });
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentCutDetail(It.IsAny<List<int>>())).ReturnsAsync(new List<MarketSegmentCutDetailDto>());
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentBlendChildren(It.IsAny<IEnumerable<int>>())).ReturnsAsync(blendCuts);
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(new SurveyCutDto());

            var response = await _marketSegmentController.SaveMarketSegmentBlend(marketSegmentId, blend) as OkObjectResult;
            var dataResponse = response?.Value as IEnumerable<MarketSegmentBlendDto>;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse.Count, Is.EqualTo(1));
        }

        [Test]
        public async Task EditMarketSegmentBlend_Success_ValidResult()
        {
            //Act
            var marketSegmentId = 1;
            var cutKey = 1;
            var blend = new MarketSegmentBlendDto { MarketSegmentCutKey = cutKey };
            var children = new List<MarketSegmentBlendCutDto> { new MarketSegmentBlendCutDto { ParentMarketSegmentCutKey = blend.MarketSegmentCutKey } };

            _marketSegmentRepository.Setup(x => x.GetMarketSegment(It.IsAny<int>())).ReturnsAsync(new MarketSegmentDto { Id = marketSegmentId, Blends = new List<MarketSegmentBlendDto> { blend } });
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentCut(It.IsAny<int>()))
                .ReturnsAsync(new List<MarketSegmentCutDto> { new MarketSegmentCutDto { MarketSegmentCutKey = cutKey, BlendFlag = true } });
            _marketSegmentRepository.Setup(x => x.GetMarketSegmentCutDetail(It.IsAny<List<int>>())).ReturnsAsync(new List<MarketSegmentCutDetailDto>());
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentBlendChildren(It.IsAny<IEnumerable<int>>()))
                .ReturnsAsync(children)
                .ReturnsAsync(children);
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(new SurveyCutDto());

            var response = await _marketSegmentController.SaveMarketSegmentBlend(marketSegmentId, blend) as OkObjectResult;
            var dataResponse = response?.Value as IEnumerable<MarketSegmentBlendDto>;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse.Count, Is.EqualTo(1));
        }

        [Test]
        public async Task EditMarketSegmentCutDetails_Fail_InvalidResult()
        {
            //Act
            var marketSegmentId = 0;
            var response = await _marketSegmentController.EditMarketSegmentCutDetails(marketSegmentId, new List<MarketSegmentCutDetailDto>()) as BadRequestResult;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
        }

        [Test]
        public async Task EditMarketSegmentCutDetails_Success_ValidResult()
        {
            #region Act
            //Act
            var marketSegmentId = 1;
            var existingMarketSegmentCutKey = 1;
            var industryKey = 1;
            var industryName = "Industry Name";
            var organizationKey = 2;
            var organizationName = "Organization Name";
            var cutGroupKey = 3;
            var cutGroupName = "CutGroup Name";
            var cutSubGroupKey = 4;
            var cutSubGroupName = "CutSubGroup Name";
            var existingCutDetails = new MarketSegmentCutDetailDto
            {
                MarketSegmentCutKey = existingMarketSegmentCutKey,
                IndustrySectorKey = industryKey,
                IndustrySectorName = industryName,
                OrganizationTypeKey = organizationKey,
                OrganizationTypeName = organizationName,
                CutGroupKey = cutGroupKey,
                CutGroupName = cutGroupName,
                CutSubGroupKey = cutSubGroupKey,
                CutSubGroupName = cutSubGroupName,
                CutName = "Cut One"
            };
            var existingCut = new MarketSegmentCutDto
            {
                MarketSegmentId = marketSegmentId,
                MarketSegmentCutKey = existingMarketSegmentCutKey,
                IndustrySectorKey = industryKey,
                IndustrySectorName = industryName,
                OrganizationTypeKey = organizationKey,
                OrganizationTypeName = organizationName,
                CutGroupKey = cutGroupKey,
                CutGroupName = cutGroupName,
                CutSubGroupKey = cutSubGroupKey,
                CutSubGroupName = cutSubGroupName,
                CutDetails = new List<MarketSegmentCutDetailDto> { existingCutDetails }
            };
            var existingMarketSegmentDto = new MarketSegmentDto
            {
                Id = marketSegmentId,
                Cuts = new List<MarketSegmentCutDto> { existingCut }
            };
            var surveyCuts = new SurveyCutDto
            {
                Industries = new List<NameKeyDto> { new NameKeyDto { Name = industryName, Keys = new List<int> { industryKey } } },
                Organizations = new List<NameKeyDto> { new NameKeyDto { Name = organizationName, Keys = new List<int> { organizationKey } } },
                CutGroups = new List<NameKeyDto> { new NameKeyDto { Name = cutGroupName, Keys = new List<int> { cutGroupKey } } },
                CutSubGroups = new List<NameKeyDto> { new NameKeyDto { Name = cutSubGroupName, Keys = new List<int> { cutSubGroupKey } } },
            };
            var newCutDetail = new MarketSegmentCutDetailDto
            {
                IndustrySectorName = industryName,
                OrganizationTypeName = organizationName,
                CutGroupName = cutGroupName,
                CutSubGroupName = cutSubGroupName,
                CutName = "Cut Two"
            };
            var newCut = new MarketSegmentCutDto
            {
                MarketSegmentId = marketSegmentId,
                MarketSegmentCutKey = existingMarketSegmentCutKey,
                IndustrySectorKey = industryKey,
                OrganizationTypeKey = organizationKey,
                CutGroupKey = cutGroupKey,
                CutSubGroupKey = cutSubGroupKey,
                CutDetails = new List<MarketSegmentCutDetailDto> { existingCutDetails, newCutDetail }
            };
            var newMarketSegmentDto = new MarketSegmentDto
            {
                Id = marketSegmentId,
                Cuts = new List<MarketSegmentCutDto> { newCut }
            };

            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegment(It.IsAny<int>()))
                .ReturnsAsync(existingMarketSegmentDto)
                .ReturnsAsync(newMarketSegmentDto);
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCut(It.IsAny<int>()))
                .ReturnsAsync(new List<MarketSegmentCutDto> { existingCut })
                .ReturnsAsync(new List<MarketSegmentCutDto> { existingCut });
            _marketSegmentRepository.SetupSequence(x => x.GetMarketSegmentCutDetail(It.IsAny<List<int>>()))
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { existingCutDetails })
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { existingCutDetails })
                .ReturnsAsync(new List<MarketSegmentCutDetailDto> { existingCutDetails });
            _marketSegmentRepository.Setup(x => x.GetSurveyCut(It.IsAny<SurveyCutRequestDto>())).ReturnsAsync(surveyCuts);

            #endregion

            var response = await _marketSegmentController.EditMarketSegmentCutDetails(marketSegmentId, new List<MarketSegmentCutDetailDto> { existingCutDetails, newCutDetail }) as OkObjectResult;
            var dataResponse = response?.Value as MarketSegmentDto;

            //Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse, Is.EqualTo(newMarketSegmentDto));
        }

        [Test]
        public async Task GetCombinedAveragesCutNames_Success_ValidResult()
        {
            #region Arrange
            var marketSegmentId = 1;
            _combinedAveragesRepository.Setup(x => x.GetCombinedAveragesCutNames(It.IsAny<int>())).ReturnsAsync(new List<string> { "Cut One" });
            #endregion

            #region Act
            var response = await _marketSegmentController.GetCombinedAveragesCutNames(marketSegmentId) as OkObjectResult;
            var dataResponse = response?.Value as List<string>;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse.Count, Is.EqualTo(1));
            Assert.That(dataResponse[0], Is.EqualTo("Cut One"));

            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[0], Is.EqualTo(marketSegmentId));
            Assert.That(_combinedAveragesRepository.Invocations[0].Method.Name, Is.EqualTo("GetCombinedAveragesCutNames"));
            #endregion
        }

        [Test]
        public async Task GetCombinedAveragesCutNames_Fail_BadRequest()
        {
            #region Arrange
            var marketSegmentId = 0;
            _combinedAveragesRepository.Setup(x => x.GetCombinedAveragesCutNames(It.IsAny<int>())).ReturnsAsync(new List<string> { "Cut One" });
            #endregion

            #region Act
            var response = await _marketSegmentController.GetCombinedAveragesCutNames(marketSegmentId) as BadRequestResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(0));
            #endregion
        }

        [Test]
        public async Task GetCombinedAverages_Success_ValidResult()
        {
            #region Arrange
            var marketSegmentId = 10;
            var averageId = 11;
            var averageName = "Cut One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new List<CombinedAveragesDto>
            {
                new CombinedAveragesDto
                {
                    Id = averageId,
                    MarketSegmentId = marketSegmentId,
                    Name = averageName,
                    Order = order,
                    Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
                }
            };

            _combinedAveragesRepository.Setup(x => x.GetCombinedAveragesByMarketSegmentId(It.IsAny<int>())).ReturnsAsync(combinedAverages);
            #endregion

            #region Act
            var response = await _marketSegmentController.GetCombinedAverages(marketSegmentId) as OkObjectResult;
            var dataResponse = response?.Value as List<CombinedAveragesDto>;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            Assert.IsNotNull(dataResponse);
            Assert.That(dataResponse.Count, Is.EqualTo(1));
            Assert.That(dataResponse[0].Id, Is.EqualTo(averageId));
            Assert.That(dataResponse[0].MarketSegmentId, Is.EqualTo(marketSegmentId));
            Assert.That(dataResponse[0].Name, Is.EqualTo(averageName));
            Assert.That(dataResponse[0].Order, Is.EqualTo(order));
            Assert.That(dataResponse[0].Cuts.Count, Is.EqualTo(1));
            Assert.That(dataResponse[0].Cuts[0].Id, Is.EqualTo(cutId));
            Assert.That(dataResponse[0].Cuts[0].CombinedAveragesId, Is.EqualTo(averageId));
            Assert.That(dataResponse[0].Cuts[0].Name, Is.EqualTo(cutName));

            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[0], Is.EqualTo(marketSegmentId));
            Assert.That(_combinedAveragesRepository.Invocations[0].Method.Name, Is.EqualTo("GetCombinedAveragesByMarketSegmentId"));
            #endregion
        }

        [Test]
        public async Task GetCombinedAverages_Fail_BadRequest()
        {
            #region Arrange
            var marketSegmentId = 0;
            #endregion

            #region Act
            var response = await _marketSegmentController.GetCombinedAveragesCutNames(marketSegmentId) as BadRequestResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(0));
            #endregion
        }

        [Test]
        public async Task InsertCombinedAverage_Success()
        {
            #region Arrange
            var marketSegmentId = 10;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new CombinedAveragesDto
            {
                Id = averageId,
                MarketSegmentId = marketSegmentId,
                Name = averageName,
                Order = order,
                Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.InsertCombinedAverage(marketSegmentId, combinedAverages) as OkResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[0], Is.EqualTo(combinedAverages));
            Assert.That(_combinedAveragesRepository.Invocations[0].Method.Name, Is.EqualTo("InsertCombinedAverage"));
            #endregion
        }

        [Test]
        public async Task InsertCombinedAverage_Fail_BadRequest()
        {
            #region Arrange
            var marketSegmentId = 0;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new CombinedAveragesDto
            {
                Id = averageId,
                MarketSegmentId = marketSegmentId,
                Name = averageName,
                Order = order,
                Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.InsertCombinedAverage(marketSegmentId, combinedAverages) as BadRequestResult;
            var response2 = await _marketSegmentController.InsertCombinedAverage((marketSegmentId + 1), combinedAverages) as BadRequestResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.IsNotNull(response2);
            Assert.IsTrue(response2.StatusCode == 400);
            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(0));
            #endregion
        }

        [Test]
        public async Task InsertAndUpdateAndRemoveCombinedAverages_Success()
        {
            #region Arrange
            var marketSegmentId = 10;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new List<CombinedAveragesDto>
            {
                new CombinedAveragesDto
                {
                    Id = averageId,
                    MarketSegmentId = marketSegmentId,
                    Name = averageName,
                    Order = order,
                    Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
                }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.InsertAndUpdateAndRemoveCombinedAverages(marketSegmentId, combinedAverages) as OkResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[0], Is.EqualTo(marketSegmentId));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[1], Is.EqualTo(combinedAverages));
            Assert.That(_combinedAveragesRepository.Invocations[0].Method.Name, Is.EqualTo("InsertAndUpdateAndRemoveCombinedAverages"));
            #endregion
        }

        [Test]
        public async Task InsertAndUpdateAndRemoveCombinedAverages_Fail_BadRequest()
        {
            #region Arrange
            var marketSegmentId = 0;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new List<CombinedAveragesDto>
            {
                new CombinedAveragesDto
                {
                    Id = averageId,
                    MarketSegmentId = marketSegmentId,
                    Name = averageName,
                    Order = order,
                    Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
                }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.InsertAndUpdateAndRemoveCombinedAverages(marketSegmentId, combinedAverages) as BadRequestResult;
            var response2 = await _marketSegmentController.InsertAndUpdateAndRemoveCombinedAverages((marketSegmentId + 1), combinedAverages) as BadRequestResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.IsNotNull(response2);
            Assert.IsTrue(response2.StatusCode == 400);
            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(0));
            #endregion
        }

        [Test]
        public async Task UpdateCombinedAverages_Success()
        {
            #region Arrange
            var marketSegmentId = 10;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new CombinedAveragesDto
            {
                Id = averageId,
                MarketSegmentId = marketSegmentId,
                Name = averageName,
                Order = order,
                Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.UpdateCombinedAverages(marketSegmentId, averageId, combinedAverages) as OkResult;
            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);

            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(1));
            Assert.That(_combinedAveragesRepository.Invocations[0].Arguments[0], Is.EqualTo(combinedAverages));
            Assert.That(_combinedAveragesRepository.Invocations[0].Method.Name, Is.EqualTo("UpdateCombinedAverages"));
            #endregion
        }

        [Test]
        public async Task UpdateCombinedAverages_Fail_BadRequest()
        {
            #region Arrange
            var marketSegmentId = 1;
            var averageId = 11;
            var averageName = "Average One";
            var order = 12;
            var cutId = 20;
            var cutName = "Cut One";

            var combinedAverages = new CombinedAveragesDto
            {
                Id = averageId + 1,
                MarketSegmentId = marketSegmentId + 1,
                Name = averageName,
                Order = order,
                Cuts = new List<CombinedAveragesCutDto>
                    {
                        new CombinedAveragesCutDto
                        {
                            Id = cutId,
                            CombinedAveragesId = averageId,
                            Name = cutName,
                        }
                    }
            };
            #endregion

            #region Act
            var response = await _marketSegmentController.UpdateCombinedAverages(0, averageId, combinedAverages) as BadRequestResult;
            var response2 = await _marketSegmentController.UpdateCombinedAverages(marketSegmentId, 0, combinedAverages) as BadRequestResult;

            var response3 = await _marketSegmentController.UpdateCombinedAverages(marketSegmentId, averageId, combinedAverages) as BadRequestResult;
            var response4 = await _marketSegmentController.UpdateCombinedAverages((marketSegmentId + 1), averageId, combinedAverages) as BadRequestResult;

            var response5 = await _marketSegmentController.UpdateCombinedAverages((marketSegmentId + 1), (averageId + 1), combinedAverages) as BadRequestResult;

            #endregion

            #region Assert
            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.IsNotNull(response2);
            Assert.IsTrue(response2.StatusCode == 400);
            Assert.IsNotNull(response3);
            Assert.IsTrue(response3.StatusCode == 400);
            Assert.IsNotNull(response4);
            Assert.IsTrue(response4.StatusCode == 400);
            Assert.IsNotNull(response5);
            Assert.IsTrue(response5.StatusCode == 400);
            Assert.That(_combinedAveragesRepository.Invocations.Count, Is.EqualTo(0));
            #endregion
        }

        [Test]
        public async Task DeleteMarketSegment_Fail_NotFound()
        {
            #region Arrange

            var marketSegmentId = 0;

            #endregion

            #region Act

            var response = await _marketSegmentController.DeleteMarketSegment(marketSegmentId) as NotFoundResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 404);

            #endregion
        }

        [Test]
        public async Task DeleteMarketSegment_Fail_BadRequest()
        {
            #region Arrange

            var marketSegmentId = 1;
            var jobCode = "001";
            _marketSegmentRepository.Setup(x => x.ListJobCodesMapped(It.IsAny<int>())).ReturnsAsync(new List<string> { jobCode });

            #endregion

            #region Act

            var response = await _marketSegmentController.DeleteMarketSegment(marketSegmentId) as BadRequestObjectResult;
            var errorMessages = response?.Value as List<string>;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 400);
            Assert.IsNotNull(errorMessages);
            Assert.IsNotEmpty(errorMessages);
            Assert.True(errorMessages.All(m => m.Contains(jobCode)));
            _marketSegmentRepository.Verify(x => x.ListJobCodesMapped(It.IsAny<int>()), Times.Once());

            #endregion
        }

        [Test]
        public async Task DeleteMarketSegment_Success()
        {
            #region Arrange

            var marketSegmentId = 1;
            _marketSegmentRepository.Setup(x => x.ListJobCodesMapped(It.IsAny<int>())).ReturnsAsync(new List<string>());

            #endregion

            #region Act

            var response = await _marketSegmentController.DeleteMarketSegment(marketSegmentId) as OkResult;

            #endregion

            #region Assert

            Assert.IsNotNull(response);
            Assert.IsTrue(response.StatusCode == 200);
            _marketSegmentRepository.Verify(x => x.ListJobCodesMapped(It.IsAny<int>()), Times.Once());
            _marketSegmentRepository.Verify(x => x.DeleteMarketSegment(It.IsAny<int>(), It.IsAny<string?>()), Times.Once());

            #endregion
        }
    }
}
