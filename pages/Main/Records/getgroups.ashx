<%@ WebHandler Language="C#" Class="getgroups" %>

using System;
using System.Web;
using System.Text;

public class getgroups : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string backString = getspecialItem(context);
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
    private string getspecialItem(HttpContext context)
    {
        string user = context.Request["user"];
        string countItem = "SELECT count(distinct(groups.ID)) FROM groups2user,groups where groups2user.User_ID=@user and groups2user.Group_ID=groups.ID";
        sqlOperation.AddParameterWithValue("@user", Convert.ToInt32(user));
        int count = int.Parse(sqlOperation.ExecuteScalar(countItem));

        string sqlCommand = "SELECT distinct(groups.ID) as groupid,groups.groupName as groupname FROM groups2user,groups where groups2user.User_ID=@user and groups2user.Group_ID=groups.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        StringBuilder backText = new StringBuilder("{\"Item\":[");
        int i = 1;
        while (reader.Read())
        {
            backText.Append("{\"groupid\":\"" + reader["groupid"].ToString() + "\",\"groupname\":\"" + reader["groupname"].ToString() + "\"}");
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