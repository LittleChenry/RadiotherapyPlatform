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
        try{
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
            string select1 = "select Progress from treatment where ID=@treat";
            sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatID));
            string progress = sqlOperation.ExecuteScalar(select1);
            string change = "update treatment set Progress=@ReceiveTime,isback=0 where ID=@treatID";
            sqlOperation1.AddParameterWithValue("@treatID", Convert.ToInt32(treatID));
            sqlOperation1.AddParameterWithValue("@ReceiveTime", progress+",8");
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
        catch (System.Exception Ex1)
        {
            return "error";
        }
    }

}