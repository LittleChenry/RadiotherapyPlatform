<%@ WebHandler Language="C#" Class="changeAccerateAppoint" %>

using System;
using System.Web;

public class changeAccerateAppoint : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string result = AddFixRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
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
        string oldappoint = context.Request["oldappoint"];
        string appoint = context.Request["id"];
        string treatid = context.Request["treatid"];
        if (appoint != "")
        {
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

                    string updatefixappoint = "update treatmentrecord set Appointment_ID=@appointid where Appointment_ID=@appoint and Treatment_ID=@treat";
                    sqlOperation.AddParameterWithValue("@appoint", oldappoint);
                    int updatesuccess = sqlOperation.ExecuteNonQuery(updatefixappoint);

                    if (updatesuccess > 0)
                    {

                        string deleteappoint = "update appointment set Patient_ID=NULL,Treatment_ID=NULL,state=0 where ID=@appoint";
                        sqlOperation.AddParameterWithValue("appoint", Convert.ToInt32(oldappoint));
                        int Success = sqlOperation.ExecuteNonQuery(deleteappoint);
                        if (Success > 0)
                        {
                            return "success";
                        }
                    }

                    return "failure";

                }
            }

        }
        else
        {
            string updatefixappoint = "update treatmentrecord set Appointment_ID=NULL where Appointment_ID=@appoint and Treatment_ID=@treat";
            sqlOperation.AddParameterWithValue("@appoint", oldappoint);
            int updatesuccess = sqlOperation.ExecuteNonQuery(updatefixappoint);

            if (updatesuccess > 0)
            {

                string deleteappoint = "update appointment set Patient_ID=NULL,Treatment_ID=NULL,state=0 where ID=@appoint";
                sqlOperation.AddParameterWithValue("appoint", Convert.ToInt32(oldappoint));
                int Success = sqlOperation.ExecuteNonQuery(deleteappoint);
                if (Success > 0)
                {
                    return "success";
                }
            }

            return "failure";
        }
    }


}