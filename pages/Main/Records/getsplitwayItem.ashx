<%@ WebHandler Language="C#" Class="getsplitwayItem" %>

using System;
using System.Web;
using System.Text;
public class getsplitwayItem : IHttpHandler {

    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getmodelItem();
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(backString);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    private string getmodelItem()
    {
        string countItem = "SELECT count(*) FROM splitway";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));
        string count1 = "SELECT count(*) FROM splitway where IsDefault=0";
        int count2 = int.Parse(sqlOperation.ExecuteScalar(count1));
        string defaut = "";
        if (count2 > 0)
        {
            string sqlCommand1 = "SELECT ID FROM splitway where IsDefault=0";
            defaut = sqlOperation.ExecuteScalar(sqlCommand1);
        }
        string sqlCommand = "SELECT * FROM splitway order by Orders";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Ways\":\"" + reader["Ways"].ToString() + "\",\"defaultItem\":\"" + defaut + "\"}");
            if (i < count)
            {

                backText.Append(",");
            }
            i++;
        }
        reader.Close();
        backText.Append("]}");
        return backText.ToString();
    }

}