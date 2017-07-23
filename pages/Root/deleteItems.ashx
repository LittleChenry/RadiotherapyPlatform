<%@ WebHandler Language="C#" Class="deleteItems" %>

using System;
using System.Web;

public class deleteItems : IHttpHandler {
    
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
        string sqlCommand = "DELETE FROM inspections WHERE ID=@id";
        sqlOperator.AddParameterWithValue("@id", id);
        sqlOperator.ExecuteNonQuery(sqlCommand);

        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
    }
}