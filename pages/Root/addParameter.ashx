<%@ WebHandler Language="C#" Class="addParameter" %>

using System;
using System.Web;

public class addParameter : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
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
        string value = context.Request.Form["value"];
        switch (type)
        {
            case "part":
                addPart(value);
                break;
            case "DiagnosisResult":
                addDiagnosisResult(value);
                break;
            case "FixedEquipment":
                addFixedEquipment(value);
                break;
            default:
                break;
        }
    }

    private void addPart(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO part(Code,Name,Description) VALUES(@code,@name,@description)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addDiagnosisResult(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO DiagnosisResult(Code,TumorName,Description) VALUES(@code,@name,@description)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    
    private void addFixedEquipment(string value){
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO FixedEquipment(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}