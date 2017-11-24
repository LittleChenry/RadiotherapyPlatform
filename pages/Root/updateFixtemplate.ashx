<%@ WebHandler Language="C#" Class="updateFixtemplate" %>

using System;
using System.Web;

public class updateFixtemplate : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = update(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string update(HttpContext context)
    {
        string model = context.Request.Form["model"];
        string fixreq = context.Request.Form["fixreq"];
        string fixequip = context.Request.Form["fixequip"];
        string bodypost = context.Request.Form["bodypost"];
        string Remarks = context.Request.Form["Remarks"];
        string templatename = context.Request.Form["templatename"];
        string templateID = context.Request.Form["templateID"];

        string recordStrSQL = "update fixed set Model_ID=@Model_ID,FixedRequirements_ID=@FixedRequirements_ID,BodyPosition=@BodyPosition,FixedEquipment_ID=@FixedEquipment_ID,RemarksApply=@RemarksApply where ID=@ID";
        sqlOperation.AddParameterWithValue("@Model_ID", Convert.ToInt32(model));
        sqlOperation.AddParameterWithValue("@FixedRequirements_ID", Convert.ToInt32(fixreq));
        sqlOperation.AddParameterWithValue("@BodyPosition", Convert.ToInt32(bodypost));
        sqlOperation.AddParameterWithValue("@FixedEquipment_ID", Convert.ToInt32(fixequip));
        sqlOperation.AddParameterWithValue("@RemarksApply", Remarks);
        sqlOperation.AddParameterWithValue("@ID", Convert.ToInt32(templateID));
        int Success1 = sqlOperation.ExecuteNonQuery(recordStrSQL);

        string tempStrSQL = "update doctortemplate set Name=@Name where TemplateID=@TemplateID";
        sqlOperation1.AddParameterWithValue("@Name", templatename);
        sqlOperation1.AddParameterWithValue("@TemplateID", Convert.ToInt32(templateID));
        int Success2 = sqlOperation1.ExecuteNonQuery(tempStrSQL);
        if (Success1 > 0 && Success2 > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }
    }
}