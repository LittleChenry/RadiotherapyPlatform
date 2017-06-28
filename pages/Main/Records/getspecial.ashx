<%@ WebHandler Language="C#" Class="getspecial" %>

using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getspecial.ashx
 * Writer: xubxiao
 * create Date: 2017-5-5
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取特殊要求选项
 * **********************************************************/

public class getspecial : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getspecialItem();
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
    private string getspecialItem()
    {
        string countItem = "SELECT count(*) FROM fixedrequirements";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT * FROM fixedrequirements";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Requirements\":\"" + reader["Requirements"].ToString() + "\"}");
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