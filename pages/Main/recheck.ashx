<%@ WebHandler Language="C#" Class="recheck" %>

using System;
using System.Web;

public class recheck : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

        context.Response.Write(GetCheck(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public String GetCheck(HttpContext context)
    {
        string s = context.Request["radionumber"];
        string command = "select count(*) from patient where Radiotherapy_ID=@Radiotherapy_ID";
        sqlOperation.AddParameterWithValue("@Radiotherapy_ID", s);
        int success1 = int.Parse(sqlOperation.ExecuteScalar(command));
        if (success1 >= 1)
        {
            return "failure";
        }
        else
        {
            return "success";
        }
               
    }

}