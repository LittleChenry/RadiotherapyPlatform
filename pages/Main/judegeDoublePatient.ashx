<%@ WebHandler Language="C#" Class="judegeDoublePatient" %>
/* ***********************************************************
 * FileName: judegeDoublePatient.ashx
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 判读输入的病人姓名或者身份证ID在数据库中是否重复
 * **********************************************************/
using System;
using System.Web;
using System.Text;

public class judegeDoublePatient : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getDoubleCondition(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string getDoubleCondition(HttpContext context)
    {
        string id = context.Request["id"];
        string name = context.Request["name"];
        
        //查两次，一次查姓名，一次查身份证
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlID = "select count(*) from patient where IdentificationNumber=@cid";
        sqlOperation.AddParameterWithValue("@cid", id);
        int countID = int.Parse(sqlOperation.ExecuteScalar(sqlID));
        string sqlName = "select count(*) from patient where Name=@name";
        sqlOperation.AddParameterWithValue("@name", name);
        int countName = int.Parse(sqlOperation.ExecuteScalar(sqlName));
        //身份证重复
        if (countID > 0)
        {
            return "IDdouble";
        }
        //姓名重复
        if (countName > 0)
        {
            return "NameDouble";
        }
        //没有重复
        return "noDouble";
        
    }

}