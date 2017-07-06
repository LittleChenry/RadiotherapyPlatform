<%@ WebHandler Language="C#" Class="TreatmentRecordInfo" %>

using System;
using System.Web;
using System.Text;
public class TreatmentRecordInfo : IHttpHandler {
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        int treatid = Convert.ToInt32(context.Request["treatmentID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select design.* from treatment,design where treatment.ID=@treat and treatment.Design_ID=design.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"IlluminatedNumber\":\"" + reader["IlluminatedNumber"].ToString() + "\",\"MachineNumbe\":\"" + reader["MachineNumbe"] + "\"}");
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }

}