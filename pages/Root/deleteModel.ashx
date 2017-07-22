<%@ WebHandler Language="C#" Class="deleteModel" %>

using System;
using System.Web;

public class deleteModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        delete(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void delete(HttpContext context)
    {
        string cycle = context.Request.Form["cycle"];
        string model = context.Request.Form["model"];
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "DELETE FROM EquipmentInspectionModel WHERE ID=@id";
        sqlOperator.AddParameterWithValue("@id", model);
        sqlOperator.ExecuteNonQuery(sqlCommand);
    }
}