<%@ WebHandler Language="C#" Class="CheckWasInGroup" %>

using System;
using System.Web;

public class CheckWasInGroup : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = check(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string check(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string userID = context.Request.QueryString["id"];
        string sqlCommand = "SELECT count(ID) FROM user WHERE ID=@ID AND Group_ID not in(0) AND Group_ID IS NOT NULL";
        sqlOperation.AddParameterWithValue("@ID", int.Parse(userID));
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return (count == 0 ? "false":"true");
    }
}