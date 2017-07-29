<%@ WebHandler Language="C#" Class="getResultThirdItem" %>

using System;
using System.Web;
using System.Text;

public class getResultThirdItem : IHttpHandler {
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
        string text1 = context.Request.QueryString["text1"];
        string text2 = context.Request.QueryString["text2"];
        string countItem = "SELECT count(DISTINCT(Chinese)) FROM icdcode where Group1=@text1 and Group2=@text2 ";
        sqlOperation.AddParameterWithValue("@text1", text1);
        sqlOperation.AddParameterWithValue("@text2", text2);
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT DISTINCT(Chinese) as group3 FROM icdcode where Group1=@text1 and Group2=@text2 ";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["group3"].ToString() + "\",\"Name\":\"" + reader["group3"].ToString() + "\"}");
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