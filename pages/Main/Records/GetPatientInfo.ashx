<%@ WebHandler Language="C#" Class="GetPatientInfo" %>

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
        string sqlCommand = "SELECT count(*) from patient";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
        string sqlCommand2 = "select treatment.ID as treatid,patient.*,State,Progress,user.Name as doctor,treatment.Treatmentname from treatment,patient,user where patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID order by patient.ID desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
      
        while (reader.Read())
        {
                   
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treatID\":\"" + reader["Treatmentname"].ToString()
                 + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treat\":\"" + reader["treatid"].ToString() + "\"}");
    
            if (i < count)
            {
                backText.Append(","); 
            }
            i++;
        }
       // backText.Remove(backText.Length - 1, 1);
        backText.Append("]}");
        return backText.ToString();
    }
}