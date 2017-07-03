<%@ WebHandler Language="C#" Class="changeReceiveUser" %>

using System;
using System.Web;
using System.Text;
public class changeReceiveUser : IHttpHandler {




    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
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
        DateTime datetime = DateTime.Now;
        String userID = context.Request.QueryString["userID"];
        String treatID = context.Request.QueryString["treatID"];
        string design = "select Design_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
        int designID = Convert.ToInt32(sqlOperation.ExecuteScalar(design));
        string finishappoint = "update design set Receive_User_ID=@userid,ReceiveTime=@ReceiveTime where ID=@designID";
        sqlOperation.AddParameterWithValue("@designID", designID);
        sqlOperation.AddParameterWithValue("@userid", Convert.ToInt32(userID));
        sqlOperation.AddParameterWithValue("@ReceiveTime", datetime);
        int Success = sqlOperation.ExecuteNonQuery(finishappoint);
        string change = "update treatment set Progress=@ReceiveTime where ID=@treatID";
        sqlOperation1.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
        sqlOperation1.AddParameterWithValue("@ReceiveTime",9);
        int Success1 = sqlOperation1.ExecuteNonQuery(change);
        if ( Success > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }
    }

}