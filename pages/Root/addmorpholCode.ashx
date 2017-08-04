<%@ WebHandler Language="C#" Class="addmorpholCode" %>

using System;
using System.Web;


public class addmorpholCode : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        add(context);
        context.Response.Write("");
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
        string name = context.Request.Form["name"];

        string sqlCommand = "INSERT INTO morphol(Groupfirst,Groupsecond) VALUES(@name,@first);SELECT @@IDENTITY";

        sqlOperator.AddParameterWithValue("@first", first);
        sqlOperator.AddParameterWithValue("@name", name);

        string id = sqlOperator.ExecuteScalar(sqlCommand);
        return id;
    }
}