<%@ WebHandler Language="C#" Class="getAllappointInfoFromDate" %>

using System;
using System.Web;
using System.Collections;
using System.Text;

public class getAllappointInfoFromDate : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getallapointinfo(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getallapointinfo(HttpContext context)
    {
        string begindate = context.Request["begindate"];
        string enddate = context.Request["enddate"];
        string equipmentid = context.Request["equipmentid"];
        StringBuilder backstring=new StringBuilder("{\"appointinfo\":[");
        string countcommand2 = "select count(*) from appointment_accelerate where Equipment_ID=@equipid and Date>=@date1 and Date<=@date2";
        sqlOperation.AddParameterWithValue("@date1", begindate);
        sqlOperation.AddParameterWithValue("@date2", enddate);
        sqlOperation.AddParameterWithValue("@equipid", equipmentid);
        int count2 = int.Parse(sqlOperation.ExecuteScalar(countcommand2));
        int i = 1;
        string appointinfocommand = "select ID,Task,Patient_ID,Date,Begin,End,Completed,IsDouble from appointment_accelerate where Equipment_ID=@equipid and Date>=@date1 and Date<=@date2 order by Date,Begin asc";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(appointinfocommand);
        while (reader.Read())
        {
            string pnamecommand = "select Name from patient where ID=@pid";
            sqlOperation1.AddParameterWithValue("@pid", reader["Patient_ID"].ToString());
            string pname = sqlOperation1.ExecuteScalar(pnamecommand);
            string begin = reader["Begin"].ToString();
            backstring.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString().Split(new char[]{' '})[0] + "\",\"Begin\":\"" + begin + "\",\"End\":\"" + reader["End"].ToString() + "\"");
            backstring.Append(",\"Completed\":\"" + reader["Completed"].ToString() + "\",\"patientname\":\"" + pname + "\",\"IsDouble\":\"" + reader["IsDouble"].ToString() + "\"}");
            if (i < count2)
            {
                backstring.Append(",");
            }
            i++;
        }
        backstring.Append("]}");
        return backstring.ToString();

    }
}