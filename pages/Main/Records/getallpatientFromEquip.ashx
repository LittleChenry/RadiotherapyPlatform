<%@ WebHandler Language="C#" Class="getallpatientFromEquip" %>

using System;
using System.Web;
using System.Text;

public class getallpatientFromEquip : IHttpHandler {
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
        string datebegin = context.Request["datebegin"];
        string dateend = context.Request["dateend"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select count(*) from appointment where Equipment_ID=@equip and Date<=@date2 and Date>=@date1 and State=1 and Completed is  NULL";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        sqlOperation.AddParameterWithValue("@date1", datebegin);
        sqlOperation.AddParameterWithValue("@date2", dateend);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlCommand));
        string allpatient = "select * from appointment where Equipment_ID=@equip and Date<=@date2 and Date>=@date1 and State=1 and Completed is  NULL";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(allpatient);
        int i=0;
        while (reader.Read())
        {
            string treatinfo = "select Treatmentdescribe from treatment where ID=@treat";
            sqlOperation1.AddParameterWithValue("@treat", Convert.ToInt32(reader["Treatment_ID"].ToString()));
            string treatmentscribe=sqlOperation1.ExecuteScalar(treatinfo);
            string patientname = "select Name from patient where ID=@patient";
            sqlOperation1.AddParameterWithValue("@patient",Convert.ToInt32(reader["Patient_ID"].ToString()));
            string pname=sqlOperation1.ExecuteScalar(patientname);
            backText.Append("{\"Begin\":\"" + reader["Begin"].ToString() + "\",\"End\":\"" + reader["End"].ToString() +
               "\",\"treatmentscribe\":\"" + treatmentscribe + "\",\"pname\":\"" + pname + "\",\"Date\":\"" + reader["Date"].ToString() + "\",\"Treatment_ID\":\"" + reader["Treatment_ID"].ToString() + "\"}");
            if (i < count - 1)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        return backText.ToString();

    }


}