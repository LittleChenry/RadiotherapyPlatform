<%@ WebHandler Language="C#" Class="updateItem" %>

using System;
using System.Web;

public class updateItem : IHttpHandler {
    
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
        string mainItem = context.Request.Form["mainItem"];
        string childItem = context.Request.Form["childItem"];
        string type = context.Request.Form["type"];
        string explain = context.Request.Form["explain"];
        string reference = context.Request.Form["reference"];

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "UPDATE inspections SET MainItem=@mainItem,ChildItem=@childItem,inspections.Explain=@explain,Reference=@reference WHERE ID=@id";
        sqlOperator.AddParameterWithValue("@mainItem", mainItem);
        sqlOperator.AddParameterWithValue("@childItem", childItem);
        sqlOperator.AddParameterWithValue("@explain", explain);
        sqlOperator.AddParameterWithValue("@reference", reference);
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.ExecuteNonQuery(sqlCommand);


    }

}