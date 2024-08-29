using ServiceStack.OrmLite;
using ServiceStack.OrmLite.Sqlite;
using System.Data;

namespace CN.Incumbent.Tests.Generic;

public class InMemoryDatabase
{
    private readonly OrmLiteConnectionFactory dbFactory = new OrmLiteConnectionFactory(":memory:", SqliteOrmLiteDialectProvider.Instance);

    //public IDbConnection GetConnection() => this.dbFactory.OpenDbConnection();
    public IDbConnection OpenConnection() => this.dbFactory.OpenDbConnection();

    /// <summary>
    /// Insert a list of objects into a temporary database.
    /// If a tableName is passed it will create the table with that name otherwise it will use the T object name
    /// </summary>
    /// <typeparam name="T">Type object</typeparam>
    /// <param name="tableName">Table name</param>
    /// <param name="items">List of items T</param>
    public void Insert<T>(IEnumerable<T> items, string? tableName = null)
    {
        using (var db = this.OpenConnection())
        {
            if (string.IsNullOrEmpty(tableName))
            {
                db.CreateTableIfNotExists<T>();
            }
            else 
            {
                ExecWithAlias<T>(tableName, fn: () => { db.DropAndCreateTable<T>(); return null; });
            }
                
            foreach (var item in items)
            {
                db.Insert(item);
            }
        }
    }

    /// <summary>
    /// Create an empty table into a temporary database.
    /// </summary>
    /// <param name="tableName">Table name</param>
    public void CreateTable<T>(string tableName) where T : new()
    {
        using (var db = this.OpenConnection())
        {
            ExecWithAlias<T>(tableName, () => { db.CreateTable<T>(); return null; });
        }
    }

    /// <summary>
    /// Updates the table name.
    /// </summary>
    private static object ExecWithAlias<T>(string tableName, Func<object> fn)
    {
        var modelDef = typeof(T).GetModelMetadata();
        lock (modelDef)
        {
            try
            {
                modelDef.Alias = tableName;
                modelDef.Name = tableName;
                return fn();
            }
            catch(Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
    }
}