<%@ WebHandler Language="C#" Class="updateWarning" %>

using System;
using System.Web;

public class updateWarning : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        edit(context);
        context.Response.Write(" ");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public void edit(HttpContext context)
    {
        string item = context.Request.Form["item"];
        string light = context.Request.Form["light"];
        string serious = context.Request.Form["serious"];
        string updateWarningCommand = "UPDATE warning SET WarningLightTime=@WarningLightTime,WarningSeriousTime=@WarningSeriousTime WHERE WarningItem=@WarningItem";
        sqlOperation.AddParameterWithValue("@WarningLightTime", double.Parse(light));
        sqlOperation.AddParameterWithValue("@WarningSeriousTime",double.Parse(serious));
        sqlOperation.AddParameterWithValue("@WarningItem",item);
        sqlOperation.ExecuteNonQuery(updateWarningCommand);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
    } 
}