<%@ WebHandler Language="C#" Class="patientInfoForFix" %>

using System;
using System.Web;
using System.Text;

public class patientInfoForFix : IHttpHandler {
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
    private string patientfixInformation(HttpContext context)
    {
        string treatid=context.Request["treatmentID"];      
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT count(*) from patient,treatment where treatment.Patient_ID=patient.ID and treatment.ID=@id";
        sqlOperation.AddParameterWithValue("@id", treatid);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"patient\":false}";
        }
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;

        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"patient\":[");
        string sqlCommand2 = "select treatment.Treatmentname,Progress,patient.*,user.Name as doctor,part.name as partname,diagnosisresult.*,diagnosisrecord.Part_ID as partID from diagnosisresult,treatment,patient,user,part,diagnosisrecord where diagnosisrecord.DiagnosisResult_ID=diagnosisresult.ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and diagnosisrecord.Part_ID=part.ID and patient.RegisterDoctor=user.ID and treatment.Patient_ID=patient.ID and treatment.ID=@id";
        sqlOperation2.AddParameterWithValue("@id", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] + "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString()  + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"RegisterDoctor\":\"" + reader["doctor"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() + "\",\"diagnosisresult\":\"" + reader["TumorName"].ToString() +reader["Description"].ToString()+
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"partID\":\"" + reader["partID"].ToString() + "\",\"partname\":\"" + reader["partname"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
      
        backText.Append("]}");
        reader.Close();
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        return backText.ToString();
     }

}