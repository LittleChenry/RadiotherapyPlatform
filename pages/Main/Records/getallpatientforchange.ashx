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
        string selectequip = "select ID,Name,State,TreatmentItem from equipment where ID=@equip ";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(selectequip);
          StringBuilder backText = new StringBuilder("{\"equipmentinfo\":");
        int i = 0;
        if (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() +
              "\",\"State\":\"" + reader["State"].ToString() + "\",\"TreatmentItem\":\"" + reader["TreatmentItem"].ToString() + "\"}");
        }
        else
        {
            backText.Append("\"\"");
        }
        reader.Close();
        backText.Append(",");
        backText.Append("patientinfo:[");
        string date1= DateTime.Now.ToString("yyyy-MM-dd");
        int h = DateTime.Now.Hour;
        int s = DateTime.Now.Minute;
        int time = h * 60 + s;
        string sqlCommand = "select count(*) from appointment where Equipment_ID=@equip and  (Date>@date1 or (Date=@date1 and Begin>@begintime))  and State=1 and Completed is  NULL";
        sqlOperation.AddParameterWithValue("@equip", equipid);
        sqlOperation.AddParameterWithValue("@begintime", time);
        sqlOperation.AddParameterWithValue("@date1", date1);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlCommand));
        string allpatient = "select * from appointment where Equipment_ID=@equip and  (Date>@date1 or (Date=@date1 and Begin>@begintime))  and State=1 and Completed is  NULL";
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(allpatient);
        while (reader1.Read())
        {
            string treatinfo = "select Treatmentdescribe from treatment where ID=@treat";
            sqlOperation1.AddParameterWithValue("@treat", Convert.ToInt32(reader1["Treatment_ID"].ToString()));
            string treatmentscribe = sqlOperation1.ExecuteScalar(treatinfo);
            string patientname = "select Name from patient where ID=@patient";
            sqlOperation1.AddParameterWithValue("@patient", Convert.ToInt32(reader1["Patient_ID"].ToString()));
            string pname = sqlOperation1.ExecuteScalar(patientname);
            backText.Append("{\"Begin\":\"" + reader1["Begin"].ToString() + "\",\"End\":\"" + reader1["End"].ToString() +
               "\",\"treatmentscribe\":\"" + treatmentscribe + "\",\"pname\":\"" + pname + "\",\"Date\":\"" + reader1["Date"].ToString() + "\",\"Treatment_ID\":\"" + reader1["Treatment_ID"].ToString() + "\"}");
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