<%@ WebHandler Language="C#" Class="getalllog" %>

using System;
using System.Web;

public class getalllog : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = getlog(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getlog(HttpContext context)
    {
        string treatID=context.Request.QueryString["treatmentID"];
        int treatid = Convert.ToInt32(treatID);
        string command = "select ChangeLog from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string result = sqlOperation.ExecuteScalar(command);
        return result;        
    }

}