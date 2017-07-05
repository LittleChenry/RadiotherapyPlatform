<%@ WebHandler Language="C#" Class="recordSummary" %>

using System;
using System.Web;

public class recordSummary : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddDiagnoseRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
       
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string AddDiagnoseRecord(HttpContext context)
    {
        //获取表单信息

        string treatID = context.Request.QueryString["treatid"];      
        string userid = context.Request.QueryString["userid"];
        string remark = context.Request.QueryString["content"];
        //查诊断号
        string diag = "select patient_ID from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatID));
        int patient = Convert.ToInt32(sqlOperation.ExecuteScalar(diag));        
        DateTime datetime = DateTime.Now;
        //将信息写入数据库，并返回是否成功
        string strSqlCommand = "INSERT INTO summary(Content,Patient_ID,Operator_User_ID,OperateTime) " +
                                        "VALUES(@content,@Patient_ID,@Operate_User_ID,@OperateTime)";
        sqlOperation1.AddParameterWithValue("@content", remark);
        sqlOperation1.AddParameterWithValue("@Patient_ID", patient);
        sqlOperation1.AddParameterWithValue("@Operate_User_ID", Convert.ToInt32(userid));
        sqlOperation1.AddParameterWithValue("@OperateTime", datetime);
        int Success1 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

        if ( Success1 > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }

    }



}
    