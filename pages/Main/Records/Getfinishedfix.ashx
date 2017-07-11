<%@ WebHandler Language="C#" Class="Getfinishedfix" %>

using System;
using System.Web;
using System.Text;

public class Getfinishedfix : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        int treatid = Convert.ToInt32(context.Request.QueryString["treatmentID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        string sqlcommand2 = "select count(*) from treatment,fixed,fixedequipment,fixedrequirements,material,user,appointment,equipment where treatment.Patient_ID=@patient and treatment.Fixed_ID=fixed.ID and fixed.Appointment_ID=appointment.ID  and material.ID=fixed.Model_ID  and fixed.FixedEquipment_ID=fixedequipment.ID  and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count=Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand2 = "select treatment.Treatmentname as treatmentname,material.Name as materialName,material.ID as materialID,FixedRequirements_ID as RequirementsID,fixedrequirements.Requirements as fixedrequire,fixedequipment.ID as fixedequipid,fixedequipment.Name as fixedequipname,BodyPosition,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username from treatment,fixed,fixedequipment,fixedrequirements,material,user,appointment,equipment where treatment.Patient_ID=@patient and treatment.Fixed_ID=fixed.ID and fixed.Appointment_ID=appointment.ID  and material.ID=fixed.Model_ID  and fixed.FixedEquipment_ID=fixedequipment.ID  and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string date = reader["Date"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            string date2 = reader["ApplicationTime"].ToString();
            DateTime dt2 = Convert.ToDateTime(date2);
            string date3 = dt2.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"materialName\":\"" + reader["materialName"].ToString() + "\",\"treatmentname\":\"" + reader["treatmentname"] + "\",\"materialID\":\"" + reader["materialID"] + "\",\"require\":\"" + reader["RequirementsID"] + "\",\"fixedrequire\":\"" + reader["fixedrequire"] +
                 "\",\"fixedequipname\":\"" + reader["fixedequipname"].ToString() + "\",\"fixedequipid\":\"" + reader["fixedequipid"].ToString() + "\",\"BodyPosition\":\"" + reader["BodyPosition"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() +
                 "\",\"Date\":\"" + date1 + "\",\"ApplicationTime\":\"" + date3 + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
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