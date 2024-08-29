using System.Data;

namespace CN.Project.Infrastructure.Repository;

public interface IDBContext
{
    public IDbConnection GetConnection();
}
