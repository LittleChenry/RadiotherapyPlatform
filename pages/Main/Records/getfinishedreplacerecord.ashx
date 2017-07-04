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
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select replacementrequirements.Requirements as replacerequire,user.Name as username,OriginCenter,PlanCenter,Movement,ReferenceDRRPicture,VerificationPicture,Result,OperateTime,replacement.Remarks as remark from treatment,replacement,user,replacementrequirements where treatment.ID=@treat and treatment.Replacement_ID=replacement.ID and replacement.Operate_User_ID=user.ID and replacement.ReplacementRequirements_ID=replacementrequirements.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"replacerequire\":\"" + reader["replacerequire"].ToString() + "\",\"username\":\"" + reader["username"] +
                 "\",\"OriginCenter\":\"" + reader["OriginCenter"].ToString() + "\",\"PlanCenter\":\"" + reader["PlanCenter"].ToString() + "\",\"Movement\":\"" + reader["Movement"].ToString() +
                 "\",\"ReferenceDRRPicture\":\"" + reader["ReferenceDRRPicture"].ToString() + "\",\"VerificationPicture\":\"" + reader["VerificationPicture"].ToString() +
                 "\",\"Result\":\"" + reader["Result"].ToString() + "\",\"OperateTime\":\"" + reader["OperateTime"].ToString() + "\",\"remark\":\"" + reader["remark"].ToString() + "\"}");
            backText.Append(",");
        }
        backText.Append("]}");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backText.ToString();

    }
}