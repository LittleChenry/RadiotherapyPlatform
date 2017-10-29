<%@ WebHandler Language="C#" Class="Getsplittimes" %>

using System;
using System.Web;

public class Getsplittimes : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getmodelItem(context);
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
    private string getmodelItem(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatid"];
        string sqlCommand = "SELECT Times FROM splitway,treatment where treatment.SplitWay_ID=splitway.ID and treatment.ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        string inter = sqlOperation.ExecuteScalar(sqlCommand);
        return inter;
    }

}