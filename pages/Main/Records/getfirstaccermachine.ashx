<%@ WebHandler Language="C#" Class="getfirstaccermachine" %>

using System;
using System.Web;
using System.Text;

public class getfirstaccermachine : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getFixmachine(context);
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
    public string getFixmachine(HttpContext context)
    {
        string treatid = context.Request["treatmentid"];
        string firstcommd = "select equipment.Name as equipname,equipment.ID as equipid from equipment,appointment_accelerate,treatmentrecord  where treatmentrecord.Appointment_ID=appointment_accelerate.ID and appointment_accelerate.Equipment_ID=equipment.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(firstcommd);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
       if(reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["equipid"].ToString() + "\",\"Name\":\"" + reader["equipname"].ToString() + "\"}");
          
        }
        backText.Append("]}");
        return backText.ToString();
    }

}