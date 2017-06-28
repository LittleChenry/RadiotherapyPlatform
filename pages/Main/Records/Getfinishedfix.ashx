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
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select material.ID as materialName,FixedRequirements_ID as Requirements,fixedequipment.ID as fixedequipname,BodyPosition,equipment.Name as equipname,Begin,End,Date,ApplicationTime,user.Name as username from treatment,fixed,fixedequipment,fixedrequirements,material,user,appointment,equipment where treatment.ID=@treat and treatment.Fixed_ID=fixed.ID and fixed.Appointment_ID=appointment.ID  and material.ID=fixed.Model_ID  and fixed.FixedEquipment_ID=fixedequipment.ID  and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.Application_User_ID=user.ID and appointment.Equipment_ID=equipment.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"materialName\":\"" + reader["materialName"].ToString() + "\",\"require\":\"" + reader["Requirements"] +
                 "\",\"fixedequipname\":\"" + reader["fixedequipname"].ToString() + "\",\"BodyPosition\":\"" + reader["BodyPosition"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() +
                 "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() +
                 "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"ApplicationTime\":\"" + reader["ApplicationTime"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
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