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
        string sqlCommand2 = "select treatment.ID as treatid,Progress,patient.* from treatment,patient where treatment.Patient_ID=patient.ID and treatment.ID=@id";
        sqlOperation2.AddParameterWithValue("@id", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"IdentificationNumber\":\"" + reader["IdentificationNumber"] +
                 "\",\"Hospital\":\"" + reader["Hospital"].ToString() + "\",\"RecordNumber\":\"" + reader["RecordNumber"].ToString()  + "\",\"Name\":\"" + reader["Name"].ToString() +
                 "\",\"Gender\":\"" + reader["Gender"].ToString() + "\",\"Age\":\"" + reader["Age"].ToString() +
                 "\",\"Nation\":\"" + reader["Nation"].ToString() + "\",\"Address\":\"" + reader["Address"].ToString() + "\",\"Contact1\":\"" + reader["Contact1"].ToString() +
                 "\",\"Contact2\":\"" + reader["Contact2"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\"}");
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