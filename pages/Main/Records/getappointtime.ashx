<%@ WebHandler Language="C#" Class="getappointtime" %>

using System;
using System.Web;
using System.Text;

public class getappointtime : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getappoint(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string getappoint(HttpContext context)
    {
        string appoint = context.Request["appoint"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string command = "select Date,Begin,End from appointment_accelerate where ID=@id";
        sqlOperation.AddParameterWithValue("@id", appoint);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(command);
        StringBuilder backText = new StringBuilder("{\"time\":[");
        if (reader.Read())
        {
            backText.Append("{\"Date\":\"" + reader["Date"].ToString() + "\",\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() + "\"}");
            
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }

}