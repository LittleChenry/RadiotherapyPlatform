<%@ WebHandler Language="C#" Class="getErrorInformation" %>

using System;
using System.Web;
using System.Text;

public class getErrorInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getInformation());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation()
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT * FROM errorInformation";

        StringBuilder result = new StringBuilder("[");

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            result.Append("{\"id\":\"").Append(reader["id"].ToString())
                  .Append("\",\"name\":\"").Append(reader["name"].ToString())
                  .Append("\",\"encode\":\"").Append(reader["encode"].ToString())
                  .Append("\",\"description\":\"").Append(reader["description"].ToString())
                  .Append("\"},");
        }

        result.Remove(result.Length - 1, 1).Append("]");
        return result.ToString();
    }
}