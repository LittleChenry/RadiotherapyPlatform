<%@ WebHandler Language="C#" Class="deleteUser" %>

using System;
using System.Web;

public class deleteUser : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        delete(context);
        sqlOperation.Close();
        sqlOperation.Dispose();
        sqlOperation = null;
        context.Response.Write(" ");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

    public void delete(HttpContext context)
    { 
        string editNumber = context.Request.Form["numberEdit"];
        //查找id
        string selectUserIDCommand = "SELECT ID FROM USER WHERE Number=@Number";
        sqlOperation.AddParameterWithValue("@Number",editNumber);
        string userID = sqlOperation.ExecuteScalar(selectUserIDCommand);
        //删除user
        string deleteUserCommand = "DELETE FROM user WHERE Number=@Number";
        sqlOperation.AddParameterWithValue("@Number", editNumber);
        sqlOperation.ExecuteNonQuery(deleteUserCommand);
        //删除role
        string deleteRoleCommand = "DELETE FROM user2role WHERE User_ID=@User_ID";
        sqlOperation.AddParameterWithValue("@User_ID",int.Parse(userID));
        sqlOperation.ExecuteNonQuery(deleteRoleCommand);
    } 
}