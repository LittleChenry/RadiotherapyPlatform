using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;

/// <summary>
/// 用户信息数据源类
/// </summary>
public class userDataSource
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
	public userDataSource()
	{
		
	}

    public DataSet Select(string activate, string office)
    {
        string sqlCommand = "SELECT * FROM user";
        string addStr = "";
        if (office != "allOffice")
        {
            addStr += " WHERE Office=@office";
            sqlOperation.AddParameterWithValue("@office", office);
        }
        if (activate != "allNumber")
        {
            if (addStr == "")
            {
                addStr += " WHERE Activate=@activate";               
            }
            else
            {
                addStr += " AND Activate=@activate";
            }
            sqlOperation.AddParameterWithValue("@activate", int.Parse(activate));
        }
        sqlCommand += addStr;
        DataSet myds = sqlOperation.ExecuteDataSet(sqlCommand, "user");
        return myds;
    }

    public void Update(string Number, string name, string Gender, string contact, string office, string Password)
    {
        string sqlCommand = "Update user set Name=@name,Gender=@sex,Contact=@contact,Office=@office,Password=@password WHERE Number=@number";
        sqlOperation.AddParameterWithValue("@name", name);
        sqlOperation.AddParameterWithValue("@sex", Gender);
        sqlOperation.AddParameterWithValue("@contact", contact);
        sqlOperation.AddParameterWithValue("@office", office);
        sqlOperation.AddParameterWithValue("@number", Number);
        sqlOperation.AddParameterWithValue("@password", Password);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    public void Delete(string Number)
    {
        string sqlCommand = "DELETE FROM user WHERE Number=@number";
        sqlOperation.AddParameterWithValue("@number", Number);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}