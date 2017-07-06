<%@ WebHandler Language="C#" Class="checkNumberReapt" %>

using System;
using System.Web;

public class checkNumberReapt : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(check(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string check(HttpContext context)
    {
        string id = context.Request.QueryString["userName"];
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT COUNT(ID) FROM user WHERE Number=@id";
        sqlOperator.AddParameterWithValue("@id", id);
        int re = int.Parse(sqlOperator.ExecuteScalar(sqlCommand));
        return re > 0 ? "false" : "true";
    }

}