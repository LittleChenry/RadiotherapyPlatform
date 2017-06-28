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
        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
        string sqlCommand2 = "select treatment.ID as treatid,patient.*,State,Progress,TumorName,user.Name as doctor from treatment,patient,diagnosisrecord,diagnosisresult,user where patient.ID=treatment.Patient_ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and diagnosisrecord.DiagnosisResult_ID=diagnosisresult.ID and diagnosisrecord.Diagnosis_User_ID=user.ID ";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString() + "\",\"Picture\":\"" + reader["Picture"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"Birthday\":\"" + reader["Birthday"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"Height\":\"" + reader["Height"].ToString() + "\",\"Weight\":\"" + reader["Weight"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"State\":\"" + reader["State"].ToString()
                 + "\",\"Progress\":\"" + reader["Progress"] + "\",\"TumorName\":\"" + reader["TumorName"] + "\",\"doctor\":\"" + reader["doctor"] + "\"}");
            if (i < count)
            {
                backText.Append(","); 
            }
            i++;
        }
        backText.Remove(backText.Length - 1, 1);
        backText.Append("]}");
        return backText.ToString();
    }
}