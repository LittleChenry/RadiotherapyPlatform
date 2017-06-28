<%@ WebHandler Language="C#" Class="checkNameReapt" %>

using System;
using System.Web;

public class checkNameReapt : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = checkReapt(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string checkReapt(HttpContext context)
    {
        string name = context.Request.QueryString["name"];
        string sqlCommand = "SELECT count(ID) FROM role WHERE Name=@name";
        sqlOperation.AddParameterWithValue("@name", name);
        int re = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        return (re > 0 ? "repeat" : "false");
    }
}