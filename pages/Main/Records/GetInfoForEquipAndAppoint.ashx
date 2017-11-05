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
        string time = DateTime.Now.ToShortDateString();
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
        string countcommand="select count(*) from appointment_accelerate where Equipment_ID=@equipid and Date>=@date";
        sqlOperation.AddParameterWithValue("@date", time);
        int count=int.Parse(sqlOperation.ExecuteScalar(countcommand));
        int maxbegin = 0;
        backString.Append(",\"appointinfo\":[");
       
        int i=0;
        string appointinfocommand = "select ID,Task,Patient_ID,Date,Begin,End,Completed,Treatment_ID,IsDouble from appointment_accelerate where Equipment_ID=@equipid and Date>=@date order by Date,Begin asc";
        reader = sqlOperation.ExecuteReader(appointinfocommand);
        while (reader.Read())
        {
            
            string pnamecommand="select Name from patient where ID=@pid";
            sqlOperation2.AddParameterWithValue("@pid",reader["Patient_ID"].ToString());
            string pname=sqlOperation2.ExecuteScalar(pnamecommand);
            string treatmentdescribe = "select Treatmentdescribe from treatment where ID=@treatid";
            sqlOperation2.AddParameterWithValue("@treatid", reader["Treatment_ID"].ToString());
            string treatdescribe = sqlOperation2.ExecuteScalar(treatmentdescribe);
      
            string begin = reader["Begin"].ToString();
            if (int.Parse(begin) > maxbegin)
            {
                maxbegin = int.Parse(begin);
            }
            backString.Append("{\"appointid\":\"" + reader["ID"].ToString() + "\",\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + begin + "\",\"End\":\"" + reader["End"].ToString() + "\"");
            backString.Append(",\"Completed\":\"" + reader["Completed"].ToString() + "\",\"patientname\":\"" + pname + "\",\"treatdescribe\":\"" + treatdescribe + "\",\"IsDouble\":\"" + reader["IsDouble"].ToString() + "\"}");
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