<%@ WebHandler Language="C#" Class="GetUserInformation" %>

using System;
using System.Web;
using System.Text;

public class GetUserInformation : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getInformation();
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getInformation()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT `user`.ID uid,`user`.Name FROM `user` LEFT JOIN user2role ON `user`.ID=user2role.User_ID WHERE user2role.Role_ID=2 AND `user`.Activate=1 ORDER BY `user`.Name";
        StringBuilder backString = new StringBuilder("[");
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        if (!reader.Read())
            return "[{\"ID\":\"null\"}]";
        while (true)
        {
            backString.Append("{\"ID\":\"").Append(reader["uid"].ToString()).Append("\",\"Name\":\"").Append(reader["Name"].ToString())
                .Append("\"}");
            if (reader.Read())
            {
                backString.Append(",");
            }
            else
            {
                break;
            }
        }
        reader.Close();
        sqlOperation.Close();
        sqlOperation.Dispose();
        backString.Append("]");
        return backString.ToString();
    }
}