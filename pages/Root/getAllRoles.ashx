<%@ WebHandler Language="C#" Class="getAllRoles" %>

using System;
using System.Web;
using System.Text;

public class getAllRoles : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write(getRole());
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getRole()
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string sqlCommand = "SELECT `user`.Number, `user`.Name, `user`.Office, `user`.Activate,role.Description From user LEFT JOIN user2role ON `user`.ID=user2role.User_ID LEFT JOIN role ON user2role.Role_ID=role.ID";
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperation.ExecuteReader(sqlCommand);
        string now = "";
        int flag = 0;
        StringBuilder sb = new StringBuilder("[");
        while (reader.Read())
        {
            if (reader["Number"].ToString().Equals(now))
            {
                sb.Append(" ").Append(reader["Description"].ToString());
            }
            else
            {
                now = reader["Number"].ToString();
                if (flag == 0)
                {
                    sb.Append("{\"number\":\"").Append(reader["Number"].ToString()).Append("\",\"Name\":\"").Append(reader["Name"].ToString())
                        .Append("\",\"Office\":\"").Append(reader["Office"].ToString()).Append("\",\"Activate\":\"").Append(reader["Activate"].ToString().Equals("1") ? "激活":"未激活")
                 .Append("\",\"description\":\"").Append(reader["Description"].ToString());
                    flag++;
                }
                else
                {
                    sb.Append("\"},").Append("{\"number\":\"").Append(reader["Number"].ToString()).Append("\",\"Name\":\"").Append(reader["Name"].ToString())
                      .Append("\",\"Office\":\"").Append(reader["Office"].ToString()).Append("\",\"Activate\":\"").Append(reader["Activate"].ToString().Equals("1") ? "激活" : "未激活")
                      .Append("\",\"description\":\"").Append(reader["Description"].ToString());
                }
            }
        }
        sb.Append("\"}").Append("]");
        return sb.ToString();
    }

}