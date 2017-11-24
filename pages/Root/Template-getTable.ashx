<%@ WebHandler Language="C#" Class="Template_getTable" %>

using System;
using System.Web;
using System.Text;

public class Template_getTable : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getList(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string getList(HttpContext context)
    {
        string sqlCommand = "SELECT * FROM doctortemplate WHERE type=@type AND User_ID=0";
        StringBuilder backString = new StringBuilder("[");
        sqlOperation.AddParameterWithValue("@type",context.Request.Form["type"]);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\",\"TemplateID\":\"")
                      .Append(reader["TemplateID"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }
}