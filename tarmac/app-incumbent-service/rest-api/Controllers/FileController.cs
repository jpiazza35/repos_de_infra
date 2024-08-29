using CN.Incumbent.Domain;
using CN.Incumbent.Domain.Models.Dtos;
using CN.Incumbent.Domain.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace CN.Incumbent.RestApi.Controllers;

[Authorize]
[Route("file")]
[Route("api/files")]
[ApiController]
public class FileController : ControllerBase
{
    private readonly IFileRepository _fileRepository;
    private readonly IFileService _fileService;
    private IConfiguration _configuration { get; }
    public FileController(IFileRepository fileRepository, IFileService fileService, IConfiguration configuration)
    {
        _fileRepository = fileRepository;
        _fileService = fileService;
        _configuration = configuration;
    }

    [HttpGet, Route("build")]
    public async Task<IActionResult> GetBuildNumber()
    {
        return Ok(_configuration["BuildNumber"]);
    }

    [HttpPost]
    [RequestSizeLimit(500_000_000)]
    public async Task<IActionResult> SaveFileDetails([FromForm] SaveFileDto details)
    {
        var userObjectId = GetUserObjectId(User);
        var response = await _fileRepository.InsertFileLog(details, userObjectId);
        return Ok(response);
    }

    [HttpPut, Route("{fileLogkey}/uploaded")]
    public async Task<IActionResult> UpdateFileStatusToUploaded(int fileLogkey)
    {
        await _fileRepository.UpdateFileStatusToUploaded(fileLogkey);
        return Ok();
    }

    [HttpGet]
    public async Task<IActionResult> GetFileByFilters(int orgId, string sourceData)
    {
        var response = await _fileRepository.GetFileByFilters(orgId, sourceData);
        return Ok(response);
    }

    [HttpGet, Route("{fileKey}/link")]
    public async Task<IActionResult> GetFileLinkByFileKey(int fileKey)
    {
        var response = await _fileRepository.GetFileLinkAsync(fileKey);
        return Ok(response);
    }

    [HttpGet, Route("link")]
    public async Task<IActionResult> GetFileLinkByFileName(string fileS3Name)
    {
        var response = await _fileRepository.GetFileLinkAsync(fileS3Name);
        return Ok(response);
    }

    [HttpGet, Route("{fileKey}/details")]
    public async Task<IActionResult> GetFileDetails(int fileKey)
    {
        if (fileKey < 1)
            return BadRequest();

        var response = await _fileService.GetFileLogDetails(fileKey);

        if (response is null)
            return NotFound();

        return Ok(response);
    }

    private string? GetUserObjectId(ClaimsPrincipal user)
    {
        try
        {
            var identity = user.Identity as ClaimsIdentity;

            if (identity != null && identity.Claims.Any())
                return identity.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier || c.Type == ClaimTypes.Name)?.Value;

            return null;
        }
        catch
        {
            return null;
        }
    }
}