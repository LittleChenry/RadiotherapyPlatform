<%@ WebHandler Language="C#" Class="GetMainItems" %>

using System;
using System.Web;
using System.Text;

public class GetMainItems : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = allMainItem();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string allMainItem()
    {
        StringBuilder backString = new StringBuilder("[");
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT count(DISTINCT MainItem) FROM inspections";
        int count = int.Parse(sqlOperation.ExecuteScalar(sqlCommand));
        if (count == 0)
        {
            return "[{\"MainItem\":\"false\"}]";
        }
        sqlCommand = "SELECT DISTINCT MainItem FROM inspections";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        int n = 1;
        while (reader.Read())
        {
            backString.Append("{\"MainItem\":\"");
            backString.Append(reader["MainItem"].ToString());
            backString.Append("\"}");
            if (n < count)
            {
                backString.Append(",");
            }
            ++n;
        }
        backString.Append("]");
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        return backString.ToString();
    }
}