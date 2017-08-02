<%@ WebHandler Language="C#" Class="changeReplaceAppoint" %>

using System;
using System.Web;

public class changeReplaceAppoint : IHttpHandler {


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
        string appoint = context.Request["newappoint"];
        string oldappoint = context.Request["oldappoint"];
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
                    string asktreat = "select Treatment_ID from appointment where ID=@oldappointid";
                    sqlOperation.AddParameterWithValue("@oldappointid", Convert.ToInt32(context.Request["oldappoint"]));
                    string treatid = sqlOperation.ExecuteScalar(asktreat);
                    string strcommand2 = "select Patient_ID from treatment where ID=@treat";
                    sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
                    string patient_ID = sqlOperation.ExecuteScalar(strcommand2);

                    string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                    sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                    int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);

                    string search = "select Replacement_ID from treatment where ID=@treat";
                    string replacement = sqlOperation.ExecuteScalar(search);

                    string updatefixappoint = "update replacement set Appointment_ID=@appointid where ID=@replacement";
                    sqlOperation.AddParameterWithValue("@replacement", Convert.ToInt32(replacement));
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


}