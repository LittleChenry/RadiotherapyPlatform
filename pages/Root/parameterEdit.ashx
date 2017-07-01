<%@ WebHandler Language="C#" Class="parameterEdit" %>

using System;
using System.Web;
using System.Text;

public class parameterEdit : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        selectUpdate(context);
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void selectUpdate(HttpContext context)
    {
        string type = context.Request.Form["type"];
        string id = context.Request.Form["id"];
        string value = context.Request.Form["value"];

        switch (type)
        {
            case "part":
                updatePart(id, value);
                break;
            case "DiagnosisResult":
                updateDiagnosisResult(id, value);
                break;
            case "FixedEquipment":
                updateFixedEquipment(id, value);
                break;
            default:
                break;
        }
    }
    
    private void updatePart(string id, string value){
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE part set Code=@code,Name=@name,Description=@description WHERE ID=@id";
        
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.AddParameterWithValue("@id", id);
        
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    
    private void  updateDiagnosisResult(string id, string value){
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE diagnosisResult set Code=@code,TumorName=@name,Description=@description WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateFixedEquipment(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE FixedEquipment set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}