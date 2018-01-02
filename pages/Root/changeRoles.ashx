<%@ WebHandler Language="C#" Class="changeRoles" %>

using System;
using System.Web;

public class changeRoles : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        change(context);
        context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    private void change(HttpContext context)
    {
        DataLayer sqlOperation = new DataLayer("sqlStr");
        string number = context.Request.Form["number"];
        string newroles = context.Request.Form["role"];
        string[] roles = newroles.Split(' ');
        string sqlCommand = "DELETE FROM user2role WHERE User_ID=(SELECT ID FROM user WHERE user.Number=@number)";
        sqlOperation.AddParameterWithValue("@number", number);
        sqlOperation.ExecuteNonQuery(sqlCommand);
        string userID = sqlOperation.ExecuteScalar("SELECT ID FROM user WHERE user.Number=@number");
        sqlOperation.AddParameterWithValue("@userID", userID);
        for (int i = 0; i < roles.Length; i++)
        {
            if (roles[i] != "")
            {
                sqlCommand = "SELECT ID FROM role WHERE Name=@name";
                sqlOperation.AddParameterWithValue("@name", roles[i]);
                string roleID = sqlOperation.ExecuteScalar(sqlCommand);
                sqlCommand = "INSERT INTO user2role(User_ID,Role_ID) VALUES(@userID,@roleID)";
                sqlOperation.AddParameterWithValue("@roleID", roleID);
                sqlOperation.ExecuteNonQuery(sqlCommand);
            }
        }
    }
}