<%@ WebHandler Language="C#" Class="addEquipmentType" %>

using System;
using System.Web;

public class addEquipmentType : IHttpHandler {
    
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
        string type = context.Request.Form["type"];
        DataLayer sqlOperater = new DataLayer("sqlStr");
        string sqlCommand = "INSERT INTO equipmenttype(Type) VALUES(@type)";
        sqlOperater.AddParameterWithValue("@type", type);
        sqlOperater.ExecuteNonQuery(sqlCommand);

        sqlOperater.Close();
        sqlOperater.Dispose();
        sqlOperater = null;
    }
}