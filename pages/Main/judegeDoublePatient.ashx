<%@ WebHandler Language="C#" Class="judegeDoublePatient" %>


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
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlID = "select count(*) from patient where IdentificationNumber=@cid";
        sqlOperation.AddParameterWithValue("@cid", id);
        int countID = int.Parse(sqlOperation.ExecuteScalar(sqlID));
        string sqlName = "select count(*) from patient where Name=@name";
        sqlOperation.AddParameterWithValue("@name", name);
        int countName = int.Parse(sqlOperation.ExecuteScalar(sqlName));
        if (countID > 0)
        {
            return "IDdouble";
        }
        if (countName > 0)
        {
            return "NameDouble";
        }
        return "noDouble";
        
    }

}