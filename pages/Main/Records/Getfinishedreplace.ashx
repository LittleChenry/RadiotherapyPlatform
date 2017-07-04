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
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select replacement.ReplacementRequirements_ID as requirement,appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username from treatment,user,replacement,appointment,equipment where treatment.Replacement_ID=replacement.ID and replacement.Appointment_ID=appointment.ID and appointment.Equipment_ID=equipment.ID and replacement.Application_User_ID=user.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            string sqlCommand2 = "select End from appointment where ID=@appoint";
            sqlOperation1.AddParameterWithValue("@appoint", Convert.ToInt32(reader["appointid"].ToString()) + 1);
            string count = sqlOperation1.ExecuteScalar(sqlCommand2);
            backText.Append("{\"require\":\"" + reader["requirement"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + count +
                 "\",\"Date\":\"" + reader["Date"].ToString()   + "\",\"ApplicationTime\":\"" + reader["ApplicationTime"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
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