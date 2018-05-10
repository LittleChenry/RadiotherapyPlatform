<%@ WebHandler Language="C#" Class="checkLog" %>

using System;
using System.Web;
using System.Text;


public class checkLog : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = checkinfo(context);
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string checkinfo(HttpContext context)
    {

        string id = context.Request["infoid"];
        string command = "update loginfo set isChecked=1 where ID=@id";
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteScalar(command);
        return "success";

    }




}