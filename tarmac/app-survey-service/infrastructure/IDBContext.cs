using System.Data;
using System.Data.Odbc;

namespace CN.Survey.Infrastructure;

public interface IDBContext
{
    public IDbConnection GetConnection();
    public OdbcConnection GetDataBricksConnection();
}