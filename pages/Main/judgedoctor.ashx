<%@ WebHandler Language="C#" Class="judgedoctor" %>
/* ***********************************************************
 * FileName: judgedoctor.ashx
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 判断操作人是否是病人的组医师
 * **********************************************************/
using System;
using System.Web;
using System.Text;

public class judgedoctor : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getjudgeresult(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            sqlOperation = null;
            sqlOperation1.Close();
            sqlOperation1.Dispose();
            sqlOperation1 = null;
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }


    public string getjudgeresult(HttpContext context)
    {
        string id = context.Request["patientid"];
        string userid = context.Request["userid"];

        string isBelongCommand = "select count(*) from treatment where treatment.Patient_ID=@pid and treatment.Belongingdoctor=@userid";
        sqlOperation.AddParameterWithValue("@pid", id);
        sqlOperation.AddParameterWithValue("@userid", userid);
        int isbelonging = int.Parse(sqlOperation.ExecuteScalar(isBelongCommand));

        string groupCommand = "select DISTINCT(treatment.Group_ID) as groupid from treatment where treatment.Patient_ID=@pid";
        sqlOperation.AddParameterWithValue("@pid", id);
        string groupid = sqlOperation.ExecuteScalar(groupCommand);

        string groupCommand1 = "select Group_ID  from groups2user where ID=@groupid";
        sqlOperation.AddParameterWithValue("@groupid", groupid);
        string group = sqlOperation.ExecuteScalar(groupCommand1);
        
        
        string userInGroupCommand = "select count(*) from groups2user where User_ID=@userid and Group_ID=@groupid";
        sqlOperation.AddParameterWithValue("@userid", userid);
        sqlOperation.AddParameterWithValue("@groupid", group);
        int isuser = int.Parse(sqlOperation.ExecuteScalar(userInGroupCommand));

        if (isuser != 0 || isbelonging != 0)
        {
            return "success";
        }
        else
        {

            return "failure";
        }
        
    }
    

}