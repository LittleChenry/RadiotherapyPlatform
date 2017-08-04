<%@ WebHandler Language="C#" Class="getThird" %>

using System;
using System.Web;
using System.Text;

public class getThird : IHttpHandler {
    
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
        string second = context.Request.Form["second"];

        string sqlCommand = "SELECT ID,code,Chinese FROM icdcode WHERE Group2=@second";

        sqlOperator.AddParameterWithValue("@second", second);

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        StringBuilder result = new StringBuilder("[");
        
        while(reader.Read()){
            result.Append("{\"id\":\"").Append(reader["ID"].ToString())
                  .Append("\",\"code\":\"").Append(reader["code"].ToString())
                  .Append("\",\"name\":\"").Append(reader["Chinese"].ToString())
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