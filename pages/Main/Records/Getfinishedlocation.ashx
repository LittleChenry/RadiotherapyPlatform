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
        int treatid = Convert.ToInt32(context.Request.QueryString["treatmentID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        string sqlcommand2 = "select distinct(count(*)) from treatment,location,scanmethod,scanpart,locationrequirements,enhancemethod,user,appointment,equipment where treatment.Patient_ID=@patient and treatment.Location_ID=location.ID and location.Appointment_ID=appointment.ID  and  location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID and location.ScanPart_ID=scanpart.ID and location.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand2 = "select distinct(treatment.Treatmentname) as treatname,Treatmentdescribe,scanmethod.Method as scanmethod,scanmethod.ID as scanmethodID,scanpart.ID as scanpartID,scanpart.Name as scanpartname,UpperBound,LowerBound,locationrequirements.ID as locationrequireID,locationrequirements.Requirements as locationrequire,Enhance,location.EnhanceMethod_ID as enhancemethod,Remarks,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username,ApplicationTime from treatment,location,scanmethod,scanpart,locationrequirements,enhancemethod,user,appointment,equipment where treatment.Patient_ID=@patient and treatment.Location_ID=location.ID and location.Appointment_ID=appointment.ID  and  location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID and location.ScanPart_ID=scanpart.ID and location.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string date = reader["Date"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            string date2 = reader["ApplicationTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            string date3 = dt2.ToString("yyyy-MM-dd HH:mm");
            string method = "";
            if (reader["Enhance"].ToString() == "1")
            {
                string sqlcommand3 = "select Method from enhancemethod where ID=@enhancemethod";
                sqlOperation1.AddParameterWithValue("@enhancemethod", Convert.ToInt32(reader["enhancemethod"].ToString()));
                method = sqlOperation1.ExecuteScalar(sqlcommand3);
            }
            backText.Append("{\"scanmethod\":\"" + reader["scanmethod"].ToString() + "\",\"treatname\":\"" + reader["treatname"] + "\",\"scanmethodID\":\"" + reader["scanmethodID"] + "\",\"scanpartID\":\"" + reader["scanpartID"] + "\",\"scanpartname\":\"" + reader["scanpartname"] + "\",\"locationrequireID\":\"" + reader["locationrequireID"] +
                 "\",\"UpperBound\":\"" + reader["UpperBound"].ToString() + "\",\"LowerBound\":\"" + reader["LowerBound"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                 "\",\"Date\":\"" + date1 + "\",\"locationrequire\":\"" + reader["locationrequire"].ToString() + "\",\"Enhance\":\"" + reader["Enhance"].ToString() + "\",\"enhancemethod\":\"" + reader["enhancemethod"].ToString() + "\",\"methodname\":\"" + method + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"ApplicationTime\":\"" + date3 + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
            
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }


}