<%@ WebHandler Language="C#" Class="diagnoseInfo" %>

using System;
using System.Web;
using System.Text;
public class diagnoseInfo : IHttpHandler {

    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);

            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
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
        string iscommon = "select iscommon from treatment where ID=@treatID";
        int iscommonnumber = int.Parse(sqlOperation2.ExecuteScalar(iscommon));
        string countCompute = "select count(diagnosisrecord.ID) from treatment,diagnosisrecord where treatment.Patient_ID=@patient and treatment.DiagnosisRecord_ID is not null and diagnosisrecord.ID =treatment.DiagnosisRecord_ID";
        sqlOperation2.AddParameterWithValue("@patient", patientid);
        int count = int.Parse(sqlOperation2.ExecuteScalar(countCompute));
        int i = 1;
        string sqlCommand1 = "select diagnosisrecord.*,treataim.Aim as treatmentaim,user.Name as username,Treatmentname,Treatmentdescribe from user,diagnosisrecord,treatment,treataim where diagnosisrecord.TreatAim_ID=treataim.ID  and diagnosisrecord.Diagnosis_User_ID=user.ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and treatment.Patient_ID=@patient";
        sqlOperation2.AddParameterWithValue("@patient", patientid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"diagnosisInfo\":[");
        while (reader.Read())
        {
            string icdcode = "select Group1,Group2,Chinese from icdcode where ID=@icdcodeid";
            sqlOperation1.AddParameterWithValue("@icdcodeid", reader["DiagnosisResult_ID"].ToString());
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(icdcode);
            string result1 = "";
            string result2 = "";
            if (reader1.Read())
            {
                result1 = reader1["Group1"].ToString() + "," + reader1["Group2"].ToString() + "," + reader1["Chinese"].ToString();
            }
            reader1.Close();
            string icdcode1 = "select Groupfirst,Groupsecond from morphol where ID=@morpholid";
            sqlOperation1.AddParameterWithValue("@morpholid", reader["PathologyResult"].ToString());
             reader1= sqlOperation1.ExecuteReader(icdcode1);
             if (reader1.Read())
             {
                 result2 = reader1["Groupsecond"].ToString() + "," + reader1["Groupfirst"].ToString() ;
             }
             reader1.Close();
            string date = reader["Time"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"partname\":\"" + reader["Part_ID"] + "\",\"lightpartname\":\"" + reader["LightPart_ID"]+ "\",\"Treatmentname\":\"" + reader["Treatmentname"] + "\",\"diagnosisresultName1\":\"" + result1 + "\",\"diagnosisresultName2\":\"" + result2 +
                 "\",\"diagnosisresultID\":\"" + reader["DiagnosisResult_ID"].ToString() + "\",\"treatmentaim\":\"" + reader["treatmentaim"].ToString() + "\",\"treatmentaimID\":\"" + reader["TreatAim_ID"].ToString() + "\",\"PathologyResult\":\"" + reader["PathologyResult"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\",\"userID\":\"" + reader["Diagnosis_User_ID"].ToString() + "\",\"Treatmentdescribe\":\"" + reader["Treatmentdescribe"].ToString() +
                 "\",\"Time\":\"" + date1 + "\",\"iscommonnumber\":\"" + iscommonnumber + "\"}");
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