<%@ WebHandler Language="C#" Class="getAppointmentByTime" %>

using System;
using System.Web;
using System.Text;

public class getAppointmentByTime : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getAppoint(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getAppoint(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string year = context.Request.Form["year"];
        string month = context.Request.Form["month"];
        string day = context.Request.Form["day"];
        string id = context.Request.Form["id"];
        string lyear = context.Request.Form["lyear"];
        string lmonth = context.Request.Form["lmonth"];
        string lday = context.Request.Form["lday"];

        string sqlCommand = "SELECT appointment.Patient_ID,appointment.ID aid,appointment.Task,appointment.Date,appointment.Equipment_ID,appointment.Begin,appointment.End,appointment.State,appointment.Completed,appointment.Treatment_ID,patient.Name FROM appointment LEFT JOIN patient ON appointment.Patient_ID=patient.ID WHERE Date >= @datebegin AND Date <= @dateend AND Equipment_ID=@id order by Date,Begin";
        sqlOperator.AddParameterWithValue("@datebegin",year+"-"+month+"-"+day);
        sqlOperator.AddParameterWithValue("@dateend",lyear+"-"+lmonth+"-"+lday);
        sqlOperator.AddParameterWithValue("@id",id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder("[");
        while(reader.Read()){
            backString.Append("{\"ID\":\"")
                     .Append(reader["aid"].ToString())
                     .Append("\",\"Task\":\"")
                     .Append(reader["Task"].ToString())
                     .Append("\",\"PatientID\":\"")
                     .Append(reader["Patient_ID"].ToString())
                     .Append("\",\"PatientName\":\"")
                     .Append(reader["Name"].ToString())
                     .Append("\",\"Date\":\"")
                     .Append(reader["Date"].ToString())
                     .Append("\",\"Equipment_ID\":\"")
                     .Append(reader["Equipment_ID"].ToString())
                     .Append("\",\"Begin\":\"")
                     .Append(reader["Begin"].ToString())
                     .Append("\",\"End\":\"")
                     .Append(reader["End"].ToString())
                     .Append("\",\"State\":\"")
                     .Append(reader["State"].ToString())
                     .Append("\",\"Completed\":\"")
                     .Append(reader["Completed"].ToString())
                     .Append("\",\"Treatment_ID\":\"")
                     .Append(reader["Treatment_ID"].ToString())
                     .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        sqlOperator.Close();
        sqlOperator.Dispose();
        reader.Close();
        return backString.ToString();
        
    }
    
}