<%@ WebHandler Language="C#" Class="judge" %>

using System;
using System.Web;

public class judge : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = gettotal(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string gettotal(HttpContext context)
    {
        string appoint = context.Request.QueryString["appointid"];
        int appointid = int.Parse(appoint);
        string treat = context.Request.QueryString["treat"];
        int treatid = int.Parse(treat);
        string sqlcommand = "select Treat_User_ID from treatmentrecord where Appointment_ID=@appoint and Treatment_ID=@treat";
        sqlOperation.AddParameterWithValue("@appoint", appointid);
        sqlOperation.AddParameterWithValue("@treat", treatid);
         string user=sqlOperation.ExecuteScalar(sqlcommand);
         if (user.ToString() == "")
         {
             return "success";
         }
         else
         {
             return "failure";
         }
    }

}