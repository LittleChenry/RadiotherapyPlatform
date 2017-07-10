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


        string sqlCommand = "select diagnosisrecord.*,part.Name as partname,user.Name as username,treatment.Group_ID as group from user,part,diagnosisrecord,treatment where diagnosisrecord.Diagnosis_User_ID=user.ID and treatment.DiagnosisRecord_ID=diagnosisrecord.ID and diagnosisrecord.Part_ID=part.ID and treatment.ID=@treatID";
        sqlOperation2.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"diagnosisInfo\":[");
        while (reader.Read())
        {
            string date = reader["Time"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd HH:mm");
            backText.Append("{\"Remarks\":\"" + reader["Remarks"].ToString() + "\",\"partname\":\"" + reader["partname"] + "\",\"partID\":\"" + reader["Part_ID"] +
                 "\",\"diagnosisresultID\":\"" + reader["DiagnosisResult_ID"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\",\"group\":\"" + reader["group"].ToString() + "\",\"userID\":\"" + reader["Diagnosis_User_ID"].ToString() +
                 "\",\"Time\":\"" + date1 + "\"}");

        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}