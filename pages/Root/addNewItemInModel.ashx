<%@ WebHandler Language="C#" Class="addNewItemInModel" %>

using System;
using System.Web;

public class addNewItemInModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        add(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void add(HttpContext context)
    {
        string mainItem = context.Request.Form["MainItem"];
        string childItem = context.Request.Form["ChildItem"];
        string checkWay = context.Request.Form["checkWay"];
        string explain = context.Request.Form["explain"];
        string reference = context.Request.Form["reference"];
        string cycle = context.Request.Form["cycle"];
        string model = context.Request.Form["model"];
        if (checkWay == "NA")
            reference = "NA";
        else if (checkWay == "IsOK")
            reference = "功能正常";

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "INSERT INTO inspections(MainItem,ChildItem,inspections.Explain,Reference,TemplateID,Cycle) VALUES(@mainItem,@childItem,@explain,@reference,@templateID,@cycle)";

        sqlOperator.AddParameterWithValue("@mainItem", mainItem);
        sqlOperator.AddParameterWithValue("@childItem", childItem);
        sqlOperator.AddParameterWithValue("@explain", explain);
        sqlOperator.AddParameterWithValue("@reference", reference);
        sqlOperator.AddParameterWithValue("@templateID", int.Parse(model));
        sqlOperator.AddParameterWithValue("@cycle", cycle);
        sqlOperator.ExecuteNonQuery(sqlCommand);

            
    }
   
}