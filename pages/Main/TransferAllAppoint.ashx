<%@ WebHandler Language="C#" Class="TransferAllAppoint" %>

using System;
using System.Web;

public class TransferAllAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
       context.Response.ContentType = "text/plain";
        try
        {
            transferapp(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation=null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1=null;
            
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }

    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public void transferapp(HttpContext context)
    {
        string equipid = context.Request["equipid"];
        string maxdatecommand = "select max(Date) from appointment_accelerate,treatmentrecord where appointment_accelerate.ID=treatmentrecord.Appointment_ID and appointment_accelerate.Date>=@date and appointment_accelerate.Equipment_ID=@equipid";
        sqlOperation.AddParameterWithValue("@date", DateTime.Now.ToString("yyyy-MM-dd"));
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        string maxdate = sqlOperation.ExecuteScalar(maxdatecommand);
        DateTime maxdatetime = Convert.ToDateTime(maxdate);
        DateTime nowdatetime = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd"));
        DateTime temp=maxdatetime;
        while (DateTime.Compare(temp, nowdatetime) >= 0)
        {
            if (temp.DayOfWeek.ToString() != "Sunday" && temp.DayOfWeek.ToString() != "Saturday")
            {
                if (temp.DayOfWeek.ToString() == "Friday")
                {
                    string updatecommand = "UPDATE appointment_accelerate set Date=@newdate where Date=@olddate";
                    sqlOperation.AddParameterWithValue("@newdate", temp.AddDays(3));
                    sqlOperation.AddParameterWithValue("@olddate", temp);
                    sqlOperation.ExecuteNonQuery(updatecommand);
                }
                else
                {
                    string updatecommand = "UPDATE appointment_accelerate set Date=@newdate where Date=@olddate";
                    sqlOperation.AddParameterWithValue("@newdate", temp.AddDays(1));
                    sqlOperation.AddParameterWithValue("@olddate", temp);
                    sqlOperation.ExecuteNonQuery(updatecommand);
                }

            }
            temp = temp.AddDays(-1);
            
        }
    }
    

}