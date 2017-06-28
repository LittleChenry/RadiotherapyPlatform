using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// roleManagement 的摘要说明
/// </summary>
public class roleManagement
{
    DataLayer sqlOperation = new DataLayer("sqlStr");
	public roleManagement()
	{

	}

    public DataSet Select()
    {
        string sqlCommand = "SELECT * FROM role";
        DataSet myds = sqlOperation.ExecuteDataSet(sqlCommand, "role");
        return myds;
    }

    public void Update(string id, string Description)
    {
        string sqlCommand = "UPDATE role SET Description=@description WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.AddParameterWithValue("@description", Description);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    public void Delete(string id)
    {
        string sqlCommand = "DELETE FROM role WHERE ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        sqlCommand = "DELETE FROM function2role WHERE Role_ID=@id";
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}