using CN.Survey.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CN.Survey.RestApi.Controllers;

[Authorize]
[Route("api/survey")]
[ApiController]
public class BenchmarkDataTypeController : ControllerBase
{
    private readonly IBenchmarkDataTypeRepository _benchmarkDataTypeRepository;

    public BenchmarkDataTypeController(IBenchmarkDataTypeRepository benchmarkDataTypeRepository)
    {
        _benchmarkDataTypeRepository = benchmarkDataTypeRepository;
    }

    [HttpGet("{sourceGroupKey}/benchmark-data-types")]
    public async Task<IActionResult> GetBenchmarkDataTypes(int sourceGroupKey)
    {
        var benchmarkDataTypes = await _benchmarkDataTypeRepository.GetBenchmarkDataTypes(sourceGroupKey);
        return Ok(benchmarkDataTypes);
    }
}