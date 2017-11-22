<%@ WebHandler Language="C#" Class="getallfirstappoint" %>

using System;
using System.Web;
using System.Text;
public class getallfirstappoint : IHttpHandler {

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
        int count = 0;
        int appointid=0;
        string date="";
        string begin="";
        string sqlcommand2 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date>@nowdate) or((Date=@nowdate)and Begin>@nowbegin)) order by Date desc,Begin desc";
        sqlOperation.AddParameterWithValue("@nowdate", DateTime.Now.Date.ToString());
        sqlOperation.AddParameterWithValue("@treat", treat);
        sqlOperation.AddParameterWithValue("@nowbegin", DateTime.Now.Hour * 60 + DateTime.Now.Minute);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand2);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() == "")
            {
                appointid = int.Parse(reader["Appointment_ID"].ToString()); 
               
            }
            count++;
        }
        reader.Close();


        string sqlcommand = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and ((Date<@nowdate) or((Date=@nowdate)and Begin<@nowbegin)) order by Date desc,Begin desc";
        reader = sqlOperation.ExecuteReader(sqlcommand);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() != "")
            {
                appointid = int.Parse(reader["Appointment_ID"].ToString());
                date = reader["Date"].ToString();
                begin = reader["Begin"].ToString();
                break;
            }
        }
        reader.Close();

        if (appointid != 0)
        {
            string sqlcommand1 = "select Treat_User_ID,Appointment_ID,Date,Begin,End from treatmentrecord,appointment_accelerate where treatmentrecord.Treatment_ID=@treat and treatmentrecord.Appointment_ID=appointment_accelerate.ID and (Date<@date or (Date=@date and Begin<=@begin)) order by Date,Begin asc";
            sqlOperation.AddParameterWithValue("@date", date);
            sqlOperation.AddParameterWithValue("@begin", begin);
            MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(sqlcommand1);
            while (reader1.Read())
            {
                if (reader1["Treat_User_ID"].ToString() != "")
                {
                    count++;
                }

            }
            reader1.Close();
        }

        return count+"";
    }


}