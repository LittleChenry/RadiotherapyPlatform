<%@ WebHandler Language="C#" Class="getDnsity" %>

using System;
using System.Web;
using System.Text;

public class getDnsity : IHttpHandler {

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
        string countItem = "SELECT count(*) FROM densityconversion";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));
        string count1 = "SELECT count(*) FROM densityconversion where IsDefault=0";
        int count2 = int.Parse(sqlOperation.ExecuteScalar(count1));
        string defaut = "";
        if (count2 > 0)
        {
            string sqlCommand1 = "SELECT ID FROM densityconversion where IsDefault=0";
            defaut = sqlOperation.ExecuteScalar(sqlCommand1);
        }
        string sqlCommand = "SELECT ID,Name FROM densityconversion order by Orders";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\",\"defaultItem\":\"" + defaut+"\"}");
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