using System.Data;

namespace CN.Incumbent.Infrastructure;

public interface IDBContext
{
    public IDbConnection GetIncumbentConnection();
    public IDbConnection GetIncumbentStagingConnection();
}