<%@ WebHandler Language="C#" Class="getappointgroupdesign" %>

using System;
using System.Web;
using System.Text;

public class getappointgroupdesign : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getalldesign(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private string getalldesign(HttpContext context)
    {
        string appointid = context.Request["appointid"];
        string childdesgincommand = "select treatmentrecord.ChildDesign_ID as chid from treatmentrecord where Appointment_ID=@app and Treat_User_ID is null";
        sqlOperation.AddParameterWithValue("@app", appointid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(childdesgincommand);
        StringBuilder info = new StringBuilder("[");
        int count = 0;
        while (reader.Read())
        {
            if (count == 0)
            {
                info.Append(reader["chid"].ToString());
            }
            else
            {
                info.Append("," + reader["chid"].ToString());
            }
            count++;
        }
        info.Append("]");
        return info.ToString();
    }

}