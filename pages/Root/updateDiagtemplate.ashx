<%@ WebHandler Language="C#" Class="updateDiagtemplate" %>

using System;
using System.Web;

public class updateDiagtemplate : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = update(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        sqlOperation2.Close();
        sqlOperation2.Dispose();
        sqlOperation2 = null;

        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string update(HttpContext context) 
    {
        string part = context.Request["part"];
        string newpart = context.Request["newpart"];
        string remark = context.Request["remark"];
        string Aim = context.Request["Aim"];
        string copybingli1 = context.Request["copybingli1"];
        string copybingli2 = context.Request["copybingli2"];
        string copybingqing1 = context.Request["copybingqing1"];
        string copybingqing2 = context.Request["copybingqing2"];
        string copybingqing3 = context.Request["copybingqing3"];
        string TemplateName = context.Request["TemplateName"];
        string templateID = context.Request["templateID"];
        string diagRecordID = context.Request["diagRecordID"];

        string selectcode1 = "select ID from icdcode where Group1=@group1 and Group2=@group2 and Chinese=@group3";
        sqlOperation.AddParameterWithValue("@group1", copybingqing1);
        sqlOperation.AddParameterWithValue("@group2", copybingqing2);
        sqlOperation.AddParameterWithValue("@group3", copybingqing3);
        int code1 = Convert.ToInt32(sqlOperation.ExecuteScalar(selectcode1));

        string selectcode2 = "select ID from morphol where Groupsecond=@group3 and Groupfirst=@group4 ";
        sqlOperation.AddParameterWithValue("@group3", copybingli1);
        sqlOperation.AddParameterWithValue("@group4", copybingli2);
        int code2 = Convert.ToInt32(sqlOperation.ExecuteScalar(selectcode2));

        string strSqlCommand = "update diagnosisrecord set Part_ID=@Part_ID,LightPart_ID=@LightPart_ID,DiagnosisResult_ID=@DiagnosisResult_ID,PathologyResult=@PathologyResult,Remarks=@Remarks,TreatAim_ID=@TreatAim_ID where ID=@diagRecordID";
        sqlOperation1.AddParameterWithValue("@Part_ID", part);
        sqlOperation1.AddParameterWithValue("@LightPart_ID", newpart);
        sqlOperation1.AddParameterWithValue("@DiagnosisResult_ID", code1);
        sqlOperation1.AddParameterWithValue("@PathologyResult", code2);
        sqlOperation1.AddParameterWithValue("@TreatAim_ID", Convert.ToInt32(Aim));
        sqlOperation1.AddParameterWithValue("@diagRecordID", Convert.ToInt32(diagRecordID));
        sqlOperation1.AddParameterWithValue("@Remarks", remark);
        int intSuccess = sqlOperation1.ExecuteNonQuery(strSqlCommand);
        
        string strSqlCommand2 = "update doctortemplate set Name=@Name where ID=@ID";
        sqlOperation2.AddParameterWithValue("@Name",TemplateName);
        sqlOperation2.AddParameterWithValue("@ID", templateID);
        int intSuccess1 = sqlOperation2.ExecuteNonQuery(strSqlCommand2);
        if (intSuccess > 0 && intSuccess1 > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }
    }
}