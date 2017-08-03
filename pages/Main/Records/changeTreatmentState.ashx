<%@ WebHandler Language="C#" Class="changeTreatmentState" %>

using System;
using System.Web;
using System.Text;
public class changeTreatmentState : IHttpHandler {
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);      
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getprinItem(HttpContext context)
    {
        try{
            String state = context.Request.QueryString["state"];
            String treatID = context.Request.QueryString["treatID"];           
            string change = "update treatment set State=@state where ID=@treatID";
            sqlOperation1.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
            sqlOperation1.AddParameterWithValue("@state", Convert.ToInt32(state));
            int Success1 = sqlOperation1.ExecuteNonQuery(change);
            if ( Success1 > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
        }
        catch (System.Exception Ex1)
        {
            return "error";
        }
    }

}