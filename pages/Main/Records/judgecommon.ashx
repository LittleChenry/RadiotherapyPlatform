<%@ WebHandler Language="C#" Class="judgecommon" %>

using System;
using System.Web;

public class judgecommon : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getjudegecommon(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getjudegecommon(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        string command = "SELECT iscommon FROM treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string iscommon = sqlOperation.ExecuteScalar(command);
        return iscommon;
    }

}