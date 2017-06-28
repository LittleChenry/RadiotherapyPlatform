<%@ WebHandler Language="C#" Class="getTreamentItem" %>

using System;
using System.Web;
using System.Text;

public class getTreamentItem : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getCurrentItem();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getCurrentItem()
    {
        string sqlCommand = "SELECT DISTINCT TreatmentItem FROM Equipment";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backString = new StringBuilder();
        while (reader.Read())
        {
            backString.Append(reader["TreatmentItem"].ToString() + " ");
        }
        return backString.ToString();
    }
}