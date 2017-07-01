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
}