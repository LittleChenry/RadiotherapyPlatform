<%@ WebHandler Language="C#" Class="patientInfoForJLS" %>

using System;
using System.Web;
using System.Text;
public class patientInfoForJLS : IHttpHandler {
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
        String equipmentid = context.Request.QueryString["equipmentid"];
        int equipmentID = Convert.ToInt32(equipmentid);
        DateTime date = DateTime.Now;
        string date1 = date.ToString("yyyy-MM-dd");
        string sqlCommand = "SELECT count(*) from appointment where Equipment_ID=@groupid and Date=@date and State=1";
        sqlOperation.AddParameterWithValue("@groupid", equipmentID);
        sqlOperation.AddParameterWithValue("@date", date1);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        
        int i = 1;
        string sqlCommand2 = "select treatment.ID as treatid,patient.*,user.Name as doctor,appointment.*,equipment.Name as eqname,treatment.Treatmentname,DiagnosisRecord_ID from appointment,treatment,patient,user,equipment where appointment.Equipment_ID=equipment.ID and appointment.Equipment_ID=@groupid and appointment.Date=@date and appointment.State=1 and appointment.Treatment_ID=treatment.ID and patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID order by patient.ID desc";
        sqlOperation2.AddParameterWithValue("@groupid", equipmentID);
        sqlOperation2.AddParameterWithValue("@date", date1);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");

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
            string da = reader["Date"].ToString();
            DateTime dt1 = Convert.ToDateTime(da);
            string date2 = dt1.ToString("yyyy-MM-dd");
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"date\":\"" + date2 + "\",\"begin\":\"" + reader["Begin"].ToString() + "\",\"end\":\"" + reader["End"].ToString() + 
                    "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentname"].ToString() 
                    + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\"}");

            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        reader.Close();       
        // backText.Remove(backText.Length - 1, 1);                
        backText.Append("]}");
        return backText.ToString();
    }
}