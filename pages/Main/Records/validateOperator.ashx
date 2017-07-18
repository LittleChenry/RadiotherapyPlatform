<%@ WebHandler Language="C#" Class="validateOperator" %>

using System;
using System.Web;

public class validateOperator : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(validate(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    public string validate(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string number = context.Request["Number"];
        string Password = context.Request["Password"];
        string sqlcommand = "select count(*) from user where Number=@number and Password=@pass";
        sqlOperation.AddParameterWithValue("@number", number);
        sqlOperation.AddParameterWithValue("@pass", Password);
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlcommand));
       
        if (count== 0)
        {
            return "fail";
        }
        else
        {
            string sqlcommand1 = "select Name from user where Number=@number and Password=@pass";
            string name = sqlOperation.ExecuteScalar(sqlcommand1);
            return name;
        }      
        
    }

}