using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

/// <summary>
/// Gender 的摘要说明
/// </summary>
public class Gender
{
    private DataLayer sqlOperation = new DataLayer("sqlStr");
	public Gender()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}

    public DataTable Select()
    {
        string sqlCommand = "SELECT DISTINCT Gender FROM user";
        DataTable mydt = sqlOperation.ExecuteDataTable(sqlCommand);
        return mydt;
    }
}