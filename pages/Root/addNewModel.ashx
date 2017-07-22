<%@ WebHandler Language="C#" Class="addNewModel" %>

using System;
using System.Web;

public class addNewModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(add(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string add(HttpContext context)
    {
        string name = context.Request.QueryString["name"];
        string cycle = context.Request.QueryString["cycle"];
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "INSERT INTO EquipmentInspectionModel(Name,cycle) VALUES(@name,@cycle);SELECT @@IDENTITY";
        sqlOperator.AddParameterWithValue("@name", name);
        sqlOperator.AddParameterWithValue("@cycle", cycle);
        string id = sqlOperator.ExecuteScalar(sqlCommand);
        return id;
    }

}