<%@ WebHandler Language="C#" Class="addCode" %>

using System;
using System.Web;

public class addCode : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(add(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string add(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string first = context.Request.Form["first"];
        string second = context.Request.Form["second"];
        string code = context.Request.Form["code"];
        string name = context.Request.Form["name"];

        string sqlCommand = "INSERT INTO icdcode(Group1,Group2,code,Chinese) VALUES(@first,@second,@code,@name);SELECT @@IDENTITY";

        sqlOperator.AddParameterWithValue("@first", first);
        sqlOperator.AddParameterWithValue("@second", second);
        sqlOperator.AddParameterWithValue("@code", code);
        sqlOperator.AddParameterWithValue("@name", name);

        string id = sqlOperator.ExecuteScalar(sqlCommand);
        return id;
    }
}