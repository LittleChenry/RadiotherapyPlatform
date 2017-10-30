<%@ WebHandler Language="C#" Class="Getfinishedfirstaccelerate" %>

using System;
using System.Web;
using System.Text;

public class Getfinishedfirstaccelerate : IHttpHandler {
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select appointment_accelerate.ID as appointid,Equipment_ID,Begin,End,Date,Completed,user.Name as username,equipment.Name as equipname,ApplyTime from treatmentrecord,appointment_accelerate,equipment,user where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.ApplyUser=user.ID order by Date,Begin desc";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"Begin\":\"" + reader["Begin"].ToString() +"\",\"End\":\"" + reader["End"].ToString() +
                 "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Equipment_ID\":\"" + reader["Equipment_ID"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\",\"ApplyTime\":\"" + reader["ApplyTime"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\",\"appointid\":\"" + reader["appointid"].ToString() + "\"}");
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