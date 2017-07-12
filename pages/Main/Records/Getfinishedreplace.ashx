<%@ WebHandler Language="C#" Class="Getfinishedreplace" %>

using System;
using System.Web;
using System.Text;

public class Getfinishedreplace : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientReplaceInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientReplaceInformation(HttpContext context)
    {
        int treatid = Convert.ToInt32(context.Request.QueryString["treatmentID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        string sqlcommand = "select distinct(count(*)) from treatment,user,replacement,appointment,equipment,replacementrequirements where replacement.ReplacementRequirements_ID=replacementrequirements.ID and treatment.Replacement_ID=replacement.ID and replacement.Appointment_ID=appointment.ID and appointment.Equipment_ID=equipment.ID and replacement.Application_User_ID=user.ID and treatment.Patient_ID=@patient";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand1 = "select replacementrequirements.Requirements as replacerequire,Treatmentname,replacement.ReplacementRequirements_ID as requirement,appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username from treatment,user,replacement,appointment,equipment,replacementrequirements where replacement.ReplacementRequirements_ID=replacementrequirements.ID and treatment.Replacement_ID=replacement.ID and replacement.Appointment_ID=appointment.ID and appointment.Equipment_ID=equipment.ID and replacement.Application_User_ID=user.ID and treatment.Patient_ID=@patient";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand1);
        while (reader.Read())
        {
            string sqlCommand2 = "select End from appointment where ID=@appoint";
            sqlOperation1.AddParameterWithValue("@appoint", Convert.ToInt32(reader["appointid"].ToString()) + 1);
            string count1 = sqlOperation1.ExecuteScalar(sqlCommand2);
            string desgin = "select PDF from design,treatment where treatment.Design_ID=design.ID and treatment.ID=@treatid";
            sqlOperation1.AddParameterWithValue("@treatid", treatid);
            string pdf = sqlOperation1.ExecuteScalar(desgin);
            backText.Append("{\"require\":\"" + reader["replacerequire"].ToString() + "\",\"requirement\":\"" + reader["requirement"].ToString() + "\",\"treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + count1 +
                 "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"ApplicationTime\":\"" + reader["ApplicationTime"].ToString() + "\",\"pdf\":\"" + pdf.ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
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
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        return backText.ToString();

    }
}