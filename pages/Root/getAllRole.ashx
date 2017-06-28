<%@ WebHandler Language="C#" Class="getAllRole" %>

using System;
using System.Web;
using System.Text;

public class getAllRole : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string getroles = GetRole();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(getroles);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    /// <summary>
    /// 读取数据库，返回存在的所有角色，生成json
    /// </summary>
    /// <returns></returns>
    private string GetRole()
    {
        string sqlCommand = "SELECT DISTINCT Name,Description FROM role";
        string countStr = "SELECT count(ID) FROM role";
        int count = int.Parse(sqlOperation.ExecuteScalar(countStr));
        if (count == 0)
        {
            return "{\"role\":[{\"Name\":\"false\"}]}";
        }
        StringBuilder text = new StringBuilder("{\"role\":[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        int i = 1;
        while (reader.Read())
        {
            text.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"Description\":\"" + reader["Description"].ToString()
                + "\"}");
            if (i < count)
            {
                text.Append(",");
            }
            else
            {
                text.Append("]}");
            }
            i++;
        }
        sqlOperation.Close();
        return text.ToString();
    }

}