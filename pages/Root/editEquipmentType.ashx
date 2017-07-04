<%@ WebHandler Language="C#" Class="editEquipmentType" %>

using System;
using System.Web;

public class editEquipmentType : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        update(context);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void update(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");

        string id = context.Request.Form["id"];
        string type = context.Request.Form["type"];
        string sqlCommand = "UPDATE equipmenttype SET Type=@type WHERE ID=@id";
        sqlOperator.AddParameterWithValue("@type", type);
        sqlOperator.AddParameterWithValue("@id", id);
        sqlOperator.ExecuteNonQuery(sqlCommand);

        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
    }

}