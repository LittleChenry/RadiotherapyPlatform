<%@ WebHandler Language="C#" Class="getSecond" %>

using System;
using System.Web;
using System.Text;

public class getSecond : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(get(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string get(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string first = context.Request.Form["first"];

        string sqlCommand = "SELECT DISTINCT Group2 FROM icdcode WHERE Group1=@first";

        sqlOperator.AddParameterWithValue("@first", first);

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"group\":\"").Append(reader["Group2"].ToString())
                  .Append("\"},");
        }
        result.Remove(result.Length - 1, 1).Append("]");

        reader.Close();
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        
        return result.ToString();
    }
}