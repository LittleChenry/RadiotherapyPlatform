<%@ WebHandler Language="C#" Class="deleteErrorInformation" %>

using System;
using System.Web;

public class deleteErrorInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        delete(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void delete(HttpContext context)
    {
        int id = int.Parse(context.Request.Form["id"]);

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "DELETE FROM errorInformation WHERE id=@id";
        sqlOperator.AddParameterWithValue("@id", id);
        sqlOperator.ExecuteNonQuery(sqlCommand);
    }
}