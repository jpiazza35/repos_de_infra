using AutoMapper;
using Cn.Survey;
using CN.Project.Domain.Models.Dto;
using CN.Project.Infrastructure.Repository;
using CN.Project.Infrastructure;
using CN.Project.Test.Generic;
using Grpc.Core.Testing;
using Grpc.Core;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;
using Survey = Cn.Survey.Survey;
using System.ComponentModel.DataAnnotations;

namespace CN.Project.Test
{
    [TestFixture]
    public class MarketSegmentRepositoryTest
    {
        private Mock<IDBContext> _context;
        private Mock<ILogger<MarketSegmentRepository>> _logger;
        private IMapper _mapper;
        private List<Market_Segment_List> _marketSegments;
        private List<Market_Segment_Cut> _marketSegmentCuts;
        private List<Market_Segment_Cut_Detail> _marketSegmentCutDetails;
        private List<Market_Segment_Blend> _marketSegmentBlends;
        private Mock<Survey.SurveyClient> _surveyClient;
        private SurveyCutListResponse _surveyCutListResponse;

        [SetUp]
        public void Setup()
        {
            _logger = new Mock<ILogger<MarketSegmentRepository>>();
            _context = new Mock<IDBContext>();
            _mapper = MappingConfig.RegisterMaps().CreateMapper();

            _marketSegments = new List<Market_Segment_List>
            {
                new Market_Segment_List
                {
                    Market_Segment_Id=1,
                    Market_Segment_Name="test",
                    Project_Version_Id=1,
                },
                new Market_Segment_List
                {
                    Market_Segment_Id=2,
                    Market_Segment_Name="test 2",
                    Project_Version_Id=2,
                },
            };

            _marketSegmentCuts = new List<Market_Segment_Cut> 
            {
                new Market_Segment_Cut{ Market_Segment_Id=1,}
            };
            _marketSegmentCutDetails = new List<Market_Segment_Cut_Detail> { };

            _marketSegmentBlends = new List<Market_Segment_Blend>
            {
                new Market_Segment_Blend
                {
                    Market_Segment_Blend_Key = 1,
                    Parent_Market_Segment_Cut_Key = 1,
                    Child_Market_Segment_Cut_Key = 1,
                    Blend_Weight = 1
                }
            };

            var db = new InMemoryDatabase();
            db.Insert(_marketSegments);
            db.Insert(_marketSegmentCuts);
            db.Insert(_marketSegmentCutDetails);
            db.Insert(_marketSegmentBlends);

            _context.Setup(c => c.GetConnection()).Returns(db.OpenConnection());

            SetupSurveyClient();
        }

        [Test]
        public async Task GetMarketSegments()
        {
            var projectVersionId = 1;
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);
            var result = await repository.GetMarketSegments(projectVersionId);

            Assert.That(result[0].Id, Is.EqualTo(1));
            Assert.That(result[0].Name, Is.EqualTo("test"));
        }

        [Test]
        public async Task SaveMarketSegment()
        {
            var marketSegment = new MarketSegmentDto();

            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);
            var result = await repository.SaveMarketSegment(marketSegment, string.Empty);

            Assert.That(result, Is.EqualTo(_marketSegments.Count + 1));
        }

        [Test]
        public async Task GetMarketSegment()
        {
            var marketSegmentId = 1;

            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);
            var result = await repository.GetMarketSegment(marketSegmentId);

            Assert.IsNotNull(result);
            Assert.That(result.Id, Is.EqualTo(marketSegmentId));
        }

        [Test]
        public async Task GetSurveyCut()
        {
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);
            var result = await repository.GetSurveyCut(new SurveyCutRequestDto());

            Assert.IsNotNull(result);
            Assert.IsNotNull(result.SurveyYears);
            Assert.That(result.SurveyYears.Count, Is.EqualTo(_surveyCutListResponse.SurveyYears.Count));
        }

        [Test]
        public async Task EditMarketSegment()
        {
            var marketSegment = new MarketSegmentDto { Id = 1 };
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);

            await repository.EditMarketSegment(marketSegment, marketSegment, string.Empty);
        }

        [Test]
        public async Task EditMarketSegmentEri()
        {
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);

            await repository.EditMarketSegmentEri(new MarketSegmentDto { EriAdjustmentFactor = 1, EriCity = "New York", EriCutName = "ERI Test" }, string.Empty);
        }

        [Test]
        public async Task SaveMarketSegmentBlend()
        {
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);

            var marketSegment = _marketSegments.First();

            await repository.SaveMarketSegmentBlend(marketSegment.Market_Segment_Id, new MarketSegmentBlendDto
            {
                BlendName = "Blend Test",
                DisplayOnReport = true,
                ReportOrder = 2,
                Cuts = new List<MarketSegmentBlendCutDto>
                {
                    new MarketSegmentBlendCutDto
                    {
                        ChildMarketSegmentCutKey = 2,
                        BlendWeight = 1
                    }
                }
            }, string.Empty);
        }

        [Test]
        public async Task EditMarketSegmentBlend()
        {
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);

            var existingChildren = new List<MarketSegmentBlendCutDto>
            {
                new MarketSegmentBlendCutDto
                {
                    MarketSegmentBlendKey = 1,
                    ParentMarketSegmentCutKey = 1,
                    ChildMarketSegmentCutKey = 2,
                    BlendWeight = 2
                }
            };

            await repository.EditMarketSegmentBlend(new MarketSegmentBlendDto
            {
                BlendName = "Blend Test",
                DisplayOnReport = true,
                ReportOrder = 2,
                Cuts = new List<MarketSegmentBlendCutDto>
                {
                    new MarketSegmentBlendCutDto
                    {
                        ChildMarketSegmentCutKey = 2,
                        BlendWeight = 1
                    }
                }
            }, string.Empty, existingChildren);
        }

        [Test]
        public async Task EditMarketSegmentCutDetails()
        {
            var repository = new MarketSegmentRepository(_context.Object, _mapper, _logger.Object, _surveyClient.Object);

            await repository.EditMarketSegmentCutDetails(new List<MarketSegmentCutDetailDto> { new MarketSegmentCutDetailDto { MarketSegmentCutKey = 1 } },
                new List<MarketSegmentCutDetailDto>
                {
                    new MarketSegmentCutDetailDto
                    {
                        PublisherKey = 1,
                        SurveyKey = 2,
                        IndustrySectorKey = 3,
                        OrganizationTypeKey = 4,
                        CutGroupKey = 5,
                        CutSubGroupKey = 6,
                        CutKey = 7,
                    }
                }, string.Empty);
        }

        private void SetupSurveyClient()
        {
            _surveyClient = new Mock<Survey.SurveyClient>();
            _surveyCutListResponse = new SurveyCutListResponse();

            var surveyCutsListResponse = TestCalls.AsyncUnaryCall(Task.FromResult(_surveyCutListResponse), Task.FromResult(new Metadata()), () => Status.DefaultSuccess, () => new Metadata(), () => { });
            _surveyClient.Setup(o => o.ListSurveyCutsAsync(It.IsAny<SurveyCutsRequest>(), null, null, CancellationToken.None)).Returns(surveyCutsListResponse);
        }

        //Support classes
        protected class Market_Segment_List
        {
            [Key]
            public int Market_Segment_Id { get; set; }
            public int Project_Version_Id { get; set; }
            public string? Market_Segment_Name { get; set; }
            public int Market_Segment_Status_Key { get; set; }
            public decimal? Eri_Adjustment_Factor { get; set; }
            public string? Eri_Cut_Name { get; set; }
            public string? Eri_City { get; set; }
            public string? Emulated_by { get; set; }
            public string? Modified_Username { get; set; }
            public DateTime? Modified_Utc_Datetime { get; set; }
        }

        protected class Market_Segment_Cut
        {
            [Key]
            public int Market_Segment_Cut_Key { get; set; }
            public int Market_Segment_Id { get; set; }
            public bool Is_Blend_Flag { get; set; }
            public int? Industry_Sector_Key { get; set; }
            public int? Organization_Type_Key { get; set; }
            public int? Cut_Group_Key { get; set; }
            public int? Cut_Sub_Group_Key { get; set; }
            public string? Market_Pricing_Cut_Name { get; set; }
            public bool Display_On_Report_Flag { get; set; }
            public decimal? Subgroup_Cut_Weight { get; set; }
            public int Report_Order { get; set; }
            public string? Emulated_By { get; set; }
            public string? Modified_Username { get; set; }
            public DateTime Modified_Utc_Datetime { get; set; }
        }

        protected class Market_Segment_Cut_Detail
        {
            [Key]
            public int Market_Segment_Cut_Detail_Key { get; set; }
            public int Market_Segment_Cut_Key { get; set; }
            public int? Publisher_Key { get; set; }
            public int? Survey_Key { get; set; }
            public int? Industry_Sector_Key { get; set; }
            public int? Organization_Type_Key { get; set; }
            public int? Cut_Group_Key { get; set; }
            public int? Cut_Sub_Group_Key { get; set; }
            public int? Cut_Key { get; set; }
            public bool? Is_Selected { get; set; }
            public string? Emulated_By { get; set; }
            public string? Modified_Username { get; set; }
            public DateTime Modified_Utc_Datetime { get; set; }
        }

        protected class Market_Segment_Blend
        {
            [Key]
            public int Market_Segment_Blend_Key { get; set; }
            public int Parent_Market_Segment_Cut_Key { get; set; }
            public int Child_Market_Segment_Cut_Key { get; set; }
            public decimal Blend_Weight { get; set; }
            public string? Emulated_By { get; set; }
            public string? Modified_Username { get; set; }
            public DateTime? Modified_Utc_Datetime { get; set; }
        }
    }
}