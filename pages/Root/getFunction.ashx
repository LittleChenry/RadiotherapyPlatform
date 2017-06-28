<%@ WebHandler Language="C#" Class="getFunction" %>

using System;
using System.Web;
using System.Text;

public class getFunction : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getFunctions();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getFunctions()
    {
        string sqlCommand = "SELECT count(ID) FROM function";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"func\":[{\"ID\":\"false\"}]}";
        }
        sqlCommand = "SELECT * FROM function";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder("{\"func\":[");
        int i = 1;
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\"}");
            if (i < count)
            {
                backString.Append(",");
            }
        }
        backString.Append("]}");
        return backString.ToString();
    }

}