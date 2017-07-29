<%@ WebHandler Language="C#" Class="getResultSecondItem" %>
using System;
using System.Web;
using System.Text;
public class getResultSecondItem : IHttpHandler {

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
        string text = context.Request.QueryString["text"];

        string countItem = "SELECT count(DISTINCT(Group2)) FROM icdcode where Group1=@text";
        sqlOperation.AddParameterWithValue("@text", text);
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT DISTINCT(Group2) as group2 FROM icdcode where Group1=@text";
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