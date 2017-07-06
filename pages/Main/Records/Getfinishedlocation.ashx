<%@ WebHandler Language="C#" Class="Getfinishedlocation" %>

using System;
using System.Web;
using System.Text;
public class Getfinishedlocation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = patientLocationInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string patientLocationInformation(HttpContext context)
    {
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select scanmethod.ID as scanmethod,scanpart.ID as scanpartname,UpperBound,LowerBound,locationrequirements.ID as locationrequire,Enhance,enhancemethod.ID as enhancemethod,Remarks,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username,ApplicationTime from treatment,location,scanmethod,scanpart,locationrequirements,enhancemethod,user,appointment,equipment where treatment.ID=@treat and treatment.Location_ID=location.ID and location.Appointment_ID=appointment.ID  and  location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID  and location.EnhanceMethod_ID=enhancemethod.ID and location.ScanPart_ID=scanpart.ID and location.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            string date = reader["Date"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            string date2 = reader["ApplicationTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            string date3 = dt2.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"scanmethod\":\"" + reader["scanmethod"].ToString() + "\",\"scanpartname\":\"" + reader["scanpartname"] +
                 "\",\"UpperBound\":\"" + reader["UpperBound"].ToString() + "\",\"LowerBound\":\"" + reader["LowerBound"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() +
                 "\",\"Date\":\"" + date1 + "\",\"locationrequire\":\"" + reader["locationrequire"].ToString() + "\",\"Enhance\":\"" + reader["Enhance"].ToString() + "\",\"enhancemethod\":\"" + reader["enhancemethod"].ToString() + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"ApplicationTime\":\"" + date3 + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
            backText.Append(",");
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }


}