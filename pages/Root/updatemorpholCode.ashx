<%@ WebHandler Language="C#" Class="updatemorpholCode" %>

using System;
using System.Web;

public class updatemorpholCode : IHttpHandler {
    
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
        string name = context.Request.Form["name"];

        string sqlCommand = "UPDATE morphol SET Groupfirst=@name WHERE ID=@id";

        sqlOperator.AddParameterWithValue("@name", name);
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.ExecuteNonQuery(sqlCommand);

    }
}