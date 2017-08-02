﻿<%@ WebHandler Language="C#" Class="GetPatientInfo" %>

using System;
using System.Web;
using System.Text;

public class GetPatientInfo : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientInformation();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string patientInformation()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT count(ID) from treatment";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
        string sqlCommand2 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,Progress,user.Name as doctor,treatment.Treatmentdescribe,Group_ID,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID order by patient.ID desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
      
        while (reader.Read())
        {

            string result = "";
            if (reader["DiagnosisRecord_ID"] is DBNull)
            {
                result = "";
            }
            else
            {
                string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                result = sqlOperation1.ExecuteScalar(sqlCommand3);
            }
            string groupname = "";
            if (reader["Group_ID"] is DBNull)
            {
                groupname = "";
            }
            else
            {
                string sqlCommand5 = "select groupName from groups,groups2user where groups2user.ID=@ID and groups2user.Group_ID=groups.ID";
                sqlOperation1.AddParameterWithValue("@ID", reader["Group_ID"].ToString());
                groupname = sqlOperation1.ExecuteScalar(sqlCommand5);               
            }
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"state\":\"" + reader["treatstate"].ToString() +
                 "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"groupname\":\"" + groupname
                 + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\"}");

            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
       // backText.Remove(backText.Length - 1, 1);
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        backText.Append("]}");
        return backText.ToString();
    }
}