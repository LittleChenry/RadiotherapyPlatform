<%@ WebHandler Language="C#" Class="getallAppointInfo" %>

using System;
using System.Web;
using System.Text;

public class getallAppointInfo : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getprinItem(HttpContext context)
    {
        string treatid = context.Request["treatID"];
        int treat = Convert.ToInt32(treatid);
        string selectfix="select appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treat and appointment.Task='体位固定'";
        sqlOperation.AddParameterWithValue("@treat", treat);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectfix);
        StringBuilder backText = new StringBuilder("{\"fix\":");
        if (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"},");
        }
        else
        {
            backText.Append("\"\",");
        }
        reader.Close();
        string selectlocate = "select appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treat and appointment.Task='模拟定位'";
        reader = sqlOperation.ExecuteReader(selectlocate);
         backText.Append("\"locate\":");
        if (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"},");
        }
        else
        {
            backText.Append("\"\",");
        }
        reader.Close();
        string selectreplace = "select appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treat and appointment.Task='复位模拟'";
        reader = sqlOperation.ExecuteReader(selectreplace);
        backText.Append("\"replace\":");
        if (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"},");
        }
        else
        {
            backText.Append("\"\",");
        }
        reader.Close();
        string selectfirstaccelerate = "select appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treat and appointment.Task='加速器'";
        reader = sqlOperation.ExecuteReader(selectfirstaccelerate);
        backText.Append("\"firstaccelerate\":");
        if (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"},");
        }
        else
        {
            backText.Append("\"\",");
        }
        reader.Close();
        string selectotheraccelerate = "select appointment.ID as appointid,equipment.Name as equipname,Begin,End,Date,Completed from equipment,appointment where appointment.Equipment_ID=equipment.ID and Treatment_ID=@treat and appointment.Task='加速器'";
        reader = sqlOperation.ExecuteReader(selectotheraccelerate);
        if(reader.Read())
        { 
            backText.Append("\"otheraccelerate\":[");
               while(reader.Read())
                {
                    backText.Append("{\"ID\":\"" + reader["appointid"].ToString() + "\",\"equipname\":\"" + reader["equipname"].ToString() + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\",\"Completed\":\"" + reader["Completed"].ToString() + "\"},");
                }
            backText.Append("]}");
        }
        else
        {
            backText.Append("\"otheraccelerate\":");
            backText.Append("\"\"}");
        }
        backText.Remove(backText.Length - 3, 1);
        return backText.ToString();
    }

}