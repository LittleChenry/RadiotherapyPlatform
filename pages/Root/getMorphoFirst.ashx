<%@ WebHandler Language="C#" Class="getMorphoFirst" %>

using System;
using System.Web;
using System.Text;

public class getMorphoFirst : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(get());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string get()
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT DISTINCT Groupsecond FROM morphol";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"group\":\"").Append(reader["Groupsecond"].ToString()).Append("\"},");
        }
        result.Remove(result.Length - 1, 1).Append("]");

        reader.Close();
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;

        return result.ToString();
    }
}