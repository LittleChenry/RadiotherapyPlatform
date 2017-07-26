<%@ WebHandler Language="C#" Class="addErrorInformation" %>

using System;
using System.Web;

public class addErrorInformation : IHttpHandler {
    
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
        string name = context.Request.Form["name"];
        string encode = context.Request.Form["encode"];
        string description = context.Request.Form["description"];

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "INSERT INTO errorInformation(name,encode,description) VALUES(@name,@encode,@description);SELECT @@IDENTITY";

        sqlOperator.AddParameterWithValue("@name", name);
        sqlOperator.AddParameterWithValue("@encode", encode);
        sqlOperator.AddParameterWithValue("@description", description);

        return sqlOperator.ExecuteScalar(sqlCommand);
    }
}