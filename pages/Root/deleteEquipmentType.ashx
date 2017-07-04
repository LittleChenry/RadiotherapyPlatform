<%@ WebHandler Language="C#" Class="deleteEquipmentType" %>

using System;
using System.Web;

public class deleteEquipmentType : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        delete(context);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void delete(HttpContext context)
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");

        string id = context.Request.Form["id"];

        string sqlCommand = "DELETE FROM equipmenttype WHERE ID=@id";
        sqlOperator.AddParameterWithValue("@id", id);

        sqlOperator.ExecuteNonQuery(sqlCommand);

        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
    }
}