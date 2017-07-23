<%@ WebHandler Language="C#" Class="gettreatmentnumber" %>

using System;
using System.Web;
using System.Text;

public class gettreatmentnumber : IHttpHandler {
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
        string treatid=context.Request.QueryString["treatmentID"];
        int treat=int.Parse(treatid);
        string sqlcommand = "select TotalNumber from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat",treatid);
        string totalnumber = sqlOperation.ExecuteScalar(sqlcommand);
        string sqlcommand1 = "select max(TreatedTimes) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
        string treattimes = sqlOperation.ExecuteScalar(sqlcommand1);
        return totalnumber.ToString() + "," + treattimes.ToString();
       
    }

}