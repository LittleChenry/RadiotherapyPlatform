<%@ WebHandler Language="C#" Class="Notice" %>

using System;
using System.Web;
using System.Text;

public class Notice : IHttpHandler {
    private DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        try
        {
            string json = getTitle(context);
            sqlOperation.Close();
            sqlOperation.Dispose();
            context.Response.Write(json);
        }
        catch(Exception ex)
        {
            MessageBox.Message(ex.Message);
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getTitle(HttpContext context)
    {
        string type = "%" + context.Request.QueryString["Type"] + "%";
        string sqlCommand = "SELECT ID,Title,Releasetime,Important FROM news WHERE Permission like(@type) order by Important desc, Releasetime desc";
        string countNotice = "SELECT count(ID) FROM news WHERE Permission like(@type)";
        sqlOperation.AddParameterWithValue("@type", type);
        int count = int.Parse(sqlOperation.ExecuteScalar(countNotice));
        if (count == 0)
        {
            return "{\"Notice\":[{\"Title\":\"false\"}]";
        }
        int i = 1;
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Notice\":[");
        while (reader.Read())
        {
            DateTime date = Convert.ToDateTime(reader["Releasetime"].ToString());
            string day = date.Year.ToString() + "-" + date.Month.ToString() + "-" + date.Day.ToString();
            /*backText += "\"Title\":\"" + reader["Title"].ToString() + "\",\"Time\":\"" + reader["Releasetime"].ToString()
                + "\",\"ID\":\"" + reader["ID"].ToString() + "\"}";*/
            backText.Append("{\"Title\":\"" + reader["Title"].ToString() + "\",\"Time\":\"" + day
                + "\",\"ID\":\"" + reader["ID"].ToString() + "\",\"Important\":\"" + reader["Important"].ToString() + "\"}");
            if (i < count)
            {
                //backText += ",";
                backText.Append(",");
            }
            i++;
        }
        //backText += "]}";
        backText.Append("]}");
        return backText.ToString();
    }

    #region 
    /*
    private string getNotice(HttpContext context)
    {
        string type = "%" + context.Request.QueryString["Type"] + "%";
        string sqlCommand = "SELECT * FROM news,user WHERE news.Release_User_ID=user.ID AND news.Permission like(@type) order by Important desc, Releasetime desc";
        sqlOperation.AddParameterWithValue("@type", type);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        string json = "{\"Notice\":[";
        int i = 1;
        while (reader.Read())
        {
            json += "{\"Title\":\"" + reader["Title"].ToString() + "\",\"Content\":\"" + reader["Content"].ToString()
                + "\",\"Release\":\"" + reader["Name"].ToString() + "\",\"Time\":\"" + reader["Releasetime"].ToString()
                + "\"}";        
                json += ",";
        }
        sqlOperation.Close();
        return json;
    }*/
    #endregion
}