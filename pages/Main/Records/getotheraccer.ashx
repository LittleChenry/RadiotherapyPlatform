<%@ WebHandler Language="C#" Class="getotheraccer" %>

using System;
using System.Web;
using System.Text;
public class getotheraccer : IHttpHandler {

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
        string sqlcommand = "select Treat_User_ID from treatmentrecord where Treatment_ID=@treat order by Appointment_ID desc";
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
                break;
            }
        }
        return count + "";
    }



}