<%@ WebHandler Language="C#" Class="GetInspection" %>

using System;
using System.Web;
using System.Text;

public class GetInspection : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string cycle = context.Request.QueryString["cycle"];
        string model = context.Request.QueryString["model"];
        sqlOperation.AddParameterWithValue("@model", model);
        sqlOperation.AddParameterWithValue("@cycle", cycle);
        string sqlCommand = "SELECT * FROM Inspections WHERE Cycle=@cycle AND TemplateID=@model ORDER BY MainItem";
        StringBuilder backString = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"MainItem\":\"");
            backString.Append(reader["MainItem"].ToString());
            backString.Append("\",\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"ChildItem\":\"");
            backString.Append(reader["ChildItem"].ToString());
            backString.Append("\",\"Explain\":\"");
            backString.Append(reader["Explain"].ToString().Replace("\r\n",""));
            backString.Append("\",\"Reference\":\"");
            backString.Append(reader["Reference"].ToString());
            backString.Append("\",\"files\":\"");
            backString.Append(reader["files"].ToString());
            backString.Append("\"},");

        }
        backString.Remove(backString.Length - 1, 1);
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }

}