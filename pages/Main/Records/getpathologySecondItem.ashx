<%@ WebHandler Language="C#" Class="getpathologySecondItem" %>
using System;
using System.Web;
using System.Text;

public class getpathologySecondItem : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getprinItem(context);
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
    private string getprinItem(HttpContext context)
    {
        string text = context.Request["text"];
        string countItem = "SELECT count(DISTINCT(Groupfirst)) FROM morphol where Groupsecond=@text";
        sqlOperation.AddParameterWithValue("@text", text);
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT DISTINCT(Groupfirst) as group2 FROM morphol where Groupsecond=@text ";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + i + "\",\"Name\":\"" + reader["group2"].ToString() + "\"}");
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