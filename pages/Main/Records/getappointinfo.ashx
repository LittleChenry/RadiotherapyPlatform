<%@ WebHandler Language="C#" Class="getappointinfo" %>

using System;
using System.Web;
using System.Text;

public class getappointinfo : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getprinItem(HttpContext context)
    {
        string treatid = context.Request["treatID"];
        int treat = Convert.ToInt32(treatid);
        string selectallappoint = "select count(*) from appointment where Treatment_ID=@treatid and Task not like '加速器'";
        sqlOperation.AddParameterWithValue("@treatid", treat);
        int count=int.Parse(sqlOperation.ExecuteScalar(selectallappoint));
        string selectall = "select appointment.ID as appointid,ischecked,equipment.Name as equipname,Begin,End,Date,Completed,Task from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treatid and Task not like '加速器' order by Date,Begin";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectall);
        StringBuilder backText = new StringBuilder("{\"appoint\":[");
        int i=0;
        while (reader.Read())
        {
            string task = "";
            if (reader["ischecked"].ToString() == "1")
            {
                task = "CT复查";
            }
            else
            {
                task = reader["Task"].ToString();
            }
            backText.Append("{\"Task\":\"" + task + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"appointid\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"}");
            if (i < count-1)
            {
                backText.Append(",");
            }
            i++;
        }
        reader.Close();
        string selectallappoint2 = "select count(*) from appointment_accelerate where Treatment_ID=@treatid";
        int count1 = int.Parse(sqlOperation.ExecuteScalar(selectallappoint2));
        if (count1 > 0 && count>0)
        {
            backText.Append(",");
        }
        string selectall1 = "select appointment_accelerate.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed,Task from equipment,appointment_accelerate where appointment_accelerate.Equipment_ID=equipment.ID and Treatment_ID=@treatid order by Date,Begin";
        reader = sqlOperation.ExecuteReader(selectall1);
         i = 0;
        while (reader.Read())
        {
            backText.Append("{\"Task\":\"" + reader["Task"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"appointid\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"}");
            if (i < count1 - 1)
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