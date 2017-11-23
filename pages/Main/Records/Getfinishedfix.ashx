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
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        string sqlcommand2 = "select count(*) from treatment,fixed,fixedequipment,fixedrequirements,material,user where treatment.Patient_ID=@patient and treatment.Fixed_ID=fixed.ID  and material.ID=fixed.Model_ID  and fixed.FixedEquipment_ID=fixedequipment.ID  and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.Application_User_ID=user.ID";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count=Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand2 = "select treatment.Treatmentname as treatmentname,RemarksApply,Treatmentdescribe,material.Name as materialName,Appointment_ID,material.ID as materialID,FixedRequirements_ID as RequirementsID,fixedrequirements.Requirements as fixedrequire,fixedequipment.ID as fixedequipid,fixedequipment.Name as fixedequipname,bodyposition.Name as Body,bodyposition.ID as bodyid,ApplicationTime,user.Name as username,fixed.Application_User_ID as useri from treatment,fixed,fixedequipment,fixedrequirements,material,user,bodyposition where treatment.Patient_ID=@patient and treatment.Fixed_ID=fixed.ID and material.ID=fixed.Model_ID  and fixed.FixedEquipment_ID=fixedequipment.ID  and fixed.FixedRequirements_ID=fixedrequirements.ID and fixed.Application_User_ID=user.ID and fixed.BodyPosition=bodyposition.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string date1 = "";
            string begin = "";
            string end = "";
            string equipname = "";
            if (reader["Appointment_ID"].ToString()!= "")
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
            backText.Append("{\"materialName\":\"" + reader["materialName"].ToString() + "\",\"treatmentname\":\"" + reader["treatmentname"] + "\",\"materialID\":\"" + reader["materialID"] + "\",\"require\":\"" + reader["RequirementsID"] + "\",\"fixedrequire\":\"" + reader["fixedrequire"] +
                 "\",\"fixedequipname\":\"" + reader["fixedequipname"].ToString() + "\",\"fixedequipid\":\"" + reader["fixedequipid"].ToString() + "\",\"BodyPosition\":\"" + reader["Body"].ToString() + "\",\"equipname\":\"" + equipname +
                 "\",\"Begin\":\"" + begin + "\",\"End\":\"" + end + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"] + "\",\"Remarks\":\"" + reader["RemarksApply"] +
                 "\",\"Date\":\"" + date1 + "\",\"ApplicationTime\":\"" + date3 + "\",\"username\":\"" + reader["username"].ToString() + "\",\"bodyid\":\"" + reader["bodyid"].ToString() + "\",\"userID\":\"" + reader["useri"].ToString() + "\",\"appointid\":\"" + reader["Appointment_ID"].ToString() + "\"}");
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