<%@ WebHandler Language="C#" Class="getEquipmentInformation" %>

using System;
using System.Web;
using System.Text;

public class getEquipmentInformation : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = information(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string information(HttpContext context)
    {
        string sqlCommand = "SELECT * FROM Equipment WHERE ID=@id";
        string id = context.Request.QueryString["id"];
        sqlOperation.AddParameterWithValue("@id", id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder("[");
        if (reader.Read())
        {
            backString.Append("{\"Name\":\"" + reader["Name"].ToString() + "\",\"State\":\"" + reader["State"].ToString()
                + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString()
                + "\",\"EndTimeAM\":\"" + reader["EndTimeAM"].ToString() + "\",\"BegTimePM\":\"" + reader["BegTimePM"].ToString()
                + "\",\"EndTimePM\":\"" + reader["EndTimeTPM"].ToString() + "\",\"TreatmentItem\":\"" + reader["TreatmentItem"].ToString()
                + "\"}]");
        }
        return backString.ToString();
    }
}