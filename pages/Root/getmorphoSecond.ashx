<%@ WebHandler Language="C#" Class="getmorphoSecond" %>

using System;
using System.Web;
using System.Text;

public class getmorphoSecond : IHttpHandler {
    
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

        string sqlCommand = "SELECT DISTINCT ID,Groupfirst FROM morphol WHERE Groupsecond=@first";

        sqlOperator.AddParameterWithValue("@first", first);

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        StringBuilder result = new StringBuilder("[");
        
        while(reader.Read()){
            result.Append("{\"id\":\"").Append(reader["ID"].ToString())
                  .Append("\",\"name\":\"").Append(reader["Groupfirst"].ToString())                  
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