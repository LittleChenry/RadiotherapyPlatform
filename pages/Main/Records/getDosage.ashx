<%@ WebHandler Language="C#" Class="getDosage" %>

using System;
using System.Web;

public class getDosage : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(get(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public string get(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string treatID = context.Request.Form["treatID"];
        string selectDesignID = "SELECT Design_ID FROM treatment WHERE ID=@ID";
        sqlOperation.AddParameterWithValue("@ID",treatID);
        string designID = sqlOperation.ExecuteScalar(selectDesignID);
        string selectDosage = "SELECT DosagePriority FROM design WHERE id=@designid";
        sqlOperation.AddParameterWithValue("@designid", designID);
        string result = sqlOperation.ExecuteScalar(selectDosage);
        result = result.Split(new char[1] { '&' })[0];
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return result;
    }
}