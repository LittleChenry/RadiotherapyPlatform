<%@ WebHandler Language="C#" Class="GetEquipment" %>

using System;
using System.Web;
using System.Text;

public class GetEquipment : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = equipmentInformation();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string equipmentInformation()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT COUNT(ID) FROM equipment";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "[{\"ID\":\"null\"}]";
        }
        sqlCommand = "SELECT ID,Name FROM equipment";
        StringBuilder backString = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        int n = 1;
        while (reader.Read())
        {
            backString.Append("{\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"Name\":\"");
            backString.Append(reader["Name"].ToString());
            backString.Append("\"}");
            if (n < count)
            {
                backString.Append(",");
            }
            ++n;
        }
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }
}