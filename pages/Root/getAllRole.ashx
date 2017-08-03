<%@ WebHandler Language="C#" Class="getAllRole" %>

using System;
using System.Web;
using System.Text;

public class getAllRole : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string getroles = GetRole();
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

        StringBuilder text = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            text.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"Description\":\"" + reader["Description"].ToString()
                + "\"},");
        }
        text.Remove(text.Length - 1, 1).Append("]");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return text.ToString();
    }

}