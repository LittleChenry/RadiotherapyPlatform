<%@ WebHandler Language="C#" Class="parameterDelete" %>

using System;
using System.Web;

public class parameterDelete : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        selectDelete(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write("");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
    private void selectDelete(HttpContext context)
    {
        string type = context.Request.Form["type"];
        string id = context.Request.Form["id"];
        //string value = context.Request.Form["value"];

        switch (type)
        {
            case "part":
                deletePart(id);
                break;
            case "DiagnosisResult":
                deleteDiagnosisResult(id);
                break;
            case "FixedEquipment":
                deleteFixedEquipment(id);
                break;
            case "FixedRequirements":
                deleteFixedRequirements(id);
                break;
            case "ScanPart":
                deleteScanPart(id);
                break;
            case "ScanMethod":
                deleteScanMethod(id);
                break;
            case "EnhanceMethod":
                deleteEnhanceMethod(id);
                break;
            case "LocationRequirements":
                deleteLocationRequirements(id);
                break;
            case "DensityConversion":
                deleteDensityConversion(id);
                break;
            case "EndangeredOrgan":
                deleteEndangeredOrgan(id);
                break;
            case "Technology":
                deleteTechnology(id);
                break;
            case "PlanSystem":
                deletePlanSystem(id);
                break;
            case "Grid":
                deleteGrid(id);
                break;
            case "Algorithm":
                deleteAlgorithm(id);
                break;
            case "ReplacementRequirements":
                deleteReplacementRequirements(id);
                break;
            case "lightpart":
                deleteLightPart(id);
                break;
            case "treataim":
                deleteTreatAim(id);
                break;
            case "headrest":
                deleteHeadRest(id);
                break;
            case "pendulumfieldinfo":
                deletePendulumFieldInfo(id);
                break;
            case "planoptimizedegree":
                deletePlanOptimizeDegree(id);
                break;
            case "drr":
                deleteDrr(id);
                break;
            case "exportotradiotherapynetwork":
                deleteExportoTradiotherapyNetwork(id);
                break;
            case "splitway":
                deleteSplitWay(id);
                break;
            case "material":
                deletematerial(id);
                break;
            case "irradiation":
                deleteIrradiation(id);
                break;
            case "raytype":
                deleteRaytype(id);
                break;
            case "bodyposition":
                deleteBodyposition(id);
                break;
            case "energy":
                deleteEnergy(id);
                break;
            default:
                break;
        }
    }
    private void deletePart(string id)
    {
        string sqlCommand = "delete from part where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteDiagnosisResult(string id)
    {
        string sqlCommand = "delete from diagnosisresult where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteFixedEquipment(string id)
    {
        string sqlCommand = "delete from fixedequipment where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteFixedRequirements(string id)
    {
        string sqlCommand = "delete from fixedrequirements where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    private void deleteScanPart(string id)
    {
        string sqlCommand = "delete from scanpart where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteScanMethod(string id)
    {
        string sqlCommand = "delete from scanmethod where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteEnhanceMethod(string id)
    {
        string sqlCommand = "delete from enhancemethod where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
    
    private void deleteLocationRequirements(string id)
    {
        string sqlCommand = "delete from locationrequirements where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteDensityConversion(string id)
    {
        string sqlCommand = "delete from densityconversion where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteEndangeredOrgan(string id)
    {
        string sqlCommand = "delete from endangeredorgan where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteTechnology(string id)
    {
        string sqlCommand = "delete from technology where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deletePlanSystem(string id)
    {
        string sqlCommand = "delete from plansystem where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteGrid(string id)
    {
        string sqlCommand = "delete from grid where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteAlgorithm(string id)
    {
        string sqlCommand = "delete from algorithm where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteReplacementRequirements(string id)
    {
        string sqlCommand = "delete from replacementrequirements where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteLightPart(string id)
    {
        string sqlCommand = "delete from lightpart where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteTreatAim(string id)
    {
        string sqlCommand = "delete from treataim where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteHeadRest(string id)
    {
        string sqlCommand = "delete from headrest where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deletePendulumFieldInfo(string id)
    {
        string sqlCommand = "delete from pendulumfieldinfo where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deletePlanOptimizeDegree(string id)
    {
        string sqlCommand = "delete from planoptimizedegree where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteDrr(string id)
    {
        string sqlCommand = "delete from drr where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteExportoTradiotherapyNetwork(string id)
    {
        string sqlCommand = "delete from exportotradiotherapynetwork where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteSplitWay(string id)
    {
        string sqlCommand = "delete from splitway where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deletematerial(string id)
    {
        string sqlCommand = "delete from material where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteIrradiation(string id)
    {
        string sqlCommand = "delete from irradiation where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteRaytype(string id)
    {
        string sqlCommand = "delete from raytype where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteBodyposition(string id)
    {
        string sqlCommand = "delete from bodyposition where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }

    private void deleteEnergy(string id) 
    {
        string sqlCommand = "delete from energy where id=@id";
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);
    }
}