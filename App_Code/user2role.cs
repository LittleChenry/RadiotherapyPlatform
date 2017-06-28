using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;

/// <summary>
/// user2role 的摘要说明
/// </summary>
public class user2role
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
	public user2role()
	{

	}

    public DataSet Select(string activate, string office)
    {
        string sqlCommand = "SELECT * FROM user,user2role";
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
        if (addStr == "")
        {
            addStr += " WHERE user.ID=user2role.User_ID";
        }
        else
        {
            addStr += " AND user.ID=user2role.User_ID";
        }
        sqlCommand += addStr;
        DataSet myds = sqlOperation.ExecuteDataSet(sqlCommand, "user");
        return myds;
    }
}