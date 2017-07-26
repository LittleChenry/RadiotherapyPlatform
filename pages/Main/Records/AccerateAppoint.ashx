<%@ WebHandler Language="C#" Class="AccerateAppoint" %>

using System;
using System.Web;

public class AccerateAppoint : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddFixRecord(context);
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
    public string AddFixRecord(HttpContext context)
    {
        //获取表单信息
        string appoint = context.Request["id"];
        string treatid = context.Request["treatid"];
        string strcommand = "select State from appointment where ID=@appointid";
        sqlOperation.AddParameterWithValue("@appointid", Convert.ToInt32(appoint));
        string count = sqlOperation.ExecuteScalar(strcommand);
        if (count == "1")
        {
            return "busy";
        }
        else
        {
            string strcommand1 = "update appointment set State=1 where ID=@appointid and State=0";
            int intSuccess = sqlOperation.ExecuteNonQuery(strcommand1);
            if (intSuccess == 0)
            {
                return "busy";
            }
            else
            {
                string strcommand2 = "select Patient_ID from treatment where ID=@treat";
                sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                string patient_ID = sqlOperation.ExecuteScalar(strcommand2);

                string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);
                //将信息写入数据库，并返回是否成功
                string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID) " +
                                        "VALUES(@Treatment_ID,@Appointment_ID)";
                sqlOperation1.AddParameterWithValue("@Appointment_ID", Convert.ToInt32(appoint));
                sqlOperation1.AddParameterWithValue("@Treatment_ID", Convert.ToInt32(treatid));
                int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);
                if ( Success2 > 0)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
        }

    }

}