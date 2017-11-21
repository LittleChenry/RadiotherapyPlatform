<%@ WebHandler Language="C#" Class="editUser" %>

using System;
using System.Web;

public class editUser : IHttpHandler {
    DataLayer sqlOperation = new DataLayer("sqlStr");
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        updateUser(context);
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
    public void updateUser(HttpContext context)
    {
        string numberEdit = context.Request.Form["numberEdit"];
        string nameEdit = context.Request.Form["nameEdit"];
        string genderEdit = context.Request.Form["genderEdit"];
        string phoneEdit = context.Request.Form["phoneEdit"];
        string officeEdit = context.Request.Form["officeEdit"];
        string activateEdit = context.Request.Form["activateEdit"];
        string pwd = context.Request.Form["pwd"];
        string beforeNumber = context.Request.Form["beforeNumber"];

        string updateUserCommand = "UPDATE user SET Number=@Number,Name=@Name,Gender=@Gender,Contact=@Contact,Password=@pwd,Office=@Office,Activate=@Activate WHERE Number=@BeforeNumber";
        sqlOperation.AddParameterWithValue("@Name",nameEdit);
        sqlOperation.AddParameterWithValue("@Gender",genderEdit);
        sqlOperation.AddParameterWithValue("@Contact",phoneEdit);
        sqlOperation.AddParameterWithValue("@Office",officeEdit);
        sqlOperation.AddParameterWithValue("@pwd", pwd);
        sqlOperation.AddParameterWithValue("@Activate",int.Parse(activateEdit));
        sqlOperation.AddParameterWithValue("@Number",numberEdit);
        sqlOperation.AddParameterWithValue("@BeforeNumber", beforeNumber);
        sqlOperation.ExecuteNonQuery(updateUserCommand);
    }
}