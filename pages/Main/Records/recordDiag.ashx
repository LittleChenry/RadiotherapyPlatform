<%@ WebHandler Language="C#" Class="recordDiag" %>

using System;
using System.Web;
using System.Collections;
using System.Text.RegularExpressions;

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
            string treatID = context.Request["treatid"];
            string part = context.Request["part"];
            string newpart = context.Request["newpart"];
            string diaguserid = context.Request["diaguserid"];
            string remark = context.Request["remark"];
            string treatname = context.Request["treatname"];
            string Aim = context.Request["Aim"];
            string patientjudge = context.Request["patientjudge"];
            string copybingli1 = context.Request["copybingli1"];
            string copybingli2 = context.Request["copybingli2"];
            string copybingqing1 = context.Request["copybingqing1"];
            string copybingqing2 = context.Request["copybingqing2"];
            string copybingqing3 = context.Request["copybingqing3"];
            string selectcode1 = "select ID from icdcode where Group1=@group1 and Group2=@group2 and Chinese=@group3";
            sqlOperation.AddParameterWithValue("@group1", copybingqing1);
            sqlOperation.AddParameterWithValue("@group2", copybingqing2);
            sqlOperation.AddParameterWithValue("@group3", copybingqing3);
            int code1 = Convert.ToInt32(sqlOperation.ExecuteScalar(selectcode1));

            string selectcode2 = "select ID from morphol where Groupsecond=@group3 and Groupfirst=@group4 ";
            sqlOperation.AddParameterWithValue("@group3", copybingli1);
            sqlOperation.AddParameterWithValue("@group4", copybingli2);
            int code2 = Convert.ToInt32(sqlOperation.ExecuteScalar(selectcode2));
            DateTime date = DateTime.Now;
            string date1 = date.ToString();
            //将信息写入数据库，并返回是否成功
            string strSqlCommand = "insert into diagnosisrecord(Part_ID,LightPart_ID,DiagnosisResult_ID,PathologyResult,TreatAim_ID,Diagnosis_User_ID,Time,Remarks)" +
                                    "values(@Part_ID,@LightPart_ID,@DiagnosisResult_ID,@PathologyResult,@TreatAim_ID,@Diagnosis_User_ID,@Time,@Remarks)";

            sqlOperation1.AddParameterWithValue("@Part_ID", Convert.ToInt32(part));
            sqlOperation1.AddParameterWithValue("@LightPart_ID", Convert.ToInt32(newpart));
            sqlOperation1.AddParameterWithValue("@DiagnosisResult_ID", code1);
            sqlOperation1.AddParameterWithValue("@PathologyResult", code2);
            sqlOperation1.AddParameterWithValue("@TreatAim_ID", Convert.ToInt32(Aim));
            sqlOperation1.AddParameterWithValue("@Diagnosis_User_ID", Convert.ToInt32(diaguserid));
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
            reader.Close();
            string select1 = "select Progress from treatment where ID=@treatid";
            sqlOperation.AddParameterWithValue("@treatid", treatID);
            string progress = sqlOperation.ExecuteScalar(select1);
            string[] group = progress.Split(',');
            bool exists = ((IList)group).Contains("1");
            if (!exists)
            {
                
                string strSqlCommand1 = "update treatment set Progress=@Progress,DiagnosisRecord_ID=@DiagnosisRecord_ID,Treatmentdescribe=@Treatmentdescribe where ID=@treatid";
                sqlOperation2.AddParameterWithValue("@treatid", treatID);
                sqlOperation2.AddParameterWithValue("@Treatmentdescribe", treatname);
                sqlOperation2.AddParameterWithValue("@DiagnosisRecord_ID", diagno);
                sqlOperation2.AddParameterWithValue("@Progress", "0,1");
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
            else
            {
                string strSqlCommand1 = "update treatment set DiagnosisRecord_ID=@DiagnosisRecord_ID,Treatmentdescribe=@Treatmentdescribe where ID=@treatid";
                sqlOperation2.AddParameterWithValue("@treatid", treatID);
                sqlOperation2.AddParameterWithValue("@Treatmentdescribe", treatname);
                sqlOperation2.AddParameterWithValue("@DiagnosisRecord_ID", diagno);
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


        }
        catch (System.Exception Ex1)
        {
            return "error";
        }
        }
    }     

    