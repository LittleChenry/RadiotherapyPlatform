<%@ WebHandler Language="C#" Class="isCharger" %>

using System;
using System.Web;

public class isCharger : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = findCharger(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string findCharger(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string ids = context.Request.QueryString["data"];
        string[] chargers = ids.Split(' ');
        string sqlCommand = "SELECT COUNT(ID) FROM groups WHERE Charge_User_ID=@id";
        for (int i = 0; i < chargers.Length; ++i)
        {
            sqlOperation.AddParameterWithValue("@id", chargers[i]);
            int has = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            if (has > 0)
            {
                return "true";
            }
        }
        return "false";
    }
}