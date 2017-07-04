<%@ WebHandler Language="C#" Class="getrequire" %>
using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getrequire.ashx
 * Writer: xubxiao
 * create Date: 2017-5-16
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取数据库中复位要求参考表数据
 * **********************************************************/

public class getrequire : IHttpHandler {

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
        string countItem = "SELECT count(*) FROM replacementrequirements";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT ID,Requirements FROM replacementrequirements";
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