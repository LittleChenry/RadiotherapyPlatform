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
        string sqlcommand2 = "select distinct(count(*)) from treatment,location,scanmethod,locationrequirements,enhancemethod,user where treatment.Patient_ID=@patient and treatment.Location_ID=location.ID   and  location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID and location.Application_User_ID=user.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand2 = "select distinct(treatment.Treatmentname) as treatname,Treatmentdescribe,Application_User_ID,scanmethod.Method as scanmethod,scanmethod.ID as scanmethodID,ScanPart_ID as scanpartID,UpperBound,LowerBound,locationrequirements.ID as locationrequireID,Appointment_ID,locationrequirements.Requirements as locationrequire,Enhance,location.EnhanceMethod_ID as enhancemethod,Remarks,ApplicationTime,user.Name as username,ApplicationTime from treatment,location,scanmethod,locationrequirements,enhancemethod,user where treatment.Patient_ID=@patient and treatment.Location_ID=location.ID  and  location.ScanMethod_ID=scanmethod.ID  and location.LocationRequirements_ID=locationrequirements.ID and location.Application_User_ID=user.ID ";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string date1 = "";
            string begin = "";
            string end = "";
            string equipname = "";
            if (reader["Appointment_ID"].ToString() != "")
            {
                string appointinfo = "select equipment.Name as equipname,Date,Begin,End from appointment,equipment where appointment.ID=@Appointment_ID and appointment.Equipment_ID=equipment.ID";
                sqlOperation1.AddParameterWithValue("@Appointment_ID", reader["Appointment_ID"].ToString());
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(appointinfo);
                if (reader1.Read())
                {
                    String date = reader1["Date"].ToString();
                    begin = reader1["Begin"].ToString();
                    end = reader1["End"].ToString();
                    equipname = reader1["equipname"].ToString();
                    DateTime dt1 = Convert.ToDateTime(date);
                    date1 = dt1.ToString("yyyy-MM-dd");
                }
                reader1.Close();

            }
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
            backText.Append("{\"scanmethod\":\"" + reader["scanmethod"].ToString() + "\",\"treatname\":\"" + reader["treatname"] + "\",\"scanmethodID\":\"" + reader["scanmethodID"] + "\",\"scanpartID\":\"" + reader["scanpartID"] + "\",\"locationrequireID\":\"" + reader["locationrequireID"] +
                 "\",\"UpperBound\":\"" + reader["UpperBound"].ToString() + "\",\"LowerBound\":\"" + reader["LowerBound"].ToString() + "\",\"equipname\":\"" + equipname + "\",\"appointid\":\"" + reader["Appointment_ID"].ToString() + "\",\"userID\":\"" + reader["Application_User_ID"].ToString() +
                 "\",\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
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