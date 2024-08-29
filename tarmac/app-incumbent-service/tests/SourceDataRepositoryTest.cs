using AutoMapper;
using CN.Incumbent.Infrastructure.Repositories;
using CN.Incumbent.Infrastructure;
using CN.Incumbent.Tests.Generic;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;
using CN.Incumbent.Domain;


namespace CN.Incumbent.Test
{
    [TestFixture]
    public class SourceDataRepositoryTest
    {
        private Mock<IDBContext> _context;
        private Mock<ILogger<SourceDataRepository>> _logger;
        private IMapper _mapper;
        private InMemoryDatabase db;
        private List<Source_Data_Aggr> aggr;

        [SetUp]
        public void Setup()
        {

            _context = new Mock<IDBContext>();
            _logger = new Mock<ILogger<SourceDataRepository>>();

            aggr = new List<Source_Data_Aggr>()
            {
                new Source_Data_Aggr()
                {
                    Source_Data_Aggr_Key = 1,
                     Aggregation_Method_Key = 1,
                     Ces_Org_Id = 1,
                     Client_Job_Group = "Group",
                     File_Log_Key = 1,
                     File_Org_Key = 1,
                     Fte_Value = 1,
                     Incumbent_Count = 1,
                     Job_Code = "250.250",
                     Job_Family = "JF",
                     Job_Level = "JL",
                     Job_Title = "Title",
                     Location_Description = "Description",
                     Pay_Grade = "PG",
                     Pay_Type = "PType",
                     Position_Code = null,
                     Position_Code_Description = "PC Description",
                },
                 new Source_Data_Aggr()
                {
                     Source_Data_Aggr_Key = 2,
                     Aggregation_Method_Key = 1,
                     Ces_Org_Id = 1,
                     Client_Job_Group = "Group",
                     File_Log_Key = 1,
                     File_Org_Key = 1,
                     Fte_Value = 1,
                     Incumbent_Count = 1,
                     Job_Code = "250.250",
                     Job_Family = "JF",
                     Job_Level = "JL",
                     Job_Title = "Title",
                     Location_Description = "Description",
                     Pay_Grade = "PG",
                     Pay_Type = "PType",
                     Position_Code = "111.18",
                     Position_Code_Description = "PC Description",
                }
            };

            db = new InMemoryDatabase();
            db.Insert(aggr);

            _context.Setup(c => c.GetIncumbentConnection()).Returns(db.OpenConnection());
        }

        [TestCase(1, 1, "250.250", "", 1 )]
        [TestCase(1, 1, "250.250", "111.18", 1)]
        public async Task GetClientJobs_Success(int fileLogKey, int aggrMethod, string jobCode,
                                string positionCode,
                                int fileOrgKey)
        {
           

            var repo =  new SourceDataRepository(_context.Object, _logger.Object, _mapper);
            var response = await repo.ListClientPositionDetail(fileLogKey, aggrMethod, jobCode, positionCode, fileOrgKey);

            Assert.IsNotNull(response);
            Assert.That(response.Count, Is.EqualTo(1));
            Assert.That(response.First().FteValue, !Is.EqualTo(0));
        }
        protected class Source_Data_Aggr
        {
            public int Source_Data_Aggr_Key { get; set; }
            public int Aggregation_Method_Key { get; set; }
            public int File_Log_Key { get; set; }
            public int File_Org_Key { get; set; }
            public int Ces_Org_Id { get; set; }
            public string Job_Code { get; set; } = string.Empty;
            public string Job_Title { get; set; } = string.Empty;
            public int Incumbent_Count { get; set; }
            public int Fte_Value { get; set; }
            public string Location_Description { get; set; } = string.Empty;
            public string Job_Family { get; set; } = string.Empty;
            public string Pay_Grade { get; set; } = string.Empty;
            public string Pay_Type { get; set; } = string.Empty;
            public string? Position_Code { get; set; }
            public string Position_Code_Description { get; set; } = string.Empty;
            public string Job_Level { get; set; } = string.Empty;
            public string Client_Job_Group { get; set; } = string.Empty;

        }
    }
}