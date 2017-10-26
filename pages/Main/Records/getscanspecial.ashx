<%@ WebHandler Language="C#" Class="getscanspecial" %>
using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getscanspecial.ashx
 * Writer: xubxiao
 * create Date: 2017-5-4
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取数据库中扫描特殊要求参考表数据
 * **********************************************************/
public class getscanspecial : IHttpHandler {
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
        string countItem = "SELECT count(*) FROM LocationRequirements";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT ID,Requirements FROM LocationRequirements order by Orders";
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
        reader.Close();
        backText.Append("],\"defaultItem\":");
        string defaultpart = "SELECT ID,Requirements FROM LocationRequirements where IsDefault=0";
        MySql.Data.MySqlClient.MySqlDataReader reader1 = sqlOperation.ExecuteReader(defaultpart);
        if (reader1.Read())
        {
            backText.Append("{\"ID\":\"" + reader1["ID"].ToString() + "\",\"Requirements\":\"" + reader1["Requirements"].ToString() + "\"}");

        }
        else
        {
            backText.Append("\"\"");
        }
        backText.Append("}");
        return backText.ToString();
    }
}