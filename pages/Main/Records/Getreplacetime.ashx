<%@ WebHandler Language="C#" Class="Getreplacetime" %>

using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getFixtime.ashx
 * Writer: xubxiao
 * create Date: 2017-5-9
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取某个疗程的复位预约开始时间
 * **********************************************************/
public class Getreplacetime : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getfixtime(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixtime(HttpContext context)
    {
        String treatid = context.Request.QueryString["treatid"];
        string sqlCommand = "select Date,Begin,End,appointment.ID as appointid from appointment,treatment,replacement where treatment.ID=@treatid and appointment.ID=replacement.Appointment_ID  and treatment.Replacement_ID=replacement.ID";
        sqlOperation.AddParameterWithValue("@treatid", Convert.ToInt32(treatid));
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"fixtime\":[");
        if (reader.Read())
        {
            string sqlCommand2 = "select End from appointment,treatment,replacement where appointment.ID=@appointid";
            sqlOperation1.AddParameterWithValue("@appointid",Convert.ToInt32(reader["appointid"].ToString())+1);
            string end=sqlOperation1.ExecuteScalar(sqlCommand2);
            backText.Append("{\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + end + "\"}");
        }
        backText.Append("]}");
        return backText.ToString();
    }

}