<%@ WebHandler Language="C#" Class="DeleteItem" %>

using System;
using System.Web;

public class DeleteItem : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        Delete(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void Delete(HttpContext context)
    {
        string id = context.Request.Form["id"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "DELETE FROM inspection WHERE ID=@id";
        string[] ids = id.Split(' ');
        for (int i = 0; i < ids.Length; i++)
        {
            if (ids[i] != "")
            {
                sqlOperation.AddParameterWithValue("@id", ids[i]);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
    }
    
}