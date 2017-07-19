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
        string sqlcommand = "select Treat_User_ID,Appointment_ID from treatmentrecord where Treatment_ID=@treat order by Appointment_ID desc";
        sqlOperation.AddParameterWithValue("treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlcommand);
        while (reader.Read())
        {
            if (reader["Treat_User_ID"].ToString() == "")
            {
                count++;
            }
            else
            {
                appointid = int.Parse(reader["Appointment_ID"].ToString());
                break;
            }  
        }
        reader.Close();
        if (appointid != 0)
        {
            string sqlcommand1 = "select Treat_User_ID from treatmentrecord where Treatment_ID=@treat and Appointment_ID<=@appoint order by Appointment_ID asc";
            sqlOperation.AddParameterWithValue("@appoint", appointid);
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