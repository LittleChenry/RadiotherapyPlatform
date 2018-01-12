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
        String userid = context.Request.QueryString["userID"];
        string sqlCommand = "SELECT count(*) from treatment where (Progress like '%5%' and Progress not in(select Progress from treatment where Progress like '%6%'))or ((Progress like '%8%' or Progress like '%7%') and Progress not in (select Progress from treatment where Progress like '%9%'))";       
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }
        
        int i = 1;
        string sqlCommand2 = "select treatment.State as treatstate,treatment.ID as treatid,patient.*,user.Name as doctor,isback,Progress,iscommon,treatment.Treatmentdescribe,DiagnosisRecord_ID from treatment,patient,user where patient.ID=treatment.Patient_ID and treatment.Belongingdoctor=user.ID and ((Progress like '%5%' and Progress not in(select Progress from treatment where Progress like '%6%'))or ((Progress like '%8%' or Progress like '%7%') and Progress not in (select Progress from treatment where Progress like '%9%'))) order by patient.ID desc";   
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");

        while (reader.Read())
        {
            string progress = reader["Progress"].ToString();
            string[] strArray = progress.Split(',');
            string locationTime = "";
            string designApplyTime = "";
            string receiveTime = "";
            string advice = "";
            if (Array.LastIndexOf(strArray, "8") > 0)
            {
                string sqlCommand5 = "select Receive_User_ID from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                string receiveID = sqlOperation1.ExecuteScalar(sqlCommand5);
                if (receiveID != userid)
                {
                    count--;
                    continue;
                }
                string sqlCommand8 = "select ReceiveTime from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                receiveTime = sqlOperation1.ExecuteScalar(sqlCommand8);
            }
            if (Array.LastIndexOf(strArray, "5") > 0 && Array.LastIndexOf(strArray, "6") < 0)
            {
                string sqlCommand6 = "select OperateTime from location,treatment where location.ID=treatment.Location_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                locationTime = sqlOperation1.ExecuteScalar(sqlCommand6);

            }
            if (Array.LastIndexOf(strArray, "7") > 0 && Array.LastIndexOf(strArray, "8") < 0)
            {
                string sqlCommand7 = "select ApplicationTime from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                designApplyTime = sqlOperation1.ExecuteScalar(sqlCommand7);
                if (reader["isback"].ToString() == "1")
                {
                    string sqlCommand8 = "select Checkadvice from design,treatment where design.ID=treatment.Design_ID and treatment.ID =@treatID";
                    sqlOperation1.AddParameterWithValue("@treatID", reader["treatid"].ToString());
                    advice = sqlOperation1.ExecuteScalar(sqlCommand8);
                }
            }
            string result="";
            if (reader["DiagnosisRecord_ID"] is DBNull)
            {
                result = "";
            }
            else
            {
                string sqlCommand3 = "select Chinese from diagnosisrecord,icdcode where diagnosisrecord.ID=@ID and diagnosisrecord.DiagnosisResult_ID =icdcode.ID";
                sqlOperation1.AddParameterWithValue("@ID", reader["DiagnosisRecord_ID"].ToString());
                result = sqlOperation1.ExecuteScalar(sqlCommand3);
            }
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"state\":\"" + reader["treatstate"].ToString() +
                    "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"isback\":\"" + reader["isback"].ToString() + "\",\"advice\":\"" + advice
                    + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"locationTime\":\"" + locationTime + "\",\"receiveTime\":\"" + receiveTime + "\",\"designApplyTime\":\"" + designApplyTime + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\"}");

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