<%@ WebHandler Language="C#" Class="getParameterTable" %>

using System;
using System.Web;
using System.Text;

public class getParameterTable : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = choose(context);
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string choose(HttpContext context)
    {
        string type = context.Request.Form["table"];
        switch (type)
        {
            case "part":
                return selectPart();
            case "DiagnosisResult":
                return selectDiagnosisResult();
            case "FixedEquipment":
                return selectFixedEquipment();
            case "FixedRequirements":
                return selectFixedRequirements();
            case "ScanPart":
                return selectScanPart();
            case "ScanMethod":
                return selectScanMethod();
            case "EnhanceMethod":
                return selectEnhanceMethod();
            case "LocationRequirements":
                return selectLocationRequirements();
            case "DensityConversion":
                return selectDensityConversion();
            case "EndangeredOrgan":
                return selectEndangeredOrgan();
            case "Technology":
                return selectTechnology();
            case "PlanSystem":
                return selectPlanSystem();
            case "Grid":
                return selectGrid();
            case "Algorithm":
                return selectAlgorithm();
            case "ReplacementRequirements":
                return selectReplacementRequirements();
            case "lightpart":
                return selectLightPart();
            case "treataim":
                return selectTreatAim();
            case "headrest":
                return selectHeadRest();
            case "pendulumfieldinfo":
                return selectPendulumFieldInfo();
            case "planoptimizedegree":
                return selectPlanOptimizeDegree();
            case "drr":
                return selectDrr();
            case "exportotradiotherapynetwork":
                return selectExportoTradiotherapyNetwork();
            case "splitway":
                return selectSpiltWay();
            case "material":
                return selectMaterial();
        }
        return "";
    }

    private string selectPart()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM part";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"code\":\"")
                      .Append(reader["Code"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\",\"Description\":\"")
                      .Append(reader["Description"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectDiagnosisResult()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM DiagnosisResult";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"code\":\"")
                      .Append(reader["Code"].ToString())
                      .Append("\",\"TumorName\":\"")
                      .Append(reader["TumorName"].ToString())
                      .Append("\",\"Description\":\"")
                      .Append(reader["Description"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectFixedEquipment()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM FixedEquipment";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectFixedRequirements()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM FixedRequirements";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Requirements\":\"")
                      .Append(reader["Requirements"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectScanPart()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM ScanPart";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectScanMethod()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM ScanMethod";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Method\":\"")
                      .Append(reader["Method"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectEnhanceMethod()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM EnhanceMethod";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Method\":\"")
                      .Append(reader["Method"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectLocationRequirements()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM LocationRequirements";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Requirements\":\"")
                      .Append(reader["Requirements"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectDensityConversion()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM DensityConversion";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectEndangeredOrgan()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM EndangeredOrgan";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectTechnology()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM Technology";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectPlanSystem()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM PlanSystem";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectGrid()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM Grid";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectAlgorithm()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM Algorithm";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectReplacementRequirements()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM ReplacementRequirements";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);

        while (reader.Read())
        {
            backString.Append("{\"id\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Requirements\":\"")
                      .Append(reader["Requirements"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectLightPart()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM lightpart";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString(); 
    }

    private string selectTreatAim()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM treataim";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Aim\":\"")
                      .Append(reader["Aim"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectHeadRest() 
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM headrest";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectPendulumFieldInfo()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM pendulumfieldinfo";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }
    private string selectPlanOptimizeDegree() 
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM planoptimizedegree";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }
    private string selectDrr()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM drr";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectExportoTradiotherapyNetwork()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM exportotradiotherapynetwork";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectSpiltWay()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM splitway";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Ways\":\"")
                      .Append(reader["Ways"].ToString())
                      .Append("\",\"Interal\":\"")
                      .Append(reader["Interal"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }

    private string selectMaterial()
    {
        StringBuilder backString = new StringBuilder("[");
        string sqlCommand = "SELECT * FROM material";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"")
                      .Append(reader["ID"].ToString())
                      .Append("\",\"Name\":\"")
                      .Append(reader["Name"].ToString())
                      .Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1)
                  .Append("]");
        return backString.ToString();
    }
}