<%@ WebHandler Language="C#" Class="getLocation" %>

using System;
using System.Web;
using System.Text;
public class getLocation : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = patientimportCTInformation(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;          
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientimportCTInformation(HttpContext context)
    {
        int treatid =Convert.ToInt32(context.Request["treatmentID"]);        
        
        string sqlCommand3 = "select location.* from location,treatment where treatment.Location_ID=location.ID and treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand3);
        StringBuilder backText = new StringBuilder("{\"info\":[");
        while (reader.Read())
        {
            backText.Append("{\"Thickness\":\"" + reader["Thickness"].ToString() + "\",\"Number\":\"" + reader["Number"] + "\",\"ReferenceNumber\":\"" + reader["ReferenceNumber"] + "\"}");           
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}