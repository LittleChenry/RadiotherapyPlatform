<%@ WebHandler Language="C#" Class="patientInfoForZLJS" %>

using System;
using System.Web;
using System.Text;
public class patientInfoForZLJS : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    private DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = gettreatrecord(context);
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
    private string gettreatrecord(HttpContext context)
    {
        String equipmentid = context.Request.QueryString["equipmentid"];
        int equipmentID = Convert.ToInt32(equipmentid);
        String date1 = context.Request.QueryString["date1"];
        String date2 = context.Request.QueryString["date2"];

        string sqlCommand = "SELECT count(*) from appointment where Equipment_ID=@Equipment and Date >= @date1 and Date <= @date2 and State=1";
        sqlOperation.AddParameterWithValue("@Equipment", equipmentID);
        sqlOperation.AddParameterWithValue("@date1", date1);
        sqlOperation.AddParameterWithValue("@date2", date2);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "{\"PatientInfo\":false}";
        }

        int i = 1;
        string sqlCommand2 = "select treatment.State as treatstate,Progress,iscommon,treatment.ID as treatid,patient.*,user.Name as doctor,appointment.ID as appointid,appointment.*,equipment.Name as eqname,treatment.Treatmentdescribe,DiagnosisRecord_ID from appointment,treatment,patient,user,equipment where appointment.Equipment_ID=equipment.ID and appointment.Equipment_ID=@groupid and appointment.Date >= @date1 and appointment.Date <= @date2 and appointment.State=1 and appointment.Treatment_ID=treatment.ID and patient.ID=treatment.Patient_ID and patient.RegisterDoctor=user.ID order by appointment.Date,appointment.Begin asc";
        sqlOperation2.AddParameterWithValue("@groupid", equipmentID);
        sqlOperation2.AddParameterWithValue("@date1", date1);
        sqlOperation2.AddParameterWithValue("@date2", date2);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand2);
        StringBuilder backText = new StringBuilder("{\"PatientInfo\":[");

        while (reader.Read())
        {
            int totalnumber = 0;
            int totaltimes = 0;
            int temp = 0;
            string sqlcommand = "select count(*) from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL";
            sqlOperation.AddParameterWithValue("@treat", Convert.ToInt32(reader["treatid"].ToString()));
            int counttemp = int.Parse(sqlOperation.ExecuteScalar(sqlcommand));
            if (counttemp == 0)
            {
               
                totalnumber = 0;
            }
            else
            {
                string sqlcommand4 = "select TreatedTimes,Rest,Singlenumber from treatmentrecord where Treatment_ID=@treat and Treat_User_ID is not NULL order by ID desc";
                sqlOperation1.AddParameterWithValue("@treat", Convert.ToInt32(reader["treatid"].ToString()));
                MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation1.ExecuteReader(sqlcommand4);
                while (reader1.Read())
                {
                    totalnumber = totalnumber + Convert.ToInt32(reader1["Singlenumber"].ToString());
                    temp++;
                }
                reader1.Close();
    
            }
            string sqlcommandtotaltimes = "select TotalNumber from treatment where ID=@treat";
            string total = sqlOperation.ExecuteScalar(sqlcommandtotaltimes);
            if (total != "")
            {
                totaltimes = int.Parse(total);
            }            
            string result = "";
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
            string da = reader["Date"].ToString();
            DateTime dt1 = Convert.ToDateTime(da);
            string date3 = dt1.ToString("yyyy-MM-dd");
            backText.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"diagnosisresult\":\"" + result + "\",\"date\":\"" + date3 + "\",\"begin\":\"" + reader["Begin"].ToString() + "\",\"end\":\"" + reader["End"].ToString() + "\",\"state\":\"" + reader["treatstate"].ToString() +
                    "\",\"Radiotherapy_ID\":\"" + reader["Radiotherapy_ID"].ToString() + "\",\"treat\":\"" + reader["Treatmentdescribe"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString()
                    + "\",\"doctor\":\"" + reader["doctor"].ToString() + "\",\"treatID\":\"" + reader["treatid"].ToString() + "\",\"finishedtimes\":\"" + counttemp + "\",\"totalnumber\":\"" + totalnumber + "\",\"totaltimes\":\"" + totaltimes + "\",\"appointid\":\"" + reader["appointid"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\",\"iscommon\":\"" + reader["iscommon"].ToString() + "\"}");

            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        reader.Close();               
        backText.Append("]}");
        return backText.ToString();
    }

}