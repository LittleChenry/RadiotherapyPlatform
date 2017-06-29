<%@ WebHandler Language="C#" Class="recordDiag" %>

using System;
using System.Web;

public class recordDiag : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
  
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = AddDiagnoseRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string AddDiagnoseRecord(HttpContext context)
    {
        //获取表单信息

        string treatID =context.Request.QueryString["treatid"];
        string part = context.Request.QueryString["part"];
        string diagresult = context.Request.QueryString["diagresult"];
        string diaguserid =context.Request.QueryString["diaguserid"];
        string remark = context.Request.QueryString["remark"];
        //查诊断号
        string diag = "select DiagnosisRecord_ID from treatment where ID=@treat";
        sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatID));
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(diag);
         int diagno=0;
         if (reader.Read())
         {
             diagno = Convert.ToInt32(reader["DiagnosisRecord_ID"].ToString());
         }
         string strSqlCommand1 = "update treatment set Progress=@Progress where ID=@treatid";
         sqlOperation2.AddParameterWithValue("@treatid", treatID);
         sqlOperation2.AddParameterWithValue("@Progress", 2);
         int intSuccess1 = sqlOperation2.ExecuteNonQuery(strSqlCommand1);
      

        //将信息写入数据库，并返回是否成功
        string strSqlCommand = "update diagnosisrecord set Part_ID=@Part_ID,DiagnosisResult_ID=@DiagnosisResult_ID,Diagnosis_User_ID=@Diagnosis_User_ID,Time=@Time,Remarks=@Remarks where ID=@diagid";

        sqlOperation1.AddParameterWithValue("@DiagnosisResult_ID", Convert.ToInt32(diagresult));
        sqlOperation1.AddParameterWithValue("@Diagnosis_User_ID", Convert.ToInt32(diaguserid));
        sqlOperation1.AddParameterWithValue("@Part_ID", Convert.ToInt32(part));
        sqlOperation1.AddParameterWithValue("@Time", DateTime.Now);
        sqlOperation1.AddParameterWithValue("@Remarks", remark);
        sqlOperation1.AddParameterWithValue("@diagid", diagno);
        int intSuccess = sqlOperation1.ExecuteNonQuery(strSqlCommand);

        if (intSuccess > 0 && intSuccess1>0)
        {
            return "success";
        }
        else
        {
           return "failure";
        }

    }
        
        
        
    }
    