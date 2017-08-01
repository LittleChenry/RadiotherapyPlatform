﻿<%@ WebHandler Language="C#" Class="getallpatientforchange" %>

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
        int i = 0;
        if (reader.Read())
        {
            string typeselect = "select Type from equipmenttype where ID=@id";
            sqlOperation1.AddParameterWithValue("@id", reader["EquipmentType"].ToString());
            string type=sqlOperation1.ExecuteScalar(typeselect);
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\",\"Timelength\":\"" + reader["Timelength"].ToString() + "\",\"BeginTimeAM\":\"" + reader["BeginTimeAM"].ToString() + "\",\"EndTimeAM\":\"" + reader["EndTimeAM"].ToString() + "\",\"BegTimePM\":\"" + reader["BegTimePM"].ToString() +
              "\",\"EndTimePM\":\"" + reader["EndTimeTPM"].ToString() + "\",\"type\":\"" + type + "\",\"State\":\"" + reader["State"].ToString() + "\",\"TreatmentItem\":\"" + reader["TreatmentItem"].ToString() + "\"}");
        }
        else
        {
            backText.Append("\"\"");
        }
        reader.Close();
        backText.Append(",");
        backText.Append("\"patientinfo\":[");
        string date1= DateTime.Now.ToString("yyyy-MM-dd");
        int h = DateTime.Now.Hour;
        int s = DateTime.Now.Minute;
        int time = h * 60 + s;
        string sqlCommand = "select count(distinct(Treatment_ID)) from appointment where Equipment_ID=@equip and  (Date>@date1 or (Date=@date1 and Begin>@begintime))  and State=1 and Completed is  NULL ";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        sqlOperation.AddParameterWithValue("@begintime", time);
        sqlOperation.AddParameterWithValue("@date1", date1);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlCommand));
        string allpatient = "select distinct(Treatment_ID),Patient_ID from appointment where Equipment_ID=@equip and  (Date>@date1 or (Date=@date1 and Begin>@begintime))  and State=1 and Completed is  NULL ";
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(allpatient);
        while (reader1.Read())
        {
            string treatinfo = "select Treatmentdescribe from treatment where ID=@treat";
            sqlOperation1.AddParameterWithValue("@treat", Convert.ToInt32(reader1["Treatment_ID"].ToString()));
            string treatmentscribe = sqlOperation1.ExecuteScalar(treatinfo);
            string diag = "select DiagnosisRecord_ID from treatment where ID=@treat";

            string diagid = sqlOperation1.ExecuteScalar(diag);
            string result = "select DiagnosisResult_ID from diagnosisrecord where ID=@diagid";
            sqlOperation1.AddParameterWithValue("@diagid", Convert.ToInt32(diagid));
            string resultid = sqlOperation1.ExecuteScalar(result);
            string sqlCommand3 = "select Chinese from icdcode where ID=@icdID";
            sqlOperation1.AddParameterWithValue("@icdID", Convert.ToInt32(resultid));
            string result1 = sqlOperation1.ExecuteScalar(sqlCommand3);
            string patientname = "select Name from patient where ID=@patient";
            sqlOperation1.AddParameterWithValue("@patient", Convert.ToInt32(reader1["Patient_ID"].ToString()));
            string pname = sqlOperation1.ExecuteScalar(patientname);
            string radio = "select Radiotherapy_ID from patient where ID=@patient";

            string radioid = sqlOperation1.ExecuteScalar(radio);
            backText.Append("{\"treatmentscribe\":\"" + treatmentscribe + "\",\"pname\":\"" + pname + "\",\"Treatment_ID\":\"" + reader1["Treatment_ID"].ToString() + "\",\"Radiotherapy_ID\":\"" + radioid + "\",\"DiagnosisResult\":\"" + result1 + "\"}");
            if (i < count - 1)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        reader1.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        return backText.ToString();

    }

}