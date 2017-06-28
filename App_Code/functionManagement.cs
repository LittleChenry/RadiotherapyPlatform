using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using MySql.Data.MySqlClient;

/// <summary>
/// functionManagement 的摘要说明
/// </summary>
public class functionManagement
{
    DataLayer sqlOperation = new DataLayer("sqlStr");
	public functionManagement()
	{

	}

    public DataSet Select()
    {
        string sqlCommand = "SELECT * FROM function";
        DataSet myds = sqlOperation.ExecuteDataSet(sqlCommand, "function");
        return myds;
    }

    public void Delete(string ID)
    {
        string sqlCommand = "DELETE FROM function where ID=@id";
        sqlOperation.AddParameterWithValue("@id", ID);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}