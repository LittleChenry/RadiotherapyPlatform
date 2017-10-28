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
            case "lightpart":
                updateLightPart(id,value);
                break;
            case "treataim":
                updateTreatAim(id,value);
                break;
            case "headrest":
                updateHeadRest(id, value);
                break;
            case "pendulumfieldinfo":
                updatePendulumFieldInfo(id, value);
                break;
            case "planoptimizedegree":
                updatePlanOptimizeDegree(id, value);
                break;
            case "drr":
                updateDrr(id, value);
                break;
            case "exportotradiotherapynetwork":
                updateExportoTradiotherapyNetwork(id, value);
                break;
            case "splitway":
                updateSplitWay(id, value);
                break;
            case "material":
                updateMaterial(id,value);
                break;
            case "irradiation":
                updateIrradiation(id,value);
                break;
            case "raytype":
                updateRaytype(id, value);
                break;
            case "bodyposition":
                updateBodyposition(id,value);
                break;
            case "energy":
                updateEnergy(id,value);
                break;
            default:
                break;
        }
    }
    
    private void updatePart(string id, string value){
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE part set Code=@code,Name=@name,Description=@description,IsDefault=@IsDefault WHERE ID=@id";
        
        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[3]));
        sqlOperation.AddParameterWithValue("@id", id);
        
        sqlOperation.ExecuteNonQuery(sqlCommand);
        if (values[3] == "0")
        {
            string sqlCommand1 = "update part set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
    
    private void  updateDiagnosisResult(string id, string value){
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE diagnosisResult set Code=@code,TumorName=@name,Description=@description,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@code", values[0]);
        sqlOperation.AddParameterWithValue("@name", values[1]);
        sqlOperation.AddParameterWithValue("@description", values[2]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[3]));
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);
        if (values[3] == "0")
        {
            string sqlCommand1 = "update diagnosisResult set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateFixedEquipment(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE fixedequipment set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update fixedequipment set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateFixedRequirements(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE fixedrequirements set Requirements=@Requirements,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update fixedrequirements set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateScanPart(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE scanpart set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update scanpart set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateScanMethod(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE scanmethod set Method=@Method,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Method", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update scanmethod set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateEnhanceMethod(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE enhancemethod set Method=@Method,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Method", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update enhancemethod set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateLocationRequirements(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE locationrequirements set Requirements=@Requirements,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update locationrequirements set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateDensityConversion(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE densityconversion set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update densityconversion set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateEndangeredOrgan(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE endangeredorgan set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update endangeredorgan set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateTechnology(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE technology set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update technology set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updatePlanSystem(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE plansystem set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update plansystem set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateGrid(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE grid set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update grid set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateAlgorithm(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE algorithm set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update algorithm set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateReplacementRequirements(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE replacementrequirements set Requirements=@Requirements,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Requirements", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update replacementrequirements set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateLightPart(string id, string value) 
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE lightpart set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update lightpart set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateTreatAim(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE treataim set Aim=@Aim,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Aim", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update treataim set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateHeadRest(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE headrest set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update headrest set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updatePendulumFieldInfo(string id, string value) 
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE pendulumfieldinfo set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update pendulumfieldinfo set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
    private void updatePlanOptimizeDegree(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE planoptimizedegree set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update planoptimizedegree set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
    private void updateDrr(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE drr set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update drr set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
    private void updateExportoTradiotherapyNetwork(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE exportotradiotherapynetwork set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update exportotradiotherapynetwork set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
    private void updateSplitWay(string id, string value)
    {
        string[] values = value.Split(' ');
        string sqlCommand = "UPDATE splitway set Ways=@Ways,Interal=@Interal,Times=@Times,TimeInteral=@TimeInteral,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Ways", values[0]);
        sqlOperation.AddParameterWithValue("@Interal",values[1]);
        sqlOperation.AddParameterWithValue("@Times", values[2]);
        sqlOperation.AddParameterWithValue("@TimeInteral", values[3]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[4]));
        sqlOperation.AddParameterWithValue("@id", id);

        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[4] == "0")
        {
            string sqlCommand1 = "update splitway set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateMaterial(string id,string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE material set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update material set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateIrradiation(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE irradiation set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update irradiation set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateRaytype(string id, string value)
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE raytype set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update raytype set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateBodyposition(string id,string value)
    {
        string[] values = value.Split(' ');
        
        string sqlCommand = "UPDATE bodyposition set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault",int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if(values[1]=="0"){
            string sqlCommand1 = "update bodyposition set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }

    private void updateEnergy(string id, string value) 
    {
        string[] values = value.Split(' ');

        string sqlCommand = "UPDATE energy set Name=@Name,IsDefault=@IsDefault WHERE ID=@id";

        sqlOperation.clearParameter();
        sqlOperation.AddParameterWithValue("@Name", values[0]);
        sqlOperation.AddParameterWithValue("@IsDefault", int.Parse(values[1]));
        sqlOperation.AddParameterWithValue("@id", id);
        sqlOperation.ExecuteNonQuery(sqlCommand);

        if (values[1] == "0")
        {
            string sqlCommand1 = "update energy set IsDefault=1 where ID != @ID";
            sqlOperation.clearParameter();
            sqlOperation.AddParameterWithValue("@ID", id);
            sqlOperation.ExecuteNonQuery(sqlCommand1);
        }
    }
}