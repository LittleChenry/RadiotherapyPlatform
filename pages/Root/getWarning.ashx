<%@ WebHandler Language="C#" Class="getWarning" %>

using System;
using System.Web;
using System.Text;

public class getWarning : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getWarningTable());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public string getWarningTable()
    {
        string getWarningCommand = "SELECT * FROM warning";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(getWarningCommand);
        StringBuilder backString = new StringBuilder("[");
        while(reader.Read()){
            backString.Append("{\"ID\":\"");
            backString.Append(reader["ID"].ToString());
            backString.Append("\",\"WarningItem\":\"");
            backString.Append(reader["WarningItem"].ToString());
            backString.Append("\",\"WarningLightTime\":\"");
            backString.Append(reader["WarningLightTime"].ToString());
            backString.Append("\",\"WarningSeriousTime\":\"");
            backString.Append(reader["WarningSeriousTime"].ToString());
            backString.Append("\"},");
        }
        backString.Remove(backString.Length - 1, 1);
        backString.Append("]");
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        return backString.ToString();
    }

}