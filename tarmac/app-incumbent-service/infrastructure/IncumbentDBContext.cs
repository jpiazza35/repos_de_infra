using Microsoft.Extensions.Configuration;
using Npgsql;
using System.Data;

namespace CN.Incumbent.Infrastructure;

public class IncumbentDBContext : IDBContext
{
    private readonly IConfiguration _configuration;
    private readonly string _incumbentConnectionString;
    private readonly string _incumbentStagingConnectionString;

    public IncumbentDBContext(IConfiguration configuration)
    {
        _configuration = configuration;
        _incumbentConnectionString = _configuration.GetConnectionString("IncumbentConnection") ?? throw new ArgumentNullException("IncumbentConnection");
        _incumbentStagingConnectionString = _configuration.GetConnectionString("IncumbentStagingConnection") ?? throw new ArgumentNullException("IncumbentStagingConnection");
    }
    public IDbConnection GetIncumbentConnection()
        => new NpgsqlConnection(_incumbentConnectionString);

    public IDbConnection GetIncumbentStagingConnection()
        => new NpgsqlConnection(_incumbentStagingConnectionString);
}
