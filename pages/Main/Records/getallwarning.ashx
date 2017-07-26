<%@ WebHandler Language="C#" Class="getallwarning" %>

using System;
using System.Web;
using System.Text;

public class getallwarning : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem();
        sqlOperation.Close();
        sqlOperation.Dispose();
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getprinItem()
    {
        string countItem = "SELECT count(*) FROM warning";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT WarningItem,WarningLightTime,WarningSeriousTime,Progress FROM warning";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"WarningItem\":\"" + reader["WarningItem"].ToString() + "\",\"light\":\"" + reader["WarningLightTime"].ToString() + "\",\"serious\":\"" + reader["WarningSeriousTime"].ToString() + "\",\"Progress\":\"" + reader["Progress"].ToString() + "\"}");
            if (i < count)
            {

                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        return backText.ToString();
    }

}