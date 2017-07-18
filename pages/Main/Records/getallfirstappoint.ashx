<%@ WebHandler Language="C#" Class="getallfirstappoint" %>

using System;
using System.Web;
using System.Text;
public class getallfirstappoint : IHttpHandler {

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
        string treatid = context.Request.QueryString["treatmentID"];
        int treat = int.Parse(treatid);
        string sqlcommand = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        sqlOperation.AddParameterWithValue("treat", treatid);
        int count1 = int.Parse(sqlOperation.ExecuteScalar(sqlcommand));
        string sqlcommand2= "select max(ID) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        int count2 = int.Parse(sqlOperation.ExecuteScalar(sqlcommand2));
        string sqlcommand3 = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is  NULL and ID>@count";
        sqlOperation.AddParameterWithValue("@count", count2);
        int count3 = int.Parse(sqlOperation.ExecuteScalar(sqlcommand3));
        return count1 +count3+"";
    }


}