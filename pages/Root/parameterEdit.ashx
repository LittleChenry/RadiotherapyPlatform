﻿<%@ WebHandler Language="C#" Class="parameterEdit" %>

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
            case "FixedRequirements":
                updateFixedRequirements(id, value);
                break;
            case "ScanPart":
                updateScanPart(id, value);
                break;
            case "ScanMethod":
                updateScanMethod(id, value);
                break;
            case "EnhanceMethod":
                updateEnhanceMethod(id, value);
                break;
            case "LocationRequirements":
                updateLocationRequirements(id, value);
                break;
            case "DensityConversion":
                updateDensityConversion(id, value);
                break;
            case "EndangeredOrgan":
                updateEndangeredOrgan(id, value);
                break;
            case "Technology":
                updateTechnology(id, value);
                break;
            case "PlanSystem":
                updatePlanSystem(id, value);
                break;
            case "Grid":
                updateGrid(id, value);
                break;
            case "Algorithm":
                updateAlgorithm(id, value);
                break;
            case "ReplacementRequirements":
                updateReplacementRequirements(id, value);
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

    private void updateFixedRequirements(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE FixedRequirements set Requirements=@Requirements WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateScanPart(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE ScanPart set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateScanMethod(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE ScanMethod set Method=@method WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@method", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateEnhanceMethod(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE EnhanceMethod set Method=@method WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@method", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateLocationRequirements(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE LocationRequirements set Requirements=@Requirements WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateDensityConversion(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE DensityConversion set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateEndangeredOrgan(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE EndangeredOrgan set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateTechnology(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE Technology set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updatePlanSystem(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE PlanSystem set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateGrid(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE Grid set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateAlgorithm(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE Algorithm set Name=@name WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void updateReplacementRequirements(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE ReplacementRequirements set Requirements=@Requirements WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}