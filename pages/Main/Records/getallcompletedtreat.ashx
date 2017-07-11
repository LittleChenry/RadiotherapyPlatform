<%@ WebHandler Language="C#" Class="getallcompletedtreat" %>

using System;
using System.Web;
using System.Text;

public class getallcompletedtreat : IHttpHandler {
    
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
        int radiotherapyid = Convert.ToInt32(context.Request.QueryString["Radiotherapy_ID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "select ID from patient where Radiotherapy_ID=@radio";
        sqlOperation.AddParameterWithValue("@radio", radiotherapyid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        string sqlcommand2 = "select count(*) from treatment where Patient_ID=@patient";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));

        StringBuilder backText = new StringBuilder("{\"treatinfo\":[");
        int i = 1;
        string sqlCommand2 = "select * from treatment where Patient_ID=@patient";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            backText.Append("{\"diagnose\":\"" + reader["DiagnosisRecord_ID"].ToString() + "\",\"patient\":\"" + patientid + "\",\"fixed\":\"" + reader["Fixed_ID"].ToString() + "\",\"location\":\"" + reader["Location_ID"].ToString() + "\",\"design\":\"" + reader["Design_ID"].ToString() + "\",\"replace\":\"" + reader["Replacement_ID"].ToString() + "\",\"review\":\"" + reader["Review_ID"].ToString() + "\"}");
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
        return backText.ToString();
    }

}