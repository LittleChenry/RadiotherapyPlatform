<%@ WebHandler Language="C#" Class="addUser" %>

using System;
using System.Web;

public class addUser : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        addToUser(context);
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

    public void addToUser(HttpContext context)
    {
        string userNumber = context.Request.Form["userNumber"];
        string userName = context.Request.Form["userName"];
        string gender = context.Request.Form["gender"];
        string userPassword = context.Request.Form["userPassword"];
        string phoneContact = context.Request.Form["phoneContact"];
        string office = context.Request.Form["office"];
        string role = context.Request.Form["roles"];
        string activate = context.Request.Form["activate"];

        string insertUserCommand = "INSERT INTO user (Number,Name,Gender,Contact,Office,Password,Activate)"+
                                    "VALUES (@Number,@Name,@Gender,@Contact,@Office,@Password,@Activate);SELECT @@IDENTITY";
        sqlOperation.AddParameterWithValue("@Number",userNumber);
        sqlOperation.AddParameterWithValue("@Name",userName);
        sqlOperation.AddParameterWithValue("@Gender",gender);
        sqlOperation.AddParameterWithValue("@Contact",phoneContact);
        sqlOperation.AddParameterWithValue("@Office",office);
        sqlOperation.AddParameterWithValue("@Password",userPassword);
        sqlOperation.AddParameterWithValue("@Activate",int.Parse(activate));

        string userID = sqlOperation.ExecuteScalar(insertUserCommand);

        string[] roles = role.Split(' ');
        for (int i = 0; i < roles.Length - 1;i++ )
        {
            //查询role的id
            string selectRoleIDCommand = "SELECT ID FROM role WHERE name=@name";
            sqlOperation.AddParameterWithValue("@name",roles[i]);
            string roleID = sqlOperation.ExecuteScalar(selectRoleIDCommand);
            //绑定role
            string insertRoleCommand = "INSERT INTO user2role (User_ID,Role_ID) VALUES (@User_ID,@Role_ID)";
            sqlOperation.AddParameterWithValue("@User_ID", int.Parse(userID));
            sqlOperation.AddParameterWithValue("@Role_ID",int.Parse(roleID));
            sqlOperation.ExecuteNonQuery(insertRoleCommand);
        }
        
    }

}