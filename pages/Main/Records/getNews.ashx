<%@ WebHandler Language="C#" Class="getNews" %>

using System;
using System.Web;
using System.Text;
public class getNews : IHttpHandler {
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);
            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2=null;         
            context.Response.Write(json);
        }
        catch (Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getfixrecordinfo(HttpContext context)
    {           
        int count = 5;
        int i = 1;
        string sqlCommand1 = "select news.*,user.Name as username from news,user where user.ID=news.Release_User_ID order by Important desc,Releasetime desc limit 0,5";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"patientInfo\":[");
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Release_User_ID\":\"" + reader["Release_User_ID"].ToString() + "\",\"Title\":\"" + reader["Title"] + "\",\"Important\":\"" + reader["Important"] +
                 "\",\"Permission\":\"" + reader["Permission"].ToString() + "\",\"Releasetime\":\"" + reader["Permission"].ToString() + "\",\"Release_UserName\":\"" + reader["username"].ToString() + "\"}");
            if (i < count)
            {
                backText.Append(",");
            }
            i++;
        }
        backText.Append("]}");
        reader.Close();
        return backText.ToString();
    }
}