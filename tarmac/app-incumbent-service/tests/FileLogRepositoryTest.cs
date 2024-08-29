using AutoMapper;
using CN.Incumbent.Infrastructure.Repositories;
using CN.Incumbent.Infrastructure;
using CN.Incumbent.Tests.Generic;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;
using System.ComponentModel.DataAnnotations;

namespace CN.Incumbent.Test
{
    public class FileLogRepositoryTest
    {
        private Mock<IDBContext> _context;
        private Mock<ILogger<FileLogRepository>> _logger;
        private IMapper _mapper;
        private InMemoryDatabase db;
        private Dictionary<string, string> _inMemorySettings;

        [SetUp]
        public void Setup()
        {
            _logger = new Mock<ILogger<FileLogRepository>>();
            _context = new Mock<IDBContext>();
            _mapper = MappingConfig.RegisterMaps().CreateMapper();

            _inMemorySettings = new Dictionary<string, string>
            {
                { "AwsConfiguration:AWSBucketName", "s3-bucket-test" },
                { "AwsConfiguration:AWSAccessKey", "access-key-test" },
                { "AwsConfiguration:AWSSecretKey", "secret-key-test" }
            };

            var fileLogDetails = new List<File_Log_Detail>
            {
                new File_Log_Detail
                {
                    File_Log_Detail_Key = 1,
                    File_Log_Key = 1,
                    Message_Text = "Test Log",
                    Created_Utc_Datetime = DateTime.UtcNow
                }
            };

            db = new InMemoryDatabase();
            db.Insert(fileLogDetails);

            _context.Setup(c => c.GetIncumbentStagingConnection()).Returns(db.OpenConnection());
        }

        [Test]
        public async Task GetFileLogDetails()
        {
            // Act
            var fileLogKey = 1;

            var response = await new FileLogRepository(_context.Object, _logger.Object, _mapper).GetFileLogDetails(fileLogKey);

            // Assert
            Assert.That(response.Count, Is.EqualTo(1));
        }

        //Support classes
        protected class File_Log_Detail
        {
            [Key]
            public int File_Log_Detail_Key { get; set; }
            public int File_Log_Key { get; set; }
            public string? Message_Text { get; set; }
            public DateTime Created_Utc_Datetime { get; set; }
        }
    }
}
