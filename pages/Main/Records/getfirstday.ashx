<%@ WebHandler Language="C#" Class="getfirstday" %>

using System;
using System.Web;
using System.Text;

public class getfirstday : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = gettotal(context);
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
    private string gettotal(HttpContext context)
    {
        string treatid = context.Request.QueryString["treatmentID"];
        int treat = int.Parse(treatid);
        string total = "";
        string sqlcommand = "select appointment_accelerate.Date as begindate from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.Treatment_ID=@treat order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        sqlOperation.AddParameterWithValue("treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        if (reader.Read())
        {
            total = reader["begindate"].ToString();

        }
        return total;
    }

}