<%@ WebHandler Language="C#" Class="GetInfoForEquipAndAppoint" %>

using System;
using System.Web;
using System.Text;

public class GetInfoForEquipAndAppoint : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInfo(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string getInfo(HttpContext context)
    {
        string equipid = context.Request["equipid"];
        string first = context.Request["firstday"];
        DateTime firstdate = Convert.ToDateTime(first);
        string last = firstdate.AddDays(6).ToString("yyyy-MM-dd");
        StringBuilder backString = new StringBuilder("{\"machineinfo\":");
        string equipinfocommand = "select Name,State,Timelength,BeginTimeAM from equipment where ID=@equipid";
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(equipinfocommand);
        if (reader.Read())
        {
            backString.Append("{\"equipname\":\"" + reader["Name"].ToString() + "\",\"equipstate\":\"" + reader["State"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\"}");


        }
        else
        {
            backString.Append("\"\"");
        }
        reader.Close();
        string countcommand="select count(*) from appointment_accelerate where Equipment_ID=@equipid and Date>=@date and Date<=@date1";
        sqlOperation.AddParameterWithValue("@date", first);
        sqlOperation.AddParameterWithValue("@date1", last);
        sqlOperation.AddParameterWithValue("@equipid", equipid);
        int count=int.Parse(sqlOperation.ExecuteScalar(countcommand));
        int maxbegin = 0;
        backString.Append(",\"appointinfo\":[");
       
        int i=0;
        string appointinfocommand = "select ID,Task,Patient_ID,Date,Begin,End from appointment_accelerate where Equipment_ID=@equipid and Date>=@date and Date<=@date1 order by Begin,Date asc";
        reader = sqlOperation.ExecuteReader(appointinfocommand);
        while (reader.Read())
        {
            
            string pnamecommand="select Name from patient where ID=@pid";
            sqlOperation2.AddParameterWithValue("@pid",reader["Patient_ID"].ToString());
            string pname=sqlOperation2.ExecuteScalar(pnamecommand);
      
            string begin = reader["Begin"].ToString();
            if (int.Parse(begin) > maxbegin)
            {
                maxbegin = int.Parse(begin);
            }
            string checkcommand = "select count(*) from treatmentrecord where Appointment_ID=@appointid and Treat_User_ID is null";
            sqlOperation2.AddParameterWithValue("@appointid", reader["ID"].ToString());
            int count1 = int.Parse(sqlOperation2.ExecuteScalar(checkcommand));
            string completed = "";
            if (count1 > 0)
            {
                completed = "false";
            }
            else
            {
                completed = "true";
            }
            backString.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + begin + "\",\"End\":\"" + reader["End"].ToString() + "\"");
            backString.Append(",\"Completed\":\"" + completed + "\",\"patientname\":\"" + pname + "\"}");
            if (i < count - 1)
            {
                backString.Append(",");
            }
            i++;
        }
        backString.Append("],\"maxbegin\":\"" + maxbegin + "\"}");
        return backString.ToString();
      
    }

}