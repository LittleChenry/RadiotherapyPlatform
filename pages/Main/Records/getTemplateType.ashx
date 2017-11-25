<%@ WebHandler Language="C#" Class="getTemplateType" %>

using System;
using System.Web;
using System.Text;
public class getTemplateType : IHttpHandler {
    private DataLayer sqlOperation2 = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getfixrecordinfo(context);

            sqlOperation2.Close();
            sqlOperation2.Dispose();
            sqlOperation2 = null;
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
        int userid = Convert.ToInt32(context.Request.QueryString["userID"]);
        int type = Convert.ToInt32(context.Request.QueryString["type"]);
        int i = 1;
        string Count = "select count(*) from doctortemplate where (user_ID=@userID or user_ID=0) and Type=@type";
        sqlOperation2.AddParameterWithValue("@userID", userid);
        sqlOperation2.AddParameterWithValue("@type", type);
        int count = int.Parse(sqlOperation2.ExecuteScalar(Count));
        string sqlCommand1 = "select ID,Name,TemplateID,User_ID from doctortemplate where (user_ID=@userID or user_ID=0) and Type=@type order by user_ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation2.ExecuteReader(sqlCommand1);
        StringBuilder backText = new StringBuilder("{\"templateInfo\":[");
        while (reader.Read())
        {

            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"] + "\",\"TemplateID\":\"" + reader["TemplateID"] + "\",\"Ispublic\":\"" + reader["User_ID"] + "\"}");
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