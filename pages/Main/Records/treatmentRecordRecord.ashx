<%@ WebHandler Language="C#" Class="treatmentRecordRecord" %>

using System;
using System.Web;

public class treatmentRecordRecord : IHttpHandler {

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
        string treatid = context.Request["treatmentID"];
        int treat = int.Parse(treatid);
        string select1 = "select Progress from treatment where ID=@treatid";
        sqlOperation.AddParameterWithValue("@treatid", treat);
        string progress = sqlOperation.ExecuteScalar(select1);
        string strSqlCommand2 = "UPDATE  treatment  SET Progress=@progress where ID=@treatid ";
        sqlOperation.AddParameterWithValue("@progress", progress + ",15");
        int intSuccess2 = sqlOperation.ExecuteNonQuery(strSqlCommand2);
        if (intSuccess2 > 0)
        {
            return "success";
        }
        else
        {
            return "fail";
        }
    }


}