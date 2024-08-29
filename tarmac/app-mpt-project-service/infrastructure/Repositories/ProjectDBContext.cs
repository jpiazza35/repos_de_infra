using Microsoft.Extensions.Configuration;
using Npgsql;
using System.Data;

namespace CN.Project.Infrastructure.Repository;

public class ProjectDBContext : IDBContext
{
    private readonly IConfiguration _configuration;
    private readonly string _connectionString;

    public ProjectDBContext(IConfiguration configuration)
    {
        _configuration = configuration;
        _connectionString = _configuration.GetConnectionString("MptProjectConnection") ?? throw new ArgumentNullException(nameof(_connectionString));
    }
    public IDbConnection GetConnection()
        => new NpgsqlConnection(_connectionString);
}