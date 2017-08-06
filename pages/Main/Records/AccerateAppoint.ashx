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
        string appoint = context.Request["appoint"];
        string treatid = context.Request["treatid"];
        string[] array=appoint.Split(',');
        for (int k = 1; k < array.Length; k++)
        {
            string strcommand1 = "update appointment set State=1 where ID=@appointid and State=0";
            sqlOperation.AddParameterWithValue("@appointid", array[k]);
            int intSuccess = sqlOperation.ExecuteNonQuery(strcommand1);
            if (intSuccess == 0)
            {
                for (int j = 1; j < k; j++)
                {
                    string strcommand2 = "update appointment set State=0 where ID=@appointid and State=1";
                    sqlOperation.AddParameterWithValue("@appointid", array[j]);
                      sqlOperation.ExecuteNonQuery(strcommand2);
                }
                return "busy";
            }
    
        } 
        string strcommand3 = "select Patient_ID from treatment where ID=@treat";
       sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(treatid));
        string patient_ID = sqlOperation.ExecuteScalar(strcommand3);
        Boolean flag=true;
       for (int k = 1; k < array.Length; k++)
        {
                string finishappoint = "update appointment set Patient_ID=@Patient,Treatment_ID=@treat where ID=@appointid";
                sqlOperation.AddParameterWithValue("@appointid", array[k]);
                sqlOperation.AddParameterWithValue("@Patient", Convert.ToInt32(patient_ID));
                int Success1 = sqlOperation.ExecuteNonQuery(finishappoint);
                //将信息写入数据库，并返回是否成功
                string strSqlCommand = "INSERT INTO treatmentrecord(Treatment_ID,Appointment_ID) " +
                                        "VALUES(@Treatment_ID,@Appointment_ID)";
                sqlOperation1.AddParameterWithValue("@Appointment_ID", array[k]);
                sqlOperation1.AddParameterWithValue("@Treatment_ID", Convert.ToInt32(treatid));
                int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);
                if ( Success2 == 0)
                {
                    flag=false;
                    break;
                }
               
      }
      if( flag==true)
      {
          return "success";
      }else
      {
          return "failure";
      }

    }

}