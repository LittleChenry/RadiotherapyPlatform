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

        DataLayer sqlOperation2 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"patient\":[");
        string sqlCommand2 = "select treatment.State as treatstate,treatment.Treatmentdescribe,Treatmentname,Progress,iscommon,patient.*,user.Name as doctor,diagnosisrecord.Part_ID as partID,diagnosisrecord.LightPart_ID as LightPart_ID,diagnosisrecord.DiagnosisResult_ID as diag from treatment,patient,user,diagnosisrecord where treatment.DiagnosisRecord_ID=diagnosisrecord.ID  and treatment.Belongingdoctor=user.ID and treatment.Patient_ID=patient.ID and treatment.ID=@id";
        sqlOperation2.AddParameterWithValue("@id", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
        while (reader.Read())
        {
            string sqlCommand3 = "select Chinese from icdcode where ID=@icdID";
            sqlOperation.AddParameterWithValue("@icdID", Convert.ToInt32(reader["diag"].ToString()));
            string result = sqlOperation.ExecuteScalar(sqlCommand3);
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] + "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString()  + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() + "\",\"RegisterDoctor\":\"" + reader["doctor"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"treatstate\":\"" + reader["treatstate"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() + "\",\"diagnosisresult\":\"" + result +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"Treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Hospital_ID\":\"" + reader["Hospital_ID"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"partID\":\"" + reader["partID"].ToString() + "\",\"LightPart_ID\":\"" + reader["LightPart_ID"].ToString() + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\"}");
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

        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        return backText.ToString();
     }

}