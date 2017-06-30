jidnfuwiwjr 。 <%@ WebHandler Language="C#" Class="getdoctor" %>

using System;
using System.Web;
using System.Text;
/* ***********************************************************
 * FileName:getdoctor.ashx
 * Writer: xubxiao
 * create Date: 2017-5-24
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 获取数据库中医生列表
 * **********************************************************/

public class getdoctor : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getdoctorItem();
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
    private string getdoctorItem()
    {


        string countItem = "SELECT count(*) FROM user,user2role where user.ID=user2role.User_ID and user2role.Role_ID=2";
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT user.ID as ID,Name FROM user,user2role where user.ID=user2role.User_ID and user2role.Role_ID=2";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"ID\":\"" + reader["ID"].ToString() + "\",\"Name\":\"" + reader["Name"].ToString() + "\"}");
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