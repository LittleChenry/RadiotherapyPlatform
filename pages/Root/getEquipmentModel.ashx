<%@ WebHandler Language="C#" Class="getEquipmentModel" %>

using System;
using System.Web;
using System.Text;

public class getEquipmentModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getModel(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getModel(HttpContext context)
    {
        string cycle = context.Request.Form["cycle"];
        string model = context.Request.Form["model"];

        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT ID,MainItem,ChildItem,inspections.Explain,Reference,Cycle,TemplateID,files FROM inspections WHERE Cycle=@cycle AND TemplateID=@model ORDER BY MainItem";
        sqlOperator.AddParameterWithValue("@cycle", cycle);
        sqlOperator.AddParameterWithValue("@model", model);
        MySql.Data.MySqlClient.MySqlDataReader reader = null ;
        reader = sqlOperator.ExecuteReader(sqlCommand);


        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"id\":\"").Append(reader["ID"].ToString())
                .Append("\",\"mainItem\":\"").Append(reader["MainItem"].ToString())
                .Append("\",\"childItem\":\"").Append(reader["ChildItem"].ToString())
                .Append("\",\"explain\":\"").Append(reader["Explain"].ToString().Replace("\r\n",""))
                .Append("\",\"reference\":\"").Append(reader["Reference"].ToString())
                .Append("\",\"files\":\"").Append(reader["files"].ToString())
                .Append("\"},");
        }
        result.Remove(result.Length - 1, 1).Append("]");
        reader.Close();
        sqlOperator.Close();
        sqlOperator.Dispose();
        sqlOperator = null;
        return result.ToString();
    }
}