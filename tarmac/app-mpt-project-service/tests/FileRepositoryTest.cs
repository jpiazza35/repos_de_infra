using AutoMapper;
using CN.Project.Infrastructure.Repository;
using CN.Project.Infrastructure;
using Cn.Incumbent;
using Google.Protobuf.WellKnownTypes;
using Grpc.Core.Testing;
using Grpc.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using NUnit.Framework;

namespace CN.Project.Test;

[TestFixture]
public class FileRepositoryTest
{
    private IMapper _mapper;
    private Mock<IConfiguration> _configuration;
    private Mock<ILogger<FileRepository>> _logger;
    private Mock<Incumbent.IncumbentClient> _incumbentClient;
    private FileList _fileList;

    [SetUp]
    public void Setup()
    {
        _logger = new Mock<ILogger<FileRepository>>();
        _mapper = MappingConfig.RegisterMaps().CreateMapper();
        _configuration = new Mock<IConfiguration>();
        SetupIncumbentClient();
    }

    [Test]
    public async Task InsertFileLogAsync_Success()
    {
        // Act
        var fileIds = new List<int>() { 1 };

        var result = await new FileRepository(_mapper, _configuration.Object, _logger.Object, _incumbentClient.Object)
            .GetFilesByIds(fileIds);

        // Assert
        Assert.That(fileIds.Count, Is.EqualTo(result.Count));
        Assert.That(result[0].FileStatusName, Is.EqualTo("Uploaded"));
        Assert.That(result[0].SourceDataName, Is.EqualTo("Incumbent"));
    }

    private void SetupIncumbentClient()
    {
        _incumbentClient = new Mock<Incumbent.IncumbentClient>();
        _fileList = new FileList();
        _fileList.Files.AddRange(new Google.Protobuf.Collections.RepeatedField<FileModel>
        {
            new FileModel
            {
                FileLogKey = 1,
                FileStatusKey = 2,
                SourceDataName = "Incumbent",
                StatusName = "Uploaded",
                DataEffectiveDate = DateTime.UtcNow.ToTimestamp(),
                FileOrgKey = 1
            }
        });

        var fileListResponse = TestCalls.AsyncUnaryCall(Task.FromResult(_fileList), Task.FromResult(new Metadata()), () => Status.DefaultSuccess, () => new Metadata(), () => { });
        _incumbentClient.Setup(o => o.ListFilesByIdsAsync(It.IsAny<FileIdsRequest>(), null, null, CancellationToken.None)).Returns(fileListResponse);
    }
}
