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
        try
        {
            string treatID = context.Request.QueryString["treatid"];
            string radioID = context.Request.QueryString["radioid"];
            string part = context.Request.QueryString["part"];
            string diagresult = context.Request.QueryString["diagresult"];
            string diaguserid = context.Request.QueryString["diaguserid"];
            string remark = context.Request.QueryString["remark"];
            //查诊断号
            string patient = "select ID from patient where Radiotherapy_ID=@Radiotherapy_ID";
            sqlOperation.AddParameterWithValue("@Radiotherapy_ID", Convert.ToInt32(radioID));
            int patientID = Convert.ToInt32(sqlOperation.ExecuteScalar(patient));

            DateTime date = DateTime.Now;
            string date1 = date.ToString();
            //将信息写入数据库，并返回是否成功
            string strSqlCommand = "insert into diagnosisrecord(Part_ID,DiagnosisResult_ID,Diagnosis_User_ID,Time,Remarks)" +
                                    "values(@Part_ID,@DiagnosisResult_ID,@Diagnosis_User_ID,@Time,@Remarks)";

            sqlOperation1.AddParameterWithValue("@DiagnosisResult_ID", Convert.ToInt32(diagresult));
            sqlOperation1.AddParameterWithValue("@Diagnosis_User_ID", Convert.ToInt32(diaguserid));
            sqlOperation1.AddParameterWithValue("@Part_ID", Convert.ToInt32(part));
            sqlOperation1.AddParameterWithValue("@Time", date1);
            sqlOperation1.AddParameterWithValue("@Remarks", remark);

            int intSuccess = sqlOperation1.ExecuteNonQuery(strSqlCommand);
            string diag = "select ID from diagnosisrecord where Diagnosis_User_ID=@Diagnosis_User_ID and Time=@Time";
            sqlOperation.AddParameterWithValue("@Time", date1);
            sqlOperation.AddParameterWithValue("@Diagnosis_User_ID", Convert.ToInt32(diaguserid));
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(diag);
            int diagno = 0;
            if (reader.Read())
            {
                diagno = Convert.ToInt32(reader["ID"].ToString());
            }
            string strSqlCommand1 = "update treatment set Progress=@Progress,DiagnosisRecord_ID=@DiagnosisRecord_ID where Treatmentname=@treatid and Patient_ID=@patient";
            sqlOperation2.AddParameterWithValue("@treatid", treatID);
            sqlOperation2.AddParameterWithValue("@patient", patientID);
            sqlOperation2.AddParameterWithValue("@DiagnosisRecord_ID", diagno);
            sqlOperation2.AddParameterWithValue("@Progress", 2);
            int intSuccess1 = sqlOperation2.ExecuteNonQuery(strSqlCommand1);

            if (intSuccess > 0 && intSuccess1 > 0)
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
    