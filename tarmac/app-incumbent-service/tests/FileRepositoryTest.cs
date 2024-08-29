using Moq;
using NUnit.Framework;
using CN.Incumbent.Tests.Generic;
using CN.Incumbent.Infrastructure.Repositories;
using CN.Incumbent.Domain.Models.Dtos;
using Microsoft.Extensions.Configuration;
using CN.Incumbent.Infrastructure;
using Microsoft.Extensions.Logging;
using System.ComponentModel.DataAnnotations;
using ServiceStack.Text;
using AutoMapper;
using Microsoft.AspNetCore.Http;

namespace CN.Incumbent.Test;

[TestFixture]
public class FileRepositoryTest
{
    private Mock<IDBContext> _context;
    private IConfiguration _configuration;
    private Mock<ILogger<FileRepository>> _logger;
    private IMapper _mapper;
    private InMemoryDatabase db;
    private Dictionary<string, string?> _inMemorySettings;

    [SetUp]
    public void Setup()
    {
        _logger = new Mock<ILogger<FileRepository>>();
        _context = new Mock<IDBContext>();
        _mapper = MappingConfig.RegisterMaps().CreateMapper();

        _inMemorySettings = new Dictionary<string, string?>
        {
            { "AwsConfiguration:AWSBucketName", "s3-bucket-test" },
            { "AwsConfiguration:AWSAccessKey", "access-key-test" },
            { "AwsConfiguration:AWSSecretKey", "secret-key-test" }
        };

        _configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(_inMemorySettings)
            .Build();

        var fileLogs = new List<File_log>() {
            new()
            {
                File_log_key = 1,
                Client_Filename = "Test_file_1.cs",
                Data_effective_date = new DateTime(2023,3,21),
                File_s3_url = "s3-bucket-test/UploadedFiles/202303/1/Test_file_1.cs",
                File_s3_name = $"{Guid.NewGuid()}.csv",
                File_org_key = 1,
                Source_data_name = "incumbent",
                File_status_key = 1
            }
        };

        var status = new List<Status_List>
        {
            new() { Status_Key = 1, Status_Name = "Started" },
            new() { Status_Key = 2, Status_Name = "Uploaded" },
            new() { Status_Key = 3, Status_Name = "Validating" },
            new() { Status_Key = 4, Status_Name = "Invalid" },
            new() { Status_Key = 5, Status_Name = "Valid" },
            new() { Status_Key = 6, Status_Name = "Valid with warnings" },
            new() { Status_Key = 7, Status_Name = "Valid - oudated" },
            new() { Status_Key = 8, Status_Name = "Valid with warnings - outdated" },
        };

        db = new InMemoryDatabase();
        db.Insert(status);
        db.Insert(fileLogs);

        _context.Setup(c => c.GetIncumbentConnection()).Returns(db.OpenConnection());
    }

    [Test]
    public async Task InsertFile_Success()
    {
        // Act
        var fileLogDetails = new SaveFileDto()
        {
            OrganizationId = 1,
            EffectiveDate = DateTime.Now,
            SourceDataName = "Incumbent",
            ClientFileName = "TestFile_2.cs",
            File = new Mock<IFormFile>().Object
        };

        var result = await new FileRepository(_context.Object, _logger.Object, _configuration, _mapper)
            .InsertFileLog(fileLogDetails, "testObjectId");

        // Assert
        Assert.That(result.FileS3Url, Does.Contain(_inMemorySettings.Get("AwsConfiguration:AWSBucketName") + "/UploadedFiles"));
        Assert.That(result.FileS3Url, Does.Contain($"/{fileLogDetails.OrganizationId}/"));
    }

    [Test]
    public async Task ExistsFileWithOrgIdSourceData()
    {
        // Act
        var orgId = 1;
        var sourceData = "incumbent";

        var response = await new FileRepository(_context.Object, _logger.Object, _configuration, _mapper)
            .GetFileByFilters(orgId, sourceData);

        // Assert
        Assert.That(response.Count(), Is.EqualTo(1));
        Assert.That(orgId, Is.EqualTo(response?.FirstOrDefault()?.OrganizationId));
        Assert.That(sourceData, Is.EqualTo(response?.FirstOrDefault()?.SourceDataName));
    }

    [Test]
    public async Task NotExistsFileWithOrgIdSourceData()
    {
        // Act
        var orgId = 1;
        var sourceData = "job";

        var response = await new FileRepository(_context.Object, _logger.Object, _configuration, _mapper)
            .GetFileByFilters(orgId, sourceData);

        // Assert
        Assert.That(response.Count(), Is.EqualTo(0));
    }

    //Support classes
    protected class File_log
    {
        [Key]
        public int File_log_key { get; set; }
        public int File_org_key { get; set; }
        public string? Source_data_name { get; set; }
        public DateTime Data_effective_date { get; set; }
        public string? Client_Filename { get; set; }
        public string? File_s3_url { get; set; }
        public string? File_s3_name { get; set; }
        public string? Uploaded_by { get; set; }
        public DateTime Uploaded_utc_datetime { get; set; }
        public int File_status_key { get; set; }
    }

    protected class Status_List
    {
        public int Status_Key { get; set; }
        public string? Status_Name { get; set; }
    }
}
