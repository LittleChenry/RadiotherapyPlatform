<%@ WebHandler Language="C#" Class="updateErrorInformation" %>

using System;
using System.Web;

public class updateErrorInformation : IHttpHandler {
    
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
        int id = int.Parse(context.Request.Form["id"]);
        string name = context.Request.Form["name"];
        string encode = context.Request.Form["encode"];
        string description = context.Request.Form["description"];

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommnad = "UPDATE errorInformation SET name=@name,encode=@encode,description=@description WHERE id=@id";
        sqlOperator.AddParameterWithValue("@name", name);
        sqlOperator.AddParameterWithValue("@encode", encode);
        sqlOperator.AddParameterWithValue("@description", description);
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.ExecuteNonQuery(sqlCommnad);
    }
}