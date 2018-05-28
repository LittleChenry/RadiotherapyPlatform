<%@ WebHandler Language="C#" Class="recordTaskWarning" %>
using System;
using System.Web;
using System.Text;

public class recordTaskWarning : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";

            string json = recordWarnning(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;

            context.Response.Write(json);
     
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string recordWarnning(HttpContext context)
    {
        string treatid = context.Request["treatid"];
        string progress = context.Request["progress"];
        string type = context.Request["type"];
        string delayTime = context.Request["delayTime"];
        string checkcommand="select count(*) from taskWarning where treatID=@treat and CurrentProgress=@progess";
        sqlOperation.AddParameterWithValue("@progess", progress);
        sqlOperation.AddParameterWithValue("@treat", treatid);
        int result = int.Parse(sqlOperation.ExecuteScalar(checkcommand));
        if (result == 0)
        {
            string recordcommand = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            sqlOperation.AddParameterWithValue("@currentprogress", progress);
            if (type == "0")
            {
                sqlOperation.AddParameterWithValue("@type", "黄色预警");
            }
            else
            {
                sqlOperation.AddParameterWithValue("@type", "红色预警");
            }
            sqlOperation.AddParameterWithValue("@time", delayTime);
            sqlOperation.ExecuteNonQuery(recordcommand);
          
        }else
        {

            string recordcommand = "delete from taskWarning where TreatID=@treat and CurrentProgress=@progress";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            sqlOperation.AddParameterWithValue("@currentprogress", progress);
            sqlOperation.ExecuteNonQuery(recordcommand);

            string recordcommand2 = "insert into taskWarning(TreatID,CurrentProgress,Type,Time) VALUES(@treat,@currentprogress,@type,@time)";
            sqlOperation.AddParameterWithValue("@treat", treatid);
            sqlOperation.AddParameterWithValue("@currentprogress", progress);
            if (type == "0")
            {
                sqlOperation.AddParameterWithValue("@type", "黄色预警");
            }
            else
            {
                sqlOperation.AddParameterWithValue("@type", "红色预警");
            }
            sqlOperation.AddParameterWithValue("@time", delayTime);
            sqlOperation.ExecuteNonQuery(recordcommand2);
            
        }
        return "success";
    }

}