<%@ WebHandler Language="C#" Class="igrtrecord" %>

using System;
using System.Web;
 using System.Text;

public class igrtrecord : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = igrt(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
    private string igrt(HttpContext context)
    {

        int chid = Convert.ToInt32(context.Request["chid"]);
        string assistant = context.Request["assistant"];
        double xvalue = Convert.ToDouble(context.Request["xvalue"]);
        double yvalue = Convert.ToDouble(context.Request["yvalue"]);
        double zvalue = Convert.ToDouble(context.Request["zvalue"]);
        string way = context.Request["way"];
        int user = Convert.ToInt32(context.Request["user"]);
        string insert = "insert into igrt(Operate_User_ID,OperateTime,X_System,Y_System,Z_System,ChildDesign_ID,Assist,way) values(@Operate_User_ID,@OperateTime,@X_System,@Y_System,@Z_System,@ChildDesign_ID,@Assist,@way)";
        sqlOperation.AddParameterWithValue("@OperateTime", DateTime.Now);
        sqlOperation.AddParameterWithValue("@X_System", xvalue);
        sqlOperation.AddParameterWithValue("@Y_System", yvalue);
        sqlOperation.AddParameterWithValue("@Z_System", zvalue);
        sqlOperation.AddParameterWithValue("@Operate_User_ID", user);
        sqlOperation.AddParameterWithValue("@Assist", assistant);
        sqlOperation.AddParameterWithValue("@ChildDesign_ID", chid);
        sqlOperation.AddParameterWithValue("@way", way);
        int success = sqlOperation.ExecuteNonQuery(insert);
        if (success > 0)
        {
            return "success";
        }
        return "fail";

    }

}