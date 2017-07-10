<%@ WebHandler Language="C#" Class="diagnoseInfo" %>

using System;
using System.Web;
using System.Text;
public class diagnoseInfo : IHttpHandler {

    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);

            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixrecordinfo(HttpContext context)
    {
        int treatid = Convert.ToInt32(context.Request.QueryString["treatID"]);
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation2.ExecuteScalar(sqlCommand));
        string countCompute = "select count(diagnosisrecord.ID) from treatment,diagnosisrecord where treatment.Patient_ID=@patient and treatment.DiagnosisRecord_ID is not null and diagnosisrecord.ID =treatment.DiagnosisRecord_ID";
        sqlOperation2.AddParameterWithValue("@patient", patientid);
        int count = int.Parse(sqlOperation2.ExecuteScalar(countCompute));
        int i = 1;
        string sqlCommand1 = "select diagnosisrecord.*,part.Name as partname,user.Name as username,Group_ID,Treatmentname from user,part,diagnosisrecord,treatment where diagnosisrecord.Diagnosis_User_ID=user.ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and diagnosisrecord.Part_ID=part.ID and treatment.Patient_ID=@patient";
        sqlOperation2.AddParameterWithValue("@patient", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"diagnosisInfo\":[");
        while (reader.Read())
        {
            string date = reader["Time"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"partname\":\"" + reader["partname"] + "\",\"partID\":\"" + reader["Part_ID"] + "\",\"Treatmentname\":\"" + reader["Treatmentname"] +
                 "\",\"diagnosisresultID\":\"" + reader["DiagnosisResult_ID"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\",\"group\":\"" + reader["Group_ID"].ToString() + "\",\"userID\":\"" + reader["Diagnosis_User_ID"].ToString() +
                 "\",\"Time\":\"" + date1 + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}