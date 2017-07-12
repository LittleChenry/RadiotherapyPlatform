<%@ WebHandler Language="C#" Class="getfinishedreplacerecord" %>

using System;
using System.Web;
using System.Text;


public class getfinishedreplacerecord : IHttpHandler {

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = patientLocationInformation(context);
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string patientLocationInformation(HttpContext context)
    {
        int treatid = Convert.ToInt32(context.Request.QueryString["treatmentID"]);
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "select Patient_ID from treatment where treatment.ID=@treatID";
        sqlOperation.AddParameterWithValue("@treatID", treatid);
        int patientid = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));

        string sqlcommand = "select distinct(count(*)) from treatment,user,replacement where treatment.Replacement_ID=replacement.ID and replacement.Operate_User_ID=user.ID and treatment.Patient_ID=@patient and treatment.Progress>=13";
        sqlOperation.AddParameterWithValue("@patient", patientid);
        int count = Convert.ToInt32(sqlOperation.ExecuteScalar(sqlcommand));
        StringBuilder backText = new StringBuilder("{\"info\":[");
        int i = 1;
        string sqlCommand1 = "select Treatmentname,OriginCenter,PlanCenter,Movement,Distance,ReferenceDRRPicture,VerificationPicture,Result,user.Name as username,OperateTime,Remarks from treatment,user,replacement where treatment.Replacement_ID=replacement.ID and replacement.Operate_User_ID=user.ID and treatment.Patient_ID=@patient and treatment.Progress>=13";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand1);
        while (reader.Read())
        {
            backText.Append("{\"OriginCenter\":\"" + reader["OriginCenter"].ToString() + "\",\"PlanCenter\":\"" + reader["PlanCenter"].ToString() + "\",\"treatmentname\":\"" + reader["Treatmentname"].ToString() + "\",\"Movement\":\"" + reader["Movement"].ToString() + "\",\"Distance\":\"" + reader["Distance"].ToString() +
                 "\",\"ReferenceDRRPicture\":\"" + reader["ReferenceDRRPicture"].ToString()  +
                 "\",\"VerificationPicture\":\"" + reader["VerificationPicture"].ToString() + "\",\"Result\":\"" + reader["Result"].ToString() + "\",\"OperateTime\":\"" + reader["OperateTime"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\",\"Remarks\":\"" + reader["Remarks"].ToString() + "\"}");
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
        return backText.ToString();

    }
}