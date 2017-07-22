<%@ WebHandler Language="C#" Class="getModel" %>

using System;
using System.Web;
using System.Text;

public class getModel : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(get(context));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string get(HttpContext context)
    {
        string cycle = context.Request.Form["cycle"];
        DataLayer sqlOperator = new DataLayer("sqlStr");
        string sqlCommand = "SELECT DISTINCT Inspections.TemplateID,EquipmentInspectionModel.Name,EquipmentInspectionModel.ID FROM Inspections RIGHT JOIN EquipmentInspectionModel ON Inspections.TemplateID=EquipmentInspectionModel.ID WHERE EquipmentInspectionModel.Cycle=@cycle ";
        sqlOperator.AddParameterWithValue("@cycle", cycle);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"id\":\"").Append(reader["ID"].ToString())
                  .Append("\",\"Name\":\"").Append(reader["Name"].ToString())
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