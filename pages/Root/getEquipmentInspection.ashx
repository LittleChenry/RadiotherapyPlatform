<%@ WebHandler Language="C#" Class="getEquipmentInspection" %>

using System;
using System.Web;
using System.Text;

public class getEquipmentInspection : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInspection()
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT * FROM inspection WHERE Cycle=Day";
        return "";
    }
}