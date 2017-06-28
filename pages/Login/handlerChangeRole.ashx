<%@ WebHandler Language="C#" Class="handlerChangeRole" %>

using System;
using System.Web;
using System.Text;
using System.Web.SessionState;

public class handlerChangeRole : IHttpHandler, IRequiresSessionState
{
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string backString = getRoles(context);
        context.Response.Write(backString);
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private string getRoles(HttpContext context)
    {
        DataLayer sqlOperater = new DataLayer("sqlStr");
        UserInformation user = (UserInformation)context.Session["loginUser"];
        int id = user.GetUserID();
        string sqlCommand = "SELECT role.Name,role.Description FROM user LEFT JOIN user2role On "
                            + "user.ID=user2role.User_ID LEFT JOIN role ON user2role.Role_ID=role.ID "
                            + "WHERE user.ID=@userID";
        sqlOperater.AddParameterWithValue("@userID", id);
        MySql.Data.MySqlClient.MySqlDataReader reader = sqlOperater.ExecuteReader(sqlCommand);
        StringBuilder result = new StringBuilder("[");
        while (reader.Read())
        {
            result.Append("{\"Name\":\"")
                .Append(reader["Name"].ToString())
                .Append("\",\"Description\":\"")
                .Append(reader["Description"].ToString())
                .Append("\"},");    
        }
        result.Remove(result.Length - 1, 1);
        result.Append("]");
        reader.Close();
        sqlOperater.Close();
        sqlOperater.Dispose();
        sqlOperater = null;
        return result.ToString();
    }
}