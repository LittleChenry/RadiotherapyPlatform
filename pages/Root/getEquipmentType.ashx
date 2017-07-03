<%@ WebHandler Language="C#" Class="getEquipmentType" %>

using System;
using System.Web;
using System.Text;

public class getEquipmentType : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string result = getType();
        context.Response.Write(result);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getType()
    {
        DataLayer sqlOperator = new DataLayer("sqlStr");

        string sqlCommand = "SELECT * FROM equipmenttype";

        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperator.ExecuteReader(sqlCommand);

        StringBuilder result = new StringBuilder("[");

        while (reader.Read())
        {
            result.Append("{\"id\":\"")
                  .Append(reader["ID"].ToString())
                  .Append("\",\"type\":\"")
                  .Append(reader["Type"].ToString())
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