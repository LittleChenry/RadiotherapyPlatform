<%@ WebHandler Language="C#" Class="AddFixTemplateByPost" %>

using System;
using System.Web;

public class AddFixTemplateByPost : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        string result = AddFixRecord(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        sqlOperation1.Close();
        sqlOperation1.Dispose();
        sqlOperation1 = null;
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    public string AddFixRecord(HttpContext context)
    {
        //获取表单信息      
        string treatid = context.Request.Form["treatid"];
        string model = context.Request.Form["model"];
        string fixreq = context.Request.Form["fixreq"];
        string user = context.Request.Form["user"];
        string fixequip = context.Request.Form["fixequip"];
        string bodypost = context.Request.Form["bodypost"];
        string Remarks = context.Request.Form["Remarks"];
        string name = context.Request.Form["templatename"];
        //将信息写入数据库，并返回是否成功
        DateTime now = DateTime.Now;
        string date = now.ToString();
        string strSqlCommand = "INSERT INTO fixed(Model_ID,FixedRequirements_ID,Application_User_ID,ApplicationTime,BodyPosition,RemarksApply,FixedEquipment_ID) " +
                                "VALUES(@Model_ID,@FixedRequirements_ID,@Application_User_ID,@ApplicationTime,@BodyPosition,@RemarksApply,@FixedEquipment_ID)";
        sqlOperation1.AddParameterWithValue("@Model_ID", Convert.ToInt32(model));
        sqlOperation1.AddParameterWithValue("@FixedRequirements_ID", Convert.ToInt32(fixreq));
        sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
        sqlOperation1.AddParameterWithValue("@ApplicationTime", date);
        sqlOperation1.AddParameterWithValue("@BodyPosition", bodypost);
        sqlOperation1.AddParameterWithValue("@RemarksApply", Remarks);
        sqlOperation1.AddParameterWithValue("@FixedEquipment_ID", fixequip);
        int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);

        string maxnumber = "select ID from fixed where ApplicationTime=@ApplicationTime and Application_User_ID=@Application_User_ID order by ID desc";
        sqlOperation.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
        sqlOperation.AddParameterWithValue("@ApplicationTime", date);
        string maxfixid = sqlOperation.ExecuteScalar(maxnumber);

        //将诊断ID填入treatment表
        string inserttreat = "INSERT INTO doctortemplate(Name,TemplateID,Type,User_ID) " +
                                "VALUES(@Name,@TemplateID,@Type,@User_ID)";
        sqlOperation.AddParameterWithValue("@Type", 2);
        sqlOperation.AddParameterWithValue("@TemplateID", Convert.ToInt32(maxfixid));
        sqlOperation.AddParameterWithValue("@User_ID", Convert.ToInt32(user));
        sqlOperation.AddParameterWithValue("@Name", name);
        int Success = sqlOperation.ExecuteNonQuery(inserttreat);
        if (Success > 0 && Success2 > 0)
        {
            return "success";
        }
        else
        {
            return "failure";
        }
    }
}