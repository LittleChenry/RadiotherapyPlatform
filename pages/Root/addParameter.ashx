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
            case "FixedRequirements":
                addFixedRequirements(value);
                break;
            case "ScanPart":
                addScanPart(value);
                break;
            case "ScanMethod":
                addScanMethod(value);
                break;
            case "EnhanceMethod":
                addEnhanceMethod(value);
                break;
            case "LocationRequirements":
                addLocationRequirements(value);
                break;
            case "DensityConversion":
                addDensityConversion(value);
                break;
            case "EndangeredOrgan":
                addEndangeredOrgan(value);
                break;
            case "Technology":
                addTechnology(value);
                break;
            case "PlanSystem":
                addPlanSystem(value);
                break;
            case "Grid":
                addGrid(value);
                break;
            case "Algorithm":
                addAlgorithm(value);
                break;
            case "ReplacementRequirements":
                addReplacementRequirements(value);
                break;
            case "lightpart":
                addLightPart(value);
                break;
            case "treataim":
                addTreatAim(value);
                break;
            case "headrest":
                addHeadRest(value);
                break;
            case "pendulumfieldinfo":
                addPendulumFieldInfo(value);
                break;
            case "planoptimizedegree":
                addPlanOptimizeDegree(value);
                break;
            case "drr":
                addDrr(value);
                break;
            case "exportotradiotherapynetwork":
                addExportoTradiotherapyNetwork(value);
                break;
            case "splitway":
                addSplitWay(value);
                break;
            case "material":
                addMaterial(value);
                break;
            case "irradiation":
                addIrradiation(value);
                break;
            case "raytype":
                addRaytype(value);
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

    private void addFixedRequirements(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO FixedRequirements(Requirements) VALUES(@Requirements)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addScanPart(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO ScanPart(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    
    private void addScanMethod(string value){
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO ScanMethod(Method) VALUES(@method)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@method", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addEnhanceMethod(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO EnhanceMethod(Method) VALUES(@method)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@method", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addLocationRequirements(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO LocationRequirements(Requirements) VALUES(@Requirements)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addDensityConversion(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO DensityConversion(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addEndangeredOrgan(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO EndangeredOrgan(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addTechnology(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO Technology(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    
    private void addPlanSystem(string value){
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO PlanSystem(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addGrid(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO Grid(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addAlgorithm(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO Algorithm(Name) VALUES(@name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addReplacementRequirements(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO ReplacementRequirements(Requirements) VALUES(@Requirements)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addLightPart(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO lightpart(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name",values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addTreatAim(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO treataim(Aim) VALUES(@Aim)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Aim", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addHeadRest(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO headrest(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addPendulumFieldInfo(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO pendulumfieldinfo(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    private void addPlanOptimizeDegree(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO planoptimizedegree(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addDrr(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO drr(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    private void addExportoTradiotherapyNetwork(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO exportotradiotherapynetwork(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addSplitWay(string value) 
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO splitway(Ways,Interal) VALUES(@Ways,@Interal)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Ways", values[0]);
        sqlOperation.AddParameterWithValue("@Interal",values[1]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addMaterial(string value) 
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO material(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addIrradiation(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO irradiation(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void addRaytype(string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "INSERT INTO raytype(Name) VALUES(@Name)";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}