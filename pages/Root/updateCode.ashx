<%@ WebHandler Language="C#" Class="updateCode" %>

using System;
using System.Web;

public class updateCode : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        update(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void update(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");

        string id = context.Request.Form["id"];
        string code = context.Request.Form["code"];
        string name = context.Request.Form["name"];

        string sqlCommand = "UPDATE icdcode SET code=@code,Chinese=@name WHERE ID=@id";

        sqlOperator.AddParameterWithValue("@code", code);
        sqlOperator.AddParameterWithValue("@name", name);
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.ExecuteNonQuery(sqlCommand);
            
    }
}