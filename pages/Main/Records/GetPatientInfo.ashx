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
        string sqlCommand2 = "select treatment.ID as treatid,patient.*,State,Progress,DiagnosisResult_ID,user.Name as doctor,treatment.Treatmentname from treatment,patient,diagnosisrecord,user where patient.ID=treatment.Patient_ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and patient.RegisterDoctor=user.ID order by patient.ID desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
      
        while (reader.Read())
        {
            string tumorname=null;
            if (reader["DiagnosisResult_ID"] is DBNull)
            { 
                tumorname = "无";
            }
            else
            {
                DataLayer sqlOperation3 = new DataLayer("sqlStr");
                string sqlCommand3 = "SELECT TumorName from diagnosisresult where diagnosisresult.ID=@diagnosisresult";
                sqlOperation3.AddParameterWithValue("@diagnosisresult", Convert.ToInt32(reader["DiagnosisResult_ID"].ToString()));
                tumorname = sqlOperation3.ExecuteScalar(sqlCommand3);
            }
            
            
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString() + "\",\"Picture\":\"" + reader["Picture"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"Birthday\":\"" + reader["Birthday"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"Height\":\"" + reader["Height"].ToString() + "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treatID\":\"" + reader["Treatmentname"].ToString() + "\",\"State\":\"" + reader["State"].ToString()
                 + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"TumorName\":\"" + tumorname + "\",\"doctor\":\"" + reader["doctor"].ToString()  + "\"}");
    
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