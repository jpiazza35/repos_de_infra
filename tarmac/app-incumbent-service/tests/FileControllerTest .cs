using CN.Incumbent.RestApi.Controllers;
using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using Moq;
using NUnit.Framework;
using Microsoft.AspNetCore.Mvc;
using FluentAssertions;
using CN.Incumbent.RestApi.Services;
using Microsoft.Extensions.Configuration;
namespace CN.Incumbent.Test;

[TestFixture]
public class FileControllerTest
{
    private Mock<IFileRepository> _fileRepository;
    private Mock<IFileLogRepository> _fileLogRepository;
    private FileService _fileService;
    private FileController _fileController;
    private List<FileLogDto> _files;
    private List<FileLogDetailDto> _fileDetails;
    private Mock<IConfiguration> _configuration;

    [SetUp]
    public void Setup()
    {
        _configuration = new Mock<IConfiguration>();
        _fileRepository = new Mock<IFileRepository>();
        _fileLogRepository = new Mock<IFileLogRepository>();
        _fileService = new FileService(_fileRepository.Object, _fileLogRepository.Object);
        _fileController = new FileController(_fileRepository.Object, _fileService, _configuration.Object);

        _files = new List<FileLogDto>()
        {
            new ()
            {
                FileLogKey = 1,
                ClientFileName = "Test_file_1.csv",
                OrganizationId = 90,
                FileS3Url = "s3-bucket-server/Test_file_1.csv",
                FileStatusKey = 2,
                SourceDataName = "Job",
                EffectiveDate =  new DateTime(2023, 03, 28),
                FileStatusName = "Upload"
            },
            new ()
            {
                FileLogKey = 1,
                ClientFileName = "Test_file_2.csv",
                OrganizationId = 90,
                FileS3Url = "s3-bucket-server/Test_file_2.csv",
                FileStatusKey = 2,
                SourceDataName = "Job",
                EffectiveDate =  new DateTime(2023, 03, 28),
                FileStatusName = "Started"
            }
        };

        _fileDetails = new List<FileLogDetailDto>
        {
            new FileLogDetailDto{ FileLogKey = 1, FileLogDetailKey = 1, MessageText = "Test", CreatedUtcDatetime = DateTime.UtcNow }
        };

        _fileRepository.Setup(x => x.GetFileByFilters(It.IsAny<int>(), It.IsAny<string>())).ReturnsAsync(_files);
        _fileRepository.Setup(x => x.GetFilesByIds(It.IsAny<List<int>>())).ReturnsAsync(_files);
        _fileRepository.Setup(x => x.GetFileLinkAsync(It.IsAny<int>())).ReturnsAsync(_files.FirstOrDefault()?.FileS3Url ?? string.Empty);
        _fileRepository.Setup(x => x.GetFileLinkAsync(It.IsAny<string>())).ReturnsAsync(_files.FirstOrDefault()?.FileS3Url ?? string.Empty);
        _fileLogRepository.Setup(x => x.GetFileLogDetails(It.IsAny<int>())).ReturnsAsync(_fileDetails);
    }

    [Test]
    public async Task GetFileByFilters_Success()
    {
        var orgId = 1;
        var sourceData = "Job";

        var response = await _fileController.GetFileByFilters(orgId, sourceData) as OkObjectResult;
        var fileResponse = response?.Value as List<FileLogDto>;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(fileResponse);

        fileResponse.Should().BeEquivalentTo(_files);
    }

    [Test]
    public async Task GetFileDetails_BadRequest()
    {
        var fileKey = 0;

        var response = await _fileController.GetFileDetails(fileKey) as BadRequestResult;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 400);
    }

    [Test]
    public async Task GetFileDetails_NotFound()
    {
        var fileKey = 2; 

        _fileRepository.Setup(x => x.GetFilesByIds(It.IsAny<List<int>>())).ReturnsAsync(new List<FileLogDto>());

        var response = await _fileController.GetFileDetails(fileKey) as NotFoundResult;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 404);
    }

    [Test]
    public async Task GetFileDetails_Success()
    {
        var fileKey = 1;

        var response = await _fileController.GetFileDetails(fileKey) as OkObjectResult;
        var fileResponse = response?.Value as FileLogDto;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(fileResponse);
        Assert.IsNotNull(fileResponse.Details);
        Assert.IsNotEmpty(fileResponse.Details);

        fileResponse.Details.Should().BeEquivalentTo(_fileDetails);
    }


    [Test]
    public async Task GetFileLinkByFileKey_Success()
    {
        var fileKey = 1;

        var response = await _fileController.GetFileLinkByFileKey(fileKey) as OkObjectResult;
        var fileResponse = response?.Value as string;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(fileResponse);
        Assert.IsNotEmpty(fileResponse);

        fileResponse.Should().BeEquivalentTo(_files.FirstOrDefault()?.FileS3Url);
    }

    [Test]
    public async Task GetFileLinkByFileName_Success()
    {
        var fileS3Name = "FileS3Name";

        var response = await _fileController.GetFileLinkByFileName(fileS3Name) as OkObjectResult;
        var fileResponse = response?.Value as string;

        //Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
        Assert.IsNotNull(fileResponse);
        Assert.IsNotEmpty(fileResponse);

        fileResponse.Should().BeEquivalentTo(_files.FirstOrDefault()?.FileS3Url);
    }

    [Test]
    public async Task GetBuildNumber_Success()
    {
        var response = await _fileController.GetBuildNumber() as OkObjectResult;

        ////Assert
        Assert.IsNotNull(response);
        Assert.IsTrue(response.StatusCode == 200);
    }     
}