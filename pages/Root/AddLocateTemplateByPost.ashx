﻿<%@ WebHandler Language="C#" Class="AddLocateTemplateByPost" %>

using System;
using System.Web;

public class AddLocateTemplateByPost : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    DataLayer sqlOperation1 = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/x-www-form-urlencoded";
        string result = AddLocationApplyRecord(context);
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
    public string AddLocationApplyRecord(HttpContext context)
    {
        //获取表单信息       
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

        //将信息写入数据库，并返回是否成功
        DateTime now = DateTime.Now;
        string date = now.ToString();
        //将信息写入数据库，并返回是否成功
        string strSqlCommand = "INSERT INTO location(ScanPart_ID,ScanMethod_ID,UpperBound,Enhance,EnhanceMethod_ID,LowerBound,LocationRequirements_ID,Remarks,Application_User_ID,ApplicationTime) " +
                                "VALUES(@ScanPart_ID,@ScanMethod_ID,@UpperBound,@Enhance,@EnhanceMethod_ID,@LowerBound,@LocationRequirements_ID,@Remarks,@Application_User_ID,@ApplicationTime)";
        if (scanpart == "")
        {
            sqlOperation1.AddParameterWithValue("@ScanPart_ID", null);
        }
        else
        {
            sqlOperation1.AddParameterWithValue("@ScanPart_ID", scanpart);
        }
        
        sqlOperation1.AddParameterWithValue("@ScanMethod_ID", Convert.ToInt32(scanmethod));
        sqlOperation1.AddParameterWithValue("@UpperBound", up);
        sqlOperation1.AddParameterWithValue("@ApplicationTime", date);
        sqlOperation1.AddParameterWithValue("@LowerBound", down);
        sqlOperation1.AddParameterWithValue("@LocationRequirements_ID", Convert.ToInt32(requirement));
        sqlOperation1.AddParameterWithValue("@Remarks", remark);
        sqlOperation1.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
        sqlOperation1.AddParameterWithValue("@Enhance", Convert.ToInt32(add));
        if (Convert.ToInt32(add) == 1)
        {
            sqlOperation1.AddParameterWithValue("@EnhanceMethod_ID", Convert.ToInt32(addmethod));
        }
        else
        {
            sqlOperation1.AddParameterWithValue("@EnhanceMethod_ID", null);
        }

        int Success2 = sqlOperation1.ExecuteNonQuery(strSqlCommand);


        string maxnumber = "select ID from  location where ApplicationTime=@ApplicationTime and Application_User_ID=@Application_User_ID order by ID desc";
        sqlOperation.AddParameterWithValue("@Application_User_ID", Convert.ToInt32(user));
        sqlOperation.AddParameterWithValue("@ApplicationTime", date);
        string maxfixid = sqlOperation.ExecuteScalar(maxnumber);

        string inserttreat = "INSERT INTO doctortemplate(Name,TemplateID,Type,User_ID) " +
                                "VALUES(@Name,@TemplateID,@Type,@User_ID)";
        sqlOperation.AddParameterWithValue("@Type", 3);
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