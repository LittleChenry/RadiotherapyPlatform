<%@ WebHandler Language="C#" Class="GetfinishedimportCT" %>

using System;
using System.Web;
using System.Text;
public class GetfinishedimportCT : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = patientimportCTInformation(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string patientimportCTInformation(HttpContext context)
    {
        string treatid = context.Request["treatmentID"];
        DataLayer sqlOperation = new DataLayer("sqlStr");
        StringBuilder backText = new StringBuilder("{\"info\":[");
        string sqlCommand = "select DensityConversion_ID,SequenceNaming,ct.Thickness as Thickness,ct.Number as Number,ct.ReferenceScale as ReferenceScale,ct.MultimodalImage as MultimodalImage,user.Name as username,ct.OperateTime as  OperateTime,ct.Remarks as remarks from location,ct,treatment,user where treatment.ID=@treat and treatment.Location_ID=location.ID and location.CT_ID=ct.ID and ct.Operate_User_ID=user.ID";
        sqlOperation.AddParameterWithValue("@treat", treatid);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backText.Append("{\"DensityConversion_ID\":\"" + reader["DensityConversion_ID"].ToString() + "\",\"SequenceNaming\":\"" + reader["SequenceNaming"] +
                 "\",\"Thickness\":\"" + reader["Thickness"].ToString() + "\",\"Number\":\"" + reader["Number"].ToString() + "\",\"ReferenceScale\":\"" + reader["ReferenceScale"].ToString() +
                 "\",\"MultimodalImage\":\"" + reader["MultimodalImage"].ToString() + "\",\"Remarks\":\"" + reader["remarks"].ToString() + "\",\"OperateTime\":\"" + reader["OperateTime"].ToString() + "\",\"username\":\"" + reader["username"].ToString() + "\"}");
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