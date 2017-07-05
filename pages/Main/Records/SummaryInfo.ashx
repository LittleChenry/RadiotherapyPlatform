<%@ WebHandler Language="C#" Class="SummaryInfo" %>

using System;
using System.Web;
using System.Text;
public class SummaryInfo : IHttpHandler
{

    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getpatientFixinfo(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
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
    private string getpatientFixinfo(HttpContext context)
    {

        int treatID = Convert.ToInt32(context.Request.QueryString["treatID"]);
        int i = 1;
        string countCompute = "select count(summary.ID) from treatment,patient,summary where patient.ID=treatment.Patient_ID and summary.Patient_ID =patient.ID and treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatID);
        int count = int.Parse(sqlOperation.ExecuteScalar(countCompute));

        string sqlCommand = "select summary.*,user.Name as username from user,treatment,patient,summary where user.ID=Operator_User_ID and patient.ID=treatment.Patient_ID and summary.Patient_ID =patient.ID and treatment.ID=@treatID order by OperateTime desc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"summaryInfo\":[");
        //reader.Read();
        //backText.Append(count);
        while (reader.Read())
        {
            string date = reader["OperateTime"].ToString();
            DateTime dt1 = Convert.ToDateTime(date);
            string date1 = dt1.ToString("yyyy-MM-dd");
            backText.Append("{\"Content\":\"" + reader["Content"].ToString() +
                 "\",\"username\":\"" + reader["username"].ToString() + "\",\"OperateTime\":\"" + date1 + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        return backText.ToString();

    }
}