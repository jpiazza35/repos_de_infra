using Microsoft.Extensions.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;

namespace CN.Survey.Infrastructure;

public class BenchmarkDBContext : IDBContext
{
    private readonly IConfiguration _configuration;
    private readonly string _connectionString;
    private readonly string _connectionStringDataBricks;

    public BenchmarkDBContext(IConfiguration configuration)
    {
        _configuration = configuration;
        _connectionString = _configuration.GetConnectionString("BenchmarkConnection") ?? throw new ArgumentNullException("BenchmarkConnection");

        var dataBricksCatalogRawValue = _configuration["SurveyDataBricks_Catalog"] ?? throw new ArgumentNullException("SurveyDataBricks_Catalog");
        var dataBricksTokenRawValue = _configuration["SurveyDataBricks_Token"] ?? throw new ArgumentNullException("SurveyDataBricks_Token");
        var dataBricksRawValue = _configuration.GetConnectionString("SurveyDataBricks") ?? throw new ArgumentNullException("SurveyDataBricksConnection");

        _connectionStringDataBricks = string.Format(dataBricksRawValue, dataBricksCatalogRawValue, dataBricksTokenRawValue);
    }
    public IDbConnection GetConnection()
        => new SqlConnection(_connectionString);

    public OdbcConnection GetDataBricksConnection()
        => new OdbcConnection(_connectionStringDataBricks);
}
