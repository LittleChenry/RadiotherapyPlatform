<%@ WebHandler Language="C#" Class="computeOtherDays" %>

using System;
using System.Web;
using System.Text;

public class computeOtherDays : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getOtherDays(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;

            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getOtherDays(HttpContext context)
    {
        string start = context.Request["starttime"];
        string end = context.Request["endtime"];
        string command = "select count(*) from worktimetable where Date>@begindate and  Date<@enddate and IsUsed =1";
        sqlOperation.AddParameterWithValue("@begindate", start);
        sqlOperation.AddParameterWithValue("@enddate", end);
        string result = sqlOperation.ExecuteScalar(command);
        return result;  
    }
    
    

}