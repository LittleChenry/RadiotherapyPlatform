<%@ WebHandler Language="C#" Class="patientInfoForDoctor" %>

using System;
using System.Web;
using System.Text;
public class patientInfoForDoctor : IHttpHandler {

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
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
        String userid = context.Request.QueryString["userID"];
        
        int userID = Convert.ToInt32(userid);
        string sqlCommand1 = "SELECT Group_ID from groups2user where User_ID=@userid";
        sqlOperation.AddParameterWithValue("@userid", userID);
        
        
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlCommand1);
        int j = 0;
        int[] group=new int[20]; 
        while (reader1.Read())
        {
            group[j] = int.Parse(reader1["Group_ID"].ToString());
            j++;
        }
        int Count=0;
        int count = 0;
        reader1.Close();
        for (int k = 0; k < j; k++)
        {
            string sqlCommand = "SELECT count(*) from treatment where Group_ID=@groupid";
            sqlOperation.AddParameterWithValue("@groupid", group[k]);
            count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
            Count = Count + count;
        }
        if (Count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        
        int i = 1;
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");
        for (int k = 0; k < j; k++)
        {
            string sqlCommand2 = "select treatment.ID as treatid,patient.*,State,Progress,user.Name as doctor,treatment.Treatmentname,groupName,DiagnosisRecord_ID from groups,treatment,patient,user where patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID and groups.ID=treatment.Group_ID and treatment.Group_ID=@groupid order by patient.ID desc";
            sqlOperation2.AddParameterWithValue("@groupid", group[k]);
            MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);

            while (reader.Read())
            {
                string result="";
                if (reader["DiagnosisRecord_ID"] is DBNull)
                {
                    result = "";
                }
                else
                {
                    string sqlCommand3 = "select TumorName from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
                    sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                    string TumorName = sqlOperation1.ExecuteScalar(sqlCommand3);
                    string sqlCommand4 = "select Description from diagnosisrecord,diagnosisresult where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =diagnosisresult.ID";
                    sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                    string Description = sqlOperation1.ExecuteScalar(sqlCommand4);
                    result = TumorName + Description;
                }
                backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result +
                     "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentname"].ToString() + "\",\"groupname\":\"" + reader["groupName"].ToString()
                     + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\"}");

                if (i < Count)
                {
                    backText.Append(",");
                }
                i++;
            }
            reader.Close();
        }
        // backText.Remove(backText.Length - 1, 1);                
        backText.Append("]}");
        return backText.ToString();
    }
}