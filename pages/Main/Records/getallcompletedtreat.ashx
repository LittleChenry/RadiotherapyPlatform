<%@ WebHandler Language="C#" Class="getallcompletedtreat" %>

using System;
using System.Web;
using System.Text;

public class getallcompletedtreat : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = patientfixInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string patientfixInformation(HttpContext context)
    {
        int radiotherapyid = Convert.ToInt32(context.Request["Radiotherapy_ID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        DataLayer sqlOperation1 = new DataLayer("sqlStr");
        string sqlCommand = "select ID from patient where Radiotherapy_ID=@radio";
        sqlOperation.AddParameterWithValue("@radio", radiotherapyid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        string sqlcommand2 = "select count(*) from treatment where Patient_ID=@patient";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand2));

        StringBuilder backText = new StringBuilder("{\"treatinfo\":[");
        int i = 1;
        string sqlCommand2 = "select * from treatment where Patient_ID=@patient";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand2);
        while (reader.Read())
        {
            string fix="";
            string location = "";
            string design = "";
            string replace = "";
            if (reader["Fixed_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from fixed where ID=@fix";
                sqlOperation1.AddParameterWithValue("@fix", Convert.ToInt32(reader["Fixed_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    fix = "";
                }
                else
                {
                    fix = reader["Fixed_ID"].ToString();
                }
            }
            if (reader["Location_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from location where ID=@location";
                sqlOperation1.AddParameterWithValue("@location", Convert.ToInt32(reader["Location_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                string sqlCommand4 = "select CT_ID from location where ID=@location";
                string ct = sqlOperation1.ExecuteScalar(sqlCommand4);
                if (user == "" || ct=="")
                {
                    location = "";
                }
                else
                {
                    location= reader["Fixed_ID"].ToString();
                }
            }
            if (reader["Review_ID"].ToString() != "")
            {
                string sqlCommand3 = "select _User_ID from review where ID=@review";
                sqlOperation1.AddParameterWithValue("@review", Convert.ToInt32(reader["Review_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    design = "";
                }
                else
                {
                    design = reader["Design_ID"].ToString();
                }
            }
            if (reader["Replacement_ID"].ToString() != "")
            {
                string sqlCommand3 = "select Operate_User_ID from replacement where ID=@replace";
                sqlOperation1.AddParameterWithValue("@replace", Convert.ToInt32(reader["Replacement_ID"].ToString()));
                string user = sqlOperation1.ExecuteScalar(sqlCommand3);
                if (user == "")
                {
                    replace = "";
                }
                else
                {
                    replace = reader["Replacement_ID"].ToString();
                }
            }
            backText.Append("{\"diagnose\":\"" + reader["DiagnosisRecord_ID"].ToString() + "\",\"fixed\":\"" + fix + "\",\"location\":\"" + location + "\",\"design\":\"" + design + "\",\"replace\":\"" + replace + "\",\"treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"review\":\"" + reader["Review_ID"].ToString() + "\",\"group\":\"" + reader["Group_ID"].ToString() + "\"}");
            if (i < count)
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
        sqlOperation1= null;
        return backText.ToString();
    }

}