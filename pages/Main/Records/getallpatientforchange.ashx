<%@ WebHandler Language="C#" Class="getallpatientforchange" %>

using System;
using System.Web;
using System.Text;


public class getallpatientforchange : IHttpHandler {
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
        string equipid = context.Request["equipment"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string selectequip = "select * from equipment where ID=@equip ";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectequip);
          StringBuilder backText = new StringBuilder("{\"equipmentinfo\":");
          string item = "";
        int i = 0;
        if (reader.Read())
        {
            string typeselect = "select Type from equipmenttype where ID=@id";
            sqlOperation1.AddParameterWithValue("@id", reader["EquipmentType"].ToString());
            string type=sqlOperation1.ExecuteScalar(typeselect);
            item = reader["TreatmentItem"].ToString();
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\",\"EndTimeAM\":\"" + reader["EndTimeAM"].ToString() + "\",\"BegTimePM\":\"" + reader["BegTimePM"].ToString() +
              "\",\"EndTimePM\":\"" + reader["EndTimeTPM"].ToString() + "\",\"type\":\"" + type + "\",\"State\":\"" + reader["State"].ToString() + "\",\"TreatmentItem\":\"" + item + "\"}");
        }
        else
        {
            backText.Append("\"\"");
        }
        reader.Close();
        backText.Append("}");
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        return backText.ToString();

    }

}