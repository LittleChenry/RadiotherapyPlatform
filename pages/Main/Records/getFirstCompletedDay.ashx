<%@ WebHandler Language="C#" Class="getFirstCompletedDay" %>
using System;
using System.Web;
using System.Text;

public class getFirstCompletedDay : IHttpHandler {
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
        string chid = context.Request.QueryString["chid"];
        int treat = int.Parse(chid);
        string total = "";
        string sqlcommand = "select TreatTime as begindate from treatmentrecord,appointment_accelerate where treatmentrecord.Appointment_ID=appointment_accelerate.ID and treatmentrecord.ChildDesign_ID=@treat and treatmentrecord.Treat_User_ID is not null order by appointment_accelerate.Date,appointment_accelerate.Begin asc";
        sqlOperation.AddParameterWithValue("treat", treat);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        if (reader.Read())
        {
            total = reader["begindate"].ToString();

        }
        return total;
    }

}