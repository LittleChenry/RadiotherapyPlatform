<%@ WebHandler Language="C#" Class="updateLocatetemplate" %>

using System;
using System.Web;

public class updateLocatetemplate : IHttpHandler {
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        string result = update(context);
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
        string templateID = context.Request.Form["templateID"];
        string scanpart = context.Request.Form["scanpart"];
        string scanmethod = context.Request.Form["scanmethod"];
        string user = context.Request.Form["user"];
        string add = context.Request.Form["add"];
        string addmethod = context.Request.Form["addmethod"];
        string down = context.Request.Form["down"];
        string up = context.Request.Form["up"];
        string remark = context.Request.Form["remark"];
        string requirement = context.Request.Form["requirement"];
        string name = context.Request.Form["templatename"];

        string tempStrSQL = "update doctortemplate set Name=@Name where TemplateID=@TemplateID";
        sqlOperation1.AddParameterWithValue("@Name", name);
        sqlOperation1.AddParameterWithValue("@TemplateID", Convert.ToInt32(templateID));
        int Success1 = sqlOperation1.ExecuteNonQuery(tempStrSQL);

        string recordStrSQL = "update location set ScanPart_ID=@ScanPart_ID,ScanMethod_ID=@ScanMethod_ID,UpperBound=@UpperBound,LowerBound=@LowerBound,Enhance=@Enhance,EnhanceMethod_ID=@EnhanceMethod_ID,LocationRequirements_ID=@LocationRequirements_ID,Remarks=@Remarks where ID=@ID";
        if (scanpart == "")
        {
            sqlOperation2.AddParameterWithValue("@ScanPart_ID", DBNull.Value);
        }
        else
        {
            sqlOperation2.AddParameterWithValue("@ScanPart_ID", scanpart);
        }
        sqlOperation2.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(scanmethod));
        sqlOperation2.AddParameterWithValue("@UpperBound", up);
        sqlOperation2.AddParameterWithValue("@LowerBound", down);
        sqlOperation2.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(requirement));
        sqlOperation2.AddParameterWithValue("@Remarks", remark);
        sqlOperation2.AddParameterWithValue("@Enhance", Convert.ToInt32(add));
        if (Convert.ToInt32(add) == 1)
        {
            sqlOperation2.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(addmethod));
        }
        else
        {
            sqlOperation2.AddParameterWithValue("@EnhanceMethod_ID", DBNull.Value);
        }
        sqlOperation2.AddParameterWithValue("@ID", Convert.ToInt32(templateID));
        int Success2 = sqlOperation2.ExecuteNonQuery(recordStrSQL);
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