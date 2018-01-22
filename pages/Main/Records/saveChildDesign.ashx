<%@ WebHandler Language="C#" Class="saveChildDesign" %>

using System;
using System.Web;

public class saveChildDesign : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = savechidesign(context);
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
    private string savechidesign(HttpContext context)
    {
        string chid = context.Request["chid"];
        string totalnumber = context.Request["totalnumber"];
        string username = context.Request["username"];
        string splitway = context.Request["splitway"];
        string remarks=context.Request["remarks"];
        string select = "select ChangeLog from childdesign where ID=@chid";
        sqlOperation.AddParameterWithValue("@chid", chid);
        string log = sqlOperation.ExecuteScalar(select);
        string command = "update childdesign set State=3,Changelog=@log,Totalnumber=@totalnumber,SpecialEnjoin=@special,Splitway_ID=@splitway where ID=@chid";
        sqlOperation.AddParameterWithValue("@totalnumber", totalnumber);
        sqlOperation.AddParameterWithValue("@special", remarks);
        sqlOperation.AddParameterWithValue("@splitway", splitway);
        sqlOperation.AddParameterWithValue("@log", log + ";" + username + "," + DateTime.Now + "," + totalnumber);
        int num = sqlOperation.ExecuteNonQuery(command);
        if (num == 0)
        {
            return "failure";
        }
        else
        {
            return "success";
        }
        
    }
    
    
    
    
    }